#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QApplication>
#include <QQuickWindow>
#include <QThread>
#include <QObject>
#include <signal.h>

#include "radialbar.h"
#include "brewinggraph.h"
#include "countdowntimer.h"
#include "rpidata.h"
#include "websocket.h"
#include "rpithreads.h"

// Enable to remove debug outputs throughout code
//#define QT_NO_DEBUG_OUTPUT

void sigHandler(int s) {
    signal(s, SIG_DFL);
    qDebug() << "[X] Ctrl + C Caught: Quitting...";
    qApp->quit();
}

int main(int argc, char *argv[])
{

    // Disable debug, info, and warning output in Release profile
#ifdef QT_NO_DEBUG_OUTPUT
   qputenv("QT_LOGGING_RULES", "qml=false");
   const char* nullStream = "/dev/null";
   if (!freopen(nullStream, "a", stdout)) assert(false);
   if (!freopen(nullStream, "a", stderr)) assert(false);
#endif

    // Allow file reads inside the qrc files
    qputenv("QML_XHR_ALLOW_FILE_READ", QByteArray("1"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);
    QQuickWindow::setSceneGraphBackend(QSGRendererInterface::OpenGL);

    if (QSysInfo::productType() != "osx") {
        QCursor cursor(Qt::BlankCursor);
        QApplication::setOverrideCursor(cursor);
        QApplication::changeOverrideCursor(cursor);
    }

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // Initalize GPIO
    gpioInitialise();

    RPiData* RPiDataGlobal = new RPiData();
    CountdownTimer* Countdown = new CountdownTimer();

    engine.rootContext()->setContextProperty("RPiData", RPiDataGlobal);
    engine.rootContext()->setContextProperty("CountdownTimer", Countdown);
    qmlRegisterType<RadialBar>("TemperatureRadialBar", 1, 0, "RadialBar");
    qmlRegisterType<BrewingGraph>("BreweryGraph", 1, 0, "BrewingGraph");

    RpiThreads* temperatureWorker = new RpiThreads(RPiDataGlobal);
    QThread* tempThread = new QThread;
    temperatureWorker->moveToThread(tempThread);
    QObject::connect(tempThread, SIGNAL(started()), temperatureWorker, SLOT(processTemps()));
    QObject::connect(tempThread, SIGNAL(finished()), temperatureWorker, SLOT(deleteLater()));
    QObject::connect(&app, &QCoreApplication::aboutToQuit, tempThread, [&tempThread]() {
        tempThread->requestInterruption();
        tempThread->wait();
    }, Qt::DirectConnection);

    RpiThreads* pidHLTWorker = new RpiThreads(RPiDataGlobal);
    QThread* pidHLTThread = new QThread;
    pidHLTWorker->moveToThread(pidHLTThread);
    QObject::connect(pidHLTThread, SIGNAL(started()), pidHLTWorker, SLOT(processPidHLT()));
    QObject::connect(pidHLTThread, SIGNAL(finished()), pidHLTWorker, SLOT(deleteLater()));
    QObject::connect(&app, &QCoreApplication::aboutToQuit, pidHLTThread, [&pidHLTThread]() {
        pidHLTThread->requestInterruption();
        pidHLTThread->wait();
    }, Qt::DirectConnection);

    RpiThreads* pidBOILWorker = new RpiThreads(RPiDataGlobal);
    QThread* pidBOILThread = new QThread;
    pidBOILWorker->moveToThread(pidBOILThread);
    QObject::connect(pidBOILThread, SIGNAL(started()), pidBOILWorker, SLOT(processPidBOIL()));
    QObject::connect(pidBOILThread, SIGNAL(finished()), pidBOILWorker, SLOT(deleteLater()));
    QObject::connect(&app, &QCoreApplication::aboutToQuit, pidBOILThread, [&pidBOILThread]() {
        pidBOILThread->requestInterruption();
        pidBOILThread->wait();
    }, Qt::DirectConnection);

    QObject::connect(pidHLTWorker, SIGNAL(pidHLTValueChanged()), temperatureWorker, SLOT(processPwmHLT()));
    QObject::connect(pidBOILWorker, SIGNAL(pidBOILValueChanged()), temperatureWorker, SLOT(processPwmBOIL()));

    tempThread->start(); // Start main MAX31865 Temperature sensor thread
    pidHLTThread->start(); // HLT PID Thread
    pidBOILThread->start(); // Boil PID Thread

    tempThread->setPriority(QThread::TimeCriticalPriority);
    pidHLTThread->setPriority(QThread::HighPriority);
    pidBOILThread->setPriority(QThread::HighPriority);

    WebSocket client(QUrl(QStringLiteral("ws://20.125.115.180:81")), true, RPiDataGlobal);

    engine.load(url);
    if (engine.rootObjects().isEmpty()) return -1;

    signal(SIGTERM, sigHandler);
    signal(SIGKILL, sigHandler);
    signal(SIGHUP, sigHandler);
    signal(SIGINT, sigHandler);
    signal(SIGQUIT, sigHandler);
    signal(SIGILL, sigHandler);
    signal(SIGTRAP, sigHandler);
    signal(SIGABRT, sigHandler);
    signal(SIGUSR2, sigHandler);

    return app.exec();
}
