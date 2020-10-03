#include "generalsettings.h"
#include "../_debug.h"

GeneralSettings::GeneralSettings(QObject *parent)
    : Settings(parent)
{
    m_defaultSettings = {
        {"SeekSmallStep",  QVariant(5)},
        {"SeekMediumStep", QVariant(15)},
        {"SeekBigStep",    QVariant(30)},
        {"VolumeStep",     QVariant(5)},
        {"OsdFontSize",    QVariant(25)},
        {"LastPlayedFile", QVariant(QStringLiteral())},
        {"LastUrl",        QVariant(QStringLiteral())},
        {"Volume",         QVariant(75)},
        {"ShowMenuBar",    QVariant(true)},
        {"ShowHeader",     QVariant(true)}
    };
}

int GeneralSettings::osdFontSize()
{
    return get("General", "OsdFontSize").toInt();
}

void GeneralSettings::setOsdFontSize(int fontSize)
{
    if (fontSize == osdFontSize()) {
        return;
    }
    set("General", "OsdFontSize", QString::number(fontSize));
    emit osdFontSizeChanged();
}

int GeneralSettings::volumeStep()
{
    return get("General", "VolumeStep").toInt();
}

void GeneralSettings::setVolumeStep(int step)
{
    if (step == volumeStep()) {
        return;
    }
    set("General", "VolumeStep", QString::number(step));
    emit volumeStepChanged();
}

int GeneralSettings::seekSmallStep()
{
    return get("General", "SeekSmallStep").toInt();
}

void GeneralSettings::setSeekSmallStep(int step)
{
    if (step == seekSmallStep()) {
        return;
    }
    set("General", "SeekSmallStep", QString::number(step));
    emit seekSmallStep();
}

int GeneralSettings::seekMediumStep()
{
    return get("General", "SeekMediumStep").toInt();
}

void GeneralSettings::setSeekMediumStep(int step)
{
    if (step == seekMediumStep()) {
        return;
    }
    set("General", "SeekMediumStep", QString::number(step));
    emit seekMediumStep();
}

int GeneralSettings::seekBigStep()
{
    return get("General", "SeekBigStep").toInt();
}

void GeneralSettings::setSeekBigStep(int step)
{
    if (step == seekBigStep()) {
        return;
    }
    set("General", "SeekBigStep", QString::number(step));
    emit seekBigStep();
}

int GeneralSettings::volume()
{
    return get("General", "Volume").toInt();
}

void GeneralSettings::setVolume(int vol)
{
    if (vol == volume()) {
        return;
    }
    set("General", "Volume", QString::number(vol));
    emit volumeChanged();
}

QString GeneralSettings::lastPlayedFile()
{
    return get("General", "LastPlayedFile").toString();
}

void GeneralSettings::setLastPlayedFile(const QString &file)
{
    if (file == lastPlayedFile()) {
        return;
    }
    set("General", "LastPlayedFile", file);
    emit lastPlayedFileChanged();
}

QString GeneralSettings::lastUrl()
{
    return get("General", "LastUrl").toString();
}

void GeneralSettings::setLastUrl(const QString &url)
{
    if (url == lastUrl()) {
        return;
    }
    set("General", "LastUrl", url);
    emit lastUrlChanged();
}

bool GeneralSettings::showMenuBar()
{
    return get("General", "ShowMenuBar").toBool();
}

void GeneralSettings::setShowMenuBar(bool isVisible)
{
    if (isVisible == showMenuBar()) {
        return;
    }
    set("General", "ShowMenuBar", QVariant(isVisible).toString());
    emit showMenuBarChanged();
}

bool GeneralSettings::showHeader()
{
    return get("General", "ShowHeader").toBool();
}

void GeneralSettings::setShowHeader(bool isVisible)
{
    if (isVisible == showHeader()) {
        return;
    }
    set("General", "ShowHeader", QVariant(isVisible).toString());
    emit showHeaderChanged();
}
