#include "model/PlaylistModel.h"

namespace QHUD {

PlaylistModel::PlaylistModel()
{
    // 7 songs from MediaScreen.tsx
    // Index 0 = currently playing ("Midnight City")
    m_songs = {
        { QStringLiteral("Midnight City"),  QStringLiteral("M83"),
          QStringLiteral("4:03"), true },
        { QStringLiteral("Blinding Lights"), QStringLiteral("The Weeknd"),
          QStringLiteral("3:20"), false },
        { QStringLiteral("Starboy"), QStringLiteral("The Weeknd"),
          QStringLiteral("3:50"), false },
        { QStringLiteral("Instant Crush"), QStringLiteral("Daft Punk"),
          QStringLiteral("5:38"), false },
        { QStringLiteral("Nightcall"), QStringLiteral("Kavinsky"),
          QStringLiteral("4:19"), false },
        { QStringLiteral("Resonance"), QStringLiteral("HOME"),
          QStringLiteral("3:32"), false },
        { QStringLiteral("Odd Look"), QStringLiteral("Kavinsky, The Weeknd"),
          QStringLiteral("4:12"), false },
        { QStringLiteral("Kids"), QStringLiteral("MGMT"),
          QStringLiteral("5:02"), false },
    };
}

const std::vector<Song>& PlaylistModel::songs() const
{
    return m_songs;
}

int PlaylistModel::count() const
{
    return static_cast<int>(m_songs.size());
}

const Song& PlaylistModel::songAt(int index) const
{
    static const Song empty;
    if (index < 0 || index >= static_cast<int>(m_songs.size()))
        return empty;
    return m_songs[index];
}

} // namespace QHUD
