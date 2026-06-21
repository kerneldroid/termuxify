#!/usr/bin/env python3
"""
Material You Palette Generator — Simplified but Working
Uses HSL color space with chroma-aware palette generation.
Supports all 10 Monet styles.
"""

import sys
import json
import math
import colorsys

# ─── Color Conversions ────────────────────────────────────────────────────────

def hex_to_rgb(h):
    h = h.lstrip('#')
    if len(h) == 8:
        h = h[2:]
    return tuple(int(h[i:i+2], 16) for i in (0, 2, 4))

def rgb_to_hex(r, g, b):
    return '{:02X}{:02X}{:02X}'.format(
        max(0, min(255, int(round(r)))),
        max(0, min(255, int(round(g)))),
        max(0, min(255, int(round(b))))
    )

def hex_to_hsl(h):
    r, g, b = hex_to_rgb(h)
    hue, l, s = colorsys.rgb_to_hls(r/255, g/255, b/255)
    return hue * 360, s, l

def hsl_to_hex(hue, sat, light):
    hue = hue % 360
    sat = max(0, min(1, sat))
    light = max(0, min(1, light))
    r, g, b = colorsys.hls_to_rgb(hue/360, light, sat)
    return rgb_to_hex(r*255, g*255, b*255)

def hsl_to_rgb(hue, sat, light):
    hue = hue % 360
    sat = max(0, min(1, sat))
    light = max(0, min(1, light))
    r, g, b = colorsys.hls_to_rgb(hue/360, light, sat)
    return r*255, g*255, b*255

# ─── Perceptual Lightness (L*) ────────────────────────────────────────────────

def srgb_to_linear(c):
    c = c / 255.0
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def linear_to_srgb(c):
    c = max(0.0, min(1.0, c))
    return 12.92 * c if c <= 0.0031308 else 1.055 * c ** (1/2.4) - 0.055

def rgb_to_lstar(r, g, b):
    lr, lg, lb = srgb_to_linear(r/255), srgb_to_linear(g/255), srgb_to_linear(b/255)
    y = 0.2126 * lr + 0.7152 * lg + 0.0722 * lb
    if y <= 216 / 24389:
        return y * 24389 / 27
    return 116 * (y ** (1/3)) - 16

def lstar_to_y(lstar):
    if lstar <= 8:
        return lstar * 27 / 24389
    f = (lstar + 16) / 116
    return f ** 3

def lstar_to_rgb(lstar):
    """Convert L* to grayscale RGB."""
    y = lstar_to_y(lstar) * 100
    r = linear_to_srgb(y / 100) * 255
    g = r
    b = r
    return max(0, min(255, int(round(r)))), max(0, min(255, int(round(g)))), max(0, min(255, int(round(b))))

# ─── Tone Mapping ─────────────────────────────────────────────────────────────

def tone_to_lightness(tone):
    """Map Material You tone (0-100) to HSL lightness with proper contrast."""
    if tone <= 0:
        return 0.0
    if tone >= 100:
        return 1.0
    return tone / 100.0

def tone_to_saturation(tone, base_sat):
    """Adjust saturation based on tone for better contrast."""
    if tone < 20:
        return base_sat * 0.3
    elif tone < 40:
        return base_sat * 0.6
    elif tone < 60:
        return base_sat * 0.8
    elif tone < 80:
        return base_sat * 0.9
    else:
        return base_sat * 0.7

# ─── Material You Palette Generation ──────────────────────────────────────────

