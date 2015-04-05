import QtQuick 2.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property PlanetInfo planetInfo
    property alias size: image.height
    property real zoom: 1.0
    property real imageScale: 1.0
    property real imageOpacity: 1.0
    property bool showZPosition: false
    property bool showShadowBehindPlanet: true
    property real shadowRotation: planetInfo.currentShadowRotation

    // -----------------------------------------------------------------------

    x: planetInfo.calculatedX * zoom
    y: planetInfo.calculatedY * zoom + (showZPosition ? planetInfo.calculatedZ * zoom : 0.0)
    scale: imageScale * planetInfo.currentOpacityFactor
    opacity: imageOpacity * planetInfo.currentOpacityFactor
    visible: planetInfo.visible

    // -----------------------------------------------------------------------
    // actual image
    Image
    {
        id: image

        source: planetInfo.imageSource
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
    }

    // -----------------------------------------------------------------------
    // display distance to ecliptic
    Rectangle
    {
        id: zIndicator

        width: 4
        radius: 2
        z: -1
        height: Math.abs(planetInfo.calculatedZ * zoom)
        color: planetInfo.calculatedZ < 0.0 ? "green" : "red"
        opacity: 0.3
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: planetInfo.calculatedZ > 0.0 ? -height : 0 }
        visible: showZPosition

        Rectangle
        {
            id: zIndicatorBase

            width: 8
            height: width
            radius: width / 2
            anchors { verticalCenter: planetInfo.calculatedZ < 0 ? parent.bottom : parent.top; horizontalCenter: parent.horizontalCenter }
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
