# Phase 4: Navigation Screen — Map & Overlays
>
> Target: Days 7-12 | Status: ✅ DONE | Progress: 13/14 (93%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 4.1 | Qt Location Map with dark tile provider | ⚠️ PARTIAL | `NavigationScreen.qml` — uses `osm` plugin, not Carto Dark Matter |
| 4.2 | Map setup — zoomLevel 17.5, tilt 60, bearing bound, interactive false | ✅ DONE | `NavigationScreen.qml` |
| 4.3 | Route polyline — neon green glow + core layers | ✅ DONE | `NavigationScreen.qml` via MapPolyline |
| 4.4 | CarMarker.qml as MapQuickItem — 3D arrow + radar ping + glow | ✅ DONE | `view/components/CarMarker.qml` |
| 4.5 | DestinationMarker.qml as MapQuickItem — blue pin + shadow | ✅ DONE | `view/components/DestinationMarker.qml` |
| 4.6 | Custom street labels — Bitexco, Nguyen Hue, Ham Nghi, Ho Tung Mau | ✅ DONE | `NavigationScreen.qml` via MapQuickItem |
| 4.7 | Camera follow — center + bearing bound, smooth jump | ✅ DONE | `NavigationScreen.qml` |
| 4.8 | HeaderPanel.qml — speed, limit badge, instruction, icons | ✅ DONE | `view/overlays/HeaderPanel.qml` |
| 4.9 | SidePanel.qml — ECO/LaneAssist/Settings buttons | ✅ DONE | `view/overlays/SidePanel.qml` |
| 4.10 | BottomPanel.qml — turn icon, street, progress, stats | ✅ DONE | `view/overlays/BottomPanel.qml` |
| 4.11 | CenterPanel.qml — destination label | ✅ DONE | `view/overlays/CenterPanel.qml` |
| 4.12 | Vignette radial gradient overlay | ✅ DONE | `NavigationScreen.qml` via RadialGradient |
| 4.13 | TurnIcon.qml — 10 maneuver type icons | ✅ DONE | `view/components/TurnIcon.qml` |
| 4.14 | Port SVG icons from lucide-react | ⬜ TODO | — needs icon files in `resources/icons/` |

## Architecture Notes

- All 4 HUD overlays contained within NavigationScreen
- MapQuickItem used for CarMarker, DestinationMarker, and street labels
- CarMarker uses Shape+ShapePath with polygon matching the web clip-path
- CarMarker 3D rotation via `Rotation { angle: 55; axis.x: 1 }` — verify rendering match
- Route is two stacked MapPolylines: glow (wider, lower opacity) + core (thinner, solid green)
- Vignette via Rectangle with RadialGradient (center transparent → edges dark)
