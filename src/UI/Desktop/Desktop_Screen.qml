import QtQuick 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.14
import QtWayland.Compositor 1.14
import "../../utils/settings.js" as Settings
import "../../utils/utils.js" as Utils
import "../../UI"

Rectangle {
    width: 1280
    height: 720
    color: "#363535"
    id: desktop_root
    Image {
        width: parent.width
        height: parent.height
        source: "http://binghomepagewallpapers.x10host.com/images/random/HaystackRock_1920x1200.jpg"
    }
    Repeater {
        model: shellSurfaces_desktop
        ShellSurfaceItem {
            autoCreatePopupItems: true
            shellSurface: modelData
            onSurfaceDestroyed: shellSurfaces_desktop.remove(index)
        }
    }
    Desktop_BottomBar {
        id: bottombar
    }
}
