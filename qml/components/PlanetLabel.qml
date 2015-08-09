import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property PlanetInfo planetInfo
    property real yOffset

    // -----------------------------------------------------------------------

    x: planetInfo.displayedX * currentZoom
    y: planetInfo.displayedY * currentZoom + yOffset * 0.75
    opacity: planetInfo.currentOpacityFactor
    visible: planetInfo.visible

    // -----------------------------------------------------------------------

    Label
    {
        id: label

        text: planetInfo.name
        color: Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        anchors { centerIn: parent }
    }
}
