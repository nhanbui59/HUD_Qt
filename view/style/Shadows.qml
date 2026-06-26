pragma Singleton
import QtQuick
import "../config"

QtObject {
    // ─── Blue glow (Dock active button, progress fill) ────────
    readonly property var blueGlow: QtObject {
        readonly property color color: Theme.blue600
        readonly property real opacity: 0.4
        readonly property real radius: 20
        readonly property int samples: 17
        readonly property real spread: 0
    }

    // ─── Blue glow softer (speed number, gauge) ────────────────
    readonly property var blueSoftGlow: QtObject {
        readonly property color color: Qt.rgba(59/255, 130/255, 246/255, 0.3)
        readonly property real radius: 20
        readonly property int samples: 17
        readonly property real horizontalOffset: 0
        readonly property real verticalOffset: 0
        readonly property color color_: Theme.blue500
        readonly property real opacity: 0.3
    }

    // ─── Text drop shadow ──────────────────────────────────────
    readonly property var textDropShadow: QtObject {
        readonly property color color: Qt.rgba(0, 0, 0, 0.8)
        readonly property real radius: 10
        readonly property int samples: 17
        readonly property real horizontalOffset: 0
        readonly property real verticalOffset: 2
    }

    // ─── Car marker drop shadow ────────────────────────────────
    readonly property var carMarkerShadow: QtObject {
        readonly property color color: Qt.rgba(0, 0, 0, 0.8)
        readonly property real radius: 10
        readonly property int samples: 17
    }

    // ─── Car marker cyan glow ──────────────────────────────────
    readonly property var carCyanGlow: QtObject {
        readonly property color color: Qt.rgba(0, 240/255, 1, 0.4)
        readonly property real radius: 8
        readonly property int samples: 17
    }

    // ─── Destination marker blue glow ──────────────────────────
    readonly property var destBlueGlow: QtObject {
        readonly property color color: Qt.rgba(37/255, 99/255, 235/255, 0.8)
        readonly property real radius: 20
        readonly property int samples: 17
    }

    // ─── Album art shadow ──────────────────────────────────────
    readonly property var albumArtShadow: QtObject {
        readonly property color color: Qt.rgba(0, 0, 0, 0.5)
        readonly property real radius: 50
        readonly property int samples: 25
        readonly property real verticalOffset: 20
    }

    // ─── Panel shadow (BottomPanel) ────────────────────────────
    readonly property var panelShadow: QtObject {
        readonly property color color: Qt.rgba(0, 0, 0, 0.5)
        readonly property real radius: 16
        readonly property int samples: 25
    }

    // ─── Door warning red glow ─────────────────────────────────
    readonly property var doorWarningGlow: QtObject {
        readonly property color color: Qt.rgba(239/255, 68/255, 68/255, 0.5)
        readonly property real radius: 20
        readonly property int samples: 17
    }

    // ─── Speed limit pulse red ─────────────────────────────────
    readonly property var speedLimitRedGlow: QtObject {
        readonly property color color: Qt.rgba(220/255, 38/255, 38/255, 0.6)
        readonly property real radius: 12
        readonly property int samples: 17
    }
}
