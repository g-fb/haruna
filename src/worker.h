#ifndef WORKER_H
#define WORKER_H

#include <QObject>

class Worker : public QObject
{
    Q_OBJECT
public:
    Worker() = default;
    ~Worker() = default;

    static Worker* instance();


signals:
    void videoDuration(int index, QString duration);
public slots:
    void getVideoDuration(int index, QString path);
private:
    static Worker *sm_worker;
};

#endif // WORKER_H
