import QtQuick 2.0

Item
{
    id: root

    property PlanetInfo planetInfo
    property alias size: image.height

    x: planetInfo.calculatedX * currentZoom
    y: planetInfo.calculatedY * currentZoom
    scale: imageScale * planetInfo.currentFadeOutValue
    opacity: imageOpacity

    Image
    {
        id: image

        source: planetInfo.imageSource
        antialiasing: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    Item
    {
        id: shadow

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        rotation: planetInfo.calculatedShadowRotation

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
