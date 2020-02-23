/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef TRACKSMODEL_H
#define TRACKSMODEL_H

#include <QAbstractListModel>
#include <QObject>

class Track;

class TracksModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit TracksModel(QObject *parent = nullptr);
    enum {
        TextRole = Qt::UserRole,
        LanguageRole,
        TitleRole,
        IDRole,
        FirstTrackRole,
        SecondTrackRole,
        CodecRole
    };
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
    int firstTrack() const;
    void setFirstTrack(int i);
    int secondTrack() const;
    void setSecondTrack(int i);

signals:

public slots:
    void setTracks(QMap<int, Track *> tracks);
    Q_INVOKABLE void updateFirstTrack(int i);
    Q_INVOKABLE void updateSecondTrack(int i);
private:
    QMap<int, Track *> m_tracks;
    int m_firstTrack;
    int m_secondTrack;
};

#endif // TRACKSMODEL_H
