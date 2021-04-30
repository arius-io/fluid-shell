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
    height: (root.width > root.height) ? root.width / 30 * Settings.get("scaling_factor") : root.height / 30 * Settings.get("scaling_factor")
    z: 50
    color: (state_handler.state === "locked") ? "#00000000" : "#6f000000"
    anchors {
        top: parent.top
    }
    MouseArea {
        anchors.fill: parent
    }

    Text {
        id: current_app_text
        visible: true
        color: "#ffffff"
        text: "Launcher"
        font.pixelSize: parent.height / 2
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: Settings.get("statusbar_screen_offset")
        }
    }
    Text {
        visible: (state_handler.state === "normal")
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
                right: (state_handler.state == "normal") ? clock.left : parent.right
                verticalCenter: parent.verticalCenter
                rightMargin: Settings.get("statusbar_screen_offset")
            }
            height: clock.height
            width: (root.width > root.height) ? root.height / 55 * Settings.get("scaling_factor") : root.width / 55 * Settings.get("scaling_factor")
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
