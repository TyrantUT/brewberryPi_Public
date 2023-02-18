/**
  ******************************************************************************
  * File Name          : rpicomms.h
  * Description        : Header file for Raspberry Pi Communication to sensors and Contactor / SSR
  ******************************************************************************
  * @attention
**/

#ifndef RPICOMMS_H
#define RPICOMMS_H

#include <pigpio.h>
#include <iostream>
#include <thread>
#include <QThread>
#include <QDebug>

#define QT_DEBUG_ON         false

#define INPUT_MIN           (float)    0.0
#define INPUT_MAX           (float)    100.0
#define OUTPUT_MIN          (float)    0.0
#define OUTPUT_MAX          (float)    255.0


#define MISO                19
#define MOSI                20
#define SCLK                21

#define MAX31865_HLT_GPIO   14
#define MAX31865_MASH_GPIO  15
#define MAX31865_BOIL_GPIO  18
#define MAX31865_MASH2_GPIO 25
#define PWM_HLT             12
#define PWM_BOIL            13
#define ELEMENT_HLT         23
#define ELEMENT_BOIL        24


class RPiComms {


public:
    explicit RPiComms();
    virtual ~RPiComms();

    static void spiSetup(void);
    static void gpioSetup(void);
    static void spiSendByte(uint8_t byte);
    static uint8_t spiReceiveByte(void);
    static void elementOnWrite_HLT(const bool &val);
    static void elementOnWrite_Boil(const bool &val);
};


#endif // RPICOMMS_H
