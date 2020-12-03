/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "_debug.h"
#include "application.h"
#include "haction.h"
#include "lockmanager.h"
#include "mpvobject.h"
#include "settings/audiosettings.h"
#include "settings/generalsettings.h"
#include "settings/mousesettings.h"
#include "settings/playbacksettings.h"
#include "settings/playlistsettings.h"
#include "settings/subtitlessettings.h"
#include "settings/videosettings.h"
#include "playlist/playlistitem.h"
#include "playlist/playlistmodel.h"
#include "subtitlesfoldersmodel.h"
#include "thumbnailimageprovider.h"
#include "tracksmodel.h"
#include "worker.h"

#include <QApplication>
#include <QCommandLineParser>
#include <QCoreApplication>
#include <QGuiApplication>
#include <QDir>
#include <QFileInfo>
#include <QPointer>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickItem>
#include <QQuickStyle>
#include <QQuickView>
#include <QStandardPaths>
#include <QThread>

#include <KAboutApplicationDialog>
#include <KAboutData>
#include <KColorSchemeManager>
#include <KConfig>
#include <KConfigGroup>
#include <KFileMetaData/Properties>
#include <KI18n/KLocalizedString>
#include <KLocalizedString>
#include <KShortcutsDialog>

static QApplication *createApplication(int &argc, char **argv, const QString &applicationName)
{
    QApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QApplication::setOrganizationName("georgefb");
    QApplication::setApplicationName(applicationName);
    QApplication::setOrganizationDomain("georgefb.com");
    QApplication::setApplicationDisplayName("Haruna - Video Player");
    QApplication::setApplicationVersion("0.3.1");
    QApplication::setWindowIcon(QIcon::fromTheme("com.georgefb.haruna"));

    QQuickStyle::setStyle(QStringLiteral("org.kde.desktop"));
    QQuickStyle::setFallbackStyle(QStringLiteral("Fusion"));

    QApplication *app = new QApplication(argc, argv);
    return app;
}

Application::Application(int &argc, char **argv, const QString &applicationName)
    : m_app(createApplication(argc, argv, applicationName))
    , m_collection(this)
{
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
    m_shortcuts = new KConfigGroup(m_config, "Shortcuts");
    m_schemes = new KColorSchemeManager(this);

    setupWorkerThread();

    // Qt sets the locale in the QGuiApplication constructor, but libmpv
    // requires the LC_NUMERIC category to be set to "C", so change it back.
    std::setlocale(LC_NUMERIC, "C");

    setupAboutData();
    setupCommandLineParser();
    registerQmlTypes();
    setupQmlSettingsTypes();

    m_engine = new QQmlApplicationEngine(this);
    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
    auto onObjectCreated = [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        }
    };
    QObject::connect(m_engine, &QQmlApplicationEngine::objectCreated,
                     m_app, onObjectCreated, Qt::QueuedConnection);
    m_engine->addImageProvider("thumbnail", new ThumbnailImageProvider());
    setupQmlContextProperties();
    m_engine->load(url);
}

Application::~Application()
{
    delete m_engine;
}

int Application::run()
{
    return m_app->exec();
}

void Application::setupWorkerThread()
{
    auto worker = Worker::instance();
    auto thread = new QThread();
    worker->moveToThread(thread);
    QObject::connect(thread, &QThread::finished,
                     worker, &Worker::deleteLater);
    QObject::connect(thread, &QThread::finished,
                     thread, &QThread::deleteLater);
    thread->start();
}

