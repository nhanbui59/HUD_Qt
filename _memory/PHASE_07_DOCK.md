# Phase 7: Screen Switching & Dock
>
> Target: Days 20-21 | Status: ✅ DONE | Progress: 5/5 (100%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 7.1 | Dock.qml — 3 buttons: Nav/Map, Dash/Gauge, Media/Music | ✅ DONE | `view/components/Dock.qml` |
| 7.2 | Screen switching via ScreenViewModel.switchToScreen() — 500ms opacity transition | ✅ DONE | `view/main.qml` |
| 7.3 | Dock active state — blue bg + glow shadow + scale(1.1) | ✅ DONE | `Dock.qml` via IconButton |
| 7.4 | Dock responsive layout — bottom row mobile, left sidebar desktop | ✅ DONE | `Dock.qml` |
| 7.5 | pointer-events/interactive correct per screen — only active screen enabled | ✅ DONE | `main.qml` via `enabled: isActive` |

## Architecture Notes

- Screen switching matches App.tsx exactly: all 3 screens rendered, opacity toggled
- Transition: `Behavior on opacity { NumberAnimation { duration: 500; easing.type: Easing.InOutQuad } }`
- Dock uses IconButton.qml for each button
- Active button: Theme.blue600 bg, DropShadow glow, scale 1.1
- Inactive: white/5 bg, gray400 icon
- Dock z-index: 100 (always above all screens)
- Desktop: left sidebar (anchors.left: 24, anchors.verticalCenter)
- Mobile: bottom row (anchors.bottom: 24, anchors.horizontalCenter)
