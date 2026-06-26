# QHUD — Porting from React Web to Qt6 MVVM (Native C++/QML)

> **Target:** Pixel-perfect port of the HUD car dashboard from React/Tailwind/Vite to Qt6 QML + C++.
> **Constraint:** No WebView. Pure native Qt6. Smart pointers only. No magic numbers. MVVM separation.

---

## 1. Architecture Overview (MVVM)

```
┌────────────────────────────────────────────────────────┐
│                     VIEW (QML)                         │
│  main.qml → ScreenStack (opacity-based switching)      │
│  ├── NavigationScreen.qml (Map + Header + Side + ...) │
│  ├── DashboardScreen.qml                                │
│  ├── MediaScreen.qml                                    │
│  ├── Dock.qml                                           │
│  └── components/ (reusable: SpeedGauge, TurnIcon, ...)  │
├────────────────────────────────────────────────────────┤
│                  VIEW MODEL (C++ / QObject)             │
│  TelemetryViewModel  — exposes all Q_PROPERTY for QML  │
│  MediaViewModel      — playlist, playback state         │
│  ScreenViewModel     — currentScreen, app config        │
│  All communicate via SIGNAL/SLOT, no QML → C++ logic   │
├────────────────────────────────────────────────────────┤
│                    MODEL (C++ Pure)                     │
│  TelemetryEngine     — simulation loop (QTimer)         │
│  RouteCalculator    — route math, turn detection        │
│  PlaylistModel      — song list data                    │
│  ConfigManager      — constants, theme, map styles      │
│  All owned by ViewModels via std::unique_ptr            │
└────────────────────────────────────────────────────────┘
```

**Data flow:** Model (pure C++) → ViewModel (QObject + `Q_PROPERTY`) → View (QML binding).
QML never accesses Model directly. ViewModel is the single contract surface.

---

## 2. Technology Mapping

| Web (React) | Qt6 Equivalent |
|---|---|
| `useState` / props | `Q_PROPERTY(... NOTIFY signal)` + QML binding |
| `useEffect` | `Component.onCompleted`, `QTimer`, or `Connections {}` |
| `requestAnimationFrame` 60fps loop | `QTimer` with 16ms interval (~60fps) or `QQuickWindow::beforeSynchronizing` |
| `motion` (Framer Motion) | `Behavior on`, `NumberAnimation`, `PropertyAnimation`, `SequentialAnimation` |
| Tailwind CSS v4 | QML `Rectangle` styling, `Gradient`, `DropShadow`, `Blur` effects |
| `lucide-react` icons | Custom `IconButton.qml` using Qt `ColorImage` with SVG or `Canvas` paths |
| MapLibre GL | Qt Location `Map` + `MapPolyline` + `MapQuickItem` (custom tile provider) |
| HTML custom markers | `MapQuickItem` with anchor points |
| CSS `clip-path` | QML `Shape` / `ShapePath` or inline `Canvas` |
| CSS `backdrop-blur` | `FastBlur` effect on `ShaderEffectSource` |
| CSS `pointer-events-none` | `enabled: false` or `interactive: false` |
| CSS radial gradient vignette | `RadialGradient {}` in `Rectangle` |

---

## 3. Project Structure

