#include "model/TelemetryEngine.h"
#include "config/AppConfig.h"
#include <cmath>
#include <random>

namespace QHUD {

// ── Constructor ─────────────────────────────────────────────────
TelemetryEngine::TelemetryEngine(QObject* parent)
    : QObject(parent)
    , m_timer(new QTimer(this))
{
    m_timer->setTimerType(Qt::PreciseTimer);
    m_timer->setInterval(AppConfig::SIMULATION_INTERVAL_MS);
    connect(m_timer, &QTimer::timeout, this, &TelemetryEngine::onTick);

    buildRoute();
}

// ── start / stop / isRunning ────────────────────────────────────
void TelemetryEngine::start()
{
    if (m_running) return;
    m_running = true;
    m_timer->start();
}

void TelemetryEngine::stop()
{
    if (!m_running) return;
    m_running = false;
    m_timer->stop();
}

bool TelemetryEngine::isRunning() const
{
    return m_running;
}

void TelemetryEngine::setCallback(Callback cb)
{
    m_callback = std::move(cb);
}

// ── buildRoute ──────────────────────────────────────────────────
void TelemetryEngine::buildRoute()
{
    m_route.clear();
    m_route.reserve(AppConfig::ROUTE_COORDINATES.size());

    for (const auto& c : AppConfig::ROUTE_COORDINATES) {
        m_route.push_back({c.first, c.second});
    }

    m_totalLength = RouteCalculator::computeTotalLength(m_route, m_segmentLengths);
}

// ── onTick ──────────────────────────────────────────────────────
void TelemetryEngine::onTick()
{
    ++m_tickCount;

    const double dtSec = AppConfig::SIMULATION_INTERVAL_MS / 1000.0;

    // ── Speed fluctuation (±1 km/h per second, clamped) ──────
    // Speed changes roughly once per second; use tick counter
    if (m_tickCount % 60 == 0) { // ~1s at 16ms ticks
        static std::mt19937 rng(std::random_device{}());
        static std::uniform_real_distribution<double> dist(-1.0, 1.0);

        double newSpeed = m_speed + dist(rng);
        if (newSpeed > AppConfig::MAX_SPEED)
            newSpeed = AppConfig::MAX_SPEED - 2.0;  // clamp down (matches web: resets to 50)
        if (newSpeed < AppConfig::MIN_SPEED)
            newSpeed = AppConfig::MIN_SPEED + 2.0;  // clamp up (matches web: resets to 42)
        m_speed = std::round(newSpeed);
    }

    // ── Route progress (linear, loops) ────────────────────────
    m_progress += dtSec * 1000.0 / static_cast<double>(AppConfig::ROUTE_DURATION_MS);
    if (m_progress >= 1.0) {
        m_progress -= 1.0;  // loop
    }

    // ── Fuel consumption (~0.0083% per second → 0.5% per min) ─
    m_fuelLevel -= 0.0083 * dtSec;
    if (m_fuelLevel < 5.0)
        m_fuelLevel = 5.0;

    // ── Odometer increment ────────────────────────────────────
    // Speed in km/h → increment proportionally per tick
    double distTraveled = m_speed * dtSec / 3600.0; // km per tick
    m_odometer += static_cast<int>(distTraveled * 1000.0); // accum in meters (int)

    // ── Build TelemetryData ──────────────────────────────────
    TelemetryData data = computeFrame();

    if (m_callback) {
        m_callback(data);
    }
}

// ── computeFrame ──────────────────────────────────────────────
TelemetryData TelemetryEngine::computeFrame()
{
    using namespace AppConfig;

    TelemetryData d;

    const double targetLength = m_progress * m_totalLength;

    // ── Position ─────────────────────────────────────────────
    auto locAtProg = RouteCalculator::getPointAtLength(
        targetLength, m_route, m_totalLength, m_segmentLengths);

    d.location.lng = locAtProg.point.lng;
    d.location.lat = locAtProg.point.lat;

    // ── Upcoming route (from current position forward) ──────
    std::vector<RoutePoint> upcoming;
    upcoming.push_back(locAtProg.point);
    for (size_t i = locAtProg.segmentIndex + 1; i < m_route.size(); ++i) {
        upcoming.push_back(m_route[i]);
    }
    d.route = upcoming;

    // ── Heading (lookahead + smoothing) ─────────────────────
    RoutePoint lookaheadPt;
    if (targetLength >= m_totalLength - NEAR_END_THRESHOLD) {
        // Near end: heading from last two points
        int sz = static_cast<int>(m_route.size());
        lookaheadPt = m_route[sz - 1];
    } else {
        auto laProg = RouteCalculator::getPointAtLength(
            targetLength + LOOKAHEAD_DISTANCE,
            m_route, m_totalLength, m_segmentLengths);
        lookaheadPt = laProg.point;
    }

    double rawHeading = RouteCalculator::calculateHeading(
        locAtProg.point, lookaheadPt);

    if (!m_headingInitialized) {
        m_smoothedHeading = rawHeading;
        m_headingInitialized = true;
    } else {
        m_smoothedHeading = RouteCalculator::smoothHeading(
            rawHeading, m_smoothedHeading, HEADING_SMOOTH_FACTOR);
    }

    d.heading = m_smoothedHeading;

    // ── Turn Detection ──────────────────────────────────────
    TurnDetection turn = RouteCalculator::detectNextTurn(
        m_route, locAtProg.segmentIndex);

    d.nextTurnManeuver = turn.maneuver;
    d.nextTurnDistance  = std::max(MIN_DISPLAY_DISTANCE, turn.distanceKm);

    // ── Street names ───────────────────────────────────────
    const int idx = locAtProg.segmentIndex;
    if (idx >= SEGMENT_NGUYEN_HUE_START && idx < SEGMENT_TON_DUC_THANG_START) {
        d.currentStreet = STREET_NGUYEN_HUE;
        d.nextTurnStreet = STREET_TON_DUC_THANG;
    } else if (idx >= SEGMENT_TON_DUC_THANG_START && idx < SEGMENT_HAI_TRIEU_START) {
        d.currentStreet = STREET_TON_DUC_THANG;
        d.nextTurnStreet = STREET_HAI_TRIEU;
    } else if (idx >= SEGMENT_HAI_TRIEU_START) {
        d.currentStreet = STREET_HAI_TRIEU_BITEXCO;
        d.nextTurnStreet = STREET_DESTINATION;
    } else {
        d.currentStreet = STREET_LE_THANH_TON;
        d.nextTurnStreet = STREET_NGUYEN_HUE;
    }

    // Override nextTurnStreet if no turn found (arrived)
    if (!turn.found && idx >= SEGMENT_HAI_TRIEU_START) {
        d.nextTurnStreet = STREET_BITEXCO_TOWER;
    } else if (!turn.found) {
        d.nextTurnStreet = STREET_DESTINATION;
    }

    // ── ETA ──────────────────────────────────────────────────
    double secondsLeft = std::round((1.0 - m_progress) * ETA_MAX_SECONDS);
    int mins = static_cast<int>(secondsLeft) / 60;
    int secs = static_cast<int>(secondsLeft) % 60;
    d.eta = QStringLiteral("%1:%2 min")
                .arg(mins, 2, 10, QChar('0'))
                .arg(secs, 2, 10, QChar('0'));

    // ── Speed & limit ───────────────────────────────────────
    d.speed      = m_speed;
    d.speedLimit = INITIAL_SPEED_LIMIT;

    // ── Total remaining distance ────────────────────────────
    d.totalDistanceRemaining = std::max(
        MIN_DISPLAY_DISTANCE,
        (1.0 - m_progress) * TOTAL_DISTANCE_FACTOR);

    // ── Fuel / Odometer ─────────────────────────────────────
    d.fuelLevel = m_fuelLevel;
    d.fuelRange = std::max(0.0, INITIAL_FUEL_RANGE * (m_fuelLevel / INITIAL_FUEL_LEVEL));
    d.odometer  = m_odometer;

    // ── Status flags ───────────────────────────────────────
    d.isEcoMode         = INITIAL_ECO_MODE;
    d.isHeadlightsOn    = INITIAL_HEADLIGHTS;
    d.isDoorOpenWarning = INITIAL_DOOR_WARNING;
    d.isLaneAssistOn    = INITIAL_LANE_ASSIST;

    return d;
}

} // namespace QHUD
