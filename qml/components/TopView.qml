import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.DateTime 1.0

import "../globals.js" as Globals

Canvas
{
    id: root

    // -----------------------------------------------------------------------

    // settings
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
    property var solarBodyPainters: []

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var solarBody)
    signal clickedOnEmptySpace()
    signal showHelpText(string text)

    // -----------------------------------------------------------------------

    function init()
    {
        // create instances
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];

            var painter = solarBodyPainter.createObject(null, {"solarBody": solarBody});
            solarBodyPainters.push(painter);

            var bodyZ = solarSystem.solarBodies.length - bodyIdx;
            var image = solarBodyImageComponent.createObject(images, {"solarBody": solarBody, "painter": painter, "z": bodyZ});
            var label = solarBodyLabelComponent.createObject(labels, {"solarBody": solarBody, "painter": painter, "z": bodyZ, "yOffset": image.imageHeight * 0.3});
        }
        // link to parent instances
        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            var painter = solarBodyPainters[painterIdx];
            var parentSolarBody = painter.solarBody.parentSolarBody;
            if (parentSolarBody)
            {
                painter.parentPainter = solarBodyPainters[solarSystem.getIndex(parentSolarBody)];
            }
        }
        updateSimplifiedOrbitRadiuses();
        initialized = true;
    }

    // -----------------------------------------------------------------------

    function update(dateTime)
    {
        solarSystem.dateTime.string = dateTime.string;
        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            solarBodyPainters[painterIdx].updateCoordinates();
        }
        requestPaint();
    }

    // -----------------------------------------------------------------------

    function updateSimplifiedOrbitRadiuses()
    {
        // calculate number of visible bodies
        var visibleBodyCount = 0;
        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            var painter = solarBodyPainters[painterIdx];
            if (painter.solarBody.visible && !painter.solarBody.parentSolarBody)
            {
                ++visibleBodyCount;
            }
        }

        // calculate new simplified radiuses
        var radiusIncrement = radiusRange / (visibleBodyCount - 1);
        var visibleBodyIdx = 0;
        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            var painter = solarBodyPainters[painterIdx];
            if (painter.solarBody.parentSolarBody)
            {
                painter.orbitSimplifiedRadius = radiusIncrement / 2;
            }
            else if (painter.solarBody.visible)
            {
                painter.orbitSimplifiedRadius = radiusSunOffset + radiusIncrement * visibleBodyIdx;
                ++visibleBodyIdx;
            }
        }
        auSize = solarBodyPainters[solarSystem.getIndex(solarSystem.earth)].orbitSimplifiedRadius;
    }

    // -----------------------------------------------------------------------

    function click(mouseX, mouseY)
    {
        var closestPainter;
        var minDistance = 99999;

        for (var imageIdx = 0; imageIdx < images.children.length; ++imageIdx)
        {
            var image = images.children[imageIdx];
            if (image.scale < 0.4 || image.painter.parentPainter)
                continue;

            var dx = image.x + width / 2 - mouseX;
            var dy = image.y + height / 2 - mouseY;
            var distance = Math.sqrt(dx * dx + dy * dy);
            if (distance < minDistance && distance < Globals.PLANET_CLICK_AREA_SIZE)
            {
                closestPainter = image.painter;
                minDistance = distance;
            }
        }

        if (closestPainter)
        {
            clickedOnPlanet(closestPainter.solarBody);
        }
        else
        {
            clickedOnEmptySpace();
        }
    }

    // -----------------------------------------------------------------------

    function generateHelpText()
    {
        if (simplifiedOrbits)
            showHelpText(qsTr("Click on planets for details"));
        else
            showHelpText(qsTr("Click to toggle zoom"))
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
            requestPaint();
        }
        generateHelpText();
    }
    onCurrentZoomChanged:
    {
        if (initialized)
        {
            requestPaint();
        }
    }
    onVisibleChanged:
    {
        if (visible)
        {
            generateHelpText();
        }
    }
    onPaint:
    {
        if (!solarSystem.dateTime.valid)
            return;

        var context = getContext("2d");
        context.reset();

        if (!showOrbits)
            return;

        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            var painter = solarBodyPainters[painterIdx];
            if (painter.solarBody.visible && !painter.parentPainter)
            {
                var rotation = -painter.orbitRotation;
                var offset = -painter.orbitOffset * root.currentZoom;
                var a = painter.orbitA * root.currentZoom;
                var b = painter.orbitB * root.currentZoom;

                context.save();
                context.translate(width / 2.0, height / 2.0);
                context.rotate(rotation);
                context.translate(offset, 0.0);
                context.scale(1.0, b / a);
                context.beginPath();
                context.arc(0.0, 0.0, a, 0.0, 2.0 * Math.PI);
                context.restore();
                context.globalAlpha = painter.displayedOpacity;
                context.lineWidth = root.orbitThickness;
                context.strokeStyle = painter.solarBody.orbitColor;
                context.stroke();
            }
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: solarBodyPainter

        Item
        {
            property SolarBody solarBody
            property var parentPainter: null

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

                if (parentPainter)
                {
                    newX += parentPainter.displayedX;
                    newY += parentPainter.displayedY;
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
            property var painter

            x: painter.displayedX * root.currentZoom
            y: painter.displayedY * root.currentZoom
            scale: painter.displayedScale
            opacity: painter.displayedOpacity
            shadowRotation: painter.displayedShadowRotation
        }
    }
    Component
    {
        id: solarBodyLabelComponent

        SolarBodyLabel
        {
            property var painter

            x: painter.displayedX * root.currentZoom
            y: painter.displayedY * root.currentZoom
            opacity: painter.displayedOpacity
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
    Item
    {
        id: images

        opacity: root.imageOpacity
        anchors { centerIn: parent }
        visible: solarSystem.valid
        z: 2
    }
    Item
    {
        id: labels

        anchors { centerIn: parent }
        visible: root.showLabels && solarSystem.valid
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
