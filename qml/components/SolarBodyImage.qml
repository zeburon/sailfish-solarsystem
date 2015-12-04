import QtQuick 2.0

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

    // -----------------------------------------------------------------------

    visible: solarBody.visible

    // -----------------------------------------------------------------------
    // actual image
    Image
    {
        id: image

        source: useSmallImage ? solarBody.smallImageSourceBottom : solarBody.mediumImageSourceBottom
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
        z: -10
    }

    // -----------------------------------------------------------------------
    // optional image rendered on top of everything (e.g. rings)
    Image
    {
        id: imageOnTop

        source: useSmallImage ? solarBody.smallImageSourceTop : solarBody.mediumImageSourceTop
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }
        antialiasing: true
        z: 10
    }
}
