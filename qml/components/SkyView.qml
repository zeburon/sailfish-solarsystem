import QtQuick 2.0
import harbour.solarsystem.Projector 1.0
import harbour.solarsystem.DateTime 1.0

Canvas
{
    id: root

    // -----------------------------------------------------------------------

    property bool showLabels: true
    property bool showAzimuth: true
    property bool showEquator: true
    property bool showEcliptic: true

    property alias solarSystem: solarSystem
    property var solarBodyInfos: []

    property real latitude: 47.066
    property real longitude: 15.433

    property real fieldOfView: 120
    property real currentZoom: 1.0

    property var earthCoordinates: [0, 0, 0]
    property real sunLongitude

    property real longitudeLookOffset: 0.01
    property real latitudeLookOffset: 40
    property int mouseXStart
    property int mouseLongitudeOffsetStart
    property int mouseYStart
    property int mouseLatitudeOffsetStart

    // -----------------------------------------------------------------------

    function init()
    {
        for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
        {
            var solarBody = solarSystem.solarBodies[bodyIdx];

            var info = solarBodyInfo.createObject(null, {"solarBody": solarBody});
            solarBodyInfos.push(info);

            var planetImage = planetImageComponent.createObject(root, {"solarBody": solarBody, "info": info});
            var planetLabel = planetLabelComponent.createObject(root, {"solarBody": solarBody, "info": info, "yOffset": planetImage.imageHeight * 0.75});
        }
    }

    // -----------------------------------------------------------------------

    function update(dateTime)
    {
        solarSystem.dateTime.string = dateTime.string;
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
            drawCircle(context, coordinates, color, 5);
            context.fillStyle = color;
            context.fillText(label,  coordinates.x, coordinates.y - 5);
        }
    }

    // -----------------------------------------------------------------------

    function drawPath(context, coordinates)
    {
        var drawing = false;
        for (var idx = 0; idx < coordinates.length; ++idx)
        {
            var point = coordinates[idx];
            if (point.z > 0)
            {
                if (drawing)
                    context.lineTo(point.x, point.y);
                else
                    context.moveTo(point.x, point.y);

                drawing = true;
            }
            else
            {
                drawing = false;
            }
        }
    }

    // -----------------------------------------------------------------------

    function drawAzimuth(context)
    {
        var skyLongitude, skyLatitude;

        context.globalAlpha = 0.3;
        context.lineWidth = 2;

        // upper hemisphere
        context.strokeStyle = "#9999ff";
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

        // lower hemisphere
        context.strokeStyle = "#88cc00";
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

        // equator
        context.globalAlpha = 0.4;
        context.lineWidth = 4;
        context.strokeStyle = "white";
        var equatorCoordinates = [];
        for (skyLongitude = 0; skyLongitude <= 360; skyLongitude += 10)
        {
            equatorCoordinates.push(projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, 0));
        }
        context.beginPath();
        drawPath(context, equatorCoordinates);
        context.stroke();

        // labels
        context.globalAlpha = 0.6;
        for (skyLongitude = 0; skyLongitude < 360; skyLongitude += 90)
        {
            var direction;
            switch (skyLongitude)
            {
                case 0: direction = "E"; break;
                case 90: direction = "N"; break;
                case 180: direction = "W"; break;
                case 270: direction = "S"; break;
            }
            drawLabel(context, projector.sphericalAzimuthalToScreenCoordinates(skyLongitude, 0), "white", direction);
        }
        drawLabel(context, projector.sphericalAzimuthalToScreenCoordinates(0, 90), "#9999ff", "NORTH");
        drawLabel(context, projector.sphericalAzimuthalToScreenCoordinates(0, -90), "#88cc00", "SOUTH");
    }

    // -----------------------------------------------------------------------

    function drawEquator(context)
    {
        // equator
        var coordinates = [];
        for (var skyLongitude = 0; skyLongitude <= 360; skyLongitude += 10)
        {
            coordinates.push(projector.sphericalEquatorialToScreenCoordinates(skyLongitude, 0));
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
        // equator
        var coordinates = [];
        for (var skyLongitude = 0; skyLongitude <= 360; skyLongitude += 10)
        {
            coordinates.push(projector.sphericalEclipticToScreenCoordinates(skyLongitude, 0));
        }
        context.globalAlpha = 0.3;
        context.lineWidth = 4;
        context.beginPath();
        drawPath(context, coordinates);
        context.strokeStyle = "cyan";
        context.stroke();
    }

    // -----------------------------------------------------------------------

    onPaint:
    {
        var context = getContext("2d");
        context.reset();
        context.translate(width / 2.0, height / 2.0);

        context.font = "bold 12pt sans-serif";
        context.textAlign = "center";

        earthCoordinates[0] = solarSystem.earth.orbitalElements.x;
        earthCoordinates[1] = solarSystem.earth.orbitalElements.y;
        earthCoordinates[2] = solarSystem.earth.orbitalElements.z;

        //longitudeLookOffset = -dateTime.meanSiderealTime / 24 * 360 - solarSystem.saturn.orbitalElements.longitude - longitude;
        //latitudeLookOffset = 0;

        projector.update();

        if (showAzimuth)
            drawAzimuth(context);
        if (showEquator)
            drawEquator(context);
        if (showEcliptic)
            drawEcliptic(context);

        context.globalAlpha = 1.0;

        // stars
        var maxMagnitude = starConfigs[0].magnitude;
        for (var starIdx = 0; starIdx < starConfigs.length; ++starIdx)
        {
            var starConfig = starConfigs[starIdx];
            var projectedStarCoordinates = projector.sphericalEclipticToScreenCoordinates(starConfig.raDegrees, starConfig.declination);
            drawCircle(context, projectedStarCoordinates, "yellow", 4 * (1.0 - (starConfig.magnitude - maxMagnitude) / 6));
        }

        // sun
        var projected = projector.rectangularEclipticToScreenCoordinates(-earthCoordinates[0], -earthCoordinates[1], -earthCoordinates[2]);
        sun.x = projected.x + width / 2;
        sun.y = projected.y + height / 2;
        sun.z = 1000 - projected.z;
        sun.visible = projected.z > 0;
        sunLongitude = (solarSystem.earth.orbitalElements.longitude + 180) % 360;
        sun.rotation = projector.getImageRotation(sunLongitude, 0);

        // planets
        for (var infoIdx = 0; infoIdx < solarBodyInfos.length; ++infoIdx)
        {
            solarBodyInfos[infoIdx].updateCoordinates();
        }
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: solarBodyInfo

        Item
        {
            property SolarBody solarBody

            property real displayedX
            property real displayedY
            property real displayedZ
            property real displayedRotation
            property real displayedPhase: 0.5
            property real longitudeFromEarth

            function updateCoordinates()
            {
                if (!solarBody.visible)
                {
                    visible = false;
                    return;
                }

                var dx = solarBody.orbitalElements.x;
                var dy = solarBody.orbitalElements.y;
                var dz = solarBody.orbitalElements.z;
                if (solarBody.parentSolarBody)
                {
                    var parentSolarBody = solarBody.parentSolarBody;
                    dx += parentSolarBody.orbitalElements.x;
                    dy += parentSolarBody.orbitalElements.y;
                    dz += parentSolarBody.orbitalElements.z;
                }
                dx -= earthCoordinates[0];
                dy -= earthCoordinates[1];
                dz -= earthCoordinates[2];

                var newLongitudeFromEarth = Math.atan2(dy, dx) * 180 / Math.PI;
                if (newLongitudeFromEarth < 0.0)
                {
                    newLongitudeFromEarth += 360.0;
                }
                longitudeFromEarth = newLongitudeFromEarth;

                var projectedCoordinates = projector.rectangularEclipticToScreenCoordinates(dx, dy, dz)
                displayedX = projectedCoordinates.x + root.width / 2;
                displayedY = projectedCoordinates.y + root.height / 2;
                displayedZ = 1000 - projectedCoordinates.z;
                visible = projectedCoordinates.z > 0;
                displayedRotation = projector.getImageRotation(longitudeFromEarth, solarBody.orbitalElements.latitude);

                if (solarBody.orbitalElements.distance < solarSystem.earth.orbitalElements.distance)
                {
                    var age = (solarBody.orbitalElements.longitude - root.sunLongitude + 180) % 360.0;
                    if (age < 0)
                    {
                        age += 360;
                    }
                    var phase = 1.0 - 0.5 * (1.0 - Math.cos(0.5 * age * Math.PI / 180));
                    if (solarBody.parentSolarBody)
                    {
                        phase = (phase + 0.5) % 1.0;
                    }
                    displayedPhase = phase;
                }
            }
        }
    }
    Component
    {
        id: planetImageComponent

        SkySolarBodyImage
        {
            property var info

            x: info.displayedX
            y: info.displayedY
            z: info.displayedZ
            visible: info.visible
            rotation: info.displayedRotation
            shadowPhase: info.displayedPhase
            useSmallImage: !solarBody.parentSolarBody
        }
    }
    Component
    {
        id: planetLabelComponent

        SolarBodyLabel
        {
            property var info

            x: info.displayedX
            y: info.displayedY
            z: info.displayedZ + 1
            visible: info.visible && root.showLabels
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        showDwarfPlanets: settings.showDwarfPlanets
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
    Sun
    {
        id: sun

        animated: true
        visible: z > 0
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
}
