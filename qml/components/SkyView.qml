import QtQuick 2.0

Canvas
{
    id: root

    // -----------------------------------------------------------------------

    property date date
    property bool showLabels: true
    property bool showAzimutalGrid: true
    property bool showEquatorialGrid: true
    property bool showEclipticGrid: true
    property real hours: 13
    property bool timerEnabled

    property alias planetPositions: solarSystem.planetPositions
    property var planetImages: []
    property var planetLabels: []

    property real latitude: 47.066
    property real longitude: 15.433

    property real longitudeOffset: latitude < 0 ? 180 : 0
    property real longitudeLookOffset: 0.01
    property real latitudeLookOffset: 40

    property real horizontalFov: 120
    property real verticalFov: horizontalFov * (height / width)
    property real horizontalFovTan: Math.tan(horizontalFov * Math.PI / 180 / 2)
    property real verticalFovTan: Math.tan(verticalFov * Math.PI / 180 / 2)
    property real currentZoom: 1

    property var earthCoordinates: [0, 0, 0]

    property var lookUp: [0, 0, 0]
    property var lookRight: [0, 0, 0]
    property var lookView: [0, 0, 0]

    property var azimutalUp: [0, 0, 0]
    property var azimutalRight: [0, 0, 0]
    property var azimutalView: [0, 0, 0]

    property int mouseXStart
    property int mouseLongitudeOffsetStart
    property int mouseYStart
    property int mouseLatitudeOffsetStart

    property real planetRotation

    // -----------------------------------------------------------------------

    function init()
    {
        solarSystem.init();

        for (var planetIdx = 0; planetIdx < planetPositions.length; ++planetIdx)
        {
            var planetPosition = planetPositions[planetIdx];
            var planetConfig = planetPosition.planetConfig;

            var planetImage = planetImageComponent.createObject(root, {"planetConfig": planetConfig});
            var planetLabel = planetLabelComponent.createObject(root, {"planetConfig": planetConfig, "yOffset": planetImage.imageHeight * 0.75});
            planetImages.push(planetImage);
            planetLabels.push(planetLabel);
        }
    }

    // -----------------------------------------------------------------------

    function drawCircle(context, coordinates, color, radius)
    {
        if (coordinates[2] >= 0)
        {
            context.beginPath();
            context.arc(coordinates[0], coordinates[1], radius, 0, 2 * Math.PI, false);
            context.fillStyle = color;
            context.fill();
        }
    }

    // -----------------------------------------------------------------------

    function drawGridWithLines(context, coordinates, color)
    {
        var circleCount = coordinates.length;
        var equatorIdx = Math.floor(circleCount / 2);
        var segmentCount = coordinates[0].length - 1;

        context.globalAlpha = 0.2;
        context.lineJoin = "round";
        context.lineCap = "round";
        context.strokeStyle = color;

        context.beginPath();
        context.lineWidth = 1;
        for (var circleIdx = 0; circleIdx < circleCount; ++circleIdx)
        {
            if (circleIdx !== equatorIdx)
                drawGridHelperHorizontal(context, coordinates, circleIdx);
        }
        for (var segmentIdx = 0; segmentIdx < segmentCount; ++segmentIdx)
        {
            drawGridHelperVertical(context, coordinates, segmentIdx);
        }
        context.stroke();

        context.globalAlpha = 0.4;
        context.beginPath();
        context.lineWidth = 3;
        drawGridHelperHorizontal(context, coordinates, equatorIdx);
        context.stroke();
    }

    // -----------------------------------------------------------------------

    function drawGridHelperHorizontal(context, coordinates, idx)
    {
        var drawing = false;
        for (var segmentIdx = 0; segmentIdx < coordinates[idx].length; ++segmentIdx)
        {
            var projectedCoordinates = coordinates[idx][segmentIdx];
            if (projectedCoordinates[2] >= 0)
            {
                if (drawing)
                    context.lineTo(projectedCoordinates[0], projectedCoordinates[1]);
                else
                    context.moveTo(projectedCoordinates[0], projectedCoordinates[1]);
                drawing = true;
            }
            else
            {
                drawing = false;
            }
        }
    }

    // -----------------------------------------------------------------------

    function drawGridHelperVertical(context, coordinates, idx)
    {
        var drawing = false;
        for (var circleIdx = 0; circleIdx < coordinates.length; ++circleIdx)
        {
            var projectedCoordinates = coordinates[circleIdx][idx];
            if (projectedCoordinates[2] >= 0)
            {
                if (drawing)
                {
                    context.lineTo(projectedCoordinates[0], projectedCoordinates[1]);
                }
                else
                {
                    context.moveTo(projectedCoordinates[0], projectedCoordinates[1]);
                }
                drawing = true;
            }
            else if (drawing)
            {
                drawing = false;
            }
        }
    }

    // -----------------------------------------------------------------------

    function drawGridLabel(context, coordinates, color, label)
    {
        if (coordinates[2] > 0)
        {
            drawCircle(context, coordinates, color, 5);
            context.fillStyle = color;
            context.fillText(label,  coordinates[0], coordinates[1] - 5);
        }
    }

    // -----------------------------------------------------------------------

    function drawAzimutalGrid(context, color)
    {
        var coordinates = [];
        for (var skyLatitude = -75; skyLatitude <= 75; skyLatitude += 25)
        {
            var circleCoordinates = [];
            for (var skyLongitude = 0; skyLongitude <= 360; skyLongitude += 22.5)
            {
                var azimutalCoordinates = getCoordinates(skyLongitude, skyLatitude, 100);
                circleCoordinates.push(relativeAzimutalToScreenCoordinates(azimutalCoordinates));
            }
            coordinates.push(circleCoordinates);
        }
        drawGridWithLines(context, coordinates, color);

        for (var skyLongitude = 0; skyLongitude < 360; skyLongitude += 90)
        {
            var direction;
            switch (skyLongitude)
            {
                case 0: direction = "E"; break;
                case 90: direction = "N"; break;
                case 180: direction = "W"; break;
                case 270: direction = "S"; break;
            }
            drawGridLabel(context, relativeAzimutalToScreenCoordinates(getCoordinates(skyLongitude, 0, 100)), "white", direction);
        }

        // north pole
        drawGridLabel(context, relativeAzimutalToScreenCoordinates(getCoordinates(0, 90, 100)), "white", "NORTH");

        // south pole
        drawGridLabel(context, relativeAzimutalToScreenCoordinates(getCoordinates(0, -90, 100)), "white", "SOUTH");
    }

    // -----------------------------------------------------------------------

    function drawEquatorialGrid(context, color)
    {
        var coordinates = [];
        for (var skyLatitude = -75; skyLatitude <= 75; skyLatitude += 25)
        {
            var circleCoordinates = [];
            for (var skyLongitude = 0; skyLongitude <= 360; skyLongitude += 22.5)
            {
                var equatorialCoordinates = getCoordinates(skyLongitude - longitudeOffset, skyLatitude, 100);
                circleCoordinates.push(relativeEquatorialToScreenCoordinates(equatorialCoordinates));
            }
            coordinates.push(circleCoordinates);
        }
        drawGridWithLines(context, coordinates, color);

        // north pole
        var projected = relativeEquatorialToScreenCoordinates(getCoordinates(0, 90, 100));
        drawCircle(context, projected, color, 3);

        // south pole
        var projected = relativeEquatorialToScreenCoordinates(getCoordinates(0, -90, 100));
        drawCircle(context, projected, color, 3);
    }

    // -----------------------------------------------------------------------

    function drawEclipticGrid(context, color)
    {
        var coordinates = [];
        for (var skyLatitude = -75; skyLatitude <= 75; skyLatitude += 25)
        {
            var circleCoordinates = [];
            for (var skyLongitude = 0; skyLongitude <= 360; skyLongitude += 22.5)
            {
                var eclipticalCoordinates = getCoordinates(skyLongitude, skyLatitude, 100);
                circleCoordinates.push(relativeEclipticToScreenCoordinates(eclipticalCoordinates));
            }
            coordinates.push(circleCoordinates);
        }
        drawGridWithLines(context, coordinates, color);

        // north pole
        var projected = relativeEclipticToScreenCoordinates(getCoordinates(0, 90, 100));
        drawCircle(context, projected, color, 3);

        // south pole
        var projected = relativeEclipticToScreenCoordinates(getCoordinates(0, -90, 100));
        drawCircle(context, projected, color, 3);
    }

    // -----------------------------------------------------------------------

    function normalize(v)
    {
        var length = Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
        return [v[0] / length, v[1] / length, v[2] / length];
    }

    // -----------------------------------------------------------------------

    function getCoordinates(lon, lat, distance)
    {
        lon *= Math.PI / 180;
        lat *= Math.PI / 180;

        var coords = [0, 0, 0];
        coords[0] = distance * Math.cos(lat) * Math.cos(lon);
        coords[1] = distance * Math.cos(lat) * Math.sin(lon);
        coords[2] = distance * Math.sin(lat);
        return coords;
    }

    // -----------------------------------------------------------------------

    function eclipticToEquatorialCoordinates(ecliptic)
    {
        var c = Math.cos(-earth.axialTilt * Math.PI / 180);
        var s = Math.sin(-earth.axialTilt * Math.PI / 180);

        var equatorial = [0, 0, 0];
        equatorial[0] = ecliptic[0];
        equatorial[1] = c * ecliptic[1] - s * ecliptic[2];
        equatorial[2] = s * ecliptic[1] + c * ecliptic[2];
        return equatorial;
    }

    // -----------------------------------------------------------------------

    function equatorialToEclipticCoordinates(equatorial)
    {
        var c = Math.cos(-earth.axialTilt * Math.PI / 180);
        var s = Math.sin(-earth.axialTilt * Math.PI / 180);

        var ecliptic = [0, 0, 0];
        ecliptic[0] = equatorial[0];
        ecliptic[1] = c * equatorial[1] + s * equatorial[2];
        ecliptic[2] = -s * equatorial[1] + c * equatorial[2];
        return ecliptic;
    }

    // -----------------------------------------------------------------------

    function absolouteEclipticToScreenCoordinates(absoluteEclipticCoordinates)
    {
        var relativeEclipticCoordinates = [0, 0, 0];
        relativeEclipticCoordinates[0] = absoluteEclipticCoordinates[0] - earthCoordinates[0];
        relativeEclipticCoordinates[1] = absoluteEclipticCoordinates[1] - earthCoordinates[1];
        relativeEclipticCoordinates[2] = absoluteEclipticCoordinates[2] - earthCoordinates[2];
        return relativeEclipticToScreenCoordinates(relativeEclipticCoordinates);
    }

    // -----------------------------------------------------------------------

    function relativeEclipticToScreenCoordinates(relativeEclipticCoordinates)
    {
        var relativeEquatorialCoordinates = eclipticToEquatorialCoordinates(relativeEclipticCoordinates);
        return relativeEquatorialToScreenCoordinates(relativeEquatorialCoordinates);
    }

    // -----------------------------------------------------------------------

    function relativeEquatorialToScreenCoordinates(relativeEquatorialCoordinates)
    {
        var lookCoordinates = toLookCoordinates(relativeEquatorialCoordinates);
        return eyeToScreenCoordinates(lookCoordinates);
    }

    // -----------------------------------------------------------------------

    function relativeAzimutalToScreenCoordinates(coordinates)
    {
        var azimutalCoordinates = toAzimutalCoordinates(coordinates);

        var eyeCoordinates = [0, 0, 0];
        eyeCoordinates[0] = azimutalCoordinates[0] * lookRight[0] + azimutalCoordinates[1] * lookRight[1] + azimutalCoordinates[2] * lookRight[2];
        eyeCoordinates[1] = azimutalCoordinates[0] * lookView[0]  + azimutalCoordinates[1] * lookView[1]  + azimutalCoordinates[2] * lookView[2];
        eyeCoordinates[2] = azimutalCoordinates[0] * lookUp[0]    + azimutalCoordinates[1] * lookUp[1]    + azimutalCoordinates[2] * lookUp[2];
        return eyeToScreenCoordinates(eyeCoordinates);
    }

    // -----------------------------------------------------------------------

    function toAzimutalCoordinates(coordinates)
    {
        var azimutalCoordinates = [0, 0, 0];
        azimutalCoordinates[0] = coordinates[0] * azimutalRight[0] + coordinates[1] * azimutalView[0] + coordinates[2] * azimutalUp[0];
        azimutalCoordinates[1] = coordinates[0] * azimutalRight[1] + coordinates[1] * azimutalView[1] + coordinates[2] * azimutalUp[1];
        azimutalCoordinates[2] = coordinates[0] * azimutalRight[2] + coordinates[1] * azimutalView[2] + coordinates[2] * azimutalUp[2];
        return azimutalCoordinates;
    }

    // -----------------------------------------------------------------------

    function toLookCoordinates(coordinates)
    {
        var lookCoordinates = [0, 0, 0];
        lookCoordinates[0] = coordinates[0] * lookRight[0] + coordinates[1] * lookRight[1] + coordinates[2] * lookRight[2];
        lookCoordinates[1] = coordinates[0] * lookView[0]  + coordinates[1] * lookView[1]  + coordinates[2] * lookView[2];
        lookCoordinates[2] = coordinates[0] * lookUp[0]    + coordinates[1] * lookUp[1]    + coordinates[2] * lookUp[2];
        return lookCoordinates;
    }

    // -----------------------------------------------------------------------

    function eyeToScreenCoordinates(eyeCoordinates)
    {
        var distance = currentZoom / eyeCoordinates[1];

        var normalizedCoordinates = [0, 0, 0];
        normalizedCoordinates[0] = distance * eyeCoordinates[0] / horizontalFovTan;
        normalizedCoordinates[1] = eyeCoordinates[1];
        normalizedCoordinates[2] = distance * eyeCoordinates[2] / verticalFovTan;

        var projectedCoordinates = [0, 0, 0];
        projectedCoordinates[0] = (width / 2.0) * normalizedCoordinates[0];
        projectedCoordinates[1] = -(height / 2.0) * normalizedCoordinates[2];
        projectedCoordinates[2] = normalizedCoordinates[1];
        return projectedCoordinates;
    }

    // -----------------------------------------------------------------------

    onPaint:
    {
        var context = getContext("2d");
        context.reset();
        context.translate(width / 2.0, height / 2.0);

        context.font = "bold 12pt sans-serif";
        context.textAlign = "center";

        earthCoordinates = planetPositions[earth.idxWithDwarfPlanets].displayedCoordinates;
        longitudeOffset = solarSystem.getLongitudeOffset(hours);

        azimutalUp = getCoordinates(longitude - longitudeOffset, latitude, 1);
        azimutalRight = [azimutalUp[1], -azimutalUp[0], 0];
        azimutalRight = normalize(azimutalRight);
        azimutalView[0] = azimutalRight[1] * azimutalUp[2] - azimutalRight[2] * azimutalUp[1];
        azimutalView[1] = azimutalRight[2] * azimutalUp[0] - azimutalRight[0] * azimutalUp[2];
        azimutalView[2] = azimutalRight[0] * azimutalUp[1] - azimutalRight[1] * azimutalUp[0];
        azimutalView = normalize(azimutalView);

        lookView = getCoordinates(longitudeLookOffset - 90, latitudeLookOffset, 1);
        lookRight = [lookView[1], -lookView[0], 0];
        lookRight = normalize(lookRight);
        lookUp[0] = lookRight[1] * lookView[2] - lookRight[2] * lookView[1];
        lookUp[1] = lookRight[2] * lookView[0] - lookRight[0] * lookView[2];
        lookUp[2] = lookRight[0] * lookView[1] - lookRight[1] * lookView[0];
        lookUp = normalize(lookUp);

        lookRight = toAzimutalCoordinates(lookRight);
        lookView = toAzimutalCoordinates(lookView);
        lookUp = toAzimutalCoordinates(lookUp);

        if (showAzimutalGrid)
            drawAzimutalGrid(context, "cyan");

        if (showEquatorialGrid)
            drawEquatorialGrid(context, "lightblue");

        if (showEclipticGrid)
            drawEclipticGrid(context, "blue");

        context.globalAlpha = 1.0;

        // stars
        var maxMagnitude = starConfigs[0].magnitude;
        for (var starIdx = 0; starIdx < starConfigs.length; ++starIdx)
        {
            var starConfig = starConfigs[starIdx];
            var projectedStarCoordinates = relativeEquatorialToScreenCoordinates(getCoordinates(starConfig.raDegrees, starConfig.declination, 100));
            drawCircle(context, projectedStarCoordinates, "yellow", 4 * (1.0 - (starConfig.magnitude - maxMagnitude) / 6));
        }

        // sun
        var projected = absolouteEclipticToScreenCoordinates([0, 0, 0]);
        sun.x = projected[0] + width / 2;
        sun.y = projected[1] + height / 2;
        sun.z = 1000 - projected[2];
        sun.visible = projected[2] > 0;

        // planets
        for (var planetIdx = 0; planetIdx < planetPositions.length; ++planetIdx)
        {
            var planetPosition = planetPositions[planetIdx];
            var planetCoordinates = planetPosition.displayedCoordinates;
            var planetImage = planetImages[planetIdx];
            var planetLabel = planetLabels[planetIdx];

            if (!planetPosition.planetConfig.visible || planetIdx === earth.idxWithDwarfPlanets)
            {
                planetImage.visible = false;
                planetLabel.visible = false;
                continue;
            }
            var orientation = -earthCoordinates[0] * (planetCoordinates[1] - earthCoordinates[1]) - (planetCoordinates[0] - earthCoordinates[0]) * -earthCoordinates[1];

            var projectedPlanetCoordinates = absolouteEclipticToScreenCoordinates(planetCoordinates);
            planetImage.x = projectedPlanetCoordinates[0] + width / 2;
            planetImage.y = projectedPlanetCoordinates[1] + height / 2;
            planetImage.z = projectedPlanetCoordinates[2];
            planetImage.z = 1000 - projectedPlanetCoordinates[2];
            planetImage.shadowRotation = orientation > 0.0 ? 180 : 0;
            planetImage.visible = projectedPlanetCoordinates[2] > 0;

            planetLabel.x = projectedPlanetCoordinates[0] + width / 2;
            planetLabel.y = projectedPlanetCoordinates[1] + height / 2;
            planetLabel.z = 1000 - projectedPlanetCoordinates[2];
            planetLabel.visible = showLabels && projectedPlanetCoordinates[2] > 0;
        }

        // calculate rotation of planet images along ecliptic plane
        var eclipticLongitude = -longitudeOffset - longitudeLookOffset;
        var projectedEclipticPosition1 = relativeEclipticToScreenCoordinates(getCoordinates(eclipticLongitude, 0, 100));
        var projectedEclipticPosition2 = relativeEclipticToScreenCoordinates(getCoordinates(eclipticLongitude + 1, 0, 100));
        planetRotation = Math.atan2(projectedEclipticPosition2[0] - projectedEclipticPosition1[0], -(projectedEclipticPosition2[1] - projectedEclipticPosition1[1])) * 180 / Math.PI + 90;
    }

    // -----------------------------------------------------------------------

    Component
    {
        id: planetImageComponent

        PlanetImage
        {
            showShadowOnPlanet: true
            showShadowBehindPlanet: false
            rotation: planetRotation
            shadowOpacity: Math.min(1.0, Math.sqrt((x - sun.x) * (x - sun.x) + (y - sun.y) * (y - sun.y)) / 150)

            Behavior on shadowOpacity
            {
                NumberAnimation { duration: 100 }
            }
            Behavior on shadowRotation
            {
                RotationAnimation { direction: RotationAnimation.Shortest; duration: 100 }
            }
        }
    }
    Component
    {
        id: planetLabelComponent

        PlanetLabel
        {
        }
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        date: root.date
        showDwarfPlanets: settings.showDwarfPlanets
        simplifiedOrbits: false
        radius: 100
    }
    Sun
    {
        id: sun

        animated: true
        rotation: planetRotation
        visible: z > 0
    }

    Timer
    {
        repeat: true
        interval: 50
        running: timerEnabled
        onTriggered:
        {
            /*
            hours += 0.05;
            hours %= 24;
            */
            var newDate = new Date(date);
            newDate.setDate(newDate.getDate() + 1);
            date = newDate;
            parent.requestPaint();
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
            longitudeLookOffset %= 360;
            latitudeLookOffset = mouseLatitudeOffsetStart + (180 / height) * -(mouse.y - mouseYStart);
            latitudeLookOffset = Math.max(-89.0, Math.min(89.0, latitudeLookOffset));
            root.requestPaint();
        }
    }
}
