import QtQuick 2.0
import Sailfish.Silica 1.0

IconButton
{
    id: root

    // -----------------------------------------------------------------------

    property bool active: settings.trackNow

    // -----------------------------------------------------------------------

    signal signalActivated()

    // -----------------------------------------------------------------------

    icon.source: "image://theme/icon-m-up"
    opacity: active ? 1.0 : 0.5
    onClicked:
    {
        settings.animationEnabled = false;
        if (!active)
        {
            signalActivated();
        }
        settings.trackNow = !settings.trackNow;
    }

    // -----------------------------------------------------------------------

    Image
    {
        id: activeIndicator

        source: "../gfx/now.png"
        anchors { centerIn: parent }
        width: parent.width * 0.575
        height: width
        opacity: root.active ? 0.5 : 0.0

        // fade in/out
        Behavior on opacity
        {
            NumberAnimation
            {
                id: fadeAnimation

                duration: 200
            }
        }
        // rotate while active
        SequentialAnimation on rotation
        {
            running: true
            paused: !root.active || !page.active || !app.active
            loops: Animation.Infinite

            NumberAnimation { from: 0; to: 360; duration: 20000 }
        }
    }
}
