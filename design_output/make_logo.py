"""Quiet Cartography — logo for 'Like a Local'."""
import math
from PIL import Image, ImageDraw, ImageFont, ImageFilter

FONT_DIR = r"C:/Users/youse/AppData/Roaming/Claude/local-agent-mode-sessions/skills-plugin/f2af91ee-c71a-4215-9ca4-7635131f3cb6/d5879f2b-b923-4572-9ce3-fb7db329f4ed/skills/canvas-design/canvas-fonts"

# Palette — paper, blue grays, terracotta
PAPER       = (246, 247, 248)
INK_900     = (28, 36, 46)
INK_700     = (66, 80, 96)
INK_500     = (122, 134, 148)
INK_300     = (188, 196, 205)
INK_200     = (212, 218, 224)
TERRACOTTA  = (201, 123, 92)
TERRA_DEEP  = (168, 95, 68)

W, H = 2400, 3000
img = Image.new("RGB", (W, H), PAPER)
d = ImageDraw.Draw(img, "RGBA")

# ─── subtle paper grid ──────────────────────────────────────────────
grid_color = (216, 222, 228, 70)
step = 60
for x in range(0, W, step):
    d.line([(x, 0), (x, H)], fill=grid_color, width=1)
for y in range(0, H, step):
    d.line([(0, y), (W, y)], fill=grid_color, width=1)

# Stronger axis cross marks (registration ticks) around the mark
cx, cy = W // 2, 1180
tick = 26
tick_col = (170, 180, 190, 200)
for (tx, ty) in [(cx, 220), (cx, 2100), (220, cy), (2180, cy)]:
    d.line([(tx - tick, ty), (tx + tick, ty)], fill=tick_col, width=2)
    d.line([(tx, ty - tick), (tx, ty + tick)], fill=tick_col, width=2)

# ─── the mark: a hand-drawn napkin map ──────────────────────────────
# A circle (the place), a soft meandering route ending at a terracotta pin.

# Outer ring — the "neighborhood" — thin, slightly open
ring_r = 520
ring_box = [cx - ring_r, cy - ring_r, cx + ring_r, cy + ring_r]
# draw as an arc with a tiny opening at top — "the way in"
d.arc(ring_box, start=275, end=265, fill=INK_900, width=10)

# Inner constellation: faint dotted contour, like a topographic line
inner_r = 380
inner_box = [cx - inner_r, cy - inner_r, cx + inner_r, cy + inner_r]
# dotted arc
N = 120
for i in range(N):
    a0 = 360 * i / N
    a1 = a0 + (360 / N) * 0.35
    d.arc(inner_box, start=a0, end=a1, fill=INK_300, width=4)

# A meandering route from edge to center pin — drawn as a smooth bezier-ish path
def smooth_path(points, samples=240):
    # Catmull-Rom through points
    def cr(p0, p1, p2, p3, t):
        t2, t3 = t*t, t*t*t
        x = 0.5*((2*p1[0]) + (-p0[0]+p2[0])*t + (2*p0[0]-5*p1[0]+4*p2[0]-p3[0])*t2 + (-p0[0]+3*p1[0]-3*p2[0]+p3[0])*t3)
        y = 0.5*((2*p1[1]) + (-p0[1]+p2[1])*t + (2*p0[1]-5*p1[1]+4*p2[1]-p3[1])*t2 + (-p0[1]+3*p1[1]-3*p2[1]+p3[1])*t3)
        return (x, y)
    out = []
    pts = [points[0]] + list(points) + [points[-1]]
    for i in range(len(pts)-3):
        for s in range(samples):
            t = s / samples
            out.append(cr(pts[i], pts[i+1], pts[i+2], pts[i+3], t))
    return out

# Entry from top opening, winding gently inward toward the pin (slightly off-center, lower-right of cx,cy)
pin = (cx + 90, cy + 60)
route_pts = [
    (cx, cy - ring_r + 4),
    (cx - 140, cy - 360),
    (cx - 260, cy - 120),
    (cx - 180, cy + 130),
    (cx + 30,  cy + 220),
    (cx + 170, cy + 130),
    pin,
]
path = smooth_path(route_pts, samples=60)

# Draw route as a soft, slightly imperfect ink line
for i in range(len(path) - 1):
    x0, y0 = path[i]
    x1, y1 = path[i+1]
    d.line([(x0, y0), (x1, y1)], fill=INK_700, width=7)

# A faint shadow under the route to give pencil-weight
shadow = Image.new("RGBA", (W, H), (0,0,0,0))
sd = ImageDraw.Draw(shadow)
for i in range(len(path) - 1):
    sd.line([path[i], path[i+1]], fill=(0,0,0,40), width=14)
shadow = shadow.filter(ImageFilter.GaussianBlur(6))
img.paste(shadow, (0,0), shadow)

# Small annotated dots along the route — places passed
anno_idx = [int(len(path)*f) for f in (0.18, 0.42, 0.66)]
for k, i in enumerate(anno_idx):
    px, py = path[i]
    d.ellipse([px-9, py-9, px+9, py+9], fill=PAPER, outline=INK_700, width=3)

