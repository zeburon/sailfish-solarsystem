import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../calculation.js" as Calculation

Page
{
    id: page

    property bool active: status === PageStatus.Active

    function selectDate()
    {
        if (pageStack.depth > 1)
        {
            // already selecting a date
            return;
        }
        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
        {
            date: app.date,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        dialog.accepted.connect(function()
        {
            app.date = dialog.date;
        })
    }

    function toggleZoom()
    {
        if (!app.simplifiedOrbits)
        {
            app.zoomedOut = !app.zoomedOut;
        }
    }

    function refresh()
    {
        solarSystem.paintOrbits();
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("About Solar System")
                onClicked:
                {
                    pageStack.push(Qt.resolvedUrl("AboutPage.qml"));
                }
            }
            MenuItem
            {
                text: app.showLabels ? qsTr("Hide Labels") : qsTr("Show Labels")
                onClicked:
                {
                    app.showLabels = !app.showLabels;
                }
            }
            MenuItem
            {
                text: app.showOrbits ? qsTr("Hide Orbits") : qsTr("Show Orbits")
                onClicked:
                {
                    app.showOrbits = !app.showOrbits;
                }
            }
            MenuItem
            {
                text: app.simplifiedOrbits ? qsTr("Realistic Orbits") : qsTr("Simplified Orbits")
                onClicked:
                {
                    app.simplifiedOrbits = !app.simplifiedOrbits;
                    if (!app.simplifiedOrbits)
                        zoomTextTimeout.start();
                }
            }
        }
        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingMedium

            PageHeader
            {
                title: qsTr("Solar System")

                Image
                {
                    id: zoomImage

                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingLarge
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !app.simplifiedOrbits
                    source: app.zoomedOut ? "image://theme/icon-camera-zoom-in" : "image://theme/icon-camera-zoom-out"
                }
                Text
                {
                    id: zoomText

                    anchors.left: zoomImage.right
                    anchors.verticalCenter: zoomImage.verticalCenter
                    anchors.margins: Theme.paddingSmall
                    text: qsTr("Click to toggle zoom")
                    visible: zoomImage.visible
                    color: Theme.secondaryHighlightColor
                    font.pixelSize: Theme.fontSizeTiny
                    opacity: zoomTextTimeout.running ? 1 : 0

                    Behavior on opacity
                    {
                        NumberAnimation { easing.type: Easing.InOutQuart; duration: 500 }
                    }
                }
                Timer
                {
                    id: zoomTextTimeout
                    repeat: false
                    running: false
                    interval: 3000
                }
                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        toggleZoom();
                    }
                }
            }
            SolarSystem
            {
                id: solarSystem

                width: column.width
                height: column.width
                showLabels: app.showLabels
                showOrbits: app.showOrbits
                date: app.date
                animationIncrement: app.animationIncrement
                simplifiedOrbits: app.simplifiedOrbits
                zoomedOut: app.zoomedOut
                animateSun: page.active && app.active
                animateZoom: app.initialized
                Component.onCompleted:
                {
                    solarSystem.clicked.connect(toggleZoom);
                    solarSystem.update();
                }
            }
            Label
            {
                width: parent.width
                height: font.pixelSize + Theme.paddingLarge
                horizontalAlignment: Text.AlignHCenter
                text: Qt.formatDate(app.date)
                color: Theme.primaryColor
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeLarge

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        selectDate();
                    }
                }
            }
            Row
            {
                spacing: Theme.paddingLarge * 2
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton
                {
                    id: togglePlayBackward

                    icon.source: (app.animationEnabled && app.animationDirection == -1) ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                    icon.mirror: true
                    onClicked:
                    {
                        if (!app.animationEnabled || app.animationDirection == -1)
                            app.animationEnabled = !app.animationEnabled;

                        app.animationDirection = -1;
                    }
                }
                Column
                {
                    spacing: 0

                    IconButton
                    {
                        id: restart

                        icon.source: "image://theme/icon-m-up"
                        opacity: 0.75
                        onClicked:
                        {
                            var newDate = new Date(Date.now());
                            newDate.setHours(0);
                            newDate.setMinutes(0);
                            app.date = newDate;
                        }
                    }
                    Label
                    {
                        text: qsTr("Today")
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeTiny
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                IconButton
                {
                    id: toggle_play_forward

                    icon.source: (app.animationEnabled && app.animationDirection == 1) ? "image://theme/icon-l-pause" : "image://theme/icon-l-play"
                    onClicked:
                    {
                        if (!app.animationEnabled || app.animationDirection == 1)
                            app.animationEnabled = !app.animationEnabled;

                        app.animationDirection = 1;
                    }
                }
            }
            Row
            {
                spacing: Theme.paddingMedium
                anchors.horizontalCenter: parent.horizontalCenter

                IconButton
                {
                    icon.source: "image://theme/icon-l-left"
                    enabled: app.animationIncrement > 1
                    onClicked:
                    {
                        if (app.animationIncrement <= 5)
                            app.animationIncrement -= 1;
                        else
                            app.animationIncrement -= 5;
                    }
                }
                Label
                {
                    text: qsTr("Increment: %1 day(s)").arg(app.animationIncrement)
                    color: Theme.highlightColor
                    font.family: Theme.fontFamilyHeading
                    anchors.verticalCenter: parent.verticalCenter
                }
                IconButton
                {
                    icon.source: "image://theme/icon-l-right"
                    enabled: app.animationIncrement < 200
                    onClicked:
                    {
                        if (app.animationIncrement < 5)
                            app.animationIncrement += 1;
                        else
                            app.animationIncrement += 5;
                    }
                }
            }
        }
    }
    Timer
    {
        id: timer

        interval: 50
        running: app.animationEnabled
        repeat: true
        onTriggered:
        {
            var newDate = new Date(app.date);
            newDate.setHours(0);
            newDate.setMinutes(0);
            newDate.setSeconds(0);
            newDate.setMilliseconds(0);

            newDate.setDate(newDate.getDate() + animationIncrement * app.animationDirection);

            // QDateTime documentation:
            // There is no year 0. Dates in that year are considered invalid.
            // The year -1 is the year "1 before Christ" or "1 before current era." The day before 1 January 1 CE is 31 December 1 BCE.

            // HOWEVER:
            // subtracting one day from january first of the year 1 will make the year jump to 0.
            // this makes the whole date invalid, as there is no year 0 according to the documentation.
            if (newDate.getFullYear() === 0)
            {
                newDate.setFullYear(app.animationDirection);
            }
            // next problem: if we assign a date with a negative year to a different date, the year is increased by one.
            // year -1 becomes year 0, which is invalid yet again.
            // 'solution': subtract one year, which will be added again during assignment.
            if (newDate.getFullYear() < 0)
            {
                newDate.setFullYear(newDate.getFullYear() - 1);
            }


            if (Calculation.isDateValid(newDate))
            {
                app.date = newDate;
            }
            else
            {
                console.log("reached illegal date. stopping animation");
                app.animationEnabled = false;
            }
        }
    }
}
