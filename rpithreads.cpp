/**
  ******************************************************************************
  * File Name          : rpithreads.cpp
  * Description        : Raspberry Pi / QT Threads class
  ******************************************************************************
  * @attention
**/

#include "rpithreads.h"


static float mapPWM(float input) {
    return 1.0 * OUTPUT_MIN + \
            ((OUTPUT_MAX - OUTPUT_MIN) / (INPUT_MAX - INPUT_MIN)) \
            * (input - INPUT_MIN);
}

RpiThreads::RpiThreads(RPiData *RPiDataGlobal, QObject *parent) :
    QObject(parent),
    m_rpiDataGlobal(RPiDataGlobal)
{
}

RpiThreads::~RpiThreads() { }

void RpiThreads::processTemps() {

    MAX31865 MAX31865_hlt(MAX31865_HLT_GPIO);
    MAX31865 MAX31865_mash(MAX31865_MASH_GPIO);
    MAX31865 MAX31865_boil(MAX31865_BOIL_GPIO);
    MAX31865 MAX31865_mash2(MAX31865_MASH2_GPIO);

    if (QT_DEBUG_ON) {
        qDebug() << "[DEBUG - MAX31865 Thread] MAX31865 Initialized.";
        qDebug() << "[DEBUG - MAX31865 Thread] MAX31865 Temperature Thread Starting";
    }

    while(!QThread::currentThread()->isInterruptionRequested()) {

        static volatile float tempHLT_F = 0.0f;
        static volatile float tempMASH_F = 0.0f;
        static volatile float tempBOIL_F = 0.0f;
        static volatile float tempMASH2_F = 0.0f;

        // HLT
        MAX31865_hlt.MAX31865_readTemp();
        tempHLT_F = MAX31865_hlt.MAX31865_tempF();


        if (QT_DEBUG_ON) {
            qDebug() << "[DEBUG - MAX31865 Thread] HLT Temp: " << tempHLT_F;
            qDebug() << "[DEBUG - MAX31865 Thread] HLT Fault: " << MAX31865_hlt.MAX31865_faultText();
        }

        // Set the variables in the RPi Data class
        m_rpiDataGlobal->setTempMAXHLT(tempHLT_F);
        m_rpiDataGlobal->setFaultText_HLT(QString(MAX31865_hlt.MAX31865_faultText()));

        // MASH
        MAX31865_mash.MAX31865_readTemp();
        tempMASH_F = MAX31865_mash.MAX31865_tempF();

        if (QT_DEBUG_ON) {
            qDebug() << "[DEBUG - MAX31865 Thread] Mash Temp: " << tempMASH_F;
            qDebug() << "[DEBUG - MAX31865 Thread] Mash Fault: " << MAX31865_mash.MAX31865_faultText();
        }

        // Set the variables in the RPi Data class
        m_rpiDataGlobal->setTempMAXMash(tempMASH_F);
        m_rpiDataGlobal->setFaultText_Mash(QString(MAX31865_mash.MAX31865_faultText()));

        // BOIL
        MAX31865_boil.MAX31865_readTemp();
        tempBOIL_F = MAX31865_boil.MAX31865_tempF();

        if (QT_DEBUG_ON) {
            qDebug() << "[DEBUG - MAX31865 Thread] BOIL Temp: " << tempBOIL_F;
            qDebug() << "[DEBUG - MAX31865 Thread] BOIL Fault: " << MAX31865_boil.MAX31865_faultText();
        }

        // Set the variables in the RPi Data class
        m_rpiDataGlobal->setTempMAXBoil(tempBOIL_F);
        m_rpiDataGlobal->setFaultText_Boil(QString(MAX31865_boil.MAX31865_faultText()));

        // MASH2
        MAX31865_mash2.MAX31865_readTemp();
        tempMASH2_F = MAX31865_mash2.MAX31865_tempF();

        if (QT_DEBUG_ON) {
            qDebug() << "[DEBUG - MAX31865 Thread] Mash2 Temp: " << tempMASH2_F;
            qDebug() << "[DEBUG - MAX31865 Thread] Mash2 Fault: " << MAX31865_mash2.MAX31865_faultText();
        }

        // Set the variables in the RPi Data class
        m_rpiDataGlobal->setTempMAXMash2(tempMASH2_F);
        m_rpiDataGlobal->setFaultText_Mash2(QString(MAX31865_mash2.MAX31865_faultText()));
    }

    QThread::currentThread()->quit();
}

