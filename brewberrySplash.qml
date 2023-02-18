import QtQuick 2.0
import QtQuick.Timeline 1.0
import QtQuick.Window 2.12
import QtGraphicalEffects 1.15

ApplicationWindow {
    id: splashMain
    width: 1024
    height: 600
    visible: true
    x: Screen.width / 2 - width / 2;
    y: Screen.height / 2 - height / 2;
    color: "#00000000"
    title: qsTr("Loading")

    // Remove Title Bar
    flags: Qt.SpashScreen | Qt.FramelessWindowHint

    Rectangle {
        id: splashBackground
        color: "#000000"
        radius: 10
        border.width: 0
        anchors.fill: parent

        Text {
            id: splashLoadingText
            color: "white"
            text: "Loading Interface"
            anchors.top: splashBackground.top
            anchors.horizontalCenter: parent.horizontalCenter
            font.pointSize: 36
            opacity: 1
        }

        Timeline {
            id: splashTimeline
            animations: [
                TimelineAnimation {
                    id: splashTimelineAnimation
                    loops: 1
                    running: true
                    duration: 5000
                    to: 5000
                    from: 0
                }
            ]
            startFrame: 0
            endFrame: 5000
            enabled: true

            KeyframeGroup {
                target: splashImageCenter
                property: "opacity"
                Keyframe {
                    value: 0
                    frame: 0
                }

                Keyframe {
                    easing.bezierCurve: [0.112,0.75,0.558,1.25,1,1]
                    value: 1
                    frame: 5003
                }
            }

            KeyframeGroup {
                target: splashLoadingText
                property: "opacity"
                Keyframe {
                    frame: 0
                    value: 0
                }

                Keyframe {
                    easing.bezierCurve: [0.112,0.75,0.558,1.25,1,1]
                    frame: 5000
                    value: 1
                }
            }

            KeyframeGroup {
                target: splashEndBtn
                property: "opacity"
                Keyframe {
                    frame: 0
                    value: 0
                }
                Keyframe {
                    frame: 4998
                    value: 0
                }
                Keyframe {
                    frame: 5000
                    value: 1
                }
            }

            KeyframeGroup {
                target: busyIndicator
                property: "opacity"
                Keyframe {
                    frame: 0
                    value: 1
                }
                Keyframe {
                    frame: 4998
                    value: 1
                }
                Keyframe {
                    frame: 5000
                    value: 0
                }
            }
        }

        Image {
            id: splashImageCenter
            x: 312
            y: 100
            width: 400
            height: 400
            opacity: 1
            source: "qrc:/images/mainHopsLoadingGreen.png"
            fillMode: Image.PreserveAspectFit
        }

        ProgressBar {
            id: busyIndicator
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            value: 0
            width: parent.width - 10
            height: 20
            clip: true
            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 6
                border.color: "#999999"
                radius: 5
            }
            contentItem: Item {
                implicitWidth: 200
                implicitHeight: 4

                Rectangle {
                    id: bar
                    width: busyIndicator.visualPosition * parent.width
                    height: parent.height
                    radius: 5
                }

                LinearGradient {
                    anchors.fill: bar
                    start: Qt.point(0, 0)
                    end: Qt.point(bar.width, 0)
                    source: bar
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: "#17a81a" }
                        GradientStop { id: grad; position: 0.5; color: Qt.lighter("#17a81a", 2) }
                        GradientStop { position: 1.0; color: "#17a81a" }
                    }
                    PropertyAnimation {
                        target: grad
                        property: "position"
                        from: 0.1
                        to: 0.9
                        duration: 1000
                        running: true
                        loops: 1
                    }
                }

                LinearGradient {
                    anchors.fill: bar
                    start: Qt.point(0, 0)
                    end: Qt.point(0, bar.height)
                    source: bar
                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Qt.rgba(0,0,0,0) }
                        GradientStop { position: 0.5; color: Qt.rgba(1,1,1,0.3) }
                        GradientStop { position: 1.0; color: Qt.rgba(0,0,0,0.05) }
                    }
                }
            }

            PropertyAnimation {
                target: busyIndicator
                property: "value"
                from: 0
                to: 1
                duration: 5000
                running: true
                loops: 1
            }
        }

        Button {
            id: splashEndBtn
            width: 250
            height: 60
            opacity: 1
            text: qsTr("Continue")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10

            onClicked: function() {
                splashMain.destroy();
            }
        }
    }
}