void Application::setupQmlSettingsTypes()
{
    qmlRegisterSingletonType<AudioSettings>("com.georgefb.haruna", 1, 0, "AudioSettings", &AudioSettings::provider);
    qmlRegisterSingletonType<GeneralSettings>("com.georgefb.haruna", 1, 0, "GeneralSettings", &GeneralSettings::provider);
    qmlRegisterSingletonType<MouseSettings>("com.georgefb.haruna", 1, 0, "MouseSettings", &MouseSettings::provider);
    qmlRegisterSingletonType<PlaybackSettings>("com.georgefb.haruna", 1, 0, "PlaybackSettings", &PlaybackSettings::provider);
    qmlRegisterSingletonType<PlaylistSettings>("com.georgefb.haruna", 1, 0, "PlaylistSettings", &PlaylistSettings::provider);
    qmlRegisterSingletonType<SubtitlesSettings>("com.georgefb.haruna", 1, 0, "SubtitlesSettings", &SubtitlesSettings::provider);
    qmlRegisterSingletonType<VideoSettings>("com.georgefb.haruna", 1, 0, "VideoSettings", &VideoSettings::provider);
}

void Application::setupQmlContextProperties()
{
    std::unique_ptr<LockManager> lockManager = std::make_unique<LockManager>();
    std::unique_ptr<SubtitlesFoldersModel> subsFoldersModel = std::make_unique<SubtitlesFoldersModel>();
    std::unique_ptr<PlayListModel> playListModel = std::make_unique<PlayListModel>();

    m_engine->rootContext()->setContextProperty("playListModel", playListModel.release());
    qmlRegisterUncreatableType<PlayListModel>("PlayListModel", 1, 0, "PlayListModel",
                                               QStringLiteral("PlayListModel should not be created in QML"));

    m_engine->rootContext()->setContextProperty(QStringLiteral("app"), this);
    qmlRegisterUncreatableType<Application>("Application", 1, 0, "Application",
                                            QStringLiteral("Application should not be created in QML"));

    m_engine->rootContext()->setContextProperty(QStringLiteral("lockManager"), lockManager.release());
    qmlRegisterUncreatableType<LockManager>("LockManager", 1, 0, "LockManager",
                                            QStringLiteral("LockManager should not be created in QML"));

    m_engine->rootContext()->setContextProperty(QStringLiteral("subsFoldersModel"), subsFoldersModel.release());
}

QString Application::formatTime(const double time)
{
    QTime t(0, 0, 0);
    QString formattedTime = t.addSecs(static_cast<qint64>(time)).toString("hh:mm:ss");
    return formattedTime;
}

QUrl Application::getPathFromArg(const QString &arg)
{
    return QUrl::fromUserInput(arg, QDir::currentPath());
}

void Application::hideCursor()
{
    QApplication::setOverrideCursor(Qt::BlankCursor);
}

void Application::showCursor()
{
    QApplication::setOverrideCursor(Qt::ArrowCursor);
}

QString Application::argument(int key)
{
    return m_args[key];
}

void Application::addArgument(int key, const QString &value)
{
    m_args.insert(key, value);
}

QAction *Application::action(const QString &name)
{
    auto resultAction = m_collection.action(name);

    if (!resultAction) {
        setupActions(name);
        resultAction = m_collection.action(name);
    }

    return resultAction;
}

QString Application::getFileContent(QString file)
{
    QFile f(file);
    f.open(QIODevice::ReadOnly);
    QString content = f.readAll();
    f.close();
    return content;
}

QAbstractItemModel *Application::colorSchemesModel()
{
    return m_schemes->model();
}

void Application::registerQmlTypes()
{
    qmlRegisterType<MpvObject>("mpv", 1, 0, "MpvObject");
    qRegisterMetaType<QAction*>();
    qRegisterMetaType<TracksModel*>();
    qRegisterMetaType<KFileMetaData::PropertyMap>("KFileMetaData::PropertyMap");

}

void Application::activateColorScheme(const QString &name)
{
    m_schemes->activateScheme(m_schemes->indexForScheme(name));
}

void Application::configureShortcuts()
{
    KShortcutsDialog dlg(KShortcutsEditor::ApplicationAction, KShortcutsEditor::LetterShortcutsAllowed, nullptr);
    connect(&dlg, &KShortcutsDialog::accepted, this, [ = ](){
        m_collection.writeSettings(m_shortcuts);
        m_config->sync();
    });
    dlg.setModal(true);
    dlg.addCollection(&m_collection);
    dlg.configure(false);
}

