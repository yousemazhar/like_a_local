"""Export the LAL icon at sizes/formats flutter_launcher_icons needs.
- assets/icon/app_icon.png         : 1024x1024 full-bleed square (iOS + base)
- assets/icon/app_icon_foreground.png : 1024x1024 with padded foreground only,
                                        transparent BG (Android adaptive foreground)
- assets/icon/app_icon_round.png   : 1024x1024 with rounded corners (preview)
"""
import math
from PIL import Image, ImageDraw, ImageFilter

OUT = r"C:/Users/youse/StudioProjects/like_a_local/assets/icon"

# ─── shared palette ────────────────────────────────────────────────
PAPER       = (246, 247, 248)
TERRACOTTA  = (201, 123, 92)
TERRA_DARK  = (132, 70, 50)
STONE_LIGHT = (244, 226, 196)
STONE_SHADE = (180, 142, 100)

S = 1024
ADAPTIVE_BG = (185, 100, 70)   # solid background hex used in pubspec

# ─── full-bleed square icon ─────────────────────────────────────────
def build_full(S=1024, transparent_bg=False, inner_scale=1.0):
    img = Image.new("RGB", (S, S), PAPER)
    # Background gradient (warm dusk) — full square (no rounded corners; OS masks)
    px = img.load()
    c_top = (216, 144, 108); c_bot = (172, 88, 62)
    for y in range(S):
        t = y / (S-1)
        row = (int(c_top[0]*(1-t)+c_bot[0]*t),
               int(c_top[1]*(1-t)+c_bot[1]*t),
               int(c_top[2]*(1-t)+c_bot[2]*t))
        for x in range(S):
            px[x, y] = row

    if transparent_bg:
        img = Image.new("RGBA", (S, S), (0,0,0,0))

    d = ImageDraw.Draw(img, "RGBA")

    # subtle sun glow — smaller, restrained
    sun_cx, sun_cy, sun_r = S//2, int(S*0.40), int(S*0.13)
    sun_layer = Image.new("RGBA", (S, S), (0,0,0,0))
    sdl = ImageDraw.Draw(sun_layer)
    sdl.ellipse([sun_cx-sun_r, sun_cy-sun_r, sun_cx+sun_r, sun_cy+sun_r],
                fill=(245, 210, 160, 180 if not transparent_bg else 0))
    sun_layer = sun_layer.filter(ImageFilter.GaussianBlur(40))
    if not transparent_bg:
        img.paste(sun_layer, (0,0), sun_layer)

    d = ImageDraw.Draw(img, "RGBA")

    # geometry — generous letter heights, pyramids with proper ~52° Giza slope
    ground_y = int(S*0.74)
    top_y    = int(S*0.34)
    if inner_scale != 1.0:
        cy = (ground_y + top_y) / 2
        ground_y = int(cy + (ground_y-cy)*inner_scale)
        top_y    = int(cy + (top_y - cy)*inner_scale)
    letter_h = ground_y - top_y

    # Columns: L is narrow, A (pyramid cluster) is wider — pyramids need real base width
    col_L = int(S*0.16*inner_scale)
    col_A = int(S*0.34*inner_scale)
    gap   = int(S*0.04*inner_scale)
    total_w = col_L*2 + col_A + gap*2
    left_x  = (S - total_w)//2

    def draw_L(x):
        stem_w = int(col_L*0.34)
        foot_h = int(letter_h*0.20)
        d.rectangle([x, top_y, x+stem_w, ground_y], fill=PAPER)
        d.rectangle([x, ground_y - foot_h, x+col_L, ground_y], fill=PAPER)

    draw_L(left_x)
    draw_L(left_x + col_L + gap + col_A + gap)

    # Pyramids — stylized so the central one reads as the letter A.
    # Central pyramid uses tall apex (letterform slope ≈ A); flanking pyramids
    # use Giza-realistic ~52° slope as background context.
    ax = left_x + col_L + gap
    aw = col_A

    def pyramid(cx, base_y, half_base, height, light, shade):
        apex = (cx, base_y - height)
        bl   = (cx - half_base, base_y)
        br   = (cx + half_base, base_y)
        d.polygon([apex, bl, br], fill=light)
        mid = (cx, base_y)
        d.polygon([apex, mid, br], fill=shade)
        return apex, bl, br

    # Khufu (back-left): real Giza slope, mid-size
    khufu_half = int(aw*0.40)
    pyramid(ax + int(aw*0.30), ground_y,
            khufu_half, int(khufu_half*1.30),
            STONE_LIGHT, STONE_SHADE)

    # Khafre (CENTER) — the A. Tall like a letter, apex near top_y, crossbar inside.
    khafre_half = int(aw*0.34)
    khafre_height = letter_h            # full letter height: an A
    khafre_apex, khafre_bl, khafre_br = pyramid(
        ax + int(aw*0.55), ground_y, khafre_half, khafre_height,
        (252, 234, 204), (210, 176, 130))

    # Menkaure (front-right): small, real slope
    menk_half = int(aw*0.22)
    pyramid(ax + int(aw*0.86), ground_y,
            menk_half, int(menk_half*1.30),
            (238, 216, 180), (196, 160, 116))

    # crossbar
    def x_at_y(apex, base, y):
        if base[1] == apex[1]: return base[0]
        t = (y - apex[1]) / (base[1] - apex[1])
        return apex[0] + t * (base[0] - apex[0])
    bar_y = ground_y - int(letter_h*0.30)
    bar_xL = x_at_y(khafre_apex, khafre_bl, bar_y)
    bar_xR = x_at_y(khafre_apex, khafre_br, bar_y)
    inset = (bar_xR - bar_xL) * 0.18
    bar_h = max(2, int(S*0.014))
    d.rectangle([bar_xL+inset, bar_y - bar_h//2, bar_xR-inset, bar_y + bar_h//2],
                fill=TERRA_DARK)

    # pin
    pin_cx, pin_cy = khafre_apex[0], khafre_apex[1] - int(S*0.028)
    pin_r = max(2, int(S*0.018))
    d.line([(pin_cx, khafre_apex[1]+2), (pin_cx, pin_cy+pin_r-2)], fill=TERRA_DARK, width=max(2, int(S*0.0035)))
    d.ellipse([pin_cx-pin_r, pin_cy-pin_r, pin_cx+pin_r, pin_cy+pin_r], fill=TERRA_DARK)

    # ground line
    d.line([(left_x - int(S*0.02), ground_y),
            (left_x + total_w + int(S*0.02), ground_y)],
           fill=(255,255,255,160), width=max(2, int(S*0.003)))

    return img

# 1) Full bleed (iOS + base)
full = build_full(S=1024, transparent_bg=False, inner_scale=1.0)
full.convert("RGB").save(f"{OUT}/app_icon.png", "PNG", optimize=True)

# 2) Android adaptive foreground: transparent BG, inner content scaled to ~66% safe zone
fg = build_full(S=1024, transparent_bg=True, inner_scale=0.66)
fg.save(f"{OUT}/app_icon_foreground.png", "PNG", optimize=True)

# 3) Rounded preview (for repo readme / store screenshot)
preview = full.convert("RGBA")
mask = Image.new("L", (S, S), 0)
ImageDraw.Draw(mask).rounded_rectangle([0,0,S,S], radius=int(S*0.22), fill=255)
preview.putalpha(mask)
preview.save(f"{OUT}/app_icon_round.png", "PNG", optimize=True)

print("Wrote:")
print(f"  {OUT}/app_icon.png            (1024x1024, opaque, iOS-safe)")
print(f"  {OUT}/app_icon_foreground.png (1024x1024, transparent, adaptive)")
print(f"  {OUT}/app_icon_round.png      (preview)")
