/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "_debug.h"
#include "track.h"
#include "tracksmodel.h"

TracksModel::TracksModel(QObject *parent)
    : QAbstractListModel(parent)
{

}

int TracksModel::rowCount(const QModelIndex &parent) const
{
    return m_tracks.size();
}

QVariant TracksModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || m_tracks.isEmpty())
        return QVariant();

    Track *track = m_tracks[index.row()];

    switch (role) {
    case TextRole:
        return QVariant(track->text());
    case LanguageRole:
        return QVariant(track->lang());
    case TitleRole:
        return QVariant(track->title());
    case IDRole:
        return QVariant(track->id());
    case FirstTrackRole:
        return QVariant(track->isFirst());
    case SecondTrackRole:
        return QVariant(track->isSecond());
    case CodecRole:
        return QVariant(track->codec());
    }

    return QVariant();
}

QHash<int, QByteArray> TracksModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[TextRole] = "text";
    roles[LanguageRole] = "language";
    roles[TitleRole] = "title";
    roles[IDRole] = "id";
    roles[FirstTrackRole] = "isFirstTrack";
    roles[SecondTrackRole] = "isSecondTrack";
    roles[CodecRole] = "codec";
    return roles;
}

void TracksModel::setTracks(QMap<int, Track *> tracks)
{
    beginResetModel();
    m_tracks = tracks;
    endResetModel();
}

void TracksModel::updateFirstTrack(int i)
{
    m_tracks[firstTrack()]->setFirst(false);
    dataChanged(index(firstTrack()), index(firstTrack()));

    m_tracks[i]->setFirst(true);
    dataChanged(index(i), index(i));
    setFirstTrack(i);
}

int TracksModel::firstTrack() const
{
    return m_firstTrack;
}

void TracksModel::setFirstTrack(int i)
{
    m_firstTrack = i;
}

void TracksModel::updateSecondTrack(int i)
{
    m_tracks[secondTrack()]->setSecond(false);
    dataChanged(index(secondTrack()), index(secondTrack()));

    m_tracks[i]->setSecond(true);
    dataChanged(index(i), index(i));
    setSecondTrack(i);
}

int TracksModel::secondTrack() const
{
    return m_secondTrack;
}

void TracksModel::setSecondTrack(int i)
{
    m_secondTrack = i;
}
