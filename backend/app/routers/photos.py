import hashlib
import json
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from sqlalchemy.orm import Session
from ..db import get_db
from ..models import Photo
from ..schemas import PhotoUploadResponse
from ..services.face_check import validate_face_image
from ..services.storage import save_original_photo, delete_photo_storage

router = APIRouter(prefix="/v1/photos", tags=["Photos"])

MAX_BYTES = 8 * 1024 * 1024  # 8 MB

@router.post("", response_model=PhotoUploadResponse)
async def upload_photo(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
):
    contents = await file.read()
    if len(contents) > MAX_BYTES:
        return PhotoUploadResponse(
            photo_id="",
            ok=False,
            issues=["FILE_TOO_LARGE"],
        )

    # Validate face quality
    ok, issues, meta = validate_face_image(contents)
    if not ok:
        return PhotoUploadResponse(
            photo_id="",
            ok=False,
            issues=issues,
        )

    # Compute SHA256
    sha256 = hashlib.sha256(contents).hexdigest()

    # Create photo record
    new_photo = Photo(
        session_id="anon",
        storage_path="",  # will update after saving
        sha256=sha256,
        face_meta=json.dumps(meta),
    )
    db.add(new_photo)
    db.flush()

    # Save to local storage
    saved_path = save_original_photo(new_photo.id, contents)
    new_photo.storage_path = saved_path
    db.commit()
    db.refresh(new_photo)

    return PhotoUploadResponse(
        photo_id=new_photo.id,
        ok=True,
        issues=[],
        expires_in=86400,
    )

@router.delete("/{photo_id}")
def delete_photo(
    photo_id: str,
    db: Session = Depends(get_db),
):
    photo = db.query(Photo).filter(Photo.id == photo_id).first()
    if not photo:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "PHOTO_NOT_FOUND", "message": "Photo does not exist"}},
        )

    # Delete storage files immediately
    delete_photo_storage(photo_id)

    # Delete DB record (cascades to generations)
    db.delete(photo)
    db.commit()

    return {"ok": True, "message": "Photo and all associated generations permanently deleted."}
