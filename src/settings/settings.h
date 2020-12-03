/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>
#include <QHash>
#include <KSharedConfig>
#include <QQmlEngine>

class Settings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QUrl configFilePath READ configFilePath)
    Q_PROPERTY(QUrl configFolderPath READ configFolderPath)
public:
    explicit Settings(QObject *parent = nullptr);

    Q_INVOKABLE QVariant get(const QString &key);
    Q_INVOKABLE void set(const QString &key, const QString &value);
    QUrl configFilePath();
    QUrl configFolderPath();

signals:
    void settingsChanged();

protected:
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
    QString CONFIG_GROUP;
};

#endif // SETTINGS_H
