import QtQuick
import QtQuick.Shapes
import "../config"
import "../style"

// ─── CarAvatar — top-down car with headlights/taillights ────────────
// Matches EXACTLY: DashboardScreen.tsx CarSVG + center car section

Item {
    id: root

    // Inputs from telemetryVM
    property bool isHeadlightsOn: false
    property bool isDoorOpenWarning: false

    implicitWidth: 160
    implicitHeight: 340

    // ─── Drop shadow under car ───────────────────────────────
    Rectangle {
        anchors.centerIn: carBody
        width: carBody.width * 0.85
        height: carBody.height * 0.95
        radius: width * 0.5
        color: Qt.rgba(0, 0, 0, 0.6)
        z: 0

        layer.enabled: false
    }

    // ─── Car Body (pill shape) ───────────────────────────────
    Shape {
        id: carBody
        anchors.centerIn: parent
        width: 64
        height: 200
        z: 1

        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1.5

            fillColor: "#2c3036"

            // Pill shape: rect with rx=32
            startX: 18; startY: 10
            PathLine { x: 82; y: 10 }
            PathArc { x: 82; y: 210; radiusX: 32; radiusY: 32 }
            PathLine { x: 18; y: 210 }
            PathArc { x: 18; y: 10; radiusX: 32; radiusY: 32 }
        }

        // Hood detail lines
        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1.5
            fillColor: "transparent"
            startX: 22; startY: 55
            PathQuad { x: 78; y: 55; controlX: 50; controlY: 70 }
        }
        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1
            fillColor: "transparent"
            startX: 35; startY: 15
            PathLine { x: 32; y: 55 }
        }
        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1
            fillColor: "transparent"
            startX: 65; startY: 15
            PathLine { x: 68; y: 55 }
        }
    }

    // ─── Panoramic Glass Roof ────────────────────────────────
    Shape {
        anchors.centerIn: parent
        width: 64
        height: 200
        z: 2

        ShapePath {
            strokeColor: "#111111"
            strokeWidth: 1.5

            fillColor: "#111318"

            startX: 24; startY: 75
            PathLine { x: 76; y: 75 }
            PathQuad { x: 76; y: 170; controlX: 82; controlY: 120 }
            PathLine { x: 24; y: 170 }
            PathQuad { x: 24; y: 75; controlX: 18; controlY: 120 }
        }
    }

    // ─── Side Mirrors ─────────────────────────────────────────
    Shape {
        anchors.centerIn: parent
        width: 64
        height: 200
        z: 3

        // Left mirror
        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1
            fillColor: "#2c3036"
            startX: 18; startY: 85
            PathLine { x: 12; y: 85 }
            PathLine { x: 14; y: 92 }
            PathLine { x: 18; y: 92 }
        }
        // Right mirror
        ShapePath {
            strokeColor: "#1f2229"
            strokeWidth: 1
            fillColor: "#2c3036"
            startX: 82; startY: 85
            PathLine { x: 88; y: 85 }
            PathLine { x: 86; y: 92 }
            PathLine { x: 82; y: 92 }
        }
    }

    // ─── Headlights ──────────────────────────────────────────
    // Left headlight
    Rectangle {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: -22
        anchors.verticalCenterOffset: -93
        width: 10; height: 4
        radius: 2
        color: root.isHeadlightsOn ? Theme.white : Theme.slate300
        z: 4
    }
    // Right headlight
    Rectangle {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: 22
        anchors.verticalCenterOffset: -93
        width: 10; height: 4
        radius: 2
        color: root.isHeadlightsOn ? Theme.white : Theme.slate300
        z: 4
    }

    // Headlight glow (when on)
    Loader {
        active: root.isHeadlightsOn
        sourceComponent: Item {
            anchors.centerIn: parent
            z: 4

            // Left glow ellipse
            Rectangle {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: -22
                anchors.verticalCenterOffset: -92
                width: 16; height: 8
                radius: 4
                color: Qt.rgba(1, 1, 1, 0.8)
                layer.enabled: false
            }
            // Right glow ellipse
            Rectangle {
                anchors.centerIn: parent
                anchors.horizontalCenterOffset: 22
                anchors.verticalCenterOffset: -92
                width: 16; height: 8
                radius: 4
                color: Qt.rgba(1, 1, 1, 0.8)
                layer.enabled: false
            }
        }
    }

    // ─── Taillights (Red LED strip) ──────────────────────────
    Shape {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 93
        width: 64
        height: 6
        z: 4

        ShapePath {
            strokeColor: "#ff3333"
            strokeWidth: 3
            fillColor: "transparent"
            startX: 22; startY: 3
            PathQuad { x: 78; y: 3; controlX: 50; controlY: 6 }
        }
        ShapePath {
            strokeColor: Theme.red400
            strokeWidth: 1
            fillColor: "transparent"
            startX: 22; startY: 3
            PathQuad { x: 78; y: 3; controlX: 50; controlY: 6 }
        }
    }

    // ─── Headlight beams projection (conditional) ────────────
    Loader {
        active: root.isHeadlightsOn
        sourceComponent: Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            y: -160
            width: 320; height: 320
            radius: 160
            color: "transparent"

            Rectangle {
                anchors.fill: parent
                radius: parent.radius
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 0.7; color: Qt.rgba(1, 1, 1, 0.4) }
                }

                layer.enabled: false
            }
            z: -1
        }
    }

    // ─── Door warning badge ──────────────────────────────────
    Loader {
        active: root.isDoorOpenWarning
        sourceComponent: Item {
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.height * 0.1
            anchors.left: parent.right
            anchors.leftMargin: -10
            width: 120
            height: 40
            z: 20

            Rectangle {
                anchors.fill: parent
                radius: 12
                color: Qt.rgba(220/255, 38/255, 38/255, 0.3)
                border.color: Qt.rgba(239/255, 68/255, 68/255, 0.5)
                border.width: 1

                // Red glow shadow
                Rectangle {
                    anchors.fill: parent
                    radius: parent.radius
                    color: Qt.rgba(239/255, 68/255, 68/255, 0.5)
                    opacity: 0.5
                    layer.enabled: false
                }
            }

            Row {
                anchors.centerIn: parent
                spacing: 6

                // Alert icon (exclamation in circle)
                Rectangle {
                    width: 20; height: 20
                    radius: 10
                    color: Theme.red500
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        anchors.centerIn: parent
                        text: "!"
                        color: Theme.white
                        font.family: Theme.fontFamily
                        font.pixelSize: 14
                        font.weight: Font.Bold
                    }
                }

                Text {
                    text: "Door Ajar"
                    color: Theme.red500
                    font.family: Theme.fontFamily
                    font.pixelSize: 13
                    font.weight: Font.Bold
                    font.capitalization: Font.AllUppercase
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
