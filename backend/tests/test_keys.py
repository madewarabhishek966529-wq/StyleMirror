import os
import pytest
from app.services.keys import KeyPool

def test_key_pool_rotation():
    os.environ["TEST_GEMINI_KEYS"] = "key_alpha, key_beta, key_gamma"
    pool = KeyPool(env_name="TEST_GEMINI_KEYS")
    assert pool.size == 3
    assert pool.has_keys is True

    # Round robin rotation
    k1 = pool.next()
    k2 = pool.next()
    k3 = pool.next()
    k4 = pool.next()

    assert k1 == "key_alpha"
    assert k2 == "key_beta"
    assert k3 == "key_gamma"
    assert k4 == "key_alpha"

def test_key_pool_quota_exhaustion_skip():
    os.environ["TEST_GEMINI_KEYS_QUOTA"] = "key_1, key_2"
    pool = KeyPool(env_name="TEST_GEMINI_KEYS_QUOTA")

    k1 = pool.next()
    assert k1 == "key_1"
    pool.mark_quota_exhausted("key_1")

    # Next call skips exhausted key_1
    k2 = pool.next()
    assert k2 == "key_2"

def test_empty_key_pool():
    os.environ["TEST_EMPTY_KEYS"] = ""
    pool = KeyPool(env_name="TEST_EMPTY_KEYS")
    assert pool.size == 0
    assert pool.has_keys is False
    with pytest.raises(RuntimeError):
        pool.next()
