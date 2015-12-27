import QtQuick 2.0
import harbour.solarsystem.Projector 1.0
import harbour.solarsystem.DateTime 1.0

import "../globals.js" as Globals

Canvas
{
    id: root

    // -----------------------------------------------------------------------

    // settings
    property bool showLabels: true
    property bool showAzimuth: true
    property bool showEquator: true
    property bool showEcliptic: true
    property bool zoomedOut: false
    property bool animateSun: true
    property bool animateZoom: false

    // view-related properties
    property real latitude: 47.066
    property real longitude: 15.433
    property real fieldOfView: zoomedOut ? 90 : 120
    property real currentZoom: zoomedOut ? 0.5 : 1.0
    property real visibleRadius: 1.175 * Math.sqrt(2.0 * Math.pow(Math.max(width, height), 2.0)) * currentZoom / 2.0
    property real visibleRadiusSquared: visibleRadius * visibleRadius
    property real visibleRadiusFadeStart: visibleRadius - 40

    // mouse-look properties
    property real longitudeLookOffset: 0.01
    property real latitudeLookOffset: 40
    property int mouseXStart
    property int mouseLongitudeOffsetStart
    property int mouseYStart
    property int mouseLatitudeOffsetStart
    property bool mouseDragged: false

    // solar body information
    property alias solarSystem: solarSystem
    property alias earth: solarSystem.earth
    property alias moon: solarSystem.moon
    property alias mars: solarSystem.mars
    property real sunLongitude
    property var solarBodyPainters: []
    property var solarBodyImages: []

    // -----------------------------------------------------------------------

    signal clickedOnPlanet(var solarBody, var solarSystem)
    signal clickedOnEmptySpace()
    signal showHelpText(string text)
    signal repaintImages()

    // -----------------------------------------------------------------------

    function init()
    {
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];
            if (solarBody === earth)
                continue;

            var painter = solarBodyPainter.createObject(null, {"solarBody": solarBody});
            solarBodyPainters.push(painter);

            var image = planetImageComponent.createObject(items, {"solarBody": solarBody, "painter": painter});
            repaintImages.connect(image.requestPaint);
            solarBodyImages.push(image);
            var label = planetLabelComponent.createObject(items, {"solarBody": solarBody, "painter": painter, "yOffset": image.imageHeight * 0.3});
        }
    }

    // -----------------------------------------------------------------------

    function update(dateTime)
    {
        if (dateTime.string !== solarSystem.dateTime.string)
        {
            solarSystem.dateTime.string = dateTime.string;
            sunLongitude = (earth.orbitalElements.longitude + 180) % 360;
            for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
            {
                var painter = solarBodyPainters[painterIdx];
                painter.calculateRelativeCoordinates();
                painter.calculatePhase();
            }
        }
        requestPaint();
    }

    // -----------------------------------------------------------------------

    function repaintCanvasAndImages()
    {
        requestPaint();
        repaintImages();
    }

    // -----------------------------------------------------------------------

    function drawCircle(context, coordinates, color, radius)
    {
        if (coordinates.z >= 0)
        {
            context.beginPath();
            context.arc(coordinates.x, coordinates.y, radius, 0, 2 * Math.PI, false);
            context.fillStyle = color;
            context.fill();
        }
    }

    // -----------------------------------------------------------------------

    function drawLabel(context, coordinates, color, label)
    {
        if (coordinates.z > 0)
        {
            context.globalAlpha = 0.6 * getOpacity(coordinates.x, coordinates.y);
            drawCircle(context, coordinates, color, 5);
            context.fillStyle = color;
            context.fillText(label,  coordinates.x, coordinates.y - 5);
        }
    }

    // -----------------------------------------------------------------------

    function drawPath(context, coordinates)
    {
        var lastX = 0, lastY = 0, dX = 0, dY = 0, segmentLength = 0;
        for (var idx = 0; idx < coordinates.length; ++idx)
        {
            var point = coordinates[idx];
            if (point.z > 0.0 && point.length() < visibleRadius)
            {
                dX = point.x - lastX;
                dY = point.y - lastY;
                if (segmentLength === 1)
                {
                    if (idx > 1)
                    {
                        var positionOnBorder = getPositionOnBorder(point.x, point.y, -dX, -dY);
                        context.moveTo(positionOnBorder[0], positionOnBorder[1]);
                    }
                    else
                    {
                        context.moveTo(lastX, lastY);
                    }
                }
                if (segmentLength >= 1)
                {
                    context.lineTo(point.x, point.y);
                }
                lastX = point.x;
                lastY = point.y;
                ++segmentLength;
            }
            else
            {
                if (segmentLength >= 1)
                {
                    var positionOnBorder = getPositionOnBorder(lastX, lastY, dX, dY);
                    context.lineTo(positionOnBorder[0], positionOnBorder[1]);
                }
                segmentLength = 0;
            }
        }
    }

    // -----------------------------------------------------------------------

    function getPositionOnBorder(xPos, yPos, dX, dY)
    {
        var xPosSquared = xPos * xPos;
        var yPosSquared = yPos * yPos;
        var dXSquared = dX * dX;
        var dYSquared = dY * dY;

        var factor = (Math.sqrt(-(dYSquared * xPosSquared - 2.0 * dX * dY * xPos * yPos + dXSquared * yPosSquared - visibleRadiusSquared * (dXSquared + dYSquared))) - dX * xPos - dY * yPos) / (dXSquared + dYSquared);
        return [xPos + factor * dX, yPos + factor * dY];
    }

    // -----------------------------------------------------------------------

    function drawAzimuth(context)
    {
        var skyLongitude, skyLatitude;

        context.lineWidth = 2;

        // upper hemisphere
        context.strokeStyle = "#9999ff";
        context.globalAlpha = 0.3 * (1.0 - Math.max(0.0, Math.min(1.0, (latitudeLookOffset / -50.0))));
        if (context.globalAlpha > 0.0)
        {
            for (skyLongitude = 0; skyLongitude < 180; skyLongitude += 90)
            {
                var upperCoordinates = [];
                for (skyLatitude = 0; skyLatitude <= 180; skyLatitude += 10)
                {
                    upperCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, skyLatitude));
                }
                context.beginPath();
                drawPath(context, upperCoordinates);
                context.stroke();
            }
        }

        // lower hemisphere
        context.strokeStyle = "#88cc00";
        context.globalAlpha = 0.3 * (1.0 - Math.max(0.0, Math.min(1.0, (latitudeLookOffset / 50.0))));
        if (context.globalAlpha > 0.0)
        {
            for (skyLongitude = 0; skyLongitude < 180; skyLongitude += 90)
            {
                var lowerCoordinates = [];
                for (skyLatitude = 0; skyLatitude <= 180; skyLatitude += 10)
                {
                    lowerCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, -skyLatitude));
                }
                context.beginPath();
                drawPath(context, lowerCoordinates);
                context.stroke();
            }
        }

        // horizon
        context.globalAlpha = 0.4 * (1.0 - Math.max(0.0, Math.min(1.0, (Math.abs(latitudeLookOffset) / 80.0))));
        context.lineWidth = 4;
        context.strokeStyle = "white";
        var equatorCoordinates = [];
        var longitudeOffset = longitudeLookOffset - 90;
        var longitudeRange = Math.min(180, (fieldOfView / 1) / currentZoom);
        for (skyLongitude = -longitudeRange; skyLongitude <= longitudeRange; skyLongitude += 10)
        {
            equatorCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.beginPath();
        drawPath(context, equatorCoordinates);
        context.stroke();

        // labels
        for (skyLongitude = 0; skyLongitude < 360; skyLongitude += 90)
        {
            var direction;
            switch (skyLongitude)
            {
                case 0:   direction = qsTr("E"); break;
                case 90:  direction = qsTr("N"); break;
                case 180: direction = qsTr("W"); break;
                case 270: direction = qsTr("S"); break;
            }
            drawLabel(context, projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, 0), "white", direction);
        }
        context.globalAlpha = 0.6;
        drawCircle(context, projector.sphericalAzimuthalToScreenCoordinates(0, 90), "#9999ff", 3);
        drawCircle(context, projector.sphericalAzimuthalToScreenCoordinates(0, -90), "#88cc00", 3);
    }

    // -----------------------------------------------------------------------

    function drawEquator(context)
    {
        var coordinates = [];
        var longitudeOffset = -longitudeLookOffset - (dateTime.meanSiderealTime / 24) * 360;
        var longitudeRange = Math.min(180, fieldOfView / currentZoom);
        for (var skyLongitude = -longitudeRange; skyLongitude <= longitudeRange; skyLongitude += 10)
        {
            coordinates.push(projector.sphericalEquatorialToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        context.beginPath();
        drawPath(context, coordinates);
        context.strokeStyle = "#999966";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function drawEcliptic(context)
    {
        var coordinates = [];
        var longitudeOffset = -longitudeLookOffset - (dateTime.meanSiderealTime / 24) * 360;
        var longitudeRange = Math.min(180, fieldOfView / currentZoom);
        for (var skyLongitude = -longitudeRange; skyLongitude <= longitudeRange; skyLongitude += 10)
        {
            coordinates.push(projector.sphericalEclipticToScreenCoordinates(skyLongitude + longitudeOffset, 0));
        }
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        context.beginPath();
        drawPath(context, coordinates);
        context.strokeStyle = "cyan";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function getOpacity(xPos, yPos)
    {
        return Math.max(0.0, 1.0 - Math.max(0.0, (Math.sqrt(xPos * xPos + yPos * yPos) - visibleRadiusFadeStart) / (visibleRadius - visibleRadiusFadeStart)));
    }

    // -----------------------------------------------------------------------

    function click(mouseX, mouseY)
    {
        var closestPainter;
        var minDistance = 99999;

        for (var imageIdx = 0; imageIdx < solarBodyImages.length; ++imageIdx)
        {
            var image = solarBodyImages[imageIdx];
            if (!image.visible || image.solarBody.parentSolarBody)
                continue;

            var dx = image.x - mouseX;
            var dy = image.y - mouseY;
            var distance = Math.sqrt(dx * dx + dy * dy);
            if (distance < minDistance && distance < Globals.PLANET_CLICK_AREA_SIZE * currentZoom)
            {
                closestPainter = image.painter;
                minDistance = distance;
            }
        }

        if (closestPainter)
        {
            clickedOnPlanet(closestPainter.solarBody, solarSystem);
        }
        else
        {
            clickedOnEmptySpace();
        }
    }

    // -----------------------------------------------------------------------

    function generateHelpText()
    {
        showHelpText("");
    }

    // -----------------------------------------------------------------------

    onVisibleChanged:
    {
        if (visible)
        {
            generateHelpText();
        }
    }
    onCurrentZoomChanged:
    {
        requestPaint();
    }
    onPaint:
    {
        if (!solarSystem.dateTime.valid)
            return;

        var context = getContext("2d");
        context.reset();
        context.font = "bold 12pt sans-serif";
        context.textAlign = "center";
        context.translate(width / 2.0, height / 2.0);

        projector.update();
        /*
        var followCoordinates = projector.eclipticToAzimuthalCoordinates(solarBodyPainters[1].geocentricLongitude, solarBodyPainters[1].geocentricLatitude);
        longitudeLookOffset = followCoordinates.x + 90;
        latitudeLookOffset = followCoordinates.y;
        projector.update();
        */

        // helper lines
        if (showAzimuth)
            drawAzimuth(context);
        if (showEquator)
            drawEquator(context);
        if (showEcliptic)
            drawEcliptic(context);

        // background
        context.globalAlpha = 0.5;
        context.lineWidth = 4;
        var gradient = context.createRadialGradient(0, 0, visibleRadius / 2, 0, 0, visibleRadius);
        gradient.addColorStop(0.4, "black");
        gradient.addColorStop(1, "#005ddb");
        context.beginPath();
        context.arc(0, 0, visibleRadius, 0, 2 * Math.PI, false);
        context.fillStyle = gradient;
        context.fill();
        context.strokeStyle = "#88b0e7";
        context.stroke();

        // stars
        context.globalAlpha = 1.0;
        for (var starIdx = 0; starIdx < galaxy.stars.length; ++starIdx)
        {
            var star = galaxy.stars[starIdx];
            var projectedStarCoordinates = projector.sphericalEclipticToScreenCoordinates(star.rightAscensionDegrees, star.declination);
            drawCircle(context, projectedStarCoordinates, "yellow", star.displayedSize * root.currentZoom);
        }

        // sun
        var projected = projector.rectangularEclipticToScreenCoordinates(-earth.orbitalElements.x, -earth.orbitalElements.y, -earth.orbitalElements.z);
        sun.x = projected.x + width / 2;
        sun.y = projected.y + height / 2;
        sun.z = 1000 - projected.z;
        sun.visible = projected.z > 0;
        sun.opacity = getOpacity(projected.x, projected.y);
        sun.rotation = projector.getImageRotation(sunLongitude, 0);

        // planets
        for (var painterIdx = 0; painterIdx < solarBodyPainters.length; ++painterIdx)
        {
            solarBodyPainters[painterIdx].applyRelativeCoordinates();
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: solarBodyPainter

        Item
        {
            property SolarBody solarBody

            property real relativeX
            property real relativeY
            property real relativeZ
            property real displayedX
            property real displayedY
            property real displayedZ
            property real displayedRotation
            property real displayedOpacity
            property real displayedPhase: 0.5
            property real geocentricLongitude
            property real geocentricLatitude

            function calculateRelativeCoordinates()
            {
                if (!solarBody.visible)
                {
                    visible = false;
                    return;
                }

                // calculate geocentric rectangular coordinates
                relativeX = solarBody.orbitalElements.x;
                relativeY = solarBody.orbitalElements.y;
                relativeZ = solarBody.orbitalElements.z;
                if (solarBody.parentSolarBody)
                {
                    var parentSolarBody = solarBody.parentSolarBody;
                    relativeX += parentSolarBody.orbitalElements.x;
                    relativeY += parentSolarBody.orbitalElements.y;
                    relativeZ += parentSolarBody.orbitalElements.z;
                }
                relativeX -= earth.orbitalElements.x;
                relativeY -= earth.orbitalElements.y;
                relativeZ -= earth.orbitalElements.z;

                // calculate geocentric spherical coordinates
                var newLongitudeFromEarth = Math.atan2(relativeY, relativeX) * 180 / Math.PI;
                if (newLongitudeFromEarth < 0.0)
                {
                    newLongitudeFromEarth += 360.0;
                }
                geocentricLongitude = newLongitudeFromEarth;
                geocentricLatitude = Math.asin(relativeZ / Math.sqrt(relativeX * relativeX + relativeY * relativeY + relativeZ * relativeZ)) * 180 / Math.PI;
            }

            function calculatePhase()
            {
                if (solarBody === moon)
                {
                    var longitudeDifference = (root.sunLongitude - solarBody.orbitalElements.longitude) % 360.0;
                    if (longitudeDifference < 0.0)
                    {
                        longitudeDifference += 360.0;
                    }

                    var elongation = Math.acos(Math.cos((sunLongitude - solarBody.orbitalElements.longitude) * Math.PI / 180) * Math.cos(solarBody.orbitalElements.latitude * Math.PI / 180));
                    var phase = 1.0 - (1.0 + Math.cos(Math.PI - elongation)) / 4.0;
                    if (longitudeDifference > 180.0)
                    {
                        phase = 1.0 - phase;
                    }
                    displayedPhase = phase;
                }
                else if (solarBody.orbitalElements.distance <= mars.orbitalElements.distance)
                {
                    var longitudeDifference = (earth.orbitalElements.longitude - solarBody.orbitalElements.longitude) % 360.0;
                    if (longitudeDifference < 0.0)
                    {
                        longitudeDifference += 360.0;
                    }

                    var heliocentricDistance = solarBody.orbitalElements.distance;
                    var geocentricDistance = Math.sqrt(relativeX * relativeX + relativeY * relativeY + relativeZ * relativeZ);
                    var distanceToSun = earth.orbitalElements.distance;

                    var phaseAngle = Math.acos((heliocentricDistance * heliocentricDistance + geocentricDistance * geocentricDistance - distanceToSun * distanceToSun) / (2.0 * heliocentricDistance * geocentricDistance));
                    if (solarBody.orbitalElements.distance < earth.orbitalElements.distance)
                    {
                        phaseAngle *= 0.5;
                    }
                    var phase = 0.5 * Math.cos(phaseAngle);
                    if (longitudeDifference < 180.0)
                    {
                        phase = 1.0 - phase;
                    }
                    displayedPhase = 1.0 - phase;
                }
            }

            function applyRelativeCoordinates()
            {
                if (!solarBody.visible)
                {
                    visible = false;
                    return;
                }

                var projectedCoordinates = projector.rectangularEclipticToScreenCoordinates(relativeX, relativeY, relativeZ);
                displayedX = projectedCoordinates.x + root.width / 2;
                displayedY = projectedCoordinates.y + root.height / 2;
                displayedZ = 1000 - projectedCoordinates.z;
                displayedOpacity = getOpacity(projectedCoordinates.x, projectedCoordinates.y);
                displayedRotation = projector.getImageRotation(geocentricLongitude, solarBody.orbitalElements.latitude);
                visible = projectedCoordinates.z > 0;
            }
        }
    }
    Component
    {
        id: planetImageComponent

        SkySolarBodyImage
        {
            property var painter

            x: painter.displayedX
            y: painter.displayedY
            z: painter.displayedZ
            visible: painter.visible
            rotation: painter.displayedRotation
            scale: root.currentZoom
            opacity: painter.displayedOpacity
            shadowPhase: painter.displayedPhase
            useSmallImage: solarBody !== moon
        }
    }
    Component
    {
        id: planetLabelComponent

        SolarBodyLabel
        {
            property var painter

            x: painter.displayedX
            y: painter.displayedY
            z: painter.displayedZ + 1
            visible: painter.visible && root.showLabels
            opacity: painter.displayedOpacity
            yOffsetScale: root.currentZoom
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        showDwarfPlanets: settings.showDwarfPlanets
    }
    Galaxy
    {
        id: galaxy
    }
    Projector
    {
        id: projector

        dateTime: solarSystem.dateTime
        longitude: root.longitude
        latitude: root.latitude
        longitudeLookOffset: root.longitudeLookOffset
        latitudeLookOffset: root.latitudeLookOffset
        width: root.width
        height: root.height
        zoom: root.currentZoom
        fieldOfView: root.fieldOfView
    }

    Item
    {
        id: items

        anchors { fill: parent }
        visible: solarSystem.valid

        Sun
        {
            id: sun

            animated: root.animateSun
            scale: root.currentZoom
            visible: z > 0
        }
    }

    MouseArea
    {
        id: mouseArea

        anchors { fill: parent }
        onPressed:
        {
            mouseXStart = mouse.x;
            mouseYStart = mouse.y;
            mouseLongitudeOffsetStart = longitudeLookOffset;
            mouseLatitudeOffsetStart = latitudeLookOffset;
            mouseDragged = false;
        }
        onPositionChanged:
        {
            longitudeLookOffset = mouseLongitudeOffsetStart + (360 / width) * -(mouse.x - mouseXStart);
            longitudeLookOffset = longitudeLookOffset % 360;
            latitudeLookOffset = mouseLatitudeOffsetStart + (180 / height) * -(mouse.y - mouseYStart);
            latitudeLookOffset = Math.max(-89.0, Math.min(89.0, latitudeLookOffset));

            if (!mouseDragged)
            {
                var dx = mouseLongitudeOffsetStart - longitudeLookOffset;
                var dy = mouseLatitudeOffsetStart - latitudeLookOffset;
                if (Math.sqrt(dx * dx + dy * dy) > 2)
                    mouseDragged = true;
            }

            requestPaint();
        }
        onPressAndHold:
        {
            mouseDragged = true;
        }
        onClicked:
        {
            if (!mouseDragged)
                root.click(mouse.x, mouse.y);
        }

        preventStealing: true
        propagateComposedEvents: false
    }

    Behavior on currentZoom
    {
        enabled: root.animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
    Behavior on fieldOfView
    {
        enabled: root.animateZoom

        NumberAnimation { easing.type: Easing.InOutQuart; duration: Globals.ZOOM_ANIMATION_DURATION_MS }
    }
}
