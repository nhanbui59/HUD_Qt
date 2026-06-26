#pragma once

#include "model/TelemetryTypes.h"
#include <vector>
#include <cmath>

namespace QHUD {

// ── RouteCalculator ──────────────────────────────────────────────
// Stateless math class. Ports the route-math logic from
// TelemetryService.ts exactly — same formulas, same angle detection.
//
// All thresholds come from config/AppConfig.h — ZERO magic numbers.
class RouteCalculator {
public:
    RouteCalculator() = delete;

    // Haversine-style distance (in degrees) between two points
    static double calculateDistance(const RoutePoint& p1, const RoutePoint& p2);

    // Bearing from p1→p2 in degrees [0, 360)
    static double calculateHeading(const RoutePoint& p1, const RoutePoint& p2);

    // Linear interpolation between two points
    static RoutePoint interpolatePoint(double t, const RoutePoint& p1, const RoutePoint& p2);

    // Find the interpolated position at a given length along the route.
    // Returns the nearest point AND the segment index.
    static LocationAtProgress getPointAtLength(double length,
                                               const std::vector<RoutePoint>& route,
                                               double totalLength,
                                               const std::vector<double>& segmentLengths);

    // Detect the next significant turn ahead from a given segment index.
    // angleDiff > 25° → turn; > 70° → right; < -70° → left.
    static TurnDetection detectNextTurn(const std::vector<RoutePoint>& route,
                                        int startIdx);

    // Exponential smoothing for heading with angle wraparound.
    // Returns the smoothed heading value.
    static double smoothHeading(double raw, double previous, double factor);

    // Normalize heading to [0, 360)
    static double normalizeHeading(double h);

    // Compute total route length and segment lengths from route points
    static double computeTotalLength(const std::vector<RoutePoint>& route,
                                     std::vector<double>& outSegmentLengths);
};

} // namespace QHUD
