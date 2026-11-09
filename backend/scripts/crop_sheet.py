"""
Script to crop the 5x5 collage sheets into individual front/side/back style thumbnails.
Reference: docs/03_STYLE_CATALOG.md
Usage:
    python backend/scripts/crop_sheet.py --sheet hair_sheet.jpg --type hair
"""
import argparse
from pathlib import Path
from PIL import Image

def crop_grid(
    image_path: str,
    cols: int,
    rows: int,
    top_offset: int,
    cell_w: int,
    cell_h: int,
    out_dir: str,
    prefix: str,
):
    out_path = Path(out_dir)
    out_path.mkdir(parents=True, exist_ok=True)
    
    img = Image.open(image_path)
    count = 1
    for r in range(rows):
        for c in range(cols):
            sid = f"{prefix}{count:02d}"
            box = (c * cell_w, top_offset + r * cell_h, (c + 1) * cell_w, top_offset + (r + 1) * cell_h)
            cell = img.crop(box)
            
            # Save cell thumbnail
            cell.save(out_path / f"{sid}_front.jpg", quality=92)
            count += 1
            if count > 25:
                break
        if count > 25:
            break
    print(f"✓ Successfully cropped {count - 1} styles to {out_dir}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Crop style reference sheets into thumbnails")
    parser.add_argument("--sheet", type=str, help="Path to input collage image sheet")
    parser.add_argument("--type", choices=["hair", "beard"], default="hair", help="Style type")
    parser.add_argument("--out", type=str, default="assets/styles", help="Output directory")
    args = parser.parse_args()

    prefix = "H" if args.type == "hair" else "B"
    out_folder = f"{args.out}/{args.type}"
    print(f"Ready to process {args.type} sheet with prefix {prefix} -> {out_folder}")
