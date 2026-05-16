"""LAL — app icon. The 'A' is three pyramids of Giza."""
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

FONT_DIR = r"C:/Users/youse/AppData/Roaming/Claude/local-agent-mode-sessions/skills-plugin/f2af91ee-c71a-4215-9ca4-7635131f3cb6/d5879f2b-b923-4572-9ce3-fb7db329f4ed/skills/canvas-design/canvas-fonts"

# Palette
PAPER       = (246, 247, 248)
INK_900     = (28, 36, 46)
INK_700     = (66, 80, 96)
INK_500     = (122, 134, 148)
INK_300     = (188, 196, 205)
TERRACOTTA  = (201, 123, 92)
TERRA_DEEP  = (168, 95, 68)
TERRA_DARK  = (132, 70, 50)

# Pyramid stones
STONE_LIGHT = (244, 226, 196)
STONE_MID   = (224, 198, 158)
STONE_SHADE = (180, 142, 100)
STONE_DEEP  = (140, 102, 70)

# ─── Icon canvas ────────────────────────────────────────────────────
S = 2048
icon = Image.new("RGB", (S, S), PAPER)

# Warm dusk gradient background, rounded
def gradient_bg(image, c_top, c_bot, radius):
    g = Image.new("RGB", (S, S), c_top)
    px = g.load()
    for y in range(S):
        t = y / (S-1)
        px_row = (
            int(c_top[0]*(1-t) + c_bot[0]*t),
            int(c_top[1]*(1-t) + c_bot[1]*t),
            int(c_top[2]*(1-t) + c_bot[2]*t),
        )
        for x in range(S):
            px[x, y] = px_row
    mask = Image.new("L", (S, S), 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle([0,0,S,S], radius=radius, fill=255)
    image.paste(g, (0,0), mask)

CORNER = int(S*0.22)
gradient_bg(icon, (216, 144, 108), (172, 88, 62), CORNER)

d = ImageDraw.Draw(icon, "RGBA")

# Soft sun disk
sun_cx, sun_cy, sun_r = S//2, int(S*0.42), int(S*0.21)
sun_layer = Image.new("RGBA", (S, S), (0,0,0,0))
sdl = ImageDraw.Draw(sun_layer)
sdl.ellipse([sun_cx-sun_r, sun_cy-sun_r, sun_cx+sun_r, sun_cy+sun_r],
            fill=(245, 210, 160, 215))
sun_layer = sun_layer.filter(ImageFilter.GaussianBlur(46))
icon.paste(sun_layer, (0,0), sun_layer)
# crisper inner sun
d.ellipse([sun_cx-int(sun_r*0.55), sun_cy-int(sun_r*0.55),
           sun_cx+int(sun_r*0.55), sun_cy+int(sun_r*0.55)],
          fill=(250, 222, 178, 110))

d = ImageDraw.Draw(icon, "RGBA")

# Geometry: L  A  L
ground_y  = int(S*0.78)
top_y     = int(S*0.30)
letter_h  = ground_y - top_y

col_w = int(S*0.20)
gap   = int(S*0.05)
total_w = col_w*3 + gap*2
left_x  = (S - total_w)//2

# ── L glyph (slab) ─────────────────────────────────────────────────
def draw_L(x):
    stem_w = int(col_w*0.30)
    foot_h = int(letter_h*0.22)
    d.rectangle([x, top_y, x+stem_w, ground_y], fill=PAPER)
    d.rectangle([x, ground_y - foot_h, x+col_w, ground_y], fill=PAPER)

draw_L(left_x)
draw_L(left_x + 2*(col_w+gap))

# ── A as three pyramids of Giza ─────────────────────────────────────
# Real Giza slope ≈ 52°. We position three pyramids staggered like the iconic skyline:
#   Khufu (biggest) — back left
#   Khafre (mid)    — middle, slightly forward (same height visually)
#   Menkaure (small)— front right
# The middle/central pyramid forms the A; a thin crossbar gives the letter its bar.

ax = left_x + col_w + gap
aw = col_w

def pyramid(cx, base_y, height, half_base, light=STONE_LIGHT, shade=STONE_SHADE):
    apex = (cx, base_y - height)
    bl   = (cx - half_base, base_y)
    br   = (cx + half_base, base_y)
    # lit (left) face
    d.polygon([apex, bl, br], fill=light)
    # shaded (right) face — apex, midpoint of base, base_r
    mid = (cx, base_y)
    d.polygon([apex, mid, br], fill=shade)
    return apex, bl, br

# Back-left (Khufu) — tallest
khufu_h    = int(letter_h*0.92)
khufu_half = int(aw*0.62)
khufu_cx   = ax + int(aw*0.30)
khufu_apex, khufu_bl, khufu_br = pyramid(khufu_cx, ground_y, khufu_h, khufu_half,
                                          light=STONE_LIGHT, shade=STONE_SHADE)

# Middle (Khafre) — slightly shorter, but appears same height (slight rise of bedrock)
khafre_h    = int(letter_h*0.86)
khafre_half = int(aw*0.55)
khafre_cx   = ax + int(aw*0.72)
khafre_apex, khafre_bl, khafre_br = pyramid(khafre_cx, ground_y, khafre_h, khafre_half,
                                              light=(252, 234, 204), shade=(210, 176, 130))

# Front-right (Menkaure) — smallest
menk_h    = int(letter_h*0.42)
menk_half = int(aw*0.32)
menk_cx   = ax + int(aw*1.05)
menk_apex, menk_bl, menk_br = pyramid(menk_cx, ground_y, menk_h, menk_half,
                                       light=(238, 216, 180), shade=(196, 160, 116))

# A's crossbar — small horizontal stroke across the middle (Khafre) pyramid,
# placed at the lower third like a true letter A.
def x_at_y(apex, base, y):
    if base[1] == apex[1]: return base[0]
    t = (y - apex[1]) / (base[1] - apex[1])
    return apex[0] + t * (base[0] - apex[0])

bar_y = ground_y - int(letter_h*0.30)
bar_xL = x_at_y(khafre_apex, khafre_bl, bar_y)
bar_xR = x_at_y(khafre_apex, khafre_br, bar_y)
inset = (bar_xR - bar_xL) * 0.18
bar_h = int(S*0.014)
d.rectangle([bar_xL+inset, bar_y - bar_h//2, bar_xR-inset, bar_y + bar_h//2],
            fill=TERRA_DARK)

# Tiny location pin atop Khafre's apex — "the local mark"
pin_cx, pin_cy = khafre_apex[0], khafre_apex[1] - int(S*0.028)
pin_r = int(S*0.018)
d.line([(pin_cx, khafre_apex[1]+2), (pin_cx, pin_cy+pin_r-2)], fill=TERRA_DARK, width=5)
d.ellipse([pin_cx-pin_r, pin_cy-pin_r, pin_cx+pin_r, pin_cy+pin_r], fill=TERRA_DARK)
# pin highlight
d.ellipse([pin_cx-int(pin_r*0.35), pin_cy-int(pin_r*0.35),
           pin_cx+int(pin_r*0.10), pin_cy+int(pin_r*0.10)],
          fill=(255, 220, 200, 200))

# Ground line — clean, single hairline
d.line([(left_x - int(S*0.02), ground_y),
        (left_x + total_w + int(S*0.02), ground_y)],
       fill=(255,255,255,160), width=3)

# ─── Presentation canvas ────────────────────────────────────────────
CW, CH = 2400, 3000
canvas = Image.new("RGB", (CW, CH), PAPER)
cd = ImageDraw.Draw(canvas, "RGBA")

# Faint grid
grid_color = (216, 222, 228, 70)
step = 60
for x in range(0, CW, step):
    cd.line([(x, 0), (x, CH)], fill=grid_color, width=1)
for y in range(0, CH, step):
    cd.line([(0, y), (CW, y)], fill=grid_color, width=1)

# Frame
cd.rectangle([120,120,CW-120,CH-120], outline=INK_300, width=2)
cd.rectangle([150,150,CW-150,CH-150], outline=(212,218,224), width=1)

# Header
def font(name, size):
    return ImageFont.truetype(f"{FONT_DIR}/{name}", size)
f_title  = font("InstrumentSerif-Italic.ttf", 200)
f_title2 = font("InstrumentSerif-Regular.ttf", 240)
f_meta   = font("GeistMono-Regular.ttf", 36)
f_meta_b = font("GeistMono-Bold.ttf", 36)

def tw(text, fnt):
    bb = cd.textbbox((0,0), text, font=fnt)
    return bb[2]-bb[0], bb[3]-bb[1]

header = "LIKE  A  LOCAL  ·  DISCOVER  EGYPT"
hw, _ = tw(header, f_meta)
cd.line([(CW//2 - 50, 220), (CW//2 + 50, 220)], fill=INK_500, width=2)
cd.text(((CW-hw)//2, 250), header, font=f_meta, fill=INK_500)

# Place icon centered with soft shadow
icon_size = 1500
icon_resized = icon.resize((icon_size, icon_size), Image.LANCZOS)
ix = (CW - icon_size)//2
iy = 540
sh = Image.new("RGBA", (CW, CH), (0,0,0,0))
shd = ImageDraw.Draw(sh)
shd.rounded_rectangle([ix+18, iy+38, ix+icon_size+18, iy+icon_size+38],
                       radius=int(icon_size*0.22), fill=(0,0,0,85))
sh = sh.filter(ImageFilter.GaussianBlur(30))
canvas.paste(sh, (0,0), sh)
mask = Image.new("L", (icon_size, icon_size), 0)
md = ImageDraw.Draw(mask)
md.rounded_rectangle([0,0,icon_size,icon_size], radius=int(icon_size*0.22), fill=255)
canvas.paste(icon_resized, (ix, iy), mask)

# Wordmark
t1, t2 = "like a", "Local"
w1, _ = tw(t1, f_title); w2, _ = tw(t2, f_title2)
gap_w = 28
total_w = w1 + gap_w + w2
ty = 2200
tx = (CW - total_w)//2
cd.text((tx, ty), t1, font=f_title, fill=INK_700)
cd.text((tx + w1 + gap_w, ty - 14), t2, font=f_title2, fill=INK_900)
cd.ellipse([tx + w1 + gap_w//2 - 6, ty + 56, tx + w1 + gap_w//2 + 12, ty + 74], fill=TERRACOTTA)

# Footer
foot = "CAIRO  ·  N 30°02′  E 31°08′"
fw, _ = tw(foot, f_meta_b)
cd.text(((CW-fw)//2, 2580), foot, font=f_meta_b, fill=INK_900)

cd.text((180, CH-160), "EST.  MMXXVI", font=f_meta, fill=INK_500)
ed = "Nº  01 / 01"
ew, _ = tw(ed, f_meta)
cd.text((CW-180-ew, CH-160), ed, font=f_meta, fill=INK_500)

canvas.save(r"C:/Users/youse/StudioProjects/like_a_local/design_output/lal_logo.png", "PNG", optimize=True)

# App-icon only (rounded square, transparent corners)
icon_only = icon.convert("RGBA")
icon_mask = Image.new("L", (S, S), 0)
mdm = ImageDraw.Draw(icon_mask)
mdm.rounded_rectangle([0,0,S,S], radius=CORNER, fill=255)
icon_only.putalpha(icon_mask)
icon_only.save(r"C:/Users/youse/StudioProjects/like_a_local/design_output/lal_app_icon.png", "PNG", optimize=True)
print("Done")
