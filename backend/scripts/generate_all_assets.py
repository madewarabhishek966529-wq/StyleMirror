"""
generate_all_assets.py
Generates high-quality thumbnail artwork for all 50 styles (H01-H25, B01-B25)
plus sample selfie model portraits for instant Try-On testing.
"""
import os
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

def create_gradient(width, height, start_color, end_color):
    """Create a vertical gradient image."""
    base = Image.new('RGB', (width, height), start_color)
    top = Image.new('RGB', (width, height), end_color)
    mask = Image.new('L', (width, height))
    mask_data = []
    for y in range(height):
        alpha = int(255 * (y / height))
        mask_data.extend([alpha] * width)
    mask.putdata(mask_data)
    base.paste(top, (0, 0), mask)
    return base

def draw_head_base(draw, cx, cy, skin_color=(220, 180, 150), neck_color=(195, 155, 125)):
    """Draw neck and face oval."""
    # Neck
    draw.rectangle([cx - 40, cy + 30, cx + 40, cy + 130], fill=neck_color)
    # Head oval
    draw.ellipse([cx - 65, cy - 80, cx + 65, cy + 65], fill=skin_color)
    # Ears
    draw.ellipse([cx - 75, cy - 20, cx - 60, cy + 25], fill=neck_color)
    draw.ellipse([cx + 60, cy - 20, cx + 75, cy + 25], fill=neck_color)
    # Eyes
    draw.ellipse([cx - 36, cy - 12, cx - 20, cy - 4], fill=(60, 45, 35))
    draw.ellipse([cx + 20, cy - 12, cx + 36, cy - 4], fill=(60, 45, 35))
    # Eyebrows
    draw.line([cx - 42, cy - 22, cx - 16, cy - 20], fill=(45, 30, 20), width=4)
    draw.line([cx + 16, cy - 20, cx + 42, cy - 22], fill=(45, 30, 20), width=4)
    # Nose hint
    draw.line([cx, cy - 10, cx - 3, cy + 12], fill=(185, 145, 115), width=2)
    draw.line([cx - 3, cy + 12, cx + 4, cy + 14], fill=(185, 145, 115), width=2)
    # Mouth line
    draw.line([cx - 16, cy + 32, cx + 16, cy + 32], fill=(160, 105, 95), width=2)

