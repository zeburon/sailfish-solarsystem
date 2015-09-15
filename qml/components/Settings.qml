import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "../storage.js" as Storage
import "../globals.js" as Globals
import "../calculation.js" as Calculation

QtObject
{
    property bool animationEnabled: false
    property int animationDirection: 1

    property bool showLabels: true;                      property string showLabelsKey: "showLabels"
    property bool showOrbits: true;                      property string showOrbitsKey: "showOrbits"
    property bool showDwarfPlanets: false;               property string showDwarfPlanetsKey: "showDwarfPlanets"
    property bool showZPosition: false;                  property string showZPositionKey: "showZPosition"
    property date date: new Date(Date.now());            property string dateKey: "date"
    property string dateFormat: Globals.DATE_FORMATS[0]; property string dateFormatKey: "dateFormat"
    property int animationIncrement: 1;                  property string animationIncrementKey: "animationIncrement"
    property bool simplifiedOrbits: true;                property string simplifiedOrbitsKey: "simplifiedOrbits"
    property bool zoomedOut: false;                      property string zoomedOutKey: "zoomedOut"
    property int distancePlanetIdx: 0;                   property string distancePlanetIdxKey: "distancePlanetIdx"

    // -----------------------------------------------------------------------

    function loadValues()
    {
        Storage.startInit();

        // load showOrbits
        var storedShowOrbits = Storage.getValue(showOrbitsKey);
        if (storedShowOrbits)
            showOrbits = storedShowOrbits === "true";

        // load showLabels
        var storedShowLabels = Storage.getValue(showLabelsKey);
        if (storedShowLabels)
            showLabels = storedShowLabels === "true";

        // load showDwarfPlanets
        var storedShowDwarfPlanets = Storage.getValue(showDwarfPlanetsKey);
        if (storedShowDwarfPlanets)
            showDwarfPlanets = storedShowDwarfPlanets === "true";

        // load showZPosition
        var storedShowZPosition = Storage.getValue(showZPositionKey);
        if (storedShowZPosition)
            showZPosition = storedShowZPosition === "true";

        // load date
        var storedDate = Storage.getValue(dateKey);
        if (storedDate)
        {
            date = new Date(storedDate);

            // check if stored date is actually valid
            if (!Calculation.isDateValid(date))
                date = new Date(Date.now());
        }

        // load dateFormat
        var storedDateFormat = Storage.getValue(dateFormatKey);
        if (storedDateFormat)
            dateFormat = storedDateFormat;

        // load animationIncrement
        var storedAnimationIncrement = Storage.getValue(animationIncrementKey);
        if (storedAnimationIncrement)
            animationIncrement = storedAnimationIncrement;

        // load simplifiedOrbits
        var storedSimplifiedOrbits = Storage.getValue(simplifiedOrbitsKey);
        if (storedSimplifiedOrbits)
            simplifiedOrbits = storedSimplifiedOrbits === "true";

        // load zoomedOut
        var storedZoomedOut = Storage.getValue(zoomedOutKey);
        if (storedZoomedOut)
            zoomedOut = storedZoomedOut === "true";

        // load distancePlanetIdx
        var storedDistancePlanetIdx = Storage.getValue(distancePlanetIdxKey);
        if (storedDistancePlanetIdx)
            distancePlanetIdx = storedDistancePlanetIdx;
    }

    // -----------------------------------------------------------------------

    function startStoringValueChanges()
    {
        Storage.finishInit();
    }

    // -----------------------------------------------------------------------

    onAnimationEnabledChanged:
    {
        if (!animationEnabled)
        {
            Storage.setValue(dateKey, date);
            Storage.setValue(animationIncrementKey, animationIncrement);
        }
    }
    onShowOrbitsChanged:
    {
        Storage.setValue(showOrbitsKey, showOrbits);
    }
    onShowLabelsChanged:
    {
        Storage.setValue(showLabelsKey, showLabels);
    }
    onShowDwarfPlanetsChanged:
    {
        Storage.setValue(showDwarfPlanetsKey, showDwarfPlanets);
    }
    onShowZPositionChanged:
    {
        Storage.setValue(showZPositionKey, showZPosition);
    }
    onDateChanged:
    {
        // value keeps changing as long as animation is enabled. store when animation is disabled
        if (!animationEnabled)
            Storage.setValue(dateKey, date);
    }
    onDateFormatChanged:
    {
        Storage.setValue(dateFormatKey, dateFormat);
    }
    onAnimationIncrementChanged:
    {
        // value can keep changing as long as animation is enabled. store when animation is disabled
        if (!animationEnabled)
            Storage.setValue(animationIncrementKey, animationIncrement);
    }
    onSimplifiedOrbitsChanged:
    {
        Storage.setValue(simplifiedOrbitsKey, simplifiedOrbits);
    }
    onZoomedOutChanged:
    {
        Storage.setValue(zoomedOutKey, zoomedOut);
    }
    onDistancePlanetIdxChanged:
    {
        Storage.setValue(distancePlanetIdxKey, distancePlanetIdx);
    }
}
