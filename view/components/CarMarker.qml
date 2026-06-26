import QtQuick
import "../config"

Item {
    id: root
    implicitWidth: 120; implicitHeight: 80

    Canvas { id: ringsCanvas; anchors.fill: parent
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            var cx=width/2; var cy=height/2
            // Inner glow
            ctx.beginPath(); ctx.fillStyle="rgba(0,240,255,0.08)"; ctx.ellipse(cx-45,cy-22,90,45); ctx.fill()
            // Middle ring
            ctx.beginPath(); ctx.strokeStyle="rgba(0,240,255,0.8)"; ctx.lineWidth=1
            ctx.ellipse(cx-25,cy-12,50,25); ctx.stroke()
            // Radar pulse ring
            var pulsePhase=(Date.now()%1500)/1500
            var pulseScale=0.8+pulsePhase*0.7
            var pulseAlpha=(1-pulsePhase)*0.75
            ctx.beginPath(); ctx.strokeStyle="rgba(0,240,255,"+pulseAlpha.toFixed(2)+")"; ctx.lineWidth=1
            ctx.ellipse(cx-40*pulseScale, cy-20*pulseScale, 80*pulseScale, 40*pulseScale); ctx.stroke()
        }
        Timer { interval:30; running:true; repeat:true; onTriggered: ringsCanvas.requestPaint() }
    }

    Canvas { id:arrowCanvas; anchors.centerIn:parent; width:36; height:54; anchors.verticalCenterOffset:-4
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            // depth shadow
            ctx.beginPath(); ctx.fillStyle="rgba(0,0,0,0.5)"; ctx.moveTo(width/2,4); ctx.lineTo(width-4,height-2)
            ctx.lineTo(width/2,height*0.76); ctx.lineTo(4,height-2); ctx.closePath(); ctx.fill()
            // cyan body
            ctx.beginPath(); ctx.fillStyle="#00f0ff"; ctx.moveTo(width/2,0); ctx.lineTo(width-6,height-6)
            ctx.lineTo(width/2,height*0.74); ctx.lineTo(6,height-6); ctx.closePath(); ctx.fill()
            // white highlight
            ctx.beginPath(); var g=ctx.createLinearGradient(0,0,width,height)
            g.addColorStop(0,"transparent"); g.addColorStop(0.35,"rgba(255,255,255,0.35)"); g.addColorStop(1,"transparent")
            ctx.fillStyle=g; ctx.moveTo(width/2,2); ctx.lineTo(width-8,height-8); ctx.lineTo(width/2,height*0.7); ctx.lineTo(8,height-8); ctx.closePath(); ctx.fill()
        }
    }

    Canvas { id:thrustCanvas; width:20; height:24; anchors.horizontalCenter:parent.horizontalCenter; y:parent.height/2+22
        onPaint: {
            var ctx=getContext("2d"); ctx.clearRect(0,0,width,height)
            var thrustPhase=(Date.now()%1000)/1000
            var alpha=0.5+thrustPhase*0.5
            ctx.beginPath(); ctx.fillStyle="rgba(0,240,255,"+alpha.toFixed(2)+")"; ctx.ellipse(0,0,20,24); ctx.fill()
        }
        Timer { interval:30; running:true; repeat:true; onTriggered: thrustCanvas.requestPaint() }
    }
}
