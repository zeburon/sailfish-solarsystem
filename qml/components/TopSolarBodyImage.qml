import QtQuick 2.0

SolarBodyImage
{
    id: root

    // -----------------------------------------------------------------------

    property bool showZPosition: true
    property real zPosition: 0.0
    property alias shadowOpacity: shadow.opacity
    property alias shadowRotation: shadow.rotation

    // -----------------------------------------------------------------------
    // visualization of distance to ecliptic
    Rectangle
    {
        id: zIndicatorLine

        width: 4
        height: Math.abs(root.zPosition)
        radius: 2
        z: -20
        color: zPosition < 0.0 ? "green" : "red"
        opacity: 0.3
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: -root.zPosition / 2 }
        visible: showZPosition

        Rectangle
        {
            id: zIndicatorBase

            width: 8
            height: width
            radius: width / 2
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: root.zPosition < 0 ? parent.bottom : parent.top }
            color: parent.color
        }
    }

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
            z: 2
        }
        Image
        {
            id: shadowBehindPlanet // aka umbra :)

            antialiasing: true
            width: height * 3
            height: shadowOnPlanet.height
            source: "../gfx/shadow2.png"
            anchors { left: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
            opacity: 0.6 * root.scale
            z: 1
        }
    }
}
