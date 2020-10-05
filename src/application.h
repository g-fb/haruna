/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QAction>
#include <KActionCollection>
#include <KSharedConfig>
#include <QAbstractItemModel>

class HarunaSettings;
class KActionCollection;
class KConfigDialog;
class KColorSchemeManager;
class QAction;

class Application : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QAbstractItemModel* colorSchemesModel READ colorSchemesModel CONSTANT)

public:
    explicit Application(QObject *parent = nullptr);
    ~Application() = default;

public slots:
    static QString formatTime(const double time);
    static QUrl getPathFromArg(const QString &arg);
    static void hideCursor();
    static void showCursor();
    void addArgument(int key, const QString &value);
    void configureShortcuts();
    QString argument(int key);
    QAction* action(const QString &name);
    QString getFileContent(QString file);
    void activateColorScheme(const QString &name);
private:
    QAbstractItemModel *colorSchemesModel();
    void setupActions(const QString &actionName);
    KActionCollection m_collection;
    KSharedConfig::Ptr m_config;
    KConfigGroup *m_shortcuts;
    QMap<int, QString> m_args;
    KColorSchemeManager *m_schemes;

};

#endif // APPLICATION_H
