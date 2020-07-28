/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef VIDEOSETTINGS_H
#define VIDEOSETTINGS_H

#include <QObject>
#include <QHash>
#include <KSharedConfig>
#include <QQmlEngine>

class VideoSettings : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString screenshotTemplate
               READ screenshotTemplate
               WRITE setScreenshotTemplate
               NOTIFY screenshotTemplateChanged)

public:
    VideoSettings();

    QString screenshotTemplate();
    void setScreenshotTemplate(QString ssTemplate);

    static QObject *provider(QQmlEngine *engine, QJSEngine *scriptEngine)
    {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)

        return new VideoSettings();
    }

signals:
    void settingsChanged();
    void screenshotTemplateChanged();

public slots:
    QVariant get(const QString &group, const QString &key);
    void set(const QString &group, const QString &key, const QString &value);
private:
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
};

#endif // VIDEOSETTINGS_H
