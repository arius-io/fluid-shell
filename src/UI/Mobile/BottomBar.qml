import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import "../../utils/settings.js" as Settings

Rectangle {
    id: bottombar
    Component.onCompleted: {
        Settings.getDatabase()
    }
    width: root.width
    height: (root.width > root.height) ? root.width / 20 * Settings.get("scaling_factor") : root.height / 20 * Settings.get("scaling_factor")
    z: 50
    color: "#343232"
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
        Rectangle {
            id: screenshot_button
            height: parent.height / 2
            width: parent.height / 2
            color: "#e6ffffff"
            anchors {
                verticalCenter: parent.verticalCenter

            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    root.grabToImage(function(result) {
                        result.saveToFile("Screenshot "+ Qt.formatDateTime(new Date(), "dddd MMMM d") +" "+ Qt.formatTime(new Date(), "hh:mm:ss") +".png")
                    })
                }
            }
        }
    }
}
