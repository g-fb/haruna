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

    Track *track = m_tracks.at(index.row());

    switch (role) {
    case LanguageRole:
        return QVariant(track->lang());
    case TitleRole:
        return QVariant(track->title());
    case IDRole:
        return QVariant(track->id());
    case SelectedRole:
        return QVariant(track->selected());
    case CodecRole:
        return QVariant(track->codec());
    }

    return QVariant();
}

QHash<int, QByteArray> TracksModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[LanguageRole] = "language";
    roles[TitleRole] = "title";
    roles[IDRole] = "id";
    roles[SelectedRole] = "selected";
    roles[CodecRole] = "codec";
    return roles;
}

void TracksModel::setTracks(QList<Track *> tracks)
{
    beginResetModel();
    m_tracks = tracks;
    endResetModel();
}

void TracksModel::updateSelectedTrack(int id)
{
    int i = 0;
    for (auto track : m_tracks) {
        if (track->selected() == true && track->id() == id) {
            track->setSelected(true);
            dataChanged(index(i), index(i));
        }
        if (track->selected() == true && track->id() != id) {
            track->setSelected(false);
            dataChanged(index(i), index(i));
        }
        if (track->selected() == false && track->id() == id) {
            track->setSelected(true);
            dataChanged(index(i), index(i));
        }
        if (track->selected() == false && track->id() != id) {
            track->setSelected(false);
            dataChanged(index(i), index(i));
        }
        i++;
    }
}
