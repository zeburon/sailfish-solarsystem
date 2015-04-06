import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    property string dateFormat: settings.dateFormat
    property int dayLabelWidth: 30; property string dayLabelFormat: "dd"
    property int monthLabelWidth: 50; property string monthLabelFormat: "MMM"
    property int yearLabelWidth: 70; property string yearLabelFormat: "yyyy"

    property var labelWidths: [50, 50, 50]
    property var labelFormats: ["", "", ""]

    // -----------------------------------------------------------------------

    signal dateSelected();

    // -----------------------------------------------------------------------

    function selectDate()
    {
        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
        {
            date: settings.date,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        dialog.accepted.connect(function()
        {
            settings.date = dialog.date;
            dateSelected();
        })
    }

    // -----------------------------------------------------------------------

    function updateDateFormat()
    {
        var dateFormatParts = dateFormat.split("-");
        if (dateFormatParts.length === 3)
        {
            // note: values in a var array do not emit the 'changed' signal
            // however, changing the entire array at once does the trick.
            var newLabelWidths = labelWidths;
            var newLabelFormats = labelFormats;

            for(var idx = 0; idx < 3; ++idx)
            {
                switch (dateFormatParts[idx])
                {
                    case "dd":
                    {
                        labelWidths[idx] = dayLabelWidth;
                        labelFormats[idx] = dayLabelFormat;
                        break;
                    }
                    case "mmm":
                    {
                        labelWidths[idx] = monthLabelWidth;
                        labelFormats[idx] = monthLabelFormat;
                        break;
                    }
                    case "yyyy":
                    {
                        labelWidths[idx] = yearLabelWidth;
                        labelFormats[idx] = yearLabelFormat;
                        break;
                    }
                }
            }

            labelWidths = newLabelWidths;
            labelFormats = newLabelFormats;
        }
        else
        {
            console.log("illegal date format: " + dateFormat);
        }
    }

    // -----------------------------------------------------------------------

    height: yearLabel.height + Theme.paddingLarge
    onDateFormatChanged:
    {
        updateDateFormat();
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
            text: Qt.formatDate(settings.date, labelFormats[0])
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
            text: Qt.formatDate(settings.date, labelFormats[1])
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
            text: Qt.formatDate(settings.date, labelFormats[2])
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
