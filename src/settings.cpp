#include "settings.h"

#include <KConfig>
#include <KConfigGroup>
#include <QVariant>

Settings::Settings(QObject *parent) : QObject(parent)
{
    m_defaultSettings = {
        {"SeekSmallStep",         QVariant(5)},
        {"SeekMediumStep",        QVariant(15)},
        {"SeekBigStep",           QVariant(30)},
        {"VolumeStep",            QVariant(5)},
        {"OsdFontSize",           QVariant(25)},
        {"SubtitlesFolders",      QVariant(QStringLiteral("subs"))},
        {"lastPlayedFile",        QVariant(QStringLiteral())},
        {"lastPlayedDuration",    QVariant(QStringLiteral())},
        {"lastPlayedPosition",    QVariant(QStringLiteral())},
        {"lastUrl",               QVariant(QStringLiteral())},
        {"LeftButtonAction",      QVariant(QStringLiteral("none"))},
        {"MiddleButtonAction",    QVariant(QStringLiteral("none"))},
        {"RightButtonAction",     QVariant(QStringLiteral("playPauseAction"))},
        {"ScrollUpAction",        QVariant(QStringLiteral("none"))},
        {"ScrollDownAction",      QVariant(QStringLiteral("none"))},
        {"volume",                QVariant(75)}
    };
    m_config = KSharedConfig::openConfig("georgefb/haruna.conf");
}

QVariant Settings::defaultSetting(QString key)
{
    return m_defaultSettings[key];
}

QVariant Settings::get(const QString group, const QString key)
{
    return m_config->group(group).readEntry(key, m_defaultSettings[key]);
}

void Settings::set(const QString group, const QString key, const QString value)
{
    m_config->group(group).writeEntry(key, value);
    m_config->sync();
}

QVariant Settings::getPath(const QString group, const QString key)
{
    return m_config->group(group).readPathEntry(key, QStringList());
}

void Settings::setPath(const QString group, const QString key, const QString value)
{
    m_config->group(group).writePathEntry(key, value);
    m_config->sync();
}
