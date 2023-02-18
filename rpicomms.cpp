/**
  ******************************************************************************
  * File Name          : rpidata.cpp
  * Description        : Radial Bar widget class
  ******************************************************************************
  * @attention
**/

#include "rpicomms.h"

RPiComms::RPiComms() {
}

void RPiComms::spiSetup(void) {

    // Set MISO to Input
    gpioSetMode(MISO, PI_INPUT);

    // Set MOSI to Output and set Low
    gpioSetMode(MOSI, PI_OUTPUT);
    gpioWrite(MOSI, PI_LOW);

    // Set SCLK to Output and set to Low
    gpioSetMode(SCLK, PI_OUTPUT);
    gpioWrite(SCLK, PI_LOW);
}

void RPiComms::gpioSetup(void) {
    // Set Element Output to Low
    gpioSetMode(ELEMENT_HLT, PI_OUTPUT);
    gpioSetMode(ELEMENT_BOIL, PI_OUTPUT);
    gpioWrite(ELEMENT_HLT, PI_HIGH);
    gpioWrite(ELEMENT_BOIL, PI_HIGH);

    // Set PWM Modes
    gpioSetMode(PWM_HLT, PI_OUTPUT);
    gpioSetMode(PWM_BOIL, PI_OUTPUT);
    gpioSetPWMrange(PWM_HLT, OUTPUT_MAX);
    gpioSetPWMrange(PWM_BOIL, OUTPUT_MAX);
    gpioSetPWMrange(PWM_HLT, OUTPUT_MAX);
    gpioSetPWMrange(PWM_BOIL, OUTPUT_MAX);

    // Default PWM to 0
    gpioPWM(PWM_HLT, PI_LOW);
    gpioPWM(PWM_BOIL, PI_LOW);
}

void RPiComms::spiSendByte(uint8_t byte) {

    for (int i = 0; i < 8; i++) {
        gpioWrite(SCLK, PI_HIGH);
        if (byte & 0x80) {
            gpioWrite(MOSI, PI_HIGH);
        } else {
            gpioWrite(MOSI, PI_LOW);
        }
        byte <<= 1;
        gpioWrite(SCLK, PI_LOW);

        QThread::usleep(500);
    }
}

uint8_t RPiComms::spiReceiveByte(void) {
    uint8_t byte = 0x00;

    for (int i = 0; i < 8; i++) {
        gpioWrite(SCLK, PI_HIGH);
        byte <<= 1;
        if (gpioRead(MISO)) {
            byte |= 0x1;
        }
        gpioWrite(SCLK, PI_LOW);

        QThread::usleep(500);
    }

    return byte;
}

// To account for the element being on while the Pi boots
// Wiring for NO; Write Low to turn on, High to turn off
void RPiComms::elementOnWrite_HLT(const bool &val) {
    if (QT_DEBUG_ON) {
        qDebug() << "Setting HLT Element to ON" << val;
    }

    if (val) {
        gpioWrite(ELEMENT_BOIL, PI_LOW);
    } else {
        gpioWrite(ELEMENT_BOIL, PI_HIGH);
    }
}

void RPiComms::elementOnWrite_Boil(const bool &val) {
    if (QT_DEBUG_ON) {
       qDebug() << "Setting Boil Element to ON" << val;
    }

    if (val) {
        gpioWrite(ELEMENT_BOIL, PI_LOW);
    } else {
        gpioWrite(ELEMENT_BOIL, PI_HIGH);
    }
}

RPiComms::~RPiComms() {
    gpioTerminate();
}
