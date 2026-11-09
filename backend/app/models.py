import uuid
from datetime import datetime, timedelta, timezone
from sqlalchemy import (
    Column,
    String,
    Boolean,
    Integer,
    Float,
    DateTime,
    ForeignKey,
    Index,
    Text,
)
from sqlalchemy.orm import relationship
from .db import Base

def gen_uuid():
    return str(uuid.uuid4())

class Style(Base):
    __tablename__ = "styles"

    id = Column(String(10), primary_key=True)  # e.g. 'H01', 'B12'
    type = Column(String(10), nullable=False)  # 'hair' or 'beard'
    name = Column(String(100), nullable=False)
    prompt_hint = Column(Text, nullable=False)
    thumb_url = Column(String(255), nullable=False)
    ref_front_url = Column(String(255), nullable=True)
    ref_side_url = Column(String(255), nullable=True)
    ref_back_url = Column(String(255), nullable=True)
    category = Column(String(50), default="Classic")
    sort_order = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)

class Photo(Base):
    __tablename__ = "photos"

    id = Column(String(36), primary_key=True, default=gen_uuid)
    user_id = Column(String(36), nullable=True)  # None for anonymous
    session_id = Column(String(64), nullable=False, default="anon")
    storage_path = Column(String(255), nullable=False)
    sha256 = Column(String(64), nullable=False)
    face_meta = Column(Text, nullable=True)  # JSON metadata string
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))
    expires_at = Column(
        DateTime,
        default=lambda: datetime.now(timezone.utc) + timedelta(hours=24),
    )

    generations = relationship("Generation", back_populates="photo", cascade="all, delete-orphan")

class Generation(Base):
    __tablename__ = "generations"

    id = Column(String(36), primary_key=True, default=gen_uuid)
    photo_id = Column(String(36), ForeignKey("photos.id", ondelete="CASCADE"), nullable=False)
    hair_style_id = Column(String(10), ForeignKey("styles.id"), nullable=True)
    beard_style_id = Column(String(10), ForeignKey("styles.id"), nullable=True)
    view = Column(String(20), default="front")
    status = Column(String(20), default="queued")  # queued, running, done, failed
    result_path = Column(String(255), nullable=True)
    identity_score = Column(Float, nullable=True)
    provider = Column(String(50), nullable=True)
    latency_ms = Column(Integer, nullable=True)
    cost_usd = Column(Float, nullable=True)
    error = Column(Text, nullable=True)
    created_at = Column(DateTime, default=lambda: datetime.now(timezone.utc))

    photo = relationship("Photo", back_populates="generations")

# Index for fast cache lookups on identical combinations
Index(
    "ix_generations_cache",
    Generation.photo_id,
    Generation.hair_style_id,
    Generation.beard_style_id,
    Generation.view,
)
