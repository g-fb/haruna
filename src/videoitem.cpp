#include "_debug.h"
#include "videoitem.h"

VideoItem::VideoItem(QObject *parent) : QObject(parent)
{

}

QString VideoItem::filePath() const
{
    return m_filePath;
}

void VideoItem::setFilePath(const QString &filePath)
{
    m_filePath = filePath;
}

QString VideoItem::fileName() const
{
    return m_fileName;
}

void VideoItem::setFileName(const QString &fileName)
{
    m_fileName = fileName;
}

QString VideoItem::folderPath() const
{
    return m_folderPath;
}

void VideoItem::setFolderPath(const QString &folderPath)
{
    m_folderPath = folderPath;
}

QString VideoItem::duration() const
{
    return m_duration;
}

void VideoItem::setDuration(const QString &duration)
{
    m_duration = duration;
}

bool VideoItem::isHovered() const
{
    return m_isHovered;
}

void VideoItem::setIsHovered(bool isHovered)
{
    m_isHovered = isHovered;
}

bool VideoItem::isPlaying() const
{
    return m_isPlaying;
}

void VideoItem::setIsPlaying(bool isPlaying)
{
    m_isPlaying = isPlaying;
}

int VideoItem::index() const
{
    return m_index;
}

void VideoItem::setIndex(int index)
{
    m_index = index;
}
