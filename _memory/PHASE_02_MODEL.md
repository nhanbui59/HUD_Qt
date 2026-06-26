# Phase 2: Core Data Layer (Model)
>
> Target: Days 3-4 | Status: ✅ DONE | Progress: 4/5 (80%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 2.1 | TelemetryTypes.h — structs, enums, zero Qt deps | ✅ DONE | `model/TelemetryTypes.h` |
| 2.2 | RouteCalculator — interpolation, heading, turn detect, smoothing | ✅ DONE | `model/RouteCalculator.h/cpp` |
| 2.3 | TelemetryEngine — 60fps QTimer, speed fluctuate, route progress, ETA | ✅ DONE | `model/TelemetryEngine.h/cpp` |
| 2.4 | PlaylistModel — song list data container | ✅ DONE | `model/PlaylistModel.h/cpp` |
| 2.5 | Unit-test RouteCalculator math | ⬜ TODO | — stand-alone C++ tests |

## Architecture Notes

- Model classes are PURE C++ — no QObject inheritance, no Qt signals
- `TelemetryEngine` uses `std::function<void(const TelemetryData&)>` callback, not Qt signal/slot
- `RouteCalculator` is entirely static methods — can be tested without instantiation
- All magic numbers replaced with `AppConfig::` constants (speed clamps, thresholds, smoothing factor)
- Route is 29 coordinates, Ho Chi Minh City loop, ported exactly from TelemetryService.ts
