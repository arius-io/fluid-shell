import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import "../utils/settings.js" as Settings

Rectangle {
    property alias battery_container: battery_container
    property alias battery_level: battery_level
    Component.onCompleted: {
        Settings.getDatabase()
    }
    width: root.width
    height: (root.width > root.height) ? root.width / 30 : root.height / 30
    z: 50
    color: "#000000"
    anchors {
        top: parent.top
    }
    Text {
        visible: (root.state_handler.state == "normal")
        id: clock
        color: "#ffffff"
        text: Qt.formatDateTime(new Date(), "HH:mm")
        Timer {
            repeat: true
            interval: 1000
            running: true
            onTriggered: {
                parent.text = Qt.formatDateTime(new Date(), "HH:mm")
            }
        }
        font.pixelSize: parent.height / 2
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: Settings.get("statusbar_screen_offset")
        }
    }
    Rectangle {
            id: battery_container
            anchors {
                right: (root.state_handler.state == "normal") ? clock.left : parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: Settings.get("statusbar_screen_offset")
            }
            height: clock.height
            width: (root.width > root.height) ? root.height / 55 : root.width / 55
            color: "#4fffffff"
            Rectangle {
                id: battery_level
                height: 0
                width: parent.width
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

}
