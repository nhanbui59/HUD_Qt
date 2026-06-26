#pragma once

#include "viewmodel/BaseViewModel.h"
#include "model/TelemetryTypes.h"
#include "model/TelemetryEngine.h"
#include <QObject>
#include <QVariantList>
#include <memory>
#include <cmath>

namespace QHUD {

// ── TelemetryViewModel ────────────────────────────────────────────
// QObject bridge between TelemetryEngine (pure C++) and QML.
// Exposes ALL telemetry fields as Q_PROPERTY with NOTIFY signals.
// Owns the TelemetryEngine via std::unique_ptr.
//
// Data flow:
//   TelemetryEngine::onTick() → callback → onTelemetryUpdated() →
//     trySetProperty() → Q_PROPERTY NOTIFY → QML binding re-eval
class TelemetryViewModel : public BaseViewModel {
    Q_OBJECT

    // ── Speed ─────────────────────────────────────────────
    Q_PROPERTY(double speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(double speedLimit READ speedLimit NOTIFY speedLimitChanged)

    // ── Navigation ────────────────────────────────────────
    Q_PROPERTY(double nextTurnDistance READ nextTurnDistance NOTIFY nextTurnDistanceChanged)
    Q_PROPERTY(QString nextTurnStreet READ nextTurnStreet NOTIFY nextTurnStreetChanged)
    Q_PROPERTY(int nextTurnManeuver READ nextTurnManeuver NOTIFY nextTurnManeuverChanged)
    Q_PROPERTY(QString currentStreet READ currentStreet NOTIFY currentStreetChanged)
    Q_PROPERTY(double totalDistanceRemaining READ totalDistanceRemaining NOTIFY totalDistanceRemainingChanged)
    Q_PROPERTY(QString eta READ eta NOTIFY etaChanged)

    // ── Vehicle status ────────────────────────────────────
    Q_PROPERTY(double fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(double fuelRange READ fuelRange NOTIFY fuelRangeChanged)
    Q_PROPERTY(int odometer READ odometer NOTIFY odometerChanged)

    // ── Boolean flags ─────────────────────────────────────
    Q_PROPERTY(bool isEcoMode READ isEcoMode NOTIFY isEcoModeChanged)
    Q_PROPERTY(bool isHeadlightsOn READ isHeadlightsOn NOTIFY isHeadlightsOnChanged)
    Q_PROPERTY(bool isDoorOpenWarning READ isDoorOpenWarning NOTIFY isDoorOpenWarningChanged)
    Q_PROPERTY(bool isLaneAssistOn READ isLaneAssistOn NOTIFY isLaneAssistOnChanged)

    // ── Map position ──────────────────────────────────────
    Q_PROPERTY(double currentLng READ currentLng NOTIFY currentLngChanged)
    Q_PROPERTY(double currentLat READ currentLat NOTIFY currentLatChanged)
    Q_PROPERTY(double heading READ heading NOTIFY headingChanged)

    // ── Route polyline for QML MapPolyline ────────────────
    Q_PROPERTY(QVariantList routePath READ routePath NOTIFY routePathChanged)

public:
    explicit TelemetryViewModel(QObject* parent = nullptr);
    ~TelemetryViewModel() override = default;

    // ── Lifecycle ─────────────────────────────────────────
    Q_INVOKABLE void start();
    Q_INVOKABLE void stop();

    // ── Getters (Q_PROPERTY READ accessors) ───────────────
    double  speed()                 const { return m_speed; }
    double  speedLimit()            const { return m_speedLimit; }
    double  nextTurnDistance()      const { return m_nextTurnDistance; }
    QString nextTurnStreet()        const { return m_nextTurnStreet; }
    int     nextTurnManeuver()      const { return static_cast<int>(m_nextTurnManeuver); }
    QString currentStreet()         const { return m_currentStreet; }
    double  totalDistanceRemaining() const { return m_totalDistanceRemaining; }
    QString eta()                   const { return m_eta; }
    double  fuelLevel()             const { return m_fuelLevel; }
    double  fuelRange()             const { return m_fuelRange; }
    int     odometer()              const { return m_odometer; }

    bool    isEcoMode()             const { return m_isEcoMode; }
    bool    isHeadlightsOn()        const { return m_isHeadlightsOn; }
    bool    isDoorOpenWarning()     const { return m_isDoorOpenWarning; }
    bool    isLaneAssistOn()        const { return m_isLaneAssistOn; }

    double  currentLng()            const { return m_currentLng; }
    double  currentLat()            const { return m_currentLat; }
    double  heading()               const { return m_heading; }

    QVariantList routePath()        const { return m_routePath; }

signals:
    void speedChanged();
    void speedLimitChanged();
    void nextTurnDistanceChanged();
    void nextTurnStreetChanged();
    void nextTurnManeuverChanged();
    void currentStreetChanged();
    void totalDistanceRemainingChanged();
    void etaChanged();
    void fuelLevelChanged();
    void fuelRangeChanged();
    void odometerChanged();
    void isEcoModeChanged();
    void isHeadlightsOnChanged();
    void isDoorOpenWarningChanged();
    void isLaneAssistOnChanged();
    void currentLngChanged();
    void currentLatChanged();
    void headingChanged();
    void routePathChanged();

private slots:
    void onTelemetryUpdated(const TelemetryData& data);

private:
    std::unique_ptr<TelemetryEngine> m_engine;

    // ── Property backing fields ───────────────────────────
    double        m_speed                 = 0.0;
    double        m_speedLimit            = 0.0;
    double        m_nextTurnDistance      = 0.0;
    QString       m_nextTurnStreet;
    TurnManeuver  m_nextTurnManeuver      = TurnManeuver::Straight;
    QString       m_currentStreet;
    double        m_totalDistanceRemaining = 0.0;
    QString       m_eta;
    double        m_fuelLevel             = 0.0;
    double        m_fuelRange             = 0.0;
    int           m_odometer              = 0;
    bool          m_isEcoMode             = false;
    bool          m_isHeadlightsOn        = false;
    bool          m_isDoorOpenWarning     = false;
    bool          m_isLaneAssistOn        = false;
    double        m_currentLng            = 0.0;
    double        m_currentLat            = 0.0;
    double        m_heading               = 0.0;
    QVariantList  m_routePath;

    // ── Helpers ────────────────────────────────────────────
    void buildRoutePath(const std::vector<RoutePoint>& route);
};

} // namespace QHUD
