import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.DateTime 1.0

import "../globals.js" as Globals

Item
{
    property SolarBody solarBody
    property var parentPainter: null

    // settings
    property real auSize
    property real currentZoom
    property real imageScale
    property bool simplifiedOrbits

    // orbit parameters
    property real orbitProjectionFactor: Math.cos(solarBody.orbitalElements.inclination) // adjust orbit dimensions according to inclination
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((solarBody.orbitalElements.maximumDistance - solarBody.orbitalElements.minimumDistance) / 2.0) * auSize * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitalElements.semiMajorAxis * auSize * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitalElements.semiMajorAxis * auSize * Math.sqrt(1.0 - Math.pow(solarBody.orbitalElements.eccentricity, 2))
    property real orbitRotation: solarBody.orbitalElements.argumentOfPeriapsis + solarBody.orbitalElements.longitudeOfAscendingNode
    property real orbitSimplifiedRadius

    // image parameters
    property real displayedX
    property real displayedY
    property real displayedOpacity: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - currentZoom) * (1.0 - solarBody.smallImageScaleZoomedOut) + currentZoom * (1.0 - solarBody.smallImageScaleZoomedIn)))
    property real displayedScale: imageScale * displayedOpacity
    property real displayedShadowRotation: Math.atan2(displayedY, displayedX) * 180 / Math.PI;

    // -----------------------------------------------------------------------

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
            newX = solarBody.orbitalElements.x * auSize * solarBody.orbitCorrectionFactorX;
            newY = solarBody.orbitalElements.y * auSize * solarBody.orbitCorrectionFactorY;
            if (parentPainter)
            {
                newX *= 75;
                newY *= 75;
            }
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
