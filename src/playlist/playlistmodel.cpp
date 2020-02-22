/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "playlistmodel.h"
#include "playlistitem.h"
#include "../_debug.h"
#include <src/worker.h>

#include <QCollator>
#include <QDirIterator>
#include <QFileInfo>
#include <QMimeDatabase>
#include <QUrl>

PlayListModel::PlayListModel(QObject *parent)
    : QAbstractTableModel(parent)
{
    connect(this, &PlayListModel::videoAdded,
            Worker::instance(), &Worker::getVideoDuration);
    connect(Worker::instance(), &Worker::videoDuration, this, [ = ](int i, QString d) {
        m_playList[i]->setDuration(d);
        dataChanged(index(i, 1), index(i, 1));
    });
}

int PlayListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_playList.size();
}

int PlayListModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return 2;
}

QVariant PlayListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || m_playList.isEmpty())
        return QVariant();

    PlayListItem *playListItem = m_playList[index.row()];
    switch (role) {
    case DisplayRole:
        if (index.column() == 0) {
            return QVariant(playListItem->fileName());
        } else {
            return QVariant(playListItem->duration());
        }
    case PathRole:
        return QVariant(playListItem->filePath());
    case HoverRole:
        return QVariant(playListItem->isHovered());
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
    roles[HoverRole] = "isHovered";
    roles[PlayingRole] = "isPlaying";
    return roles;
}


void PlayListModel::getVideos(QString path)
{
    m_playList.clear();
    m_playingVideo = -1;
    path = QUrl(path).toLocalFile().isEmpty() ? path : QUrl(path).toLocalFile();
    QFileInfo pathInfo(path);
    QStringList videoFiles;
    if (pathInfo.exists() && pathInfo.isFile()) {
        QDirIterator *it = new QDirIterator(pathInfo.absolutePath(), QDir::Files, QDirIterator::NoIteratorFlags);
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

    beginInsertRows(QModelIndex(), 0, videoFiles.count());

    for (int i = 0; i < videoFiles.count(); ++i) {
        QFileInfo fileInfo(videoFiles.at(i));
        auto video = new PlayListItem();
        video->setFileName(fileInfo.fileName());
        video->setIndex(i);
        video->setFilePath(fileInfo.absoluteFilePath());
        video->setFolderPath(fileInfo.absolutePath());
        video->setIsHovered(false);
        video->setIsPlaying(false);
        m_playList.insert(i, video);
        if (path == videoFiles.at(i)) {
            setPlayingVideo(i);
        }
        emit videoAdded(i, video->filePath());
    }

    endInsertRows();
}

QMap<int, PlayListItem *> PlayListModel::items() const
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
        emit dataChanged(index(m_playingVideo, 0), index(m_playingVideo, 1));
        m_playList[playingVideo]->setIsPlaying(true);
        emit dataChanged(index(playingVideo, 0), index(playingVideo, 1));
    } else {
        m_playList[playingVideo]->setIsPlaying(true);
    }
    m_playingVideo = playingVideo;
}

void PlayListModel::setHoveredVideo(int hoveredVideo)
{
    m_playList[hoveredVideo]->setIsHovered(true);
    emit dataChanged(index(hoveredVideo, 0), index(hoveredVideo, 1));
}

void PlayListModel::clearHoveredVideo(int hoveredVideo)
{
    m_playList[hoveredVideo]->setIsHovered(false);
    emit dataChanged(index(hoveredVideo, 0), index(hoveredVideo, 1));
}
