import QtQuick 2.0

Item
{
    id: root

    property PlanetInfo planetInfo
    property alias size: image.height

    x: planetInfo.calculatedX * currentZoom
    y: planetInfo.calculatedY * currentZoom + (showZPosition ? planetInfo.calculatedZ * currentZoom : 0.0)
    scale: imageScale * planetInfo.currentOpacityFactor
    opacity: imageOpacity * planetInfo.currentOpacityFactor
    visible: planetInfo.visible

    Image
    {
        id: image

        source: planetInfo.imageSource
        antialiasing: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    Rectangle
    {
        id: zIndicator

        width: 4
        radius: 2
        z: -1
        height: Math.abs(planetInfo.calculatedZ * currentZoom)
        color: planetInfo.calculatedZ < 0.0 ? "green" : "red"
        opacity: 0.3
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: planetInfo.calculatedZ > 0.0 ? -height : 0
        visible: showZPosition

        Rectangle
        {
            id: zIndicatorBase

            width: 8
            height: width
            radius: width / 2
            anchors.verticalCenter: planetInfo.calculatedZ < 0 ? parent.bottom : parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            color: parent.color
        }
    }

    Item
    {
        id: shadow

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rotation: planetInfo.currentShadowRotation

        Image
        {
            id: shadowOnPlanet

            antialiasing: true
            width: image.height + 2
            height: width
            source: "../gfx/shadow.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 1
            anchors.verticalCenter: parent.verticalCenter
            z: 2
        }
        Image
        {
            id: shadowBehindPlanet

            antialiasing: true
            width: height * 3
            height: shadowOnPlanet.height
            source: "../gfx/shadow2.png"
            anchors.left: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            opacity: 0.6 * root.scale
            z: 1
        }
    }
}