def draw_hair_style(draw, sid, cx, cy, hair_color=(35, 25, 20)):
    """Render distinctive silhouette for H01 - H25."""
    hc = hair_color
    highlight = (hc[0] + 45, hc[1] + 35, hc[2] + 25)

    if sid == 'H01':  # Crew Cut
        draw.ellipse([cx - 66, cy - 90, cx + 66, cy - 45], fill=hc)
        draw.rectangle([cx - 63, cy - 92, cx + 63, cy - 70], fill=highlight)
    elif sid == 'H02':  # Buzz Cut
        draw.ellipse([cx - 67, cy - 84, cx + 67, cy - 45], fill=(hc[0] + 15, hc[1] + 15, hc[2] + 15))
    elif sid == 'H03':  # French Crop
        draw.ellipse([cx - 68, cy - 95, cx + 68, cy - 40], fill=hc)
        # Straight fringe
        draw.rectangle([cx - 50, cy - 50, cx + 50, cy - 35], fill=hc)
        draw.line([cx - 48, cy - 35, cx + 48, cy - 35], fill=highlight, width=3)
    elif sid == 'H04':  # Ivy League
        draw.ellipse([cx - 68, cy - 95, cx + 68, cy - 45], fill=hc)
        draw.polygon([(cx - 30, cy - 90), (cx + 50, cy - 90), (cx + 40, cy - 65), (cx - 40, cy - 65)], fill=highlight)
    elif sid == 'H05':  # Side Part
        draw.ellipse([cx - 68, cy - 98, cx + 68, cy - 45], fill=hc)
        # Parting line
        draw.line([cx - 30, cy - 95, cx - 20, cy - 50], fill=(20, 15, 10), width=3)
        draw.arc([cx - 20, cy - 100, cx + 60, cy - 55], 0, 180, fill=highlight, width=4)
    elif sid == 'H06':  # Slicked Back
        draw.polygon([(cx - 65, cy - 60), (cx - 55, cy - 105), (cx + 55, cy - 105), (cx + 65, cy - 60)], fill=hc)
        for dx in range(-40, 50, 15):
            draw.line([cx + dx, cy - 100, cx + dx, cy - 65], fill=highlight, width=2)
    elif sid == 'H07':  # Pompadour
        draw.ellipse([cx - 65, cy - 120, cx + 65, cy - 50], fill=hc)
        draw.ellipse([cx - 45, cy - 125, cx + 45, cy - 75], fill=highlight)
    elif sid == 'H08':  # Undercut
        # High shaved sides, long voluminous top
        draw.rectangle([cx - 68, cy - 55, cx - 58, cy - 20], fill=(80, 60, 50))
        draw.rectangle([cx + 58, cy - 55, cx + 68, cy - 20], fill=(80, 60, 50))
        draw.polygon([(cx - 55, cy - 65), (cx - 45, cy - 110), (cx + 45, cy - 110), (cx + 55, cy - 65)], fill=hc)
    elif sid == 'H09':  # Quiff
        draw.ellipse([cx - 65, cy - 95, cx + 65, cy - 50], fill=hc)
        draw.polygon([(cx - 35, cy - 80), (cx, cy - 125), (cx + 40, cy - 85)], fill=highlight)
    elif sid == 'H10':  # Faux Hawk
        draw.polygon([(cx - 25, cy - 60), (cx, cy - 130), (cx + 25, cy - 60)], fill=hc)
        draw.line([cx, cy - 125, cx, cy - 65], fill=highlight, width=5)
    elif sid in ('H11', 'H12', 'H13', 'H14', 'H15'):  # Fades
        draw.ellipse([cx - 66, cy - 95, cx + 66, cy - 55], fill=hc)
        # Fade gradient sides
        fade_h = 30 if sid == 'H11' else (45 if sid == 'H12' else 60)
        draw.rectangle([cx - 67, cy - 60, cx - 60, cy - 60 + fade_h], fill=(160, 120, 95))
        draw.rectangle([cx + 60, cy - 60, cx + 67, cy - 60 + fade_h], fill=(160, 120, 95))
    elif sid == 'H16':  # Textured Fringe
        draw.ellipse([cx - 68, cy - 100, cx + 68, cy - 50], fill=hc)
        for i in range(-5, 6):
            draw.line([cx + i * 9, cy - 60, cx + i * 9 + 4, cy - 35], fill=hc, width=4)
    elif sid == 'H17':  # Messy Waves
        draw.ellipse([cx - 72, cy - 105, cx + 72, cy - 50], fill=hc)
        for off in [-40, -20, 0, 20, 40]:
            draw.arc([cx + off - 15, cy - 95, cx + off + 15, cy - 65], 0, 180, fill=highlight, width=4)
    elif sid == 'H18':  # Curly High Top
        draw.rectangle([cx - 55, cy - 120, cx + 55, cy - 65], fill=hc)
        for y in range(cy - 115, cy - 65, 12):
            for x in range(cx - 50, cx + 50, 14):
                draw.ellipse([x, y, x + 8, y + 8], fill=highlight)
    elif sid == 'H19':  # Caesar Cut
        draw.ellipse([cx - 66, cy - 88, cx + 66, cy - 50], fill=hc)
        draw.rectangle([cx - 45, cy - 48, cx + 45, cy - 38], fill=hc)
    elif sid == 'H20':  # Edgar Cut
        draw.ellipse([cx - 68, cy - 95, cx + 68, cy - 45], fill=hc)
        draw.line([cx - 55, cy - 42, cx + 55, cy - 42], fill=hc, width=6)
    elif sid == 'H21':  # Modern Mullet
        draw.ellipse([cx - 66, cy - 95, cx + 66, cy - 50], fill=hc)
        # Flowing back hair
        draw.polygon([(cx - 75, cy - 10), (cx - 55, cy + 70), (cx - 78, cy + 90)], fill=hc)
        draw.polygon([(cx + 75, cy - 10), (cx + 55, cy + 70), (cx + 78, cy + 90)], fill=hc)
    elif sid == 'H22':  # Wolf Cut
        draw.ellipse([cx - 75, cy - 105, cx + 75, cy - 40], fill=hc)
        draw.polygon([(cx - 80, cy - 40), (cx - 70, cy + 50), (cx - 50, cy + 30)], fill=hc)
        draw.polygon([(cx + 80, cy - 40), (cx + 70, cy + 50), (cx + 50, cy + 30)], fill=hc)
    elif sid == 'H23':  # Man Bun
        draw.ellipse([cx - 66, cy - 92, cx + 66, cy - 50], fill=hc)
        # Top knot / bun
        draw.ellipse([cx - 22, cy - 128, cx + 22, cy - 90], fill=hc)
        draw.ellipse([cx - 15, cy - 122, cx + 15, cy - 96], fill=highlight)
    elif sid == 'H24':  # Shoulder Length Waves
        draw.ellipse([cx - 72, cy - 100, cx + 72, cy - 45], fill=hc)
        draw.rectangle([cx - 82, cy - 40, cx - 55, cy + 110], fill=hc)
        draw.rectangle([cx + 55, cy - 40, cx + 82, cy + 110], fill=hc)
    elif sid == 'H25':  # Long Flow / Surfer
        draw.ellipse([cx - 75, cy - 105, cx + 75, cy - 40], fill=hc)
        draw.polygon([(cx - 80, cy - 30), (cx - 60, cy + 90), (cx - 35, cy + 50)], fill=hc)
        draw.polygon([(cx + 80, cy - 30), (cx + 60, cy + 90), (cx + 35, cy + 50)], fill=hc)
    else:
        draw.ellipse([cx - 66, cy - 95, cx + 66, cy - 45], fill=hc)

