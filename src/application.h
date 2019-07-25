#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QAction>
#include <KActionCollection>
#include <KSharedConfig>

class QAction;
class KActionCollection;

class Application : public QObject
{
    Q_OBJECT
public:
    explicit Application(QObject *parent = nullptr);
    ~Application() = default;

signals:

public slots:
    void configureShortcuts();
    void hideCursor();
    void showCursor();
    QAction* action(const QString& name);
    QString iconName(const QIcon& icon);
private:
    void setupActions(const QString &actionName);
    KActionCollection m_collection;
    KSharedConfig::Ptr m_config;
    KConfigGroup *m_shortcuts;
};

#endif // APPLICATION_H
