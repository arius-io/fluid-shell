import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtGraphicalEffects 1.14
import "../utils/settings.js" as Settings
import "../utils/utils.js" as Utils
import "../UI"

Rectangle {
    property var appPages: []
    property int margin_padding: root.height / (50 * Settings.get("applications_per_row"))
    property alias statusbar: statusbar
    property alias bottombar: bottombar
    Component.onCompleted: {
        Settings.getDatabase()
        Utils.handle_battery_monitor(statusbar.battery_container, statusbar.battery_level)
    }
    id: root
    width: wayland_window.width
    height: wayland_window.height
    visible: true
    LockScreen {
        id: lockscreen
        width: root.width
        height: root.height
        visible: (state_handler.state === "locked")
    }
    Rectangle {
        width: root.width
        height: root.height
        visible: (state_handler.state === "convergence")
        color: "#363535"
        Text {
            text: "Convergence mode running. Press anywhere or undock your device to exit."
            color: "#6c6c6c"
            font.pointSize: parent.height / 30
            wrapMode: Text.WordWrap
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            anchors {
               horizontalCenter: parent.horizontalCenter
               verticalCenter: parent.verticalCenter
            }
        }
    }
    Image {
        width: root.width
        height: root.height
        visible: (state_handler.state === "normal")
        source: Settings.get("wallpaper_path")
        Component.onCompleted: {
            Utils.application_list_refresh(application_list)
        }
        StatusBar {
            id: statusbar
        }
        Page {
            visible: (shellSurfaces.count > 0) ? true : false
            id: application_container
            width: parent.width
            height: parent.height - statusbar.height - bottombar.height
            y: statusbar.height
            z: (application_container.visible == true) ? 200 : 0
            StackLayout {
                id: application_display
                anchors.fill: parent
                Repeater {
                    id: application_repeater
                    model: shellSurfaces
                    delegate: Loader {
                        source: (modelData.toString().match(/XWaylandShellSurface/)) ? "../../Chromes/XWaylandChrome.qml" : "../../Chromes/WaylandChrome.qml"
                        Component.onCompleted: {
                            application_display.currentIndex = application_display.count - 1
                            application_container.visible = true
                        }
                        Component.onDestruction: {
                            application_display.currentIndex--
                            if(!shellSurfaces.count > 0) {
                                application_container.visible = false
                            }
                        }
                    }
                }
            }

        }
        SwipeView {
            id: screen_swipe_view
            currentIndex: 0
            anchors.fill: parent
        }

        GridView {
            id: application_list
            x: margin_padding
            width: parent.width - margin_padding
            height: parent.height - statusbar.height - margin_padding - bottombar.height
            model: appPages[0].length
            cellWidth: (parent.width - margin_padding) / Settings.get("applications_per_row")
            cellHeight: (parent.width - margin_padding) / Settings.get("applications_per_row")
            focus: true
            anchors {
                top: statusbar.bottom
                topMargin: margin_padding
            }

            delegate: Item {
                Column {
                    id: app_rectangle
                    Rectangle {
                        color: "#00000000"
                        width: application_list.cellWidth - margin_padding
                        height: application_list.cellHeight - margin_padding
                        anchors.horizontalCenter: parent.horizontalCenter

                        Image {
                            width: app_rectangle.height / 2.5 * Settings.get("scaling_factor")
                            height: app_rectangle.height / 2.5 * Settings.get("scaling_factor")
                            id: application_icon
                            y: 20
                            source: "image://icons/" + appPages[0][index][1]
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                            }
                        }
                        Text {
                            font.pixelSize: parent.height / 10 * Settings.get("scaling_factor")
                            text: appPages[0][index][0]
                            color: "#ffffff"
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: margin_padding
                                leftMargin: margin_padding
                                left: parent.left
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                proc.start(appPages[0][index][2])
                            }
                        }
                    }
                }
            }
        }
        BottomBar {
            id: bottombar
        }
        //battery handler timer
        //TODO better "battery path" handler
        //TODO better battery indicator implementation
        Timer {
            repeat: true
            interval: 1000
            running: true
            onTriggered: {
                Utils.handle_battery_monitor(statusbar.battery_container, statusbar.battery_level)
            }
        }

    }
}
