#pragma once

#include <QString>
#include <vector>

namespace QHUD {
namespace AppConfig {

// ── Embedded Display ────────────────────────────────────────────────
constexpr int DISPLAY_WIDTH       = 1024;
constexpr int DISPLAY_HEIGHT      = 600;
constexpr int MIN_DISPLAY_WIDTH   = 800;
constexpr int MIN_DISPLAY_HEIGHT  = 480;

// ── Route Coordinates (29-point HCMC route) ────────────────────────
// Ported from TelemetryService.ts ROUTE_COORDINATES
extern const std::vector<std::pair<double, double>> ROUTE_COORDINATES;

// ── Speed ──────────────────────────────────────────────────────────
constexpr double MIN_SPEED           = 40.0;   // km/h — lower clamp
constexpr double MAX_SPEED           = 52.0;   // km/h — upper clamp
constexpr double INITIAL_SPEED       = 46.0;   // km/h — starting speed
constexpr double SPEED_FLUCTUATION   = 1.0;    // ±1 km/h per second

constexpr double INITIAL_SPEED_LIMIT = 50.0;   // km/h

// ── Simulation Timing ──────────────────────────────────────────────
constexpr int    ROUTE_DURATION_MS   = 60000;  // 60s for full route loop
constexpr int    SIMULATION_INTERVAL_MS = 16;  // ~60fps
constexpr double ETA_MAX_SECONDS     = 240.0;  // 4 minutes max
constexpr double TOTAL_DISTANCE_FACTOR = 2.5;  // fake total distance scaling

// ── Heading Smoothing ──────────────────────────────────────────────
constexpr double HEADING_SMOOTH_FACTOR = 0.05;       // exponential smoothing alpha
constexpr double LOOKAHEAD_DISTANCE    = 0.00015;    // lookahead for heading calc

// ── Turn Detection ─────────────────────────────────────────────────
constexpr double TURN_MIN_ANGLE_DEG   = 25.0;   // min angle diff for turn classification
constexpr double TURN_RIGHT_ANGLE     = 70.0;   // right turn threshold
constexpr double TURN_LEFT_ANGLE      = -70.0;  // left turn threshold

// ── Distance Conversion ────────────────────────────────────────────
constexpr double DEG_TO_KM           = 111.32;  // degrees → km (rough)
constexpr double NEAR_END_THRESHOLD  = 0.00005; // near end-of-route tolerance
constexpr double MIN_DISPLAY_DISTANCE = 0.1;    // minimum displayed distance (km)

// ── Initial Telemetry Values ───────────────────────────────────────
constexpr double INITIAL_FUEL_LEVEL   = 50.0;
constexpr double INITIAL_FUEL_RANGE   = 16.0;
constexpr int    INITIAL_ODOMETER     = 13372;
constexpr bool   INITIAL_ECO_MODE     = true;
constexpr bool   INITIAL_HEADLIGHTS   = true;
constexpr bool   INITIAL_DOOR_WARNING = false;
constexpr bool   INITIAL_LANE_ASSIST  = true;

// ── Street Names ───────────────────────────────────────────────────
extern const QString STREET_LE_THANH_TON;
extern const QString STREET_NGUYEN_HUE;
extern const QString STREET_TON_DUC_THANG;
extern const QString STREET_HAI_TRIEU;
extern const QString STREET_HAI_TRIEU_BITEXCO;
extern const QString STREET_DESTINATION;
extern const QString STREET_BITEXCO_TOWER;
extern const QString INITIAL_NEXT_TURN_STREET;
extern const QString INITIAL_ETA;

// ── Segment Index Ranges for Street Changes ─────────────────────────
// Route has 29 vertices → 28 segments (indices 0–27)
// Segments 0–3:    Lê Thánh Tôn → next Nguyễn Huệ
// Segments 4–23:   Nguyễn Huệ  → next Tôn Đức Thắng
// Segments 24–25:  Tôn Đức Thắng → next Hải Triều
// Segments 26–27:  Hải Triều (Bitexco) → next Đích đến
constexpr int SEGMENT_NGUYEN_HUE_START    = 4;
constexpr int SEGMENT_TON_DUC_THANG_START = 24;
constexpr int SEGMENT_HAI_TRIEU_START     = 26;
constexpr int SEGMENT_COUNT               = 28; // total segments

} // namespace AppConfig
} // namespace QHUD
