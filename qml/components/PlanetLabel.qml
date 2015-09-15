import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property PlanetInfo planetInfo
    property real yOffset
    property real displayedX: planetInfo.displayedCoordinates[0]
    property real displayedY: planetInfo.displayedCoordinates[1]

    // -----------------------------------------------------------------------

    x: displayedX * currentZoom
    y: displayedY * currentZoom + yOffset * 0.75
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