# The pin — terracotta teardrop, single solid form, master-clean
def draw_pin(draw, x, y, size=120, color=TERRACOTTA):
    r = size
    # soft cast shadow (offset, blurred)
    sh = Image.new("RGBA", (W, H), (0,0,0,0))
    shd = ImageDraw.Draw(sh)
    shd.ellipse([x-r+10, y-r+r*0.65, x+r+10, y+r+r*0.95], fill=(0,0,0,70))
    sh2 = sh.filter(ImageFilter.GaussianBlur(22))
    img.paste(sh2, (0,0), sh2)

    # composite teardrop: triangle joined seamlessly with circle
    # Tangent points on the circle for a smooth join
    tail_tip = (x, y + r*1.85)
    # angle from center to tip
    import math as _m
    ang = _m.atan2(tail_tip[1]-y, tail_tip[0]-x)
    # tangent contact angles from a point outside a circle: theta = ang ± acos(r/d)
    d_pt = _m.hypot(tail_tip[0]-x, tail_tip[1]-y)
    phi = _m.acos(r / d_pt)
    aL = ang + phi
    aR = ang - phi
    L = (x + r*_m.cos(aL), y + r*_m.sin(aL))
    R = (x + r*_m.cos(aR), y + r*_m.sin(aR))
    draw.polygon([L, tail_tip, R], fill=color)
    draw.ellipse([x-r, y-r, x+r, y+r], fill=color)

    # inner negative space (paper) — the "place"
    ir = int(r*0.34)
    draw.ellipse([x-ir, y-ir, x+ir, y+ir], fill=PAPER)

draw_pin(d, pin[0], pin[1], size=120)

# A tiny secondary pin (the "local" — already there) just slightly off — a thin outlined ring
sec = (cx - 230, cy - 220)
d.ellipse([sec[0]-22, sec[1]-22, sec[0]+22, sec[1]+22], outline=INK_900, width=5)
d.ellipse([sec[0]-6, sec[1]-6, sec[0]+6, sec[1]+6], fill=INK_900)

# ─── typography ─────────────────────────────────────────────────────
def font(name, size):
    return ImageFont.truetype(f"{FONT_DIR}/{name}", size)

f_title  = font("InstrumentSerif-Italic.ttf", 240)   # "like a"
f_title2 = font("InstrumentSerif-Regular.ttf", 300)  # "Local"
f_meta   = font("GeistMono-Regular.ttf", 38)
f_meta_b = font("GeistMono-Bold.ttf", 38)

# Wordmark: "like a Local" — italic + roman tension
# Compose centered
title1 = "like a"
title2 = "Local"

def text_w(text, fnt):
    bb = d.textbbox((0,0), text, font=fnt)
    return bb[2]-bb[0], bb[3]-bb[1]

w1, h1 = text_w(title1, f_title)
w2, h2 = text_w(title2, f_title2)

gap = 30
total_w = w1 + gap + w2
ty = 1880
tx = (W - total_w) // 2
d.text((tx, ty), title1, font=f_title, fill=INK_700)
d.text((tx + w1 + gap, ty - 16), title2, font=f_title2, fill=INK_900)

# Terracotta dot — quiet accent, set on the cap-line midpoint between words
dot_x = tx + w1 + gap // 2 + 4
dot_y = ty + 70
d.ellipse([dot_x-10, dot_y-10, dot_x+10, dot_y+10], fill=TERRACOTTA)

# ─── header & footer micro-typography ───────────────────────────────
# Header tag (clinical cartographer's stamp)
header = "QUIET  CARTOGRAPHY  ·  PL. I"
hw, hh = text_w(header, f_meta)
d.text(((W-hw)//2, 280), header, font=f_meta, fill=INK_500)

# Tiny rule above header
d.line([(W//2 - 60, 250), (W//2 + 60, 250)], fill=INK_500, width=2)

# Footer — coordinates & ethos
foot1 = "N 41°23′  ·  E 02°09′"
foot2 = "FIND  IT  ·  LIVE  IT  ·  LIKE  A  LOCAL"

fw1, fh1 = text_w(foot1, f_meta)
fw2, fh2 = text_w(foot2, f_meta_b)
d.text(((W-fw1)//2, 2380), foot1, font=f_meta, fill=INK_500)
d.text(((W-fw2)//2, 2470), foot2, font=f_meta_b, fill=INK_900)

# Edition marker at bottom corners
d.text((180, H-160), "EST.  MMXXVI", font=f_meta, fill=INK_500)
ed_text = "Nº  01 / 01"
ew, eh = text_w(ed_text, f_meta)
d.text((W - 180 - ew, H-160), ed_text, font=f_meta, fill=INK_500)

# Thin frame, generous margin
frame_m = 120
d.rectangle([frame_m, frame_m, W-frame_m, H-frame_m], outline=INK_300, width=2)
# Inner finer frame
fm2 = 150
d.rectangle([fm2, fm2, W-fm2, H-fm2], outline=INK_200, width=1)

out = r"C:/Users/youse/StudioProjects/like_a_local/design_output/like_a_local_logo.png"
img.save(out, "PNG", optimize=True)
print("Saved:", out)
