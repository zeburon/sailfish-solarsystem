import QtQuick 2.0
import Sailfish.Silica 1.0

IconButton
{
    property bool playing
    property int direction

    icon.source: playing ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
    onClicked:
    {
        if (!settings.animationEnabled || settings.animationDirection === direction)
            settings.animationEnabled = !settings.animationEnabled;

        settings.animationDirection = direction;
    }

    Image
    {
        id: playIndicator

        source: "../gfx/play.png"
        anchors { centerIn: parent }
        width: parent.width * 1.15
        height: width
        opacity: playing ? 0.35 : 0.0

        Behavior on opacity
        {
            NumberAnimation
            {
                id: fadeAnimation

                duration: 200
            }
        }
        SequentialAnimation on rotation
        {
            running: true
            paused: !playing || fadeAnimation.running
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: -360 * direction; duration: 2000 }
        }
    }
}
