import QtQuick 2.0
import Sailfish.Silica 1.0

Column
{
    property string title
    property string value
    property string unit

    spacing: 0

    Label
    {
        id: titleLabel

        text: title
        width: parent.width
        color: Theme.primaryColor
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
    }
    Label
    {
        id: valueLabel

        text: value + " <sub>" + unit + "</sub>"
        color: Theme.secondaryColor
        height: contentHeight
        textFormat: Text.RichText
        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
    }
}
