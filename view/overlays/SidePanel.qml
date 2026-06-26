import QtQuick
import "../config"

Item {
    id: root
    property bool isEcoMode: true
    property bool isLaneAssistOn: true
    property bool mobile: parent.width < 768

    anchors { right: parent.right; rightMargin: mobile ? 16 : 32 }
    y: mobile ? 100 : (parent.height - colLayout.implicitHeight) / 2
    width: mobile ? 44 : 52
    height: colLayout.implicitHeight

    Column {
        id: colLayout
        anchors.centerIn: parent
        spacing: mobile ? 16 : 24

        // ECO
        Rectangle {
            id: ecoBtn; width: root.width; height: root.width; radius: width/2
            color: Qt.rgba(0, 0, 0, 0.4); border { color: Qt.rgba(1,1,1,0.1); width: 1 }
            Text { anchors.centerIn: parent; text: "ECO"; font.pixelSize: 8; font.weight: Font.Bold; font.family: Theme.fontFamily
                color: root.isEcoMode ? Theme.green400 : Theme.gray500 }
            Rectangle { anchors { bottom: parent.bottom; bottomMargin: 8; horizontalCenter: parent.horizontalCenter }
                width: 6; height: 6; radius: 3; color: root.isEcoMode ? Theme.green400 : "transparent" }
            MouseArea { anchors.fill: parent; onClicked: {} }
        }
        // Lane Assist
        Rectangle {
            id: laneBtn; width: root.width; height: root.width; radius: width/2
            color: Qt.rgba(0, 0, 0, 0.4); border { color: Qt.rgba(1,1,1,0.1); width: 1 }
            Text { anchors.centerIn: parent; text: "LA"; font.pixelSize: mobile ? 14 : 18; font.weight: Font.Bold; font.family: Theme.fontFamily
                color: root.isLaneAssistOn ? Theme.white : Theme.gray400 }
            MouseArea { anchors.fill: parent; onClicked: {} }
        }
        // Settings
        Rectangle {
            id: setBtn; width: root.width; height: root.width; radius: width/2
            color: Qt.rgba(0, 0, 0, 0.4); border { color: Qt.rgba(1,1,1,0.1); width: 1 }
            Text { anchors.centerIn: parent; text: "⚙"; font.pixelSize: mobile ? 18 : 22; color: Theme.gray400 }
            MouseArea { anchors.fill: parent; onClicked: {} }
        }
    }
}
