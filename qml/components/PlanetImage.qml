import QtQuick 2.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property PlanetInfo planetInfo
    property bool showShadowBehindPlanet: true
    property real shadowRotation: 0
    property int clickAreaSize: 50
    property alias imageWidth: image.width
    property alias imageHeight: image.height
    property bool small: true

    // -----------------------------------------------------------------------

    signal clicked(var planet)

    // -----------------------------------------------------------------------

    visible: planetInfo.visible

    // -----------------------------------------------------------------------
    // actual image
    Image
    {
        id: image

        source: (small ? planetInfo.smallImageSource : planetInfo.mediumImageSource)
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true

        MouseArea
        {
            anchors { centerIn: parent }
            width: clickAreaSize
            height: clickAreaSize
            onClicked:
            {
                root.clicked(planetInfo);
            }
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
            width: image.height + 2
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
            visible: showShadowBehindPlanet
            z: 1
        }
    }
}
