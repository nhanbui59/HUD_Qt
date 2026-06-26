import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import "../config"
import "../style"

// ─── EnergyPanel — fuel/energy card with progress bar ──────────────
// Matches EXACTLY: DashboardScreen.tsx energy section

Item {
    id: root

    // Inputs from telemetryVM
    property real fuelLevel: 75.0        // 0-100
    property real fuelRange: 350.0       // km

    implicitWidth: 320
    implicitHeight: 180

    Rectangle {
        anchors.fill: parent
        radius: 24
        color: Theme.glassBgWhite5
        border.color: Theme.glassBorder
        border.width: 1

        layer.enabled: true
        layer.effect: FastBlur {
            radius: 6
            transparentBorder: true
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header
        Row {
            spacing: 8
            Text {
                text: "⚡"
                color: Theme.yellow500
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "Energy"
                color: Theme.gray400
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Fuel % + range
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Text {
                text: root.fuelLevel.toFixed(0)
                color: Theme.white
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize4xl
                font.weight: Font.Light
            }

            Text {
                text: "%"
                color: Theme.gray400
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize2xl
                font.weight: Font.Normal
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: root.fuelRange.toFixed(0) + " km range"
                color: Theme.gray300
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeXl
                font.weight: Font.Medium
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // Progress bar
        Item {
            width: parent.width
            height: 8

            // Track
            Rectangle {
                anchors.fill: parent
                radius: 4
                color: Theme.glassBgWhite10
            }

            // Fill
            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height
                radius: 4
                width: parent.width * Math.min(1.0, Math.max(0, root.fuelLevel / 100))

                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: root.fuelLevel > Theme.fuelLowThreshold ? Theme.green500 : Theme.red500
                    }
                    GradientStop {
                        position: 1.0
                        color: root.fuelLevel > Theme.fuelLowThreshold ? Theme.emerald400 : Theme.red500
                    }
                }

                Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }
                Behavior on color { ColorAnimation { duration: 500 } }
            }
        }
    }
}
