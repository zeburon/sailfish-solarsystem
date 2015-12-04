import QtQuick 2.0

QtObject
{
    property SolarBody solarBody

    // -----------------------------------------------------------------------
    // orbit visualization parameters

    property real orbitSimplifiedRadiusWithDwarfPlanets
    property real orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitSimplifiedRadius: showDwarfPlanets ? orbitSimplifiedRadiusWithDwarfPlanets : orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitProjectionFactor: Math.cos(solarBody.i1  * Math.PI / 180) // adjust orbit dimensions according to inclination
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((solarBody.orbitAphelion - solarBody.orbitPerihelion) / 2.0) * auSize * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitCorrectionFactorX * solarBody.a1 * auSize * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : solarBody.orbitCorrectionFactorY * solarBody.a1 * auSize * Math.sqrt(1.0 - Math.pow(solarBody.e1, 2))
    property real orbitRotationInRad: solarBody.w1 * Math.PI / 180.0

    // -----------------------------------------------------------------------
    // result of calculation

    property var eclipticCoordinates: [0, 0, 0]
    property var oldEclipticCoordinates: [0, 0, 0]

    // -----------------------------------------------------------------------
    // parameters used for displaying the calculated data

    property var displayedCoordinates: [0, 0, 0]
    property real displayedShadowRotation: Math.atan2(displayedCoordinates[1] + displayedCoordinates[2], displayedCoordinates[0]) * 180 / Math.PI;
    property real displayedOpacity: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - currentZoom) * (1.0 - solarBody.smallImageScaleZoomedOut) + currentZoom * (1.0 - solarBody.smallImageScaleZoomedIn)))
}