```
01.HUD_Qt6/
├── CMakeLists.txt                    # Root CMake (Qt6, C++17, QML module)
├── Plan.md
├── AGENTS.md
│
├── config/
│   ├── AppConfig.h / .cpp            # All constants, dimensions, colors, durations
│   ├── MapConfig.h / .cpp            # Tile URLs, zoom, pitch, road widths
│   └── ThemeConfig.h / .cpp          # Dark theme palette
│
├── model/
│   ├── TelemetryTypes.h             # Shared structs (TelemetryData, Location, etc.)
│   ├── TelemetryEngine.h / .cpp      # Pure C++ simulation engine (no Qt dep)
│   ├── RouteCalculator.h / .cpp      # Route math, heading, turn detection
│   └── PlaylistModel.h / .cpp        # Song list data
│
├── viewmodel/
│   ├── BaseViewModel.h              # Shared QObject utilities
│   ├── TelemetryViewModel.h / .cpp   # QObject, exposes telemetry to QML
│   ├── MediaViewModel.h / .cpp       # Playlist + playback state
│   └── ScreenViewModel.h / .cpp      # currentScreen, screen config
│
├── view/
│   ├── main.qml                      # Entry point, ScreenStack, Dock
│   ├── config/
│   │   └── Theme.qml                 # QML singleton with all colors/sizes
│   ├── screens/
│   │   ├── NavigationScreen.qml      # Map + HUD overlay container
│   │   ├── DashboardScreen.qml       # Gauges + car avatar + info panels
│   │   └── MediaScreen.qml           # Player UI + playlist
│   ├── overlays/
│   │   ├── HeaderPanel.qml           # Speed + speed limit + instruction
│   │   ├── BottomPanel.qml           # Turn info + progress + vehicle stats
│   │   ├── SidePanel.qml             # ECO/LaneAssist/Settings buttons
│   │   └── CenterPanel.qml           # Destination label
│   ├── components/
│   │   ├── Dock.qml                  # 3-button screen switcher
│   │   ├── SpeedGauge.qml            # Circular speed gauge
│   │   ├── TurnIcon.qml              # Turn maneuver icon mapper
│   │   ├── CarMarker.qml             # 3D arrow car marker (MapQuickItem)
│   │   ├── DestinationMarker.qml     # Blue pin marker
│   │   ├── ProgressBar.qml           # Styled progress bar
│   │   ├── GlassPanel.qml            # Backdrop-blur container
│   │   ├── IconButton.qml            # Reusable icon button
│   │   ├── TirePressureCard.qml      # FL/FR/RL/RR tire status
│   │   ├── EnergyPanel.qml           # Fuel gauge panel
│   │   └── MediaControls.qml         # Play/pause/skip/shuffle/repeat
│   └── style/
│       ├── Fonts.qml                 # Font family constants
│       └── Shadows.qml               # Drop shadow presets
│
├── resources/
│   ├── qml.qrc                       # QML resources
│   ├── icons/                        # SVG icon files (ported from lucide-react)
│   └── images/                       # Car silhouette, album art placeholder
│
├── main.cpp                          # App entry, register ViewModels to QML context
└── CMakePresets.json                 # Build presets (debug/release)
```

---

## 4. Data Model & C++ Types (model/TelemetryTypes.h)

```cpp
#pragma once
#include <QString>
#include <vector>

namespace QHUD {

struct Location {
    double lng = 0.0;
    double lat = 0.0;
};

enum class TurnManeuver {
    Left, Right, Straight, Arrive,
    Roundabout, UTurnLeft, SharpLeft, SharpRight,
    SlightRight, SlightLeft
};

struct RoutePoint {
    double lng;
    double lat;
};

struct TelemetryData {
    double speed = 0.0;
    double speedLimit = 0.0;
    double nextTurnDistance = 0.0;   // km
    QString nextTurnStreet;
    TurnManeuver nextTurnManeuver = TurnManeuver::Straight;
    QString currentStreet;
    double totalDistanceRemaining = 0.0;
    QString eta;
    double fuelLevel = 0.0;          // 0-100%
    double fuelRange = 0.0;          // km
    int odometer = 0;
    bool isEcoMode = false;
    bool isHeadlightsOn = false;
    bool isDoorOpenWarning = false;
    bool isLaneAssistOn = false;
    Location location;
    double heading = 0.0;           // degrees 0-360
    std::vector<RoutePoint> route;  // upcoming segments
};

} // namespace QHUD
```

**All coordinates, speeds, thresholds defined in `config/AppConfig.h`** — no magic numbers anywhere.

---

## 5. MVVM Layer Design

### 5.1 Models (Pure C++, no QObject)

**TelemetryEngine** — owns the simulation loop:
- `QTimer`-driven at 16ms (~60fps)
- Speed fluctuates ±1 km/h per second, clamped to [MIN_SPEED, MAX_SPEED]
- Calls `RouteCalculator` for position/heading/turn data
- Emits `std::function<void(const TelemetryData&)>` callback to push data up

**RouteCalculator** — stateless math:
- `getPointAtLength(progress, route) → {Location, index}`
- `calculateHeading(p1, p2) → double`
- `detectNextTurn(route, startIdx) → {maneuver, distance}`
- `smoothHeading(raw, prev, factor) → double`

