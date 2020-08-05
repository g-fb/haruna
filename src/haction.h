#ifndef HACTION_H
#define HACTION_H

#include <QAction>

class HAction : public QAction
{
    Q_OBJECT
public:
    explicit HAction(QObject *parent = nullptr);

public slots:
    QString shortcutName();
    QString iconName();

};

#endif // HACTION_H
