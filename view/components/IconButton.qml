import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../config"
import "../style"

// ─── IconButton — reusable circular icon button ─────────────────────
// Used by: SidePanel, Dock
// Matches: Dock.tsx, SidePanel.tsx buttons

Item {
    id: root

    // Inputs
    property real btnSize: Theme.dockButtonSize
    property color activeColor: Theme.blue600
    property color inactiveBg: Theme.glassBgWhite5
    property color inactiveIconColor: Theme.gray400
    property color hoverBg: Theme.glassBgWhite10
    property color borderColor: Theme.glassBorder
    property bool isActive: false
    property real activeScale: 1.1
    property string iconSource: ""
    property string iconText: ""         // fallback text if no icon source
    property color iconTextColor: isActive ? Theme.white : inactiveIconColor
    property real iconOpacity: 1.0
    property bool showGlow: true

    // Signals
    signal clicked()

    width: btnSize
    height: btnSize

    // Glow shadow (active only)
    Rectangle {
        anchors.fill: parent
        radius: btnSize / 2
        color: isActive ? activeColor : "transparent"
        opacity: isActive && showGlow ? 0.4 : 0
        visible: isActive && showGlow

        layer.enabled: isActive && showGlow
        layer.effect: FastBlur {
            radius: 20
            transparentBorder: true
        }

        Behavior on opacity { NumberAnimation { duration: 300 } }
    }

    // Main button circle
    Rectangle {
        id: buttonCircle
        anchors.fill: parent
        radius: btnSize / 2
        color: isActive ? activeColor : (mouseArea.containsMouse ? hoverBg : inactiveBg)
        border.color: isActive ? activeColor : borderColor
        border.width: 1
        scale: isActive ? activeScale : 1.0

        Behavior on color { ColorAnimation { duration: 300 } }
        Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
    }

    // Icon or text
    Item {
        anchors.centerIn: parent
        width: parent.width * 0.5
        height: parent.height * 0.5

        // Icon image
        Image {
            anchors.fill: parent
            source: iconSource
            visible: iconSource !== ""
            opacity: iconOpacity
            fillMode: Image.PreserveAspectFit
        }

        // Fallback text
        Text {
            anchors.fill: parent
            text: iconText
            color: isActive ? Theme.white : inactiveIconColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSm
            font.bold: true
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            visible: iconSource === ""
            Behavior on color { ColorAnimation { duration: 300 } }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