def draw_beard_style(draw, sid, cx, cy, beard_color=(35, 25, 20)):
    """Render distinctive silhouette for B01 - B25."""
    bc = beard_color
    if sid == 'B01':  # Clean Shaven
        return  # Smooth bare skin
    elif sid == 'B02':  # 5 O'Clock Shadow
        stubble = (bc[0] + 70, bc[1] + 60, bc[2] + 50)
        draw.arc([cx - 55, cy + 10, cx + 55, cy + 70], 0, 180, fill=stubble, width=8)
    elif sid in ('B03', 'B04'):  # Stubble / Designer Stubble
        stubble = (bc[0] + 40, bc[1] + 35, bc[2] + 30)
        draw.arc([cx - 58, cy + 8, cx + 58, cy + 70], 0, 180, fill=stubble, width=14)
        draw.rectangle([cx - 24, cy + 22, cx + 24, cy + 28], fill=stubble)
    elif sid == 'B05':  # Short Boxed Beard
        draw.polygon([(cx - 55, cy + 10), (cx + 55, cy + 10), (cx + 45, cy + 72), (cx - 45, cy + 72)], fill=bc)
        draw.rectangle([cx - 25, cy + 20, cx + 25, cy + 28], fill=bc)
    elif sid == 'B06':  # Medium Full Beard
        draw.polygon([(cx - 60, cy + 10), (cx + 60, cy + 10), (cx + 50, cy + 95), (cx - 50, cy + 95)], fill=bc)
        draw.rectangle([cx - 30, cy + 20, cx + 30, cy + 28], fill=bc)
    elif sid == 'B07':  # Long Full Beard
        draw.polygon([(cx - 60, cy + 10), (cx + 60, cy + 10), (cx + 45, cy + 130), (cx - 45, cy + 130)], fill=bc)
        draw.rectangle([cx - 30, cy + 18, cx + 30, cy + 28], fill=bc)
    elif sid == 'B08':  # Ducktail Beard
        draw.polygon([(cx - 55, cy + 10), (cx + 55, cy + 10), (cx, cy + 115)], fill=bc)
        draw.rectangle([cx - 25, cy + 20, cx + 25, cy + 28], fill=bc)
    elif sid == 'B09':  # Garibaldi Beard
        draw.ellipse([cx - 55, cy + 25, cx + 55, cy + 115], fill=bc)
        draw.rectangle([cx - 30, cy + 20, cx + 30, cy + 28], fill=bc)
    elif sid == 'B10':  # Verdi Beard
        draw.ellipse([cx - 50, cy + 30, cx + 50, cy + 95], fill=bc)
        # Curled stache
        draw.arc([cx - 45, cy + 15, cx - 5, cy + 30], 180, 360, fill=bc, width=5)
        draw.arc([cx + 5, cy + 15, cx + 45, cy + 30], 180, 360, fill=bc, width=5)
    elif sid == 'B11':  # Bandholz Beard
        draw.polygon([(cx - 62, cy + 5), (cx + 62, cy + 5), (cx + 50, cy + 140), (cx - 50, cy + 140)], fill=bc)
        draw.rectangle([cx - 35, cy + 16, cx + 35, cy + 30], fill=bc)
    elif sid == 'B12':  # Circle Beard
        draw.ellipse([cx - 35, cy + 18, cx + 35, cy + 65], fill=bc)
        draw.ellipse([cx - 18, cy + 32, cx + 18, cy + 48], fill=(220, 180, 150))
    elif sid == 'B13':  # Classic Goatee
        draw.ellipse([cx - 25, cy + 40, cx + 25, cy + 70], fill=bc)
    elif sid == 'B14':  # Extended Goatee
        draw.ellipse([cx - 25, cy + 40, cx + 25, cy + 70], fill=bc)
        draw.rectangle([cx - 25, cy + 20, cx + 25, cy + 28], fill=bc)
        draw.line([cx - 45, cy + 25, cx - 20, cy + 60], fill=bc, width=4)
        draw.line([cx + 45, cy + 25, cx + 20, cy + 60], fill=bc, width=4)
    elif sid == 'B15':  # Van Dyke
        draw.polygon([(cx - 20, cy + 42), (cx + 20, cy + 42), (cx, cy + 75)], fill=bc)
        draw.line([cx - 30, cy + 22, cx + 30, cy + 22], fill=bc, width=5)
    elif sid == 'B16':  # Anchor Beard
        draw.arc([cx - 40, cy + 25, cx + 40, cy + 70], 0, 180, fill=bc, width=6)
        draw.line([cx, cy + 38, cx, cy + 65], fill=bc, width=5)
        draw.line([cx - 25, cy + 22, cx + 25, cy + 22], fill=bc, width=4)
    elif sid == 'B17':  # Balbo Beard
        draw.ellipse([cx - 30, cy + 45, cx + 30, cy + 70], fill=bc)
        draw.line([cx - 30, cy + 22, cx + 30, cy + 22], fill=bc, width=5)
    elif sid == 'B18':  # Chin Strap
        draw.arc([cx - 60, cy + 5, cx + 60, cy + 70], 0, 180, fill=bc, width=6)
    elif sid in ('B19', 'B20'):  # Mutton Chops / Friendly
        draw.polygon([(cx - 65, cy - 20), (cx - 35, cy + 45), (cx - 60, cy + 55)], fill=bc)
        draw.polygon([(cx + 65, cy - 20), (cx + 35, cy + 45), (cx + 60, cy + 55)], fill=bc)
        if sid == 'B20':
            draw.rectangle([cx - 30, cy + 20, cx + 30, cy + 28], fill=bc)
    elif sid == 'B21':  # Classic Chevron Mustache
        draw.polygon([(cx - 38, cy + 26), (cx, cy + 18), (cx + 38, cy + 26), (cx + 32, cy + 32), (cx - 32, cy + 32)], fill=bc)
    elif sid == 'B22':  # Handlebar Mustache
        draw.line([cx - 42, cy + 20, cx - 10, cy + 25], fill=bc, width=5)
        draw.line([cx + 10, cy + 25, cx + 42, cy + 20], fill=bc, width=5)
        draw.arc([cx - 52, cy + 10, cx - 35, cy + 25], 0, 180, fill=bc, width=4)
        draw.arc([cx + 35, cy + 10, cx + 52, cy + 25], 0, 180, fill=bc, width=4)
    elif sid == 'B23':  # Pencil Mustache
        draw.line([cx - 30, cy + 22, cx + 30, cy + 22], fill=bc, width=2)
    elif sid == 'B24':  # Horseshoe Mustache
        draw.rectangle([cx - 30, cy + 20, cx + 30, cy + 26], fill=bc)
        draw.rectangle([cx - 30, cy + 26, cx - 24, cy + 65], fill=bc)
        draw.rectangle([cx + 24, cy + 26, cx + 30, cy + 65], fill=bc)
    elif sid == 'B25':  # Soul Patch
        draw.polygon([(cx - 8, cy + 38), (cx + 8, cy + 38), (cx, cy + 50)], fill=bc)

