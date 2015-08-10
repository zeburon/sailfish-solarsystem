import QtQuick 2.0

QtObject
{
    // -----------------------------------------------------------------------
    // general configuration

    property string name
    property bool isDwarfPlanet: false
    property bool useInPlanetDistanceList: true

    property string imageSource
    property real imageZoomedInScale: 1.0
    property real imageZoomedOutScale: 1.0

    property int idxWithDwarfPlanets
    property int idxWithoutDwarfPlanets
    property bool visible: true

    // -----------------------------------------------------------------------
    // orbit visualization parameters

    property color orbitColor
    property real orbitAlpha: 0.4
    property real orbitSimplifiedRadiusWithDwarfPlanets
    property real orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitSimplifiedRadius: showDwarfPlanets ? orbitSimplifiedRadiusWithDwarfPlanets : orbitSimplifiedRadiusWithoutDwarfPlanets
    property real orbitPerihelion: a1 * (1.0 - e1)
    property real orbitAphelion: a1 * (1.0 + e1)
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((orbitAphelion - orbitPerihelion) / 2.0) * au * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : orbitCorrectionFactorX * a1 * au * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : orbitCorrectionFactorY * a1 * au * Math.sqrt(1.0 - e1 * e1)

    // adjust orbit dimensions according to inclination
    property real orbitProjectionFactor: Math.cos(i1  * Math.PI / 180)

    // adjust to improve planet image and orbit alignment
    property real orbitCorrectionFactorX: 1
    property real orbitCorrectionFactorY: 1

    // -----------------------------------------------------------------------
    // orbital elements

    // semi-major axis
    property real a1 // au
    property real a2 // au / century

    // eccentricity
    property real e1
    property real e2 // / century

    // inclination
    property real i1 // degrees
    property real i2 // degrees / century

    // mean anomaly
    property real l1 // degrees
    property real l2 // degrees / century

    // additional terms of the mean anomaly
    property real b // degrees
    property real c // degrees
    property real s // degrees
    property real f // degrees

    // argument of perihelion
    property real w1 // degrees
    property real w2 // degrees / century

    // longitude of ascending node
    property real o1 // degrees
    property real o2 // degrees / century

    // -----------------------------------------------------------------------
    // result of calculation

    property var eclipticCoordinates: []
    property var oldEclipticCoordinates: []

    // ecliptic coordinates transformed into visual representation
    property var displayedCoordinates: []

    // -----------------------------------------------------------------------
    // dynamic parameters used for displaying the current state

    property real currentShadowRotation: Math.atan2(displayedCoordinates[1] + displayedCoordinates[2], displayedCoordinates[0]) * 180 / Math.PI;
    property real currentOpacityFactor: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - currentZoom) * (1.0 - imageZoomedOutScale) + currentZoom * (1.0 - imageZoomedInScale)))
}
