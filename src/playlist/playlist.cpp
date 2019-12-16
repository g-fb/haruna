#include "../_debug.h"
#include "../worker.h"
#include "playlist.h"
#include "playlistitem.h"

#include <QCollator>
#include <QDirIterator>
#include <QMimeDatabase>
#include <QUrl>

VideoList::VideoList(QObject *parent) : QObject(parent)
{
    connect(this, &VideoList::videoAdded,
            Worker::instance(), &Worker::getVideoDuration);
    connect(Worker::instance(), &Worker::videoDuration, this, [ = ](int i, QString d) {
        m_videoList[i]->setDuration(d);
        emit dataChanged(i, 2);
    });
}

void VideoList::getVideos(QString path)
{
    m_videoList.clear();
    m_playingVideo = -1;
    path = QUrl(path).toLocalFile().isEmpty() ? path : QUrl(path).toLocalFile();
    QFileInfo pathInfo(path);
    QStringList videoFiles;
    if (pathInfo.exists() && pathInfo.isFile()) {
        QDirIterator *it = new QDirIterator(pathInfo.absolutePath(), QDir::Files, QDirIterator::NoIteratorFlags);
        int key(0);
        while (it->hasNext()) {
            QString file = it->next();
            QFileInfo fileInfo(file);
            QMimeDatabase db;
            QMimeType type = db.mimeTypeForFile(file);
            if (fileInfo.exists() && type.name().startsWith("video/")) {
                videoFiles.append(fileInfo.absoluteFilePath());
            }
        }
    }
    QCollator collator;
    collator.setNumericMode(true);
    std::sort(videoFiles.begin(), videoFiles.end(), collator);

    emit preItemsAppended(videoFiles.count());
    for (int i = 0; i < videoFiles.count(); ++i) {
        QFileInfo fileInfo(videoFiles.at(i));
        auto video = new VideoItem();
        video->setFileName(fileInfo.fileName());
        video->setIndex(i);
        video->setFilePath(fileInfo.absoluteFilePath());
        video->setFolderPath(fileInfo.absolutePath());
        video->setIsHovered(false);
        m_videoList.insert(i, video);
        if (path == videoFiles.at(i)) {
            setPlayingVideo(i);
        } else {
            video->setIsPlaying(false);
        }
        emit videoAdded(i, video->filePath());
    }
    emit postItemsAppended();
}

QMap<int, VideoItem *> VideoList::items() const
{
    return m_videoList;
}

int VideoList::count()
{
    return m_videoList.count();
}

int VideoList::getPlayingVideo() const
{
    return m_playingVideo;
}

QString VideoList::getPath(int i)
{
    return m_videoList[i]->filePath();
}

void VideoList::setPlayingVideo(int playingVideo)
{
    if (m_playingVideo != -1) {
        m_videoList[m_playingVideo]->setIsPlaying(false);
        emit dataChanged(m_playingVideo, 0);
        emit dataChanged(m_playingVideo, 1);
        emit dataChanged(m_playingVideo, 2);
        m_videoList[playingVideo]->setIsPlaying(true);
        emit dataChanged(playingVideo, 0);
        emit dataChanged(playingVideo, 1);
        emit dataChanged(playingVideo, 2);
    } else {
        m_videoList[playingVideo]->setIsPlaying(true);
    }
    m_playingVideo = playingVideo;
}