void RpiThreads::processPidHLT() {

    PIDController PIDController_HLT;

    // Initialize HLT PID
    PIDController_HLT.PIDInit(PID_Kp,
                              PID_Ki,
                              PID_Kd,
                              PID_sampleTime,
                              PID_minOutput,
                              PID_maxOutput,
                              PIDController_HLT.AUTOMATIC,
                              PIDController_HLT.DIRECT);

    if (QT_DEBUG_ON) {
        qDebug() << "[DEBUG - PID Controller Thread - HLT / MASH] PID Initalized.\n";
    }


    while(!QThread::currentThread()->isInterruptionRequested()) {

        volatile float tempMAXHLT = m_rpiDataGlobal->getTempMAXHLT();
        volatile float tempMAXMash = m_rpiDataGlobal->getTempMAXMash();
        volatile float setpointHLT = m_rpiDataGlobal->getSetpointHLT();
        volatile float setpointMash = m_rpiDataGlobal->getSetpointMash();
        volatile bool elementOnHLT = m_rpiDataGlobal->getElementOnHLT();
        volatile bool pidModeHLT = m_rpiDataGlobal->getPIDModeHLT();
        volatile bool pidModeMash = m_rpiDataGlobal->getPIDModeMash();
        volatile bool breweryMode = m_rpiDataGlobal->getBreweryMode();

        // One PID controller for both the HLT and Mash modes since the HLT controls both
        // Set HLT PID Mode to Automatic if either HLT or Mash are False
        if (pidModeHLT == false || pidModeMash == false) {
            PIDController_HLT.PIDModeSet(PIDController_HLT.AUTOMATIC);
        }

        // Set HLT PID Mode to Manual if either HLT or Mash are True
        if (pidModeHLT == true || pidModeMash == true) {
            PIDController_HLT.PIDModeSet(PIDController_HLT.MANUAL);
        }

        // Check if the HLT element is On
        if (elementOnHLT) {
            // Check if the mode is Automatic
            if (PIDController_HLT.PIDModeGet() == PIDController_HLT.AUTOMATIC) {
                // Check if the Brewery Mode is HLT (true) or Mash (false)
                if (breweryMode == false) {
                    PIDController_HLT.PIDInputSet(tempMAXHLT);
                    PIDController_HLT.PIDSetpointSet(setpointHLT);
                    PIDController_HLT.PIDCompute();
                    m_rpiDataGlobal->setPWMDutyHLT(CONSTRAIN(PIDController_HLT.PIDOutputGet(), 0, 100.0));
                } else {
                    PIDController_HLT.PIDInputSet(tempMAXMash);
                    PIDController_HLT.PIDSetpointSet(setpointMash);
                    PIDController_HLT.PIDCompute();
                    m_rpiDataGlobal->setPWMDutyHLT(CONSTRAIN(PIDController_HLT.PIDOutputGet(), 0, 100.0));
                }
            }

            // Check if the PID Mode is set to Manual
            if (PIDController_HLT.PIDModeGet() == PIDController_HLT.MANUAL) {
                // If the brewery is set HLT (true) or Mash (false), constrain and set the appropriate setpoint
                if (breweryMode == false) {
                    m_rpiDataGlobal->setPWMDutyHLT(CONSTRAIN(setpointHLT, 0, 100.0));
                } else {
                    m_rpiDataGlobal->setPWMDutyHLT(CONSTRAIN(setpointMash, 0, 100.0));
                }
            }
        }

        // If the HLT element is Off, set the PWM to 0 to force no output
        else {
            m_rpiDataGlobal->setPWMDutyHLT(0.0);
        }

        emit pidHLTValueChanged();

        QThread::msleep(500);
    }

    QThread::currentThread()->quit();
}