def generate_style_thumbnail(sid, stype, name, category, output_path):
    w, h = 320, 400
    # Background luxury barber gradient: deep navy/charcoal to dark slate
    bg_top = (18, 24, 38) if stype == 'hair' else (25, 20, 32)
    bg_bottom = (10, 12, 18)
    img = create_gradient(w, h, bg_top, bg_bottom)
    draw = ImageDraw.Draw(img)

    # Ambient studio rim light
    cx, cy = w // 2, 175
    draw.ellipse([cx - 100, cy - 100, cx + 100, cy + 100], fill=(26, 35, 52) if stype == 'hair' else (36, 28, 42))

    # Base head
    draw_head_base(draw, cx, cy)

    # Hairstyle or Beard Style
    if stype == 'hair':
        draw_hair_style(draw, sid, cx, cy)
    else:
        # Give neutral neat buzz for beard card so focus is on beard
        draw.ellipse([cx - 65, cy - 84, cx + 65, cy - 45], fill=(45, 35, 30))
        draw_beard_style(draw, sid, cx, cy)

    # Dark gradient card footer for name clarity
    footer_h = 100
    footer_overlay = Image.new('RGBA', (w, footer_h), (0, 0, 0, 0))
    fdraw = ImageDraw.Draw(footer_overlay)
    for y in range(footer_h):
        alpha = int(240 * (y / footer_h))
        fdraw.line([(0, y), (w, y)], fill=(12, 16, 24, alpha))
    img.paste(footer_overlay, (0, h - footer_h), footer_overlay)

    # Style ID & Category Badge at top
    badge_bg = (37, 99, 235) if stype == 'hair' else (217, 119, 6)
    draw.rounded_rectangle([14, 14, 75, 36], radius=6, fill=badge_bg)
    draw.text((22, 18), sid, fill=(255, 255, 255))

    draw.rounded_rectangle([82, 14, 210, 36], radius=6, fill=(25, 35, 50))
    cat_text = category[:16]
    draw.text((88, 18), cat_text, fill=(200, 215, 240))

    # Title & Type footer
    draw.text((16, h - 68), name, fill=(255, 255, 255))
    type_sub = "PREMIUM HAIRSTYLE" if stype == 'hair' else "FACIAL HAIR SPEC"
    draw.text((16, h - 42), type_sub, fill=(156, 163, 175))

    # Outer border
    draw.rectangle([0, 0, w - 1, h - 1], outline=(40, 50, 70), width=1)

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, quality=92)

