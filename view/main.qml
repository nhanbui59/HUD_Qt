import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "config"
import "screens"
import "components"

Window {
    id: rootWindow
    visible: true
    width: Theme.screenWidth
    height: Theme.screenHeight
    minimumWidth: Theme.minimumScreenWidth
    minimumHeight: Theme.minimumScreenHeight
    color: Theme.bgPrimary
    title: "QHUD — Car Dashboard"
    property string currentScreen: typeof screenVM !== "undefined" ? screenVM.currentScreen : "dashboard"

    NavigationScreen {
        anchors.fill: parent
        opacity: rootWindow.currentScreen === "navigation" ? 1 : 0
        enabled: rootWindow.currentScreen === "navigation"
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: Theme.transitionDuration; easing.type: Easing.InOutQuad } }
    }
    DashboardScreen {
        anchors.fill: parent
        opacity: rootWindow.currentScreen === "dashboard" ? 1 : 0
        enabled: rootWindow.currentScreen === "dashboard"
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: Theme.transitionDuration; easing.type: Easing.InOutQuad } }
    }
    MediaScreen {
        anchors.fill: parent
        opacity: rootWindow.currentScreen === "media" ? 1 : 0
        enabled: rootWindow.currentScreen === "media"
        visible: opacity > 0
        Behavior on opacity { NumberAnimation { duration: Theme.transitionDuration; easing.type: Easing.InOutQuad } }
    }
    Dock {
        anchors.fill: parent
        z: 100
        currentScreen: rootWindow.currentScreen
        onScreenSelected: function(screenId) {
            if (typeof screenVM !== "undefined") { screenVM.switchToScreen(screenId) }
            else { rootWindow.currentScreen = screenId }
        }
    }
    Connections {
        target: typeof screenVM !== "undefined" ? screenVM : null
        enabled: typeof screenVM !== "undefined"
        function onCurrentScreenChanged() { rootWindow.currentScreen = screenVM.currentScreen }
    }
}
