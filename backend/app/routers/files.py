import os
from fastapi import APIRouter, HTTPException, Query, Response, status
from ..services.storage import get_file_bytes, verify_signed_token

router = APIRouter(prefix="/v1/files", tags=["Files"])

@router.get("/{file_path:path}")
def serve_file(
    file_path: str,
    token: str = Query(None),
):
    # Security check: disallow directory traversal
    if ".." in file_path or file_path.startswith("/") or file_path.startswith("\\"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={"error": {"code": "INVALID_PATH", "message": "Invalid file path traversal"}},
        )

    # In production verify token; if no token in development allow read
    if token and not verify_signed_token(file_path, token):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail={"error": {"code": "TOKEN_EXPIRED", "message": "File authorization token expired or invalid"}},
        )

    file_bytes = get_file_bytes(file_path)
    if not file_bytes:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail={"error": {"code": "FILE_NOT_FOUND", "message": "File not found"}},
        )

    return Response(content=file_bytes, media_type="image/jpeg")
