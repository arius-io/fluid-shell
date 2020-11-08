/*
add in ~/.config/gtk-3.0/gtk.css

decoration {
    border-width: 0px;
    box-shadow: none;
    margin: 0px;
}

I HATE GTK 3 DROP SHADOW BTW

*/

import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.LocalStorage 2.14
import QtQuick.Layouts 1.14
import QtWayland.Compositor 1.14
import Liri.XWayland 1.0 as LXW
import "utils/settings.js" as Settings
import "utils/utils.js" as Utils
import "UI/Mobile"
import "UI/Desktop"

Item {
    WaylandCompositor {
        id: wayland_compositor
        WaylandOutput {
            window: Window {
                Component.onCompleted: {
                    Settings.getDatabase()
                    //xwayland.startServer()
                }
                visible: true
                title: qsTr("Fluid Shell - Phone Screen")
                width: Settings.get("screen_width")
                height: Settings.get("screen_height")
                id: wayland_window
                Screen {
                    id: root
                }
            }
        }
        XdgShell {
            onToplevelCreated: {
                shellSurfaces.append({
                    shellSurface: xdgSurface
                })
                toplevel.sendResizing(Qt.size(root.width, root.height - root.statusbar.height - root.bottombar.height))
            }
            onPopupCreated: {
                shellSurfaces.append({
                    shellSurface: xdgSurface
                })
                popup.sendConfigure(popup.parentXdgSurface.windowGeometry)
            }
        }

        /*LXW.XWayland {
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
                    shellSurface.sendResize(Qt.size(480, 800));
                }
            }
            Component {
                id: shellSurfaceComponent
                LXW.XWaylandShellSurface {}
            }
        }*/
        XdgDecorationManagerV1 {
            preferredMode: XdgToplevel.ServerSideDecoration
        }
        ListModel {
            id: shellSurfaces
        }
    }
    /*Loader {
        source: (root.state_handler.state == "convergence") ? "Chromes/DesktopWaylandCompositorChrome.qml" : ""
    }*/
}
