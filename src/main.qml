import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Layouts 1.14
import QtWayland.Compositor 1.14
import Liri.XWayland 1.0 as LXW

import "utils/settings.js" as Settings
import "utils/utils.js" as Utils
import "UI"

WaylandCompositor {
    id: wayland_compositor
    property var screen_width: root.width
    property var screen_height: root.height - root.statusbar.height - root.bottombar.height
    WaylandOutput {
        window: Window {
            Component.onCompleted: {
                Settings.getDatabase()
                xwayland.startServer()
            }
            visible: true
            title: qsTr("Fluid Shell")
            width: Settings.get("screen_width")
            height: Settings.get("screen_height")
            id: wayland_window
            Screen {
                id: root
            }
        }
    }

    XdgShellV6 {
        onToplevelCreated: {
            shellSurfaces.append({
                shellSurface: xdgSurface
            })
            toplevel.sendMaximized(Qt.size(screen_width, screen_height))
        }
    }
    XdgShell {
        onToplevelCreated: {
            shellSurfaces.append({
                shellSurface: xdgSurface
            })
            console.log(toplevel.parentToplevel)
            toplevel.sendMaximized(Qt.size(screen_width, screen_height))
        }
        onPopupCreated: {
            shellSurfaces.append({
                shellSurface: xdgSurface
            })
            popup.sendConfigure(popup.parentXdgSurface.windowGeometry)
        }
    }

    LXW.XWayland {
        id: xwayland
        enabled: true
        manager: LXW.XWaylandManager {
            id: manager
            onShellSurfaceRequested: {
                var shellSurface = shellSurfaceComponent.createObject(manager);
                shellSurface.initialize(manager, window, geometry, overrideRedirect, parentShellSurface);
            }
            onShellSurfaceCreated: {
                shellSurfaces.append({
                    shellSurface: shellSurface
                })
                shellSurface.sendResize(Qt.size(screen_width, screen_height));
            }
        }
        Component {
            id: shellSurfaceComponent
            LXW.XWaylandShellSurface {}
        }
    }
    XdgDecorationManagerV1 {
        preferredMode: XdgToplevel.ServerSideDecoration
    }
    ListModel {
        id: shellSurfaces
    }
    TextInputManager {}
}

