# Phase 5: Dashboard Screen
>
> Target: Days 13-16 | Status: ✅ DONE | Progress: 11/12 (92%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 5.1 | SpeedGauge.qml — Canvas circular gauge with background track, active arc, ticks | ✅ DONE | `view/components/SpeedGauge.qml` |
| 5.2 | Bind gauge to speed — strokeDashoffset updated via binding | ✅ DONE | `SpeedGauge.qml` — Canvas.requestPaint on speed change |
| 5.3 | Center content — speed number text-7xl, gear row D4/P/R/N, speed limit badge | ✅ DONE | `SpeedGauge.qml` |
| 5.4 | CarAvatar.qml — Shape/ShapePath top-down car | ✅ DONE | `view/components/CarAvatar.qml` |
| 5.5 | 3D perspective road + radar waves | ✅ DONE | `DashboardScreen.qml` — dashed lanes + animated rings |
| 5.6 | Headlight beams projection — conditional radial glow | ✅ DONE | `DashboardScreen.qml` |
| 5.7 | Door-open warning badge — red "Door Ajar" alert | ✅ DONE | `CarAvatar.qml` |
| 5.8 | ADAS status badge — "Auto Pilot Ready" pill | ✅ DONE | `DashboardScreen.qml` |
| 5.9 | EnergyPanel.qml — fuel % bar + km range | ✅ DONE | `view/components/EnergyPanel.qml` |
| 5.10 | TirePressureCard.qml — 4-wheel grid FL/FR/RL/RR | ✅ DONE | `view/components/TirePressureCard.qml` |
| 5.11 | Temp + Odometer info cards | ✅ DONE | `DashboardScreen.qml` |
| 5.12 | Background accent — blue radial blur ellipse | ✅ DONE | `DashboardScreen.qml` |

## Architecture Notes

- DashboardScreen.tsx 3-column layout ported as Row on desktop, Flickable Column on mobile (<768px)
- SpeedGauge uses Canvas — `renderStrategy: Canvas.Cooperative` for smooth 60fps
- Speed limit badge pulses (ColorAnimation border) when speed > speedLimit
- CarAvatar uses Shape+ShapePath (vector), not raster Image
- RR tire at 38 PSI shows low-pressure warning (red bg/border/text)
- Gradient bg: #050508 → #12151c with blue radial accent blur (FastBlur radius: 120)

## Known Issues

| # | Issue | Severity |
|---|-------|----------|
| I5.1 | 3D perspective road used `rotation.x: 65` + translation — may not match CSS transform perspective: 1000px exactly | MEDIUM |
| I5.2 | SpeedGauge tick marks at 33.75° intervals — verify exact web positioning | LOW |
