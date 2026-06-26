pragma Singleton
import QtQuick
import "../config"

QtObject {
    // ─── Font families ──────────────────────────────────────────
    readonly property string family: Theme.fontFamily
    readonly property string familyMono: Theme.fontFamilyMono

    // ─── Weights ────────────────────────────────────────────────
    readonly property int weightLight: Font.Light
    readonly property int weightNormal: Font.Normal
    readonly property int weightMedium: Font.Medium
    readonly property int weightBold: Font.Bold
    readonly property int weightBlack: Font.Black

    // ─── Sizes (px) ─────────────────────────────────────────────
    readonly property int t3xs: Theme.fontSize3xs    // 8
    readonly property int t2xs: Theme.fontSize2xs    // 10
    readonly property int tXs: Theme.fontSizeXs      // 12
    readonly property int tSm: Theme.fontSizeSm      // 14
    readonly property int tBase: Theme.fontSizeBase  // 16
    readonly property int tLg: Theme.fontSizeLg      // 18
    readonly property int tXl: Theme.fontSizeXl      // 20
    readonly property int t2xl: Theme.fontSize2xl    // 24
    readonly property int t3xl: Theme.fontSize3xl    // 30
    readonly property int t4xl: Theme.fontSize4xl    // 36
    readonly property int t5xl: Theme.fontSize5xl    // 48
    readonly property int t6xl: Theme.fontSize6xl    // 60
    readonly property int t7xl: Theme.fontSize7xl    // 72

    // ─── Letter spacing (tracking) emulation ────────────────────
    readonly property real trackingTighter: -0.05
    readonly property real trackingTight: -0.025
    readonly property real trackingNormal: 0.0
    readonly property real trackingWide: 0.05
    readonly property real trackingWider: 0.1
    readonly property real trackingWidest: 0.2

    // ─── Line heights ───────────────────────────────────────────
    readonly property real leadingTight: 1.1
    readonly property real leadingNormal: 1.5
}
