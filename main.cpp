#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QVariantMap>
#include "viewmodel/TelemetryViewModel.h"
#include "viewmodel/ScreenViewModel.h"
#include "viewmodel/MediaViewModel.h"
#include "config/AppConfig.h"
#include "config/MapConfig.h"

int main(int argc, char *argv[])
{
    // Qt 6.5+ defaults — high-DPI scaling
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("QHUD"));
    app.setApplicationVersion(QStringLiteral("1.0.0"));

    // ── ViewModels (owned on stack, exposed to QML context) ──
    QHUD::TelemetryViewModel telemetryVM;
    QHUD::ScreenViewModel    screenVM;
    QHUD::MediaViewModel     mediaVM;

    // ── QML Engine ───────────────────────────────────────────
    QQmlApplicationEngine engine;

    // Add Qt5Compat GraphicalEffects QML module path
    engine.addImportPath(QStringLiteral("/opt/homebrew/Cellar/qt5compat/6.11.0/share/qt/qml"));

    engine.rootContext()->setContextProperty(
        QStringLiteral("telemetryVM"), &telemetryVM);
    engine.rootContext()->setContextProperty(
        QStringLiteral("screenVM"), &screenVM);
    engine.rootContext()->setContextProperty(
        QStringLiteral("mediaVM"), &mediaVM);

    // ── Expose MapConfig constants to QML ────────────────────
    engine.rootContext()->setContextProperty(
        QStringLiteral("MapConfig"), QVariantMap{
            {QStringLiteral("osmProvider"), QStringLiteral("osm")},
            {QStringLiteral("defaultZoom"), QHUD::MapConfig::DEFAULT_ZOOM},
            {QStringLiteral("tilt"), QHUD::MapConfig::DEFAULT_PITCH},
            {QStringLiteral("mapboxglStyleUrl"),
             QString::fromLatin1(QHUD::MapConfig::MAPBOXGL_STYLE_URL)}
        });

    // ── Expose BUILD_INFO context property ────────────────────
    engine.rootContext()->setContextProperty(
        QStringLiteral("BUILD_INFO"), QVariantMap{
            {QStringLiteral("appName"), QStringLiteral("QHUD")},
            {QStringLiteral("qtVersion"), QString::fromLatin1(qVersion())},
            {QStringLiteral("screenWidth"), QHUD::AppConfig::DISPLAY_WIDTH},
            {QStringLiteral("screenHeight"), QHUD::AppConfig::DISPLAY_HEIGHT}
        });

    // ── Load main QML ────────────────────────────────────────
    const QUrl url(QStringLiteral("qrc:/view/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    // ── Kick off telemetry simulation ────────────────────────
    telemetryVM.start();

    return app.exec();
}
