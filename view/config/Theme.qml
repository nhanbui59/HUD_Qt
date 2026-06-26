pragma Singleton
import QtQuick

QtObject {
    // ─── Background Colors ───────────────────────────────────────────
    readonly property color bgPrimary: "#0a0a0a"
    readonly property color bgDashboardStart: "#050508"
    readonly property color bgDashboardEnd: "#12151c"
    readonly property color bgMediaStart: "#1a1a2e"
    readonly property color bgMediaEnd: "#0f0f1a"
    readonly property color bgNavigation: "#020617"          // slate-950 fallback

    // ─── Accent / Brand ─────────────────────────────────────────────
    readonly property color blue400: "#60a5fa"
    readonly property color blue500: "#3b82f6"
    readonly property color blue600: "#2563eb"
    readonly property color blue700: "#1d4ed8"
    readonly property color blue900: "#1e3a5f"
    readonly property color cyan300: "#67e8f9"
    readonly property color cyan400: "#00f0ff"
    readonly property color cyanGlow: Qt.rgba(0, 240/255, 1, 0.1)
    readonly property color cyan500: "#06b6d4"
    readonly property color teal300: "#5eead4"
    readonly property color green400: "#4ade80"
    readonly property color green500: "#22c55e"
    readonly property color emerald400: "#34d399"
    readonly property color red400: "#ff8888"
    readonly property color red500: "#ef4444"
    readonly property color red600: "#dc2626"
    readonly property color pink500: "#ec4899"
    readonly property color purple400: "#a78bfa"
    readonly property color purple500: "#8b5cf6"
    readonly property color purple600: "#7c3aed"
    readonly property color orange500: "#f97316"
    readonly property color yellow500: "#eab308"

    // ─── Neutral ─────────────────────────────────────────────────────
    readonly property color white: "#ffffff"
    readonly property color gray300: "#d1d5db"
    readonly property color gray400: "#9ca3af"
    readonly property color gray500: "#6b7280"
    readonly property color gray600: "#4b5563"
    readonly property color gray800: "#1f2937"
    readonly property color slate200: "#e2e8f0"
    readonly property color slate300: "#cbd5e1"
    readonly property color slate400: "#94a3b8"
    readonly property color slate900: "#0f172a"

    // ─── Glass / Panel ──────────────────────────────────────────────
    readonly property color glassBorder: Qt.rgba(1, 1, 1, 0.1)
    readonly property color glassBorderAlt: Qt.rgba(1, 1, 1, 0.05)
    readonly property color glassBg: Qt.rgba(0, 0, 0, 0.4)
    readonly property color glassBgLighter: Qt.rgba(1, 1, 1, 0.05)
    readonly property color glassBgHover: Qt.rgba(1, 1, 1, 0.1)
    readonly property color glassBgWhite5: Qt.rgba(1, 1, 1, 0.05)
    readonly property color glassBgWhite10: Qt.rgba(1, 1, 1, 0.1)
    readonly property color glassBgBlack40: Qt.rgba(0, 0, 0, 0.4)
    readonly property color glassBgBlack50: Qt.rgba(0, 0, 0, 0.5)
    readonly property color glassBgBlack20: Qt.rgba(0, 0, 0, 0.2)

    // ─── Route ───────────────────────────────────────────────────────
    readonly property color routeGlow: "#4ade80"
    readonly property color routeCore: "#22c55e"

    // ─── Screen dimensions ──────────────────────────────────────────
    readonly property int screenWidth: 1024
    readonly property int screenHeight: 600
    readonly property int minimumScreenWidth: 800
    readonly property int minimumScreenHeight: 480
    readonly property int dockButtonSize: 64
    readonly property int dockButtonSizeMobile: 56
    readonly property int dockIconSize: 28
    readonly property int dockIconSizeMobile: 24
    readonly property real dockRadius: 24
    readonly property int transitionDuration: 500

    // ─── Font sizes ──────────────────────────────────────────────────
    readonly property int fontSize7xl: 72
    readonly property int fontSize6xl: 60
    readonly property int fontSize5xl: 48
    readonly property int fontSize4xl: 36
    readonly property int fontSize3xl: 30
    readonly property int fontSize2xl: 24
    readonly property int fontSizeXl: 20
    readonly property int fontSizeLg: 18
    readonly property int fontSizeBase: 16
    readonly property int fontSizeSm: 14
    readonly property int fontSizeXs: 12
    readonly property int fontSize2xs: 10
    readonly property int fontSize3xs: 8

    // ─── Gauge ───────────────────────────────────────────────────────
    readonly property int gaugeSize: 400
    readonly property int gaugeRadius: 180
    readonly property int gaugeTrackWidth: 12
    readonly property int gaugeActiveWidth: 16
    readonly property int gaugeTickCount: 9
    readonly property real gaugeTickInterval: 33.75            // degrees
    readonly property int gaugeMaxSpeed: 160

    // ─── Map ──────────────────────────────────────────────────────────
    readonly property real mapDefaultZoom: 17.5
    readonly property real mapTilt: 60.0
    readonly property real headingSmoothing: 0.05
    readonly property bool useRasterMapTiles: true
    readonly property bool useOfflineMapTiles: true
    readonly property int mapTileGridSize: 7
    readonly property int mapTileRepaintInterval: 400
    readonly property int routeRepaintInterval: 100
    readonly property int mapCanvasMargin: 120
    readonly property int mapMinorRoadSpacing: 96
    readonly property int mapMajorRoadSpacing: 288
    readonly property int mapMinorRoadWidth: 2
    readonly property int mapMajorRoadWidth: 5
    readonly property int mapDiagonalRoadWidth: 4
    readonly property real mapWaterwayStartXFactor: 0.08
    readonly property real mapWaterwayControl1XFactor: 0.24
    readonly property real mapWaterwayControl1YFactor: 0.64
    readonly property real mapWaterwayControl2XFactor: 0.42
    readonly property real mapWaterwayControl2YFactor: 0.52
    readonly property real mapWaterwayEndYFactor: 0.18
    readonly property real mapDiagonalRoadStartYFactor: 0.78
    readonly property real mapDiagonalRoadEndYFactor: 0.26
    readonly property color mapBackground: "#080b0f"
    readonly property color mapBlockFill: Qt.rgba(1, 1, 1, 0.015)
    readonly property color mapMinorRoad: Qt.rgba(148/255, 163/255, 184/255, 0.11)
    readonly property color mapMajorRoad: Qt.rgba(148/255, 163/255, 184/255, 0.24)
    readonly property color mapWaterway: Qt.rgba(6/255, 182/255, 212/255, 0.13)

    // ─── Car marker ──────────────────────────────────────────────────
    readonly property int carMarkerWidth: 40
    readonly property int carMarkerHeight: 80                  // stretched for 3D perspective
    readonly property int radarPulseWidth: 80
    readonly property int radarPulseHeight: 40
    readonly property int radarMiddleWidth: 50
    readonly property int radarMiddleHeight: 25
    readonly property int radarGlowWidth: 90
    readonly property int radarGlowHeight: 45

    // ─── Destination marker ─────────────────────────────────────────
    readonly property int destPinSize: 32
    readonly property int destInnerDotSize: 12
    readonly property int destStemWidth: 4
    readonly property int destStemHeight: 32

    // ─── Fuel thresholds ─────────────────────────────────────────────
    readonly property real fuelLowThreshold: 20.0

    // ─── Tire pressure ───────────────────────────────────────────────
    readonly property int tirePressureNominal: 42

    // ─── Font family ─────────────────────────────────────────────────
    readonly property string fontFamily: "Helvetica"
    readonly property string fontFamilyMono: "Courier New"
}
