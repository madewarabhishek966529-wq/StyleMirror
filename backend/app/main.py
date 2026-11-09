import asyncio
import logging
from contextlib import asynccontextmanager
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from .config import settings
from .db import engine, Base, SessionLocal
from .models import Style
from .routers import styles, photos, generations, files
from .services.cleanup import run_24h_cleanup
from .services.storage import ensure_storage

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("stylemirror")

def seed_default_styles():
    """Seeds the 25 Hairstyles and 25 Beard styles if not already present."""
    db = SessionLocal()
    try:
        if db.query(Style).count() >= 50:
            return

        # 25 Hairstyles
        hair_catalog = [
            ("H01", "Crew Cut", "very short tapered sides, slightly longer flat-ish top, neat classic military cut", "Short & Fade"),
            ("H02", "Buzz Cut", "uniformly clipped very short all over, scalp slightly visible", "Short & Fade"),
            ("H03", "French Crop", "short textured top with a short straight forward fringe, faded short sides", "Textured Crop"),
            ("H04", "Ivy League", "short side-parted classic cut, slightly longer top, tapered neat back", "Classic & Parted"),
            ("H05", "Side Part", "neat defined side parting, combed volume on top, tapered sides", "Classic & Parted"),
            ("H06", "Mid Fade", "textured medium-length top, skin fade starting mid-level on the sides", "Fade"),
            ("H07", "High Fade", "textured top, sides faded high up toward temples, high contrast", "Fade"),
            ("H08", "Low Fade", "textured top with fringe, fade starting low near ears and neckline", "Fade"),
            ("H09", "Taper Fade", "gradual taper on sides and neckline, voluminous textured top", "Fade"),
            ("H10", "Skin Fade", "sides faded down to bare skin, longer messy-textured top", "Fade"),
            ("H11", "Undercut", "long swept-back top with sharply disconnected shaved sides", "Disconnected"),
            ("H12", "Quiff", "raised voluminous front swept upward and back, short tapered sides", "Volume & Height"),
            ("H13", "Pompadour", "tall voluminous swept-back front with height, faded sides", "Volume & Height"),
            ("H14", "Slick Back", "hair combed straight back with gel shine, no parting", "Classic & Parted"),
            ("H15", "Comb Over", "hair combed to one side with sharp parting, tapered sides", "Classic & Parted"),
            ("H16", "Curtain Hair", "center-parted medium-length hair falling to both sides like curtains", "Medium & Long"),
            ("H17", "Bro Flow", "medium-long wavy hair flowing back, past the ears", "Medium & Long"),
            ("H18", "Textured Crop", "short messy textured top with fringe, short sides", "Textured Crop"),
            ("H19", "Messy Hair", "tousled, loose, choppy medium-length layers", "Textured Crop"),
            ("H20", "Spiky Hair", "short spiked-up top with faded sides", "Short & Fade"),
            ("H21", "Man Bun", "longer hair tied in a bun at the back of head, sides tight", "Medium & Long"),
            ("H22", "Top Knot", "hair tied into a knot at the crown, shaved/faded sides", "Disconnected"),
            ("H23", "Long Hair", "long straight-to-wavy hair past the shoulders", "Medium & Long"),
            ("H24", "Mullet", "short top and sides, long tail at the back", "Medium & Long"),
            ("H25", "Curly Hair", "full natural curls on top, tapered sides", "Textured Crop"),
        ]

        # 25 Beard styles
        beard_catalog = [
            ("B01", "Clean Shaven", "no facial hair, smooth skin", "Clean & Stubble"),
            ("B02", "Stubble", "very short 1–3 mm even facial hair", "Clean & Stubble"),
            ("B03", "Short Boxed Beard", "short, well-groomed, sharply lined full beard", "Trimmed & Professional"),
            ("B04", "Medium Beard", "natural medium-length full beard, neat", "Trimmed & Professional"),
            ("B05", "Full Beard", "thick, full, long facial hair covering cheeks and chin", "Full & Long"),
            ("B06", "Goatee", "hair only on the chin, with or without mustache", "Goatee & Chin"),
            ("B07", "Extended Goatee", "goatee connected to mustache, extending slightly along the jaw", "Goatee & Chin"),
            ("B08", "Van Dyke", "pointed chin beard with a styled, disconnected mustache", "Goatee & Chin"),
            ("B09", "Circle Beard", "mustache connected to chin beard forming a circle", "Goatee & Chin"),
            ("B10", "Anchor Beard", "stylized chin beard shaped like an anchor, thin line along jaw", "Stylized"),
            ("B11", "Balbo Beard", "mustache plus chin beard, not connected, no sideburns", "Stylized"),
            ("B12", "Soul Patch", "tiny patch of hair under the lower lip", "Clean & Stubble"),
            ("B13", "Mutton Chops", "thick sideburns extending to the jaw, clean-shaven chin", "Stylized"),
            ("B14", "Friendly Mutton Chops", "mutton chops connected with a mustache, chin shaved", "Stylized"),
            ("B15", "Verdi Beard", "full rounded beard with styled mustache", "Full & Long"),
            ("B16", "Garibaldi", "long, full, wide rounded natural beard", "Full & Long"),
            ("B17", "Dutch Beard", "full beard with shaped bottom, no mustache", "Full & Long"),
            ("B18", "Bandholz", "very long, thick, rugged beard", "Full & Long"),
            ("B19", "Corporate Beard", "short, neat, professional trimmed beard", "Trimmed & Professional"),
            ("B20", "Hollywoodian", "full beard with a styled, waxed mustache", "Trimmed & Professional"),
            ("B21", "Designer Stubble", "stylish, well-defined sharp-edged stubble", "Clean & Stubble"),
            ("B22", "Chin Strap", "thin beard line following the jawline", "Stylized"),
            ("B23", "Neck Beard", "growth concentrated along the neck area", "Full & Long"),
            ("B24", "Imperial", "long upturned mustache with a goatee", "Stylized"),
            ("B25", "Horseshoe", "mustache with vertical strips running down to the chin", "Stylized"),
        ]

        order = 1
        for sid, name, hint, cat in hair_catalog:
            if not db.query(Style).filter(Style.id == sid).first():
                db.add(Style(
                    id=sid,
                    type="hair",
                    name=name,
                    prompt_hint=hint,
                    thumb_url=f"/assets/styles/hair/{sid}_front.jpg",
                    category=cat,
                    sort_order=order,
                ))
            order += 1

        for sid, name, hint, cat in beard_catalog:
            if not db.query(Style).filter(Style.id == sid).first():
                db.add(Style(
                    id=sid,
                    type="beard",
                    name=name,
                    prompt_hint=hint,
                    thumb_url=f"/assets/styles/beard/{sid}_front.jpg",
                    category=cat,
                    sort_order=order,
                ))
            order += 1

        db.commit()
        logger.info("Successfully seeded 50 hairstyles and beard styles into SQLite.")
    except Exception as e:
        logger.error(f"Error seeding styles: {e}")
    finally:
        db.close()

async def periodic_cleanup_task():
    """Runs 24h photo cleanup every 15 minutes"""
    while True:
        try:
            await asyncio.sleep(900)  # 15 minutes
            db = SessionLocal()
            run_24h_cleanup(db)
            db.close()
        except asyncio.CancelledError:
            break
        except Exception as e:
            logger.error(f"Periodic cleanup error: {e}")

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: ensure tables & storage exist
    Base.metadata.create_all(bind=engine)
    ensure_storage()
    seed_default_styles()
    cleanup_task = asyncio.create_task(periodic_cleanup_task())
    yield
    # Shutdown
    cleanup_task.cancel()

app = FastAPI(
    title=settings.app_name,
    version="1.0.0",
    lifespan=lifespan,
)

# CORS Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.allowed_origin] if settings.allowed_origin != "*" else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount Routers
app.include_router(styles.router)
app.include_router(photos.router)
app.include_router(generations.router)
app.include_router(files.router)

@app.get("/health")
def healthcheck():
    return {"status": "ok", "app": "StyleMirror", "environment": settings.environment}
