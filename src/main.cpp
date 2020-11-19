#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QImage>
#include <QProcess>
#include <QDebug>
#include <QDir>
#include <QFile>
#include <QVariantMap>
#include <QIcon>
#include <QScreen>
#include <QQuickWindow>
#include "image_provider.h"
#include "process.h"
#include "battery_handler.h"

struct AppInfo {
    QString name;
    QString icon = "application";
    QString exec;
};


QVariantList apps() {
    QVariantList apps;

    QDir dir("/usr/share/applications");
    foreach (auto fn, dir.entryList(QStringList() << "*.desktop", QDir::Files)) {
       // qDebug() << "Reading" << dir.filePath(fn);
        QFile file(dir.filePath(fn));
        if (file.open(QIODevice::ReadOnly)) {
            QTextStream in(&file);
            AppInfo app;
            bool foundDesktopEntry = false;
            while (!in.atEnd()) {
                QString line = in.readLine();
                if (line.trimmed().isEmpty()){
                    continue;
                }
                if (!foundDesktopEntry) {
                    if (line.contains("[Desktop Entry]"))
                        foundDesktopEntry = true;
                    continue;
                }
                else if (line.startsWith('[') && line.endsWith(']')) {
                    break;
                }
                QStringList values = line.split("=");
                QString name = values.takeFirst();
                QString value = QString(values.join('='));
                if (name == "Name") {
                    if (value.length() > 16){
                         QString short_value = value.mid(0,16);
                         short_value.append("...");
                         app.name = short_value;
                    } else {
                        app.name = value;
                    }
                }
                if (name == "Icon") {
                    app.icon = value;
                    QIcon icon = QIcon::fromTheme(app.icon);
                }

                if (name == "Exec") {
                    app.exec = value.remove("\"").remove(QRegExp(" %."));
                }
            }
            apps.append(QStringList() << app.name << app.icon << app.exec);
        }
    }
    return apps;
}


int main(int argc, char *argv[]) {
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);



    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    engine.setOfflineStoragePath(QDir::homePath() + "/.fluid/");
    engine.addImageProvider("icons", new ImageProvider());
    auto offlineStoragePath = QUrl::fromLocalFile(engine.offlineStoragePath());
    engine.rootContext()->setContextProperty("offlineStoragePath", offlineStoragePath);
    engine.rootContext()->setContextProperty("apps", apps());
    engine.rootContext()->setContextProperty("proc", new Process(&engine));
    engine.rootContext()->setContextProperty("battery_handler", new battery_handler());

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);
    return app.exec();
}
