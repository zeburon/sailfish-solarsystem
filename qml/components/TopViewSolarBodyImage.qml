import QtQuick 2.0

SolarBodyImage
{
    id: root

    // -----------------------------------------------------------------------

    property alias shadowOpacity: shadow.opacity
    property alias shadowRotation: shadow.rotation

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
