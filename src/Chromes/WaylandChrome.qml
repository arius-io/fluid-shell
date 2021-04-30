import QtQuick 2.14
import QtWayland.Compositor 1.14

ShellSurfaceItem {
    anchors {
        top: parent.top
        left: parent.left
    }
    sizeFollowsSurface: false
    shellSurface: modelData
    onSurfaceDestroyed: shellSurfaces.remove(index)
    visible: true
    autoCreatePopupItems: true

}

