import QtQuick
import QtQuick.Controls
import "../config"
import "../style"

// ─── SpeedGauge — Ultra-Luxury Frameless Supercar Arc HUD ────────────
// Pristine minimalist open digital cockpit: zero boxy cards, 240° glowing arc

Item {
    id: root

    // Inputs from telemetryVM
    property real speed: 0
    property real speedLimit: 60
    property real maxSpeed: Theme.gaugeMaxSpeed

    implicitWidth: 310
    implicitHeight: 310

    readonly property real speedRatio: Math.min(speed / maxSpeed, 1.0)

    // ─── 1. Frameless 240° Arc Gauge & Ticks (Canvas) ──────────────
    Canvas {
        id: arcCanvas
        anchors.fill: parent
        antialiasing: true
        smooth: true

        onPaint: {
            const ctx = getContext("2d")
            const w = width
            const h = height
            const cx = w / 2
            const cy = h * 0.48
            const r = Math.min(w, h) * 0.38

            ctx.clearRect(0, 0, w, h)

            const startDeg = 150
            const sweepDeg = 240
            const startRad = startDeg * (Math.PI / 180)
            const endRad = (startDeg + sweepDeg) * (Math.PI / 180)
            const activeEndRad = (startDeg + root.speedRatio * sweepDeg) * (Math.PI / 180)

            // Frosted Dark Instrument Cluster Dial Plate
            ctx.save()
            ctx.beginPath()
            ctx.arc(cx, cy, r + 38, 0, 2 * Math.PI, false)
            ctx.fillStyle = "rgba(18, 21, 28, 0.45)"
            ctx.fill()
            ctx.strokeStyle = "rgba(255, 255, 255, 0.05)"
            ctx.lineWidth = 1.5
            ctx.stroke()
            ctx.restore()

            // Background Outer Ambient Track
            ctx.save()
            ctx.beginPath()
            ctx.arc(cx, cy, r, startRad, endRad, false)
            ctx.strokeStyle = "rgba(0, 229, 255, 0.06)"
            ctx.lineWidth = 24
            ctx.lineCap = "round"
            ctx.stroke()
            ctx.restore()

            // Background Core Line Track
            ctx.save()
            ctx.beginPath()
            ctx.arc(cx, cy, r, startRad, endRad, false)
            ctx.strokeStyle = "rgba(255, 255, 255, 0.1)"
            ctx.lineWidth = 12
            ctx.lineCap = "round"
            ctx.stroke()
            ctx.restore()

            // Active Sweeping Cyan Arc
            if (root.speedRatio > 0.002) {
                ctx.save()
                ctx.beginPath()
                ctx.arc(cx, cy, r, startRad, activeEndRad, false)
                
                const grad = ctx.createLinearGradient(cx - r, cy, cx + r, cy)
                grad.addColorStop(0.0, Theme.blue500)
                grad.addColorStop(0.6, Theme.cyan400)
                grad.addColorStop(1.0, "#ffffff")

                ctx.strokeStyle = grad
                ctx.lineWidth = 12
                ctx.lineCap = "round"
                ctx.stroke()
                ctx.restore()
            }

            // Outer Tick Marks & Numbers (0, 50, 100, 150, 200)
            const totalTicks = 20
            const outerR = r + 16
            for (let i = 0; i <= totalTicks; i++) {
                const tickRatio = i / totalTicks
                const currentVal = Math.round(tickRatio * root.maxSpeed)
                const angleDeg = startDeg + tickRatio * sweepDeg
                const angleRad = angleDeg * (Math.PI / 180)

                const isMajor = (currentVal % 50 === 0)
                const tickLen = isMajor ? 14 : 7
                const innerR = outerR - tickLen

                const x1 = cx + outerR * Math.cos(angleRad)
                const y1 = cy + outerR * Math.sin(angleRad)
                const x2 = cx + innerR * Math.cos(angleRad)
                const y2 = cy + innerR * Math.sin(angleRad)

                ctx.save()
                ctx.beginPath()
                ctx.moveTo(x1, y1)
                ctx.lineTo(x2, y2)
                ctx.lineWidth = isMajor ? 2.5 : 1.2
                ctx.lineCap = "round"
                ctx.strokeStyle = tickRatio <= root.speedRatio ? Theme.cyan400 : "rgba(255, 255, 255, 0.25)"
                ctx.stroke()
                ctx.restore()

                // Draw speed label on major ticks
                if (isMajor) {
                    const labelR = outerR + 16
                    const lx = cx + labelR * Math.cos(angleRad)
                    const ly = cy + labelR * Math.sin(angleRad)
                    ctx.save()
                    ctx.fillStyle = tickRatio <= root.speedRatio ? Theme.white : Theme.gray500
                    ctx.font = "bold 11px Arial, sans-serif"
                    ctx.textAlign = "center"
                    ctx.textBaseline = "middle"
                    ctx.fillText(currentVal.toString(), lx, ly)
                    ctx.restore()
                }
            }
        }

        Connections {
            target: root
            function onSpeedChanged() { arcCanvas.requestPaint() }
        }
    }

    // ─── 2. Center Minimalist Readout ──────────────────────────────
    Column {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -8
        spacing: -4

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: Math.round(root.speed)
            color: Theme.white
            font.family: Theme.fontFamilyMono
            font.pixelSize: 84
            font.weight: Font.Light
            font.letterSpacing: -3
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "KM/H"
            color: Theme.cyan400
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeXs
            font.weight: Font.Bold
            font.letterSpacing: 3
        }
    }

    // ─── 3. Clean Frameless Bottom Gear Row (`P R N D`) ────────────
    Row {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 18
        spacing: 20

        Text { text: "P"; color: Theme.gray600; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeBase; font.weight: Font.Bold }
        Text { text: "R"; color: Theme.gray600; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeBase; font.weight: Font.Bold }
        Text { text: "N"; color: Theme.gray600; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeBase; font.weight: Font.Bold }

        // Active D
        Row {
            spacing: 2
            Text { text: "D"; color: Theme.cyan400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeLg; font.weight: Font.Black }
            Text { text: "4"; color: Theme.cyan400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize2xs; font.weight: Font.Bold; anchors.verticalCenter: parent.verticalCenter }
        }
    }

    // ─── 4. Speed Limit Badge (Top Right Corner) ───────────────────
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.top: parent.top
        anchors.topMargin: 12
        width: 38; height: 38; radius: 19
        color: "transparent"
        border.color: Theme.red600; border.width: 3

        Text {
            anchors.centerIn: parent
            text: root.speedLimit
            color: Theme.white
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSm
            font.weight: Font.Black
        }
    }
}
