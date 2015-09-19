import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property PlanetInfo planetInfo
    property real yOffset

    // -----------------------------------------------------------------------

    visible: planetInfo.visible

    // -----------------------------------------------------------------------

    Label
    {
        id: label

        text: planetInfo.name
        color: Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: yOffset }
    }
}
