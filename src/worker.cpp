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
    QString duration = QString::fromStdWString(MI.Get(MediaInfoLib::Stream_General, 0, L"Duration"));
    if (duration.isEmpty()) {
        return;
    }
    MI.Close();
    QDateTime UTCDuration = QDateTime::fromMSecsSinceEpoch(duration.toInt()).toUTC();
    emit videoDuration(index, UTCDuration.toString("hh:mm:ss"));
}
