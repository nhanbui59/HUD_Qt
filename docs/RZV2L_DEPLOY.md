# RZ/V2L Deployment Notes

## Target

- Board: Renesas RZ/V2L, dual Cortex-A55 1.2GHz, Mali-G31 GPU, 1GB RAM
- Display profile: 7 inch rectangular panel, 1024x600
- Preferred Qt platform plugin: `eglfs`

## Important Runtime Note

The executable alone is not enough unless the board image already contains the exact Qt 6 runtime, QML modules, and platform plugins compiled for the same ARM64 target.

Deploy one of these:

- Dynamic deployment: `QHUD` plus Qt shared libraries, QML imports, plugins, fonts, and runtime loader paths.
- Static deployment: one mostly self-contained binary built with static Qt. This is simpler to copy, but the build is larger and harder to maintain.

## Dynamic Runtime Checklist

The board needs at least:

- Qt libraries: Core, Gui, Quick, QuickControls2, Qml, Network, Core5Compat
- QML modules: QtQuick, QtQuick.Controls, Qt5Compat.GraphicalEffects
- Platform plugin: `eglfs` or a working Wayland plugin
- Mali-G31 EGL/OpenGL ES userspace drivers

## Run

Install the app under a folder that contains `bin/QHUD`, then run:

```sh
./scripts/run_rzv2l.sh
```

Equivalent direct command:

```sh
QT_QPA_PLATFORM=eglfs QT_QUICK_BACKEND=opengl QSG_RENDER_LOOP=basic ./bin/QHUD
```

## Current Embedded UI Decisions

- Navigation is 1024x600.
- Raster map tile downloads are disabled by default.
- The map background is a local lightweight vector grid.
- Route repaint interval is reduced to 100ms.
- Map repaint timer only runs when raster tiles are explicitly enabled.
