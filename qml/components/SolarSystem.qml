import QtQuick 2.0
import Sailfish.Silica 1.0

import "../calculation.js" as Calculation
import "../globals.js" as Globals

QtObject
{
    id: root

    // -----------------------------------------------------------------------

    // settings
    property date date
    property bool simplifiedOrbits: true
    property bool showDwarfPlanets: false

    // orbit-related properties
    property real radius
    property real radiusSunOffset: 0
    property real radiusBorderOffset: 0
    property real radiusRange: radius - radiusBorderOffset - radiusSunOffset
    property real radiusIncrementWithDwarfPlanets: radiusRange / (planetConfigs.length - 1)
    property real radiusIncrementWithoutDwarfPlanets: radiusRange / (realPlanetCount - 1)
    property real auSize

    property bool initialized: false
    property bool forceNextUpdate: false

    // list of planets
    property var planetPositions: []
    property Component planetPositionComponent: PlanetPosition { }

    property Timer delayedUpdateTimer: Timer
    {
        interval: 50
        repeat: false
        onTriggered:
        {
            updatePlanetPositions();
            delayedUpdateTimerTimeout();
        }
    }

    // -----------------------------------------------------------------------

    signal delayedUpdateTimerTimeout()
    signal switchedToRealisticOrbits()
    signal switchedToSimplifiedOrbits()

    // -----------------------------------------------------------------------

    function init()
    {
        initPlanetPositions();
        initialized = true;

        updatePlanetPositions();
    }

    // -----------------------------------------------------------------------

    function initPlanetPositions()
    {
        for (var planetIdx = 0; planetIdx < planetConfigs.length; ++planetIdx)
        {
            var planetConfig = planetConfigs[planetIdx];
            var planetPosition = planetPositionComponent.createObject(null, {"planetConfig": planetConfig});
            planetPosition.orbitSimplifiedRadiusWithDwarfPlanets = Qt.binding(function() { return radiusSunOffset + radiusIncrementWithDwarfPlanets * planetConfig.idxWithDwarfPlanets });
            planetPosition.orbitSimplifiedRadiusWithoutDwarfPlanets = Qt.binding(function() { return radiusSunOffset + radiusIncrementWithoutDwarfPlanets * planetConfig.idxWithoutDwarfPlanets });
            planetPositions.push(planetPosition);
        }

        auSize = Qt.binding(function() { return planetPositions[earth.idxWithDwarfPlanets].orbitSimplifiedRadius; });
    }

    // -----------------------------------------------------------------------

    function updatePlanetPositions()
    {
        if (!initialized || !Calculation.isDateValid(date))
            return;

        if (!Calculation.setDateIfChanged(date) && !forceNextUpdate)
            return;

        forceNextUpdate = false;
        Calculation.setOrbitParameters(auSize, simplifiedOrbits);

        for (var planetIdx = 0; planetIdx < planetPositions.length; ++planetIdx)
        {
            var planetPosition = planetPositions[planetIdx];
            Calculation.updateEclipticCoordinates(planetPosition);
            Calculation.updateDisplayedCoordinates(planetPosition);
        }
    }

    // -----------------------------------------------------------------------

    function prepareDistanceCoordinates()
    {
        var lastDate = new Date(date);
        lastDate.setDate(lastDate.getDate() - 1);
        Calculation.setDateIfChanged(lastDate)
        for (var planetIdx = 0; planetIdx < planetPositions.length; ++planetIdx)
        {
            Calculation.updateOldEclipticCoordinates(planetPositions[planetIdx]);
        }

        Calculation.setDateIfChanged(date);
    }

    // -----------------------------------------------------------------------

    function getDistanceBetweenPlanets(planetIdx1, planetIdx2)
    {
        var planetPosition1 = planetPositions[planetIdx1];
        var planetPosition2 = planetPositions[planetIdx2];

        var oldDistance = Calculation.getDistanceBetweenPlanets(planetPosition1, planetPosition2, true);
        var newDistance = Calculation.getDistanceBetweenPlanets(planetPosition1, planetPosition2, false);

        return [newDistance, newDistance > oldDistance ? 1 : -1];
    }

    // -----------------------------------------------------------------------

    function getDistanceToEarth(planetIdx)
    {
        return getDistanceBetweenPlanets(planetIdx, earth.idxWithoutDwarfPlanets);
    }

    // -----------------------------------------------------------------------

    function getDistanceToSun(planetIdx)
    {
        var planetPosition = planetPositions[planetIdx];

        var oldDistance = Calculation.getDistanceToSun(planetPosition, true);
        var newDistance = Calculation.getDistanceToSun(planetPosition, false);

        return [newDistance, newDistance > oldDistance ? 1 : -1];
    }

    // -----------------------------------------------------------------------

    function getLongitudeOffset(hours)
    {
        return Calculation.getLongitudeOffset(hours);
    }

    // -----------------------------------------------------------------------

    function handleSettingChange()
    {
        forceNextUpdate = true;
        delayedUpdateTimer.start();

        if (!simplifiedOrbits)
            switchedToRealisticOrbits();
        else
            switchedToSimplifiedOrbits();
    }

    // -----------------------------------------------------------------------

    onDateChanged:
    {
        if (initialized)
            updatePlanetPositions();
    }
    onSimplifiedOrbitsChanged:
    {
        handleSettingChange();
    }
    onShowDwarfPlanetsChanged:
    {
        handleSettingChange();
    }
}
