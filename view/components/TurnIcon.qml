import QtQuick
import QtQuick.Controls
import "../config"
import "../style"

// ─── TurnIcon — maps TurnManeuver enum to directional icon ──────────
// Matches: BottomPanel.tsx getTurnIcon()

Item {
    id: root

    // Inputs
    property int maneuver: 2                    // default Straight (see TelemetryTypes.h enum)
    property real iconSize: 24
    property color iconColor: Theme.white
    property int strokeWidth: 3

    // TurnManeuver enum values (must match C++ enum):
    // Left=0, Right=1, Straight=2, Arrive=3,
    // Roundabout=4, UTurnLeft=5, SharpLeft=6, SharpRight=7,
    // SlightRight=8, SlightLeft=9

    width: iconSize
    height: iconSize

    // ── Arrive (map pin) ────────────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 3
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width, c = s / 2
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                // Pin body
                ctx.beginPath()
                ctx.arc(c, c * 0.6, c * 0.45, 0, Math.PI * 2)
                ctx.stroke()
                // Inner dot
                ctx.beginPath()
                ctx.arc(c, c * 0.6, c * 0.18, 0, Math.PI * 2)
                ctx.fillStyle = root.iconColor
                ctx.fill()
                // Stem
                ctx.beginPath()
                ctx.moveTo(c * 0.7, c * 0.95)
                ctx.lineTo(c, s * 0.88)
                ctx.lineTo(c * 1.3, c * 0.95)
                ctx.stroke()
            }
        }
    }

    // ── Roundabout (circle arrow) ───────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 4
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width, c = s / 2, r = s * 0.35
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = "round"
                ctx.beginPath()
                ctx.arc(c, c, r, 0, Math.PI * 1.5)
                ctx.stroke()
                // Arrowhead
                const angle = Math.PI * 1.5
                const ax = c + r * Math.cos(angle), ay = c + r * Math.sin(angle)
                ctx.beginPath()
                ctx.moveTo(ax - 6, ay + 6)
                ctx.lineTo(ax, ay)
                ctx.lineTo(ax + 6, ay - 6)
                ctx.stroke()
            }
        }
    }

    // ── UTurnLeft (U-turn arrow) ───────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 5
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width, c = s / 2
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                // U-turn path
                ctx.beginPath()
                ctx.moveTo(s * 0.7, s * 0.25)
                ctx.lineTo(s * 0.35, s * 0.25)
                ctx.arcTo(s * 0.2, s * 0.25, s * 0.2, s * 0.75, s * 0.2)
                ctx.lineTo(s * 0.7, s * 0.75)
                ctx.stroke()
                // Arrowhead
                ctx.beginPath()
                ctx.moveTo(s * 0.7, s * 0.6)
                ctx.lineTo(s * 0.7, s * 0.85)
                ctx.lineTo(s * 0.55, s * 0.75)
                ctx.stroke()
            }
        }
    }

    // ── SharpLeft ───────────────────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 6
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.8, s * 0.15)
                ctx.lineTo(s * 0.25, s * 0.5)
                ctx.lineTo(s * 0.25, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.25, s * 0.5)
                ctx.lineTo(s * 0.25, s * 0.75)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.25, s * 0.25)
                ctx.lineTo(s * 0.15, s * 0.35)
                ctx.stroke()
            }
        }
    }

    // ── SharpRight ──────────────────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 7
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.2, s * 0.15)
                ctx.lineTo(s * 0.75, s * 0.5)
                ctx.lineTo(s * 0.75, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.75, s * 0.5)
                ctx.lineTo(s * 0.75, s * 0.75)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.75, s * 0.25)
                ctx.lineTo(s * 0.85, s * 0.35)
                ctx.stroke()
            }
        }
    }

    // ── SlightRight (diagonal up-right) ────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 8
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.25, s * 0.8)
                ctx.lineTo(s * 0.7, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.55, s * 0.2)
                ctx.lineTo(s * 0.7, s * 0.25)
                ctx.lineTo(s * 0.75, s * 0.45)
                ctx.stroke()
            }
        }
    }

    // ── SlightLeft (diagonal up-left) ──────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 9
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.75, s * 0.8)
                ctx.lineTo(s * 0.3, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.45, s * 0.2)
                ctx.lineTo(s * 0.3, s * 0.25)
                ctx.lineTo(s * 0.25, s * 0.45)
                ctx.stroke()
            }
        }
    }

    // ── Left (corner up-left) ──────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 0
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.75, s * 0.2)
                ctx.lineTo(s * 0.3, s * 0.5)
                ctx.lineTo(s * 0.75, s * 0.8)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.3, s * 0.5)
                ctx.lineTo(s * 0.3, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.3, s * 0.25)
                ctx.lineTo(s * 0.2, s * 0.35)
                ctx.stroke()
            }
        }
    }

    // ── Right (corner up-right) ────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 1
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                ctx.beginPath()
                ctx.moveTo(s * 0.25, s * 0.2)
                ctx.lineTo(s * 0.7, s * 0.5)
                ctx.lineTo(s * 0.25, s * 0.8)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.7, s * 0.5)
                ctx.lineTo(s * 0.7, s * 0.25)
                ctx.stroke()
                ctx.beginPath()
                ctx.moveTo(s * 0.7, s * 0.25)
                ctx.lineTo(s * 0.8, s * 0.35)
                ctx.stroke()
            }
        }
    }

    // ── Straight (up arrow) ────────────────────────────────────
    Loader {
        anchors.fill: parent
        active: maneuver === 2
        sourceComponent: Canvas {
            anchors.fill: parent
            onPaint: {
                const ctx = getContext("2d")
                const s = width
                ctx.clearRect(0, 0, s, s)
                ctx.strokeStyle = root.iconColor
                ctx.lineWidth = root.strokeWidth
                ctx.lineCap = ctx.lineJoin = "round"
                // Shaft
                ctx.beginPath()
                ctx.moveTo(s * 0.5, s * 0.85)
                ctx.lineTo(s * 0.5, s * 0.2)
                ctx.stroke()
                // Arrowhead
                ctx.beginPath()
                ctx.moveTo(s * 0.3, s * 0.4)
                ctx.lineTo(s * 0.5, s * 0.15)
                ctx.lineTo(s * 0.7, s * 0.4)
                ctx.stroke()
            }
        }
    }
}
