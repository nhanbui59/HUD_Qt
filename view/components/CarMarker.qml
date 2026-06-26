import QtQuick
import "../config"

Item {
    id: root
    implicitWidth: 120; implicitHeight: 80

    Canvas { id: ringsCanvas; anchors.fill: parent
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            var cx=width/2; var cy=height/2
            ctx.beginPath(); ctx.fillStyle="rgba(0,240,255,0.10)"; ctx.ellipse(cx,cy,52,28); ctx.fill()
            ctx.beginPath(); ctx.strokeStyle="rgba(0,240,255,0.38)"; ctx.lineWidth=1
            ctx.ellipse(cx,cy,50,26); ctx.stroke()
        }
        Component.onCompleted: requestPaint()
    }

    Canvas { id:arrowCanvas; anchors.centerIn:parent; width:46; height:58; anchors.verticalCenterOffset:-4
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
