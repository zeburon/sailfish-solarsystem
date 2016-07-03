import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.DateTime 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool active: status === PageStatus.Active
    property bool initialized: false
    property bool animatingBackward: settings.animationEnabled && settings.animationDirection === -1
    property bool animatingForward: settings.animationEnabled && settings.animationDirection === 1
    property bool showHelpTextWhenActivated: true
    property alias solarSystem: topView.solarSystem
    property alias dateTime: dateTime

    property real currentAnimationIncrementInMinutes:
    {
        if (settings.showSkyView)
            return 60 * 24 * (settings.animationIncrement / Globals.MAX_ANIMATION_INCREMENT);
        else
            return 60 * 24 * settings.animationIncrement;
    }
    property string currentAnimationIncrementInMinutesString:
    {
        var days    = Math.floor(currentAnimationIncrementInMinutes / (60 * 24));
        var hours   = Math.floor((currentAnimationIncrementInMinutes - days * 60 * 24) / 60);
        var minutes = Math.floor(currentAnimationIncrementInMinutes - days * 60 * 24 - hours * 60);

        var result = "";
        if (days > 0)
            result += days + "d";
        if (hours > 0)
        {
            if (result.length > 0 && hours <= 9)
                result += "0";

            result += hours + "h";
        }
        if (minutes > 0)
        {
            if (result.length > 0 && minutes <= 9)
                result += "0";

            result += minutes + "m";
        }

        return result;
    }

    // -----------------------------------------------------------------------

    function init()
    {
        if (settings.trackNow || settings.dateTime === "")
            dateTime.setNow();
        else
            dateTime.string = settings.dateTime;

        loadAnimationIncrement();
        topView.init();
        skyView.init();
        initialized = true;
    }

    // -----------------------------------------------------------------------

    function update()
    {
        if (!initialized)
            return;

        if (topView.visible)
            topView.update(dateTime);
        else
            skyView.update(dateTime);
    }

    // -----------------------------------------------------------------------

    function reactivate()
    {
        if (topView.visible)
            topView.requestPaint();
        else
            skyView.repaintCanvasAndImages();
    }

    // -----------------------------------------------------------------------

    function loadAnimationIncrement()
    {
        var diff = Globals.MAX_ANIMATION_INCREMENT - Globals.MIN_ANIMATION_INCREMENT;
        var s = (settings.animationIncrement - Globals.MIN_ANIMATION_INCREMENT) / diff;
        s = Math.max(0.0, Math.min(1.0, s));
        animationIncrementSlider.value = Math.pow(s, 1.0 / Globals.ANIMATION_EXPONENT);
    }

    // -----------------------------------------------------------------------

    function saveAnimationIncrement()
    {
        var s = Math.pow(animationIncrementSlider.value, Globals.ANIMATION_EXPONENT);
        settings.animationIncrement = Math.round(Globals.MIN_ANIMATION_INCREMENT * (1.0 - s) + Globals.MAX_ANIMATION_INCREMENT * s);
    }

    // -----------------------------------------------------------------------

    function toggleZoom()
    {
        if (topView.visible)
        {
            if (!settings.simplifiedOrbits)
                settings.zoomedOutTopView = !settings.zoomedOutTopView;
        }
        else
        {
            settings.zoomedOutSkyView = !settings.zoomedOutSkyView;
        }
    }

    // -----------------------------------------------------------------------

    function showPlanetDetailsPage(solarBody, solarSystem)
    {
        planetDetailsPage.solarBody = solarBody;
        planetDetailsPage.solarSystem = solarSystem;
        pageStack.push(planetDetailsPage);
    }

    // -----------------------------------------------------------------------

    function showHelpText(text)
    {
        helpText.text = text;
        helpTextTimer.start();
    }

    // -----------------------------------------------------------------------

    onActiveChanged:
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

            // header: zoom button, help text and title
            PageHeader
            {
                title: qsTr("Solar System")

                Image
                {
                    id: zoomImage

                    anchors { left: parent.left; leftMargin: Theme.paddingLarge; verticalCenter: parent.verticalCenter }
                    visible: (topView.visible && !settings.simplifiedOrbits) || skyView.visible
                    source: (topView.visible && settings.zoomedOutTopView) || (skyView.visible && settings.zoomedOutSkyView) ? "../gfx/zoom_in.png" : "../gfx/zoom_out.png"
                }
                Text
                {
                    id: helpText

                    anchors { left: zoomImage.left; leftMargin: zoomImage.visible ? zoomImage.width : 0; verticalCenter: zoomImage.verticalCenter; margins: Theme.paddingSmall }
                    color: Theme.secondaryHighlightColor
                    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
                    opacity: helpTextTimer.running ? 1 : 0

                    Behavior on opacity
                    {
                        NumberAnimation { easing.type: Easing.InOutQuart; duration: 500 }
                    }
                }
                Timer
                {
                    id: helpTextTimer

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

            // solar system visualization
            Item
            {
                width: column.width
                height: column.width

                TopView
                {
                    id: topView

                    anchors { centerIn: parent; horizontalCenterOffset: currentOffsetX; verticalCenterOffset: currentOffsetY }
                    width: parent.width
                    height: parent.height
                    showLabels: settings.showLabels
                    showOrbits: settings.showOrbits
                    showDwarfPlanets: settings.showDwarfPlanets
                    zoomedOut: settings.zoomedOutTopView
                    animateSun: app.active && visible
                    animateZoom: app.initialized && visible
                    simplifiedOrbits: settings.simplifiedOrbits
                    visible: !settings.showSkyView
                    Component.onCompleted:
                    {
                        clickedOnEmptySpace.connect(page.toggleZoom);
                        clickedOnPlanet.connect(page.showPlanetDetailsPage);
                        showHelpText.connect(page.showHelpText);
                    }
                    onVisibleChanged:
                    {
                        if (visible)
                        {
                            page.update();
                        }
                    }
                }
                SkyView
                {
                    id: skyView

                    width: parent.width
                    height: parent.width
                    clip: true
                    visible: settings.showSkyView
                    showLabels: settings.showLabels
                    showAzimuth: settings.showAzimuth
                    showEcliptic: settings.showEcliptic
                    showEquator: settings.showEquator
                    showBackground: settings.showBackground
                    zoomedOut: settings.zoomedOutSkyView
                    animateSun: app.active && visible
                    animateZoom: app.initialized && visible
                    Component.onCompleted:
                    {
                        clickedOnEmptySpace.connect(page.toggleZoom);
                        clickedOnPlanet.connect(page.showPlanetDetailsPage);
                        showHelpText.connect(page.showHelpText);
                    }
                    onVisibleChanged:
                    {
                        if (visible)
                        {
                            page.update();
                        }
                    }
                }
            }

            // labels displaying the selected date + time
            DateTimeDisplay
            {
                dateTime: page.dateTime
                showTime: settings.showSkyView
                width: column.width
                onDateTimeSelected:
                {
                    settings.trackNow = false;
                }
            }

            // animation controls: start/stop animation and jump to current date
            Row
            {
                spacing: Theme.paddingLarge * 2
                anchors { horizontalCenter: parent.horizontalCenter }

                // animate backward
                PlayButton
                {
                    id: toggleAnimateBackward

                    direction: -1
                    active: animatingBackward
                }
                // jump to current date
                Item
                {
                    width: nowButton.width
                    height: parent.height

                    NowButton
                    {
                        id: nowButton

                        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top }
                        onSignalActivated:
                        {
                            dateTime.setNow();
                        }
                    }
                    Label
                    {
                        anchors { horizontalCenter: parent.horizontalCenter; top: nowButton.bottom; topMargin: -Theme.fontSizeTiny }
                        text: topView.visible ? qsTr("Today") : qsTr("Now")
                        color: Theme.secondaryHighlightColor
                        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
                    }
                }
                // animate forward
                PlayButton
                {
                    id: toggleAnimateForward

                    direction: 1
                    active: animatingForward
                }
            }

            // set animation speed
            Item
            {
                width: parent.width
                height: 1
                z: -1

                Slider
                {
                    id: animationIncrementSlider

                    width: parent.width
                    anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: -Theme.fontSizeTiny }
                    minimumValue: 0
                    maximumValue: 1
                    handleVisible: true
                    label: qsTr("Animation Speed")
                    valueText: currentAnimationIncrementInMinutesString
                    onValueChanged:
                    {
                        saveAnimationIncrement();
                    }
                }
            }
        }

        PushUpMenu
        {
            MenuItem
            {
                text: settings.showSkyView ? qsTr("Switch to Top View") : qsTr("Switch to Sky View")
                onClicked:
                {
                    settings.showSkyView = !settings.showSkyView;
                }
            }

            // top view settings
            MenuItem
            {
                text: settings.simplifiedOrbits ? qsTr("Switch to realistic mode") : qsTr("Switch to simplified mode")
                visible: !settings.showSkyView
                onClicked:
                {
                    settings.simplifiedOrbits = !settings.simplifiedOrbits;
                    page.update();
                }
            }
            MenuItem
            {
                text: settings.showOrbits ? qsTr("Hide planet orbits") : qsTr("Show planet orbits")
                visible: !settings.showSkyView
                onClicked:
                {
                    settings.showOrbits = !settings.showOrbits;
                    page.update();
                }
            }

            // sky view settings
            MenuItem
            {
                text: settings.trackOrientation ? qsTr("Stop tracking orientation") : qsTr("Start tracking orientation")
                visible: settings.showSkyView
                onClicked:
                {
                    settings.trackOrientation = !settings.trackOrientation;
                }
            }
            /*
            MenuItem
            {
                text: settings.showAzimuth ? qsTr("Hide Azimuth") : qsTr("Show Azimuth")
                visible: settings.showSkyView
                onClicked:
                {
                    settings.showAzimuth = !settings.showAzimuth;
                    page.update();
                }
            }
            */
            MenuItem
            {
                text: settings.showEcliptic ? qsTr("Hide Ecliptic") : qsTr("Show Ecliptic")
                visible: settings.showSkyView
                onClicked:
                {
                    settings.showEcliptic = !settings.showEcliptic;
                    page.update();
                }
            }
            MenuItem
            {
                text: settings.showEquator ? qsTr("Hide Equator") : qsTr("Show Equator")
                visible: settings.showSkyView
                onClicked:
                {
                    settings.showEquator = !settings.showEquator;
                    page.update();
                }
            }
        }
    }

    // time information used by top and sky views
    DateTime
    {
        id: dateTime

        onStringChanged:
        {
            settings.dateTime = string;
            update();
        }
    }
    Timer
    {
        id: animationTimer

        interval: Globals.ANIMATION_INTERVAL_MS
        running: settings.animationEnabled
        repeat: true
        onTriggered:
        {
            dateTime.addMinutes(currentAnimationIncrementInMinutes * settings.animationDirection);
        }
    }
    Timer
    {
        id: trackNowTimer

        interval: Globals.TRACK_NOW_INTERVAL_MS
        running: settings.trackNow && page.active && app.active
        repeat: true
        triggeredOnStart: true
        onTriggered:
        {
            dateTime.setNow();
        }
    }
}
