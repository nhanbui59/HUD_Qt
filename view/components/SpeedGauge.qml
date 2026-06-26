import QtQuick
import QtQuick.Controls
import "../config"
import "../style"

// ─── SpeedGauge — circular gauge with speed number, gear, speed limit ─
// Matches EXACTLY: DashboardScreen.tsx left column gauge

Item {
    id: root

    // Inputs from telemetryVM
    property real speed: 0
    property real speedLimit: 60
    property real maxSpeed: Theme.gaugeMaxSpeed

    implicitWidth: 400
    implicitHeight: 400

    // Derived
    readonly property real speedPercent: Math.min(speed / maxSpeed, 1.0)
    readonly property real circumference: 2 * Math.PI * Theme.gaugeRadius
    readonly property real totalDash: circumference * 0.75   // 270°
    readonly property real offset: circumference - (speedPercent * totalDash)

    // ─── Gauge Canvas ───────────────────────────────────────
    Canvas {
        id: gaugeCanvas
        anchors.fill: parent

        // Rotate so 0 speed is at bottom-left (225°), max at bottom-right (315°)
        rotation: -225

        onPaint: {
            const ctx = getContext("2d")
            const cx = width / 2
            const cy = height / 2
            const r = Theme.gaugeRadius

            ctx.clearRect(0, 0, width, height)

            // ── Background track (white/5, 12px stroke) ──
            ctx.beginPath()
            ctx.arc(cx, cy, r, 0, Math.PI * 1.5)
            ctx.strokeStyle = "rgba(255,255,255,0.05)"
            ctx.lineWidth = Theme.gaugeTrackWidth
            ctx.lineCap = "round"
            ctx.stroke()

            // ── Active arc (blue gradient, 16px stroke) ──
            const arcLength = speedPercent * Math.PI * 1.5
            if (arcLength > 0.001) {
                ctx.beginPath()
                ctx.arc(cx, cy, r, 0, arcLength)
                // Linear gradient for stroke
                const grad = ctx.createLinearGradient(cx - r, cy - r, cx + r, cy + r)
                grad.addColorStop(0, Theme.blue500)
                grad.addColorStop(1, Theme.cyan500)
                ctx.strokeStyle = grad
                ctx.lineWidth = Theme.gaugeActiveWidth
                ctx.lineCap = "round"
                ctx.stroke()
            }

            // ── Tick marks (9 ticks, every 33.75°) ──
            for (let i = 0; i < Theme.gaugeTickCount; i++) {
                const angle = (i * Theme.gaugeTickInterval) * (Math.PI / 180)
                const tx = cx + (r - 20) * Math.cos(angle)
                const ty = cy + (r - 20) * Math.sin(angle)
                ctx.beginPath()
                ctx.arc(tx, ty, 3, 0, Math.PI * 2)
                ctx.fillStyle = "rgba(255,255,255,0.3)"
                ctx.fill()
            }
        }

        // Repaint when speed changes
        Connections {
            target: root
            function onSpeedChanged() { gaugeCanvas.requestPaint() }
            function onSpeedLimitChanged() { gaugeCanvas.requestPaint() }
        }
    }

    // ─── Center Content ──────────────────────────────────────
    Column {
        anchors.centerIn: parent
        spacing: 0
        z: 2

        // Speed number (7xl, tabular-nums, blue glow)
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.speed)
            color: Theme.white
            font.family: Theme.fontFamilyMono
            font.pixelSize: Theme.fontSize7xl
            font.weight: Font.Black
            style: Text.Normal

            // Blue glow shadow via layer effect
            layer.enabled: false
        }

        // KM/H label
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "KM/H"
            color: Theme.gray400
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize2xs
            font.weight: Font.Bold
            font.capitalization: Font.AllUppercase
        }

        // Spacer
        Item { height: 32; width: 1 }

        // Gear indicator row
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            // D4 active
            Rectangle {
                width: 42; height: 32
                radius: 8
                color: Theme.glassBgWhite10
                border.color: "transparent"

                Row {
                    anchors.centerIn: parent
                    spacing: 1
                    Text {
                        text: "D"
                        color: Theme.white
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeSm
                        font.weight: Font.Bold
                        font.capitalization: Font.AllUppercase
                    }
                    Text {
                        text: "4"
                        color: Theme.blue400
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize2xs
                        font.weight: Font.Normal
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                layer.enabled: false
            }

            // P
            Rectangle {
                width: 42; height: 32
                radius: 8
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "P"
                    color: Theme.gray500
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSm
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                }
            }

            // R
            Rectangle {
                width: 42; height: 32
                radius: 8
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "R"
                    color: Theme.gray500
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSm
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                }
            }

            // N
            Rectangle {
                width: 42; height: 32
                radius: 8
                color: "transparent"
                Text {
                    anchors.centerIn: parent
                    text: "N"
                    color: Theme.gray500
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeSm
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                }
            }
        }

        // Spacer
        Item { height: 24; width: 1 }

        // Speed limit badge (white circle, red border, pulse if speeding)
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 48; height: 48
            radius: 24
            color: Theme.white
            border.color: Theme.red600
            border.width: 4

            Text {
                anchors.centerIn: parent
                text: root.speedLimit
                color: Theme.bgPrimary
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLg
                font.weight: Font.Black
            }

            // Pulse red when speeding
            SequentialAnimation on border.color {
                id: speedPulse
                running: root.speed > root.speedLimit
                loops: Animation.Infinite
                ColorAnimation {
                    from: Theme.red600
                    to: Qt.rgba(220/255, 38/255, 38/255, 0.4)
                    duration: 500
                    easing.type: Easing.InOutSine
                }
                ColorAnimation {
                    from: Qt.rgba(220/255, 38/255, 38/255, 0.4)
                    to: Theme.red600
                    duration: 500
                    easing.type: Easing.InOutSine
                }
            }
        }
    }
}
