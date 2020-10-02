#ifndef MOUSESETTINGS_H
#define MOUSESETTINGS_H

#include "../settings.h"
#include <KSharedConfig>
#include <QQmlEngine>

class MouseSettings : public Settings
{
    Q_OBJECT
    Q_PROPERTY(QString leftAction
               READ leftAction
               WRITE setLeftAction
               NOTIFY leftActionChanged)

    Q_PROPERTY(QString leftx2Action
               READ leftx2Action
               WRITE setLeftx2Action
               NOTIFY leftx2ActionChanged)

    Q_PROPERTY(QString rightAction
               READ rightAction
               WRITE setRightAction
               NOTIFY rightActionChanged)

    Q_PROPERTY(QString rightx2Action
               READ rightx2Action
               WRITE setRightx2Action
               NOTIFY rightx2ActionChanged)

    Q_PROPERTY(QString middleAction
               READ middleAction
               WRITE setMiddleAction
               NOTIFY middleActionChanged)

    Q_PROPERTY(QString middlex2Action
               READ middlex2Action
               WRITE setMiddlex2Action
               NOTIFY middlex2ActionChanged)

    Q_PROPERTY(QString scrollUpAction
               READ scrollUpAction
               WRITE setScrollUpAction
               NOTIFY scrollUpActionChanged)

    Q_PROPERTY(QString scrollDownAction
               READ scrollDownAction
               WRITE setScrollDownAction
               NOTIFY scrollDownActionChanged)

public:
    explicit MouseSettings(QObject *parent = nullptr);

    QString leftAction();
    void setLeftAction(const QString &action);

    QString leftx2Action();
    void setLeftx2Action(const QString &action);

    QString rightAction();
    void setRightAction(const QString &action);

    QString rightx2Action();
    void setRightx2Action(const QString &action);

    QString middleAction();
    void setMiddleAction(const QString &action);

    QString middlex2Action();
    void setMiddlex2Action(const QString &action);

    QString scrollUpAction();
    void setScrollUpAction(const QString &action);

    QString scrollDownAction();
    void setScrollDownAction(const QString &action);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new MouseSettings();
    }

signals:
    void settingsChanged();
    void leftActionChanged();
    void leftx2ActionChanged();
    void rightActionChanged();
    void rightx2ActionChanged();
    void middleActionChanged();
    void middlex2ActionChanged();
    void scrollUpActionChanged();
    void scrollDownActionChanged();

};

#endif // MOUSESETTINGS_H
