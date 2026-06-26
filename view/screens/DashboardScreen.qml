import QtQuick
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects
import "../config"
import "../style"
import "../components"

// ─── DashboardScreen — speed gauge + car avatar + info panels ──────
// Matches EXACTLY: DashboardScreen.tsx

Item {
    id: root

    // Inputs from telemetryVM context
    property real speed: 0
    property real speedLimit: 60
    property real fuelLevel: 75
    property real fuelRange: 350
    property real odometer: 0
    property bool isHeadlightsOn: false
    property bool isDoorOpenWarning: false
    property bool isActive: false

    anchors.fill: parent

    // ─── Background gradient ──────────────────────────────
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.bgDashboardStart }
            GradientStop { position: 1.0; color: Theme.bgDashboardEnd }
        }
    }

    // ─── Blue radial accent blur behind content ───────────
    Rectangle {
        anchors.centerIn: parent
        width: parent.width * 0.6
        height: parent.height * 0.6
        radius: Math.max(width, height) / 2
        color: Qt.rgba(30/255, 58/255, 138/255, 0.1)          // blue-900/10
        z: 0

        layer.enabled: true
        layer.effect: FastBlur {
            radius: 120
            transparentBorder: true
        }
    }

    // ─── Main layout (3 columns on desktop, stacked on mobile) ──
    Row {
        anchors.fill: parent
        anchors.margins: 48
        spacing: 32
        visible: root.width >= 768

        // ── Left: Speed Gauge ──────────────────────────
        Item {
            width: parent.width * 0.3
            height: parent.height

            SpeedGauge {
                anchors.centerIn: parent
                speed: root.speed
                speedLimit: root.speedLimit
            }
        }

        // ── Center: Car Avatar + ADAS ──────────────────
        Item {
            width: parent.width * 0.35
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 48

                // 3D Perspective Road
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 400
                    height: 400

                    // Dashed lane lines (perspective - wider at bottom)
                    Canvas {
                        anchors.fill: parent
                        onPaint: {
                            const ctx = getContext("2d")
                            const w = width / 2
                            const topY = height * 0.2
                            const botY = height * 0.85
                            ctx.clearRect(0, 0, width, height)

                            // Left dashed line
                            ctx.beginPath()
                            ctx.moveTo(w - 60, topY)
                            ctx.lineTo(w - 100, botY)
                            ctx.strokeStyle = "rgba(255,255,255,0.15)"
                            ctx.lineWidth = 3
                            ctx.setLineDash([15, 20])
                            ctx.stroke()

                            // Right dashed line
                            ctx.beginPath()
                            ctx.moveTo(w + 60, topY)
                            ctx.lineTo(w + 100, botY)
                            ctx.stroke()

                            // Radar wave 1
                            ctx.setLineDash([])
                            ctx.beginPath()
                            ctx.ellipse(w - 160, height * 0.3, 320, 80)
                            ctx.strokeStyle = "rgba(59,130,246,0.4)"
                            ctx.lineWidth = 4
                            ctx.stroke()

                            // Radar wave 2
                            ctx.beginPath()
                            ctx.ellipse(w - 120, height * 0.5, 240, 60)
                            ctx.strokeStyle = "rgba(96,165,250,0.6)"
                            ctx.stroke()
                        }
                    }
                }

                // Car avatar
                CarAvatar {
                    anchors.horizontalCenter: parent.horizontalCenter
                    isHeadlightsOn: root.isHeadlightsOn
                    isDoorOpenWarning: root.isDoorOpenWarning
                }

                // ADAS Badge: "Auto Pilot Ready"
                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 220
                    height: 44
                    radius: 22
                    color: Qt.rgba(37/255, 99/255, 235/255, 0.2)
                    border.color: Qt.rgba(59/255, 130/255, 246/255, 0.3)
                    border.width: 1

                    layer.enabled: true
                    layer.effect: FastBlur {
                        radius: 6
                        transparentBorder: true
                    }

                    Row {
                        anchors.centerIn: parent
                        spacing: 8

                        Text {
                            text: "📷"
                            color: Theme.blue400
                            font.pixelSize: 16
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "Auto Pilot Ready"
                            color: Theme.blue400
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeSm
                            font.weight: Font.Bold
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }
            }
        }

        // ── Right: Info Panels ──────────────────────────
        Column {
            width: parent.width * 0.35
            height: parent.height
            spacing: 24

            EnergyPanel {
                width: parent.width
                fuelLevel: root.fuelLevel
                fuelRange: root.fuelRange
            }

            TirePressureCard {
                width: parent.width
            }

            Row {
                width: parent.width
                spacing: 24

                // Temp card
                Rectangle {
                    width: (parent.width - 24) / 2
                    height: 80
                    radius: 16
                    color: Theme.glassBgWhite5
                    border.color: Theme.glassBorder
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Temp"
                            color: Theme.gray400
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXs
                            font.weight: Font.Bold
                            font.capitalization: Font.AllUppercase
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "24°C"
                            color: Theme.white
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize2xl
                            font.weight: Font.Bold
                        }
                    }
                }

                // Odometer card
                Rectangle {
                    width: (parent.width - 24) / 2
                    height: 80
                    radius: 16
                    color: Theme.glassBgWhite5
                    border.color: Theme.glassBorder
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 4

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Odometer"
                            color: Theme.gray400
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXs
                            font.weight: Font.Bold
                            font.capitalization: Font.AllUppercase
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.odometer.toFixed(0)
                            color: Theme.white
                            font.family: Theme.fontFamilyMono
                            font.pixelSize: Theme.fontSizeXl
                            font.weight: Font.Bold
                        }
                    }
                }
            }
        }
    }

    // ─── Mobile layout (stacked) ──────────────────────────
    Flickable {
        anchors.fill: parent
        anchors.margins: 24
        contentHeight: mobileCol.implicitHeight + 200
        visible: root.width < 768
        clip: true

        Column {
            id: mobileCol
            width: parent.width
            spacing: 32
            topPadding: 80
            bottomPadding: 120

            SpeedGauge {
                anchors.horizontalCenter: parent.horizontalCenter
                speed: root.speed
                speedLimit: root.speedLimit
            }

            CarAvatar {
                anchors.horizontalCenter: parent.horizontalCenter
                isHeadlightsOn: root.isHeadlightsOn
                isDoorOpenWarning: root.isDoorOpenWarning
            }

            // ADAS badge
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 220; height: 44
                radius: 22
                color: Qt.rgba(37/255, 99/255, 235/255, 0.2)
                border.color: Qt.rgba(59/255, 130/255, 246/255, 0.3)

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "📷"; color: Theme.blue400; font.pixelSize: 16 }
                    Text { text: "Auto Pilot Ready"; color: Theme.blue400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeSm; font.weight: Font.Bold }
                }
            }

            EnergyPanel {
                width: parent.width
                fuelLevel: root.fuelLevel
                fuelRange: root.fuelRange
            }

            TirePressureCard {
                width: parent.width
            }

            Row {
                width: parent.width
                spacing: 16

                Rectangle {
                    width: (parent.width - 16) / 2; height: 80
                    radius: 16
                    color: Theme.glassBgWhite5
                    border.color: Theme.glassBorder
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Temp"; color: Theme.gray400; font.pixelSize: Theme.fontSizeXs; font.weight: Font.Bold }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "24°C"; color: Theme.white; font.pixelSize: Theme.fontSize2xl; font.weight: Font.Bold }
                    }
                }

                Rectangle {
                    width: (parent.width - 16) / 2; height: 80
                    radius: 16
                    color: Theme.glassBgWhite5
                    border.color: Theme.glassBorder
                    Column {
                        anchors.centerIn: parent
                        spacing: 4
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Odometer"; color: Theme.gray400; font.pixelSize: Theme.fontSizeXs; font.weight: Font.Bold }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.odometer.toFixed(0); color: Theme.white; font.family: Theme.fontFamilyMono; font.pixelSize: Theme.fontSizeXl; font.weight: Font.Bold }
                    }
                }
            }
        }
    }

    // ─── TelemetryVM data bindings ────────────────────────
    Component.onCompleted: {
        if (typeof telemetryVM !== "undefined") {
            speed = Qt.binding(function() { return telemetryVM.speed })
            speedLimit = Qt.binding(function() { return telemetryVM.speedLimit })
            fuelLevel = Qt.binding(function() { return telemetryVM.fuelLevel })
            fuelRange = Qt.binding(function() { return telemetryVM.fuelRange })
            odometer = Qt.binding(function() { return telemetryVM.odometer })
            isHeadlightsOn = Qt.binding(function() { return telemetryVM.isHeadlightsOn })
            isDoorOpenWarning = Qt.binding(function() { return telemetryVM.isDoorOpenWarning })
        }
    }
}
