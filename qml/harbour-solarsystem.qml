import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Sailfish.Silica 1.0

import "cover"
import "pages"
import "storage.js" as Storage

ApplicationWindow
{
    id: app

    property bool active: Qt.application.state === Qt.ApplicationActive
    property bool initialized: false

    property bool animationEnabled: false
    property int animationDirection: 1

    property bool showLabels: true
    property string showLabelsString: "showLabels"
    property bool showOrbits: true
    property string showOrbitsString: "showOrbits"
    property date date: new Date(Date.now())
    property string dateString: "date"
    property int animationIncrement: 1
    property string animationIncrementString: "animationIncrement"
    property bool simplifiedOrbits: true
    property string simplifiedOrbitsString: "simplifiedOrbits"
    property bool zoomedOut: false
    property string zoomedOutString: "zoomedOut"
    property int distancePlanetIdx: 0
    property string distancePlanetIdxString: "distancePlanetIdx"

    initialPage: mainPage
    cover: cover

    Component.onCompleted:
    {
        Storage.startInit();

        // load date
        var storedDate = Storage.getValue(dateString);
        if (storedDate)
            date = new Date(storedDate);

        // load animationIncrement
        var storedAnimationIncrement = Storage.getValue(animationIncrementString);
        if (storedAnimationIncrement)
            animationIncrement = storedAnimationIncrement;

        // load showOrbits
        var storedShowOrbits = Storage.getValue(showOrbitsString);
        if (storedShowOrbits)
            showOrbits = storedShowOrbits === "true";

        // load showLabels
        var storedShowLabels = Storage.getValue(showLabelsString);
        if (storedShowLabels)
            showLabels = storedShowLabels === "true";

        // load simplifiedOrbits
        var storedSimplifiedOrbits = Storage.getValue(simplifiedOrbitsString);
        if (storedSimplifiedOrbits)
            simplifiedOrbits = storedSimplifiedOrbits === "true";

        // load zoomedOut
        var storedZoomedOut = Storage.getValue(zoomedOutString);
        if (storedZoomedOut)
            zoomedOut = storedZoomedOut === "true";

        // load distancePlanetIdx
        var storedDistancePlanetIdx = Storage.getValue(distancePlanetIdxString);
        if (storedDistancePlanetIdx)
            distancePlanetIdx = storedDistancePlanetIdx;

        mainPage.init();
        Storage.finishInit();
        initialized = true;
        cover.refresh();
    }
    onActiveChanged:
    {
        animationEnabled = false;
        mainPage.refresh();
    }
    onAnimationEnabledChanged:
    {
        if (!animationEnabled)
        {
            Storage.setValue(dateString, date);
            Storage.setValue(animationIncrementString, animationIncrement);
        }
    }
    onShowOrbitsChanged:
    {
        Storage.setValue(showOrbitsString, showOrbits);
    }
    onShowLabelsChanged:
    {
        Storage.setValue(showLabelsString, showLabels);
    }
    onDateChanged:
    {
        // value keeps changing as long as animation is enabled. store when animation is disabled
        if (!animationEnabled)
            Storage.setValue(dateString, date);
    }
    onAnimationIncrementChanged:
    {
        // value keeps changing as long as animation is enabled. store when animation is disabled
        if (!animationEnabled)
            Storage.setValue(animationIncrementString, animationIncrement);
    }
    onSimplifiedOrbitsChanged:
    {
        Storage.setValue(simplifiedOrbitsString, simplifiedOrbits);
    }
    onZoomedOutChanged:
    {
        Storage.setValue(zoomedOutString, zoomedOut);
    }
    onDistancePlanetIdxChanged:
    {
        Storage.setValue(distancePlanetIdxString, distancePlanetIdx);
    }

    MainPage
    {
        id: mainPage
    }
    CoverPage
    {
        id: cover
    }
}
