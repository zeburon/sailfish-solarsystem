import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.DateTime 1.0

import "../calculation.js" as Calculation
import "../globals.js" as Globals

Item
{
    id: root

    // -----------------------------------------------------------------------

    // settings
    property int animationIncrement: 5
    property bool simplifiedOrbits: false
    property bool zoomedOut: false
    property bool showLabels: true
    property bool showOrbits: true
    property bool showDwarfPlanets: false
    property bool animateSun: true
    property real imageOpacity: 1.0
    property real imageScale: 1.0
    property int orbitThickness: 3
    property bool animateZoom: false
    property bool initialized: false

    // radius-related properties
    property real auSize: 100
    property real radiusRange: width / 2 - radiusBorderOffset - radiusSunOffset
    property real radiusSunOffset: Math.max(30, Math.min(width, height) / 20) * imageScale
    property real radiusBorderOffset: 15

    // zoom-related properties
    property real currentZoom: simplifiedOrbits ? 1.0 : currentZoomRealistic
    property real currentZoomRealistic: zoomedOut ? (showDwarfPlanets ? 0.063 : 0.08) : 1.0
    property real currentOffsetX: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? -width / 14.0 : 0.0)
    property real currentOffsetY: simplifiedOrbits ? 0.0 : (zoomedOut && showDwarfPlanets ? height / 16.0 : 0.0)

    // solar body information
    property alias solarSystem: solarSystem
    property var solarBodyInfos: []

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var solarBody)
    signal clickedOnEmptySpace()
    signal switchedToRealisticOrbits()
    signal switchedToSimplifiedOrbits()

    // -----------------------------------------------------------------------

    function init()
    {
        // create instances
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];

            var info = solarBodyInfo.createObject(null, {"solarBody": solarBody});
            solarBodyInfos.push(info);

            var bodyZ = solarSystem.solarBodies.length - bodyIdx;
            var image = solarBodyImageComponent.createObject(images, {"solarBody": solarBody, "info": info, "z": bodyZ});
            var label = solarBodyLabelComponent.createObject(labels, {"solarBody": solarBody, "info": info, "z": bodyZ, "yOffset": image.imageHeight * 0.75});
        }
        // link to parent instances
        for (var infoIdx = 0; infoIdx < solarBodyInfos.length; ++infoIdx)
        {
            var info = solarBodyInfos[infoIdx];
            var parentSolarBody = info.solarBody.parentSolarBody;
            if (parentSolarBody)
            {
                info.parentInfo = solarBodyInfos[solarSystem.getIndex(parentSolarBody)];
            }
        }
        initialized = true;
        updateSimplifiedOrbitRadiuses();
        //update();
    }

    // -----------------------------------------------------------------------

    function update(dateTime)
    {
        solarSystem.dateTime.string = dateTime.string;
        for (var infoIdx = 0; infoIdx < solarBodyInfos.length; ++infoIdx)
        {
            solarBodyInfos[infoIdx].updateCoordinates();
        }
        paintOrbits();
    }

    // -----------------------------------------------------------------------

    function updateSimplifiedOrbitRadiuses()
    {
        var visibleBodyCount = 0;
        for (var infoIdx = 0; infoIdx < solarBodyInfos.length; ++infoIdx)
        {
            var info = solarBodyInfos[infoIdx];
            if (info.solarBody.visible && !info.solarBody.parentSolarBody)
            {
                ++visibleBodyCount;
            }
        }
        var radiusIncrement = radiusRange / (visibleBodyCount - 1);
        var visibleBodyIdx = 0;
        for (var infoIdx = 0; infoIdx < solarBodyInfos.length; ++infoIdx)
        {
            var info = solarBodyInfos[infoIdx];
            if (info.solarBody.parentSolarBody)
            {
                info.orbitSimplifiedRadius = radiusIncrement / 2;
            }
            else if (info.solarBody.visible)
            {
                info.orbitSimplifiedRadius = radiusSunOffset + radiusIncrement * visibleBodyIdx;
                ++visibleBodyIdx;
            }
        }
        auSize = solarBodyInfos[solarSystem.getIndex(solarSystem.earth)].orbitSimplifiedRadius;
    }

    // -----------------------------------------------------------------------

    function paintOrbits()
    {
        orbits.requestPaint();
    }

    // -----------------------------------------------------------------------

    function click(mouseX, mouseY)
    {
        var closestInfo;
        var minDistance = 99999;

        for (var bodyIdx = 0; bodyIdx < images.children.length; ++bodyIdx)
        {
            var image = images.children[bodyIdx];
            if (image.scale < 0.4 || image.info.parentInfo)
                continue;

            var dx = image.x + width / 2 - mouseX;
            var dy = image.y + height / 2 - mouseY;
            var distance = Math.sqrt(dx * dx + dy * dy);
            if (distance < minDistance && distance < Globals.PLANET_CLICK_AREA_SIZE)
            {
                closestInfo = image.info;
                minDistance = distance;
            }
        }

        if (closestInfo)
        {
            clickedOnPlanet(closestInfo.solarBody);
        }
        else
        {
            clickedOnEmptySpace();
        }
    }

    // -----------------------------------------------------------------------

    onShowDwarfPlanetsChanged:
    {
        if (initialized)
        {
            updateSimplifiedOrbitRadiuses();
        }
    }
    onSimplifiedOrbitsChanged:
    {
        if (initialized)
        {
            //update();
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: solarBodyInfo

        Item
        {
            property SolarBody solarBody
            property var parentInfo: null

            property real orbitProjectionFactor: Math.cos(solarBody.orbitalElements.inclination) // adjust orbit dimensions according to inclination
            property real orbitOffset: simplifiedOrbits ? 0.0 : ((solarBody.orbitalElements.maximumDistance - solarBody.orbitalElements.minimumDistance) / 2.0) * root.auSize * orbitProjectionFactor
            property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitalElements.semiMajorAxis * root.auSize * orbitProjectionFactor
            property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitalElements.semiMajorAxis * root.auSize * Math.sqrt(1.0 - Math.pow(solarBody.orbitalElements.eccentricity, 2))
            property real orbitRotation: solarBody.orbitalElements.argumentOfPeriapsis + solarBody.orbitalElements.longitudeOfAscendingNode
            property real orbitSimplifiedRadius

            property real displayedX
            property real displayedY
            property real displayedOpacity: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - root.currentZoom) * (1.0 - solarBody.smallImageScaleZoomedOut) + root.currentZoom * (1.0 - solarBody.smallImageScaleZoomedIn)))
            property real displayedScale: root.imageScale * displayedOpacity
            property real displayedShadowRotation: Math.atan2(displayedY, displayedX) * 180 / Math.PI;

            function updateCoordinates()
            {
                var newX = 0, newY = 0;
                if (simplifiedOrbits)
                {
                    var angle = Math.atan2(solarBody.orbitalElements.y, solarBody.orbitalElements.x);
                    newX = orbitSimplifiedRadius * Math.cos(angle);
                    newY = orbitSimplifiedRadius * Math.sin(angle);
                }
                else
                {
                    newX = solarBody.orbitalElements.x * root.auSize * solarBody.orbitCorrectionFactorX;
                    newY = solarBody.orbitalElements.y * root.auSize * solarBody.orbitCorrectionFactorY;
                }

                if (parentInfo)
                {
                    newX += parentInfo.displayedX;
                    newY += parentInfo.displayedY;
                }
                displayedX = newX;
                displayedY = newY;
            }
        }
    }
    Component
    {
        id: solarBodyImageComponent

        TopSolarBodyImage
        {
            property var info

            x: info.displayedX * root.currentZoom
            y: info.displayedY * root.currentZoom
            scale: info.displayedScale
            opacity: info.displayedOpacity
            shadowRotation: info.displayedShadowRotation
        }
    }
    Component
    {
        id: solarBodyLabelComponent

        SolarBodyLabel
        {
            property var info

            x: info.displayedX * root.currentZoom
            y: info.displayedY * root.currentZoom
            opacity: info.displayedOpacity
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        showDwarfPlanets: root.showDwarfPlanets
    }

    Sun
    {
        id: sun

        scale: root.imageScale * root.currentZoom
        animated: root.animateSun
        opacity: root.imageOpacity
        anchors { centerIn: parent }
        z: 0
    }
    TopOrbitPainter
    {
        id: orbits

        zoom: root.currentZoom
        solarBodyInfos: root.solarBodyInfos
        lineThickness: root.orbitThickness
        visible: root.showOrbits
        anchors { fill: parent }
        z: 1
    }
    Item
    {
        id: images

        opacity: root.imageOpacity
        anchors { centerIn: parent }
        z: 2
    }
    Item
    {
        id: labels

        visible: root.showLabels
        anchors { centerIn: parent }
        z: 3
    }

    // -----------------------------------------------------------------------

    Behavior on currentZoomRealistic
    {
        enabled: root.animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on currentOffsetX
    {
        enabled: root.animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on currentOffsetY
    {
        enabled: root.animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
}
