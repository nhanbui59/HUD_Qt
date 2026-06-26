#pragma once

#include <QString>
#include <QColor>
#include <utility>

namespace QHUD {
namespace MapConfig {

// ── Tile Source ───────────────────────────────────────────────────
inline const QString TILE_URL =
    QStringLiteral("https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json");

// mapboxgl plugin style URL (Carto Dark Matter)
constexpr const char* MAPBOXGL_STYLE_URL =
    "https://basemaps.cartocdn.com/gl/dark-matter-gl-style/style.json";

// ── Map View ──────────────────────────────────────────────────────
constexpr double  DEFAULT_ZOOM         = 17.5;
constexpr double  DEFAULT_PITCH        = 60.0;
constexpr double  MIN_ZOOM             = 15.0;
constexpr double  MAX_ZOOM             = 19.0;

// ── Route Line ────────────────────────────────────────────────────
constexpr double  ROUTE_GLOW_WIDTH     = 12.0;
constexpr double  ROUTE_CORE_WIDTH     = 6.0;
constexpr double  ROUTE_GLOW_OPACITY   = 0.3;
constexpr double  ROUTE_GLOW_BLUR      = 10.0;

// ── Label Coordinates (from Map.tsx labelsGeoJSON) ─────────────────
inline const std::pair<double, double> LABEL_BITEXCO_TOWER = {106.7052, 10.7716};
inline const std::pair<double, double> LABEL_NGUYEN_HUE    = {106.7030, 10.7730};
inline const std::pair<double, double> LABEL_HAM_NGHI      = {106.7035, 10.7710};
inline const std::pair<double, double> LABEL_HO_TUNG_MAU   = {106.7045, 10.7725};

// ── Label Style ───────────────────────────────────────────────────
constexpr int     LABEL_FONT_SIZE      = 14;
inline const QColor LABEL_TEXT_COLOR   = QColor(0xA3, 0xA3, 0xA3);
inline const QColor LABEL_HALO_COLOR   = QColor(0x17, 0x17, 0x17);
constexpr double  LABEL_HALO_WIDTH     = 2.0;

// ── Map Interaction ───────────────────────────────────────────────
constexpr bool    MAP_INTERACTIVE      = false;

// ── Destination ───────────────────────────────────────────────────
// Last coordinate of the route
inline const std::pair<double, double> DESTINATION = {106.705199, 10.771564};

} // namespace MapConfig
} // namespace QHUD
