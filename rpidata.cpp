/**
  ******************************************************************************
  * File Name          : rpidata.cpp
  * Description        : Raspberry Pi / QT Data class
  ******************************************************************************
  * @attention
**/

#include "rpidata.h"

RPiData::RPiData() {
    RPiComms::spiSetup();
    RPiComms::gpioSetup();
}

void RPiData::setTempMAXHLT(float value) {
    if (RPiDataStruct.tempmax_hlt == value)
        return;
    RPiDataStruct.tempmax_hlt = value;
    emit tempMAXHLTChanged();
}

void RPiData::setTempMAXMash(float value) {
    if (RPiDataStruct.tempmax_mash == value)
        return;
    RPiDataStruct.tempmax_mash = value;

    emit tempMAXMashChanged();
}

void RPiData::setTempMAXMash2(float value) {
    if (RPiDataStruct.tempmax_mash2 == value)
        return;
    RPiDataStruct.tempmax_mash2 = value;

    emit tempMAXMash2Changed();
}

void RPiData::setTempMAXBoil(float value) {
    if (RPiDataStruct.tempmax_boil == value)
        return;
    RPiDataStruct.tempmax_boil = value;

    emit tempMAXBoilChanged();
}

void RPiData::setFaultText_HLT(QString string) {
    if (RPiDataStruct.faultText_hlt == string)
        return;
    RPiDataStruct.faultText_hlt = string;

    emit faultText_HLTChanged();
}

void RPiData::setFaultText_Mash(QString string) {
    if (RPiDataStruct.faultText_mash == string)
        return;
    RPiDataStruct.faultText_mash = string;

    emit faultText_MashChanged();
}

void RPiData::setFaultText_Mash2(QString string) {
    if (RPiDataStruct.faultText_mash2 == string)
        return;
    RPiDataStruct.faultText_mash2 = string;

    emit faultText_Mash2Changed();
}

void RPiData::setFaultText_Boil(QString string) {
    if (RPiDataStruct.faultText_boil == string)
        return;
    RPiDataStruct.faultText_boil = string;

    emit faultText_BoilChanged();
}

void RPiData::setSetpointHLT(float value) {
    if (RPiDataStruct.setpoint_hlt == value)
        return;
    RPiDataStruct.setpoint_hlt = value;

    emit setpointHLTChanged();
}

void RPiData::setSetpointMash(float value) {
    if (RPiDataStruct.setpoint_mash == value)
        return;
    RPiDataStruct.setpoint_mash = value;

    emit setpointMashChanged();
}

void RPiData::setSetpointBoil(float value) {
    if (RPiDataStruct.setpoint_boil == value)
        return;
    RPiDataStruct.setpoint_boil = value;

    emit setpointBoilChanged();
}

void RPiData::setElementOnHLT(bool value) {
    if (RPiDataStruct.elementon_hlt == value)
        return;
    RPiDataStruct.elementon_hlt = value;

    RPiComms::elementOnWrite_HLT(value);
    emit elementOnHLTChanged();
}

void RPiData::setElementOnBoil(bool value) {
    if (RPiDataStruct.elementon_boil == value)
        return;
    RPiDataStruct.elementon_boil = value;

    RPiComms::elementOnWrite_Boil(value);
    emit elementOnBoilChanged();
}

void RPiData::setPIDModeHLT(bool value) {
    if (RPiDataStruct.pidmode_hlt == value)
        return;
    RPiDataStruct.pidmode_hlt = value;

    emit pidModeHLTChanged();
}

void RPiData::setPIDModeMash(bool value) {
    if (RPiDataStruct.pidmode_mash == value)
        return;
    RPiDataStruct.pidmode_mash = value;

    emit pidModeMashChanged();
}

void RPiData::setPIDModeBoil(bool value) {
    if (RPiDataStruct.pidmode_boil == value)
        return;
    RPiDataStruct.pidmode_boil = value;

    emit pidModeBoilChanged();
}

void RPiData::setPWMDutyHLT(float value) {
    if (RPiDataStruct.pwmduty_hlt == value)
        return;
    RPiDataStruct.pwmduty_hlt = value;

    emit pwmDutyHLTChanged();
}

void RPiData::setPWMDutyBoil(float value) {
    if (RPiDataStruct.pwmduty_boil == value)
        return;
    RPiDataStruct.pwmduty_boil = value;

    emit pwmDutyBoilChanged();
}

void RPiData::setBreweryMode(bool value) {
    if (RPiDataStruct.brewery_mode == value)
        return;
    RPiDataStruct.brewery_mode = value;

    emit breweryModeChanged();
}

void RPiData::setBreweryReset(bool value) {
    if (value) {
        setSetpointHLT(0.0);
        setSetpointMash(0.0);
        setSetpointBoil(0.0);
        setElementOnHLT(false);
        setElementOnBoil(false);
        setPIDModeHLT(false);
        setPIDModeMash(false);
        setPIDModeBoil(false);
        setBreweryMode(false);

        emit breweryResetChanged();
    }
}

RPiData::~RPiData()
{
}