def generate_model_portrait(model_id, name, desc, output_path):
    w, h = 480, 600
    img = create_gradient(w, h, (30, 38, 55), (14, 18, 28))
    draw = ImageDraw.Draw(img)

    cx, cy = w // 2, 260
    # Soft portrait studio backdrop
    draw.ellipse([cx - 150, cy - 150, cx + 150, cy + 150], fill=(42, 54, 78))

    # Base portrait
    skin_tones = [
        ((225, 185, 155), (200, 160, 130), (35, 25, 20)),
        ((195, 145, 115), (170, 120, 90), (25, 20, 18)),
        ((240, 205, 175), (215, 180, 150), (60, 45, 30)),
    ]
    skin, neck, hair = skin_tones[model_id % 3]
    draw_head_base(draw, cx, cy, skin_color=skin, neck_color=neck)
    draw.ellipse([cx - 67, cy - 88, cx + 67, cy - 45], fill=hair)

    # Collar / shirt
    draw.polygon([(cx - 70, cy + 130), (cx + 70, cy + 130), (cx + 140, h), (cx - 140, h)], fill=(28, 35, 48))

    # Header and ID
    draw.rounded_rectangle([20, 20, 180, 50], radius=8, fill=(16, 185, 129))
    draw.text((32, 26), f"STUDIO MODEL #{model_id}", fill=(255, 255, 255))

    # Footer banner
    draw.rectangle([0, h - 80, w, h], fill=(10, 14, 20))
    draw.text((24, h - 65), name, fill=(255, 255, 255))
    draw.text((24, h - 40), desc, fill=(156, 163, 175))

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, quality=94)

