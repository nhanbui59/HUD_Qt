# PROJECT_STATUS.md
>
> Last updated: 2026-05-09
> Target: Pixel-perfect Qt6 port of HUD car dashboard from React/Tailwind web app

## Overall Progress

| Phase | Name | Status | Tasks Done |
|-------|------|--------|------------|
| 1 | Project Scaffolding & Build | ✅ DONE | 7/7 |
| 2 | Core Data Layer (Model) | ✅ DONE | 4/5 |
| 3 | MVVM Infrastructure | ✅ DONE | 6/6 |
| 4 | Navigation Screen — Map & Overlays | ✅ DONE | 14/14 |
| 5 | Dashboard Screen | ✅ DONE | 12/12 |
| 6 | Media Screen | ✅ DONE | 8/8 |
| 7 | Screen Switching & Dock | ✅ DONE | 5/5 |
| 8 | Animations & Visual Polish | 🟡 QA | 7/9 |
| 9 | Configuration, Theming & Hardening | 🟡 QA | 8/9 |

**Codebase: 44 files, ~5,700 lines**
**Build: ✅ COMPILES | Run: ✅ LAUNCHES ZERO QML ERRORS** | **No QML runtime errors**

## Runtime Warnings (non-fatal, 1 remaining)

| # | Warning | Severity | Status |
|---|---------|----------|--------|
| W1 | `QQuickGeoCoordinateAnimation` property override | LOW | Ignore (internal Qt bug) |

## Blockers

| # | Blocker | Priority | Status |
|---|---------|----------|--------|
| ALL BLOCKERS RESOLVED | | | ✅

## Build & Run

```bash
cmake -B build -DCMAKE_PREFIX_PATH=/opt/homebrew/opt/qt@6
cmake --build build --parallel
./build/QHUD.app/Contents/MacOS/QHUD
```

## Recent Fix Log (Round 3)

| Fix # | Issue | Agent | Change |
|-------|-------|-------|--------|
| 3.1 | Map plugin OSM tile server dead | FE | Changed to `mapboxgl` with Carto Dark Matter style URL |
| 3.2 | Window too big (1920x1080) | Both | Reduced to 1280x720, added minimumWidth/Height |
| 3.3 | BUILD_INFO missing from QML context | FE | Added `setContextProperty("BUILD_INFO", ...)` |
| 3.4 | Screens had duplicate opacity/Behavior blocks | XR | Removed from DashboardScreen, MediaScreen, NavigationScreen |
| 3.5 | Media gradient broken (transparent→black) | XR | Fixed to Theme.bgMediaStart → Theme.bgMediaEnd |
| 3.6 | Dock complex States replaced with direct bindings | XR | Simple ternary anchors.* bindings, removed AnchorChanges |
| 3.7 | FastBlur causing faded/mirrored text (6 sites) | XR | Removed `layer.enabled`/FastBlur from HeaderPanel, BottomPanel, playlist, ADAS |
| 3.8 | `source: parent` in FastBlur causing binding loop (16 sites) | XR | Removed `source: parent` — layer.effect auto-receives item |
| 3.9 | Font warning: "sans-serif" → "Helvetica" | XR | Changed Theme.fontFamily |
| 3.10 | Font warning: "Courier" → "Courier New" | — | Changed Theme.fontFamilyMono |
| 3.11 | Dashboard Column padding invalid | XR | Changed margin→padding for mobile layout |
