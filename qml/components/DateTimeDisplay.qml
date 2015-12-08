import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.DateTime 1.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property DateTime dateTime
    property bool showTime: false

    property string dateFormat: settings.dateFormat
    property int dayLabelWidth: 30; property string dayLabelFormat: "dd"
    property int monthLabelWidth: 50; property string monthLabelFormat: "MMM"
    property int yearLabelWidth: 70; property string yearLabelFormat: "yyyy"
    property int hourLabelWidth: 30; property string hourLabelFormat: "hh"
    property int minuteLabelWidth: 30; property string minuteLabelFormat: "mm"

    property var dateLabelWidths: []
    property var dateLabelFormats: []

    // -----------------------------------------------------------------------

    signal dateTimeSelected()

    // -----------------------------------------------------------------------

    function selectDate()
    {
        // open dialog
        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
        {
            date: dateTime.value,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        // handle accept event
        dialog.accepted.connect(function()
        {
            dateTime.setDate(dialog.date.getFullYear(), dialog.date.getMonth() + 1, dialog.date.getDate());
            dateTimeSelected();
        })
    }

    // -----------------------------------------------------------------------

    function selectTime()
    {
        // open dialog
        var dialog = pageStack.push("Sailfish.Silica.TimePickerDialog",
        {
            hour: dateTime.hours,
            minute: dateTime.minutes,
            hourMode: DateTime.TwentyFourHours,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        // handle accept event
        dialog.accepted.connect(function()
        {
            dateTime.setTime(dialog.hour, dialog.minute, 0);
            dateTimeSelected();
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
        dateLabelWidths = newLabelWidths;
        dateLabelFormats = newLabelFormats;
    }

    // -----------------------------------------------------------------------

    function getDateTimeString(format)
    {
        var str = Qt.formatDateTime(dateTime.value, format);

        // make sure "abbreviated localized month name" is always the same length
        if (format === monthLabelFormat)
            str = str.substring(0, format.length);

        return str;
    }

    // -----------------------------------------------------------------------

    height: Theme.fontSizeLarge + Theme.paddingLarge
    onDateFormatChanged:
    {
        applyDateFormat();
    }

    // -----------------------------------------------------------------------

    Item
    {
        id: dateSelector

        width: timeSelector.visible ? parent.width * 0.65 : parent.width
        height: parent.height

        Row
        {
            anchors { centerIn: parent }
            spacing: Theme.paddingLarge * 0.8

            Label
            {
                id: dayLabel

                width: dateLabelWidths[0]
                horizontalAlignment: Text.AlignHCenter
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: getDateTimeString(dateLabelFormats[0])
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

                width: dateLabelWidths[1]
                horizontalAlignment: Text.AlignHCenter
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: getDateTimeString(dateLabelFormats[1])
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

                width: dateLabelWidths[2]
                horizontalAlignment: Text.AlignHCenter
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: getDateTimeString(dateLabelFormats[2])
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

    Item
    {
        id: timeSelector

        anchors { left: dateSelector.right; right: parent.right; verticalCenter: parent.verticalCenter }
        height: parent.height
        visible: root.showTime

        Row
        {
            anchors { centerIn: parent }
            spacing: Theme.paddingLarge * 0.8

            Label
            {
                id: hourLabel

                width: hourLabelWidth
                horizontalAlignment: Text.AlignHCenter
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: getDateTimeString(hourLabelFormat)
            }
            Label
            {
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: ":"
            }
            Label
            {
                id: minuteLabel

                width: minuteLabelWidth
                horizontalAlignment: Text.AlignHCenter
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
                text: getDateTimeString(minuteLabelFormat)
            }
        }
        MouseArea
        {
            anchors { fill: parent }
            onClicked:
            {
                selectTime();
            }
        }
    }
}