void RpiThreads::processPidBOIL() {
    PIDController PIDController_BOIL;

    // Initialize BOIL PID
    PIDController_BOIL.PIDInit(PID_Kp,
                               PID_Ki,
                               PID_Kd,
                               PID_sampleTime,
                               PID_minOutput,
                               PID_maxOutput,
                               PIDController_BOIL.AUTOMATIC,
                               PIDController_BOIL.DIRECT);

    if (QT_DEBUG_ON) {
       qDebug() << "[DEBUG - PID Controller Thread - BOIL] PID Initalized.\n";
    }

    while(!QThread::currentThread()->isInterruptionRequested()) {

        volatile float tempMAXBoil = m_rpiDataGlobal->getTempMAXBoil();
        volatile float setpointBoil = m_rpiDataGlobal->getSetpointBoil();
        volatile bool elementOnBoil = m_rpiDataGlobal->getElementOnBoil();
        volatile bool pidModeBoil = m_rpiDataGlobal->getPIDModeBoil();

        // Set the PID Mode and se to Automatic or Manual
        if (pidModeBoil == false) {
            PIDController_BOIL.PIDModeSet(PIDController_BOIL.AUTOMATIC);
        } else {
            PIDController_BOIL.PIDModeSet(PIDController_BOIL.MANUAL);
        }

        // Check whether the Boil element is on
        if (elementOnBoil) {
            if (PIDController_BOIL.PIDModeGet() == PIDController_BOIL.AUTOMATIC) {
                PIDController_BOIL.PIDInputSet(tempMAXBoil);
                PIDController_BOIL.PIDSetpointSet(setpointBoil);
                PIDController_BOIL.PIDCompute();
                m_rpiDataGlobal->setPWMDutyBoil(CONSTRAIN(PIDController_BOIL.PIDOutputGet(), 0, 100.0));
            }

            if (PIDController_BOIL.PIDModeGet() == PIDController_BOIL.MANUAL) {
                m_rpiDataGlobal->setPWMDutyBoil(CONSTRAIN(setpointBoil, 0, 100));
            }
        }

        // If the Boil element is Off, set the PWM to 0 to force no output
        else {
            m_rpiDataGlobal->setPWMDutyBoil(0.0);
        }

        emit pidBOILValueChanged();

        QThread::msleep(500);
    }

    QThread::currentThread()->quit();
}

void RpiThreads::processPwmHLT() {

    // Check if the element is on
    if (m_rpiDataGlobal->getElementOnHLT()) {
        dutyCycle_HLT = mapPWM(m_rpiDataGlobal->getPWMDutyHLT());
        if ((dutyCycle_HLT != dutyCycleLast_HLT)) {
            gpioPWM(PWM_HLT, dutyCycle_HLT);
            dutyCycleLast_HLT = dutyCycle_HLT;
        }
    }

    // If not, reset the PWM to 0 so were not getting any output
    else {
        gpioPWM(PWM_HLT, PI_LOW);
    }
}

void RpiThreads::processPwmBOIL() {

    // Check if the element is on
    if (m_rpiDataGlobal->getElementOnBoil()) {
       dutyCycle_Boil = mapPWM(m_rpiDataGlobal->getPWMDutyBoil());
       if ((dutyCycle_Boil != dutyCycleLast_Boil)) {
           gpioPWM(PWM_BOIL, dutyCycle_Boil);
           dutyCycleLast_Boil = dutyCycle_Boil;
       }
    }

    // If not, reset the PWM to 0 so were not getting any output
    else {
        gpioPWM(PWM_BOIL, PI_LOW);
    }
}
