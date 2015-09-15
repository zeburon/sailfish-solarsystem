import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property string dateFormat: settings.dateFormat
    property int dayLabelWidth: 30; property string dayLabelFormat: "dd"
    property int monthLabelWidth: 50; property string monthLabelFormat: "MMM"
    property int yearLabelWidth: 70; property string yearLabelFormat: "yyyy"

    property var labelWidths: []
    property var labelFormats: []

    // -----------------------------------------------------------------------

    signal dateSelected();

    // -----------------------------------------------------------------------

    function selectDate()
    {
        // open dialog
        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
        {
            date: settings.date,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        // handle accept event
        dialog.accepted.connect(function()
        {
            settings.date = dialog.date;
            dateSelected();
        })
    }

    // -----------------------------------------------------------------------

    function applyDateFormat()
    {
        var dateFormatParts = dateFormat.split("-");
        if (dateFormatParts.length !== 3)
        {
            console.log("illegal date format: " + dateFormat);
            return;
        }

        // note: values in a var array do not emit the 'changed' signal
        // however, changing the entire array at once does the trick.
        var newLabelWidths = [0, 0, 0];
        var newLabelFormats = ["", "", ""];
        for(var idx = 0; idx < 3; ++idx)
        {
            switch (dateFormatParts[idx])
            {
                case "dd":
                {
                    newLabelWidths[idx] = dayLabelWidth;
                    newLabelFormats[idx] = dayLabelFormat;
                    break;
                }
                case "mmm":
                {
                    newLabelWidths[idx] = monthLabelWidth;
                    newLabelFormats[idx] = monthLabelFormat;
                    break;
                }
                case "yyyy":
                {
                    newLabelWidths[idx] = yearLabelWidth;
                    newLabelFormats[idx] = yearLabelFormat;
                    break;
                }
            }
        }
        labelWidths = newLabelWidths;
        labelFormats = newLabelFormats;
    }

    // -----------------------------------------------------------------------

    function getDateString(format)
    {
        var str = Qt.formatDate(settings.date, format);
        return str.substring(0, format.length);
    }

    // -----------------------------------------------------------------------

    height: yearLabel.height + Theme.paddingLarge
    onDateFormatChanged:
    {
        applyDateFormat();
    }

    // -----------------------------------------------------------------------

    Row
    {
        anchors { centerIn: parent }
        spacing: Theme.paddingLarge * 0.8

        Label
        {
            id: dayLabel

            width: labelWidths[0]
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: getDateString(labelFormats[0])
        }
        Label
        {
            color: Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: "-"
        }
        Label
        {
            id: monthLabel

            width: labelWidths[1]
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: getDateString(labelFormats[1])
        }
        Label
        {
            color: Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: "-"
        }
        Label
        {
            id: yearLabel

            width: labelWidths[2]
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: getDateString(labelFormats[2])
        }
    }
    MouseArea
    {
        anchors { fill: parent }
        onClicked:
        {
            selectDate();
        }
    }
}
