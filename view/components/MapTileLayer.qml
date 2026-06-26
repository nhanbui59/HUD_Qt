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
        anchors { fill: parent; margins: -200 }
        onPaint: {
            var ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            var z = root.tileZoom
            var cx = root.lngToTileX(root.centerLng, z)
            var cy = root.latToTileY(root.centerLat, z)
            var wx = root.worldX(root.centerLng, z)
            var wy = root.worldY(root.centerLat, z)
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
        }
        Timer { interval: Theme.mapTileRepaintInterval; running: true; repeat: true; onTriggered: canvas.requestPaint() }
    }
}
