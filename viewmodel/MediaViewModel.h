#pragma once

#include <QObject>
#include <QVariantList>
#include <QString>

namespace QHUD {

class PlaylistModel;

// ── MediaViewModel ────────────────────────────────────────────────
// Exposes playlist data and playback state to QML.
// Owns PlaylistModel internally.
class MediaViewModel : public QObject {
    Q_OBJECT

    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    Q_PROPERTY(QVariantList playlist READ playlist NOTIFY playlistChanged)
    Q_PROPERTY(int currentTrackIndex READ currentTrackIndex NOTIFY currentTrackIndexChanged)

public:
    explicit MediaViewModel(QObject* parent = nullptr);
    ~MediaViewModel() override;

    bool        isPlaying()         const { return m_isPlaying; }
    QVariantList playlist()         const { return m_playlist; }
    int         currentTrackIndex() const { return m_currentTrackIndex; }

    Q_INVOKABLE void togglePlayPause();
    Q_INVOKABLE void nextTrack();
    Q_INVOKABLE void prevTrack();

signals:
    void isPlayingChanged();
    void playlistChanged();
    void currentTrackIndexChanged();

private:
    void buildPlaylist();

    std::unique_ptr<PlaylistModel> m_playlistModel;

    bool         m_isPlaying         = true;
    int          m_currentTrackIndex = 0;
    QVariantList m_playlist;
};

} // namespace QHUD
