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
    void setHovered(int row);
    void removeHovered(int row);
    void setPlayingVideo(int playingVideo);
    int getPlayingVideo() const;
    QMap<int, VideoItem *> items() const;
private:
    QMap<int, VideoItem*> m_videoList;
    int m_playingVideo = -1;
};

#endif // VIDEOLIST_H
