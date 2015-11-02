import QtQuick 2.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property PlanetConfig planetConfig
    property bool showShadowOnPlanet: true
    property bool showShadowBehindPlanet: true
    property alias shadowOpacity: shadow.opacity
    property real shadowRotation: 0
    property alias imageWidth: image.width
    property alias imageHeight: image.height
    property int totalWidth: Math.max(imageOnTop.width, image.width)
    property int totalHeight: Math.max(imageOnTop.height, image.height)
    property bool useSmallImage: true

    // -----------------------------------------------------------------------

    visible: planetConfig.visible

    // -----------------------------------------------------------------------
    // actual image
    Image
    {
        id: image

        source: useSmallImage ? planetConfig.smallImageSource : planetConfig.mediumImageSource
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
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
            visible: showShadowOnPlanet
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

    // -----------------------------------------------------------------------
    // optional image rendered on top of everything (e.g. rings)
    Image
    {
        id: imageOnTop

        source: (useSmallImage ? planetConfig.smallImageOnTopSource : planetConfig.mediumImageOnTopSource)
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
    }
}
