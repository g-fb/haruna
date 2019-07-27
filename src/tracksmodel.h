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
        LanguageRole = Qt::UserRole,
        TitleRole,
        IDRole,
        SelectedRole,
        CodecRole
    };
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    virtual QHash<int, QByteArray> roleNames() const override;
signals:

public slots:
    void setTracks(QList<Track *> tracks);
    Q_INVOKABLE void updateSelectedTrack(int id);
private:
    QList<Track *> m_tracks;
};

#endif // TRACKSMODEL_H
