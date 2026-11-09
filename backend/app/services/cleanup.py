import logging
from datetime import datetime, timezone
from sqlalchemy.orm import Session
from ..models import Photo
from ..services.storage import delete_photo_storage

logger = logging.getLogger("stylemirror.cleanup")

def run_24h_cleanup(db: Session) -> int:
    """Purges expired photos and all associated generated files"""
    now = datetime.now(timezone.utc)
    expired_photos = db.query(Photo).filter(Photo.expires_at < now).all()
    count = 0

    for photo in expired_photos:
        try:
            delete_photo_storage(photo.id)
            db.delete(photo)
            count += 1
        except Exception as e:
            logger.error(f"Error purging expired photo {photo.id}: {e}")

    if count > 0:
        db.commit()
        logger.info(f"Cleanup purged {count} expired photos and their outputs.")

    return count
