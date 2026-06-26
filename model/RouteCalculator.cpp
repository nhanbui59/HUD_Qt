#include "model/RouteCalculator.h"
#include "config/AppConfig.h"
#include <algorithm>

namespace QHUD {

// ── calculateDistance ──────────────────────────────────────────
// Matches TelemetryService.ts calculateDistance() exactly:
//   sqrt((lng1-lng2)^2 + (lat1-lat2)^2)
double RouteCalculator::calculateDistance(const RoutePoint& p1, const RoutePoint& p2)
{
    const double dx = p1.lng - p2.lng;
    const double dy = p1.lat - p2.lat;
    return std::sqrt(dx * dx + dy * dy);
}

// ── calculateHeading ───────────────────────────────────────────
// Matches TelemetryService.ts calculateHeading():
//   atan2(lng2-lng1, lat2-lat1) * (180/PI)
// Returns degrees in [0, 360)
double RouteCalculator::calculateHeading(const RoutePoint& p1, const RoutePoint& p2)
{
    const double dx = p2.lng - p1.lng;
    const double dy = p2.lat - p1.lat;
    double h = std::atan2(dx, dy) * (180.0 / M_PI);
    return normalizeHeading(h);
}

// ── interpolatePoint ───────────────────────────────────────────
// t in [0, 1] — linear interpolation between p1 and p2
RoutePoint RouteCalculator::interpolatePoint(double t,
                                              const RoutePoint& p1,
                                              const RoutePoint& p2)
{
    return {
        p1.lng + (p2.lng - p1.lng) * t,
        p1.lat + (p2.lat - p1.lat) * t
    };
}

// ── computeTotalLength ─────────────────────────────────────────
double RouteCalculator::computeTotalLength(const std::vector<RoutePoint>& route,
                                            std::vector<double>& outSegmentLengths)
{
    outSegmentLengths.clear();
    double total = 0.0;
    for (size_t i = 0; i + 1 < route.size(); ++i) {
        const double len = calculateDistance(route[i], route[i + 1]);
        outSegmentLengths.push_back(len);
        total += len;
    }
    return total;
}

// ── getPointAtLength ───────────────────────────────────────────
// Linear search through segments (same algorithm as web).
// Returns nearest point + segment index.
LocationAtProgress RouteCalculator::getPointAtLength(double length,
                                                      const std::vector<RoutePoint>& route,
                                                      double totalLength,
                                                      const std::vector<double>& segmentLengths)
{
    if (route.empty()) return {};

    if (length <= 0.0)
        return { route.front(), 0 };

    if (length >= totalLength)
        return { route.back(), static_cast<int>(route.size()) - 1 };

    double curLen = 0.0;
    for (size_t i = 0; i < segmentLengths.size(); ++i) {
        if (curLen + segmentLengths[i] >= length) {
            const double segProg = (length - curLen) / segmentLengths[i];
            return {
                interpolatePoint(segProg, route[i], route[i + 1]),
                static_cast<int>(i)
            };
        }
        curLen += segmentLengths[i];
    }

    return { route.back(), static_cast<int>(route.size()) - 1 };
}

// ── detectNextTurn ─────────────────────────────────────────────
// Matches the turn-detection logic from TelemetryService.ts:
//   angleDiff > 25° → turn; > 70° → right; < -70° → left; etc.
TurnDetection RouteCalculator::detectNextTurn(const std::vector<RoutePoint>& route,
                                                int startIdx)
{
    TurnDetection result;
    result.found = false;
    result.maneuver = TurnManeuver::Arrive;

    if (startIdx < 0 || static_cast<size_t>(startIdx) + 2 >= route.size())
        return result;

    double distToTurn = 0.0;

    for (int i = startIdx; i < static_cast<int>(route.size()) - 2; ++i) {
        const RoutePoint& p1 = route[i];
        const RoutePoint& p2 = route[i + 1];
        const RoutePoint& p3 = route[i + 2];

        distToTurn += calculateDistance(p1, p2) * AppConfig::DEG_TO_KM;

        double h1 = calculateHeading(p1, p2);
        double h2 = calculateHeading(p2, p3);

        double angleDiff = h2 - h1;
        while (angleDiff > 180.0)
            angleDiff -= 360.0;
        while (angleDiff < -180.0)
            angleDiff += 360.0;

        if (std::abs(angleDiff) > AppConfig::TURN_MIN_ANGLE_DEG) {
            result.found = true;
            if (angleDiff > AppConfig::TURN_RIGHT_ANGLE)
                result.maneuver = TurnManeuver::Right;
            else if (angleDiff > AppConfig::TURN_MIN_ANGLE_DEG)
                result.maneuver = TurnManeuver::SlightRight;
            else if (angleDiff < AppConfig::TURN_LEFT_ANGLE)
                result.maneuver = TurnManeuver::Left;
            else if (angleDiff < -AppConfig::TURN_MIN_ANGLE_DEG)
                result.maneuver = TurnManeuver::SlightLeft;
            break;
        }
    }

    if (!result.found) {
        // Calculate remaining distance to end
        for (int i = startIdx; i < static_cast<int>(route.size()) - 1; ++i) {
            result.distanceKm += calculateDistance(route[i], route[i + 1]) * AppConfig::DEG_TO_KM;
        }
    } else {
        result.distanceKm = distToTurn;
    }

    return result;
}

// ── smoothHeading ──────────────────────────────────────────────
// Exponential smoothing with angle wraparound.
// Matches the web logic exactly:
//   diff = raw - prev; while(diff>180) diff-=360; while(diff<-180) diff+=360;
//   prev += diff * factor; normalize
double RouteCalculator::smoothHeading(double raw, double previous, double factor)
{
    double diff = raw - previous;
    while (diff > 180.0)
        diff -= 360.0;
    while (diff < -180.0)
        diff += 360.0;

    double smoothed = previous + diff * factor;
    return normalizeHeading(smoothed);
}

// ── normalizeHeading ───────────────────────────────────────────
double RouteCalculator::normalizeHeading(double h)
{
    while (h >= 360.0)
        h -= 360.0;
    while (h < 0.0)
        h += 360.0;
    return h;
}

} // namespace QHUD
