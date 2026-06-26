import QtQuick
import "../config"
import "../style"

// ─── TirePressureCard — 4-wheel tire pressure grid ──────────────────
// Matches EXACTLY: DashboardScreen.tsx TirePressure section

Item {
    id: root

    // Tire pressures (PSI)
    property int flPressure: 42
    property int frPressure: 42
    property int rlPressure: 41
    property int rrPressure: 38

    // Nominal threshold for "low"
    property int nominalPressure: Theme.tirePressureNominal

    implicitWidth: 320
    implicitHeight: 180

    Rectangle {
        anchors.fill: parent
        radius: 16
        color: Qt.rgba(1, 1, 1, 0.035)
        border.color: Qt.rgba(1, 1, 1, 0.08)
        border.width: 1
    }

    Column {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 16

        // Header
        Row {
            spacing: 8
            Text {
                text: "⟳"
                color: Theme.cyan400
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: "Tire Pressure"
                color: Theme.gray400
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Bold
                font.capitalization: Font.AllUppercase
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        // 2x2 grid
        Grid {
            columns: 2
            rowSpacing: 12
            columnSpacing: 12

            // FL
            TirePressureTile { label: "FL"; pressure: flPressure; isLow: flPressure < nominalPressure }
            // FR
            TirePressureTile { label: "FR"; pressure: frPressure; isLow: frPressure < nominalPressure }
            // RL
            TirePressureTile { label: "RL"; pressure: rlPressure; isLow: rlPressure < nominalPressure }
            // RR
            TirePressureTile { label: "RR"; pressure: rrPressure; isLow: rrPressure < nominalPressure }
        }
    }

    // ── Reusable tile ──────────────────────────────────────
    component TirePressureTile: Item {
        property string label: ""
        property int pressure: 0
        property bool isLow: false

        width: 140
        height: 48

        Rectangle {
            anchors.fill: parent
            radius: 8
            color: isLow ? Qt.rgba(239/255, 68/255, 68/255, 0.15) : "transparent"
            border.color: isLow ? Qt.rgba(239/255, 68/255, 68/255, 0.4) : "transparent"
            border.width: 1
        }

        Row {
            anchors.centerIn: parent
            spacing: 12

            Text {
                text: label
                color: Theme.gray400
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: pressure
                color: isLow ? Theme.red400 : Theme.white
                font.family: Theme.fontFamilyMono
                font.pixelSize: Theme.fontSizeSm
                font.weight: Font.Bold
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "PSI"
                color: isLow ? Theme.red400 : Theme.gray400
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize2xs
                font.weight: Font.Normal
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
