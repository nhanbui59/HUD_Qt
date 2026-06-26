#include "viewmodel/MediaViewModel.h"
#include "model/PlaylistModel.h"
#include <QVariantMap>

namespace QHUD {

MediaViewModel::MediaViewModel(QObject* parent)
    : QObject(parent)
    , m_playlistModel(std::make_unique<PlaylistModel>())
{
    buildPlaylist();
}

MediaViewModel::~MediaViewModel() = default;

void MediaViewModel::togglePlayPause()
{
    m_isPlaying = !m_isPlaying;
    Q_EMIT isPlayingChanged();
}

void MediaViewModel::nextTrack()
{
    if (m_playlistModel->count() == 0) return;

    int next = m_currentTrackIndex + 1;
    if (next >= m_playlistModel->count())
        next = 0;

    if (next != m_currentTrackIndex) {
        m_currentTrackIndex = next;
        Q_EMIT currentTrackIndexChanged();
    }
}

void MediaViewModel::prevTrack()
{
    if (m_playlistModel->count() == 0) return;

    int prev = m_currentTrackIndex - 1;
    if (prev < 0)
        prev = m_playlistModel->count() - 1;

    if (prev != m_currentTrackIndex) {
        m_currentTrackIndex = prev;
        Q_EMIT currentTrackIndexChanged();
    }
}

void MediaViewModel::buildPlaylist()
{
    QVariantList list;
    const auto& songs = m_playlistModel->songs();
    list.reserve(static_cast<int>(songs.size()));

    for (const auto& song : songs) {
        QVariantMap item;
        item[QStringLiteral("title")]    = song.title;
        item[QStringLiteral("artist")]   = song.artist;
        item[QStringLiteral("duration")] = song.duration;
        item[QStringLiteral("active")]   = song.active;
        list.append(item);
    }

    m_playlist = std::move(list);
    Q_EMIT playlistChanged();
}

} // namespace QHUD