**PlaylistModel** — song list data container

### 5.2 ViewModels (QObject, expose Q_PROPERTY)

**TelemetryViewModel** — bridges Model→View:
```cpp
class TelemetryViewModel : public QObject {
    Q_OBJECT
    Q_PROPERTY(double speed READ speed NOTIFY speedChanged)
    Q_PROPERTY(double speedLimit READ speedLimit NOTIFY speedLimitChanged)
    Q_PROPERTY(double nextTurnDistance READ nextTurnDistance NOTIFY nextTurnDistanceChanged)
    Q_PROPERTY(QString nextTurnStreet READ nextTurnStreet NOTIFY nextTurnStreetChanged)
    Q_PROPERTY(int nextTurnManeuver READ nextTurnManeuver NOTIFY nextTurnManeuverChanged)
    Q_PROPERTY(QString currentStreet READ currentStreet NOTIFY currentStreetChanged)
    Q_PROPERTY(double totalDistanceRemaining READ totalDistanceRemaining NOTIFY totalDistanceRemainingChanged)
    Q_PROPERTY(QString eta READ eta NOTIFY etaChanged)
    Q_PROPERTY(double fuelLevel READ fuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(double fuelRange READ fuelRange NOTIFY fuelRangeChanged)
    Q_PROPERTY(int odometer READ odometer NOTIFY odometerChanged)
    Q_PROPERTY(bool isEcoMode READ isEcoMode NOTIFY isEcoModeChanged)
    Q_PROPERTY(bool isHeadlightsOn READ isHeadlightsOn NOTIFY isHeadlightsOnChanged)
    Q_PROPERTY(bool isDoorOpenWarning READ isDoorOpenWarning NOTIFY isDoorOpenWarningChanged)
    Q_PROPERTY(bool isLaneAssistOn READ isLaneAssistOn NOTIFY isLaneAssistOnChanged)
    Q_PROPERTY(double currentLng READ currentLng NOTIFY currentLngChanged)
    Q_PROPERTY(double currentLat READ currentLat NOTIFY currentLatChanged)
    Q_PROPERTY(double heading READ heading NOTIFY headingChanged)
    Q_PROPERTY(QVariantList routePath READ routePath NOTIFY routePathChanged)
    // ...
public:
    explicit TelemetryViewModel(QObject *parent = nullptr);
    void start();
    void stop();
private:
    std::unique_ptr<TelemetryEngine> m_engine;
    void onTelemetryUpdated(const TelemetryData &data);
};
```

**ScreenViewModel** — screen management:
```cpp
Q_PROPERTY(QString currentScreen READ currentScreen NOTIFY currentScreenChanged)
// Values: "navigation", "dashboard", "media"
Q_INVOKABLE void switchToScreen(const QString &screen);
```

All 3 screens rendered concurrently, toggled via QML `opacity` + `enabled`.

### 5.3 Views (QML)

Each screen container uses:
```qml
opacity: currentScreen === "navigation" ? 1 : 0
enabled: currentScreen === "navigation"
Behavior on opacity { NumberAnimation { duration: 500 } }
```
to replicate the 500ms CSS transition.

---

## 6. Phase-by-Phase Plan

### Phase 1: Project Scaffolding & Build System
**Target: Days 1–2**

| # | Task | Details |
|---|---|---|
| 1.1 | Create CMake project skeleton | Qt6 (`6.5+`), C++17, `find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Positioning Location)` |
| 1.2 | Create `main.cpp` with `QQmlApplicationEngine` | Register ViewModels to root context, load `main.qml` |
| 1.3 | Create `resources/qml.qrc` | Enumerate all QML files, icons, images |
| 1.4 | Create `config/AppConfig.h`, `ThemeConfig.h` | Extract ALL dimensions, colors, durations from web source into named constants |
| 1.5 | Create `view/config/Theme.qml` singleton | Expose color palette matching Tailwind dark theme |
| 1.6 | Create `view/style/Fonts.qml`, `Shadows.qml` | Match web font sizes, weights, tracking |
| 1.7 | Verify build compiles + runs empty window | `cmake -B build && cmake --build build` |

### Phase 2: Core Data Layer (Model)
**Target: Days 3–4**

