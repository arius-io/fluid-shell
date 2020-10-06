//very basic AOD implentation
import QtQuick 2.14

Rectangle {
    width: root.width
    height: root.height
    color: "#000000"
    Text {
        id: clock
        color: "#454545"
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
        anchors.fill: parent
        onClicked: root.state_handler.state = "locked"
    }
}
