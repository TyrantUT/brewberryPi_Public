import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Window 2.12

ApplicationWindow {
    id: main
    width: Screen.width
    height: Screen.height
    visible: true

    SwipeView {
        id: swipeView
        anchors.fill: parent
        Page1Form {}
        Page2Form {}
        Page3Form {}
    }

}
