import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import "../../utils/settings.js" as Settings

Rectangle {
    id: bottombar
    Component.onCompleted: {
        Settings.getDatabase()
    }
    width: root.width
    height: (root.width > root.height) ? root.width / 40 * Settings.get("scaling_factor") : root.height / 40 * Settings.get("scaling_factor")
    z: 50
    color: "#000000"
    anchors {
        bottom: parent.bottom
    }
    MouseArea {
        anchors.fill: parent
    }

    Rectangle {
        id: home_button
        height: parent.height / 6
        width: parent.width / 6
        color: "#e6ffffff"
        radius: width*0.5
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            application_container.visible = false
            console.log("h")
        }
        onPressAndHold: {
            console.log("multi task")
        }
    }

}
