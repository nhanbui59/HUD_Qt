import QtQuick
import "../config"

Item {
    id: root
    property string nextTurnStreet: ""
    property real nextTurnDistance: 0
    property string currentStreet: ""
    property int nextTurnManeuver: 2
    property real totalDistanceRemaining: 0
    property string eta: "--:--"
    property int odometer: 0
    property real fuelLevel: 0
    property real fuelRange: 0
    property bool big: width >= 768

    anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
    height: big ? 130 : 160

    // Gradient overlay
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 0.4; color: Qt.rgba(0, 0, 0, 0.6) }
            GradientStop { position: 1; color: Qt.rgba(0, 0, 0, 0.85) }
        }
    }

    Rectangle {
        id: glassPanel
        anchors { bottom: parent.bottom; bottomMargin: big ? 24 : 20; left: parent.left; leftMargin: big ? 80 : 16; right: parent.right; rightMargin: big ? 32 : 16 }
        height: big ? 96 : implicitHeight
        radius: 24; color: Qt.rgba(1, 1, 1, 0.08); border { color: Qt.rgba(1, 1, 1, 0.1); width: 1 }

        // Desktop: 3-column
        Row {
            anchors { fill: parent; margins: 20 }
            spacing: 16
            visible: root.big

            // Left: turn icon + street
            Rectangle { width: 48; height: 48; radius: 12; color: Theme.blue600; anchors.verticalCenter: parent.verticalCenter }
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 3 - 80
                spacing: 2
                Text {
                    text: root.nextTurnStreet + " trong " + root.nextTurnDistance.toFixed(1) + " km"
                    color: Theme.white; font.family: "Helvetica"; font.pixelSize: 20; font.weight: Font.Bold
                    width: parent.width; elide: Text.ElideNone; maximumLineCount: 1
                }
                Text {
                    text: "\u0110u\u1EDDng hi\u1EC7n t\u1EA1i: " + root.currentStreet
                    color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 12; font.weight: Font.DemiBold
                    width: parent.width; elide: Text.ElideNone; maximumLineCount: 1
                }
            }

            // Center: trip progress
            Column {
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 3
                spacing: 6
                Row { anchors.horizontalCenter: parent.horizontalCenter; spacing: 12
                    Text { text: root.totalDistanceRemaining.toFixed(1) + " km total"; color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 10; font.weight: Font.Bold; font.capitalization: Font.AllUppercase }
                    Text { text: root.eta; color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 10; font.weight: Font.Bold }
                }
                Rectangle { width: parent.width - 20; height: 4; radius: 2; color: Qt.rgba(1,1,1,0.1); anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle { height: 4; radius: 2; width: parent.width * ((100 - root.totalDistanceRemaining / 1.5 * 100) / 100); color: Theme.blue500 } }
            }

            // Right: vehicle info
            Row {
                anchors.verticalCenter: parent.verticalCenter
                spacing: 16
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: root.odometer; color: Theme.white; font.family: "Helvetica"; font.pixelSize: 18; font.weight: Font.Bold }
                    Text { text: "Odometer Km"; color: Theme.gray500; font.family: "Helvetica"; font.pixelSize: 9; font.weight: Font.Bold; font.capitalization: Font.AllUppercase }
                }
                Rectangle { width: 1; height: 32; color: Qt.rgba(1,1,1,0.1); anchors.verticalCenter: parent.verticalCenter }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Text { text: "\u26FD " + root.fuelLevel.toFixed(0) + "%"; color: Theme.white; font.family: "Helvetica"; font.pixelSize: 18; font.weight: Font.Bold }
                    Text { text: root.fuelRange.toFixed(0) + " km left"; color: Theme.gray500; font.family: "Helvetica"; font.pixelSize: 9; font.weight: Font.Bold; font.capitalization: Font.AllUppercase }
                }
                Text { text: "\u2726"; color: Theme.blue400; font.pixelSize: 18; anchors.verticalCenter: parent.verticalCenter }
            }
        }

        // Mobile: stacked
        Column {
            anchors { fill: parent; margins: 16 }
            spacing: 10
            visible: !root.big

            Row { spacing: 12; width: parent.width
                Rectangle { width: 40; height: 40; radius: 10; color: Theme.blue600; anchors.verticalCenter: parent.verticalCenter }
                Column { width: parent.width - 52
                    Text { text: root.nextTurnStreet + " trong " + root.nextTurnDistance.toFixed(1) + " km"; color: Theme.white; font.family: "Helvetica"; font.pixelSize: 16; font.weight: Font.Bold; width: parent.width }
                    Text { text: root.currentStreet; color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 11; width: parent.width }
                }
            }
            Row { width: parent.width; spacing: 16; anchors.horizontalCenter: parent.horizontalCenter
                Text { text: root.eta; color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 11 }
                Text { text: root.totalDistanceRemaining.toFixed(1) + " km"; color: Theme.gray400; font.family: "Helvetica"; font.pixelSize: 11 }
            }
            Row { width: parent.width; spacing: 16
                Text { text: root.odometer + " Km"; color: Theme.white; font.family: "Helvetica"; font.pixelSize: 16; font.weight: Font.Bold }
                Text { text: "\u26FD " + root.fuelLevel.toFixed(0) + "%"; color: Theme.white; font.family: "Helvetica"; font.pixelSize: 16; font.weight: Font.Bold }
            }
        }
    }
}
