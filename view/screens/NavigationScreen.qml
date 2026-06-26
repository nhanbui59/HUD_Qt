import QtQuick
import "../config"
import "../overlays"
import "../components"

Item {
    id: root
    property real currentLng: 106.7030
    property real currentLat: 10.7710
    property real heading: 0
    property var routePath: []
    readonly property real fallbackDestLng: 106.705199
    readonly property real fallbackDestLat: 10.771564
    readonly property var destinationPoint: routeDestination()
    readonly property real destLng: pointLng(destinationPoint)
    readonly property real destLat: pointLat(destinationPoint)
    anchors.fill: parent

    function pointLat(point) {
        if (typeof point === "object" && point !== null && point.lat !== undefined) return point.lat
        if (point && point[1] !== undefined) return point[1]
        return fallbackDestLat
    }

    function pointLng(point) {
        if (typeof point === "object" && point !== null && point.lng !== undefined) return point.lng
        if (point && point[0] !== undefined) return point[0]
        return fallbackDestLng
    }

    function routeDestination() {
        if (routePath && routePath.length > 1) return routePath[routePath.length - 1]
        return { lat: fallbackDestLat, lng: fallbackDestLng }
    }

    Rectangle { anchors.fill: parent; color: "#0a0a0a" }

    // Rotating map world
    Item {
        id: mapWorld
        anchors.fill: parent
        transform: Rotation {
            origin.x: mapWorld.width / 2
            origin.y: mapWorld.height / 2
            angle: -root.heading
            Behavior on angle { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
        }

        MapTileLayer {
            id: mapTiles
            anchors.fill: parent
            centerLat: root.currentLat
            centerLng: root.currentLng
            zoomLevel: 17.5
        }

        // Route path — neon green, inside rotated world
        Canvas {
            id: routeCanvas
            anchors.fill: parent
            z: 2
            property var cachedPoints: []
            property var cachedPathRef: null

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (!root.routePath || root.routePath.length < 2) return

                // Only rebuild points if routePath reference changed
                if (root.routePath !== cachedPathRef) {
                    cachedPathRef = root.routePath
                    cachedPoints = []
                    for (var i = 0; i < root.routePath.length; i++) {
                        var rp = root.routePath[i]
                        var lat = (typeof rp === "object" && rp.lat !== undefined) ? rp.lat : (rp[1] || 0)
                        var lng = (typeof rp === "object" && rp.lng !== undefined) ? rp.lng : (rp[0] || 0)
                        // Store as world coordinates, convert at paint time
                        cachedPoints.push({ lat: lat, lng: lng })
                    }
                }

                // Convert to screen each paint (handles rotation)
                var pts = []
                for (var j = 0; j < cachedPoints.length; j++) {
                    pts.push(mapTiles.latLngToScreen(cachedPoints[j].lat, cachedPoints[j].lng))
                }
                if (pts.length < 2) return

                ctx.save()
                ctx.beginPath()
                ctx.strokeStyle = "rgba(74, 222, 128, 0.35)"
                ctx.lineWidth = 12
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.moveTo(pts[0].x, pts[0].y)
                for (var k = 1; k < pts.length; k++) ctx.lineTo(pts[k].x, pts[k].y)
                ctx.stroke()
                ctx.restore()

                ctx.save()
                ctx.beginPath()
                ctx.strokeStyle = "#22c55e"
                ctx.lineWidth = 6
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.moveTo(pts[0].x, pts[0].y)
                for (var m = 1; m < pts.length; m++) ctx.lineTo(pts[m].x, pts[m].y)
                ctx.stroke()
                ctx.restore()
            }
            // Redraw on each frame
            Timer { interval: Theme.routeRepaintInterval; running: true; repeat: true; onTriggered: routeCanvas.requestPaint() }
        }

        // Destination pin
        DestinationMarker {
            z: 3
            property var sp: mapTiles.latLngToScreen(root.destLat, root.destLng)
            x: sp.x - width / 2
            y: sp.y - height
            transform: Rotation {
                origin.x: width / 2
                origin.y: height
                angle: root.heading
            }
        }

        // Street labels
        Repeater {
            model: [
                { t: "Bitexco Tower", lat: 10.7716, lng: 106.7052 },
                { t: "Nguyen Hue", lat: 10.7730, lng: 106.7030 },
                { t: "Ham Nghi", lat: 10.7710, lng: 106.7035 },
                { t: "Ho Tung Mau", lat: 10.7725, lng: 106.7045 }
            ]
            delegate: Text {
                z: 4
                property var pp: mapTiles.latLngToScreen(modelData.lat, modelData.lng)
                x: pp.x - width / 2; y: pp.y - height / 2
                text: modelData.t; color: "#a3a3a3"; font.family: "Helvetica"; font.pixelSize: 14; font.weight: Font.DemiBold
                style: Text.Outline; styleColor: "#171717"; horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // Car marker — screen center, always upright
    CarMarker { anchors.centerIn: parent; z: 10; width: 120; height: 80 }

    // Destination info text
    Text {
        z: 15
        anchors { left: parent.left; leftMargin: 40; bottom: parent.bottom; bottomMargin: 180 }
        text: "DESTINATION: BITEXCO FINANCIAL TOWER\n[" + root.destLat.toFixed(6) + "\u00B0 N, " + root.destLng.toFixed(6) + "\u00B0 E]"
        color: Qt.rgba(1, 1, 1, 0.35); font.family: "Courier New"; font.pixelSize: 11
    }

    HeaderPanel { id: headerPanel; z: 25; anchors { top: parent.top; topMargin: 24; horizontalCenter: parent.horizontalCenter } }
    SidePanel { id: sidePanel; z: 30 }
    BottomPanel { id: bottomPanel; z: 20 }

    // Vignette edges
    Item {
        anchors.fill: parent
        z: 8
        Rectangle {
            anchors { top: parent.top; left: parent.left; right: parent.right }
            height: parent.height * 0.06
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0, 0, 0, 0.4) }
                GradientStop { position: 1; color: "transparent" }
            }
        }
        Rectangle {
            anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
            height: parent.height * 0.3
            gradient: Gradient {
                GradientStop { position: 0; color: Qt.rgba(0, 0, 0, 0.8) }
                GradientStop { position: 1; color: "transparent" }
            }
        }
    }

    Component.onCompleted: {
        if (typeof telemetryVM !== "undefined") {
            currentLng = Qt.binding(function() { return telemetryVM.currentLng })
            currentLat = Qt.binding(function() { return telemetryVM.currentLat })
            heading = Qt.binding(function() { return telemetryVM.heading })
            routePath = Qt.binding(function() { return telemetryVM.routePath })
            headerPanel.speed = Qt.binding(function() { return telemetryVM.speed })
            headerPanel.speedLimit = Qt.binding(function() { return telemetryVM.speedLimit })
            headerPanel.nextTurnStreet = Qt.binding(function() { return telemetryVM.nextTurnStreet })
            headerPanel.nextTurnDistance = Qt.binding(function() { return telemetryVM.nextTurnDistance })
            headerPanel.isHeadlightsOn = Qt.binding(function() { return telemetryVM.isHeadlightsOn })
            headerPanel.isDoorOpenWarning = Qt.binding(function() { return telemetryVM.isDoorOpenWarning })
            sidePanel.isEcoMode = Qt.binding(function() { return telemetryVM.isEcoMode })
            sidePanel.isLaneAssistOn = Qt.binding(function() { return telemetryVM.isLaneAssistOn })
            bottomPanel.nextTurnStreet = Qt.binding(function() { return telemetryVM.nextTurnStreet })
            bottomPanel.nextTurnDistance = Qt.binding(function() { return telemetryVM.nextTurnDistance })
            bottomPanel.currentStreet = Qt.binding(function() { return telemetryVM.currentStreet })
            bottomPanel.nextTurnManeuver = Qt.binding(function() { return telemetryVM.nextTurnManeuver })
            bottomPanel.totalDistanceRemaining = Qt.binding(function() { return telemetryVM.totalDistanceRemaining })
            bottomPanel.eta = Qt.binding(function() { return telemetryVM.eta })
            bottomPanel.odometer = Qt.binding(function() { return telemetryVM.odometer })
            bottomPanel.fuelLevel = Qt.binding(function() { return telemetryVM.fuelLevel })
            bottomPanel.fuelRange = Qt.binding(function() { return telemetryVM.fuelRange })
        }
    }
}
