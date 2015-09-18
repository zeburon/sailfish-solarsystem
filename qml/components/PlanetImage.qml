import QtQuick 2.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property PlanetInfo planetInfo
    property alias size: image.height
    property bool showShadowBehindPlanet: true

    property real displayedX: planetInfo.displayedCoordinates[0]
    property real displayedY: planetInfo.displayedCoordinates[1]
    property real displayedZ: planetInfo.displayedCoordinates[2]
    property real displayedShadowRotation: planetInfo.currentShadowRotation

    // -----------------------------------------------------------------------

    x: displayedX * currentZoom
    y: displayedY * currentZoom + (showZPosition ? displayedZ * currentZoom : 0.0)
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
    // visualization of distance to ecliptic
    Rectangle
    {
        id: zIndicatorLine

        width: 4
        radius: 2
        z: -1
        height: Math.abs(displayedZ * currentZoom)
        color: displayedZ < 0.0 ? "green" : "red"
        opacity: 0.3
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: displayedZ > 0.0 ? -height : 0 }
        visible: showZPosition

        Rectangle
        {
            id: zIndicatorBase

            width: 8
            height: width
            radius: width / 2
            anchors { verticalCenter: displayedZ < 0 ? parent.bottom : parent.top; horizontalCenter: parent.horizontalCenter }
            color: parent.color
        }
    }

    // -----------------------------------------------------------------------
    // shadow rendering
    Item
    {
        id: shadow

        anchors { centerIn: parent }
        rotation: displayedShadowRotation

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
