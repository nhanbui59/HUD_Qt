#pragma once

#include <QString>
#include <vector>

namespace QHUD {

// ── Song ──────────────────────────────────────────────────────────
struct Song {
    QString title;
    QString artist;
    QString duration;   // e.g. "3:20"
    bool    active = false;
};

// ── PlaylistModel ─────────────────────────────────────────────────
// Simple data container for the 7-song playlist from MediaScreen.tsx
class PlaylistModel {
public:
    PlaylistModel();

    const std::vector<Song>& songs() const;
    int                       count() const;

    // Return the song at index, or default-constructed if out of range
    const Song& songAt(int index) const;

private:
    std::vector<Song> m_songs;
};

} // namespace QHUD