| # | Task | Details |
|---|---|---|
| 2.1 | Implement `model/TelemetryTypes.h` | All structs, enums. Zero Qt dependencies. |
| 2.2 | Implement `model/RouteCalculator` | Line interpolation, heading calc, turn detection, exponential smoothing |
| 2.3 | Implement `model/TelemetryEngine` | 60fps QTimer loop, speed fluctuation, route progress, ETA calc |
| 2.4 | Implement `model/PlaylistModel` | Song list data container |
| 2.5 | Unit-test RouteCalculator math | Standalone C++ tests (no Qt needed for pure math) |

### Phase 3: MVVM Infrastructure
**Target: Days 5–6**

| # | Task | Details |
|---|---|---|
| 3.1 | Implement `viewmodel/BaseViewModel.h` | Shared base for property registration helpers |
| 3.2 | Implement `viewmodel/TelemetryViewModel` | All `Q_PROPERTY` + `NOTIFY`, owns `TelemetryEngine`, connects to update slot |
| 3.3 | Implement `viewmodel/ScreenViewModel` | `currentScreen` property, `switchToScreen(slot)` |
| 3.4 | Implement `viewmodel/MediaViewModel` | Playlist, current track, play/pause state |
| 3.5 | Register all ViewModels in `main.cpp` | `engine.rootContext()->setContextProperty("telemetryVM", &telemetryVM)` |
| 3.6 | Create `view/main.qml` skeleton | 4-layer structure: Nav+Dash+Media screens + Dock overlay |

### Phase 4: Navigation Screen — Map & Overlays
**Target: Days 7–12 (largest phase)**

| # | Task | Details |
|---|---|---|
| 4.1 | Configure Qt Location Map with dark tile provider | Custom plugin params for Carto Dark Matter equivalent tile URL |
| 4.2 | Set up `Map` in `NavigationScreen.qml` | `zoomLevel: 17.5`, `tilt: 60`, `bearing` bound to heading, `interactive: false` |
| 4.3 | Implement route polyline (`MapPolyline`) | Neon green glow layer (wider, blurred, 30% opacity) + core line |
| 4.4 | Implement `CarMarker.qml` as `MapQuickItem` | 3D arrow polygon + radar pulse rings + thrust glow, all animated |
| 4.5 | Implement `DestinationMarker.qml` as `MapQuickItem` | Blue circle + stem + shadow |
| 4.6 | Implement custom street labels (`MapQuickItem` + Text) | Bitexco Tower, Nguyen Hue, Ham Nghi, Ho Tung Mau |
| 4.7 | Wire camera follow: map `center` + `bearing` bound to ViewModel | Smooth jump via `Behavior on center` |
| 4.8 | Implement `HeaderPanel.qml` overlay | Speed text + KM/H label + red speed limit badge + instruction text + headlight/door icons |
| 4.9 | Implement `SidePanel.qml` overlay | ECO/LaneAssist/Settings circular buttons |
| 4.10 | Implement `BottomPanel.qml` overlay | Turn icon + street name + distance + progress bar + odometer + fuel% + range |
| 4.11 | Implement `CenterPanel.qml` overlay | Destination label in bottom-left |
| 4.12 | Implement vignette radial gradient overlay | `RadialGradient` fill rectangle with `interactive: false` |
| 4.13 | Implement turn icon logic in `TurnIcon.qml` | Map maneuver enum → SVG icon |
| 4.14 | Port SVG icons from lucide-react to Qt resources | ArrowUp, CornerUpRight, CornerUpLeft, MapPin, Fuel, RefreshCw, etc. |

### Phase 5: Dashboard Screen
**Target: Days 13–16**

