from datetime import datetime, timedelta, timezone
from app.models import Photo, Generation
from app.services.cleanup import run_24h_cleanup

def test_24h_cleanup_purges_expired_only(db_session):
    now = datetime.now(timezone.utc)

    # 1. Active photo (expires in 24h)
    active_photo = Photo(
        session_id="anon",
        storage_path="photos/active/original.jpg",
        sha256="hash_active",
        expires_at=now + timedelta(hours=24),
    )

    # 2. Expired photo (expired 2 hours ago)
    expired_photo = Photo(
        session_id="anon",
        storage_path="photos/expired/original.jpg",
        sha256="hash_expired",
        expires_at=now - timedelta(hours=2),
    )

    db_session.add(active_photo)
    db_session.add(expired_photo)
    db_session.commit()

    # Run cleanup
    purged_count = run_24h_cleanup(db_session)
    assert purged_count == 1

    # Verify active photo remains, expired is deleted
    remaining_ids = [p.id for p in db_session.query(Photo).all()]
    assert active_photo.id in remaining_ids
    assert expired_photo.id not in remaining_ids

