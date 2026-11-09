from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel
from typing import List, Optional
from sqlalchemy.orm import Session
from ..db import get_db
from ..models import Style
from ..schemas import StyleResponse

router = APIRouter(prefix="/v1/suggestions", tags=["Suggestions"])

class FaceShapeSuggestionRequest(BaseModel):
    photo_id: Optional[str] = None
    face_shape: Optional[str] = "oval"  # oval, round, square, heart, diamond, oblong

class SuggestionResponse(BaseModel):
    face_shape: str
    description: str
    recommended_hair: List[StyleResponse]
    recommended_beard: List[StyleResponse]

# Rule-based styling matrix according to barber aesthetics
FACE_SHAPE_RECOMMENDATIONS = {
    "oval": {
        "hair": ["H12", "H11", "H06", "H03", "H13", "H15"],
        "beard": ["B02", "B04", "B03", "B09", "B21", "B08"],
        "desc": "Oval faces suit almost any hairstyle. Fades, quiffs, and medium beards maintain ideal proportions.",
    },
    "round": {
        "hair": ["H13", "H12", "H07", "H11", "H20", "H09"],
        "beard": ["B03", "B08", "B06", "B10", "B07", "B11"],
        "desc": "Add height on top and keep sides tight to elongate facial shape. Pointed or anchor beards add jawline definition.",
    },
    "square": {
        "hair": ["H04", "H05", "H03", "H01", "H18", "H14"],
        "beard": ["B02", "B06", "B08", "B21", "B12", "B01"],
        "desc": "Softer textured crops or classic side-parts complement strong angular jawlines without overpowering them.",
    },
    "heart": {
        "hair": ["H16", "H17", "H25", "H19", "H08", "H23"],
        "beard": ["B05", "B04", "B15", "B16", "B03", "B19"],
        "desc": "Fuller beards add volume to a narrower chin, while flowing mid-length hair balances forehead width.",
    },
    "diamond": {
        "hair": ["H16", "H18", "H12", "H09", "H25", "H17"],
        "beard": ["B04", "B03", "B07", "B15", "B21", "B02"],
        "desc": "Curtain hair or textured fringes soften wide cheekbones. Medium boxed beards provide balanced lower-face symmetry.",
    },
    "oblong": {
        "hair": ["H03", "H04", "H18", "H08", "H16", "H19"],
        "beard": ["B04", "B13", "B14", "B03", "B02", "B20"],
        "desc": "Forward fringes reduce forehead visual height; avoid extreme top volume. Side growth in beards adds width.",
    },
}

@router.post("", response_model=SuggestionResponse)
def get_face_shape_suggestions(
    req: FaceShapeSuggestionRequest,
    db: Session = Depends(get_db),
):
    shape = (req.face_shape or "oval").lower()
    if shape not in FACE_SHAPE_RECOMMENDATIONS:
        shape = "oval"

    config = FACE_SHAPE_RECOMMENDATIONS[shape]
    hair_ids = config["hair"]
    beard_ids = config["beard"]

    hair_styles = db.query(Style).filter(Style.id.in_(hair_ids)).all()
    beard_styles = db.query(Style).filter(Style.id.in_(beard_ids)).all()

    # Sort matching the recommendation priority
    hair_map = {s.id: s for s in hair_styles}
    beard_map = {s.id: s for s in beard_styles}

    sorted_hair = [hair_map[hid] for hid in hair_ids if hid in hair_map]
    sorted_beard = [beard_map[bid] for bid in beard_ids if bid in beard_map]

    return SuggestionResponse(
        face_shape=shape.capitalize(),
        description=config["desc"],
        recommended_hair=[StyleResponse.model_validate(s) for s in sorted_hair],
        recommended_beard=[StyleResponse.model_validate(s) for s in sorted_beard],
    )