def generate_styled_result(base_portrait_path, hair_sid, beard_sid, output_path):
    """Generate a realistic styled Try-On result combining hair & beard."""
    base = Image.open(base_portrait_path).convert('RGB')
    w, h = base.size
    draw = ImageDraw.Draw(base)
    cx, cy = w // 2, 260

    if hair_sid:
        draw_hair_style(draw, hair_sid, cx, cy)
    if beard_sid:
        draw_beard_style(draw, beard_sid, cx, cy)

    # Subtle 'BEFORE / AFTER' badge
    draw.rounded_rectangle([20, 20, 200, 52], radius=8, fill=(37, 99, 235))
    draw.text((32, 28), "STYLEMIRROR AI TRY-ON", fill=(255, 255, 255))

    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    base.save(output_path, quality=94)

if __name__ == "__main__":
    import re
    # 1. Parse all styles
    with open('lib/data/style_catalog_data.dart', 'r', encoding='utf-8') as f:
        text = f.read()

    blocks = re.findall(
        r"StyleModel\(\s*id:\s*'([HB]\d+)',\s*type:\s*'(\w+)',\s*name:\s*'([^']+)',.*?category:\s*'([^']+)'",
        text,
        re.DOTALL
    )
    print(f"Found {len(blocks)} styles to generate...")

    for sid, stype, name, cat in blocks:
        sub = "hair" if stype == "hair" else "beard"
        out = f"assets/styles/{sub}/{sid}_front.jpg"
        generate_style_thumbnail(sid, stype, name, cat, out)

    print("✓ All 50 style thumbnails generated in assets/styles/")

    # 2. Generate sample model portraits
    models = [
        (1, "Alex Mercer (Preset 1)", "Clean studio front lighting - Ideal for fades & crops"),
        (2, "Marcus Sterling (Preset 2)", "Warm neutral portrait - Ideal for classic cuts & beards"),
        (3, "Julian Vance (Preset 3)", "Modern cool studio - Ideal for medium-long flow"),
    ]
    for mid, mname, mdesc in models:
        out = f"assets/portraits/model_{mid}.jpg"
        generate_model_portrait(mid, mname, mdesc, out)

    print("✓ 3 model portrait presets generated in assets/portraits/")

    # 3. Generate default styled result previews
    generate_styled_result("assets/portraits/model_1.jpg", "H01", "B05", "assets/portraits/model_1_styled_H01_B05.jpg")
    generate_styled_result("assets/portraits/model_2.jpg", "H07", "B06", "assets/portraits/model_2_styled_H07_B06.jpg")
    generate_styled_result("assets/portraits/model_3.jpg", "H25", "B03", "assets/portraits/model_3_styled_H25_B03.jpg")
    print("✓ Sample styled look results generated.")

