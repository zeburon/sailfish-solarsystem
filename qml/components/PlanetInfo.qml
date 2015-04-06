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
    property real orbitProjectionFactor: Math.cos(i1  * Math.PI / 180) // adjust orbit dimensions according to inclination
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((orbitAphelion - orbitPerihelion) / 2.0) * au * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : positionCorrectionFactorX * a1 * au * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : positionCorrectionFactorY * a1 * au * Math.sqrt(1.0 - e1 * e1)

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
    // result of position calculation is multiplied by these factors. slightly improves planet image and orbit alignment

    property real positionCorrectionFactorX: 1
    property real positionCorrectionFactorY: 1

    // -----------------------------------------------------------------------
    // result of last calculation

    property real calculatedX
    property real calculatedY
    property real calculatedZ

    // -----------------------------------------------------------------------
    // dynamic parameters used for displaying the current state

    property real currentShadowRotation: Math.atan2(calculatedY + calculatedZ, calculatedX) * 180 / Math.PI;
    property real currentOpacityFactor: simplifiedOrbits ? 1.0 : (1.0 - ((1.0 - currentZoom) * (1.0 - imageZoomedOutScale) + currentZoom * (1.0 - imageZoomedInScale)))
}
