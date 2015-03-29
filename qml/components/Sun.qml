import QtQuick 2.0

Item
{
    property bool animated

    // -----------------------------------------------------------------------

    Image
    {
        source: "../gfx/sun_light.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.35
        scale: 2

        SequentialAnimation on rotation
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: 360; duration: 34000; easing.type: "Linear" }
        }
    }
    Image
    {
        source: "../gfx/sun_flames.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.75

        SequentialAnimation on rotation
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: -360; duration: 6000; easing.type: "Linear" }
        }
        SequentialAnimation on scale
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 1.0; to: 1.05; duration: 1000; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.05; to: 1.0; duration: 1200; easing.type: Easing.InOutSine }
        }
    }
    Image
    {
        source: "../gfx/sun_flares.png"
        opacity: 0.65
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        SequentialAnimation on rotation
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: -360; duration: 8000; easing.type: "Linear" }
        }
        SequentialAnimation on scale
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0.9; to: 1.0; duration: 1400; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.0; to: 0.9; duration: 1200; easing.type: Easing.InOutSine }
        }
    }
    Image
    {
        source: "../gfx/sun_flames.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        opacity: 0.35
        mirror: true

        SequentialAnimation on rotation
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: 360; duration: 4000; easing.type: "Linear" }
        }
        SequentialAnimation on scale
        {
            running: animated
            loops: Animation.Infinite

            NumberAnimation { from: 0.95; to: 1.0; duration: 800; easing.type: Easing.InOutSine }
            NumberAnimation { from: 1.0; to: 0.95; duration: 700; easing.type: Easing.InOutSine }
        }
    }
}
