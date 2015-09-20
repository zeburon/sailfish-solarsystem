import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property PlanetConfig planetConfig
    property real yOffset

    // -----------------------------------------------------------------------

    visible: planetConfig.visible

    // -----------------------------------------------------------------------

    Label
    {
        id: label

        text: planetConfig.name
        color: Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter; verticalCenterOffset: yOffset }
    }
}
