import os
import shutil
import hmac
import hashlib
import time
from pathlib import Path
from PIL import Image, ImageOps
import io
from ..config import settings

STORAGE_ROOT = Path(settings.storage_dir)

def ensure_storage():
    STORAGE_ROOT.mkdir(parents=True, exist_ok=True)

def save_original_photo(photo_id: str, image_bytes: bytes) -> str:
    """Fix EXIF, resize max side to 1024px, save to storage/photos/{photo_id}/original.jpg"""
    ensure_storage()
    folder = STORAGE_ROOT / "photos" / photo_id
    folder.mkdir(parents=True, exist_ok=True)
    out_path = folder / "original.jpg"

    pil_img = Image.open(io.BytesIO(image_bytes))
    pil_img = ImageOps.exif_transpose(pil_img)
    pil_img.thumbnail((1024, 1024), Image.Resampling.LANCZOS)
    pil_img.convert("RGB").save(out_path, format="JPEG", quality=90)

    return f"photos/{photo_id}/original.jpg"

def save_generation_output(photo_id: str, generation_id: str, output_bytes: bytes) -> str:
    """Saves generated preview to storage/photos/{photo_id}/out/{generation_id}.jpg"""
    ensure_storage()
    out_dir = STORAGE_ROOT / "photos" / photo_id / "out"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / f"{generation_id}.jpg"

    with open(out_path, "wb") as f:
        f.write(output_bytes)

    return f"photos/{photo_id}/out/{generation_id}.jpg"

def get_file_bytes(relative_path: str) -> bytes | None:
    full_path = STORAGE_ROOT / relative_path
    if full_path.exists() and full_path.is_file():
        return full_path.read_bytes()
    return None

def delete_photo_storage(photo_id: str) -> bool:
    """Permanently deletes storage/photos/{photo_id} and all contained outputs"""
    folder = STORAGE_ROOT / "photos" / photo_id
    if folder.exists() and folder.is_dir():
        shutil.rmtree(folder, ignore_errors=True)
        return True
    return False

def generate_signed_token(file_path: str, expires_in_seconds: int = 3600) -> str:
    """Generates an HMAC-SHA256 signature for signed file access"""
    expiry = int(time.time()) + expires_in_seconds
    msg = f"{file_path}:{expiry}".encode()
    sig = hmac.new(settings.secret_key.encode(), msg, hashlib.sha256).hexdigest()
    return f"{expiry}_{sig}"

def verify_signed_token(file_path: str, token: str) -> bool:
    try:
        parts = token.split("_")
        if len(parts) != 2:
            return False
        expiry = int(parts[0])
        provided_sig = parts[1]

        if time.time() > expiry:
            return False  # Expired token

        msg = f"{file_path}:{expiry}".encode()
        expected_sig = hmac.new(settings.secret_key.encode(), msg, hashlib.sha256).hexdigest()
        return hmac.compare_digest(expected_sig, provided_sig)
    except Exception:
        return False

