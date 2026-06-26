#pragma once

#include <QString>
#include <vector>

namespace QHUD {

// ── Location ───────────────────────────────────────────────────
struct Location {
    double lng = 0.0;
    double lat = 0.0;
};

// ── Turn Maneuver Enum ─────────────────────────────────────────
// Mirrors the TypeScript union type from types.ts
enum class TurnManeuver {
    Left,
    Right,
    Straight,
    Arrive,
    Roundabout,
    UTurnLeft,
    SharpLeft,
    SharpRight,
    SlightRight,
    SlightLeft
};

// ── Route Point ────────────────────────────────────────────────
struct RoutePoint {
    double lng = 0.0;
    double lat = 0.0;
};

// ── Telemetry Data ─────────────────────────────────────────────
// All fields mirror the TelemetryData interface from types.ts
// QString is used for string fields — the ONLY Qt dependency in model layer
struct TelemetryData {
    double        speed                 = 0.0;
    double        speedLimit            = 0.0;
    double        nextTurnDistance      = 0.0;   // km
    QString       nextTurnStreet;
    TurnManeuver  nextTurnManeuver      = TurnManeuver::Straight;
    QString       currentStreet;
    double        totalDistanceRemaining = 0.0;  // km
    QString       eta;
    double        fuelLevel             = 0.0;    // 0-100%
    double        fuelRange             = 0.0;    // km
    int           odometer              = 0;
    bool          isEcoMode             = false;
    bool          isHeadlightsOn        = false;
    bool          isDoorOpenWarning     = false;
    bool          isLaneAssistOn        = false;
    Location      location;
    double        heading               = 0.0;    // degrees 0-360
    std::vector<RoutePoint> route;                // upcoming segments
};

// ── Turn Detection Result ──────────────────────────────────────
struct TurnDetection {
    TurnManeuver maneuver = TurnManeuver::Straight;
    double       distanceKm = 0.0;
    bool         found = false;
};

// ── Location-at-Progress Result ────────────────────────────────
struct LocationAtProgress {
    RoutePoint   point;
    int          segmentIndex = 0;
};

} // namespace QHUD
