## Fluid Shell

QML-based Wayland Compostor for low-end Linux Devices such as [testing PostmarketOS ports](https://wiki.postmarketos.org/wiki/Devices).

### Features
* Low RAM usage
* Framebuffer support

### Dependencies
* [Qt 5.14](download.qt.io/official_releases/qt/5.14)
* [cmake-shared](https://github.com/lirios/cmake-shared)
* [qml-xwayland](https://github.com/lirios/qml-xwayland)

### Build instructions
```
$ mkdir build
$ cd build
$ qmake-qt5 ../src
$ make
```
