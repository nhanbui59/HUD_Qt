# RZ/V2L Deployment Notes

## Target

- Board: Renesas RZ/V2L, dual Cortex-A55 1.2GHz, Mali-G31 GPU, 1GB RAM
- Display profile: 7 inch rectangular panel, 1024x600
- Preferred Qt platform plugin: `eglfs`

## Important Runtime Note

The app is designed to be started directly as `QHUD`. On Linux embedded, it auto-selects `eglfs` when no `DISPLAY` or `WAYLAND_DISPLAY` session is present.

The executable alone is enough only when the board image already contains the exact Qt 6 runtime, QML modules, platform plugins, and Mali userspace drivers compiled for the same ARM64 target.

Deploy one of these:

- Dynamic deployment: `QHUD` plus Qt shared libraries, QML imports, plugins, fonts, and runtime loader paths.
- Static deployment: one mostly self-contained binary built with static Qt. This is simpler to copy, but the build is larger and harder to maintain.

## Dynamic Runtime Checklist

The board needs at least:

- Qt libraries: Core, Gui, Quick, QuickControls2, Qml, Network
- QML modules: QtQuick, QtQuick.Controls
- Platform plugin: `eglfs` or a working Wayland plugin
- Mali-G31 EGL/OpenGL ES userspace drivers

## Run

Run the binary directly:

```sh
./QHUD
```

## Current Embedded UI Decisions

- Navigation is 1024x600.
- Raster map tiles are enabled by default for accurate street detail.
- A 49-tile offline cache around the HCMC route is embedded at zoom 17.
- The app reads offline tiles first; network tiles are only used when offline tiles are disabled.
- The local lightweight vector grid remains only as a fallback when raster tiles are disabled.
- Route repaint interval is reduced to 100ms.
- Map repaint timer only runs when raster tiles are explicitly enabled.
