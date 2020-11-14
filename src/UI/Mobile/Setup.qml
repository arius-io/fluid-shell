import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Controls 2.14
import "../../utils/settings.js" as Settings

Rectangle {
    color: "#ff3333"
    width: wayland_window.width
    height: wayland_window.height
    Text {
        text: "SETUP."
        color: "#6c6c6c"
        wrapMode: Text.WordWrap
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        anchors {
           horizontalCenter: parent.horizontalCenter
           verticalCenter: parent.verticalCenter
        }
    }
    Button {
        text: "Done."
        onClicked: {
            Settings.set("setup_done", "true")
            Settings.set("screen_width", 480)
            Settings.set("screen_height", 800)
            Settings.set("applications_per_row", 3)
            Settings.set("statusbar_screen_offset", 5)
            Settings.set("wallpaper_path", "file:///home/xyn/img1.jpg")
            Settings.set("default_colour", "#357cf0")
            Settings.set("scaling_factor", 1)
            state_handler.state = "locked"

        }
    }
}
