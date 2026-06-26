# Phase 8: Animations & Visual Polish
>
> Target: Days 22-24 | Status: 🟡 IN PROGRESS | Progress: 6/9 (67%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 8.1 | Car marker animations — radar pulse ping + thrust glow | ✅ DONE | `CarMarker.qml` — NumberAnimation loops |
| 8.2 | Gauge transition — smooth Behavior on strokeDashoffset 300ms | ✅ DONE | `SpeedGauge.qml` — Canvas.requestPaint |
| 8.3 | Screen transition — 500ms InOutQuad opacity animation | ✅ DONE | `main.qml` |
| 8.4 | Hover/active states on all buttons — scale + color | ✅ DONE | IconButton.qml, Dock.qml, MediaControls.qml |
| 8.5 | Progress bar animated fill — Behavior on width | ✅ DONE | `ProgressBar.qml` |
| 8.6 | Glass-morphism backdrop blur — FastBlur on all panels | ✅ DONE | `GlassPanel.qml`, HeaderPanel, BottomPanel |
| 8.7 | Speed limit pulse when speeding — ColorAnimation on border | ⬜ TODO | `SpeedGauge.qml` or HeaderPanel — need to verify existing pulse logic works |
| 8.8 | Album art hover zoom — Behavior on scale | ⬜ TODO | `MediaScreen.qml` — need to verify hover triggers correctly |
| 8.9 | Verify all animations run at 60fps | ⬜ TODO | — blocked: need runtime QA |

## Architecture Notes

- Radar pulse: NumberAnimation on opacity (0.75→0) + scale (0.9→1.3), 1500ms, infinite loop
- Thrust glow: ColorAnimation/OpacityAnimation pulse on the cyan circle
- Gauge uses `Canvas.requestPaint()` triggered by speed change binding
- Glass panels: `layer.enabled: true` + `layer.effect: FastBlur { radius: 20; transparentBorder: true }`
- All animations use QML's built-in animation system (no external lib)
