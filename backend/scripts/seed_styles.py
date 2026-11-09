"""
Seeds the 25 Hairstyles and 25 Beard styles into the SQLite database.
Usage:
    python backend/scripts/seed_styles.py
"""
import sys
from pathlib import Path

# Add backend directory to sys.path
backend_dir = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(backend_dir))

from app.db import engine, Base
from app.main import seed_default_styles, ensure_storage

if __name__ == "__main__":
    print("Initializing StyleMirror storage & SQLite tables...")
    ensure_storage()
    Base.metadata.create_all(bind=engine)
    print("Seeding all 25 Hairstyles + 25 Beard styles...")
    seed_default_styles()
    print("✓ Done! Styles catalog successfully seeded.")
