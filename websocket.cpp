#include "websocket.h"

QT_USE_NAMESPACE

WebSocket::WebSocket(const QUrl &url, bool debug, RPiData *RPiDataGlobal, QObject *parent) :
        QObject(parent),
        m_url(url),
        m_rpiDataGlobal(RPiDataGlobal),
        m_debug(debug)
{
    if (m_debug)
        qDebug() << "Web Socket Server" << url;
    connect(&m_webSocket, &QWebSocket::connected, this, &WebSocket::onConnected);
    connect(&m_webSocket, &QWebSocket::disconnected, this, &WebSocket::socketDisconnected);

    m_webSocket.open(QUrl(url));
}

void WebSocket::onConnected() {
    if (m_debug)
        qDebug() << "Web Socket Connected";

    connect(websocketTimer, SIGNAL(timeout()), this, SLOT(sendWebSocketMessage()));
    websocketTimer->start(1000);
}

void WebSocket::socketDisconnected() {
    if (m_debug)
        qDebug() << "socketDisconnected:" << m_webSocket.errorString();
    if ((m_webSocket.state() == QAbstractSocket::UnconnectedState))
        m_webSocket.open(QUrl(m_url));
}

void WebSocket::sendWebSocketMessage() {
    QByteArray Data = processData(m_rpiDataGlobal);
    m_webSocket.sendTextMessage(Data);
}

QByteArray WebSocket::processData(RPiData *RPiDataGlobal) {

    volatile float tempmax_hlt = RPiDataGlobal->getTempMAXHLT();
    volatile float tempmax_mash = RPiDataGlobal->getTempMAXMash();
    volatile float tempmax_mash2 = RPiDataGlobal->getTempMAXMash2();
    volatile float tempmax_boil = RPiDataGlobal->getTempMAXBoil();
    QString faultText_hlt = RPiDataGlobal->getFaultText_HLT();
    QString faultText_mash = RPiDataGlobal->getFaultText_Mash();
    QString faultText_mash2 = RPiDataGlobal->getFaultText_Mash2();
    QString faultText_boil = RPiDataGlobal->getFaultText_Boil();
    volatile float setpoint_hlt = RPiDataGlobal->getSetpointHLT();
    volatile float setpoint_mash = RPiDataGlobal->getSetpointMash();
    volatile float setpoint_boil = RPiDataGlobal->getSetpointBoil();
    volatile bool elementon_hlt = RPiDataGlobal->getElementOnHLT();
    volatile bool elementon_boil = RPiDataGlobal->getElementOnBoil();
    float pwmduty_hlt = RPiDataGlobal->getPWMDutyHLT();
    float pwmduty_boil = RPiDataGlobal->getPWMDutyBoil();
    bool brewery_mode = RPiDataGlobal->getBreweryMode();

    QJsonObject getData;

    getData.insert("tempmax_hlt", tempmax_hlt);
    getData.insert("tempmax_mash", tempmax_mash);
    getData.insert("tempmax_mash2", tempmax_mash2);
    getData.insert("tempmax_boil", tempmax_boil);
    getData.insert("faultText_hlt", faultText_hlt);
    getData.insert("faultText_mash", faultText_mash);
    getData.insert("faultText_mash2", faultText_mash2);
    getData.insert("faultText_boil", faultText_boil);
    getData.insert("setpoint_hlt", setpoint_hlt);
    getData.insert("setpoint_mash", setpoint_mash);
    getData.insert("setpoint_boil", setpoint_boil);
    getData.insert("elementon_hlt", elementon_hlt);
    getData.insert("elementon_boil", elementon_boil);
    getData.insert("pwmduty_hlt", pwmduty_hlt);
    getData.insert("pwmduty_boil", pwmduty_boil);
    getData.insert("brewery_mode", brewery_mode);

    QJsonDocument doc(getData);
    QString getDataJson(doc.toJson(QJsonDocument::Compact));
    QByteArray getDataBytes = getDataJson.toUtf8();

    return getDataBytes;
}
