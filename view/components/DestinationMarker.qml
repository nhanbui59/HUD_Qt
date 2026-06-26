import QtQuick
import "../config"

Item {
    id: root

    implicitWidth: 56
    implicitHeight: 78
    readonly property real tipX: width / 2
    readonly property real tipY: height

    Canvas {
        id: markerCanvas
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var cx = width / 2
            var sphereY = height * 0.30
            var sphereRx = width * 0.27
            var sphereRy = height * 0.18
            var tipY = height - 2
            var stemTopY = sphereY + sphereRy * 0.52
            var stemHalfTop = width * 0.095
            var stemHalfBottom = width * 0.030

            ctx.save()
            ctx.translate(cx, tipY - height * 0.025)
            ctx.scale(1, 0.34)
            var shadow = ctx.createRadialGradient(0, 0, 2, 0, 0, width * 0.28)
            shadow.addColorStop(0, "rgba(37,99,235,0.30)")
            shadow.addColorStop(0.58, "rgba(37,99,235,0.12)")
            shadow.addColorStop(1, "rgba(0,0,0,0.00)")
            ctx.beginPath()
            ctx.fillStyle = shadow
            ctx.arc(0, 0, width * 0.28, 0, Math.PI * 2)
            ctx.fill()
            ctx.restore()

            ctx.beginPath()
            ctx.moveTo(cx - stemHalfTop, stemTopY)
            ctx.quadraticCurveTo(cx - width * 0.16, height * 0.60, cx - stemHalfBottom, tipY)
            ctx.lineTo(cx + stemHalfBottom, tipY)
            ctx.quadraticCurveTo(cx + width * 0.16, height * 0.60, cx + stemHalfTop, stemTopY)
            ctx.closePath()
            var stem = ctx.createLinearGradient(cx - stemHalfTop, stemTopY, cx + stemHalfTop, tipY)
            stem.addColorStop(0, "#60a5fa")
            stem.addColorStop(0.52, "#2563eb")
            stem.addColorStop(1, "#123f9c")
            ctx.fillStyle = stem
            ctx.fill()

            ctx.beginPath()
            ctx.moveTo(cx + stemHalfTop, stemTopY)
            ctx.quadraticCurveTo(cx + width * 0.16, height * 0.60, cx + stemHalfBottom, tipY)
            ctx.lineTo(cx, tipY)
            ctx.lineTo(cx, stemTopY)
            ctx.closePath()
            ctx.fillStyle = "rgba(12,44,132,0.38)"
            ctx.fill()

            var body = ctx.createRadialGradient(cx - sphereRx * 0.38, sphereY - sphereRy * 0.50,
                                                2, cx, sphereY, sphereRx * 1.25)
            body.addColorStop(0, "#c7f4ff")
            body.addColorStop(0.18, "#60a5fa")
            body.addColorStop(0.68, "#2563eb")
            body.addColorStop(1, "#123f9c")
            ctx.beginPath()
            ctx.ellipse(cx, sphereY, sphereRx, sphereRy, 0, 0, Math.PI * 2)
            ctx.fillStyle = body
            ctx.fill()

            ctx.beginPath()
            ctx.ellipse(cx, sphereY, sphereRx, sphereRy, 0, 0, Math.PI * 2)
            ctx.strokeStyle = "rgba(191,219,254,0.72)"
            ctx.lineWidth = 1.4
            ctx.stroke()

            ctx.beginPath()
            ctx.ellipse(cx - sphereRx * 0.30, sphereY - sphereRy * 0.34,
                        sphereRx * 0.22, sphereRy * 0.14, -0.28, 0, Math.PI * 2)
            ctx.fillStyle = "rgba(255,255,255,0.36)"
            ctx.fill()

            ctx.beginPath()
            ctx.ellipse(cx, sphereY + sphereRy * 0.06,
                        sphereRx * 0.30, sphereRy * 0.26, 0, 0, Math.PI * 2)
            ctx.fillStyle = "rgba(255,255,255,0.92)"
            ctx.fill()

            ctx.beginPath()
            ctx.ellipse(cx, sphereY + sphereRy * 0.06,
                        sphereRx * 0.15, sphereRy * 0.13, 0, 0, Math.PI * 2)
            ctx.fillStyle = "#2563eb"
            ctx.fill()
        }

        Component.onCompleted: requestPaint()
    }
}
