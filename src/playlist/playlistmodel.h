/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef PLAYLISTMODEL_H
#define PLAYLISTMODEL_H

#include <QAbstractTableModel>

class PlayListItem;

class PlayListModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit PlayListModel(QObject *parent = nullptr);

    enum {
        DisplayRole = Qt::UserRole,
        PathRole,
        FolderPathRole,
        PlayingRole,
        HoverRole
    };

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;


signals:
    void videoAdded(int index, QString path);

public slots:
    QMap<int, PlayListItem *> items() const;
    QString getPath(int i);
    void getVideos(QString path);
    void setPlayingVideo(int playingVideo);
    void setHoveredVideo(int hoveredVideo);
    void clearHoveredVideo(int hoveredVideo);
    int getPlayingVideo() const;

private:
    QMap<int, PlayListItem*> m_playList;
    int m_playingVideo = -1;
};

#endif // PLAYLISTMODEL_H
