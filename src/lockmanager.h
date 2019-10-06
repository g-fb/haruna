#ifndef LOCKMANAGER_H
#define LOCKMANAGER_H

#include <QObject>

class OrgFreedesktopScreenSaverInterface;

class LockManager : public QObject
{
    Q_OBJECT

public:
    explicit LockManager(QObject *parent = nullptr);
    ~LockManager() = default;

public Q_SLOTS:
    void setInhibitionOn();
    void setInhibitionOff();
private:
    OrgFreedesktopScreenSaverInterface* m_iface;
    int m_cookie;
    bool m_inhibit;
};

#endif // LOCKMANAGER_H


