import QtQuick
import "../config"
import "../style"

// ─── DestinationMarker — blue pin with inner dot and stem ────────
// Matches EXACTLY: Map.tsx DestinationMarker()
// Used as MapQuickItem sourceItem

Item {
    id: root

    implicitWidth: 32
    implicitHeight: 48

    // Pin body (blue circle, border, glow shadow)
    Rectangle {
        id: pinBody
        anchors.horizontalCenter: parent.horizontalCenter
        width: Theme.destPinSize
        height: Theme.destPinSize
        radius: width / 2
        color: Theme.blue600
        border.color: Theme.blue400
        border.width: 2

        // Blue glow shadow
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Qt.rgba(37/255, 99/255, 235/255, 0.8)
            opacity: 0.6

            layer.enabled: false
        }
    }

    // Inner white dot
    Rectangle {
        anchors.centerIn: pinBody
        width: Theme.destInnerDotSize
        height: Theme.destInnerDotSize
        radius: width / 2
        color: Theme.white
    }

    // Vertical stem
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: pinBody.bottom
        anchors.topMargin: -4
        width: Theme.destStemWidth
        height: Theme.destStemHeight
        color: Qt.rgba(37/255, 99/255, 235/255, 0.8)
    }

    // Base shadow ellipse
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: -6
        width: 16
        height: 4
        radius: 2
        color: Qt.rgba(0, 0, 0, 0.5)
    }
}
