#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QAction>
#include <KActionCollection>
#include <KSharedConfig>

#include "ui_settings.h"

class QAction;
class KActionCollection;
class HarunaSettings;
class KConfigDialog;

class SettingsWidget: public QWidget, public Ui::SettingsWidget
{
    Q_OBJECT
public:
    explicit SettingsWidget(QWidget *parent) : QWidget(parent) {
        setupUi(this);
    }
};

class Application : public QObject
{
    Q_OBJECT
public:
    explicit Application(QObject *parent = nullptr);
    ~Application() = default;

signals:

public slots:
    void configureShortcuts();
    QString argument(int key);
    void addArgument(int key, QString value);
    QString getPathFromArg(QString arg);
    void hideCursor();
    void showCursor();
    QAction* action(const QString& name);
    QString iconName(const QIcon& icon);
    QVariant setting(const QString group, const QString key, const QString defaultValue = QStringLiteral());
    void setSetting(const QString group, const QString key, const QString value);
    QVariant pathSetting(const QString group, const QString key);
    void setPathSetting(const QString group, const QString key, const QString value);
    void openSettingsDialog();
private:
    void setupActions(const QString &actionName);
    KActionCollection m_collection;
    KSharedConfig::Ptr m_config;
    KConfigGroup *m_shortcuts;
    KConfigDialog *m_settingsDialog;
    SettingsWidget *m_settingsWidget = nullptr;
    QMap<int, QString> args;
};

#endif // APPLICATION_H
