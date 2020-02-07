/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "../_debug.h"
#include "playlistitem.h"

PlayListItem::PlayListItem(QObject *parent) : QObject(parent)
{

}

QString PlayListItem::filePath() const
{
    return m_filePath;
}

void PlayListItem::setFilePath(const QString &filePath)
{
    m_filePath = filePath;
}

QString PlayListItem::fileName() const
{
    return m_fileName;
}

void PlayListItem::setFileName(const QString &fileName)
{
    m_fileName = fileName;
}

QString PlayListItem::folderPath() const
{
    return m_folderPath;
}

void PlayListItem::setFolderPath(const QString &folderPath)
{
    m_folderPath = folderPath;
}

QString PlayListItem::duration() const
{
    return m_duration;
}

void PlayListItem::setDuration(const QString &duration)
{
    m_duration = duration;
}

bool PlayListItem::isHovered() const
{
    return m_isHovered;
}

void PlayListItem::setIsHovered(bool isHovered)
{
    m_isHovered = isHovered;
}

bool PlayListItem::isPlaying() const
{
    return m_isPlaying;
}

void PlayListItem::setIsPlaying(bool isPlaying)
{
    m_isPlaying = isPlaying;
}

int PlayListItem::index() const
{
    return m_index;
}

void PlayListItem::setIndex(int index)
{
    m_index = index;
}
