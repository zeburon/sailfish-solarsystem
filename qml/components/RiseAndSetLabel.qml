import QtQuick 2.0
import Sailfish.Silica 1.0

Label
{
    property real time

    text: {
        if (Math.abs(time) > 24)
            return "--:--";

        var hours = Math.floor(time);
        var minutes = Math.floor((time - hours) * 60);

        var hoursString = hours.toString();
        if (hours < 10)
            hoursString = "0" + hoursString;

        var minutesString = minutes.toString();
        if (minutes < 10)
            minutesString = "0" + minutesString;

        return hoursString + ":" + minutesString;
    }

    color: Theme.highlightColor
    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
}
