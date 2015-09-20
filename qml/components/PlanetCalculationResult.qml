import QtQuick 2.0

QtObject
{
    property PlanetInfo planetInfo

    // -----------------------------------------------------------------------
    // orbit visualization parameters

    property real orbitSimplifiedRadiusWithDwarfPlanets
    property real orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitSimplifiedRadius: showDwarfPlanets ? orbitSimplifiedRadiusWithDwarfPlanets : orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((planetInfo.orbitAphelion - planetInfo.orbitPerihelion) / 2.0) * auSize * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : planetInfo.orbitCorrectionFactorX * planetInfo.a1 * auSize * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : planetInfo.orbitCorrectionFactorY * planetInfo.a1 * auSize * Math.sqrt(1.0 - Math.pow(planetInfo.e1, 2))

    // adjust orbit dimensions according to inclination
    property real orbitProjectionFactor: Math.cos(planetInfo.i1  * Math.PI / 180)

    // -----------------------------------------------------------------------
    // result of calculation

    property var eclipticCoordinates: [0, 0, 0]
    property var oldEclipticCoordinates: [0, 0, 0]

    // ecliptic coordinates transformed into visual representation
    property var displayedCoordinates: [0, 0, 0]

    // -----------------------------------------------------------------------
    // dynamic parameters used for displaying the current state

    property real currentShadowRotation: Math.atan2(displayedCoordinates[1] + displayedCoordinates[2], displayedCoordinates[0]) * 180 / Math.PI;
    property real currentOpacityFactor: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - currentZoom) * (1.0 - planetInfo.smallImageScaleZoomedOut) + currentZoom * (1.0 - planetInfo.smallImageScaleZoomedIn)))
}
