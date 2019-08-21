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
    int selectedTrack() const;
    void setSelectedTrack(int selectedTrack);

signals:

public slots:
    void setTracks(QMap<int, Track *> tracks);
    Q_INVOKABLE void updateSelectedTrack(int i);
private:
    QMap<int, Track *> m_tracks;
    int m_selectedTrack;
};

#endif // TRACKSMODEL_H
