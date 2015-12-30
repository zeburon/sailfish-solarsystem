import QtQuick 2.0
import Sailfish.Silica 1.0

Item
{
    id: root

    // -----------------------------------------------------------------------

    property bool animated
    property bool highlighted: false

    // -----------------------------------------------------------------------

    Image
    {
        id: lightImage

        source: "../gfx/sun_light.png"
        anchors { centerIn: parent }
        opacity: 0.35 * parent.opacity // fade out even more
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
        id: bottomFlamesImage

        source: "../gfx/sun_flames.png"
        anchors { centerIn: parent }
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
        id: flaresImage

        source: "../gfx/sun_flares.png"
        opacity: 0.65
        anchors { centerIn: parent }

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
        id: topFlamesImage

        source: "../gfx/sun_flames.png"
        anchors { centerIn: parent }
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

    // -----------------------------------------------------------------------
    // optional highlight rendering
    Rectangle
    {
        anchors { centerIn: parent }
        width: bottomFlamesImage.width
        height: bottomFlamesImage.height
        radius: width / 2
        color: "transparent"
        border { color: Theme.highlightColor; width: 2 }
        z: 20
        visible: root.highlighted
    }
}
