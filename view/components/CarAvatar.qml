import QtQuick
import "../config"
import "../style"

// ─── CarAvatar — Luxury 3D Rear Cutout with Dynamic Lighting ────────
Item {
    id: root

    property bool isHeadlightsOn: false
    property bool isDoorOpenWarning: false

    implicitWidth: 240
    implicitHeight: 150



    // ── Subtle Dark Shadow Beneath Tires ──────────────
    Canvas {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 8
        width: parent.width * 0.82
        height: 20
        antialiasing: true
        smooth: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            var grad = ctx.createRadialGradient(width/2, height/2, 2, width/2, height/2, width/2);
            grad.addColorStop(0.0, "rgba(0, 0, 0, 0.8)");
            grad.addColorStop(1.0, "rgba(0, 0, 0, 0.0)");
            ctx.fillStyle = grad;
            ctx.beginPath();
            ctx.ellipse(0, 0, width, height);
            ctx.fill();
        }
    }

    // ── Pre-rendered Transparent 3D Luxury Vehicle Cutout ─
    Image {
        id: carImage
        anchors.fill: parent
        source: "qrc:/resources/images/car_rear.png"
        fillMode: Image.PreserveAspectFit
        smooth: true
        mipmap: true
    }

    // ── Door warning badge ──────────────────────────────────
    Loader {
        active: root.isDoorOpenWarning
        sourceComponent: Item {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.right
            anchors.leftMargin: 12
            width: 120
            height: 38
            z: 20

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: Qt.rgba(220/255, 38/255, 38/255, 0.3)
                border.color: Qt.rgba(239/255, 68/255, 68/255, 0.6)
                border.width: 1
            }

            Row {
                anchors.centerIn: parent
                spacing: 6
                Rectangle {
                    width: 20; height: 20; radius: 10; color: Theme.red500
                    anchors.verticalCenter: parent.verticalCenter
                    Text { anchors.centerIn: parent; text: "!"; color: Theme.white; font.pixelSize: 14; font.weight: Font.Bold }
                }
                Text {
                    text: "Door Ajar"
                    color: Theme.red500
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
