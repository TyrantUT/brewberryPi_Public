/**
  ******************************************************************************
  * File Name          : rpidata.h
  * Description        : Header file for Raspberry Pi / QT Data
  ******************************************************************************
  * @attention
**/

#ifndef RPIDATA_H
#define RPIDATA_H

#include <QObject>
#include "rpicomms.h"

typedef struct RPiData_t {
    float tempmax_hlt = 0.0f;
    float tempmax_mash = 0.0f;
    float tempmax_mash2 = 0.0f;
    float tempmax_boil = 0.0f;
    QString faultText_hlt = "";
    QString faultText_mash = "";
    QString faultText_mash2 = "";
    QString faultText_boil = "";
    float setpoint_hlt = 0.0f;
    float setpoint_mash = 0.0f;
    float setpoint_boil = 0.0f;
    bool elementon_hlt = false;
    bool elementon_boil = false;
    bool pidmode_hlt = false;
    bool pidmode_mash = false;
    bool pidmode_boil = false;
    float pwmduty_hlt = 0.0f;
    float pwmduty_boil = 0.0f;
    bool brewery_mode = false;
    bool brewery_reset = false;
} RPiData_t;

class RPiData : public QObject
{
    Q_OBJECT
    Q_PROPERTY (float tempmax_hlt READ getTempMAXHLT NOTIFY tempMAXHLTChanged)
    Q_PROPERTY (float tempmax_mash READ getTempMAXMash NOTIFY tempMAXMashChanged)
    Q_PROPERTY (float tempmax_boil READ getTempMAXBoil NOTIFY tempMAXBoilChanged)
    Q_PROPERTY (float tempmax_mash2 READ getTempMAXMash2 NOTIFY tempMAXMash2Changed)
    Q_PROPERTY (QString faultText_hlt READ getFaultText_HLT NOTIFY faultText_HLTChanged)
    Q_PROPERTY (QString faultText_mash READ getFaultText_Mash NOTIFY faultText_MashChanged)
    Q_PROPERTY (QString faultText_boil READ getFaultText_Boil NOTIFY faultText_BoilChanged)
    Q_PROPERTY (QString faultText_mash2 READ getFaultText_Mash2 NOTIFY faultText_Mash2Changed)
    Q_PROPERTY (float setpoint_hlt READ getSetpointHLT WRITE setSetpointHLT NOTIFY setpointHLTChanged)
    Q_PROPERTY (float setpoint_mash READ getSetpointMash WRITE setSetpointMash NOTIFY setpointMashChanged)
    Q_PROPERTY (float setpoint_boil READ getSetpointBoil WRITE setSetpointBoil NOTIFY setpointBoilChanged)
    Q_PROPERTY (bool elemenon_hlt READ getElementOnHLT WRITE setElementOnHLT NOTIFY elementOnHLTChanged)
    Q_PROPERTY (bool elementon_boil READ getElementOnBoil WRITE setElementOnBoil NOTIFY elementOnBoilChanged)
    Q_PROPERTY (bool pidmode_hlt READ getPIDModeHLT WRITE setPIDModeHLT NOTIFY pidModeHLTChanged)
    Q_PROPERTY (bool pidmode_mash READ getPIDModeMash WRITE setPIDModeMash NOTIFY pidModeMashChanged)
    Q_PROPERTY (bool pidmode_boil READ getPIDModeBoil WRITE setPIDModeBoil NOTIFY pidModeBoilChanged)
    Q_PROPERTY (float pwmduty_hlt READ getPWMDutyHLT NOTIFY pwmDutyHLTChanged)
    Q_PROPERTY (float pwmduty_boil READ getPWMDutyBoil NOTIFY pwmDutyBoilChanged)
    Q_PROPERTY (bool brewery_mode READ getBreweryMode WRITE setBreweryMode NOTIFY breweryModeChanged)
    Q_PROPERTY (bool brewery_reset READ getBreweryReset WRITE setBreweryReset NOTIFY breweryResetChanged)

public:
    RPiData();
    virtual ~RPiData();

    float getTempMAXHLT(void) const {return RPiDataStruct.tempmax_hlt;}
    float getTempMAXMash(void) const {return RPiDataStruct.tempmax_mash;}
    float getTempMAXBoil(void) const {return RPiDataStruct.tempmax_boil;}
    float getTempMAXMash2(void) const {return RPiDataStruct.tempmax_mash2;}
    QString getFaultText_HLT(void) const {return RPiDataStruct.faultText_hlt;}
    QString getFaultText_Mash(void) const {return RPiDataStruct.faultText_mash;}
    QString getFaultText_Mash2(void) const {return RPiDataStruct.faultText_mash2;}
    QString getFaultText_Boil(void) const {return RPiDataStruct.faultText_boil;}
    float getSetpointHLT(void) const {return RPiDataStruct.setpoint_hlt;}
    float getSetpointMash(void) const {return RPiDataStruct.setpoint_mash;}
    float getSetpointBoil(void) const {return RPiDataStruct.setpoint_boil;}
    bool getElementOnHLT(void) const {return RPiDataStruct.elementon_hlt;}
    bool getElementOnBoil(void) const {return RPiDataStruct.elementon_boil;}
    bool getPIDModeHLT(void) const {return RPiDataStruct.pidmode_hlt;}
    bool getPIDModeMash(void) const {return RPiDataStruct.pidmode_mash;}
    bool getPIDModeBoil(void) const {return RPiDataStruct.pidmode_boil;}
    float getPWMDutyHLT(void) const {return RPiDataStruct.pwmduty_hlt;}
    float getPWMDutyBoil(void) const {return RPiDataStruct.pwmduty_boil;}
    bool getBreweryMode(void) const {return RPiDataStruct.brewery_mode;}
    bool getBreweryReset(void) const {return RPiDataStruct.brewery_reset;}

public slots:
    void setTempMAXHLT(float value);
    void setTempMAXMash(float value);
    void setTempMAXMash2(float value);
    void setTempMAXBoil(float value);
    void setFaultText_HLT(QString string);
    void setFaultText_Mash(QString string);
    void setFaultText_Mash2(QString string);
    void setFaultText_Boil(QString string);
    void setSetpointHLT(float value);
    void setSetpointMash(float value);
    void setSetpointBoil(float value);
    void setElementOnHLT(bool value);
    void setElementOnBoil(bool value);    
    void setPIDModeHLT(bool value);
    void setPIDModeMash(bool value);
    void setPIDModeBoil(bool value);
    void setPWMDutyHLT(float value);
    void setPWMDutyBoil(float value);
    void setBreweryMode(bool value);
    void setBreweryReset(bool value);

signals:
    void tempMAXHLTChanged();
    void tempMAXMashChanged();
    void tempMAXMash2Changed();
    void tempMAXBoilChanged();
    void faultText_HLTChanged();
    void faultText_MashChanged();
    void faultText_Mash2Changed();
    void faultText_BoilChanged();
    void setpointHLTChanged();
    void setpointMashChanged();
    void setpointBoilChanged();    
    void elementOnHLTChanged();
    void elementOnBoilChanged();
    void pidModeHLTChanged();
    void pidModeMashChanged();
    void pidModeBoilChanged();    
    void pwmDutyHLTChanged();
    void pwmDutyBoilChanged();
    void breweryModeChanged();
    void breweryResetChanged();

private:
    RPiData_t RPiDataStruct;
};

#endif // RPIDATA_H
