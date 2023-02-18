#ifndef COUNTDOWNTIMER_H
#define COUNTDOWNTIMER_H

/**
  ******************************************************************************
  * File Name          : countdowntimer.h
  * Description        : Header file for Countdown Timer in Page2Form
  ******************************************************************************
  * @attention
**/

#include <QObject>
#include <QTime>
#include <QTimer>

class CountdownTimer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int startTime READ getStartTime WRITE setStartTime NOTIFY startTimeChanged)
    Q_PROPERTY(bool running READ getRunning NOTIFY runningChanged)
    Q_PROPERTY(float elapsed READ getElapsed NOTIFY elapsedChanged)

public:
    CountdownTimer() ;

    int getStartTime(void) const {return m_startTime;}
    bool getRunning(void) const {return m_running;}
    int getElapsed(void) const {return m_elapsed;}

public slots:
    void setStartTime(int value);
    void start(void);
    void stop(void);
    void update(void);

signals:
    void startTimeChanged();
    void runningChanged();
    void elapsedChanged();

private:
    QTimer *timer;
    int m_startTime = 0;
    bool m_running = false;
    int m_elapsed = 0;
};

#endif // COUNTDOWNTIMER_H
