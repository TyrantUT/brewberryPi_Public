import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12


Rectangle {
    id: root
    property string text: "Toggle Button"
    property bool active: false
    property string backgroundColor: active ? "green" : (enabled ? "#FAFAFA" : "lightgray")
    property string borderColor: "transparent"
    property string textColor: active ? "white" : "black"
    signal checked()
    signal checkedChanged(bool checked)

    width: 149
    height: 30
    radius: 0.5 * root.height
    color: backgroundColor
    border.color: borderColor
    border.width: 0.05 * root.height
    opacity: enabled && !MouseArea.pressed ? 1: 0.3

    Text {
        text: root.text
        anchors.centerIn: parent
        font.pixelSize: 14
        color: textColor
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            active = !active;
            root.checked();
            root.checkedChanged(active);
        }
    }

    onActiveChanged: {
        root.text = text;
        root.checked();
        root.checkedChanged(active);
    }
}
