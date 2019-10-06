#include "_debug.h"
#include "application.h"
#include "lockmanager.h"
#include "mpvobject.h"
#include "tracksmodel.h"
#include "videoitem.h"
#include "videolist.h"
#include "videolistmodel.h"
#include "worker.h"

#include <QApplication>
#include <QCommandLineParser>
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QQuickStyle>
#include <QQuickView>
#include <QThread>

#include <KAboutData>

#include <memory>

int main(int argc, char *argv[])
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("georgefb");
    app.setOrganizationDomain("georgefb.com");

    KAboutData aboutData(
                QStringLiteral("haruna"),
                i18n("Haruna Video Player"),
                QStringLiteral("0.1.0"),
                i18n("A simple video player."),
                KAboutLicense::GPL_V3,
                i18n("(c) 2019"),
                i18n("TO DO..."),
                QStringLiteral("http://georgefb.com/haruna"),
                QStringLiteral("georgefb899@gmail.com"));

    aboutData.addAuthor(i18n("George Florea Bănuș"),
                        i18n("Developer"),
                        QStringLiteral("georgefb899@gmail.com"),
                        QStringLiteral("http://georgefb.com"));

    KAboutData::setApplicationData(aboutData);

    QCommandLineParser parser;
    aboutData.setupCommandLine(&parser);
    parser.addPositionalArgument(QStringLiteral("file"), i18n("Document to open"));
    parser.process(app);
    aboutData.processCommandLine(&parser);

    // Qt sets the locale in the QGuiApplication constructor, but libmpv
    // requires the LC_NUMERIC category to be set to "C", so change it back.
    std::setlocale(LC_NUMERIC, "C");

    qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");
    qmlRegisterInterface<QAction>("QAction");
    qmlRegisterInterface<TracksModel>("TracksModel");

    QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    QQuickStyle::setFallbackStyle(QStringLiteral("Fusion"));

    std::unique_ptr<Application> myApp = std::make_unique<Application>();
    std::unique_ptr<LockManager> lockManager = std::make_unique<LockManager>();

    for (auto i = 0; i < parser.positionalArguments().size(); ++i) {
        myApp->addArgument(i, parser.positionalArguments().at(i));
    }

    auto worker = Worker::instance();
    auto thread = new QThread();
    worker->moveToThread(thread);
    QObject::connect(thread, &QThread::finished,
                     worker, &Worker::deleteLater);
    QObject::connect(thread, &QThread::finished,
                     thread, &QThread::deleteLater);
    thread->start();

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    VideoList *videoList = new VideoList();
    engine.rootContext()->setContextProperty("videoList", videoList);
    qmlRegisterUncreatableType<VideoList>("VideoPlayList", 1, 0, "VideoList",
                                          QStringLiteral("VideoList should not be created in QML"));
    VideoListModel videoListModel(videoList);
    engine.rootContext()->setContextProperty("videoListModel", &videoListModel);
    qmlRegisterUncreatableType<VideoListModel>("VideoPlayList", 1, 0, "VideoListModel",
                                               QStringLiteral("VideoListModel should not be created in QML"));

    engine.rootContext()->setContextProperty(QStringLiteral("app"), myApp.release());
    qmlRegisterUncreatableType<Application>("Application", 1, 0, "Application",
                                            QStringLiteral("Application should not be created in QML"));

    engine.rootContext()->setContextProperty(QStringLiteral("lockManager"), lockManager.release());
    qmlRegisterUncreatableType<LockManager>("LockManager", 1, 0, "LockManager",
                                            QStringLiteral("LockManager should not be created in QML"));
    engine.load(url);
    return app.exec();
}