void Application::aboutApplication()
{
    static QPointer<QDialog> dialog;
    if (!dialog) {
        dialog = new KAboutApplicationDialog(KAboutData::applicationData(), nullptr);
        dialog->setAttribute(Qt::WA_DeleteOnClose);
    }
    dialog->show();
}

void Application::setupAboutData()
{
    m_aboutData = KAboutData(QStringLiteral("haruna"),
                         i18n("Haruna Video Player"),
                         QStringLiteral("0.2.2"));
    m_aboutData.setShortDescription(i18n("A simple video player."));
    m_aboutData.setLicense(KAboutLicense::GPL_V3);
    m_aboutData.setCopyrightStatement(i18n("(c) 2019"));
    m_aboutData.setOtherText(i18n("TO DO..."));
    m_aboutData.setHomepage(QStringLiteral("https://github.com/g-fb/haruna"));
    m_aboutData.setBugAddress(QStringLiteral("https://github.com/g-fb/haruna/issues").toUtf8());

    m_aboutData.addAuthor(i18n("George Florea Bănuș"),
                        i18n("Developer"),
                        QStringLiteral("georgefb899@gmail.com"),
                        QStringLiteral("https://georgefb.com"));

    KAboutData::setApplicationData(m_aboutData);

}

void Application::setupCommandLineParser()
{
    QCommandLineParser parser;
    m_aboutData.setupCommandLine(&parser);
    parser.addPositionalArgument(QStringLiteral("file"), i18n("File to open"));
    parser.process(*m_app);
    m_aboutData.processCommandLine(&parser);

    for (auto i = 0; i < parser.positionalArguments().size(); ++i) {
        addArgument(i, parser.positionalArguments().at(i));
    }

}

