import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import "../utils/settings.js" as Settings

Rectangle {
    id: bottombar
    Component.onCompleted: {
        Settings.getDatabase()
    }
    width: root.width
    height: (root.width > root.height) ? root.width / 20 * Settings.get("scaling_factor") : root.height / 20 * Settings.get("scaling_factor")
    z: 50
    color: "#000000"
    anchors {
        bottom: parent.bottom
    }
    Rectangle {
        height: parent.height
        width: parent.width / 3
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#00000000"
        Rectangle {
            id: home_button
            height: parent.height / 2
            width: parent.height / 2
            color: "#e6ffffff"
            radius: width*0.5
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    application_container.visible = false
                }
                onPressAndHold: {
                    console.log("multi task")
                }
            }
        }
    }
}
