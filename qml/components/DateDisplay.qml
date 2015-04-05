import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
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

    height: yearLabel.height + Theme.paddingLarge

    // -----------------------------------------------------------------------

    Row
    {
        anchors { centerIn: parent }
        spacing: Theme.paddingLarge * 0.8

        Label
        {
            id: dayLabel

            width: 30
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: Qt.formatDate(settings.date, "dd")
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

            width: 50
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: Qt.formatDate(settings.date, "MMM")
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

            width: 70
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeLarge }
            text: Qt.formatDate(settings.date, "yyyy")
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
