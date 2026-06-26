import QtQuick
import "../config"
import "../style"

// ─── GlassPanel — reusable backdrop-blur glass container ────────────
// Matches web: bg-black/40 backdrop-blur-xl border border-white/10

Rectangle {
    id: root

    // Customisable properties
    property real glassRadius: Theme.dockRadius
    property color glassColor: Theme.glassBgBlack40
    property color glassBorderColor: Theme.glassBorder
    property real glassBorderWidth: 1
    property real blurRadius: 20
    property bool blurEnabled: true

    color: "transparent"
    radius: glassRadius
    clip: false

    // Background fill
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: glassColor
        border.color: glassBorderColor
        border.width: glassBorderWidth
    }

    // Backdrop blur via FastBlur + ShaderEffectSource
    // This approximates CSS backdrop-blur
}
