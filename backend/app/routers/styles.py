from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session
from typing import List, Optional
from ..db import get_db
from ..models import Style
from ..schemas import StyleResponse

router = APIRouter(prefix="/v1/styles", tags=["Styles"])

@router.get("", response_model=List[StyleResponse])
def get_styles(
    type: Optional[str] = Query(None, description="'hair' or 'beard'"),
    db: Session = Depends(get_db),
):
    query = db.query(Style).filter(Style.is_active == True)
    if type in ("hair", "beard"):
        query = query.filter(Style.type == type)
    
    return query.order_by(Style.sort_order.asc()).all()
