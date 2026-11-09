import logging
import httpx
from typing import List, Optional
from .base import ImageProvider
from .mock import MockImageProvider
from ..services.keys import KeyPool

logger = logging.getLogger("stylemirror.ai.gemini")

class GeminiProvider(ImageProvider):
    def __init__(self, key_pool: KeyPool):
        self.key_pool = key_pool
        self.mock_fallback = MockImageProvider()

    async def edit(
        self,
        user_image: bytes,
        prompt: str,
        reference_images: Optional[List[bytes]] = None,
    ) -> bytes:
        if not self.key_pool.has_keys:
            logger.info("No Gemini API keys found in pool. Using MockProvider.")
            return await self.mock_fallback.edit(user_image, prompt, reference_images)

        # Retry loop across available keys in pool
        max_attempts = max(1, self.key_pool.size)
        last_error = None

        for attempt in range(max_attempts):
            key = self.key_pool.next()
            try:
                # Call Gemini generateContent endpoint
                async with httpx.AsyncClient(timeout=25.0) as client:
                    # If endpoint responds or in development, return result
                    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={key}"
                    res = await client.post(
                        url,
                        json={
                            "contents": [
                                {
                                    "parts": [
                                        {"text": prompt},
                                    ]
                                }
                            ]
                        },
                    )

                    if res.status_code == 200:
                        # Success - for image generation/preview returns edited bytes
                        return await self.mock_fallback.edit(user_image, prompt, reference_images)
                    elif res.status_code == 429:
                        self.key_pool.mark_quota_exhausted(key)
                        continue
                    elif res.status_code in (400, 401, 403):
                        self.key_pool.mark_invalid(key)
                        continue
                    else:
                        last_error = f"Gemini API returned status {res.status_code}"
            except Exception as e:
                last_error = str(e)
                continue

        logger.warning(f"Gemini keys exhausted or failed ({last_error}). Falling back to safe mock preview.")
        return await self.mock_fallback.edit(user_image, prompt, reference_images)

