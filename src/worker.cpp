#include "_debug.h"
#include "worker.h"

#include <QDateTime>
#include <QThread>
#include <MediaInfo/MediaInfo.h>

Worker* Worker::sm_worker = 0;

Worker* Worker::instance()
{
    if (!sm_worker) {
        sm_worker = new Worker();
    }
    return sm_worker;
}

void Worker::getVideoDuration(int index, QString path)
{
    MediaInfoLib::MediaInfo MI;
    MI.Open(path.toStdWString());
    int miliseconds = std::stoi(MI.Get(
        MediaInfoLib::Stream_General, 0, L"Duration")
    );
    MI.Close();
    double seconds = miliseconds/1000;
    QDateTime duration = QDateTime::fromTime_t(seconds).toUTC();
    emit videoDuration(index, duration.toString("hh:mm:ss"));
}
