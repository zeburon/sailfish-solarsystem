import QtQuick 2.0
import Sailfish.Silica 1.0

import "../calculation.js" as Calculation
import "../globals.js" as Globals

Item
{
    id: root

    // -----------------------------------------------------------------------

    // settings
    property date date
    property int animationIncrement: 5
    property bool simplifiedOrbits: true
    property bool zoomedOut: false
    property bool showLabels: true
    property bool showOrbits: true
    property bool showDwarfPlanets: false
    property bool showZPosition: false
    property bool animateSun: true
    property real imageOpacity: 1.0
    property real imageScale: 1.0
    property int orbitThickness: 3
    property bool animateZoom: false

    // orbit-related properties
    property real radiusSunOffset: Math.max(40, Math.min(width, height) / 20) * imageScale
    property real radiusBorderOffset: 15
    property real radiusRange: Math.min(width / 2, height / 2) - radiusBorderOffset - radiusSunOffset
    property real radiusIncrementWithDwarfPlanets: radiusRange / (planetInfos.length - 1)
    property real radiusIncrementWithoutDwarfPlanets: radiusRange / (realPlanetCount - 1)
    property real auSize

    // zoom-related properties
    property real currentZoom: simplifiedOrbits ? 1.0 : currentZoomRealistic
    property real currentZoomRealistic: zoomedOut ? (showDwarfPlanets ? 0.063 : 0.08) : 1.0
    property real currentOffsetX: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? -width / 14.0 : 0.0)
    property real currentOffsetY: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? height / 16.0 : 0.0)

    // list of planets
    property bool initialized: false
    property var planetCalculationResults: []

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var planetInfo)
    signal clickedOnEmptySpace()

    // -----------------------------------------------------------------------

    function init()
    {
        initPlanetCalculationResults();
        createPlanetItems();
        initialized = true;

        updatePlanetPositions();
    }

    // -----------------------------------------------------------------------

    function initPlanetCalculationResults()
    {
        for (var planetIdx = 0; planetIdx < planetInfos.length; ++planetIdx)
        {
            var planetInfo = planetInfos[planetIdx];
            var planetCalculationResult = planetCalculationResultComponent.createObject(null, {"planetInfo": planetInfo});
            planetCalculationResult.orbitSimplifiedRadiusWithDwarfPlanets = Qt.binding(function() { return radiusSunOffset + radiusIncrementWithDwarfPlanets * planetInfo.idxWithDwarfPlanets });
            planetCalculationResult.orbitSimplifiedRadiusWithoutDwarfPlanets = Qt.binding(function() { return radiusSunOffset + radiusIncrementWithoutDwarfPlanets * planetInfo.idxWithoutDwarfPlanets });
            planetCalculationResults.push(planetCalculationResult);
        }

        auSize = Qt.binding(function() { return planetCalculationResults[earth.idxWithDwarfPlanets].orbitSimplifiedRadius; });
    }

    // -----------------------------------------------------------------------

    function createPlanetItems()
    {
        // automatically sort images and labels by creating planets in reverse order
        for (var planetIdx = planetCalculationResults.length - 1; planetIdx >= 0; --planetIdx)
        {
            var planetCalculationResult = planetCalculationResults[planetIdx];
            var planetInfo = planetCalculationResult.planetInfo;

            var planetImage = planetImageComponent.createObject(images, {"planetInfo": planetInfo, "planetCalculationResult": planetCalculationResult});
            planetImage.clicked.connect(root.clickedOnPlanet);

            var planetLabel = planetLabelComponent.createObject(labels, {"planetInfo": planetInfo, "planetCalculationResult": planetCalculationResult, "yOffset": planetImage.imageHeight * 0.75});
        }
    }

    // -----------------------------------------------------------------------

    function updatePlanetPositions()
    {
        if (!initialized)
            return;

        Calculation.setDate(date);
        Calculation.setOrbitParameters(auSize, simplifiedOrbits);

        for (var planetIdx = 0; planetIdx < planetCalculationResults.length; ++planetIdx)
        {
            var planetCalculationResult = planetCalculationResults[planetIdx];
            Calculation.updateEclipticCoordinates(planetCalculationResult);
            Calculation.updateDisplayedCoordinates(planetCalculationResult);
        }
    }

    // -----------------------------------------------------------------------

    function paintOrbits()
    {
        orbits.requestPaint();
    }

    // -----------------------------------------------------------------------

    function prepareDistanceCoordinates()
    {
        var lastDate = new Date(date);
        lastDate.setDate(lastDate.getDate() - 1);
        Calculation.setDate(lastDate)
        for (var planetIdx = 0; planetIdx < planetCalculationResults.length; ++planetIdx)
        {
            Calculation.updateOldEclipticCoordinates(planetCalculationResults[planetIdx]);
        }

        Calculation.setDate(date);
    }

    // -----------------------------------------------------------------------

    function getDistanceBetweenPlanets(planetIdx1, planetIdx2)
    {
        var planet1 = planetCalculationResults[planetIdx1];
        var planet2 = planetCalculationResults[planetIdx2];

        var oldDistance = Calculation.getDistanceBetweenPlanets(planet1, planet2, true);
        var currentDistance = Calculation.getDistanceBetweenPlanets(planet1, planet2, false);

        return [currentDistance, currentDistance > oldDistance ? 1 : -1];
    }

    // -----------------------------------------------------------------------

    function getDistanceToEarth(planetIdx)
    {
        return getDistanceBetweenPlanets(planetIdx, earth.idxWithoutDwarfPlanets);
    }

    // -----------------------------------------------------------------------

    function getDistanceToSun(planetIdx)
    {
        var planet = planetCalculationResults[planetIdx];

        var oldDistance = Calculation.getDistanceToSun(planet, true);
        var currentDistance = Calculation.getDistanceToSun(planet, false);

        return [currentDistance, currentDistance > oldDistance ? 1 : -1];
    }

    // -----------------------------------------------------------------------

    onDateChanged:
    {
        updatePlanetPositions();
    }
    onSimplifiedOrbitsChanged:
    {
        delayedUpdateTimer.start();
    }
    onShowDwarfPlanetsChanged:
    {
        delayedUpdateTimer.start();
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: planetCalculationResultComponent

        PlanetCalculationResult
        {
        }
    }
    Component
    {
        id: planetImageComponent

        PlanetImage
        {
            property PlanetCalculationResult planetCalculationResult
            property real displayedX: planetCalculationResult.displayedCoordinates[0]
            property real displayedY: planetCalculationResult.displayedCoordinates[1]
            property real displayedZ: planetCalculationResult.displayedCoordinates[2]
            property real displayedShadowRotation: planetCalculationResult.currentShadowRotation

            x: displayedX * root.currentZoom
            y: displayedY * root.currentZoom + (root.showZPosition ? displayedZ * root.currentZoom : 0.0)
            scale: root.imageScale * planetCalculationResult.currentOpacityFactor
            opacity: root.imageOpacity * planetCalculationResult.currentOpacityFactor

            // -----------------------------------------------------------------------
            // visualization of distance to ecliptic
            Rectangle
            {
                id: zIndicatorLine

                width: 4
                radius: 2
                z: -1
                height: Math.abs(displayedZ * root.currentZoom)
                color: displayedZ < 0.0 ? "green" : "red"
                opacity: 0.3
                anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: displayedZ > 0.0 ? -height : 0 }
                visible: root.showZPosition

                Rectangle
                {
                    id: zIndicatorBase

                    width: 8
                    height: width
                    radius: width / 2
                    anchors { verticalCenter: displayedZ < 0 ? parent.bottom : parent.top; horizontalCenter: parent.horizontalCenter }
                    color: parent.color
                }
            }
        }
    }
    Component
    {
        id: planetLabelComponent

        PlanetLabel
        {
            property PlanetCalculationResult planetCalculationResult
            property real displayedX: planetCalculationResult.displayedCoordinates[0]
            property real displayedY: planetCalculationResult.displayedCoordinates[1]
            property real displayedZ: planetCalculationResult.displayedCoordinates[2]

            x: displayedX * root.currentZoom
            y: displayedY * root.currentZoom + (root.showZPosition ? displayedZ * root.currentZoom : 0.0)
            opacity: planetCalculationResult.currentOpacityFactor
        }
    }

    // -----------------------------------------------------------------------

    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            root.clickedOnEmptySpace();
        }
    }
    Sun
    {
        id: sun

        scale: imageScale * currentZoom
        animated: animateSun
        opacity: imageOpacity
        anchors { centerIn: parent }
        z: 0
    }
    OrbitPainter
    {
        id: orbits

        zoom: root.currentZoom
        planetCalculationResults: root.planetCalculationResults
        lineThickness: orbitThickness
        visible: showOrbits
        anchors { fill: parent }
        z: 1
    }
    Item
    {
        id: images

        opacity: imageOpacity
        anchors { centerIn: parent }
        z: 2
    }
    Item
    {
        id: labels

        visible: showLabels
        anchors { centerIn: parent }
        z: 3
    }
    Timer
    {
        id: delayedUpdateTimer

        interval: 250
        repeat: false
        onTriggered:
        {
            paintOrbits();
            updatePlanetPositions();
        }
    }

    // -----------------------------------------------------------------------

    Behavior on currentZoomRealistic
    {
        enabled: animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on currentOffsetX
    {
        enabled: animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on currentOffsetY
    {
        enabled: animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
}
