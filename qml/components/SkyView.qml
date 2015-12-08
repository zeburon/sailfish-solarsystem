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
    property bool animateZoom: false

    // view-related properties
    property real latitude: 47.066
    property real longitude: 15.433
    property real fieldOfView: zoomedOut ? 90 : 120
    property real currentZoom: zoomedOut ? 0.5 : 1.0
    property real visibleRadius: 1.175 * Math.sqrt(2.0 * Math.pow(Math.max(width, height), 2.0)) * currentZoom / 2.0
    property real visibleRadiusFadeStart: visibleRadius - 40

    // mouse-look properties
    property real longitudeLookOffset: 0.01
    property real latitudeLookOffset: 40
    property int mouseXStart
    property int mouseLongitudeOffsetStart
    property int mouseYStart
    property int mouseLatitudeOffsetStart

    // solar body information
    property alias solarSystem: solarSystem
    property alias earth: solarSystem.earth
    property alias moon: solarSystem.moon
    property alias mars: solarSystem.mars
    property real sunLongitude
    property var solarBodyPainters: []

    // -----------------------------------------------------------------------

    signal showHelpText(string text)

    // -----------------------------------------------------------------------

    function init()
    {
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];

            var painter = solarBodyPainter.createObject(null, {"solarBody": solarBody});
            solarBodyPainters.push(painter);

            var planetImage = planetImageComponent.createObject(items, {"solarBody": solarBody, "painter": painter});
            var planetLabel = planetLabelComponent.createObject(items, {"solarBody": solarBody, "painter": painter, "yOffset": planetImage.imageHeight * 0.3});
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
                solarBodyPainters[painterIdx].calculateRelativeCoordinates();
            }
        }
        requestPaint();
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
        var newX = xPos + dX;
        var newY = yPos + dY;
        var originalLength = Math.sqrt(xPos * xPos + yPos * yPos);
        var newLength = Math.sqrt(newX * newX + newY * newY);

        var factor = (visibleRadius - originalLength) / (newLength - originalLength);
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

        // enable clipping
        context.beginPath();
        context.arc(width / 2.0, height / 2.0, visibleRadius, 0, Math.PI * 2, false);
        context.clip();
        context.translate(width / 2.0, height / 2.0);

        projector.update();

        // helper lines
        if (showAzimuth)
            drawAzimuth(context);
        if (showEquator)
            drawEquator(context);
        if (showEcliptic)
            drawEcliptic(context);

        // background
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        /*
        var gradient = context.createRadialGradient(0, 0, visibleRadius / 2, 0, 0, visibleRadius);
        gradient.addColorStop(0, "black");
        gradient.addColorStop(1, "#005ddb");
        */
        context.beginPath();
        context.arc(0, 0, visibleRadius - 2, 0, 2 * Math.PI, false);
        /*
        context.fillStyle = gradient;
        context.fill();
        */
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

            function calculateRelativeCoordinates()
            {
                if (!solarBody.visible)
                {
                    visible = false;
                    return;
                }

                // calculate geocentric coordinates
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

                // calculate geocentric longitude
                var newLongitudeFromEarth = Math.atan2(relativeY, relativeX) * 180 / Math.PI;
                if (newLongitudeFromEarth < 0.0)
                {
                    newLongitudeFromEarth += 360.0;
                }
                geocentricLongitude = newLongitudeFromEarth;

                // calulate new phase
                if (solarBody.orbitalElements.distance < solarSystem.earth.orbitalElements.distance)
                {
                    var age = (solarBody.orbitalElements.longitude - root.sunLongitude + 180) % 360.0;
                    if (age < 0)
                    {
                        age += 360;
                    }
                    var phase = 1.0 - 0.5 * (1.0 - Math.cos(0.5 * age * Math.PI / 180));

                    // phase is inverted if body is not orbiting the sun
                    if (solarBody === moon)
                    {
                        phase = (1.5 - phase) % 1.0;
                    }
                    displayedPhase = phase;
                }
                else if (solarBody === mars)
                {
                    var heliocentricDistance = solarBody.orbitalElements.distance;
                    var geocentricDistance = Math.sqrt(relativeX * relativeX + relativeY * relativeY + relativeZ * relativeZ);
                    var distanceToSun = earth.orbitalElements.distance;

                    var longitudeDifference = (earth.orbitalElements.longitude - solarBody.orbitalElements.longitude) % 360.0;
                    if (longitudeDifference < 0.0)
                    {
                        longitudeDifference += 360.0;
                    }

                    var age = Math.acos((heliocentricDistance * heliocentricDistance + geocentricDistance * geocentricDistance - distanceToSun * distanceToSun) / (2.0 * heliocentricDistance * geocentricDistance));
                    var phase = 0.5 * Math.cos(age);
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
        longitudeOffset: longitudeLookOffset
        latitudeOffset: latitudeLookOffset
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

            animated: true
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
        }
        onPositionChanged:
        {
            longitudeLookOffset = mouseLongitudeOffsetStart + (360 / width) * -(mouse.x - mouseXStart);
            longitudeLookOffset = longitudeLookOffset % 360;
            latitudeLookOffset = mouseLatitudeOffsetStart + (180 / height) * -(mouse.y - mouseYStart);
            latitudeLookOffset = Math.max(-89.0, Math.min(89.0, latitudeLookOffset));
            requestPaint();
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
