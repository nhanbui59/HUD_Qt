# Architecture & Design Decisions
>
> For future agents working on this codebase.

## MVVM Data Flow (DO NOT BREAK)

```
Model (pure C++)           ViewModel (QObject)         View (QML)
──────────────             ──────────────────          ─────────
TelemetryEngine                TelemetryViewModel         main.qml
  │ tick()                       │ Q_PROPERTY              │ binding
  │ callback ──────────────────► │ onTelemetryUpdated()    │ reads
  │                              │ trySetProperty() ─────► │ re-evaluates
  │                              │ emit NOTIFY
  │
RouteCalculator (stateless)
PlaylistModel (data)
```

Rules:
1. Model classes NEVER inherit QObject. They use `std::function` callbacks.
2. ViewModel is the ONLY bridge. QML never accesses Model directly.
3. `trySetProperty()` must be used for all Q_PROPERTY writes — it only emits if changed.
4. ALL constants go through AppConfig:: or Theme. — no inlines in logic code.

## Screen Architecture

3 screens, always rendered, opacity-switched:

```
Window
├── NavigationScreen (opacity: currentScreen=="navigation" ? 1 : 0)
│   ├── Map (Qt Location)
│   │   ├── Route polyline (glow + core MapPolyline)
│   │   ├── CarMarker (MapQuickItem)
│   │   ├── DestinationMarker (MapQuickItem)
│   │   └── Street labels (MapQuickItem × 4)
│   ├── HeaderPanel.qml (z: 20)
│   ├── SidePanel.qml (z: 30)
│   ├── BottomPanel.qml (z: 20)
│   └── CenterPanel.qml (z: 10)
├── DashboardScreen (opacity: currentScreen=="dashboard" ? 1 : 0)
│   ├── SpeedGauge (Canvas)
│   ├── CarAvatar (Shape)
│   ├── EnergyPanel
│   ├── TirePressureCard
│   └── Info cards
├── MediaScreen (opacity: currentScreen=="media" ? 1 : 0)
│   ├── Album art + metadata
│   ├── ProgressBar
│   ├── MediaControls
│   └── Playlist list
└── Dock (z: 100, always visible)
```

## Object Ownership

```
main.cpp stack:
  TelemetryViewModel  (owns unique_ptr<TelemetryEngine>)
  ScreenViewModel     (state only)
  MediaViewModel      (owns PlaylistModel data)
```

No ViewModel is dynamically allocated. All destroyed at `app.exec()` return.

## Map Rendering Constraints

- Plugin: `osm` (fallback). Carto Dark Matter requires custom tile URL plugin.
- Camera: `zoomLevel: 17.5`, `tilt: 60`, `bearing: telemetryVM.heading`, `interactive: false`
- Route: two MapPolylines — glow (width 12, green-400, opacity 0.3) + core (width 6, green-500)
- Markers: MapQuickItem with sourceItem QML component. Anchor `(0.5, 1.0)` for pin marker.
- Labels: MapQuickItem + Text components. Coordinates from MapConfig.

## Animation Patterns

- Implicit: `Behavior on property { NumberAnimation { duration: ms; easing: ... } }`
- Looping: `NumberAnimation on property { loops: Animation.Infinite; ... }`
- State: `ColorAnimation` on border color for speed limit pulse
- Canvas: `requestPaint()` on property change (gauge)

## Styling Map (web → QML)

| Web (Tailwind) | QML Equivalent |
|----------------|----------------|
| `bg-black/40` | `color: "rgba(0,0,0,0.4)"` |
| `backdrop-blur-xl` | `layer.effect: FastBlur { radius: 20 }` |
| `border-white/10` | `border.color: "rgba(255,255,255,0.1)"` |
| `rounded-[2rem]` | `radius: 32` (2rem × 16) |
| `drop-shadow-[0_0_20px_rgba(37,99,235,0.4)]` | `layer.effect: DropShadow { color: "#..."; radius: 20; samples: 17 }` |
| `text-4xl font-bold` | `font.pixelSize: 36; font.weight: Font.Bold` |
| `opacity-0 pointer-events-none` | `opacity: 0; enabled: false` |
| `from-[#050508] to-[#12151c]` | `gradient: Gradient { GradientStop { position: 0; color: "#..." } ... }` |

## What NOT to do

- ❌ Do NOT use Loader or StackView for screens — they must render simultaneously
- ❌ Do NOT access model/ classes from QML — only viewmodel/
- ❌ Do NOT use raw owning pointers — std::unique_ptr only
- ❌ Do NOT hardcode any color, size, or duration — use Theme.xxx or AppConfig::
- ❌ Do NOT add Qt dependency to model/ layer (except QString in structs)
- ❌ Do NOT skip trySetProperty() — direct member writes won't emit signals
- ❌ Do NOT use WebView or WebEngine — this is a native Qt6 app
