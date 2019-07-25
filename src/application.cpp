#include "_debug.h"
#include "application.h"
#include "settings.h"

#include <QApplication>
#include <QAction>
#include <QCoreApplication>
#include <QStandardPaths>
#include <KConfig>
#include <KLocalizedString>
#include <KShortcutsDialog>

Application::Application(QObject *parent)
    : m_collection(parent)
{
    Q_UNUSED(parent)

    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
    m_shortcuts = new KConfigGroup(m_config, "Shortcuts");
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
        DEBUG << "saved";
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

    // mpv actions
    if (actionName == QStringLiteral("seekForward")) {
        QAction *action = new QAction();
        action->setText(i18n("Seek Forward"));
        action->setIcon(QIcon::fromTheme("media-seek-forward"));
        action->setShortcut(QKeySequence(Qt::Key_Right));
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
    m_collection.readSettings(m_shortcuts);
}
