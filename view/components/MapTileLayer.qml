import QtQuick
import "../config"

Item {
    id: root
    property real centerLat: 10.7710
    property real centerLng: 106.7048
    property real zoomLevel: 17.5
    property url tileBaseUrl: "https://basemaps.cartocdn.com/dark_all/"
    property int gridSize: Theme.mapTileGridSize
    property int tileSize: 256

    readonly property int tileZoom: Math.floor(zoomLevel)
    readonly property real tileScale: Math.pow(2, zoomLevel - tileZoom)
    readonly property real ppt: tileSize * tileScale
    readonly property int halfGrid: Math.floor(gridSize / 2)

    function lngToTileX(lng, z) { return Math.floor((lng + 180) / 360 * Math.pow(2, z)) }
    function latToTileY(lat, z) {
        var r = lat * Math.PI / 180
        return Math.floor((1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2 * Math.pow(2, z))
    }
    function worldX(lng, z) { return (lng + 180) / 360 * Math.pow(2, z) * ppt }
    function worldY(lat, z) {
        var r = lat * Math.PI / 180
        return (1 - Math.log(Math.tan(r) + 1 / Math.cos(r)) / Math.PI) / 2 * Math.pow(2, z) * ppt
    }

    function latLngToScreen(lat, lng) {
        var wcx = worldX(centerLng, tileZoom)
        var wcy = worldY(centerLat, tileZoom)
        var swx = worldX(lng, tileZoom)
        var swy = worldY(lat, tileZoom)
        return { x: width / 2 + (swx - wcx), y: height / 2 + (swy - wcy) }
    }

    onCenterLatChanged: canvas.requestPaint()
    onCenterLngChanged: canvas.requestPaint()

    Canvas {
        id: canvas
        anchors { fill: parent; margins: -Theme.mapCanvasMargin }
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var z = root.tileZoom
            var wx = root.worldX(root.centerLng, z)
            var wy = root.worldY(root.centerLat, z)

            ctx.fillStyle = Theme.mapBackground
            ctx.fillRect(0, 0, width, height)

            if (Theme.useRasterMapTiles) {
                var cx = root.lngToTileX(root.centerLng, z)
                var cy = root.latToTileY(root.centerLat, z)
                var originX = width / 2 - wx + cx * root.ppt
                var originY = height / 2 - wy + cy * root.ppt

                for (var dy = -root.halfGrid; dy <= root.halfGrid; dy++) {
                    for (var dx = -root.halfGrid; dx <= root.halfGrid; dx++) {
                        var tx = cx + dx
                        var ty = cy + dy
                        if (ty < 0 || ty >= Math.pow(2, z)) continue
                        var sx = originX + dx * root.ppt
                        var sy = originY + dy * root.ppt
                        if (sx + root.ppt < 0 || sx > width || sy + root.ppt < 0 || sy > height) continue
                        var url = root.tileBaseUrl + z + "/" + tx + "/" + ty + ".png"
                        ctx.drawImage(url, sx, sy, root.ppt, root.ppt)
                    }
                }
                return
            }

            var minor = Theme.mapMinorRoadSpacing
            var major = Theme.mapMajorRoadSpacing
            var xOffset = ((wx % minor) + minor) % minor
            var yOffset = ((wy % minor) + minor) % minor

            ctx.fillStyle = Theme.mapBlockFill
            for (var by = -yOffset; by < height; by += minor) {
                for (var bx = -xOffset; bx < width; bx += minor) {
                    ctx.fillRect(bx + Theme.mapMajorRoadWidth, by + Theme.mapMajorRoadWidth,
                                 minor - Theme.mapMajorRoadWidth * 2,
                                 minor - Theme.mapMajorRoadWidth * 2)
                }
            }

            ctx.lineCap = "round"
            ctx.strokeStyle = Theme.mapMinorRoad
            ctx.lineWidth = Theme.mapMinorRoadWidth
            ctx.beginPath()
            for (var x = -xOffset; x < width; x += minor) {
                ctx.moveTo(x, 0)
                ctx.lineTo(x, height)
            }
            for (var y = -yOffset; y < height; y += minor) {
                ctx.moveTo(0, y)
                ctx.lineTo(width, y)
            }
            ctx.stroke()

            ctx.strokeStyle = Theme.mapMajorRoad
            ctx.lineWidth = Theme.mapMajorRoadWidth
            ctx.beginPath()
            var majorXOffset = ((wx % major) + major) % major
            var majorYOffset = ((wy % major) + major) % major
            for (var mx = -majorXOffset; mx < width; mx += major) {
                ctx.moveTo(mx, 0)
                ctx.lineTo(mx, height)
            }
            for (var my = -majorYOffset; my < height; my += major) {
                ctx.moveTo(0, my)
                ctx.lineTo(width, my)
            }
            ctx.stroke()

            ctx.strokeStyle = Theme.mapWaterway
            ctx.lineWidth = Theme.mapDiagonalRoadWidth
            ctx.beginPath()
            ctx.moveTo(width * Theme.mapWaterwayStartXFactor - xOffset, height)
            ctx.bezierCurveTo(width * Theme.mapWaterwayControl1XFactor,
                               height * Theme.mapWaterwayControl1YFactor,
                               width * Theme.mapWaterwayControl2XFactor,
                               height * Theme.mapWaterwayControl2YFactor,
                               width,
                               height * Theme.mapWaterwayEndYFactor + yOffset)
            ctx.stroke()

            ctx.strokeStyle = Theme.mapMajorRoad
            ctx.lineWidth = Theme.mapDiagonalRoadWidth
            ctx.beginPath()
            ctx.moveTo(-majorXOffset, height * Theme.mapDiagonalRoadStartYFactor)
            ctx.lineTo(width, height * Theme.mapDiagonalRoadEndYFactor + majorYOffset)
            ctx.stroke()
        }
        Timer {
            interval: Theme.mapTileRepaintInterval
            running: Theme.useRasterMapTiles
            repeat: true
            onTriggered: canvas.requestPaint()
        }
        Component.onCompleted: requestPaint()
    }
}
