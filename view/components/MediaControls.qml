import QtQuick
import QtQuick.Controls
import "../config"
import "../style"

// ─── MediaControls — play/pause, skip, shuffle, repeat ─────────────
// Matches EXACTLY: MediaScreen.tsx controls section

Row {
    id: root

    property bool isPlaying: true
    property real buttonSizeSm: 24
    property real buttonSizeLg: 56

    signal shuffleClicked()
    signal skipBackClicked()
    signal playPauseClicked()
    signal skipForwardClicked()
    signal repeatClicked()

    spacing: 20
    anchors.horizontalCenter: parent ? parent.horizontalCenter : undefined

    // Shuffle
    IconButton {
        id: shuffleBtn
        btnSize: root.buttonSizeSm
        inactiveBg: "transparent"
        inactiveIconColor: Theme.gray400
        hoverBg: "transparent"
        borderColor: "transparent"
        iconText: "⇌"
        iconTextColor: Theme.gray400
        showGlow: false
        onClicked: root.shuffleClicked()
    }

    // SkipBack
    IconButton {
        id: skipBackBtn
        btnSize: root.buttonSizeSm + 4
        inactiveBg: "transparent"
        inactiveIconColor: Theme.white
        hoverBg: "transparent"
        borderColor: "transparent"
        iconText: "◁◁"
        iconTextColor: Theme.white
        showGlow: false
        onClicked: root.skipBackClicked()

        Behavior on iconTextColor { ColorAnimation { duration: 200 } }
    }

    // Play/Pause (large circle)
    IconButton {
        id: playPauseBtn
        btnSize: root.buttonSizeLg
        activeColor: Theme.white
        inactiveBg: Theme.white
        inactiveIconColor: Theme.bgPrimary
        hoverBg: Theme.white
        borderColor: Theme.white
        iconText: root.isPlaying ? "❚❚" : "▶"
        iconTextColor: root.isPlaying ? (isActive ? Theme.bgPrimary : Theme.bgPrimary) : Theme.bgPrimary
        activeScale: 1.05
        showGlow: false
        isActive: true

        onClicked: root.playPauseClicked()

        Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutQuad } }
    }

    // SkipForward
    IconButton {
        id: skipForwardBtn
        btnSize: root.buttonSizeSm + 4
        inactiveBg: "transparent"
        inactiveIconColor: Theme.white
        hoverBg: "transparent"
        borderColor: "transparent"
        iconText: "▷▷"
        iconTextColor: Theme.white
        showGlow: false
        onClicked: root.skipForwardClicked()
    }

    // Repeat
    IconButton {
        id: repeatBtn
        btnSize: root.buttonSizeSm
        inactiveBg: "transparent"
        inactiveIconColor: Theme.gray400
        hoverBg: "transparent"
        borderColor: "transparent"
        iconText: "↻"
        iconTextColor: Theme.gray400
        showGlow: false
        onClicked: root.repeatClicked()
    }
}