| # | Task | Details |
|---|---|---|
| 5.1 | Implement `SpeedGauge.qml` (circular SVG gauge) | Background track arc, active gradient arc, tick marks |
| 5.2 | Bind gauge to speed property | `strokeDashoffset` updated via binding + transition |
| 5.3 | Implement center content (speed number, gear indicator, speed limit badge) | D4/P/R/N row, glowing speed limit circle |
| 5.4 | Implement `CarSVG` (top-down car avatar) | QML `Shape` / `ShapePath` matching the SVG body, windshield, mirrors, headlights/taillights |
| 5.5 | Implement 3D perspective road + radar waves | `PerspectiveTransform` or manual skew on road lanes + animated radar rings |
| 5.6 | Implement headlight beams projection | Radial gradient glow with conditional visibility |
| 5.7 | Implement door-open warning badge | Red alert badge on car side with AlertCircle icon |
| 5.8 | Implement ADAS status badge | "Auto Pilot Ready" pill with ACC icon |
| 5.9 | Implement `EnergyPanel.qml` | Fuel % bar + km range display |
| 5.10 | Implement `TirePressureCard.qml` | 4-wheel grid (FL/FR/RL/RR) with PSI and low-pressure red highlight |
| 5.11 | Implement Temp + Odometer info cards | Two bottom info cards in grid |
| 5.12 | Add background accent (blue radial blur ellipse) | `RadialGradient` with blur behind content |

### Phase 6: Media Screen
**Target: Days 17–19**

| # | Task | Details |
|---|---|---|
| 6.1 | Create `MediaScreen.qml` layout | Two-column: left = player info, right = playlist |
| 6.2 | Implement album art with `Image` | Rounded corners, border, hover zoom transform |
| 6.3 | Implement song metadata | Title + artist + heart button |
| 6.4 | Implement `ProgressBar.qml` component | Gradient fill (purple→blue), timestamps |
| 6.5 | Implement `MediaControls.qml` | Shuffle, SkipBack, Play/Pause (animated toggle), SkipForward, Repeat |
| 6.6 | Implement playlist list | Scrollable list items with track number, title, artist, duration |
| 6.7 | Add dynamic background blurs | Purple + blue radial accent blurs |
| 6.8 | Wire Play/Pause state to `MediaViewModel` | Toggle `isPlaying` property |

### Phase 7: Screen Switching & Dock
**Target: Days 20–21**

| # | Task | Details |
|---|---|---|
| 7.1 | Implement `Dock.qml` | 3 buttons: Nav (Map icon), Dash (Gauge icon), Media (Music icon) |
| 7.2 | Implement screen switching via `ScreenViewModel.switchToScreen()` | 500ms opacity transition on all 3 screen containers |
| 7.3 | Implement Dock active state | Blue background + glow shadow + scale(1.1) on active button |
| 7.4 | Implement Dock responsive layout | Bottom row on mobile, left sidebar on desktop (MD breakpoint) |
| 7.5 | Ensure `pointer-events`/`interactive` correct per screen | Only active screen is `enabled: true` |

### Phase 8: Animations & Visual Polish
**Target: Days 22–24**

| # | Task | Details |
|---|---|---|
| 8.1 | Implement car marker animations | Radar pulse ping (opacity + scale), thrust glow pulse |
| 8.2 | Implement gauge transition | Smooth `Behavior on strokeDashoffset` with 300ms duration |
| 8.3 | Implement screen transition | `NumberAnimation { duration: 500; easing.type: Easing.InOutQuad }` on opacity |
| 8.4 | Implement hover/active states on all buttons | Scale, color transition on Dock, SidePanel, Media controls |
| 8.5 | Implement progress bar animated fill | `Behavior on width` for fuel bar, trip progress bar |
| 8.6 | Implement glass-morphism backdrop blur | `ShaderEffectSource` + `FastBlur` on all panels |
| 8.7 | Implement speed limit pulse when speeding | Conditional `ColorAnimation` loop on border when speed > speedLimit |
| 8.8 | Implement album art hover zoom | `Behavior on scale` on mouse hover |
| 8.9 | Verify all animations run at 60fps | No dropped frames on target hardware |

### Phase 9: Configuration, Theming & Hardening
**Target: Days 25–27**

| # | Task | Details |
|---|---|---|
| 9.1 | Finalize `AppConfig.h` | Every number in the codebase must trace back to a named constant |
| 9.2 | Create `MapConfig.h` | Tile URL, zoom level, pitch, bearing, road line widths, colors |
| 9.3 | Create `ThemeConfig.h` | All `QColor` definitions for the dark theme palette |
| 9.4 | Memoize route calculation results | Avoid recalculating identical inputs |
| 9.5 | Add smooth heading interpolation in engine | Match the 0.05 exponential smoothing factor from web |
| 9.6 | Implement QML singleton `Theme.qml` | Bind all colors, fonts, sizes from C++ config to QML properties |
| 9.7 | Remove all hardcoded strings/numbers in QML | Replace with `Theme.xxx` references |
| 9.8 | Verify smart-pointer-only policy | grep for `new`, `delete`, raw pointers — confirm all use `std::unique_ptr`/`std::shared_ptr` |
| 9.9 | Final integration test: full 60s route loop | Verify all screens switchable, all data flows |

