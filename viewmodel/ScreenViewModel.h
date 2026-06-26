#pragma once

#include <QObject>
#include <QString>

namespace QHUD {

// ── ScreenViewModel ───────────────────────────────────────────────
// Manages the current screen state for the 3-screen HUD app.
//
// Values: "navigation", "dashboard", "media"
// Start with "navigation".
//
// All 3 screens render concurrently; this only controls opacity +
// enabled state in QML (matching the web app's CSS approach).
class ScreenViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString currentScreen READ currentScreen NOTIFY currentScreenChanged)

public:
    explicit ScreenViewModel(QObject* parent = nullptr);
    ~ScreenViewModel() override = default;

    QString currentScreen() const { return m_currentScreen; }

    Q_INVOKABLE void switchToScreen(const QString& screen);

signals:
    void currentScreenChanged();

private:
    QString m_currentScreen;
};

} // namespace QHUD
