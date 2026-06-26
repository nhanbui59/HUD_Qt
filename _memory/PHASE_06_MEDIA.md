# Phase 6: Media Screen
>
> Target: Days 17-19 | Status: ✅ DONE | Progress: 7/8 (88%)

## Tasks

| # | Task | Status | Output File |
|---|------|--------|-------------|
| 6.1 | MediaScreen.qml — two-column layout | ✅ DONE | `view/screens/MediaScreen.qml` |
| 6.2 | Album art with Image — rounded-3xl, border, hover zoom | ✅ DONE | `MediaScreen.qml` |
| 6.3 | Song metadata — title + artist + heart button | ✅ DONE | `MediaScreen.qml` |
| 6.4 | ProgressBar.qml component — gradient fill, timestamps | ✅ DONE | `view/components/ProgressBar.qml` |
| 6.5 | MediaControls.qml — Shuffle/SkipBack/PlayPause/SkipForward/Repeat | ✅ DONE | `view/components/MediaControls.qml` |
| 6.6 | Playlist list — 7 songs, scrollable | ✅ DONE | `MediaScreen.qml` |
| 6.7 | Dynamic background blurs — purple + blue radial accents | ✅ DONE | `MediaScreen.qml` |
| 6.8 | Wire Play/Pause state to MediaViewModel | ⚠️ PARTIAL | `MediaScreen.qml` — wired but needs QA with C++ backend |

## Architecture Notes

- Current track: "Midnight City" / "M83" (hardcoded as web)
- Album art uses Unsplash URL from web source
- Playlist: 7 songs from MediaScreen.tsx ported exactly
- Gradient bg: #1a1a2e → #0f0f1a
- Song list items: active track shows blue highlight (bg-white/10 + border-white/10)

## Known Issues

| # | Issue | Severity |
|---|-------|----------|
| I6.1 | Album art Image source is external URL — no offline fallback. Consider bundling placeholder | MEDIUM |
| I6.2 | Heart button icon needs SVG path — currently uses Canvas | LOW |
