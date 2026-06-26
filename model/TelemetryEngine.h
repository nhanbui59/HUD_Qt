#pragma once

#include "model/TelemetryTypes.h"
#include "model/RouteCalculator.h"
#include "config/AppConfig.h"
#include <QObject>
#include <QTimer>
#include <functional>
#include <vector>
#include <memory>

namespace QHUD {

// ── TelemetryEngine ──────────────────────────────────────────────
// Pure C++ simulation engine. Uses QTimer for timing, but the core
// logic is decoupled and testable without Qt.
//
// Emits data via std::function callback (NOT Qt signal) to keep the
// model layer free of QObject dependency.
class TelemetryEngine : public QObject {
    Q_OBJECT

public:
    using Callback = std::function<void(const TelemetryData&)>;

    explicit TelemetryEngine(QObject* parent = nullptr);
    ~TelemetryEngine() override = default;

    // ── Lifecycle ──────────────────────────────────────────────
    void start();
    void stop();
    bool isRunning() const;

    // ── Callback Registration ──────────────────────────────────
    void setCallback(Callback cb);

private slots:
    void onTick();

private:
    // ── Simulation State ──────────────────────────────────────
    QTimer*          m_timer     = nullptr;
    Callback         m_callback;
    bool             m_running   = false;
    double           m_progress  = 0.0;               // 0.0 → 1.0
    double           m_speed     = AppConfig::INITIAL_SPEED;
    double           m_smoothedHeading = 0.0;
    bool             m_headingInitialized = false;

    // ── Route Data (computed once) ─────────────────────────────
    std::vector<RoutePoint> m_route;
    std::vector<double>     m_segmentLengths;
    double                  m_totalLength = 0.0;

    // ── Fuel / Odometer simulation ─────────────────────────────
    double m_fuelLevel = AppConfig::INITIAL_FUEL_LEVEL;
    int    m_odometer  = AppConfig::INITIAL_ODOMETER;

    // ── Tick counter for sub-second events ─────────────────────
    long long m_tickCount = 0;

    // ── Internal helpers ───────────────────────────────────────
    void buildRoute();
    TelemetryData computeFrame();
};

} // namespace QHUD
