/**
  ******************************************************************************
  * File Name          : rpithreads.h
  * Description        : Raspberry Pi / QT Threads class Header file
  ******************************************************************************
  * @attention
**/

#ifndef RPITHREADS_H
#define RPITHREADS_H

#include "rpidata.h"
#include "max31865.h"
#include "pidcontroller.h"

class RpiThreads : public QObject
{
    Q_OBJECT

public:
    explicit RpiThreads(RPiData *RPiDataGlobal = nullptr, QObject *parent = nullptr);
    virtual ~RpiThreads();

public slots:
    void processTemps(void);
    void processPidHLT(void);
    void processPidBOIL(void);
    void processPwmHLT(void);
    void processPwmBOIL(void);

private:
    RPiData *m_rpiDataGlobal;

    // PID Initial values
    float PID_Kp = 1;
    float PID_Ki = 1;
    float PID_Kd = 50;
    float PID_minOutput = 0;
    float PID_maxOutput = 100;
    float PID_sampleTime = .5;

    // PWM Duty Cycle Values
    volatile float dutyCycle_HLT = 0.0;
    volatile float dutyCycle_Boil = 0.0;
    volatile float dutyCycleLast_HLT = 0.0;
    volatile float dutyCycleLast_Boil = 0.0;

signals:
    void pidHLTValueChanged(void);
    void pidBOILValueChanged(void);
};

#endif // RPITHREADS_H
