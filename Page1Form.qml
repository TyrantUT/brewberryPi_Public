import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.12
import QtGraphicalEffects 1.15

import TemperatureRadialBar 1.0

Page {
    width: 1024
    height: 600

    property int labelSize: 12
    property int degSize: 96
    property real minVal: 0.0
    property real maxVal: 215.0
    property string tempBarSuffix: "°"
    property real radialBarDialWidth: 5

    property real setpointHLTVal: 0.0
    property real setpointMashVal: 0.0
    property real setpointBoilVal: 0.0
    property bool setpointManualHLT: false
    property bool setpointManualMash: false
    property bool setpointManualBoil: false
    property bool elementHLT_ON: false
    property bool elementBOIL_ON: false

    function secondsToTime(value) {
        var date = new Date(null);
        date.setSeconds(Math.round(value * 100) / 100);
        var result = date.toISOString().substr(11, 8);
        return result;
    }

    // HLT Radial Bar
    Rectangle {
        height: parent.height / 2
        width: parent.width / 3
        anchors.top: parent.top
        anchors.left: parent.left
        color: "#000000"

        RadialBar {
            id: radialHLT
            width: parent.width + 10
            height: parent.height + 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            penStyle: Qt.RoundCap
            progressColor: "#00ffc1"
            foregroundColor: "#191a2f"
            pointColor: "#ffffff"
            dialWidth: radialBarDialWidth
            minValue: minVal
            maxValue: maxVal
            pointValue: setpointHLTVal
            value: RPiData.tempmax_hlt
            suffixText: tempBarSuffix
            textFont {
                family: "Helvetica"
                italic: false
                pointSize: degSize
            }
            textColor: "#00ffc1"
        }

        Label {
            id: label_HLT
            text: "Hot Liquor Tank"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            font.pointSize: labelSize + 4
            color: "#FFFFFF"
        }
    }

    // Mash Tun Radial Bar
    Rectangle {
        height: parent.height / 2
        width: parent.width / 3
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#000000"

        RadialBar {
            id: radialMash
            width: parent.width + 10
            height: parent.height + 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            penStyle: Qt.RoundCap
            progressColor: "#00ffc1"
            foregroundColor: "#191a2f"
            pointColor: "#ffffff"
            dialWidth: radialBarDialWidth
            minValue: minVal
            maxValue: maxVal
            pointValue: setpointMashVal
            value: button_MashMash2.active ? RPiData.tempmax_mash2 : RPiData.tempmax_mash
            suffixText: tempBarSuffix
            textFont {
                family: "Helvetica"
                italic: false
                pointSize: degSize
            }
            textColor: "#00ffc1"
        }

        Label {
            id: label_mashRadialLabel
            text: "Mash Tun"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            font.pointSize: labelSize + 4
            color: "#FFFFFF"

            ToggleButton {
                id: button_MashMash2
                anchors.centerIn: parent
                color: "#00000000"
                text: ""
                onCheckedChanged: {
                    if (checked) {
                        label_mashRadialLabel.text = "Mash 2";
                    }
                    else {
                        label_mashRadialLabel.text = "Mash Tun";
                    }
                }
            }
        }
    }

    // Boil Kettle Radial Bar
    Rectangle {
        height: parent.height / 2
        width: (parent.width / 3) + 1
        anchors.top: parent.top
        anchors.right: parent.right
        color: "#000000"

        RadialBar {
            id: radialBoil
            width: parent.width + 10
            height: parent.height + 10
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            penStyle: Qt.RoundCap
            progressColor: "#00ffc1"
            foregroundColor: "#191a2f"
            pointColor: "#ffffff"
            dialWidth: radialBarDialWidth
            minValue: minVal
            maxValue: maxVal
            pointValue: setpointBoilVal
            value: RPiData.tempmax_boil
            suffixText: tempBarSuffix
            textFont {
                family: "Helvetica"
                italic: false
                pointSize: degSize
            }
            textColor: "#00ffc1"
        }

        Label {
            text: "Boil Kettle"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            font.pointSize: labelSize + 4
            color: "#FFFFFF"
        }
    }

    // Hot Liquor Tank Controls
    Rectangle {
        id: background_HLTControls
        height: parent.height / 2
        width: parent.width / 3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        color: "#000000"

        ToggleButton {
            id: button_HLTAutomaticManual
            width: 100
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 8
            color: active ? "#100010" : "#FAFAFA"
            text: qsTr("Automatic")

            onCheckedChanged: {
                if (checked) {
                    text = qsTr("Manual")
                    radialHLT.showPointText = false;
                    radialHLT.pointColor = radialHLT.backgroundColor;
                    radialHLT.update();
                    RPiData.pidmode_hlt = true;
                    RPiData.setpoint_hlt = slider_HLTSetPoint.position * 100
                    setpointManualHLT = true;
                }

                else {
                    text = qsTr("Automatic")
                    radialHLT.showPointText = true;
                    radialHLT.pointColor = "#FFFFFF";
                    radialHLT.update();
                    RPiData.pidmode_hlt = false;
                    RPiData.setpoint_hlt = slider_HLTSetPoint.value
                    setpointManualHLT = false;
                }
            }
        }

        DropShadow {
            anchors.fill: button_HLTAutomaticManual
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: button_HLTAutomaticManual.enabled ? "#fff00000" : "black"
            source: button_HLTAutomaticManual
        }

        Label {
            id: label_HLTAutomaticManualDuty
            anchors.right: button_HLTAutomaticManual.left
            anchors.rightMargin: 10
            anchors.verticalCenter: button_HLTAutomaticManual.verticalCenter
            text: (slider_HLTSetPoint.position * 100).toFixed(2) + "%"
            color: "#FFFFFF"
            visible: button_HLTAutomaticManual.active
        }

        DelayButton {
              id: delayButton_HLTOn
              text: qsTr("HLT\nOff")
              delay: 2000
              font.pointSize: 22
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter

              onProgressChanged: {

                  hltElementCanvas.requestPaint()
              }

              contentItem: Text {
                  text: delayButton_HLTOn.text
                  font: delayButton_HLTOn.font
                  opacity: enabled ? 1.0 : 0.3
                  color: "white"
                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter
                  elide: Text.ElideRight
              }

              background: Rectangle {
                  implicitWidth: 150
                  implicitHeight: 150
                  opacity: enabled ? 1 : 0.3
                  color: delayButton_HLTOn.down ? "#17a81a" : (delayButton_HLTOn.checked ? "#f4362b" : "#21be2b")
                  radius: size / 2

                  readonly property real size: Math.min(delayButton_HLTOn.width, delayButton_HLTOn.height)
                  width: size / 1.5
                  height: size / 1.5
                  anchors.centerIn: parent

                  Canvas {
                      id: hltElementCanvas
                      anchors.fill: parent
                      onPaint: {
                          var ctx = getContext("2d")
                          ctx.clearRect(0, 0, width, height)
                          ctx.strokeStyle = "white"
                          ctx.lineWidth = parent.size / 20
                          ctx.beginPath()
                          var startAngle = Math.PI / 5 * 3
                          var endAngle = startAngle + delayButton_HLTOn.progress * Math.PI / 5 * 9
                          ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2 - 2, startAngle, endAngle)
                          ctx.stroke()
                      }
                  }
              }

              onCheckedChanged:  {
                  if (checked) {
                      text = qsTr("HLT\nOn");
                      delayButton_BoilOn.enabled = false;
                      RPiData.elemenon_hlt = true;
                  }
                  else {
                      text = qsTr("HLT\nOff");
                      delayButton_BoilOn.enabled = true;
                      RPiData.elemenon_hlt = false;
                  }
              }
        }

        DropShadow {
            anchors.fill: delayButton_HLTOn
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: delayButton_HLTOn.enabled ? "#fff00000" : "black"
            source: delayButton_HLTOn
        }

        Rectangle {
            id: rectangle_SliderHLTBackground
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: parent.width - 50
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: slider_HLTSetPoint.enabled ? "#900000ff" : "black" }
                GradientStop { position: 1.0; color: "black" }
            }

            Slider {
                id: slider_HLTSetPoint
                anchors.fill: parent
                orientation: Qt.Horizontal
                from: minVal
                to: maxVal
                value: setpointHLTVal
                stepSize: 0.5

                background: Rectangle {
                       x: parent.leftPadding
                       y: parent.topPadding + parent.availableHeight / 2 - height / 2
                       implicitWidth: 200
                       implicitHeight: 4
                       width: parent.availableWidth
                       height: implicitHeight + 5
                       radius: 2
                       color: parent.enabled ? "yellow" : "#bdbebf"

                       Rectangle {
                           width: slider_HLTSetPoint.visualPosition * parent.width
                           height: parent.height
                           radius: 2
                           enabled: parent.enabled

                           LinearGradient {
                               anchors.fill: parent
                               start: Qt.point(0, slider_HLTSetPoint.height)
                               end: Qt.point(slider_HLTSetPoint.width, slider_HLTSetPoint.height)
                               gradient: Gradient {
                                   GradientStop {position: 0.0; color: "blue" }
                                   GradientStop {position: 0.5; color: "#ff00FF" }
                                   GradientStop {position: 1.0; color: "red" }
                               }
                           }
                       }
                   }

                handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    width: 15
                    height: 30
                    radius: 5
                    color: "grey"
                }

                onValueChanged: {
                    if (value != setpointHLTVal) {
                        setpointHLTVal = value;

                        if (setpointManualHLT) {
                            RPiData.setpoint_hlt = position * 100
                        }
                        else {
                            RPiData.setpoint_hlt = setpointHLTVal
                        }
                    }
                }
            }

            DropShadow {
                anchors.fill: slider_HLTSetPoint
                horizontalOffset: 0
                verticalOffset: 0
                radius: 16
                samples: 16
                color: slider_HLTSetPoint.enabled ? "#fff00000" : "black"
                source: slider_HLTSetPoint
            }
        }
    }

    // Mash Controls
    Rectangle {
        height: parent.height / 2
        width: parent.width / 3
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#000000"

        ToggleButton {
            id: button_MashAutomaticManual
            width: 100
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 8
            color: active ? "#100010" : "#FAFAFA"
            text: qsTr("Automatic")
            enabled: false

            onCheckedChanged: {
                if (checked) {
                    text = qsTr("Manual")
                    radialMash.showPointText = false;
                    radialMash.pointColor = radialMash.backgroundColor;
                    radialMash.update();
                    RPiData.pidmode_mash = true;
                    RPiData.setpoint_mash = slider_MashSetPoint.position * 100
                    setpointManualMash = true;
                }

                else {
                    text = qsTr("Automatic")
                    radialMash.showPointText = true;
                    radialMash.pointColor = "#FFFFFF";
                    radialMash.update();
                    RPiData.pidmode_mash = false;
                    RPiData.setpoint_mash = slider_MashSetPoint.value
                    setpointManualMash = false;
                }
            }
        }

        DropShadow {
            anchors.fill: button_MashAutomaticManual
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: button_MashAutomaticManual.enabled ? "#fff00000" : "black"
            source: button_MashAutomaticManual
        }

        Label {
            id: label_MashAutomaticManualDuty
            anchors.right: button_MashAutomaticManual.left
            anchors.rightMargin: 10
            anchors.verticalCenter: button_MashAutomaticManual.verticalCenter
            text: (slider_MashSetPoint.position * 100).toFixed(2) + "%"
            color: "#FFFFFF"
            visible: button_MashAutomaticManual.active
        }

        Rectangle {
            id: rectangle_SliderMASHBackground
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: parent.width - 50
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: slider_MashSetPoint.enabled ? "#900000ff" : "black" }
                GradientStop { position: 1.0; color: "black" }
            }

            Slider {
                id: slider_MashSetPoint
                anchors.fill: parent
                orientation: Qt.Horizontal
                from: minVal
                to: maxVal
                value: setpointMashVal
                stepSize: 0.5
                enabled: false

                background: Rectangle {
                       x: parent.leftPadding
                       y: parent.topPadding + parent.availableHeight / 2 - height / 2
                       implicitWidth: 200
                       implicitHeight: 4
                       width: parent.availableWidth
                       height: implicitHeight + 5
                       radius: 2
                       color: parent.enabled ? "yellow" : "#bdbebf"

                       Rectangle {
                           width: slider_MashSetPoint.visualPosition * parent.width
                           height: parent.height
                           radius: 2
                           enabled: parent.enabled

                           LinearGradient {
                               anchors.fill: parent
                               start: Qt.point(0, slider_MashSetPoint.height)
                               end: Qt.point(slider_MashSetPoint.width, slider_MashSetPoint.height)
                               gradient: Gradient {
                                   GradientStop {position: 0.0; color: "blue" }
                                   GradientStop {position: 0.5; color: "#ff00FF" }
                                   GradientStop {position: 1.0; color: "red" }
                               }
                           }
                       }
                   }

                handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    width: 15
                    height: 30
                    radius: 5
                    color: "grey"
                }

                onValueChanged: {
                    if (value != setpointMashVal) {
                        setpointMashVal = value;
                        if (setpointManualMash) {
                            RPiData.setpoint_mash = position * 100
                        }
                        else {
                            RPiData.setpoint_mash = setpointMashVal
                        }
                    }
                }
            }
            DropShadow {
                anchors.fill: slider_MashSetPoint
                horizontalOffset: 0
                verticalOffset: 0
                radius: 16
                samples: 16
                color: slider_MashSetPoint.enabled ? "#fff00000" : "black"
                source: slider_MashSetPoint
            }
        }
    }

    // Boil Kettle Controls
    Rectangle {
        id: background_BoilControls
        height: parent.height / 2
        width: parent.width / 3 + 1
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: "#000000"

        ToggleButton {
            id: button_BoilAutomaticManual
            width: 100
            height: 30
            anchors.top: parent.top
            anchors.topMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            radius: 8
            color: active ? "#100010" : "#FAFAFA"
            text: qsTr("Automatic")

            onCheckedChanged: {
                if (checked) {
                    text = qsTr("Manual")
                    radialBoil.showPointText = false;
                    radialBoil.pointColor = radialMash.backgroundColor;
                    radialBoil.update();
                    RPiData.pidmode_boil = true;
                    RPiData.setpoint_boil = slider_BoilSetPoint.position * 100
                    setpointManualBoil = true;
                }

                else {
                    text = qsTr("Automatic")
                    radialBoil.showPointText = true;
                    radialBoil.pointColor = "#FFFFFF";
                    radialBoil.update();
                    RPiData.pidmode_boil = false;
                    RPiData.setpoint_boil = slider_BoilSetPoint.value
                    setpointManualBoil = false;
                }
            }
        }

        DropShadow {
            anchors.fill: button_BoilAutomaticManual
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: button_BoilAutomaticManual.enabled ? "#fff00000" : "black"
            source: button_BoilAutomaticManual
        }

        Label {
            id: label_BoilAutomaticManualDuty
            anchors.right: button_BoilAutomaticManual.left
            anchors.rightMargin: 10
            anchors.verticalCenter: button_BoilAutomaticManual.verticalCenter
            text: (slider_BoilSetPoint.position * 100).toFixed(2) + "%"
            color: "#FFFFFF"
            visible: button_BoilAutomaticManual.active
        }

        Rectangle {
            id: rectangle_SliderBoilBackground
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            height: 25
            width: parent.width - 50
            radius: 16
            gradient: Gradient {
                GradientStop { position: 0.0; color: "black" }
                GradientStop { position: 0.5; color: "#900000ff" }
                GradientStop { position: 1.0; color: "black" }
            }

            Slider {
                id: slider_BoilSetPoint
                anchors.fill: parent
                orientation: Qt.Horizontal
                from: minVal
                to: maxVal
                value: setpointBoilVal
                stepSize: 0.5

                background: Rectangle {
                       x: parent.leftPadding
                       y: parent.topPadding + parent.availableHeight / 2 - height / 2
                       implicitWidth: 200
                       implicitHeight: 4
                       width: parent.availableWidth
                       height: implicitHeight + 5
                       radius: 2
                       color: parent.enabled ? "yellow" : "#bdbebf"

                       Rectangle {
                           width: slider_BoilSetPoint.visualPosition * parent.width
                           height: parent.height
                           radius: 2
                           enabled: parent.enabled

                           LinearGradient {
                               anchors.fill: parent
                               start: Qt.point(0, slider_BoilSetPoint.height)
                               end: Qt.point(slider_BoilSetPoint.width, slider_BoilSetPoint.height)
                               gradient: Gradient {
                                   GradientStop {position: 0.0; color: "blue" }
                                   GradientStop {position: 0.5; color: "#ff00FF" }
                                   GradientStop {position: 1.0; color: "red" }
                               }
                           }
                       }
                   }

                handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    width: 15
                    height: 30
                    radius: 5
                    color: "grey"
                }

                onValueChanged: {
                    if (value != setpointBoilVal) {
                        setpointBoilVal = value;
                        if (setpointManualBoil) {
                            RPiData.setpoint_boil = position * 100
                        }
                        else {
                            RPiData.setpoint_boil = setpointBoilVal;
                        }
                    }
                }
            }

            DropShadow {
                anchors.fill: rectangle_SliderBoilBackground
                horizontalOffset: 0
                verticalOffset: 0
                radius: 16
                samples: 16
                color: "#fff00000"
                source: slider_BoilSetPoint
            }
        }

        DelayButton {
              id: delayButton_BoilOn
              text: qsTr("Boil\nOff")
              delay: 2000
              font.pointSize: 22
              anchors.verticalCenter: parent.verticalCenter
              anchors.horizontalCenter: parent.horizontalCenter

              onProgressChanged: {
                  boilElementCanvas.requestPaint()
              }

              contentItem: Text {
                  text: delayButton_BoilOn.text
                  font: delayButton_BoilOn.font
                  opacity: enabled ? 1.0 : 0.3
                  color: "white"
                  horizontalAlignment: Text.AlignHCenter
                  verticalAlignment: Text.AlignVCenter
                  elide: Text.ElideRight
              }

              background: Rectangle {
                  implicitWidth: 150
                  implicitHeight: 150
                  opacity: enabled ? 1 : 0.3
                  color: delayButton_BoilOn.down ? "#17a81a" : (delayButton_BoilOn.checked ? "#f4362b" : "#21be2b")
                  radius: size / 2

                  readonly property real size: Math.min(delayButton_BoilOn.width, delayButton_BoilOn.height)
                  width: size / 1.5
                  height: size / 1.5
                  anchors.centerIn: parent

                  Canvas {
                      id: boilElementCanvas
                      anchors.fill: parent

                      onPaint: {
                          var ctx = getContext("2d")
                          ctx.clearRect(0, 0, width, height)
                          ctx.strokeStyle = "white"
                          ctx.lineWidth = parent.size / 20
                          ctx.beginPath()
                          var startAngle = Math.PI / 5 * 3
                          var endAngle = startAngle + delayButton_BoilOn.progress * Math.PI / 5 * 9
                          ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2 - 2, startAngle, endAngle)
                          ctx.stroke()
                      }
                  }
              }

              onCheckedChanged: {
                  if (checked) {
                      text = qsTr("Boil\nOn");
                      delayButton_HLTOn.enabled = false;
                      RPiData.elementon_boil = true;

                  }
                  else {
                      text = qsTr("Boil\nOff");
                      delayButton_HLTOn.enabled = true;
                      RPiData.elementon_boil = false;
                  }
              }
        }

        DropShadow {
            anchors.fill: delayButton_BoilOn
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: delayButton_BoilOn.enabled ? "#fff00000" : "black"
            source: delayButton_BoilOn
        }
    }

    // Bottom Background Shape

    RectangularGlow {
        id: effect
        anchors.fill: rectangle_lowerBackground
        glowRadius: 10
        spread: 0.2
        color: "white"
        cornerRadius: rectangle_lowerBackground.radius + glowRadius
    }

    Rectangle {
        id: rectangle_lowerBackground
        anchors.bottom: parent.bottom
        anchors.bottomMargin: -5
        anchors.horizontalCenter: parent.horizontalCenter
        color: "#ff2b2b2b"
        width: parent.width
        height: 95
        radius: 8
    }

    Label {
        id: label_breweryTimerText
        anchors {
            bottom: label_breweryTimer.top
            horizontalCenter: label_breweryTimer.horizontalCenter
            bottomMargin: 10
        }

        text: qsTr("<b>Brewery Timer</b>")
        color: "#FFFFFF"
        font.pointSize: labelSize + 10
    }

    Label {
        id: label_breweryTimer
        anchors {
            bottom: button_BreweryMode.top
            horizontalCenter: button_BreweryMode.horizontalCenter
            bottomMargin: 20
        }

        text: CountdownTimer.running ? secondsToTime(CountdownTimer.elapsed) : secondsToTime(CountdownTimer.startTime)
        color: "#FFFFFF"
        font.pointSize: labelSize
    }

    // Brewery Controls / Reset
    ToggleButton {
        id: button_BreweryMode
        width: 100
        height: 30
        anchors.bottom: delayButton_Reset.top
        anchors.bottomMargin: 37
        anchors.horizontalCenter: delayButton_Reset.horizontalCenter

        radius: 8
        text: qsTr("HLT")
        color: active ? "#100010" : "#FAFAFA"

        onCheckedChanged: {
            if (checked) {
                text = qsTr("Mash");
                slider_MashSetPoint.enabled = true;
                slider_HLTSetPoint.enabled = false;
                slider_HLTSetPoint.value = 0;
                button_HLTAutomaticManual.enabled = false;
                button_HLTAutomaticManual.active = false;
                button_MashAutomaticManual.enabled = true;
                button_MashAutomaticManual.active = false;
                RPiData.brewery_mode = true;

            } else {
                text = qsTr("HLT");
                slider_HLTSetPoint.enabled = true;
                slider_MashSetPoint.enabled = false;
                slider_MashSetPoint.value = 0;
                button_HLTAutomaticManual.enabled = true;
                button_HLTAutomaticManual.active = false
                button_MashAutomaticManual.enabled = false;
                button_MashAutomaticManual.active = false;
                RPiData.brewery_mode = false;
            }
        }
    }

    DropShadow {
        anchors.fill: button_BreweryMode
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16
        samples: 16
        color: button_BreweryMode.enabled ? "#fff00000" : "black"
        source: button_BreweryMode
    }

    DelayButton {
        id: delayButton_Reset
        width: 100
        height: 30
        delay: 1000
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: 50
        implicitWidth: 100
        text: qsTr("Reset")
        font.pointSize: labelSize

        onCheckedChanged: {
            if (delayButton_Reset.checked) {
                delayButton_Reset.checked = false;

                setpointHLTVal = 0.0;
                setpointMashVal = 0.0;
                setpointBoilVal = 0.0;
                setpointManualHLT = false;
                setpointManualMash = false;
                setpointManualBoil = false;
                elementHLT_ON = false;
                elementBOIL_ON = false;
                button_HLTAutomaticManual.active = false;
                button_HLTAutomaticManual.text = "Automatic"
                button_MashAutomaticManual.active = false;
                button_MashAutomaticManual.text = "Automatic"
                button_BoilAutomaticManual.active = false;
                button_BoilAutomaticManual.text = "Automatic"
                button_BreweryMode.active = false;
                delayButton_HLTOn.checked = false;
                delayButton_BoilOn.checked = false;
                slider_HLTSetPoint.enabled = true;
                slider_HLTSetPoint.value = 0;
                slider_MashSetPoint.enabled = false;
                slider_MashSetPoint.value = 0;
                slider_BoilSetPoint.value = 0;

                RPiData.setBreweryReset(true);
            }
        }
    }

    Text {
        id: currentTime
        anchors.right: delayButton_Reset.left
        anchors.rightMargin: 25
        anchors.verticalCenter: delayButton_Reset.verticalCenter
        color: "white"
    }

    Timer {
           interval: 500
           running: true
           repeat: true
           onTriggered: currentTime.text = Qt.formatDateTime(new Date(), "h:mm:ss AP")
    }

    Text {
        id: disableControlText
        anchors.left: delayButton_Reset.right
        anchors.leftMargin: 25
        anchors.verticalCenter: delayButton_Reset.verticalCenter
        color: "white"
        text: 'No faults detected'
    }

    Rectangle {
        id: background_PWMDutyHLT
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: background_HLTControls.horizontalCenter
        width: 130
        height: 50
        radius: 4
        color: "#000000"

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: (RPiData.pwmduty_hlt).toFixed(2) + "%"
            font.pointSize: labelSize
            color: "#FAFAFA"
        }
    }

    DropShadow {
        anchors.fill: background_PWMDutyHLT
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16
        samples: 16
        color: "#fff00000"
        source: background_PWMDutyHLT
    }


    Rectangle {
        id: background_PWMDutyBoil
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: background_BoilControls.horizontalCenter
        width: 130
        height: 50
        radius: 4
        color: "#000000"

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: (RPiData.pwmduty_boil).toFixed(2) + "%"
            font.pointSize: labelSize
            color: "#FAFAFA"
        }
    }

    DropShadow {
        anchors.fill: background_PWMDutyBoil
        horizontalOffset: 0
        verticalOffset: 0
        radius: 16
        samples: 16
        color: "#fff00000"
        source: background_PWMDutyBoil
    }

    Rectangle {
        id: disableControls
        width: parent.width
        height: parent.height
        color: "transparent"
        enabled: true

        MouseArea {
               anchors.fill: parent
               // Double click to bypass faults
               onDoubleClicked: (mouse)=> {
                    parent.enabled = false;
                }

               onClicked: (mouse)=> {
                  if ((RPiData.faultText_hlt == 'No faults detected.') & (RPiData.faultText_mash == 'No faults detected.') & (RPiData.faultText_boil == 'No faults detected.')) {
                      parent.enabled = false;
                  }
                  else {
                      parent.enabled = true;
                      disableControlText.color = 'red'
                      disableControlText.text = 'Sensor fault detected.\nControls disabled.';
                  }
               }
        }
    }
}
