import time
from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks, status
from sqlalchemy.orm import Session
from ..db import get_db, SessionLocal
from ..models import Photo, Style, Generation
from ..schemas import GenerationCreateRequest, GenerationResponse
from ..prompts import build_prompt
from ..ai.mock import MockImageProvider
from ..services.storage import (
    get_file_bytes,
    save_generation_output,
    generate_signed_token,
)

router = APIRouter(prefix="/v1/generations", tags=["Generations"])
mock_provider = MockImageProvider()

def process_generation_job(generation_id: str, db_session_factory):
    db: Session = db_session_factory()
    try:
        job = db.query(Generation).filter(Generation.id == generation_id).first()
        if not job or job.status == "done":
            return

        job.status = "running"
        db.commit()

        photo = db.query(Photo).filter(Photo.id == job.photo_id).first()
        if not photo:
            job.status = "failed"
            job.error = "Photo not found"
            db.commit()
            return

        # Fetch styles
        hair = db.query(Style).filter(Style.id == job.hair_style_id).first() if job.hair_style_id else None
        beard = db.query(Style).filter(Style.id == job.beard_style_id).first() if job.beard_style_id else None

        prompt = build_prompt(
            hair_name=hair.name if hair else None,
            hair_hint=hair.prompt_hint if hair else None,
            beard_name=beard.name if beard else None,
            beard_hint=beard.prompt_hint if beard else None,
            view=job.view,
        )

        user_bytes = get_file_bytes(photo.storage_path) or b""
        start_t = time.time()
        styled_bytes = mock_provider.edit_sync(user_bytes, prompt)
        latency = int((time.time() - start_t) * 1000)

        # Save output
        out_rel_path = save_generation_output(photo.id, job.id, styled_bytes)
        token = generate_signed_token(out_rel_path)

        job.status = "done"
        job.result_path = f"/v1/files/{out_rel_path}?token={token}"
        job.identity_score = 0.94
        job.latency_ms = latency
        job.provider = "mock"
        db.commit()
    except Exception as e:
        if job:
            job.status = "failed"
            job.error = str(e)
            db.commit()
    finally:
        db.close()

@router.post("", response_model=GenerationResponse)
async def create_generation(
    req: GenerationCreateRequest,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
):
    if not req.hair_style_id and not req.beard_style_id:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": {"code": "STYLE_REQUIRED", "message": "At least one hair or beard style is required"}},
        )

    photo = db.query(Photo).filter(Photo.id == req.photo_id).first()
    if not photo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "PHOTO_NOT_FOUND", "message": "Photo not found or expired"}},
        )

    # Cache check
    existing = (
        db.query(Generation)
        .filter(
            Generation.photo_id == req.photo_id,
            Generation.hair_style_id == req.hair_style_id,
            Generation.beard_style_id == req.beard_style_id,
            Generation.view == req.view,
            Generation.status == "done",
        )
        .first()
    )

    if existing:
        return GenerationResponse(
            id=existing.id,
            photo_id=existing.photo_id,
            hair_style_id=existing.hair_style_id,
            beard_style_id=existing.beard_style_id,
            view=existing.view,
            status=existing.status,
            result_url=existing.result_path,
            identity_score=existing.identity_score,
            latency_ms=existing.latency_ms,
        )

    # Create new generation record
    new_job = Generation(
        photo_id=req.photo_id,
        hair_style_id=req.hair_style_id,
        beard_style_id=req.beard_style_id,
        view=req.view,
        status="queued",
    )
    db.add(new_job)
    db.commit()
    db.refresh(new_job)

    # Launch background generation
    background_tasks.add_task(process_generation_job, new_job.id, SessionLocal)

    return GenerationResponse(
        id=new_job.id,
        photo_id=new_job.photo_id,
        hair_style_id=new_job.hair_style_id,
        beard_style_id=new_job.beard_style_id,
        view=new_job.view,
        status=new_job.status,
    )

@router.get("/{job_id}", response_model=GenerationResponse)
def get_generation_status(
    job_id: str,
    db: Session = Depends(get_db),
):
    job = db.query(Generation).filter(Generation.id == job_id).first()
    if not job:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "JOB_NOT_FOUND", "message": "Generation job not found"}},
        )

    return GenerationResponse(
        id=job.id,
        photo_id=job.photo_id,
        hair_style_id=job.hair_style_id,
        beard_style_id=job.beard_style_id,
        view=job.view,
        status=job.status,
        result_url=job.result_path,
        identity_score=job.identity_score,
        latency_ms=job.latency_ms,
        error=job.error,
    )
