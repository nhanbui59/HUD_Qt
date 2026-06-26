# Phase 9: Configuration, Theming & Hardening
>
> Target: Days 25-27 | Status: 🟡 IN PROGRESS | Progress: 5/9 (56%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 9.1 | Finalize AppConfig.h — every number traces to named constant | ✅ DONE | `config/AppConfig.h/cpp` |
| 9.2 | Create MapConfig.h — tile URL, zoom, pitch, road widths | ✅ DONE | `config/MapConfig.h/cpp` |
| 9.3 | Create ThemeConfig.h — all QColor definitions | ✅ DONE | `config/ThemeConfig.h/cpp` |
| 9.4 | Memoize route calculation results | ⬜ TODO | `RouteCalculator.cpp` — add cache layer |
| 9.5 | Smooth heading interpolation in engine | ✅ DONE | `RouteCalculator::smoothHeading()` — 0.05 factor |
| 9.6 | QML singleton Theme.qml — all colors/fonts/sizes | ✅ DONE | `view/config/Theme.qml` |
| 9.7 | Remove all hardcoded strings/numbers in QML | ⚠️ PARTIAL | Most done, need final audit |
| 9.8 | Verify smart-pointer-only policy | ⚠️ PARTIAL | ViewModels own via unique_ptr, need grep audit |
| 9.9 | Final integration test — full 60s route loop, all screens switchable | ⬜ TODO | — blocked: need Qt6 build |

## Architecture Notes

- Theme.qml is a pragma Singleton — imported as `import "config" as Theme` or via qmldir
- AppConfig: 29 route points, 8 speed constants, 10 simulation constants, 8 initial values, 9 street constants, 5 segment index constants
- ThemeConfig: 30+ QColor inline constexpr/const declarations
- MapConfig: tile URL, zoom 17.5, pitch 60, glow width 12, core width 6, 4 label coords

## Hardcoded Audit Checklist

| Category | Files to audit | Done? |
|----------|---------------|-------|
| Colors | All QML files | ⚠️ |
| Font sizes | All QML files | ⚠️ |
| Dimensions | All QML files | ⚠️ |
| Animation durations | All QML files | ⚠️ |
| C++ magic numbers | All .cpp files | ✅ via AppConfig |
| Raw pointers | All .h/.cpp | ⚠️ |
| Hardcoded strings | All files | ⚠️ |
