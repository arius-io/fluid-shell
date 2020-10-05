import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Layouts 1.14

import "utils/settings.js" as Settings
import "utils/utils.js" as Utils
import "UI"

Window {
    property var appPages: []
    Component.onCompleted: {
        Settings.getDatabase()
        //hacked up "OOTB" just for testing
        if (!Settings.get("OOTB_run")) {
            Settings.set("OOTB_run", true)
            Settings.set("screen_width", 480)
            Settings.set("screen_height", 800)
            Settings.set("applications_per_row", 3)
            Settings.set("statusbar_screen_offset", 5)
            Settings.set("wallpaper_path", "file:///home/xyn/img1.jpg")
            Settings.set("margin_padding", 5)
            Settings.set("default_colour", "357cf0")
        }
    }
    id: root
    width: Settings.get("screen_width")
    height: Settings.get("screen_height")
    visible: true
    title: qsTr("Fluid Shell")
    Image {
        width: root.width
        height: root.height
        source: Settings.get("wallpaper_path")
        Component.onCompleted: {
            Utils.application_list_refresh(application_list)
        }

        StatusBar {
            id: statusbar
        }

        GridView {
            id: application_list
            x: Settings.get("margin_padding")
            width: parent.width - Settings.get("margin_padding")
            height: parent.height - statusbar.height - Settings.get("margin_padding")
            model: appPages[0].length
            cellWidth: (parent.width - Settings.get("margin_padding")) / Settings.get("applications_per_row")
            cellHeight: (parent.width - Settings.get("margin_padding")) / Settings.get("applications_per_row")
            focus: true
            anchors {
                bottom: parent.bottom
            }
            delegate: Item {
                Column {
                    id: app_rectangle
                    Rectangle {
                        color: "#6e" + Settings.get("default_colour")
                        width: application_list.cellWidth - Settings.get("margin_padding")
                        height: application_list.cellHeight - Settings.get("margin_padding")
                        anchors.horizontalCenter: parent.horizontalCenter
                        Image {
                            width: app_rectangle.height / 2.5
                            height: app_rectangle.height / 2.5
                            id: application_icon
                            y: 20
                            source: "image://icons/" + appPages[0][index][1]
                            anchors {
                                horizontalCenter: parent.horizontalCenter
                                verticalCenter: parent.verticalCenter
                                bottom: application_icon.top
                            }
                        }
                        Text {
                            font.pixelSize: parent.height / 10
                            text: appPages[0][index][0]
                            color:"#ffffff"
                            anchors {
                                bottom: parent.bottom
                                bottomMargin: Settings.get("margin_padding")
                                leftMargin: Settings.get("margin_padding")
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
                       Timer {
                           repeat: true
                           interval: 1000
                           running: true
                           onTriggered: {
                               Utils.handle_battery_monitor(statusbar.battery_container, statusbar.battery_level)
                           }
                       }
                       Item {
                           id: state_handler
                           state: "locked"
                           states: [
                               State {
                                   name: "locked"
                               },
                               State {
                                   name: "AOD"
                               },
                               State {
                                   name: "normal"
                               },
                               State {
                                   name: "multitasking"
                               }
                           ]
                       }

    }
}
