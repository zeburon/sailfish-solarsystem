import QtQuick 2.0
import Sailfish.Silica 1.0

Label
{
    property real time

    // -----------------------------------------------------------------------

    color: Theme.highlightColor
    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
    onTimeChanged:
    {
        if (Math.abs(time) > 100)
        {
            text = "--:--";
            dateLabel.text = "";
            return;
        }

        var hours = Math.floor(time);
        var minutes = Math.floor((time - hours) * 60);

        // next day
        if (hours >= 24)
        {
            hours %= 24;
            dateLabel.text = "+1d";
        }
        // previous day
        else if (hours < 0)
        {
            hours = 24 + (hours % 24);
            dateLabel.text = "-1d";
        }
        else
        {
            dateLabel.text = "";
        }

        var hoursString = hours.toString();
        if (hours < 10)
            hoursString = "0" + hoursString;

        var minutesString = minutes.toString();
        if (minutes < 10)
            minutesString = "0" + minutesString;

        text = hoursString + ":" + minutesString;
    }

    // -----------------------------------------------------------------------

    Label
    {
        id: dateLabel

        color: Theme.secondaryHighlightColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        anchors { bottom: parent.top; horizontalCenter: parent.horizontalCenter }
        horizontalAlignment: Text.Center
        verticalAlignment: Text.Bottom
    }
}
