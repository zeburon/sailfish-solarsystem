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
    property int animationIncrement: 5
    property string animationIncrementString: "animationIncrement"
    property bool simplifiedOrbits: true
    property string simplifiedOrbitsString: "simplifiedOrbits"
    property bool zoomedOut: false
    property string zoomedOutString: "zoomedOut"
    property int distancePlanetIdx: 0
    property string distancePlanetIdxString: "distancePlanetIdx"

    initialPage: page
    cover: cover
    Component.onCompleted:
    {
        Storage.startInit();
        var storedDate = Storage.getValue(dateString);
        if (storedDate)
            date = new Date(storedDate);

        var storedAnimationIncrement = Storage.getValue(animationIncrementString);
        if (storedAnimationIncrement)
            animationIncrement = storedAnimationIncrement;

        var storedShowOrbits = Storage.getValue(showOrbitsString);
        if (storedShowOrbits)
            showOrbits = storedShowOrbits === "true";

        var storedShowLabels = Storage.getValue(showLabelsString);
        if (storedShowLabels)
            showLabels = storedShowLabels === "true";

        var storedSimplifiedOrbits = Storage.getValue(simplifiedOrbitsString);
        if (storedSimplifiedOrbits)
            simplifiedOrbits = storedSimplifiedOrbits === "true";

        var storedZoomedOut = Storage.getValue(zoomedOutString);
        if (storedZoomedOut)
            zoomedOut = storedZoomedOut === "true";

        var storedDistancePlanceIdx = Storage.getValue(distancePlanetIdxString);
        if (storedDistancePlanceIdx)
            distancePlanetIdx = storedDistancePlanceIdx;

        Storage.finishInit();
        initialized = true;

        cover.refresh();
    }
    onActiveChanged:
    {
        animationEnabled = false;
        page.refresh();
    }
    onDateChanged:
    {
        if (!animationEnabled)
            Storage.setValue(dateString, date);
    }
    onAnimationEnabledChanged:
    {
        if (!animationEnabled)
            Storage.setValue(dateString, date);
    }
    onAnimationIncrementChanged:
    {
        Storage.setValue(animationIncrementString, animationIncrement);
    }
    onShowOrbitsChanged:
    {
        Storage.setValue(showOrbitsString, showOrbits);
    }
    onShowLabelsChanged:
    {
        Storage.setValue(showLabelsString, showLabels);
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
        id: page
    }
    CoverPage
    {
        id: cover
    }
}
