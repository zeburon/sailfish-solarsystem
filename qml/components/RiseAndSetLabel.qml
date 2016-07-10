import QtQuick 2.0
import Sailfish.Silica 1.0

Label
{
    property real time
    property bool highlighted: true

    // -----------------------------------------------------------------------

    color: highlighted ? Theme.highlightColor : Theme.primaryColor
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
        var daysString = "";
        if (hours >= 24)
        {
            hours %= 24;
            daysString = " +1d";
        }
        // previous day
        else if (hours < 0)
        {
            hours = 24 + (hours % 24);
            daysString = " -1d";
        }

        var hoursString = hours.toString();
        if (hours < 10)
            hoursString = "0" + hoursString;

        var minutesString = minutes.toString();
        if (minutes < 10)
            minutesString = "0" + minutesString;

        text = hoursString + ":" + minutesString + daysString;
    }
}
