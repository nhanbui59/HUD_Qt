#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QVariantMap>
#include <QByteArray>
#include "viewmodel/TelemetryViewModel.h"
#include "viewmodel/ScreenViewModel.h"
#include "viewmodel/MediaViewModel.h"
#include "config/AppConfig.h"
#include "config/MapConfig.h"

int main(int argc, char *argv[])
{
#if defined(Q_OS_LINUX)
    if (qEnvironmentVariableIsEmpty("QT_QPA_PLATFORM")
            && qEnvironmentVariableIsEmpty("DISPLAY")
            && qEnvironmentVariableIsEmpty("WAYLAND_DISPLAY")) {
        qputenv("QT_QPA_PLATFORM", QByteArrayLiteral("eglfs"));
    }
    if (qEnvironmentVariableIsEmpty("QT_QUICK_BACKEND")) {
        qputenv("QT_QUICK_BACKEND", QByteArrayLiteral("opengl"));
    }
    if (qEnvironmentVariableIsEmpty("QSG_RENDER_LOOP")) {
        qputenv("QSG_RENDER_LOOP", QByteArrayLiteral("basic"));
    }
#endif

    // Qt 6.5+ defaults - high-DPI scaling
    QGuiApplication app(argc, argv);
    app.setApplicationName(QStringLiteral("QHUD"));
    app.setApplicationVersion(QStringLiteral("1.0.0"));

    // ── ViewModels (owned on stack, exposed to QML context) ──
    QHUD::TelemetryViewModel telemetryVM;
    QHUD::ScreenViewModel    screenVM;
    QHUD::MediaViewModel     mediaVM;

    // ── QML Engine ───────────────────────────────────────────
    QQmlApplicationEngine engine;

    const QByteArray extraQmlImportPath = qgetenv("QHUD_QML_IMPORT_PATH");
    if (!extraQmlImportPath.isEmpty()) {
        engine.addImportPath(QString::fromLocal8Bit(extraQmlImportPath));
    }

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
