from pydantic import BaseModel, Field
from typing import Optional, List, Dict, Any

class StyleResponse(BaseModel):
    id: str
    type: str
    name: str
    prompt_hint: str
    thumb_url: str
    category: Optional[str] = None
    sort_order: int = 0
    is_active: bool = True

    class Config:
        from_attributes = True

class PhotoUploadResponse(BaseModel):
    photo_id: str
    ok: bool
    issues: List[str] = Field(default_factory=list)
    expires_in: int = 86400

class GenerationCreateRequest(BaseModel):
    photo_id: str
    hair_style_id: Optional[str] = None
    beard_style_id: Optional[str] = None
    view: str = "front"

class GenerationResponse(BaseModel):
    id: str
    photo_id: str
    hair_style_id: Optional[str] = None
    beard_style_id: Optional[str] = None
    view: str = "front"
    status: str
    result_url: Optional[str] = None
    identity_score: Optional[float] = None
    latency_ms: Optional[int] = None
    error: Optional[str] = None

    class Config:
        from_attributes = True

class ErrorDetail(BaseModel):
    code: str
    message: str

class ErrorResponse(BaseModel):
    error: ErrorDetail
