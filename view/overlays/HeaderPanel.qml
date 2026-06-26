import QtQuick
import "../config"

// ─── HeaderPanel — top center glass panel with speed + instruction ──
// Matches EXACTLY: HeaderPanel.tsx

Item {
    id: root

    // Properties bound from telemetryVM context
    property real speed: 0
    property real speedLimit: 60
    property string nextTurnStreet: ""
    property real nextTurnDistance: 0
    property bool isHeadlightsOn: false
    property bool isDoorOpenWarning: false
    property bool isDesktop: parent.width >= 768

    anchors.top: parent.top
    anchors.topMargin: isDesktop ? 24 : 16
    anchors.horizontalCenter: parent.horizontalCenter

    width: Math.min(parent.width * 0.95, 920)
    height: isDesktop ? 80 : 60

    // ─── Glass Panel Container ──────────────────────────────
    Rectangle {
        id: panel
        anchors.fill: parent
        radius: 24
        color: root.isDesktop ? Theme.glassBgBlack40 : Theme.glassBgBlack50
        border.color: Theme.glassBorder
        border.width: 1
    }

    // ── Desktop Layout ──────────────────────────────────────
    Row {
        id: desktopRow
        anchors { fill: parent; leftMargin: 24; rightMargin: 24 }
        visible: root.isDesktop

        // Left: Speed + Speed Limit — proportional width
        Item {
            width: desktopRow.width * 0.28
            height: parent.height

            Row {
                anchors.centerIn: parent
                spacing: Math.max(12, desktopRow.width * 0.03)

                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 0

                    Text {
                        text: Math.round(root.speed)
                        color: Theme.white; font.family: Theme.fontFamily; font.weight: Font.Bold
                        font.pixelSize: Math.max(24, desktopRow.width * 0.045)
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Text {
                        text: "KM/H"
                        color: Theme.gray400; font.family: Theme.fontFamily; font.weight: Font.Bold
                        font.pixelSize: Math.max(8, desktopRow.width * 0.012)
                        font.capitalization: Font.AllUppercase
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(32, desktopRow.width * 0.05); height: width
                    radius: width / 2
                    color: Theme.white; border.color: Theme.red600; border.width: 3
                    Text {
                        anchors.centerIn: parent
                        text: root.speedLimit
                        color: Theme.bgPrimary; font.family: Theme.fontFamily; font.weight: Font.Black
                        font.pixelSize: Math.max(14, width * 0.45)
                    }
                }
            }
        }

        // Center: Instruction — gets more proportional space
        Item {
            width: desktopRow.width * 0.44
            height: parent.height

            Column {
                anchors.centerIn: parent
                spacing: 2
                width: parent.width

                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Chỉ dẫn"
                    color: Theme.blue400; font.family: Theme.fontFamily; font.weight: Font.DemiBold
                    font.pixelSize: Math.max(9, desktopRow.width * 0.013)
                    font.capitalization: Font.AllUppercase
                }
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: "Rẽ vào " + root.nextTurnStreet + " sau " + root.nextTurnDistance.toFixed(1) + " km"
                    color: Theme.white; font.family: Theme.fontFamily; font.weight: Font.Medium
                    font.pixelSize: Math.max(14, desktopRow.width * 0.022)
                    horizontalAlignment: Text.AlignHCenter
                    width: parent.width
                    maximumLineCount: 1
                    clip: true
                }
            }
        }

        // Right: Warning icons — small
        Item {
            width: desktopRow.width * 0.28
            height: parent.height

            Row {
                anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                spacing: Math.max(12, desktopRow.width * 0.03)
                layoutDirection: Qt.RightToLeft

                Text { anchors.verticalCenter: parent.verticalCenter; text: "☀"
                    color: root.isHeadlightsOn ? Theme.green400 : Theme.gray600
                    font.pixelSize: Math.max(16, desktopRow.width * 0.028) }
                Text { anchors.verticalCenter: parent.verticalCenter; text: "!"; font.family: Theme.fontFamily; font.weight: Font.Black
                    color: Theme.yellow500
                    font.pixelSize: Math.max(16, desktopRow.width * 0.028) }
                Text { anchors.verticalCenter: parent.verticalCenter; text: "◧"; color: Theme.red500
                    font.pixelSize: Math.max(16, desktopRow.width * 0.028); visible: root.isDoorOpenWarning }
            }
        }
    }

    // ── Mobile Layout ───────────────────────────────────────
    Row {
        id: mobileRow
        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
        visible: !root.isDesktop

        Item {
            width: parent.width * 0.55
            height: parent.height

            Row {
                anchors.centerIn: parent
                spacing: Math.max(8, parent.width * 0.04)

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: Math.round(root.speed)
                    color: Theme.white; font.family: Theme.fontFamily; font.weight: Font.Bold
                    font.pixelSize: Math.max(18, parent.parent.width * 0.06)
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "KM/H"
                    color: Theme.gray400; font.family: Theme.fontFamily; font.weight: Font.Bold
                    font.pixelSize: Math.max(7, parent.parent.width * 0.02)
                    font.capitalization: Font.AllUppercase
                }
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: Math.max(28, parent.parent.width * 0.08); height: width
                    radius: width / 2
                    color: Theme.white; border.color: Theme.red600; border.width: 3
                    Text {
                        anchors.centerIn: parent
                        text: root.speedLimit; color: Theme.bgPrimary; font.family: Theme.fontFamily; font.weight: Font.Black
                        font.pixelSize: Math.max(12, width * 0.45)
                    }
                }
            }
        }

        Item {
            width: parent.width * 0.45
            height: parent.height
            Row {
                anchors { verticalCenter: parent.verticalCenter; right: parent.right }
                spacing: Math.max(8, parent.width * 0.04)
                layoutDirection: Qt.RightToLeft

                Text { anchors.verticalCenter: parent.verticalCenter; text: "☀"
                    color: root.isHeadlightsOn ? Theme.green400 : Theme.gray600
                    font.pixelSize: Math.max(14, parent.parent.width * 0.045) }
                Text { anchors.verticalCenter: parent.verticalCenter; text: "!"; font.family: Theme.fontFamily; font.weight: Font.Black
                    color: Theme.yellow500
                    font.pixelSize: Math.max(14, parent.parent.width * 0.045) }
                Text { anchors.verticalCenter: parent.verticalCenter; text: "◧"; color: Theme.red500
                    font.pixelSize: Math.max(14, parent.parent.width * 0.045); visible: root.isDoorOpenWarning }
            }
        }
    }
}
