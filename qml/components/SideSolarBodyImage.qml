import QtQuick 2.0
import Sailfish.Silica 1.0

SolarBodyImage
{
    id: root

    // -----------------------------------------------------------------------

    property alias shadowOpacity: shadow.opacity
    property alias shadowRotation: shadow.rotation
    property alias axialTilt: axialTiltInfo.rotation

    // -----------------------------------------------------------------------
    // shadow rendering
    Item
    {
        id: shadow

        anchors { centerIn: parent }
        rotation: shadowRotation

        Image
        {
            id: shadowOnPlanet

            antialiasing: true
            width: imageHeight + 2
            height: width
            source: "../gfx/shadow.png"
            anchors { centerIn: parent; horizontalCenterOffset: 1 }
        }
    }

    // -----------------------------------------------------------------------
    // axis rendering
    Item
    {
        id: axialTiltInfo

        anchors { centerIn: parent }
        opacity: 0.85

        Rectangle
        {
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top; bottomMargin: imageHeight / 2 }
            width: 2
            height: 6
            color: "red"

            Label
            {
                id: northLabel

                text: qsTr("N")
                anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top }
                color: parent.color
                horizontalAlignment: Text.AlignHCenter
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny * 0.75 }
            }
        }

        Rectangle
        {
            anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom; topMargin: imageHeight / 2 }
            width: 2
            height: 6
            color: "green"

            Label
            {
                id: southLabel

                text: qsTr("S")
                anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom }
                color: parent.color
                horizontalAlignment: Text.AlignHCenter
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny * 0.75 }
            }
        }
    }
}
