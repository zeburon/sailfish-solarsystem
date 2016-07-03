import QtQuick 2.0
import Sailfish.Silica 1.0

Label
{
    property real time
    property bool verticalMode: true
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

        color: highlighted ? Theme.secondaryHighlightColor : Theme.primaryColor
        font { family: Theme.fontFamily; pixelSize: verticalMode ? Theme.fontSizeTiny : Theme.fontSizeSmall }
        anchors { left: verticalMode ? undefined : parent.horizontalCenter; leftMargin: verticalMode ? 0 : parent.contentWidth / 2 + Theme.paddingSmall; verticalCenter: verticalMode ? undefined : parent.verticalCenter; bottom: verticalMode ? parent.top : undefined; horizontalCenter: verticalMode ? parent.horizontalCenter : undefined }
        horizontalAlignment: verticalMode ? Text.AlignHCenter : Text.Left
        verticalAlignment: verticalMode ? Text.Bottom : Text.AlignVCenter
    }
}
