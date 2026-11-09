from abc import ABC, abstractmethod
from typing import List, Optional

class ImageProvider(ABC):
    @abstractmethod
    async def edit(
        self,
        user_image: bytes,
        prompt: str,
        reference_images: Optional[List[bytes]] = None,
    ) -> bytes:
        """Takes user selfie bytes + styling prompt and returns styled image bytes."""
        pass

