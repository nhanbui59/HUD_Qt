#include "viewmodel/ScreenViewModel.h"

namespace QHUD {

ScreenViewModel::ScreenViewModel(QObject* parent)
    : QObject(parent)
    , m_currentScreen(QStringLiteral("navigation"))
{
}

void ScreenViewModel::switchToScreen(const QString& screen)
{
    if (screen == QStringLiteral("navigation") ||
        screen == QStringLiteral("dashboard") ||
        screen == QStringLiteral("media")) {
        if (m_currentScreen != screen) {
            m_currentScreen = screen;
            Q_EMIT currentScreenChanged();
        }
    }
}

} // namespace QHUD
