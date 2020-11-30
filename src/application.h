/*
 * SPDX-FileCopyrightText: 2020 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#ifndef APPLICATION_H
#define APPLICATION_H

#include <QObject>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QAction>
#include <KActionCollection>
#include <KSharedConfig>
#include <QAbstractItemModel>
#include <KAboutData>

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
    explicit Application(int &argc, char **argv, const QString &applicationName);
    ~Application();

    void setupQmlSettingsTypes();

    int run();
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
    void registerQmlTypes();
    void aboutApplication();
    void setupAboutData();
    void setupCommandLineParser();
    void setupActions(const QString &actionName);
    QApplication *m_app;
    QQmlApplicationEngine *m_engine;
    KAboutData m_aboutData;
    KActionCollection m_collection;
    KSharedConfig::Ptr m_config;
    KConfigGroup *m_shortcuts;
    QMap<int, QString> m_args;
    KColorSchemeManager *m_schemes;
    void setupQmlContextProperties();
    void setupWorkerThread();
};

#endif // APPLICATION_H
