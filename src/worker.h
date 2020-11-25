/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef WORKER_H
#define WORKER_H

#include <QObject>
#include <KFileMetaData/Properties>

class Worker : public QObject
{
    Q_OBJECT
public:
    Worker() = default;
    ~Worker() = default;

    static Worker* instance();

signals:
    void metaDataReady(int index, KFileMetaData::PropertyMap metadata);

public slots:
    void getMetaData(int index, const QString &path);

private:
    static Worker *sm_worker;
};

#endif // WORKER_H
