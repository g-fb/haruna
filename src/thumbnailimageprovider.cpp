/*
 * SPDX-FileCopyrightText: 2021 George Florea Bănuș <georgefb899@gmail.com>
 *
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

#include "_debug.h"
#include "thumbnailimageprovider.h"

#include <KIO/PreviewJob>
#include <QIcon>
#include <QMimeDatabase>

ThumbnailImageProvider::ThumbnailImageProvider()
{
    qRegisterMetaType<KFileItem>("KFileItem");
}

QQuickImageResponse *ThumbnailImageProvider::requestImageResponse(const QString& id, const QSize& requestedSize)
{
    auto response = new ThumbnailResponse(id, requestedSize);
    return response;
}


ThumbnailResponse::ThumbnailResponse(const QString &id, const QSize &requestedSize)
{
    getPreview(id, requestedSize);
}

void ThumbnailResponse::getPreview(const QString &id, const QSize &requestedSize)
{
    auto file = QUrl::fromPercentEncoding(id.toUtf8()).toUtf8();
    if(QFile(file).exists()) {
        QMimeDatabase db;
        QString mimetype = db.mimeTypeForFile(file).name();

        QStringList allPlugins{KIO::PreviewJob::availablePlugins()};
        auto list = KFileItemList() << KFileItem(QUrl::fromLocalFile(file), mimetype);
        auto job = new KIO::PreviewJob(list, requestedSize, &allPlugins);

        connect(job, &KIO::PreviewJob::gotPreview, this,
                [this] (const KFileItem &item, const QPixmap &pixmap) {
            Q_UNUSED(item);
            m_texture = QQuickTextureFactory::textureFactoryForImage(pixmap.toImage());
            emit finished();
        }, Qt::QueuedConnection);

        connect(job, &KIO::PreviewJob::failed, this, [=] (const KFileItem &item) {
            Q_UNUSED(item);
            DEBUG << "Failed to create thumbnail";
        });
    }
    if (QUrl(id).scheme() == "http" || QUrl(id).scheme() == "https") {
        QStringList allPlugins{KIO::PreviewJob::availablePlugins()};
        auto list = KFileItemList() << KFileItem(QUrl(file));
        auto job = new KIO::PreviewJob(list, requestedSize, &allPlugins);

        connect(job, &KIO::PreviewJob::gotPreview, this,
                [this] (const KFileItem &item, const QPixmap &pixmap) {
            Q_UNUSED(item);
            m_texture = QQuickTextureFactory::textureFactoryForImage(pixmap.toImage());
            emit finished();
        }, Qt::QueuedConnection);

        connect(job, &KIO::PreviewJob::failed, this, [=] (const KFileItem &item) {
            Q_UNUSED(item);
            auto icon = QIcon::fromTheme("im-youtube", QIcon::fromTheme("video-x-generic"));
            m_texture = QQuickTextureFactory::textureFactoryForImage(icon.pixmap(requestedSize).toImage());
            emit finished();
        });
    }
}

QQuickTextureFactory *ThumbnailResponse::textureFactory() const
{
    return m_texture;
}
