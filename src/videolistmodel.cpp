#include "videolistmodel.h"
#include "videolist.h"
#include "videoitem.h"
#include "_debug.h"

VideoListModel::VideoListModel(VideoList *videoList, QObject *parent)
    : QAbstractTableModel(parent)
    , m_list(videoList)
{
    if (m_list) {
        connect(m_list, &VideoList::preItemsAppended, [this](int numElements) {
            const int start = m_list->items().size();
            beginInsertRows(QModelIndex(), start, start + numElements - 1);
        });

        connect(m_list, &VideoList::postItemsAppended, [this]() {
            endInsertRows();
        });

        connect(m_list, &VideoList::dataChanged, [this](int row, int col) {
            dataChanged(index(row, col), index(row, col));
        });

    }
}

int VideoListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return m_list->items().size();
}

int VideoListModel::columnCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    return 3;
}

QVariant VideoListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || m_list == nullptr)
        return QVariant();

    VideoItem *videoItem = m_list->items()[index.row()];
    switch (role) {
    case DisplayRole:
        if (index.column() == 0) {
            return QVariant(index.row() + 1);
        } else if (index.column() == 1) {
            return QVariant(videoItem->fileName());
        } else {
            return QVariant(videoItem->duration());
        }
    case PathRole:
        return QVariant(videoItem->filePath());
    case HoverRole:
        return QVariant(videoItem->isHovered());
    case PlayingRole:
        return QVariant(videoItem->isPlaying());
    case FolderPathRole:
        return QVariant(videoItem->folderPath());
    }

    return QVariant();
}

QHash<int, QByteArray> VideoListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[DisplayRole] = "display";
    roles[PathRole] = "path";
    roles[FolderPathRole] = "folderPath";
    roles[HoverRole] = "isHovered";
    roles[PlayingRole] = "isPlaying";
    return roles;
}
