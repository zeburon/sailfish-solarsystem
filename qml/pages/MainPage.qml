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

    // -----------------------------------------------------------------------

    function init()
    {
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

    function repaint()
    {
        if (topView.visible)
            topView.requestPaint();
        else
            skyView.requestPaint();
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

    function showPlanetDetailsPage(solarBody)
    {
        planetDetailsPage.solarBody = solarBody;
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
            MenuItem
            {
                text: settings.showSkyView ? qsTr("Switch to Top View") : qsTr("Switch to Sky View")
                onClicked:
                {
                    settings.showSkyView = !settings.showSkyView;
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
                    visible: (!settings.simplifiedOrbits && topView.visible) || skyView.visible
                    source: settings.zoomedOut ? "../gfx/zoom_in.png" : "../gfx/zoom_out.png"
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
                    zoomedOut: settings.zoomedOut
                    animateSun: active && app.active
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
                MouseArea
                {
                    anchors { fill: parent }
                    enabled: topView.visible
                    onClicked:
                    {
                        var topViewCoordinates = parent.mapToItem(topView, mouse.x, mouse.y);
                        topView.click(topViewCoordinates.x, topViewCoordinates.y);
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
                    zoomedOut: settings.zoomedOut
                    animateZoom: app.initialized && visible
                    Component.onCompleted:
                    {
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

            // labels displaying the selected date
            DateDisplay
            {
                dateTime: page.dateTime
                width: column.width
            }

            // animation controls: start/stop animation and jump to current date
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
                            dateTime.setNow();
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
            // set animation speed
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
            if (settings.showSkyView)
            {
                var increment = 60 * 24.0 * (settings.animationIncrement / Globals.MAX_ANIMATION_INCREMENT);
                dateTime.addSeconds(increment * settings.animationDirection * 60);
            }
            else
            {
                dateTime.addDays(settings.animationIncrement * settings.animationDirection);
            }
        }
    }
}
