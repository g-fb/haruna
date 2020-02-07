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

class Settings : public QObject
{
    Q_OBJECT
public:
    explicit Settings(QObject *parent = nullptr);

public slots:
    QVariant get(const QString group, const QString key);
    void set(const QString group, const QString key, const QString value);
    QVariant getPath(const QString group, const QString key);
    void setPath(const QString group, const QString key, const QString value);
private:
    QVariant defaultSetting(QString key);
    QHash<QString, QVariant> m_defaultSettings;
    KSharedConfig::Ptr m_config;
};

#endif // SETTINGS_H