void Application::setupActions(const QString &actionName)
{
    if (actionName == QStringLiteral("screenshot")) {
        auto action = new HAction();
        action->setText(i18n("Screenshot"));
        action->setIcon(QIcon::fromTheme("image-x-generic"));
        m_collection.setDefaultShortcut(action, Qt::Key_S);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("file_quit")) {
        auto action = new HAction();
        action->setText(i18n("Quit"));
        action->setIcon(QIcon::fromTheme("application-exit"));
        connect(action, &QAction::triggered, m_app, &QApplication::quit);
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Q);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("options_configure_keybinding")) {
        auto action = new HAction();
        action->setText(i18n("Configure Keyboard Shortcuts"));
        action->setIcon(QIcon::fromTheme("configure-shortcuts"));
        connect(action, &QAction::triggered, this, &Application::configureShortcuts);
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::SHIFT + Qt::Key_S);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("configure")) {
        auto action = new HAction();
        action->setText(i18n("Configure"));
        action->setIcon(QIcon::fromTheme("configure"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::SHIFT + Qt::Key_Comma);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("togglePlaylist")) {
        auto action = new HAction();
        action->setText(i18n("Toggle Playlist"));
        action->setIcon(QIcon::fromTheme("view-media-playlist"));
        m_collection.setDefaultShortcut(action, Qt::Key_P);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("openContextMenu")) {
        auto action = new HAction();
        action->setText(i18n("Open Context Menu"));
        action->setIcon(QIcon::fromTheme("application-menu"));
        m_collection.setDefaultShortcut(action, Qt::Key_Menu);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("toggleFullscreen")) {
        auto action = new HAction();
        action->setText(i18n("Toggle Fullscreen"));
        action->setIcon(QIcon::fromTheme("view-fullscreen"));
        m_collection.setDefaultShortcut(action, Qt::Key_F);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("openFile")) {
        auto action = new HAction();
        action->setText(i18n("Open File"));
        action->setIcon(QIcon::fromTheme("folder-videos-symbolic"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_O);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("openUrl")) {
        auto action = new HAction();
        action->setText(i18n("Open Url"));
        action->setIcon(QIcon::fromTheme("internet-services"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::SHIFT + Qt::Key_O);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("aboutHaruna")) {
        auto action = new HAction();
        action->setText(i18n("About Haruna"));
        action->setIcon(QIcon::fromTheme("help-about-symbolic"));
        m_collection.setDefaultShortcut(action, Qt::Key_F1);
        m_collection.addAction(actionName, action);
        connect(action, &QAction::triggered, this, &Application::aboutApplication);
    }

    // mpv actions
    if (actionName == QStringLiteral("contrastUp")) {
        auto action = new HAction();
        action->setText(i18n("Contrast Up"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_1);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("contrastDown")) {
        auto action = new HAction();
        action->setText(i18n("Contrast Down"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_2);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("contrastReset")) {
        auto action = new HAction();
        action->setText(i18n("Contrast Reset"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_1);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("brightnessUp")) {
        auto action = new HAction();
        action->setText(i18n("Brightness Up"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_3);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("brightnessDown")) {
        auto action = new HAction();
        action->setText(i18n("Brightness Down"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_4);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("brightnessReset")) {
        auto action = new HAction();
        action->setText(i18n("Brightness Reset"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_3);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("gammaUp")) {
        auto action = new HAction();
        action->setText(i18n("Gamma Up"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_5);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("gammaDown")) {
        auto action = new HAction();
        action->setText(i18n("Gamma Down"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_6);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("gammaReset")) {
        auto action = new HAction();
        action->setText(i18n("Gamma Reset"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_5);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("saturationUp")) {
        auto action = new HAction();
        action->setText(i18n("Saturation Up"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_7);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("saturationDown")) {
        auto action = new HAction();
        action->setText(i18n("Saturation Down"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::Key_8);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("saturationReset")) {
        auto action = new HAction();
        action->setText(i18n("Saturation Reset"));
        action->setIcon(QIcon::fromTheme("contrast"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_7);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("playNext")) {
        auto action = new HAction();
        action->setText(i18n("Play Next"));
        action->setIcon(QIcon::fromTheme("media-skip-forward"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_Period);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("playPrevious")) {
        auto action = new HAction();
        action->setText(i18n("Play Previous"));
        action->setIcon(QIcon::fromTheme("media-skip-backward"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_Comma);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("volumeUp")) {
        auto action = new HAction();
        action->setText(i18n("Volume Up"));
        action->setIcon(QIcon::fromTheme("audio-volume-high"));
        m_collection.setDefaultShortcut(action, Qt::Key_9);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("volumeDown")) {
        auto action = new HAction();
        action->setText(i18n("Volume Down"));
        action->setIcon(QIcon::fromTheme("audio-volume-low"));
        m_collection.setDefaultShortcut(action, Qt::Key_0);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("mute")) {
        auto action = new HAction();
        action->setText(i18n("Mute"));
        action->setIcon(QIcon::fromTheme("player-volume"));
        m_collection.setDefaultShortcut(action, Qt::Key_M);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekForwardSmall")) {
        auto action = new HAction();
        action->setText(i18n("Seek Small Step Forward"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekBackwardSmall")) {
        auto action = new HAction();
        action->setText(i18n("Seek Small Step Backward"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekForwardMedium")) {
        auto action = new HAction();
        action->setText(i18n("Seek Medium Step Forward"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekBackwardMedium")) {
        auto action = new HAction();
        action->setText(i18n("Seek Medium Step Backward"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekForwardBig")) {
        auto action = new HAction();
        action->setText(i18n("Seek Big Step Forward"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Up);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekBackwardBig")) {
        auto action = new HAction();
        action->setText(i18n("Seek Big Step Backward"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Down);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekPreviousChapter")) {
        auto action = new HAction();
        action->setText(i18n("Seek Previous Chapter"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::Key_PageDown);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekNextChapter")) {
        auto action = new HAction();
        action->setText(i18n("Seek Next Chapter"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::Key_PageUp);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekNextSubtitle")) {
        auto action = new HAction();
        action->setText(i18n("Seek To Next Subtitle"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekPreviousSubtitle")) {
        auto action = new HAction();
        action->setText(i18n("Seek To Previous Subtitle"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("frameStep")) {
        auto action = new HAction();
        action->setText(i18n("Move one frame forward, then pause"));
        m_collection.setDefaultShortcut(action, Qt::Key_Period);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("frameBackStep")) {
        auto action = new HAction();
        action->setText(i18n("Move one frame backward, then pause"));
        m_collection.setDefaultShortcut(action, Qt::Key_Comma);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("increasePlayBackSpeed")) {
        auto action = new HAction();
        action->setText(i18n("Playback speed increase"));
        m_collection.setDefaultShortcut(action, Qt::Key_BracketRight);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("decreasePlayBackSpeed")) {
        auto action = new HAction();
        action->setText(i18n("Playback speed decrease"));
        m_collection.setDefaultShortcut(action, Qt::Key_BracketLeft);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("resetPlayBackSpeed")) {
        auto action = new HAction();
        action->setText(i18n("Playback speed reset"));
        m_collection.setDefaultShortcut(action, Qt::Key_Backspace);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitleQuicken")) {
        auto action = new HAction();
        action->setText(i18n("Subtitle Quicken"));
        m_collection.setDefaultShortcut(action, Qt::Key_Z);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitleDelay")) {
        auto action = new HAction();
        action->setText(i18n("Subtitle Delay"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_Z);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitleToggle")) {
        auto action = new HAction();
        action->setText(i18n("Subtitle Toggle"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_S);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("audioCycleUp")) {
        auto action = new HAction();
        action->setText(i18n("Cycle Audio Up"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_3);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("audioCycleDown")) {
        auto action = new HAction();
        action->setText(i18n("Cycle Audio Down"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_2);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitleCycleUp")) {
        auto action = new HAction();
        action->setText(i18n("Cycle Subtitle Up"));
        m_collection.setDefaultShortcut(action, Qt::Key_J);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitleCycleDown")) {
        auto action = new HAction();
        action->setText(i18n("Cycle Subtitle Down"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_J);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("zoomIn")) {
        auto action = new HAction();
        action->setText(i18n("Zoom In"));
        action->setIcon(QIcon::fromTheme("zoom-in"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Plus);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("zoomOut")) {
        auto action = new HAction();
        action->setText(i18n("Zoom Out"));
        action->setIcon(QIcon::fromTheme("zoom-out"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Minus);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("zoomReset")) {
        auto action = new HAction();
        action->setText(i18n("Zoom Reset"));
        action->setIcon(QIcon::fromTheme("zoom-original"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Backspace);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("videoPanXLeft")) {
        auto action = new HAction();
        action->setText(i18n("Video pan x left"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("videoPanXRight")) {
        auto action = new HAction();
        action->setText(i18n("Video pan x right"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("videoPanYUp")) {
        auto action = new HAction();
        action->setText(i18n("Video pan y up"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Up);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("videoPanYDown")) {
        auto action = new HAction();
        action->setText(i18n("Video pan y down"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Down);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("toggleMenuBar")) {
        auto action = new HAction();
        action->setText(i18n("Toggle Menu Bar"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_M);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("toggleHeader")) {
        auto action = new HAction();
        action->setText(i18n("Toggle Header"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_H);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("setLoop")) {
        auto action = new HAction();
        action->setText(i18n("Set Loop"));
        m_collection.setDefaultShortcut(action, Qt::Key_L);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("increaseSubtitleFontSize")) {
        auto action = new HAction();
        action->setText(i18n("Increase Subtitle Font Size"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Z);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("decreaseSubtitleFontSize")) {
        auto action = new HAction();
        action->setText(i18n("Decrease Subtitle Font Size"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_X);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitlePositionUp")) {
        auto action = new HAction();
        action->setText(i18n("Move Subtitle Up"));
        m_collection.setDefaultShortcut(action, Qt::Key_R);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("subtitlePositionDown")) {
        auto action = new HAction();
        action->setText(i18n("Move Subtitle Down"));
        m_collection.setDefaultShortcut(action, Qt::SHIFT + Qt::Key_R);
        m_collection.addAction(actionName, action);
    }
    m_collection.readSettings(m_shortcuts);
}
