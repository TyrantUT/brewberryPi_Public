import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.12
import QtCharts 2.3

Page {
    id: root
    //width: 1024
    //height: 600

    property int labelSize: 20

    function secondsToTime(value) {
        var date = new Date(null);
        date.setSeconds( Math.round(value * 100) / 100 );
        var result = date.toISOString().substr( 11, 8 );
        return result;
    }

    function changeColor(string) {
        if (string === "No faults detected.") {
            return "#00FF00"
        }
        else {
            return "#FF0000"
        }
    }

    Rectangle {
        id: background_timer1
        width: parent.width
        height: parent.height
        color: "#000000"

        Label {
            text: qsTr("Brewery Tools")
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.horizontalCenter: parent.horizontalCenter
            color: "#FFFFFF"
            font.pointSize: labelSize * 2
        }

        Label {
            id: label_breweryTimer
            anchors {
                bottom: text_timer1.top
                bottomMargin: 20
                horizontalCenter: parent.horizontalCenter
            }
            color: "white"
            font.pointSize: labelSize
            text: "Brewery Timer"
        }

        Text {
            id: text_timer1
            anchors {
                bottom: slider_timer1.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            font.pixelSize: labelSize + 20
            color: "#FFFFFF"
            text: CountdownTimer.running ? secondsToTime(CountdownTimer.elapsed) : secondsToTime(CountdownTimer.startTime)
        }

        DropShadow {
            anchors.fill: text_timer1
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: "#fff00000"
            source: text_timer1
        }

        Slider {
            id: slider_timer1
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: 200
            orientation: Qt.Vertical
            from: 0
            to: 10800
            stepSize: 1.0

            onValueChanged: {
                CountdownTimer.startTime = value;
            }
        }

        ToggleButton {
            id: button_timer1
            anchors {
                top: slider_timer1.bottom
                topMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            text: qsTr("Start Timer")
            radius: 8
            enabled: CountdownTimer.startTime > 0 ? true: false

            onCheckedChanged: {
                if (checked) {
                    text = "Stop Timer";
                    slider_timer1.enabled = false;
                    CountdownTimer.start();
                }
                else {
                    text = "Start Timer";
                    slider_timer1.enabled = true;
                    CountdownTimer.stop();
                }
            }
        }

        DropShadow {
            anchors.fill: button_timer1
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: "#fff00000"
            source: button_timer1
        }

        Button {
            id: button_timer2hour
            anchors {
                right: slider_timer1.left
                rightMargin: 20
                bottom: button_timer1hour30.top
                bottomMargin: 10
            }
            enabled: slider_timer1.enabled
            text: qsTr("2:00")
            onClicked: {
                slider_timer1.value = (120 * 60);
            }
        }

        Button {
            id: button_timer1hour30
            anchors {
                right: slider_timer1.left
                rightMargin: 20
                bottom: button_timer1hour.top
                bottomMargin: 10
            }
            enabled: slider_timer1.enabled
            text: qsTr("1:30")
            onClicked: {
                slider_timer1.value = (90 * 60);
            }
        }

        Button {
            id: button_timer1hour
            anchors {
                right: slider_timer1.left
                rightMargin: 20
                verticalCenter: slider_timer1.verticalCenter
            }
            enabled: slider_timer1.enabled
            text: qsTr("1:00")
            onClicked: {
                slider_timer1.value = (60 * 60);
            }
        }

        Button {
            id: button_timer30min
            anchors {
                right: slider_timer1.left
                rightMargin: 20
                top: button_timer1hour.bottom
                topMargin: 10
            }
            enabled: slider_timer1.enabled
            text: qsTr(":30")
            onClicked: {
                slider_timer1.value = (30 * 60);
            }
        }

        Button {
            id: button_timer15min
            anchors {
                right: slider_timer1.left
                rightMargin: 20
                top: button_timer30min.bottom
                topMargin: 10
            }
            enabled: slider_timer1.enabled
            text: qsTr(":15")
            onClicked: {
                slider_timer1.value = (15 * 60);
            }
        }

        GridLayout {
            id: statsLayout
            anchors {
                top: label_breweryTimer.top
                left: parent.left
                leftMargin: 20
            }

            rowSpacing: 5
            property real tempMAX_HLT: Math.round(RPiData.tempmax_hlt * 10) / 10
            property real tempMAX_MASH: Math.round(RPiData.tempmax_mash * 10) / 10
            property real tempMAX_MASH2: Math.round(RPiData.tempmax_mash2 * 10) / 10
            property real tempMAX_BOIL: Math.round(RPiData.tempmax_boil * 10) / 10
            property real setpointPID_HLT: Math.round(RPiData.setpoint_hlt * 10) / 10
            property real setpointPID_MASH: Math.round(RPiData.setpoint_mash * 10) / 10
            property real setpointPID_BOIL: Math.round(RPiData.setpoint_boil * 10) / 10
            property real pwmDUTY_HLT: Math.round(RPiData.pwmduty_hlt * 10) / 10
            property real pwmDUTY_BOIL: Math.round(RPiData.pwmduty_boil * 10) / 10

            property var titles: ['HLT Temperature', 'HLT Setpoint', 'Mash Temperature', 'Mash Setpoint', 'Mash 2 Temperature', 'Boil Temperature',  'Boil Setpoint', 'HLT Duty Cycle', 'Boil Duty Cycle']
            property var values: [tempMAX_HLT, setpointPID_HLT, tempMAX_MASH, setpointPID_MASH, tempMAX_MASH2, tempMAX_BOIL, setpointPID_BOIL, pwmDUTY_HLT, pwmDUTY_BOIL]

            flow: GridLayout.TopToBottom

            Repeater {
                model: statsLayout.titles
                Label {
                    Layout.row: index
                    Layout.column: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData
                    font.pixelSize: 24
                    color: "#FAFAFA"
                }
            }

            Repeater {
                model: statsLayout.values
                Label {
                    Layout.row: index
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData
                    font.pixelSize: 24
                    color: "#FAFAFA"
                }
            }

        }

        Rectangle {
            id: background_errors
            anchors {
                bottom: parent.bottom
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }
            width: parent.width - 20
            height: 130
            color: parent.color
        }

        DropShadow {
            anchors.fill: background_errors
            horizontalOffset: 0
            verticalOffset: 0
            radius: 16
            samples: 16
            color: "#fff00000"
            source: background_errors
        }

        GridLayout {
            id: errorsLayout
            anchors {
                top: background_errors.top
                topMargin: 5
                left: parent.left
                leftMargin: 20
            }

            rowSpacing: 12
            columnSpacing: 20
            flow: GridLayout.TopToBottom

            property string faultText_hlt: RPiData.faultText_hlt
            property string faultText_mash: RPiData.faultText_mash
            property string faultText_mash2: RPiData.faultText_mash2            
            property string faultText_boil: RPiData.faultText_boil

            property var titles: ['Hot Liquor Tank Sensor Error', 'Mash Sensor Error', 'Mash 2 Sensor Error', 'Boil Sensor Error']
            property var values: [faultText_hlt, faultText_mash, faultText_mash2, faultText_boil]

            Repeater {
                model: errorsLayout.titles
                Label {
                    Layout.row: index
                    Layout.column: 0
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData
                    font.pointSize: 12
                    color: "#FAFAFA"
                }
            }

            Repeater {
                model: errorsLayout.values
                Label {
                    Layout.row: index
                    Layout.column: 1
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    text: modelData
                    font.pointSize: 12
                    color: changeColor(text)
                }
            }
        }
    }
}




