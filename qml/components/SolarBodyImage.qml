import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property SolarBody solarBody
    property alias imageWidth: image.width
    property alias imageHeight: image.height
    property int totalWidth: Math.max(imageOnTop.width, image.width)
    property int totalHeight: Math.max(imageOnTop.height, image.height)
    property bool useSmallImage: true
    property bool useLargeImage: false // useSmallImage and useLargeImage are mutually exclusive
    property bool highlighted: false

    // -----------------------------------------------------------------------

    visible: solarBody.visible

    // -----------------------------------------------------------------------
    // actual image
    Image
    {
        id: image

        source: {
            if (useSmallImage)
                return solarBody.smallImageSourceBottom;
            if (useLargeImage)
                return solarBody.largeImageSourceBottom;
            return solarBody.mediumImageSourceBottom;
        }
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
        z: -10
    }

    // -----------------------------------------------------------------------
    // optional image rendered on top of everything (e.g. rings)
    Image
    {
        id: imageOnTop

        source: {
            if (useSmallImage)
                return solarBody.smallImageSourceTop;
            if (useLargeImage)
                return solarBody.largeImageSourceTop;
            return solarBody.mediumImageSourceTop;
        }
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
        z: 10
    }

    // -----------------------------------------------------------------------
    // optional highlight rendering
    Rectangle
    {
        anchors { centerIn: parent }
        width: root.imageWidth + border.width
        height: root.imageHeight + border.width
        radius: width / 2
        color: "transparent"
        border { color: Theme.highlightColor; width: 2 }
        z: 20
        visible: root.highlighted
    }
}
