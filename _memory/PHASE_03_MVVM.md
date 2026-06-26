# Phase 3: MVVM Infrastructure
>
> Target: Days 5-6 | Status: ✅ DONE | Progress: 6/6 (100%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 3.1 | BaseViewModel.h — trySetProperty<T>() template | ✅ DONE | `viewmodel/BaseViewModel.h` |
| 3.2 | TelemetryViewModel — 17 Q_PROPERTY, owns TelemetryEngine | ✅ DONE | `viewmodel/TelemetryViewModel.h/cpp` |
| 3.3 | ScreenViewModel — currentScreen, switchToScreen() | ✅ DONE | `viewmodel/ScreenViewModel.h/cpp` |
| 3.4 | MediaViewModel — isPlaying, playlist, prev/next track | ✅ DONE | `viewmodel/MediaViewModel.h/cpp` |
| 3.5 | Register in main.cpp — setContextProperty | ✅ DONE | `main.cpp` |
| 3.6 | view/main.qml skeleton — 4-layer structure | ✅ DONE | `view/main.qml` |

## Architecture Notes

- `BaseViewModel::trySetProperty()` uses `if constexpr` for float epsilon comparison (1e-9)
- ViewModel owns Model via `std::unique_ptr<Engine>` — no raw owning pointers
- Data flow: `TelemetryEngine::onTick()` → callback → `TelemetryViewModel::onTelemetryUpdated()` → `trySetProperty()` → NOTIFY signal → QML re-bind
- QML context properties: `telemetryVM`, `screenVM`, `mediaVM`
- main.qml guards all bindings with `typeof telemetryVM !== "undefined"` for standalone QML preview
- ScreenViewModel validates screen name before emitting
