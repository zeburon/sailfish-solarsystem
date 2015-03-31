import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../calculation.js" as Calculation
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool pageActive: status === PageStatus.Active
    property bool animatingBackward: settings.animationEnabled && settings.animationDirection === -1
    property bool animatingForward: settings.animationEnabled && settings.animationDirection === 1

    // -----------------------------------------------------------------------

    function init()
    {
        loadAnimationIncrement();
        solarSystem.updatePlanetPositions();
    }

    // -----------------------------------------------------------------------

    function refresh()
    {
        solarSystem.paintOrbits();
    }

    // -----------------------------------------------------------------------

    function selectDate()
    {
        if (pageStack.depth > 1)
        {
            // already selecting a date
            return;
        }
        var dialog = pageStack.push("Sailfish.Silica.DatePickerDialog",
        {
            date: settings.date,
            allowedOrientations: Orientation.Landscape | Orientation.Portrait | Orientation.LandscapeInverted
        })

        dialog.accepted.connect(function()
        {
            settings.date = dialog.date;
        })
    }

    // -----------------------------------------------------------------------

    function toggleZoom()
    {
        if (!settings.simplifiedOrbits)
        {
            settings.zoomedOut = !settings.zoomedOut;
        }
    }

    // -----------------------------------------------------------------------

    function loadAnimationIncrement()
    {
        var diff = Globals.MAX_ANIMATION_INCREMENT - Globals.MIN_ANIMATION_INCREMENT;
        var s = (settings.animationIncrement - Globals.MIN_ANIMATION_INCREMENT) / diff;
        s = Math.max(0.0, Math.min(1.0, s));
        animationIncrementSlider.value = Math.pow(s, 1.0 / 3.0);
    }

    // -----------------------------------------------------------------------

    function saveAnimationIncrement()
    {
        var s = Math.pow(animationIncrementSlider.value, 3.0);
        settings.animationIncrement = Math.round(Globals.MIN_ANIMATION_INCREMENT * (1.0 - s) + Globals.MAX_ANIMATION_INCREMENT * s);
    }

    // -----------------------------------------------------------------------

    onPageActiveChanged:
    {
        settings.animationEnabled = false;
    }

    // -----------------------------------------------------------------------

    SilicaFlickable
    {
        anchors { fill: parent }
        contentHeight: column.height
        visible: app.initialized

        PullDownMenu
        {
            MenuItem
            {
                text: qsTr("About Solar System")
                onClicked:
                {
                    pageStack.push(aboutPage);
                }
            }
            MenuItem
            {
                text: qsTr("Settings")
                onClicked:
                {
                    pageStack.push(settingsPage);
                }
            }
        }
        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: qsTr("Solar System")

                Image
                {
                    id: zoomImage

                    anchors { left: parent.left; leftMargin: Theme.paddingLarge; verticalCenter: parent.verticalCenter }
                    visible: !settings.simplifiedOrbits
                    source: settings.zoomedOut ? "image://theme/icon-camera-zoom-in" : "image://theme/icon-camera-zoom-out"
                }
                Text
                {
                    id: zoomText

                    anchors { left: zoomImage.right; verticalCenter: zoomImage.verticalCenter; margins: Theme.paddingSmall }
                    text: qsTr("Click to toggle zoom")
                    visible: zoomImage.visible
                    color: Theme.secondaryHighlightColor
                    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
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
                    anchors { fill: parent }
                    onClicked:
                    {
                        toggleZoom();
                    }
                }
            }

            Item
            {
                width: column.width
                height: column.width

                SolarSystem
                {
                    id: solarSystem

                    anchors { centerIn: parent; horizontalCenterOffset: currentOffsetX; verticalCenterOffset: currentOffsetY }
                    width: parent.width
                    height: parent.height
                    showLabels: settings.showLabels
                    showOrbits: settings.showOrbits
                    showDwarfPlanets: settings.showDwarfPlanets
                    showZPosition: settings.showZPosition
                    date: settings.date
                    animationIncrement: settings.animationIncrement
                    simplifiedOrbits: settings.simplifiedOrbits
                    zoomedOut: settings.zoomedOut
                    animateSun: pageActive && app.active
                    animateZoom: app.initialized
                    Component.onCompleted:
                    {
                        solarSystem.clicked.connect(toggleZoom);
                    }
                }
            }

            DateDisplay
            {
                width: column.width

                MouseArea
                {
                    anchors { fill: parent }
                    onClicked:
                    {
                        selectDate();
                    }
                }
            }

            Row
            {
                spacing: Theme.paddingLarge * 2
                anchors { horizontalCenter: parent.horizontalCenter }

                PlayButton
                {
                    id: toggleAnimateBackward

                    direction: -1
                    playing: animatingBackward
                    icon.mirror: true
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
                            settings.date = newDate;
                        }
                    }
                    Label
                    {
                        text: qsTr("Today")
                        color: Theme.secondaryHighlightColor
                        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
                        anchors { horizontalCenter: parent.horizontalCenter }
                    }
                }
                PlayButton
                {
                    id: toggleAnimateForward

                    direction: 1
                    playing: animatingForward
                }
            }
            Slider
            {
                id: animationIncrementSlider

                width: parent.width
                anchors { horizontalCenter: parent.horizontalCenter }
                minimumValue: 0
                maximumValue: 1
                handleVisible: true
                label: qsTr("Animation Speed")
                onValueChanged:
                {
                    saveAnimationIncrement();
                }
            }
        }
    }
    Timer
    {
        id: timer

        interval: Globals.ANIMATION_INTERVAL_MS
        running: settings.animationEnabled
        repeat: true
        onTriggered:
        {
            var newDate = new Date(settings.date);
            newDate.setHours(12);
            newDate.setMinutes(0);
            newDate.setDate(newDate.getDate() + settings.animationIncrement * settings.animationDirection);

            // QDateTime documentation:
            // There is no year 0. Dates in that year are considered invalid.
            // The year -1 is the year "1 before Christ" or "1 before current era." The day before 1 January 1 CE is 31 December 1 BCE.

            // HOWEVER:
            // subtracting one day from january first of the year 1 will make the year jump to 0.
            // this makes the whole date invalid, as there is no year 0 according to the documentation.
            if (newDate.getFullYear() === 0)
            {
                newDate.setFullYear(settings.animationDirection);
            }
            // next problem: if we assign a date with a negative year to a different date, the year is increased by one.
            // year -1 becomes year 0, which is invalid yet again.
            // 'solution': subtract one year, which will be added again during assignment.
            // note: same behavior if you have a binding to a date
            // the whole thing smells like a bug :)
            if (newDate.getFullYear() < 0)
            {
                newDate.setFullYear(newDate.getFullYear() - 1);
            }

            // final check... just to be on the safe side
            if (Calculation.isDateValid(newDate))
            {
                settings.date = newDate;
            }
            else
            {
                console.log("reached illegal date. stopping animation");
                settings.animationEnabled = false;
            }
        }
    }
}
