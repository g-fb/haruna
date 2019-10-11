#ifndef VIDEOMODEL_H
#define VIDEOMODEL_H

#include <QAbstractTableModel>

class VideoList;
class VideoItem;

class VideoListModel : public QAbstractTableModel
{
    Q_OBJECT

public:
    explicit VideoListModel(VideoList *videoList, QObject *parent = nullptr);

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
private:
    VideoList *m_list;

};

#endif // VIDEOMODEL_H
