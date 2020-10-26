/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "playlistmodel.h"
#include "playlistitem.h"
#include "_debug.h"
#include "worker.h"

#include <QCollator>
#include <QDirIterator>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QUrl>

PlayListModel::PlayListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(this, &PlayListModel::videoAdded,
            Worker::instance(), &Worker::getVideoDuration);
    connect(Worker::instance(), &Worker::videoDuration, this, [ = ](int i, const QString &d) {
        m_playList[i]->setDuration(d);
        dataChanged(index(i, 0), index(i, 0));
    });
}

int PlayListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_playList.size();
}

QVariant PlayListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || m_playList.empty())
        return QVariant();

    auto playListItem = m_playList.at(index.row()).get();
    switch (role) {
    case DisplayRole:
        return QVariant(playListItem->fileName());
    case PathRole:
        return QVariant(playListItem->filePath());
    case DurationRole:
        return QVariant(playListItem->duration());
    case PlayingRole:
        return QVariant(playListItem->isPlaying());
    case FolderPathRole:
        return QVariant(playListItem->folderPath());
    }

    return QVariant();
}

QHash<int, QByteArray> PlayListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DisplayRole] = "name";
    roles[PathRole] = "path";
    roles[FolderPathRole] = "folderPath";
    roles[DurationRole] = "duration";
    roles[PlayingRole] = "isPlaying";
    return roles;
}

void PlayListModel::getVideos(QString path)
{
    beginResetModel();
    m_playList.clear();
    endResetModel();
    m_playingVideo = -1;
    path = QUrl(path).toLocalFile().isEmpty() ? path : QUrl(path).toLocalFile();
    QFileInfo pathInfo(path);
    QStringList videoFiles;
    if (pathInfo.exists() && pathInfo.isFile()) {
        QDirIterator it(pathInfo.absolutePath(), QDir::Files, QDirIterator::NoIteratorFlags);
        while (it.hasNext()) {
            QString file = it.next();
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

    beginInsertRows(QModelIndex(), 0, videoFiles.count() - 1);

    for (int i = 0; i < videoFiles.count(); ++i) {
        QFileInfo fileInfo(videoFiles.at(i));
        auto video = std::make_shared<PlayListItem>();
        video->setFileName(fileInfo.fileName());
        video->setIndex(i);
        video->setFilePath(fileInfo.absoluteFilePath());
        video->setFolderPath(fileInfo.absolutePath());
        video->setIsPlaying(false);
        m_playList.emplace(i, video);
        if (path == videoFiles.at(i)) {
            setPlayingVideo(i);
        }
        emit videoAdded(i, video->filePath());
    }

    endInsertRows();
}

Playlist PlayListModel::items() const
{
    return m_playList;
}

int PlayListModel::getPlayingVideo() const
{
    return m_playingVideo;
}

QString PlayListModel::getPath(int i)
{
    return m_playList[i]->filePath();
}

void PlayListModel::setPlayingVideo(int playingVideo)
{
    if (m_playingVideo != -1) {
        m_playList[m_playingVideo]->setIsPlaying(false);
        emit dataChanged(index(m_playingVideo, 0), index(m_playingVideo, 0));
        m_playList[playingVideo]->setIsPlaying(true);
        emit dataChanged(index(playingVideo, 0), index(playingVideo, 0));
    } else {
        m_playList[playingVideo]->setIsPlaying(true);
    }
    m_playingVideo = playingVideo;
    emit playingVideoChanged();
}
