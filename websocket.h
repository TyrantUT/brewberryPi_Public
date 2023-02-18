#ifndef WEBSOCKET_H
#define WEBSOCKET_H

#include <QDebug>
#include <QWebSocket>
#include <QJsonObject>
#include <QJsonDocument>
#include <QTimer>
#include "rpidata.h"

class WebSocket : public QObject
{
    Q_OBJECT

public:
    explicit WebSocket(const QUrl &url, bool debug = false, RPiData *RPiDataGlobal = nullptr, QObject *parent = nullptr);
    QTimer *websocketTimer = new QTimer(this);
    QByteArray processData(RPiData *RPiDataGlobal);

Q_SIGNALS:
    void closed();

private Q_SLOTS:
    void onConnected();
    void sendWebSocketMessage();
    void socketDisconnected();

private:
    QWebSocket m_webSocket;
    QUrl m_url;
    RPiData *m_rpiDataGlobal;
    bool m_debug;
};

#endif // WEBSOCKET_H
