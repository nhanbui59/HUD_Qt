#pragma once

#include <QColor>

namespace QHUD {
namespace ThemeConfig {

// ── Background Colors ────────────────────────────────────────────
inline const QColor BACKGROUND_DEEP      = QColor(0x0A, 0x0A, 0x0A);  // #0a0a0a
inline const QColor DASHBOARD_BG_START   = QColor(0x05, 0x05, 0x08);  // #050508
inline const QColor DASHBOARD_BG_END     = QColor(0x12, 0x15, 0x1C);  // #12151c
inline const QColor MEDIA_BG_START       = QColor(0x1A, 0x1A, 0x2E);  // #1a1a2e
inline const QColor MEDIA_BG_END         = QColor(0x0F, 0x0F, 0x1A);  // #0f0f1a

// ── Accent Colors ────────────────────────────────────────────────
inline const QColor BLUE                 = QColor(0x3B, 0x82, 0xF6);  // #3b82f6
inline const QColor BLUE_DARK            = QColor(0x25, 0x63, 0xEB);  // #2563eb
inline const QColor CYAN                 = QColor(0x00, 0xF0, 0xFF);  // #00f0ff
inline const QColor GREEN                = QColor(0x22, 0xC5, 0x5E);  // #22c55e
inline const QColor GREEN_LIGHT          = QColor(0x4A, 0xDE, 0x80);  // #4ade80
inline const QColor RED                  = QColor(0xEF, 0x44, 0x44);  // #ef4444
inline const QColor RED_DARK             = QColor(0xDC, 0x26, 0x26);  // #dc2626
inline const QColor PURPLE               = QColor(0x8B, 0x5C, 0xF6);  // #8b5cf6
inline const QColor PURPLE_LIGHT         = QColor(0xA8, 0x55, 0xF7);  // #a855f7
inline const QColor PINK                 = QColor(0xEC, 0x48, 0x99);  // #ec4899
inline const QColor AMBER                = QColor(0xF5, 0x9E, 0x0B);  // #f59e0b

// ── Route Colors ─────────────────────────────────────────────────
inline const QColor ROUTE_GLOW           = QColor(0x4A, 0xDE, 0x80);  // #4ade80
inline const QColor ROUTE_CORE           = QColor(0x22, 0xC5, 0x5E);  // #22c55e

// ── Text Colors ──────────────────────────────────────────────────
inline const QColor TEXT_WHITE           = QColor(0xFF, 0xFF, 0xFF);
inline const QColor TEXT_GRAY_300        = QColor(0xD1, 0xD5, 0xDB);
inline const QColor TEXT_GRAY_400        = QColor(0x9C, 0xA3, 0xAF);
inline const QColor TEXT_GRAY_500        = QColor(0x6B, 0x72, 0x80);
inline const QColor TEXT_BLUE_400        = QColor(0x60, 0xA5, 0xFA);

// ── Panel Glass Colors ───────────────────────────────────────────
inline const QColor GLASS_BG             = QColor(0xFF, 0xFF, 0xFF, 25);   // white/10
inline const QColor GLASS_BORDER         = QColor(0xFF, 0xFF, 0xFF, 12);   // white/5
inline const QColor GLASS_BG_DARK        = QColor(0x00, 0x00, 0x00, 51);   // black/20
inline const QColor GLASS_BORDER_DARK    = QColor(0xFF, 0xFF, 0xFF, 12);   // white/5

// ── Button States ────────────────────────────────────────────────
inline const QColor BUTTON_HOVER_BG      = QColor(0xFF, 0xFF, 0xFF, 12);   // white/5
inline const QColor BUTTON_ACTIVE_BG     = QColor(0xFF, 0xFF, 0xFF, 25);   // white/10
inline const QColor BUTTON_ACTIVE_BORDER = QColor(0xFF, 0xFF, 0xFF, 25);

// ── Car Marker Colors ────────────────────────────────────────────
inline const QColor CAR_BODY_TOP         = QColor(0x5E, 0xE9, 0xFF);  // teal-300
inline const QColor CAR_BODY_MID         = QColor(0x22, 0xD3, 0xEE);  // cyan-400
inline const QColor CAR_BODY_BOTTOM      = QColor(0x25, 0x63, 0xEB);  // blue-600
inline const QColor CAR_DEPTH            = QColor(0x1E, 0x3A, 0x8A);  // blue-900
inline const QColor CAR_THRUST_GLOW      = QColor(0x22, 0xD3, 0xEE);  // cyan-400
inline const QColor CAR_RADAR_RING       = QColor(0x00, 0xF0, 0xFF);  // cyan

// ── Dashboard Gauge Colors ───────────────────────────────────────
inline const QColor GAUGE_TRACK_BG       = QColor(0xFF, 0xFF, 0xFF, 25);  // white/10
inline const QColor GAUGE_FILL           = QColor(0x3B, 0x82, 0xF6);       // blue
inline const QColor GAUGE_DANGER         = QColor(0xEF, 0x44, 0x44);       // red

// ── Destination Marker ───────────────────────────────────────────
inline const QColor DEST_MARKER_BG       = QColor(0x25, 0x63, 0xEB);  // blue-600
inline const QColor DEST_MARKER_BORDER   = QColor(0x93, 0xC5, 0xFD);  // blue-300
inline const QColor DEST_MARKER_INNER    = QColor(0xFF, 0xFF, 0xFF);

// ── Vignette Overlay ─────────────────────────────────────────────
inline const QColor VIGNETTE_CENTER      = QColor(0x00, 0x00, 0x00, 0);
inline const QColor VIGNETTE_MID         = QColor(0x0F, 0x17, 0x2A, 102);  // slate-900/40
inline const QColor VIGNETTE_EDGE        = QColor(0x02, 0x06, 0x17, 230);  // slate-950/90

// ── Media Screen Accents ─────────────────────────────────────────
inline const QColor MEDIA_BLUR_PURPLE    = QColor(0x93, 0x33, 0xEA, 51);   // purple-600/20
inline const QColor MEDIA_BLUR_BLUE      = QColor(0x25, 0x63, 0xEB, 51);   // blue-600/20
inline const QColor MEDIA_PROGRESS_START = QColor(0xA8, 0x55, 0xF7);       // purple-500
inline const QColor MEDIA_PROGRESS_END   = QColor(0x3B, 0x82, 0xF6);       // blue-500

// ── Misc ─────────────────────────────────────────────────────────
inline const QColor SPEED_LIMIT_BG       = QColor(0xEF, 0x44, 0x44);       // red badge
inline const QColor SPEED_LIMIT_GLOW     = QColor(0xEF, 0x44, 0x44, 102);  // red glow
inline const QColor DOOR_WARNING_RED     = QColor(0xEF, 0x44, 0x44);

} // namespace ThemeConfig
} // namespace QHUD
