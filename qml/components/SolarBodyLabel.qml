import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property SolarBody solarBody
    property real yOffset
    property real yOffsetScale: 1.0
    property bool highlight

    // -----------------------------------------------------------------------

    visible: solarBody.visible

    // -----------------------------------------------------------------------

    Label
    {
        id: label

        text: solarBody ? solarBody.name : "?"
        color: highlight ? Theme.highlightColor : Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.verticalCenter; topMargin: yOffset * yOffsetScale }
    }
}
