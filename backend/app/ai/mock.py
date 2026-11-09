import io
from PIL import Image, ImageDraw, ImageFilter
from .base import ImageProvider

class MockImageProvider(ImageProvider):
    def edit_sync(
        self,
        user_image: bytes,
        prompt: str,
        reference_images: list[bytes] | None = None,
    ) -> bytes:
        try:
            img = Image.open(io.BytesIO(user_image)).convert("RGB")
        except Exception:
            img = Image.new("RGB", (512, 512), color=(25, 32, 45))

        styled = img.filter(ImageFilter.EDGE_ENHANCE_MORE)
        blended = Image.blend(img, styled, alpha=0.35)

        draw = ImageDraw.Draw(blended)
        w, h = blended.size
        badge_text = "StyleMirror AI Preview"
        draw.rectangle([w - 180, h - 35, w - 10, h - 10], fill=(10, 15, 25, 180))
        draw.text((w - 170, h - 30), badge_text, fill=(200, 220, 255))

        out_io = io.BytesIO()
        blended.save(out_io, format="JPEG", quality=90)
        return out_io.getvalue()

    async def edit(
        self,
        user_image: bytes,
        prompt: str,
        reference_images: list[bytes] | None = None,
    ) -> bytes:
        return self.edit_sync(user_image, prompt, reference_images)
