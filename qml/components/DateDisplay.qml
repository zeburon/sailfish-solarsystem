import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    height: yearLabel.height + Theme.paddingLarge

    // -----------------------------------------------------------------------

    Row
    {
        anchors.centerIn: parent
        spacing: Theme.paddingLarge * 0.8

        Label
        {
            id: dayLabel

            width: 30
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            text: Qt.formatDate(settings.date, "dd")
        }
        Label
        {
            color: Theme.secondaryColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            text: "-"
        }
        Label
        {
            id: monthLabel

            width: 50
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            text: Qt.formatDate(settings.date, "MMM")
        }
        Label
        {
            color: Theme.secondaryColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            text: "-"
        }
        Label
        {
            id: yearLabel

            width: 70
            horizontalAlignment: Text.AlignHCenter
            color: Theme.primaryColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeLarge
            text: Qt.formatDate(settings.date, "yyyy")
        }
    }
}