STYLES = {
    'TONAL_SPOT': {
        'primary_chroma': 0.48,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.16,
        'secondary_hue_shift': 15,
        'tertiary_chroma': 0.24,
        'tertiary_hue_shift': 60,
        'neutral_chroma': 0.06,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.08,
        'neutralVariant_hue_shift': 0,
    },
    'VIBRANT': {
        'primary_chroma': 0.70,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.30,
        'secondary_hue_shift': 15,
        'tertiary_chroma': 0.40,
        'tertiary_hue_shift': 60,
        'neutral_chroma': 0.10,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.12,
        'neutralVariant_hue_shift': 0,
    },
    'EXPRESSIVE': {
        'primary_chroma': 0.60,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.25,
        'secondary_hue_shift': 45,
        'tertiary_chroma': 0.35,
        'tertiary_hue_shift': 120,
        'neutral_chroma': 0.08,
        'neutral_hue_shift': 15,
        'neutralVariant_chroma': 0.12,
        'neutralVariant_hue_shift': 15,
    },
    'SPRITZ': {
        'primary_chroma': 0.12,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.08,
        'secondary_hue_shift': 15,
        'tertiary_chroma': 0.12,
        'tertiary_hue_shift': 60,
        'neutral_chroma': 0.02,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.04,
        'neutralVariant_hue_shift': 0,
    },
    'RAINBOW': {
        'primary_chroma': 0.48,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.16,
        'secondary_hue_shift': 15,
        'tertiary_chroma': 0.24,
        'tertiary_hue_shift': 60,
        'neutral_chroma': 0.0,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.0,
        'neutralVariant_hue_shift': 0,
    },
    'FRUIT_SALAD': {
        'primary_chroma': 0.55,
        'primary_hue_shift': -50,
        'secondary_chroma': 0.40,
        'secondary_hue_shift': -50,
        'tertiary_chroma': 0.40,
        'tertiary_hue_shift': 0,
        'neutral_chroma': 0.10,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.16,
        'neutralVariant_hue_shift': 0,
    },
    'MONOCHROMATIC': {
        'primary_chroma': 0.0,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.0,
        'secondary_hue_shift': 0,
        'tertiary_chroma': 0.0,
        'tertiary_hue_shift': 0,
        'neutral_chroma': 0.0,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.0,
        'neutralVariant_hue_shift': 0,
    },
    'NEUTRAL': {
        'primary_chroma': 0.12,
        'primary_hue_shift': 0,
        'secondary_chroma': 0.08,
        'secondary_hue_shift': 0,
        'tertiary_chroma': 0.16,
        'tertiary_hue_shift': 0,
        'neutral_chroma': 0.02,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': 0.02,
        'neutralVariant_hue_shift': 0,
    },
    'CONTENT': {
        'primary_chroma': None,
        'primary_hue_shift': 0,
        'secondary_chroma': None,
        'secondary_hue_shift': 0,
        'tertiary_chroma': None,
        'tertiary_hue_shift': 60,
        'neutral_chroma': None,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': None,
        'neutralVariant_hue_shift': 0,
    },
    'FIDELITY': {
        'primary_chroma': None,
        'primary_hue_shift': 0,
        'secondary_chroma': None,
        'secondary_hue_shift': 0,
        'tertiary_chroma': None,
        'tertiary_hue_shift': 60,
        'neutral_chroma': None,
        'neutral_hue_shift': 0,
        'neutralVariant_chroma': None,
        'neutralVariant_hue_shift': 0,
    },
}

TONE_VALUES = [0, 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 95, 98, 99, 100]

def generate_palette(seed_hex, variant='TONAL_SPOT'):
    """Generate all Material You tonal palettes from a seed color."""
    seed_h, seed_s, seed_l = hex_to_hsl(seed_hex)
    params = STYLES.get(variant, STYLES['TONAL_SPOT'])

    palettes = {}

    for palette_name in ['primary', 'secondary', 'tertiary', 'neutral', 'neutralVariant']:
        hue_key = f'{palette_name}_hue_shift'
        chroma_key = f'{palette_name}_chroma'
        if hue_key not in params:
            hue_key = 'neutral_hue_shift'
            chroma_key = 'neutral_chroma'
        hue = (seed_h + params[hue_key]) % 360
        if params[chroma_key] is not None:
            sat = params[chroma_key]
        else:
            sat = seed_s * 0.8

        tones = {}
        for tone in TONE_VALUES:
            light = tone_to_lightness(tone)
            adjusted_sat = tone_to_saturation(tone, sat)
            tones[tone] = hsl_to_hex(hue, adjusted_sat, light)
        palettes[palette_name] = tones

    return palettes

