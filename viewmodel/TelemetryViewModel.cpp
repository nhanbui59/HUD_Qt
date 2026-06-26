#include "viewmodel/TelemetryViewModel.h"
#include "config/AppConfig.h"
#include <QVariantMap>

namespace QHUD {

// ── Constructor ─────────────────────────────────────────────────
TelemetryViewModel::TelemetryViewModel(QObject* parent)
    : BaseViewModel(parent)
    , m_engine(std::make_unique<TelemetryEngine>())
{
    // Wire engine callback to our update slot
    m_engine->setCallback([this](const TelemetryData& data) {
        // Use QMetaObject::invokeMethod to ensure slot runs on the
        // Qt event loop (thread-safe, avoids reentrancy issues).
        QMetaObject::invokeMethod(this, [this, data]() {
            onTelemetryUpdated(data);
        }, Qt::QueuedConnection);
    });
}

// ── start / stop ────────────────────────────────────────────────
void TelemetryViewModel::start()
{
    m_engine->start();
}

void TelemetryViewModel::stop()
{
    m_engine->stop();
}

// ── onTelemetryUpdated ─────────────────────────────────────────
void TelemetryViewModel::onTelemetryUpdated(const TelemetryData& data)
{
    trySetProperty(m_speed,                 data.speed,                 &TelemetryViewModel::speedChanged);
    trySetProperty(m_speedLimit,            data.speedLimit,            &TelemetryViewModel::speedLimitChanged);
    trySetProperty(m_nextTurnDistance,      data.nextTurnDistance,      &TelemetryViewModel::nextTurnDistanceChanged);
    trySetProperty(m_nextTurnStreet,        data.nextTurnStreet,        &TelemetryViewModel::nextTurnStreetChanged);
    trySetProperty(m_currentStreet,         data.currentStreet,         &TelemetryViewModel::currentStreetChanged);
    trySetProperty(m_totalDistanceRemaining, data.totalDistanceRemaining, &TelemetryViewModel::totalDistanceRemainingChanged);
    trySetProperty(m_eta,                   data.eta,                   &TelemetryViewModel::etaChanged);
    trySetProperty(m_fuelLevel,             data.fuelLevel,             &TelemetryViewModel::fuelLevelChanged);
    trySetProperty(m_fuelRange,             data.fuelRange,             &TelemetryViewModel::fuelRangeChanged);
    trySetProperty(m_odometer,              data.odometer,              &TelemetryViewModel::odometerChanged);
    trySetProperty(m_isEcoMode,             data.isEcoMode,             &TelemetryViewModel::isEcoModeChanged);
    trySetProperty(m_isHeadlightsOn,        data.isHeadlightsOn,        &TelemetryViewModel::isHeadlightsOnChanged);
    trySetProperty(m_isDoorOpenWarning,     data.isDoorOpenWarning,     &TelemetryViewModel::isDoorOpenWarningChanged);
    trySetProperty(m_isLaneAssistOn,        data.isLaneAssistOn,        &TelemetryViewModel::isLaneAssistOnChanged);
    trySetProperty(m_currentLng,            data.location.lng,          &TelemetryViewModel::currentLngChanged);
    trySetProperty(m_currentLat,            data.location.lat,          &TelemetryViewModel::currentLatChanged);
    trySetProperty(m_heading,               data.heading,               &TelemetryViewModel::headingChanged);

    // Maneuver enum → int
    int newManeuver = static_cast<int>(data.nextTurnManeuver);
    if (static_cast<int>(m_nextTurnManeuver) != newManeuver) {
        m_nextTurnManeuver = data.nextTurnManeuver;
        Q_EMIT nextTurnManeuverChanged();
    }

    // Route path (QVariantList)
    buildRoutePath(data.route);
}

// ── buildRoutePath ─────────────────────────────────────────────
void TelemetryViewModel::buildRoutePath(const std::vector<RoutePoint>& route)
{
    QVariantList path;
    path.reserve(static_cast<int>(route.size()));

    for (const auto& pt : route) {
        QVariantMap point;
        point[QStringLiteral("lng")] = pt.lng;
        point[QStringLiteral("lat")] = pt.lat;
        path.append(point);
    }

    if (m_routePath != path) {
        m_routePath = std::move(path);
        Q_EMIT routePathChanged();
    }
}

} // namespace QHUD
