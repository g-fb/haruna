#ifndef MOUSESETTINGS_H
#define MOUSESETTINGS_H

#include "../settings.h"
#include <KSharedConfig>
#include <QQmlEngine>

class MouseSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QString mouseLeftAction
               READ mouseLeftAction
               WRITE setMouseLeftAction
               NOTIFY mouseLeftActionChanged)

    Q_PROPERTY(QString mouseLeftx2Action
               READ mouseLeftx2Action
               WRITE setMouseLeftx2Action
               NOTIFY mouseLeftx2ActionChanged)

    Q_PROPERTY(QString mouseRightAction
               READ mouseRightAction
               WRITE setMouseRightAction
               NOTIFY mouseRightActionChanged)

    Q_PROPERTY(QString mouseRightx2Action
               READ mouseRightx2Action
               WRITE setMouseRightx2Action
               NOTIFY mouseRightx2ActionChanged)

    Q_PROPERTY(QString mouseMiddleAction
               READ mouseMiddleAction
               WRITE setMouseMiddleAction
               NOTIFY mouseMiddleActionChanged)

    Q_PROPERTY(QString mouseMiddlex2Action
               READ mouseMiddlex2Action
               WRITE setMouseMiddlex2Action
               NOTIFY mouseMiddlex2ActionChanged)

    Q_PROPERTY(QString mouseScrollUpAction
               READ mouseScrollUpAction
               WRITE setMouseScrollUpAction
               NOTIFY mouseScrollUpActionChanged)

    Q_PROPERTY(QString mouseScrollDownAction
               READ mouseScrollDownAction
               WRITE setMouseScrollDownAction
               NOTIFY mouseScrollDownActionChanged)

public:
    explicit MouseSettings(QObject *parent = nullptr);

    QString mouseLeftAction();
    void setMouseLeftAction(const QString &action);

    QString mouseLeftx2Action();
    void setMouseLeftx2Action(const QString &action);

    QString mouseRightAction();
    void setMouseRightAction(const QString &action);

    QString mouseRightx2Action();
    void setMouseRightx2Action(const QString &action);

    QString mouseMiddleAction();
    void setMouseMiddleAction(const QString &action);

    QString mouseMiddlex2Action();
    void setMouseMiddlex2Action(const QString &action);

    QString mouseScrollUpAction();
    void setMouseScrollUpAction(const QString &action);

    QString mouseScrollDownAction();
    void setMouseScrollDownAction(const QString &action);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new MouseSettings();
    }

signals:
    void settingsChanged();
    void mouseLeftActionChanged();
    void mouseLeftx2ActionChanged();
    void mouseRightActionChanged();
    void mouseRightx2ActionChanged();
    void mouseMiddleActionChanged();
    void mouseMiddlex2ActionChanged();
    void mouseScrollUpActionChanged();
    void mouseScrollDownActionChanged();

};

#endif // MOUSESETTINGS_H
