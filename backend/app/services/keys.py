import os
import itertools
import logging
from typing import List

logger = logging.getLogger("stylemirror.keys")

class KeyPool:
    def __init__(self, env_name: str = "GEMINI_API_KEYS"):
        raw = os.getenv(env_name, "")
        keys = [k.strip() for k in raw.split(",") if k.strip()]
        self._keys: List[str] = keys
        self._size: int = len(keys)
        self._cycle = itertools.cycle(keys) if keys else None
        self._exhausted_keys: set[str] = set()

    @property
    def size(self) -> int:
        return self._size

    @property
    def has_keys(self) -> bool:
        return self._size > 0

    def next(self) -> str:
        if not self._cycle:
            raise RuntimeError("GEMINI_API_KEYS pool is empty or not configured")
        
        # Cycle through up to pool size to find an active key
        for _ in range(self._size):
            k = next(self._cycle)
            if k not in self._exhausted_keys:
                return k
        
        # If all keys were marked exhausted, reset rotation
        self._exhausted_keys.clear()
        return next(self._cycle)

    def mark_quota_exhausted(self, key: str):
        masked = key[:4] + "..." + key[-4:] if len(key) >= 8 else "key_***"
        logger.warning(f"AI key quota exhausted: {masked}. Skipping in rotation.")
        self._exhausted_keys.add(key)

    def mark_invalid(self, key: str):
        masked = key[:4] + "..." + key[-4:] if len(key) >= 8 else "key_***"
        logger.error(f"AI_KEY_INVALID: Key failed authorization: {masked}")
        self._exhausted_keys.add(key)
