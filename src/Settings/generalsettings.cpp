#include "generalsettings.h"
#include "../_debug.h"

GeneralSettings::GeneralSettings(QObject *parent)
    : Settings(parent)
{
    CONFIG_GROUP = QStringLiteral("General");
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
    return get("OsdFontSize").toInt();
}

void GeneralSettings::setOsdFontSize(int fontSize)
{
    if (fontSize == osdFontSize()) {
        return;
    }
    set("OsdFontSize", QString::number(fontSize));
    emit osdFontSizeChanged();
}

int GeneralSettings::volumeStep()
{
    return get("VolumeStep").toInt();
}

void GeneralSettings::setVolumeStep(int step)
{
    if (step == volumeStep()) {
        return;
    }
    set("VolumeStep", QString::number(step));
    emit volumeStepChanged();
}

int GeneralSettings::seekSmallStep()
{
    return get("SeekSmallStep").toInt();
}

void GeneralSettings::setSeekSmallStep(int step)
{
    if (step == seekSmallStep()) {
        return;
    }
    set("SeekSmallStep", QString::number(step));
    emit seekSmallStep();
}

int GeneralSettings::seekMediumStep()
{
    return get("SeekMediumStep").toInt();
}

void GeneralSettings::setSeekMediumStep(int step)
{
    if (step == seekMediumStep()) {
        return;
    }
    set("SeekMediumStep", QString::number(step));
    emit seekMediumStep();
}

int GeneralSettings::seekBigStep()
{
    return get("SeekBigStep").toInt();
}

void GeneralSettings::setSeekBigStep(int step)
{
    if (step == seekBigStep()) {
        return;
    }
    set("SeekBigStep", QString::number(step));
    emit seekBigStep();
}

int GeneralSettings::volume()
{
    return get("Volume").toInt();
}

void GeneralSettings::setVolume(int vol)
{
    if (vol == volume()) {
        return;
    }
    set("Volume", QString::number(vol));
    emit volumeChanged();
}

QString GeneralSettings::lastPlayedFile()
{
    return get("LastPlayedFile").toString();
}

void GeneralSettings::setLastPlayedFile(const QString &file)
{
    if (file == lastPlayedFile()) {
        return;
    }
    set("LastPlayedFile", file);
    emit lastPlayedFileChanged();
}

QString GeneralSettings::lastUrl()
{
    return get("LastUrl").toString();
}

void GeneralSettings::setLastUrl(const QString &url)
{
    if (url == lastUrl()) {
        return;
    }
    set("LastUrl", url);
    emit lastUrlChanged();
}

bool GeneralSettings::showMenuBar()
{
    return get("ShowMenuBar").toBool();
}

void GeneralSettings::setShowMenuBar(bool isVisible)
{
    if (isVisible == showMenuBar()) {
        return;
    }
    set("ShowMenuBar", QVariant(isVisible).toString());
    emit showMenuBarChanged();
}

bool GeneralSettings::showHeader()
{
    return get("ShowHeader").toBool();
}

void GeneralSettings::setShowHeader(bool isVisible)
{
    if (isVisible == showHeader()) {
        return;
    }
    set("ShowHeader", QVariant(isVisible).toString());
    emit showHeaderChanged();
}
