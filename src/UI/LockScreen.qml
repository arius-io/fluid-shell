import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import "../utils/utils.js" as Utils
import "../utils/settings.js" as Settings


Item {
    StatusBar {
        id: statusbar
    }
    Image {
        Component.onCompleted: {
            Settings.getDatabase()
            Utils.handle_battery_monitor(statusbar.battery_container, statusbar.battery_level)
        }
        id: lockscreen
        width: root.width
        height: root.height
        source: Settings.get("wallpaper_path")
        Text {
            id: clock
            color: "#000000"
            text: Qt.formatDateTime(new Date(), "HH:mm")
            Timer {
                repeat: true
                interval: 1000
                running: true
                onTriggered: {
                    parent.text = Qt.formatDateTime(new Date(), "HH:mm")
                }
            }
            font.pixelSize: parent.height / 10
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }
        MouseArea {
            id: lockscreen_mouse_area
            anchors.fill: parent
            drag.target: lockscreen
            drag.axis: Drag.YAxis
            drag.maximumY: 0
            onReleased: {
                if(lockscreen.y > -root.height / 2) {
                    bounce.restart()
                } else {
                    root.state_handler.state = "normal"
                    lockscreen.y = 0
                }
            }
        }
        NumberAnimation {
            id: bounce
            target: lockscreen
            properties: "y"
            to: 0
            easing.type: Easing.InOutQuad
            duration: 200
        }
    }
    Timer {
        repeat: true
        interval: 1000
        running: true
        onTriggered: {
            Utils.handle_battery_monitor(statusbar.battery_container, statusbar.battery_level)
        }
    }
}

