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

    property real radiusSunOffset: Math.max(40, Math.min(width, height) / 20) * imageScale
    property real radiusBorderOffset: 15

    // zoom-related properties
    property real currentZoom: simplifiedOrbits ? 1.0 : currentZoomRealistic
    property real currentZoomRealistic: zoomedOut ? (showDwarfPlanets ? 0.063 : 0.08) : 1.0
    property real currentOffsetX: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? -width / 14.0 : 0.0)
    property real currentOffsetY: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? height / 16.0 : 0.0)

    property alias planetPositions: solarSystem.planetPositions
    property alias solarSystem: solarSystem

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var planetConfig)
    signal clickedOnEmptySpace()
    signal switchedToRealisticOrbits()
    signal switchedToSimplifiedOrbits()

    // -----------------------------------------------------------------------

    function init()
    {
        solarSystem.init();

        // automatically sort images and labels by creating planets in reverse order
        for (var planetIdx = planetPositions.length - 1; planetIdx >= 0; --planetIdx)
        {
            var planetPosition = planetPositions[planetIdx];
            var planetConfig = planetPosition.planetConfig;

            var planetImage = planetImageComponent.createObject(images, {"planetConfig": planetConfig, "planetPosition": planetPosition});
            var planetLabel = planetLabelComponent.createObject(labels, {"planetConfig": planetConfig, "planetPosition": planetPosition, "yOffset": planetImage.imageHeight * 0.75});
        }
    }

    // -----------------------------------------------------------------------

    function paintOrbits()
    {
        orbits.requestPaint();
    }

    // -----------------------------------------------------------------------

    function click(mouseX, mouseY)
    {
        var closestPlanetConfig;
        var minDistance = 99999;

        for (var planetIdx = 0; planetIdx < images.children.length; ++planetIdx)
        {
            var planetImage = images.children[planetIdx];
            if (planetImage.scale < 0.4)
                continue;

            var dx = planetImage.x + width / 2 - mouseX;
            var dy = planetImage.y + height / 2 - mouseY;
            var distance = Math.sqrt(dx * dx + dy * dy);
            if (distance < minDistance && distance < Globals.PLANET_CLICK_AREA_SIZE)
            {
                closestPlanetConfig = planetImage.planetConfig;
                minDistance = distance;
            }
        }

        if (closestPlanetConfig !== undefined)
        {
            clickedOnPlanet(closestPlanetConfig);
        }
        else
        {
            clickedOnEmptySpace();
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: planetImageComponent

        PlanetImage
        {
            property PlanetPosition planetPosition
            property real displayedX: planetPosition.displayedCoordinates[0]
            property real displayedY: planetPosition.displayedCoordinates[1]
            property real displayedZ: planetPosition.displayedCoordinates[2] * 0.75
            property real displayedShadowRotation: planetPosition.displayedShadowRotation

            x: displayedX * root.currentZoom
            y: displayedY * root.currentZoom + ((root.showZPosition && planetPosition.planetConfig.orbitCanShowZPosition) ? displayedZ * root.currentZoom : 0.0)
            scale: root.imageScale * planetPosition.displayedOpacity
            opacity: root.imageOpacity * planetPosition.displayedOpacity
            shadowRotation: planetPosition.displayedShadowRotation

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
            property PlanetPosition planetPosition
            property real displayedX: planetPosition.displayedCoordinates[0]
            property real displayedY: planetPosition.displayedCoordinates[1]
            property real displayedZ: planetPosition.displayedCoordinates[2] * 0.75

            x: displayedX * root.currentZoom
            y: displayedY * root.currentZoom + ((root.showZPosition && planetPosition.planetConfig.orbitCanShowZPosition) ? displayedZ * root.currentZoom : 0.0)
            opacity: planetPosition.displayedOpacity
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        date: root.date
        simplifiedOrbits: root.simplifiedOrbits
        showDwarfPlanets: root.showDwarfPlanets
        radius: Math.min(root.width / 2, root.height / 2)
        radiusSunOffset: root.radiusSunOffset
        radiusBorderOffset: root.radiusBorderOffset
        Component.onCompleted:
        {
            delayedUpdateTimerTimeout.connect(paintOrbits);
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
        planetPositions: solarSystem.planetPositions
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
