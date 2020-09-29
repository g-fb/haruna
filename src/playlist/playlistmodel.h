/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractTableModel>
#include <map>
#include <memory>

class PlayListItem;

using Playlist = std::map<int, std::shared_ptr<PlayListItem>>;

class PlayListModel : public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(int playingVideo
               MEMBER m_playingVideo
               READ getPlayingVideo
               WRITE setPlayingVideo
               NOTIFY playingVideoChanged)

public:
    explicit PlayListModel(QObject *parent = nullptr);

    enum {
        DisplayRole = Qt::UserRole,
        DurationRole,
        PathRole,
        FolderPathRole,
        PlayingRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;


signals:
    void videoAdded(int index, QString path);
    void playingVideoChanged();

public slots:
    Playlist items() const;
    QString getPath(int i);
    void getVideos(QString path);
    void setPlayingVideo(int playingVideo);
    int getPlayingVideo() const;

private:
    Playlist m_playList;
    int m_playingVideo = -1;
};

#endif // PLAYLISTMODEL_H
