import QtQuick
import "../config"
import "../style"

// ─── CenterPanel — small bottom-left destination monospace label ────
// Matches EXACTLY: CenterPanel.tsx

Item {
    id: root

    anchors.left: parent.left
    anchors.leftMargin: 40
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 200

    width: 500
    height: 20

    Text {
        text: "DESTINATION: BITEXCO FINANCIAL TOWER [10.7708° N, 106.7048° E]"
        color: Qt.rgba(1, 1, 1, 0.4)
        font.family: Theme.fontFamilyMono
        font.pixelSize: 10
        font.weight: Font.Normal
    }
}
