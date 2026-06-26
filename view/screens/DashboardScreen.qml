import QtQuick
import QtQuick.Shapes
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

    // ─── Main Automotive Cockpit Layout (Pinned 3-Zone Symmetrical Grid) ──
    Item {
        id: desktopCockpit
        anchors.left: parent.left
        anchors.leftMargin: 120
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        visible: root.width >= 768

        // ── Center Stage: 3D Perspective Corridor + Ego Car (Pinned exactly to screen center) ──
        Item {
            id: centerZone
            anchors.centerIn: parent
            width: Math.min(parent.width * 0.4, 460)
            height: Math.min(parent.height * 0.86, 600)

            // 1. Ultra-Wide 3D Perspective Corridor & Shoulders (Folder 09 Standard)
            Canvas {
                id: roadCanvas
                anchors.fill: parent
                antialiasing: true
                smooth: true

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.clearRect(0, 0, width, height);

                    var w = width;
                    var h = height;
                    var horizonY = h * 0.15;
                    var bottomY = h;

                    // Ultra-wide main lane boundaries
                    var bLeftX = w * 0.06;
                    var bRightX = w * 0.94;
                    var tLeftX = w * 0.43;
                    var tRightX = w * 0.57;

                    // Outer shoulder guides
                    var sbLeftX = 0;
                    var sbRightX = w;
                    var stLeftX = w * 0.36;
                    var stRightX = w * 0.64;

                    // Gradients for clean sharp fade towards horizon
                    var lineGrad = ctx.createLinearGradient(0, bottomY, 0, horizonY);
                    lineGrad.addColorStop(0.0, "rgba(0, 229, 255, 0.95)");
                    lineGrad.addColorStop(0.5, "rgba(0, 229, 255, 0.55)");
                    lineGrad.addColorStop(1.0, "rgba(0, 229, 255, 0.00)");

                    var shoulderGrad = ctx.createLinearGradient(0, bottomY, 0, horizonY);
                    shoulderGrad.addColorStop(0.0, "rgba(0, 229, 255, 0.25)");
                    shoulderGrad.addColorStop(0.6, "rgba(0, 229, 255, 0.08)");
                    shoulderGrad.addColorStop(1.0, "rgba(0, 229, 255, 0.00)");

                    // Left Shoulder Guide Line
                    ctx.save();
                    ctx.beginPath();
                    ctx.moveTo(sbLeftX, bottomY);
                    ctx.lineTo(stLeftX, horizonY);
                    ctx.strokeStyle = shoulderGrad;
                    ctx.lineWidth = 1.5;
                    ctx.stroke();
                    ctx.restore();

                    // Right Shoulder Guide Line
                    ctx.save();
                    ctx.beginPath();
                    ctx.moveTo(sbRightX, bottomY);
                    ctx.lineTo(stRightX, horizonY);
                    ctx.strokeStyle = shoulderGrad;
                    ctx.lineWidth = 1.5;
                    ctx.stroke();
                    ctx.restore();

                    // Left Main Road Line
                    ctx.save();
                    ctx.beginPath();
                    ctx.moveTo(bLeftX, bottomY);
                    ctx.lineTo(tLeftX, horizonY);
                    ctx.strokeStyle = lineGrad;
                    ctx.lineWidth = 3.2;
                    ctx.lineCap = "round";
                    ctx.stroke();
                    ctx.restore();

                    // Right Main Road Line
                    ctx.save();
                    ctx.beginPath();
                    ctx.moveTo(bRightX, bottomY);
                    ctx.lineTo(tRightX, horizonY);
                    ctx.strokeStyle = lineGrad;
                    ctx.lineWidth = 3.2;
                    ctx.lineCap = "round";
                    ctx.stroke();
                    ctx.restore();
                }
            }

            // 2. Animated 3D Chevrons Starting Strictly in Front of Car Hood
            Repeater {
                model: 7

                Item {
                    id: chevronItem
                    property real startY: parent.height * 0.44
                    property real endY: parent.height * 0.15
                    property real progress: 0
                    property real chevronOpacity: 0
                    property real chevronScale: 1.0

                    x: parent.width / 2
                    y: startY + (endY - startY) * progress

                    Canvas {
                        anchors.centerIn: parent
                        width: 68 * chevronItem.chevronScale
                        height: 15 * chevronItem.chevronScale
                        antialiasing: true
                        smooth: true
                        opacity: chevronItem.chevronOpacity

                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.clearRect(0, 0, width, height);
                            var w = width;
                            var h = height;
                            var cx = w / 2;
                            var cy = h / 2;

                            ctx.save();
                            ctx.beginPath();
                            ctx.moveTo(cx - w * 0.45, cy + h * 0.4);
                            ctx.lineTo(cx, cy - h * 0.4);
                            ctx.lineTo(cx + w * 0.45, cy + h * 0.4);
                            ctx.strokeStyle = Theme.cyan400;
                            ctx.lineWidth = Math.max(3.0 * chevronItem.chevronScale, 1.5);
                            ctx.lineCap = "round";
                            ctx.lineJoin = "round";
                            ctx.stroke();
                            ctx.restore();
                        }
                    }

                    SequentialAnimation {
                        running: root.visible
                        loops: Animation.Infinite
                        PauseAnimation { duration: index * (1200 / 7) }
                        NumberAnimation {
                            target: chevronItem; property: "progress"
                            from: 0; to: 1; duration: 1200; easing.type: Easing.OutQuad
                        }
                        PauseAnimation { duration: 0 }
                    }

                    SequentialAnimation {
                        running: root.visible
                        loops: Animation.Infinite
                        PauseAnimation { duration: index * (1200 / 7) }
                        SequentialAnimation {
                            NumberAnimation { target: chevronItem; property: "chevronOpacity"; from: 0; to: 0.95; duration: 200; easing.type: Easing.OutQuad }
                            NumberAnimation { target: chevronItem; property: "chevronOpacity"; from: 0.95; to: 0.2; duration: 650; easing.type: Easing.Linear }
                            NumberAnimation { target: chevronItem; property: "chevronOpacity"; from: 0.2; to: 0; duration: 350; easing.type: Easing.InQuad }
                        }
                    }

                    SequentialAnimation {
                        running: root.visible
                        loops: Animation.Infinite
                        PauseAnimation { duration: index * (1200 / 7) }
                        NumberAnimation { target: chevronItem; property: "chevronScale"; from: 1.0; to: 0.35; duration: 1200; easing.type: Easing.OutQuad }
                    }
                }
            }

            // 3. Ego Vehicle Avatar (Anchored upright near bottom)
            CarAvatar {
                id: egoCar
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 48
                width: 250
                height: 156
                isHeadlightsOn: root.isHeadlightsOn
                isDoorOpenWarning: root.isDoorOpenWarning
            }

            // 4. ADAS Autopilot Badge (Anchored below ego car)
            Item {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: egoCar.bottom
                anchors.topMargin: 12
                width: 220
                height: 32

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    Text { text: "📷"; color: Theme.cyan400; font.pixelSize: 15; anchors.verticalCenter: parent.verticalCenter }
                    Text { text: "Auto Pilot Ready"; color: Theme.cyan400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeSm; font.weight: Font.Bold; anchors.verticalCenter: parent.verticalCenter }
                }
            }
        }

        // ── Left Wing: Driving Dynamics & Speedometer (Anchored between Dock and Center) ──
        Item {
            id: leftZone
            anchors.left: parent.left
            anchors.right: centerZone.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            SpeedGauge {
                anchors.centerIn: parent
                speed: root.speed
                speedLimit: root.speedLimit
            }
        }

        // ── Right Wing: Vehicle Telemetry Stack (Anchored between Center and right edge) ──
        Item {
            id: rightZone
            anchors.left: centerZone.right
            anchors.right: parent.right
            anchors.rightMargin: 16
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            Column {
                anchors.centerIn: parent
                width: Math.min(parent.width * 0.9, 310)
                spacing: 20

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

                    // Temp card
                    Rectangle {
                        width: (parent.width - 16) / 2
                        height: 76
                        radius: 16
                        color: Qt.rgba(1, 1, 1, 0.035)
                        border.color: Qt.rgba(1, 1, 1, 0.08)
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: "TEMP"; color: Theme.gray400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeXs; font.weight: Font.Bold }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: "24°C"; color: Theme.white; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize2xl; font.weight: Font.Bold }
                        }
                    }

                    // Odometer card
                    Rectangle {
                        width: (parent.width - 16) / 2
                        height: 76
                        radius: 16
                        color: Qt.rgba(1, 1, 1, 0.035)
                        border.color: Qt.rgba(1, 1, 1, 0.08)
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: "ODOMETER"; color: Theme.gray400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeXs; font.weight: Font.Bold }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.odometer.toFixed(0); color: Theme.white; font.family: Theme.fontFamilyMono; font.pixelSize: Theme.fontSizeXl; font.weight: Font.Bold }
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
