import QtQuick
import "../config"

Item {
    id: root
    implicitWidth: 120; implicitHeight: 80
    readonly property real markerCenterX: width / 2
    readonly property real markerCenterY: height / 2
    readonly property real arrowVerticalOffset: -4
    readonly property real pulseCenterY: markerCenterY + 14

    Canvas { id: ringsCanvas; anchors.fill: parent
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            var cx=root.markerCenterX; var cy=root.pulseCenterY
            var pulsePhase=(Date.now()%1500)/1500
            var pulseScale=0.82+pulsePhase*0.38
            var pulseAlpha=(1-pulsePhase)*0.58

            ctx.beginPath(); ctx.fillStyle="rgba(0,240,255,0.10)"
            ctx.ellipse(cx,cy,42,20,0,0,Math.PI*2); ctx.fill()

            ctx.beginPath(); ctx.strokeStyle="rgba(0,240,255,0.48)"; ctx.lineWidth=1.5
            ctx.ellipse(cx,cy,40,18,0,0,Math.PI*2); ctx.stroke()

            ctx.beginPath(); ctx.strokeStyle="rgba(0,240,255,"+pulseAlpha.toFixed(2)+")"; ctx.lineWidth=1.4
            ctx.ellipse(cx,cy,44*pulseScale,21*pulseScale,0,0,Math.PI*2); ctx.stroke()
        }
        Timer { interval:30; running:true; repeat:true; onTriggered: ringsCanvas.requestPaint() }
    }

    Canvas { id:arrowCanvas; anchors.centerIn:parent; width:46; height:58; anchors.verticalCenterOffset: root.arrowVerticalOffset
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            // depth shadow
            ctx.beginPath(); ctx.fillStyle="rgba(0,0,0,0.52)"; ctx.moveTo(width/2,4); ctx.lineTo(width-3,height-2)
            ctx.lineTo(width/2,height*0.68); ctx.lineTo(3,height-2); ctx.closePath(); ctx.fill()
            // cyan body
            ctx.beginPath(); ctx.fillStyle="#00f0ff"; ctx.moveTo(width/2,0); ctx.lineTo(width-4,height-5)
            ctx.lineTo(width/2,height*0.66); ctx.lineTo(4,height-5); ctx.closePath(); ctx.fill()
            // white highlight
            ctx.beginPath(); var g=ctx.createLinearGradient(0,0,width,height)
            g.addColorStop(0,"transparent"); g.addColorStop(0.35,"rgba(255,255,255,0.35)"); g.addColorStop(1,"transparent")
            ctx.fillStyle=g; ctx.moveTo(width/2,3); ctx.lineTo(width-8,height-9); ctx.lineTo(width/2,height*0.61); ctx.lineTo(8,height-9); ctx.closePath(); ctx.fill()
        }
    }
}