---

## 7. Key Design Decisions

### Map Rendering Strategy
Qt Location's `Map` is used instead of embedding MapLibre GL via WebView or custom OpenGL layer.
- **Tile source**: Carto Dark Matter tiles accessed via Qt Location `PluginParameter` for tile URL
- If Qt Location lacks the exact Carto Dark Matter tile format, use `osm` or `mapboxgl` plugin with a custom style JSON
- **Fallback**: Implement a custom `QQuickItem` that uses an offline tile renderer (only if Qt Location is insufficient)

### Gauge Rendering Approach
The speed gauge uses QML `Canvas` to draw the circular gauge:
- `Canvas.onPaint` draws the background arc, active gradient arc, and tick marks
- The active arc's endpoint is bound to `speed / maxSpeed` ratio
- `Canvas.requestPaint()` is called on speed change
- Alternative: `Shape` + `ShapePath` with `PathArc` — simpler but less performant for frequent updates

### Car Avatar
The top-down car SVG is ported as QML `Shape { ShapePath { ... } }` elements (not `Image` from raster). This preserves:
- Vector crispness at all scales
- Conditional coloring (headlights on/off, door warning)
- Composited glow effects

### Animation Framework
QML's built-in animation system (`NumberAnimation`, `ColorAnimation`, `SequentialAnimation`) fully replaces Framer Motion:
- `Behavior on property { ... }` for implicit animations (like CSS transitions)
- Explicit `Animation` objects bound to `running` for looping (pulse, radar)
- `Transition` objects for state changes

### Screen Switching
Keeping the same approach as the web: all 3 screens always rendered, toggled via `opacity` + `enabled`. This avoids destroy/create overhead and preserves scroll/state per screen.

---

## 8. Risk Assessment

| Risk | Severity | Mitigation |
|---|---|---|
| Qt Location map tile rendering differs from MapLibre GL | High | Test early (Phase 4.1-4.2). Prepare `osm` fallback or offline tile renderer |
| 3D car arrow marker (CSS clip-path + 3D transforms) hard to replicate in QML | Medium | Use `Canvas` to draw polygon paths; accept 2D variant if needed |
| SVG path icons from lucide-react need manual porting | Medium | Batch port all icons in Phase 4.14 using a conversion script |
| Radial gradient vignette effect via `RadialGradient` | Low | Qt 6.5+ supports `RadialGradient` natively in QML |
| Performance of `Canvas` gauge repaint at 60fps | Low | `Canvas` with `renderStrategy: Canvas.Cooperative` handles this |
| `ShaderEffectSource` + `FastBlur` for glass panels may be heavy | Medium | Use `layer.enabled: true` with `layer.effect` for GPU-accelerated blur |
| Route polyline with glow effect not natively supported in Qt MapPolyline | Medium | Use two stacked `MapPolyline` lines (wider blurred + thin core), or `MapItemView` with custom delegate |

---

## 9. Quick-Start Commands (for the Qt6 repo)

```bash
# Prerequisites: Qt 6.5+ with QtLocation, CMake 3.21+
cmake -B build -DCMAKE_PREFIX_PATH=/path/to/Qt/6.x.x/gcc_64
cmake --build build --parallel
./build/QHUD
```

---

## 10. File Count Summary

| Layer | Files | Purpose |
|---|---|---|
| Config | 3 `.h/.cpp` pairs | Constants, theme, map config |
| Model | 4 `.h/.cpp` pairs | Data types, engine, route math, playlist |
| ViewModel | 4 `.h/.cpp` pairs | Telemetry, Media, Screen, Base |
| View (QML) | ~25 `.qml` files | Screens, overlays, components, style |
| Resources | `qml.qrc` + icons + images | Bundled assets |
| Root | `CMakeLists.txt`, `main.cpp` | Build system + entry point |

**Total: ~40 source files, ~5,000–8,000 lines of code**
