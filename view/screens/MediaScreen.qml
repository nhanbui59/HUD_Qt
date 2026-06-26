import QtQuick
import QtQuick.Controls
import "../config"
import "../style"
import "../components"

// ─── MediaScreen — music player with album art + playlist ──────────
// Matches EXACTLY: MediaScreen.tsx

Item {
    id: root

    // Inputs from mediaVM context
    property bool isPlaying: true
    property string currentTitle: "Midnight City"
    property string currentArtist: "M83"
    property string albumArtUrl: "https://images.unsplash.com/photo-1614613535308-eb5fbd3d2c17?q=80&w=800&auto=format&fit=crop"
    property real progress: 0.68           // 0-1
    property string elapsedTime: "2:45"
    property string durationTime: "4:03"
    property bool isActive: false
    property var playlist: []             // QVariantList of {title, artist, duration}

    anchors.fill: parent

    // ─── Background Gradient ──────────────────────────────
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.bgMediaStart }
            GradientStop { position: 1.0; color: Theme.bgMediaEnd }
        }
    }

    // ─── Background accent blurs ──────────────────────────
    // Purple accent (top-left)
    Rectangle {
        x: parent.width * -0.1
        y: parent.height * -0.2
        width: parent.width * 0.6
        height: parent.height * 0.6
        radius: Math.max(width, height) / 2
        color: Qt.rgba(124/255, 58/255, 237/255, 0.2)         // purple-600/20

        layer.enabled: false
    }

    // Blue accent (bottom-right)
    Rectangle {
        x: parent.width * 0.6
        y: parent.height * 0.6
        width: parent.width * 0.4
        height: parent.height * 0.4
        radius: Math.max(width, height) / 2
        color: Qt.rgba(37/255, 99/255, 235/255, 0.2)          // blue-600/20

        layer.enabled: false
    }

    // ─── Desktop: 2-column layout ────────────────────────
    Row {
        anchors.fill: parent
        anchors.margins: 32
        anchors.leftMargin: 80
        spacing: 32
        visible: root.width >= 768

        // ── Left Column: Now Playing ────────────────────
        Column {
            width: parent.width * 0.5
            height: parent.height
            spacing: 32
            anchors.verticalCenter: parent.verticalCenter

            // Header
            Column {
                spacing: 4
                Text {
                    text: "Now Playing"
                    color: Theme.white
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize5xl
                    font.weight: Font.Bold
                }
                Text {
                    text: "Bluetooth Audio // iPhone 16 Pro"
                    color: Theme.gray400
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXl
                    font.weight: Font.Medium
                }
                // Border bottom
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Theme.glassBorder
                    anchors.topMargin: 16
                }
            }

            // Album Art + Controls area
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 24
                width: Math.min(parent.width, 320)

                // Album Art (rounded-3xl, border, hover zoom)
                Item {
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 320; height: 320

                    Rectangle {
                        anchors.fill: parent
                        radius: 48
                        border.color: Theme.glassBorder
                        border.width: 1

                        // Shadow
                        Rectangle {
                            anchors.fill: parent
                            radius: parent.radius
                            color: Qt.rgba(0, 0, 0, 0.5)
                            opacity: 0.6
                            y: 20
                            layer.enabled: false
                        }
                    }

                    Image {
                        anchors.fill: parent
                        source: root.albumArtUrl
                        fillMode: Image.PreserveAspectCrop
                        clip: true

                        // Hover zoom
                        scale: mouseArea.containsMouse ? 1.05 : 1.0
                        Behavior on scale { NumberAnimation { duration: 700; easing.type: Easing.OutQuad } }
                    }

                    // Gradient overlay top
                    Rectangle {
                        anchors.fill: parent
                        radius: 48
                        gradient: Gradient {
                            GradientStop { position: 0.6; color: "transparent" }
                            GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.6) }
                        }
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                    }
                }

                // Song metadata + heart
                Row {
                    width: parent.width

                    Column {
                        spacing: 4
                        Text {
                            text: root.currentTitle
                            color: Theme.white
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize4xl
                            font.weight: Font.Bold
                        }
                        Text {
                            text: root.currentArtist
                            color: Theme.purple400
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSize2xl
                            font.weight: Font.Medium
                        }
                    }

                    Item { width: 1; height: 1 }  // spacer

                    // Heart button
                    IconButton {
                        btnSize: 40
                        inactiveBg: "transparent"
                        borderColor: "transparent"
                        iconText: "♥"
                        iconTextColor: Theme.pink500
                        showGlow: false
                        onClicked: { /* favorite toggle */ }
                    }
                }

                // Progress Bar
                Column {
                    width: parent.width
                    spacing: 8

                    ProgressBar {
                        width: parent.width
                        progress: root.progress
                        barHeight: 8
                        barRadius: 4
                        trackColor: Theme.glassBgWhite10
                        fillColorStart: Theme.purple500
                        fillColorEnd: Theme.blue500
                        glowEnabled: false
                        showLeftTimestamp: true
                        showRightTimestamp: true
                        leftTimestampText: root.elapsedTime
                        rightTimestampText: root.durationTime
                        timestampFontSize: Theme.fontSizeSm
                    }
                }

                // Media Controls
                MediaControls {
                    isPlaying: root.isPlaying
                    onPlayPauseClicked: { /* toggle via mediaVM */ }
                    onSkipBackClicked: { /* skip back */ }
                    onSkipForwardClicked: { /* skip forward */ }
                    onShuffleClicked: { /* shuffle */ }
                    onRepeatClicked: { /* repeat */ }
                }
            }
        }

        // ── Right Column: Up Next / Playlist ────────────
        Rectangle {
            width: parent.width * 0.5
            height: parent.height
            radius: 48
            color: Theme.glassBgBlack20
            border.color: Theme.glassBorderAlt
            border.width: 1

            Column {
                anchors.fill: parent
                anchors.margins: 40

                // "Up Next" header
                Row {
                    width: parent.width
                    spacing: 16

                    Text {
                        text: "Up Next"
                        color: Theme.white
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSize3xl
                        font.weight: Font.Bold
                    }

                    Rectangle {
                        width: 90; height: 28
                        radius: 14
                        color: Theme.glassBgWhite10
                        Text {
                            anchors.centerIn: parent
                            text: "24 Tracks"
                            color: Theme.gray300
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXs
                            font.weight: Font.Medium
                        }
                    }
                }

                Item { height: 32; width: 1 }

                // Playlist
                ListView {
                    id: playlistView
                    width: parent.width
                    height: parent.height - 60
                    clip: true
                    spacing: 12

                    model: ListModel {
                        id: playlistModel
                        ListElement { title: "Blinding Lights"; artist: "The Weeknd"; duration: "3:20"; active: false }
                        ListElement { title: "Starboy"; artist: "The Weeknd"; duration: "3:50"; active: false }
                        ListElement { title: "Instant Crush"; artist: "Daft Punk"; duration: "5:38"; active: false }
                        ListElement { title: "Nightcall"; artist: "Kavinsky"; duration: "4:19"; active: false }
                        ListElement { title: "Resonance"; artist: "HOME"; duration: "3:32"; active: false }
                        ListElement { title: "Odd Look"; artist: "Kavinsky, The Weeknd"; duration: "4:12"; active: false }
                        ListElement { title: "Kids"; artist: "MGMT"; duration: "5:02"; active: false }
                    }

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 72
                        radius: 16
                        color: active ? Theme.glassBgWhite10 : (mouseAreaPlaylist.containsMouse ? Theme.glassBgWhite5 : "transparent")
                        border.color: active ? Theme.glassBorder : "transparent"
                        border.width: 1

                        Behavior on color { ColorAnimation { duration: 200 } }

                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 16
                            spacing: 16

                            // Track number box
                            Rectangle {
                                width: 56; height: 56
                                radius: 12
                                color: Theme.gray800

                                Text {
                                    anchors.centerIn: parent
                                    text: index + 2
                                    color: Theme.gray500
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeLg
                                    font.weight: Font.Bold
                                }
                            }

                            Column {
                                anchors.verticalCenter: parent.verticalCenter
                                spacing: 2

                                Text {
                                    text: title
                                    color: active ? Theme.blue400 : Theme.white
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeXl
                                    font.weight: Font.Bold
                                }
                                Text {
                                    text: artist
                                    color: Theme.gray400
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeBase
                                    font.weight: Font.Normal
                                }
                            }
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 16
                            text: duration
                            color: Theme.gray500
                            font.family: Theme.fontFamilyMono
                            font.pixelSize: Theme.fontSizeBase
                        }

                        MouseArea {
                            id: mouseAreaPlaylist
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: { /* select track */ }
                        }
                    }
                }
            }
        }
    }

    // ─── Mobile layout (stacked) ──────────────────────────
    Flickable {
        anchors.fill: parent
        anchors.margins: 24
        contentHeight: mobileContent.implicitHeight + 140
        visible: root.width < 768
        clip: true

        Column {
            id: mobileContent
            width: parent.width
            spacing: 24

            Item { height: 60; width: 1 }  // top padding

            // Now Playing header
            Column {
                spacing: 4
                Text {
                    text: "Now Playing"
                    color: Theme.white
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSize3xl
                    font.weight: Font.Bold
                }
                Text {
                    text: "Bluetooth Audio // iPhone 16 Pro"
                    color: Theme.gray400
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeLg
                    font.weight: Font.Medium
                }
            }

            // Album art
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: Math.min(parent.width * 0.6, 200)
                height: width
                radius: 40
                border.color: Theme.glassBorder
                border.width: 1

                Image {
                    anchors.fill: parent
                    source: root.albumArtUrl
                    fillMode: Image.PreserveAspectCrop
                }
            }

            // Metadata
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 4
                Text { text: root.currentTitle; color: Theme.white; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize2xl; font.weight: Font.Bold }
                Text { text: root.currentArtist; color: Theme.purple400; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeLg; font.weight: Font.Medium }
            }

            // Progress
            ProgressBar {
                width: parent.width
                progress: root.progress
                barHeight: 6
                trackColor: Theme.glassBgWhite10
                fillColorStart: Theme.purple500
                fillColorEnd: Theme.blue500
                glowEnabled: false
                showLeftTimestamp: true
                showRightTimestamp: true
                leftTimestampText: root.elapsedTime
                rightTimestampText: root.durationTime
            }

            // Controls
            MediaControls {
                anchors.horizontalCenter: parent.horizontalCenter
                isPlaying: root.isPlaying
            }

            // Up Next section
            Rectangle {
                width: parent.width
                height: 400
                radius: 40
                color: Theme.glassBgBlack20
                border.color: Theme.glassBorderAlt

                Column {
                    anchors.fill: parent
                    anchors.margins: 24

                    Row {
                        spacing: 12
                        Text { text: "Up Next"; color: Theme.white; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSize2xl; font.weight: Font.Bold }
                        Rectangle {
                            width: 80; height: 24
                            radius: 12
                            color: Theme.glassBgWhite10
                            Text {
                                anchors.centerIn: parent
                                text: "24 Tracks"
                                color: Theme.gray300
                                font.pixelSize: Theme.fontSize2xs
                                font.weight: Font.Medium
                            }
                        }
                    }

                    Item { height: 16; width: 1 }

                    ListView {
                        width: parent.width
                        height: parent.height - 60
                        clip: true
                        spacing: 8

                        model: ListModel {
                            ListElement { t: "Blinding Lights"; a: "The Weeknd"; d: "3:20" }
                            ListElement { t: "Starboy"; a: "The Weeknd"; d: "3:50" }
                            ListElement { t: "Instant Crush"; a: "Daft Punk"; d: "5:38" }
                            ListElement { t: "Nightcall"; a: "Kavinsky"; d: "4:19" }
                            ListElement { t: "Resonance"; a: "HOME"; d: "3:32" }
                            ListElement { t: "Odd Look"; a: "Kavinsky, The Weeknd"; d: "4:12" }
                            ListElement { t: "Kids"; a: "MGMT"; d: "5:02" }
                        }

                        delegate: Rectangle {
                            width: ListView.view.width
                            height: 56
                            radius: 14
                            color: "transparent"

                            Row {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.left: parent.left
                                anchors.leftMargin: 12
                                spacing: 12

                                Rectangle {
                                    width: 44; height: 44
                                    radius: 10
                                    color: Theme.gray800
                                    Text {
                                        anchors.centerIn: parent
                                        text: index + 2
                                        color: Theme.gray500
                                        font.weight: Font.Bold
                                    }
                                }

                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    spacing: 2
                                    Text { text: t; color: Theme.white; font.family: Theme.fontFamily; font.pixelSize: Theme.fontSizeBase; font.weight: Font.Bold }
                                    Text { text: a; color: Theme.gray400; font.pixelSize: Theme.fontSizeSm }
                                }
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.right: parent.right
                                anchors.rightMargin: 12
                                text: d
                                color: Theme.gray500
                                font.family: Theme.fontFamilyMono
                                font.pixelSize: Theme.fontSizeSm
                            }
                        }
                    }
                }
            }
        }
    }

    // ─── MediaVM data bindings ────────────────────────────
    Component.onCompleted: {
        if (typeof mediaVM !== "undefined") {
            isPlaying = Qt.binding(function() { return mediaVM.isPlaying })
        }
    }
}
