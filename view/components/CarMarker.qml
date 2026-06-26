import QtQuick
import "../config"

Item {
    id: root
    implicitWidth: 120
    implicitHeight: 80

    Canvas {
        id: markerCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2
            var groundY = height * 0.70
            var topY = height * 0.12
            var tailY = height * 0.66
            var leftX = cx - width * 0.24
            var rightX = cx + width * 0.24
            var notchY = height * 0.50
            var depth = height * 0.10
            var pulsePhase = (Date.now() % 1500) / 1500
            var pulseScale = 0.82 + pulsePhase * 0.42
            var pulseAlpha = (1 - pulsePhase) * 0.55

            ctx.save()
            ctx.translate(cx, groundY)
            ctx.scale(1, 0.36)

            var groundGlow = ctx.createRadialGradient(0, 0, 4, 0, 0, width * 0.34)
            groundGlow.addColorStop(0, "rgba(0,240,255,0.20)")
            groundGlow.addColorStop(0.58, "rgba(0,240,255,0.08)")
            groundGlow.addColorStop(1, "rgba(0,240,255,0.00)")
            ctx.beginPath()
            ctx.fillStyle = groundGlow
            ctx.arc(0, 0, width * 0.34, 0, Math.PI * 2)
            ctx.fill()

            ctx.beginPath()
            ctx.strokeStyle = "rgba(0,240,255,0.62)"
            ctx.lineWidth = 2.0
            ctx.arc(0, 0, width * 0.25, 0, Math.PI * 2)
            ctx.stroke()

            ctx.beginPath()
            ctx.strokeStyle = "rgba(0,240,255," + pulseAlpha.toFixed(2) + ")"
            ctx.lineWidth = 1.7
            ctx.arc(0, 0, width * 0.30 * pulseScale, 0, Math.PI * 2)
            ctx.stroke()
            ctx.restore()

            ctx.beginPath()
            ctx.fillStyle = "rgba(0,0,0,0.38)"
            ctx.ellipse(cx, groundY + 2, width * 0.20, height * 0.055, 0, 0, Math.PI * 2)
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY + depth)
            ctx.lineTo(rightX + 3, tailY + depth)
            ctx.lineTo(cx, notchY + depth)
            ctx.lineTo(leftX - 3, tailY + depth)
            ctx.closePath()
            ctx.fillStyle = "rgba(0,24,34,0.70)"
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY)
            ctx.lineTo(rightX, tailY)
            ctx.lineTo(cx, notchY)
            ctx.lineTo(leftX, tailY)
            ctx.closePath()
            var body = ctx.createLinearGradient(cx, topY, cx, tailY)
            body.addColorStop(0, "#b9fbff")
            body.addColorStop(0.18, "#42f6ff")
            body.addColorStop(0.64, "#00cce8")
            body.addColorStop(1, "#008eab")
            ctx.fillStyle = body
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY)
            ctx.lineTo(rightX, tailY)
            ctx.lineTo(cx, notchY)
            ctx.closePath()
            var rightFace = ctx.createLinearGradient(cx, topY, rightX, tailY)
            rightFace.addColorStop(0, "rgba(255,255,255,0.24)")
            rightFace.addColorStop(1, "rgba(0,82,110,0.46)")
            ctx.fillStyle = rightFace
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY)
            ctx.lineTo(leftX, tailY)
            ctx.lineTo(cx, notchY)
            ctx.closePath()
            ctx.fillStyle = "rgba(0,58,88,0.30)"
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY + 4)
            ctx.lineTo(cx + width * 0.08, tailY - 9)
            ctx.lineTo(cx, notchY - 3)
            ctx.lineTo(cx - width * 0.06, tailY - 9)
            ctx.closePath()
            var highlight = ctx.createLinearGradient(cx, topY, cx, tailY)
            highlight.addColorStop(0, "rgba(255,255,255,0.58)")
            highlight.addColorStop(0.42, "rgba(255,255,255,0.16)")
            highlight.addColorStop(1, "rgba(255,255,255,0.00)")
            ctx.fillStyle = highlight
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx, topY)
            ctx.lineTo(rightX, tailY)
            ctx.lineTo(cx, notchY)
            ctx.lineTo(leftX, tailY)
            ctx.closePath()
            ctx.strokeStyle = "rgba(168,252,255,0.72)"
            ctx.lineWidth = 1.2
            ctx.stroke()
        }

        Timer {
            interval: 30
            running: true
            repeat: true
            onTriggered: markerCanvas.requestPaint()
        }
    }
}
