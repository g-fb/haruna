#include "_debug.h"
#include "application.h"
#include "settings.h"

#include <QApplication>
#include <QAction>
#include <QCoreApplication>
#include <QDir>
#include <QFileInfo>
#include <QStandardPaths>

#include <KConfig>
#include <KConfigDialog>
#include <KConfigGroup>
#include <KLocalizedString>
#include <KShortcutsDialog>

Application::Application(QObject *parent)
    : m_collection(parent)
    , m_settingsWidget(new SettingsWidget(nullptr))
{
    Q_UNUSED(parent)

    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
    m_shortcuts = new KConfigGroup(m_config, "Shortcuts");

    m_settingsDialog = new KConfigDialog(
             nullptr, "settings", HarunaSettings::self());
    m_settingsDialog->setMinimumSize(700, 600);
    m_settingsDialog->setFaceType(KPageDialog::Plain);
    m_settingsDialog->addPage(m_settingsWidget, i18n("Settings"));
}

QString Application::argument(int key)
{
    return args[key];
}

void Application::addArgument(int key, QString value)
{
    args.insert(key, value);
}

QString Application::getPathFromArg(QString arg)
{
    return QUrl::fromUserInput(arg, QDir::currentPath()).toLocalFile();
}

QVariant Application::setting(const QString group, const QString key)
{
    return m_config->group("General").readEntry(key);
}

void Application::setSetting(const QString group, const QString key, const QString value)
{
    m_config->group(group).writeEntry(key, value);
    m_config->sync();
}

QVariant Application::pathSetting(const QString group, const QString key)
{
    return m_config->group("General").readPathEntry(key, QStringList());
}

void Application::setPathSetting(const QString group, const QString key, const QString value)
{
    m_config->group(group).writePathEntry(key, value);
    m_config->sync();
}

void Application::openSettingsDialog()
{
    m_settingsDialog->show();
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

QString Application::iconName(const QIcon &icon)
{
    return icon.name();
}

void Application::configureShortcuts()
{
    KShortcutsDialog dlg(KShortcutsEditor::AllActions, KShortcutsEditor::LetterShortcutsAllowed, nullptr);
    connect(&dlg, &KShortcutsDialog::accepted, this, [ = ](){
        m_collection.writeSettings(m_shortcuts);
        m_config->sync();
    });
    dlg.setModal(true);
    dlg.addCollection(&m_collection);
    dlg.configure(false);
}

void Application::hideCursor()
{
    QApplication::setOverrideCursor(Qt::BlankCursor);
}

void Application::showCursor()
{
    QApplication::setOverrideCursor(Qt::ArrowCursor);
}

void Application::setupActions(const QString &actionName)
{
    if (actionName == QStringLiteral("file_quit")) {
        auto action = KStandardAction::quit(QCoreApplication::instance(), &QCoreApplication::quit, &m_collection);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("options_configure_keybinding")) {
        auto action = KStandardAction::keyBindings(this, &Application::configureShortcuts, &m_collection);
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_S);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("configure")) {
        auto action = KStandardAction::preferences(this, &Application::openSettingsDialog, &m_collection);
        m_collection.addAction(actionName, action);
    }

    if (actionName == QStringLiteral("openUrl")) {
        QAction *action = new QAction();
        action->setText(i18n("Open Url"));
        action->setIcon(QIcon::fromTheme("internet-services"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::SHIFT + Qt::Key_O);
        m_collection.addAction(actionName, action);
    }

    // mpv actions
    if (actionName == QStringLiteral("playNext")) {
        QAction *action = new QAction();
        action->setText(i18n("Play Next"));
        action->setIcon(QIcon::fromTheme("media-skip-forward"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("playPrevious")) {
        QAction *action = new QAction();
        action->setText(i18n("Play Previous"));
        action->setIcon(QIcon::fromTheme("media-skip-backward"));
        m_collection.setDefaultShortcut(action, Qt::ALT + Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("mute")) {
        QAction *action = new QAction();
        action->setText(i18n("Mute"));
        action->setIcon(QIcon::fromTheme("player-volume"));
        m_collection.setDefaultShortcut(action, Qt::Key_M);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekForward")) {
        QAction *action = new QAction();
        action->setText(i18n("Seek Forward"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekBackward")) {
        QAction *action = new QAction();
        action->setText(i18n("Seek Backward"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekNextSubtitle")) {
        QAction *action = new QAction();
        action->setText(i18n("Seek To Next Subtitle"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Right);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("seekPreviousSubtitle")) {
        QAction *action = new QAction();
        action->setText(i18n("Seek To Previous Subtitle"));
        action->setIcon(QIcon::fromTheme("media-seek-backward"));
        m_collection.setDefaultShortcut(action, Qt::CTRL + Qt::Key_Left);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("frameStep")) {
        QAction *action = new QAction();
        action->setText(i18n("Move one frame forward, then pause"));
        m_collection.setDefaultShortcut(action, Qt::Key_Period);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("frameBackStep")) {
        QAction *action = new QAction();
        action->setText(i18n("Move one frame backward, then pause"));
        m_collection.setDefaultShortcut(action, Qt::Key_Comma);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("increasePlayBackSpeed")) {
        QAction *action = new QAction();
        action->setText(i18n("Playback speed increase"));
        m_collection.setDefaultShortcut(action, Qt::Key_BracketRight);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("decreasePlayBackSpeed")) {
        QAction *action = new QAction();
        action->setText(i18n("Playback speed decrease"));
        m_collection.setDefaultShortcut(action, Qt::Key_BracketLeft);
        m_collection.addAction(actionName, action);
    }
    if (actionName == QStringLiteral("resetPlayBackSpeed")) {
        QAction *action = new QAction();
        action->setText(i18n("Playback speed reset"));
        m_collection.setDefaultShortcut(action, Qt::Key_Backspace);
        m_collection.addAction(actionName, action);
    }
    m_collection.readSettings(m_shortcuts);
}
