import QtQuick 2.0
import QtSensors 5.0 // ssh to emulator and type 'sudo pkcon install qt5-qtdeclarative-import-sensors'
import Sailfish.Silica 1.0
import harbour.solarsystem.Projector 1.0
import harbour.solarsystem.DateTime 1.0

import "../globals.js" as Globals

Item
{
    property SolarBody solarBody
    property SolarBody sun
    property SolarBody earth
    property SolarBody moon
    property SolarBody mars

    // coordinates
    property real projectedX
    property real projectedY
    property real projectedZ
    property real relativeX
    property real relativeY
    property real relativeZ
    property real relativeDistance
    property real geocentricLongitude
    property real geocentricLatitude
    property real azimuthalLongitude
    property real azimuthalLatitude

    // image parameters
    property real displayedX
    property real displayedY
    property real displayedZ
    property real displayedRotation
    property real displayedOpacity
    property real displayedPhase: 0.5
    property real displayedScale: 1.0

    // -----------------------------------------------------------------------

    function calculateRelativeCoordinates()
    {
        if (!solarBody.visible)
        {
            visible = false;
            return;
        }

        // calculate geocentric rectangular coordinates
        if (solarBody === sun)
        {
            relativeX = -earth.orbitalElements.x;
            relativeY = -earth.orbitalElements.y;
            relativeZ = -earth.orbitalElements.z;
        }
        else
        {
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
        }
        relativeDistance = Math.sqrt(relativeX * relativeX + relativeY * relativeY + relativeZ * relativeZ);

        // calculate geocentric spherical coordinates
        var newLongitudeFromEarth = Math.atan2(relativeY, relativeX) * 180 / Math.PI;
        if (newLongitudeFromEarth < 0.0)
        {
            newLongitudeFromEarth += 360.0;
        }
        geocentricLongitude = newLongitudeFromEarth;
        geocentricLatitude  = Math.asin(relativeZ / relativeDistance) * 180 / Math.PI;
    }

    function calculatePhase()
    {
        if (solarBody === sun)
            return;

        if (solarBody === moon)
        {
            var sunLongitude = (earth.orbitalElements.longitude + 180) % 360;
            var longitudeDifference = (sunLongitude - solarBody.orbitalElements.longitude) % 360.0;
            if (longitudeDifference < 0.0)
            {
                longitudeDifference += 360.0;
            }

            var elongation = Math.acos(Math.cos((sunLongitude - solarBody.orbitalElements.longitude) * Math.PI / 180) * Math.cos(solarBody.orbitalElements.latitude * Math.PI / 180));
            var phase = (1.0 + Math.cos(Math.PI - elongation)) / 4.0;
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
            displayedPhase = phase;
        }
        else
        {
            displayedPhase = 0.5;
        }
    }

    function applyRelativeCoordinates()
    {
        if (!solarBody.visible)
        {
            visible = false;
            return;
        }

        var azimuthalCoordinates = projector.eclipticToAzimuthalCoordinates(geocentricLongitude, geocentricLatitude);
        azimuthalLongitude = 360.0 - azimuthalCoordinates.x;
        azimuthalLatitude = azimuthalCoordinates.y;

        var projectedCoordinates = projector.rectangularEclipticToScreenCoordinates(relativeX, relativeY, relativeZ);
        projectedX = projectedCoordinates.x;
        projectedY = projectedCoordinates.y;
        projectedZ = projectedCoordinates.z;
        displayedX = projectedX + width / 2;
        displayedY = projectedY + height / 2;
        displayedZ = 1000 - projectedZ;
        displayedOpacity = 1.0 - 0.5 * Math.min(1.0, (Math.abs(Math.min(5, azimuthalLatitude) - 5) / 5.0));
        displayedRotation = projector.getImageRotation(geocentricLongitude, geocentricLatitude);
        visible = projectedZ > 0;

        // calculate scale
        var minimumDistance, maximumDistance;
        if (solarBody === moon)
        {
            minimumDistance = solarBody.orbitalElements.minimumDistance;
            maximumDistance = solarBody.orbitalElements.maximumDistance;
        }
        else
        {
            minimumDistance = Math.abs(solarBody.orbitalElements.minimumDistance - earth.orbitalElements.minimumDistance);
            maximumDistance = solarBody.orbitalElements.maximumDistance + earth.orbitalElements.maximumDistance;
        }
        displayedScale = 1.0 - 0.5 * (1.0 - minimumDistance / maximumDistance) * ((relativeDistance - minimumDistance) / (maximumDistance - minimumDistance));
    }
}
