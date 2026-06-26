import QtQuick
import "../config"
import "../style"

// ─── ProgressBar — reusable progress bar with gradient fill and timestamps
// Matches: BottomPanel trip progress, MediaScreen progress bar

Item {
    id: root

    // Inputs
    property real progress: 0.75       // 0.0 - 1.0
    property real barHeight: 6
    property real barRadius: 4
    property color trackColor: Theme.glassBgWhite10
    property color fillColorStart: Theme.blue500
    property color fillColorEnd: Theme.blue500
    property bool showLeftTimestamp: false
    property bool showRightTimestamp: false
    property string leftTimestampText: ""
    property string rightTimestampText: ""
    property color timestampColor: Theme.gray400
    property int timestampFontSize: Theme.fontSizeXs
    property bool glowEnabled: true

    implicitWidth: 200
    implicitHeight: showLeftTimestamp || showRightTimestamp ? barHeight + 24 : barHeight

    // Track
    Rectangle {
        id: track
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: showLeftTimestamp || showRightTimestamp ? 0 : 0
        height: barHeight
        radius: barRadius
        color: trackColor
    }

    // Fill
    Rectangle {
        id: fill
        anchors.left: track.left
        anchors.top: track.top
        height: barHeight
        radius: barRadius
        width: Math.max(0, track.width * Math.min(1.0, Math.max(0, root.progress)))

        gradient: Gradient {
            GradientStop { position: 0.0; color: root.fillColorStart }
            GradientStop { position: 1.0; color: root.fillColorEnd }
        }

        Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.InOutQuad } }
    }

    // Glow effect on fill
    Rectangle {
        anchors.fill: fill
        radius: barRadius
        color: fillColorStart
        opacity: glowEnabled ? 0.6 : 0
        visible: glowEnabled

        layer.enabled: false
    }

    // Left timestamp
    Text {
        anchors.left: track.left
        anchors.top: track.bottom
        anchors.topMargin: 6
        text: leftTimestampText
        color: timestampColor
        font.family: Theme.fontFamilyMono
        font.pixelSize: timestampFontSize
        font.weight: Font.Medium
        visible: showLeftTimestamp
    }

    // Right timestamp
    Text {
        anchors.right: track.right
        anchors.top: track.bottom
        anchors.topMargin: 6
        text: rightTimestampText
        color: timestampColor
        font.family: Theme.fontFamilyMono
        font.pixelSize: timestampFontSize
        font.weight: Font.Medium
        visible: showRightTimestamp
    }
}
