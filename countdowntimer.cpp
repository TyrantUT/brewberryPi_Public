/**
  ******************************************************************************
  * File Name          : countdowntimer.cpp
  * Description        : CountdownTimer Class for Timer on Page2Forum
  ******************************************************************************
  * @attention
**/

#include "countdowntimer.h"

CountdownTimer::CountdownTimer()
{
    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(update()));
}

void CountdownTimer::setStartTime(int value) {
    if (m_startTime == value)
        return;
    m_startTime = value;

    emit startTimeChanged();
}

void CountdownTimer::start(void) {
    if (m_startTime != 0) {
        m_elapsed = m_startTime;
        m_running = true;
        timer->start(1000);

        emit runningChanged();
    }
}

void CountdownTimer::stop(void) {
    m_running = false;
    timer->stop();

    if (m_startTime != 0) {
        m_startTime = m_elapsed;
    }

    emit runningChanged();
}

void CountdownTimer::update(void) {
    m_elapsed -= 1;

    if (m_elapsed == 0) {
        timer->stop();
    }

    emit elapsedChanged();
}
