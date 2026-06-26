# Phase 1: Project Scaffolding & Build System
>
> Target: Days 1-2 | Status: ✅ DONE | Progress: 7/7 (100%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 1.1 | CMake project skeleton — Qt6 6.5+, C++17, find_package | ✅ DONE | `CMakeLists.txt` |
| 1.2 | main.cpp with QQmlApplicationEngine + context properties | ✅ DONE | `main.cpp` |
| 1.3 | resources/qml.qrc — enumerate all QML files | ✅ DONE | `resources/qml.qrc` |
| 1.4 | config/AppConfig.h + ThemeConfig.h — all constants | ✅ DONE | `config/AppConfig.h/cpp`, `ThemeConfig.h/cpp` |
| 1.5 | view/config/Theme.qml singleton — dark theme palette | ✅ DONE | `view/config/Theme.qml` |
| 1.6 | view/style/Fonts.qml + Shadows.qml | ✅ DONE | `view/style/Fonts.qml`, `Shadows.qml` |
| 1.7 | Verify build compiles + runs | ⬜ TODO | — blocked: no Qt6 SDK |

## Architecture Notes

- `CMAKE_AUTOMOC ON`, `CMAKE_AUTORCC ON` — Q_OBJECT macros and .qrc auto-processed
- `target_include_directories(QHUD PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})` — all includes from project root
- Qt6 components: Quick, QuickControls2, Positioning, Location
- ViewModels live on stack in main.cpp, exposed via `setContextProperty`