def generate_termux_colors(seed_hex, variant='TONAL_SPOT'):
    """Generate Termux colors.properties format from seed."""
    palettes = generate_palette(seed_hex, variant)

    p = palettes['primary']
    s = palettes['secondary']
    t = palettes['tertiary']
    n = palettes['neutral']
    nv = palettes['neutralVariant']

    return {
        'background': '#' + n[90],
        'foreground': '#' + nv[100],
        'cursor': '#' + p[40],
        'color0': '#' + n[0],
        'color1': '#' + p[40],
        'color2': '#' + t[40],
        'color3': '#' + s[40],
        'color4': '#' + p[60],
        'color5': '#' + t[60],
        'color6': '#' + s[60],
        'color7': '#' + nv[100],
        'color8': '#' + n[30],
        'color9': '#' + p[70],
        'color10': '#' + t[70],
        'color11': '#' + s[70],
        'color12': '#' + p[80],
        'color13': '#' + t[80],
        'color14': '#' + s[80],
        'color15': '#' + n[100],
    }

def generate_overlay_resources(seed_hex, variant='TONAL_SPOT'):
    """Generate overlay resource map."""
    palettes = generate_palette(seed_hex, variant)
    resources = {}

    prefix_map = {
        'primary': 'system_accent1',
        'secondary': 'system_accent2',
        'tertiary': 'system_accent3',
        'neutral': 'system_neutral1',
        'neutralVariant': 'system_neutral2',
    }

    for palette_name, prefix in prefix_map.items():
        tones = palettes[palette_name]
        for tone, hex_val in tones.items():
            resources[f'{prefix}_{tone}'] = 'FF' + hex_val

    return resources

def generate_settings_json(seed_hex, variant='TONAL_SPOT'):
    """Generate Settings.Secure JSON."""
    return json.dumps({
        'android.theme.customization.system_palette': seed_hex.lstrip('#').upper(),
        'android.theme.customization.color_source': 'preset',
        'android.theme.customization.color_index': 0,
        'android.theme.customization.theme_style': variant,
        '_applied_timestamp': int(__import__('time').time() * 1000),
    })

# ─── CLI ──────────────────────────────────────────────────────────────────────

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: material_palette.py <seed_hex> [variant] [format]")
        print("  seed_hex: #RRGGBB or RRGGBB")
        print("  variant: TONAL_SPOT, VIBRANT, EXPRESSIVE, SPRITZ, NEUTRAL,")
        print("           MONOCHROMATIC, CONTENT, FIDELITY, RAINBOW, FRUIT_SALAD")
        print("  format: termux (default), overlay, json, settings")
        sys.exit(1)

    seed = sys.argv[1]
    variant = sys.argv[2] if len(sys.argv) > 2 else 'TONAL_SPOT'
    fmt = sys.argv[3] if len(sys.argv) > 3 else 'termux'

    if not seed.startswith('#'):
        seed = '#' + seed

    if fmt == 'termux':
        colors = generate_termux_colors(seed, variant)
        lines = []
        for key in ['background', 'foreground', 'cursor'] + [f'color{i}' for i in range(16)]:
            lines.append(f'{key}={colors[key]}')
        print('\n'.join(lines))

    elif fmt == 'overlay':
        resources = generate_overlay_resources(seed, variant)
        for name, value in sorted(resources.items()):
            print(f'{name}=#{value}')

    elif fmt == 'settings':
        print(generate_settings_json(seed, variant))

    elif fmt == 'json':
        result = {
            'seed': seed,
            'variant': variant,
            'palettes': generate_palette(seed, variant),
            'termux': generate_termux_colors(seed, variant),
            'overlay_count': len(generate_overlay_resources(seed, variant)),
        }
        print(json.dumps(result, indent=2))
