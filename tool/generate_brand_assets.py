from pathlib import Path

import cairosvg
from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
ASSETS = ROOT / "assets" / "brand"
SOURCE_DIR = ASSETS / "source"
CACHE_DIR = ROOT / ".generated" / "brand"
BOARD_SOURCE = SOURCE_DIR / "fluxa-board-master.svg"
BOARD_PREVIEW = CACHE_DIR / "fluxa-board-master-preview.png"
SYMBOL_SOURCE = SOURCE_DIR / "fluxa-symbol-master.svg"
SYMBOL_PREVIEW = CACHE_DIR / "fluxa-symbol-master-preview.png"

PRIMARY = "#2563EB"
BOARD_NAVY = "#09192C"
BACKGROUND = "#F8FAFC"
WHITE = "#FFFFFF"
LIGHT_BORDER = "#E2E8F0"

BOARD_EXPORTS = {
    "fluxa-brand-board.png": None,
    "fluxa-lockup-dark.png": None,
}

def _rounded_mask(size, radius):
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    d.rounded_rectangle((0, 0, size, size), radius=radius, fill=255)
    return mask


def _render_svg(src: Path, out: Path, output_width: int):
    if not src.exists():
        raise FileNotFoundError(f"SVG not found: {src}")
    out.parent.mkdir(parents=True, exist_ok=True)
    cairosvg.svg2png(url=str(src), write_to=str(out), output_width=output_width)


def _remove_light_background(image: Image.Image, threshold: int = 248):
    rgba = image.convert("RGBA")
    pixels = rgba.load()
    width, height = rgba.size
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            if r >= threshold and g >= threshold and b >= threshold:
                pixels[x, y] = (255, 255, 255, 0)
    bbox = rgba.getbbox()
    return rgba.crop(bbox) if bbox else rgba


def build_symbol(size):
    _render_svg(SYMBOL_SOURCE, SYMBOL_PREVIEW, max(size * 2, 2048))
    symbol = _remove_light_background(Image.open(SYMBOL_PREVIEW))
    return symbol.resize((size, int(symbol.height * (size / symbol.width))), Image.LANCZOS)


def build_icon(size, background=True):
    canvas = Image.new("RGBA", (size, size), BOARD_NAVY if background else (0, 0, 0, 0))
    symbol_size = int(size * 0.72)
    symbol = build_symbol(symbol_size)
    x = (size - symbol.width) // 2
    y = (size - symbol.height) // 2
    canvas.alpha_composite(symbol, (x, y))

    if background:
        mask = _rounded_mask(size, int(size * 0.24))
        canvas.putalpha(mask)

    return canvas


def build_light_icon(size):
    shadow = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    shadow_draw = ImageDraw.Draw(shadow)
    inset = int(size * 0.07)
    radius = int(size * 0.22)
    shadow_draw.rounded_rectangle(
        (inset, inset + int(size * 0.02), size - inset, size - inset + int(size * 0.02)),
        radius=radius,
        fill=(15, 23, 42, 28),
    )
    shadow = shadow.filter(ImageFilter.GaussianBlur(radius=int(size * 0.035)))

    base = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    base.alpha_composite(shadow)

    card = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    card_draw = ImageDraw.Draw(card)
    card_draw.rounded_rectangle(
        (int(size * 0.06), int(size * 0.06), int(size * 0.94), int(size * 0.94)),
        radius=int(size * 0.22),
        fill=WHITE,
        outline=LIGHT_BORDER,
        width=max(2, size // 256),
    )
    base.alpha_composite(card)

    symbol_size = int(size * 0.56)
    symbol = build_symbol(symbol_size)
    x = (size - symbol.width) // 2
    y = (size - symbol.height) // 2
    base.alpha_composite(symbol, (x, y))
    return base


def build_splash(size):
    canvas = Image.new("RGBA", (size, size), BACKGROUND)
    icon_size = int(size * 0.42)
    icon = build_icon(icon_size, background=True)
    x = (size - icon_size) // 2
    y = (size - icon_size) // 2
    canvas.alpha_composite(icon, (x, y))
    return canvas


def export_master_brand_assets():
    _render_svg(BOARD_SOURCE, BOARD_PREVIEW, 2400)
    board = Image.open(BOARD_PREVIEW)
    board.save(ASSETS / "fluxa-brand-board.png")

    for filename, crop_box in BOARD_EXPORTS.items():
        (board if crop_box is None else board.crop(crop_box)).save(ASSETS / filename)

    build_symbol(1024).save(ASSETS / "fluxa-symbol-1024.png")


def build_brand_preview():
    canvas = Image.new("RGBA", (1600, 900), BACKGROUND)

    light_lockup_path = ASSETS / "fluxa-lockup-light.png"
    if light_lockup_path.exists():
        light_lockup = Image.open(light_lockup_path).convert("RGBA")
        light_lockup.thumbnail((760, 360), Image.LANCZOS)
        canvas.alpha_composite(light_lockup, (72, 72))

    light_icon = Image.open(ASSETS / "fluxa-app-icon-light-1024.png").convert("RGBA")
    light_icon.thumbnail((260, 260), Image.LANCZOS)
    canvas.alpha_composite(light_icon, (860, 82))

    dark_panel = Image.new("RGBA", (380, 320), BOARD_NAVY)
    canvas.alpha_composite(dark_panel, (1220, 0))
    dark_icon = Image.open(ASSETS / "fluxa-app-icon-1024.png").convert("RGBA")
    dark_icon.thumbnail((248, 248), Image.LANCZOS)
    canvas.alpha_composite(dark_icon, (1286, 88))

    light_strip = Image.new("RGBA", (800, 180), WHITE)
    ImageDraw.Draw(light_strip).rectangle((0, 0, 799, 179), outline=LIGHT_BORDER, width=2)
    canvas.alpha_composite(light_strip, (0, 404))
    if light_lockup_path.exists():
        light_lockup_small = Image.open(light_lockup_path).convert("RGBA")
        light_lockup_small.thumbnail((520, 140), Image.LANCZOS)
        canvas.alpha_composite(light_lockup_small, (120, 426))

    dark_lockup = Image.open(ASSETS / "fluxa-lockup-dark.png").convert("RGBA")
    dark_lockup.thumbnail((720, 180), Image.LANCZOS)
    canvas.alpha_composite(dark_lockup, (800, 404))

    canvas.save(ASSETS / "fluxa-brand-preview.png")


def main():
    ASSETS.mkdir(parents=True, exist_ok=True)
    export_master_brand_assets()
    build_light_icon(1024).save(ASSETS / "fluxa-app-icon-light-1024.png")
    build_icon(1024, background=True).save(ASSETS / "fluxa-app-icon-1024.png")
    build_icon(1024, background=False).save(ASSETS / "fluxa-adaptive-foreground.png")
    build_splash(1024).save(ASSETS / "fluxa-splash-icon.png")
    build_icon(960, background=False).save(ASSETS / "fluxa-android12-splash-icon.png")
    build_brand_preview()


if __name__ == "__main__":
    main()
