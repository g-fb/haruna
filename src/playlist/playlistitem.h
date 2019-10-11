#ifndef VIDEOITEM_H
#define VIDEOITEM_H

#include <QObject>

class VideoItem : public QObject
{
    Q_OBJECT
public:
    explicit VideoItem(QObject *parent = nullptr);

    QString filePath() const;
    void setFilePath(const QString &filePath);

    QString fileName() const;
    void setFileName(const QString &fileName);

    QString folderPath() const;
    void setFolderPath(const QString &folderPath);

    QString duration() const;
    void setDuration(const QString &duration);

    bool isHovered() const;
    void setIsHovered(bool isHovered);

    bool isPlaying() const;
    void setIsPlaying(bool isPlaying);

    int index() const;
    void setIndex(int index);

signals:

public slots:

private:
    QString m_filePath;
    QString m_fileName;
    QString m_folderPath;
    QString m_duration;
    bool m_isHovered;
    bool m_isPlaying;
    int m_index;
};

#endif // VIDEOITEM_H
