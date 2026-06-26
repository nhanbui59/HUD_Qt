import QtQuick
import QtQuick.Controls
import "../config"

Item {
    id: root
    property string currentScreen: "navigation"
    property bool big: root.parent ? root.parent.width >= 768 : true
    signal screenSelected(string screenId)

    Item {
        id: dockPos
        x: root.big ? 24 : (root.parent ? (root.parent.width - dockPanel.width) / 2 : 0)
        y: root.big ? (root.parent ? (root.parent.height - dockPanel.height) / 2 : 0) : (root.parent ? root.parent.height - dockPanel.height - 24 : 0)
        width: dockPanel.width; height: dockPanel.height

        Rectangle {
            id: dockPanel
            width: root.big ? Theme.dockButtonSize + 32 : colLayout.width + 16
            height: root.big ? colLayout.height + 16 : Theme.dockButtonSize + 16
            radius: 32; color: Qt.rgba(0,0,0,0.4); border { color: Qt.rgba(1,1,1,0.1); width: 1 }
            Column { id: colLayout; anchors.centerIn: parent; spacing: root.big ? 16 : 8
                Repeater {
                    model: [{id:"navigation",icon:"◆"},{id:"dashboard",icon:"◈"},{id:"media",icon:"♫"}]
                    delegate: Rectangle {
                        width: root.big ? Theme.dockButtonSize : Theme.dockButtonSizeMobile; height:width; radius:20
                        color: root.currentScreen===modelData.id ? Theme.blue600 : Qt.rgba(1,1,1,0.05)
                        border { color: root.currentScreen===modelData.id ? Theme.blue500 : "transparent"; width:root.currentScreen===modelData.id?2:0 }
                        scale: root.currentScreen===modelData.id ? 1.1 : 1.0
                        Behavior on color { ColorAnimation { duration:300 } }
                        Behavior on scale { NumberAnimation { duration:300; easing.type:Easing.OutBack } }
                        Text { anchors.centerIn:parent; text:modelData.icon; color:root.currentScreen===modelData.id?Theme.white:Theme.gray400; font.pixelSize:root.big?28:24 }
                        MouseArea { anchors.fill:parent; cursorShape:Qt.PointingHandCursor; onClicked: root.screenSelected(modelData.id) }
                    }
                }
            }
        }
    }
}
