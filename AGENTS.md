# AGENTS.md

## Setup & Build

**Prerequisites:** Qt 6.5+, CMake 3.21+, C++17 compiler.

```bash
cmake -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x/macos
cmake --build build --parallel
./build/QHUD
```

- `CMAKE_AUTOMOC` and `CMAKE_AUTORCC` are ON — Q_OBJECT macros and .qrc are processed automatically.
- `CMAKE_PREFIX_PATH` must point to the Qt6 install (Homebrew: `$(brew --prefix qt@6)`).

No test runner, no CI, no pre-commit hooks.

## Architecture

### MVVM Layers

```
QML (View)  ──bindings──▶  ViewModel (QObject + Q_PROPERTY)  ──owns──▶  Model (pure C++)
```

- **Model** (`model/`) — pure C++, **no Qt dependency** (except `QString` in structs).
- **ViewModel** (`viewmodel/`) — QObject with `Q_PROPERTY(... NOTIFY signal)`, owns model via `std::unique_ptr`.
- **View** (`view/`) — QML, binds to ViewModel context properties.

### Data Flow

```
TelemetryEngine::tick() → std::function callback → TelemetryViewModel::onTelemetryUpdated()
  → trySetProperty() (emits NOTIFY only on change) → QML bindings re-evaluate
```

### 3 Screens — Opacity Switching

All 3 screens render **simultaneously** (no `Loader`, no `StackView`). Switching is via `opacity` + `enabled`:

```qml
opacity: isActive ? 1 : 0
enabled: isActive
Behavior on opacity { NumberAnimation { duration: 500; easing: InOutQuad } }
```

### Context Properties

3 ViewModels registered in `main.cpp` — QML accesses them directly:

| Context property | Type |
|---|---|
| `telemetryVM` | `TelemetryViewModel` |
| `screenVM` | `ScreenViewModel` |
| `mediaVM` | `MediaViewModel` |

QML guards with `typeof telemetryVM !== "undefined"` for preview without C++ backend.

## Directory Layout

```
config/         # AppConfig, ThemeConfig, MapConfig — ALL constants live here
model/          # TelemetryEngine, RouteCalculator, PlaylistModel — pure C++
viewmodel/      # TelemetryViewModel, ScreenViewModel, MediaViewModel — QObject bridges
view/
  main.qml      # Root Window, screen stack, Dock
  config/       # Theme.qml singleton — ALL colors/dimensions
  screens/      # NavigationScreen, DashboardScreen, MediaScreen
  overlays/     # HeaderPanel, BottomPanel, SidePanel, CenterPanel
  components/   # CarMarker, SpeedGauge, TurnIcon, Dock, etc.
  style/        # Fonts.qml, Shadows.qml
resources/      # qml.qrc, icons, images
```

## Key Conventions

### No Magic Numbers
Every number, color, and string constant lives in either:
- `config/AppConfig.h` — C++ constants (speeds, durations, route, thresholds)
- `view/config/Theme.qml` — QML design tokens (colors, dimensions, radii)

**Do not** hardcode values in QML or C++ logic files.

### Smart Pointers Only
- ViewModels own Models via `std::unique_ptr<EngineType>`.
- No `new`/`delete`, no raw owning pointers.
- ViewModels on the stack in `main.cpp`, destroyed at exit.

### Property Change Semantics
Use `BaseViewModel::trySetProperty()` (not direct assignment) to update `Q_PROPERTY` backing fields — it emits `NOTIFY` only when the value actually changes, preventing spurious QML re-binds.

### Namespace
All C++ code is in `namespace QHUD`. Forward-declare when possible, include full paths from project root (e.g. `#include "model/TelemetryTypes.h"`).

### Model Layer Purity
`model/` classes are pure C++. They do **not** inherit `QObject`, do not emit Qt signals, and should be testable without Qt. `TelemetryEngine` uses `std::function` callback, not `Q_OBJECT` signals.

### QML Imports
QML files that use effects need:
```qml
import QtQuick
import QtQuick.Controls
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects   # for FastBlur, DropShadow
```

### Glass Panels (Backdrop Blur)
Use `GlassPanel.qml` component or apply directly:
```qml
Rectangle {
    layer.enabled: true
    layer.effect: FastBlur { radius: 20; transparentBorder: true }
}
```

### Map Markers
Custom markers on Qt Location `Map` use `MapQuickItem` with `sourceItem` pointing to a QML component (CarMarker, DestinationMarker, labels).

## Porting Notes

- This project is a **pixel-perfect port** from a React/Tailwind web app at `../01.HUD_Web/`.
- The route is a 29-point loop in Ho Chi Minh City (Lê Thánh Tôn → Nguyễn Huệ → Tôn Đức Thắng → Hải Triều → Bitexco Tower).
- Route constants are in `config/AppConfig.cpp`.
- The original TypeScript `useTelemetry()` hook logic is split: `TelemetryEngine` (timer + state) + `RouteCalculator` (stateless math).
