import QtQuick 2.0
import QtQuick.LocalStorage 2.0

import "../storage.js" as Storage
import "../globals.js" as Globals

QtObject
{
    property bool animationEnabled: false
    property int animationDirection: 1

    property bool showLabels: true;                                property string showLabelsKey: "showLabels"
    property bool showOrbits: true;                                property string showOrbitsKey: "showOrbits"
    property bool showDwarfPlanets: false;                         property string showDwarfPlanetsKey: "showDwarfPlanets"
    property bool showSkyView: false;                              property string showSkyViewKey: "showSkyView"
    property bool showEcliptic: true;                              property string showEclipticKey: "showEcliptic"
    property bool showEquator: false;                              property string showEquatorKey: "showEquator"
    property bool showAzimuth: false;                              property string showAzimuthKey: "showAzimuth"
    property bool showBackground: false;                           property string showBackgroundKey: "showBackground"
    property string dateTime: "";                                  property string dateTimeKey: "dateTime"
    property string dateFormat: Globals.DATE_FORMATS[0];           property string dateFormatKey: "dateFormat"
    property string pressureUnit: Globals.PRESSURE_UNITS[0];       property string pressureUnitKey: "pressureUnit"
    property string temperatureUnit: Globals.TEMPERATURE_UNITS[0]; property string temperatureUnitKey: "temperatureUnit"
    property int animationIncrement: 1;                            property string animationIncrementKey: "animationIncrement"
    property bool simplifiedOrbits: true;                          property string simplifiedOrbitsKey: "simplifiedOrbits"
    property bool zoomedOutTopView: false;                         property string zoomedOutTopViewKey: "zoomedOutTopView"
    property bool zoomedOutSkyView: false;                         property string zoomedOutSkyViewKey: "zoomedOutSkyView"
    property bool trackNow: false;                                 property string trackNowKey: "trackNow"
    property bool trackOrientation: false;                         property string trackOrientationKey: "trackOrientation"
    property int distancePlanetIdx: 0;                             property string distancePlanetIdxKey: "distancePlanetIdx"

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

        // load showSkyView
        var storedShowSkyView = Storage.getValue(showSkyViewKey);
        if (storedShowSkyView)
            showSkyView = storedShowSkyView === "true";

        // load showEcliptic
        var storedShowEcliptic = Storage.getValue(showEclipticKey);
        if (storedShowEcliptic)
            showEcliptic = storedShowEcliptic === "true";

        // load showEquator
        var storedShowEquator = Storage.getValue(showEquatorKey);
        if (storedShowEquator)
            showEquator = storedShowEquator === "true";

        // load showAzimuth
        var storedShowAzimuth = Storage.getValue(showAzimuthKey);
        if (storedShowAzimuth)
            showAzimuth = storedShowAzimuth === "true";

        // load showBackground
        var storedShowBackground = Storage.getValue(showBackgroundKey);
        if (storedShowBackground)
            showBackground = storedShowBackground === "true";

        // load dateTime
        var storedDateTime = Storage.getValue(dateTimeKey);
        if (storedDateTime)
            dateTime = storedDateTime;

        // load dateFormat
        var storedDateFormat = Storage.getValue(dateFormatKey);
        if (storedDateFormat)
            dateFormat = storedDateFormat;

        // load pressureUnit
        var storedPressureUnit = Storage.getValue(pressureUnitKey);
        if (storedPressureUnit)
            pressureUnit = storedPressureUnit;

        // load temperatureUnit
        var storedTemperatureUnit = Storage.getValue(temperatureUnitKey);
        if (storedTemperatureUnit)
            temperatureUnit = storedTemperatureUnit;

        // load animationIncrement
        var storedAnimationIncrement = Storage.getValue(animationIncrementKey);
        if (storedAnimationIncrement)
            animationIncrement = storedAnimationIncrement;

        // load simplifiedOrbits
        var storedSimplifiedOrbits = Storage.getValue(simplifiedOrbitsKey);
        if (storedSimplifiedOrbits)
            simplifiedOrbits = storedSimplifiedOrbits === "true";

        // load zoomedOutTopView
        var storedZoomedOutTopView = Storage.getValue(zoomedOutTopViewKey);
        if (storedZoomedOutTopView)
            zoomedOutTopView = storedZoomedOutTopView === "true";

        // load zoomedOutSkyView
        var storedZoomedOutSkyView = Storage.getValue(zoomedOutSkyViewKey);
        if (storedZoomedOutSkyView)
            zoomedOutSkyView = storedZoomedOutSkyView === "true";

        // load trackNow
        var storedTrackNow = Storage.getValue(trackNowKey);
        if (storedTrackNow)
            trackNow = storedTrackNow === "true";

        // load trackOrientation
        var storedTrackOrientation = Storage.getValue(trackOrientationKey);
        if (storedTrackOrientation)
            trackOrientation = storedTrackOrientation === "true";

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
            Storage.setValue(dateTimeKey, dateTime);
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
    onShowSkyViewChanged:
    {
        Storage.setValue(showSkyViewKey, showSkyView);
    }
    onShowEclipticChanged:
    {
        Storage.setValue(showEclipticKey, showEcliptic);
    }
    onShowEquatorChanged:
    {
        Storage.setValue(showEquatorKey, showEquator);
    }
    onShowAzimuthChanged:
    {
        Storage.setValue(showAzimuthKey, showAzimuth);
    }
    onShowBackgroundChanged:
    {
        Storage.setValue(showBackgroundKey, showBackground);
    }
    onDateTimeChanged:
    {
        // value keeps changing as long as animation is enabled. store when animation is disabled
        if (!animationEnabled)
            Storage.setValue(dateTimeKey, dateTime);
    }
    onDateFormatChanged:
    {
        Storage.setValue(dateFormatKey, dateFormat);
    }
    onPressureUnitChanged:
    {
        Storage.setValue(pressureUnitKey, pressureUnit);
    }
    onTemperatureUnitChanged:
    {
        Storage.setValue(temperatureUnitKey, temperatureUnit);
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
    onZoomedOutTopViewChanged:
    {
        Storage.setValue(zoomedOutTopViewKey, zoomedOutTopView);
    }
    onZoomedOutSkyViewChanged:
    {
        Storage.setValue(zoomedOutSkyViewKey, zoomedOutSkyView);
    }
    onTrackNowChanged:
    {
        Storage.setValue(trackNowKey, trackNow);
    }
    onTrackOrientationChanged:
    {
        Storage.setValue(trackOrientationKey, trackOrientation);
    }
    onDistancePlanetIdxChanged:
    {
        Storage.setValue(distancePlanetIdxKey, distancePlanetIdx);
    }
}
