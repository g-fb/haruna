#ifndef VIDEOLIST_H
#define VIDEOLIST_H

#include <QMap>
#include <QObject>

class VideoItem;

class VideoList : public QObject
{
    Q_OBJECT
public:
    VideoList(QObject *parent = nullptr);

signals:
    void preItemsAppended(int numElements);
    void postItemsAppended();
    void dataChanged(int col, int row);
    void videoAdded(int index, QString path);

public slots:
    void getVideos(QString path);
    void setPlayingVideo(int playingVideo);
    int getPlayingVideo() const;
    QString getPath(int i);
    QMap<int, VideoItem *> items() const;
    int count();
private:
    QMap<int, VideoItem*> m_videoList;
    int m_playingVideo = -1;
};

#endif // VIDEOLIST_H
