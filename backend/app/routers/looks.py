import uuid
from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime
from sqlalchemy.orm import Session
from ..db import get_db
from ..models import Look, Generation

router = APIRouter(prefix="/v1/looks", tags=["Looks"])

class LookSaveRequest(BaseModel):
    generation_id: str
    title: Optional[str] = "My Style Look"

class LookResponse(BaseModel):
    id: str
    generation_id: str
    title: str
    share_id: str
    result_url: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True

@router.post("", response_model=LookResponse)
def save_look(
    req: LookSaveRequest,
    db: Session = Depends(get_db),
):
    gen = db.query(Generation).filter(Generation.id == req.generation_id).first()
    if not gen:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "GENERATION_NOT_FOUND", "message": "Generation result not found"}},
        )

    new_look = Look(
        generation_id=req.generation_id,
        title=req.title or "My Style Look",
        share_id=uuid.uuid4().hex[:10],
    )
    db.add(new_look)
    db.commit()
    db.refresh(new_look)

    return LookResponse(
        id=new_look.id,
        generation_id=new_look.generation_id,
        title=new_look.title,
        share_id=new_look.share_id,
        result_url=gen.result_path,
        created_at=new_look.created_at,
    )

@router.get("", response_model=List[LookResponse])
def list_saved_looks(
    db: Session = Depends(get_db),
):
    looks = db.query(Look).order_by(Look.created_at.desc()).all()
    results = []
    for l in looks:
        results.append(LookResponse(
            id=l.id,
            generation_id=l.generation_id,
            title=l.title,
            share_id=l.share_id,
            result_url=l.generation.result_path if l.generation else None,
            created_at=l.created_at,
        ))
    return results

@router.delete("/{look_id}")
def delete_saved_look(
    look_id: str,
    db: Session = Depends(get_db),
):
    look = db.query(Look).filter(Look.id == look_id).first()
    if not look:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "LOOK_NOT_FOUND", "message": "Saved look not found"}},
        )
    db.delete(look)
    db.commit()
    return {"ok": True, "message": "Saved look removed"}

