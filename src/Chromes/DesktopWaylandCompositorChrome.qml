import QtQuick 2.14
import QtWayland.Compositor 1.14
import QtQuick.Window 2.14
import "../UI/Desktop"
import "../utils/settings.js" as Settings

WaylandCompositor {
    id: desktop
    WaylandOutput {
        window: Window {
            Component.onCompleted: {
                Settings.getDatabase()
            }
            visible: true
            title: qsTr("Fluid Shell - Desktop Screen")
            width: 1280
            height: 720
            id: wayland_desktop
            Desktop_Screen {
                id: desktop_screen
            }
        }
    }
    XdgShell {
        onToplevelCreated: {
            shellSurfaces_desktop.append({
                shellSurface: xdgSurface
            })
        }
    }
    ListModel {
        id: shellSurfaces_desktop
    }
}
