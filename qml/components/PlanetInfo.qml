import QtQuick 2.0

QtObject
{
    // -----------------------------------------------------------------------
    // general configuration

    property string name
    property string imageSource
    property real imageZoomedOutScale: 1.0
    property real currentFadeOutValue: 1.0 - (1.0 - currentZoom) * (1.0 - imageZoomedOutScale)
    property bool useInPlanetDistanceList: true

    // -----------------------------------------------------------------------
    // orbit visualization parameters

    property color orbitColor
    property real orbitAlpha: 0.4
    property real orbitSimplifiedRadius
    property real orbitPerihelion: a1 * (1.0 - e1)
    property real orbitAphelion: a1 * (1.0 + e1)
    property real orbitProjectionFactor: Math.cos(i1  * Math.PI / 180)
    property real orbitOffset: simplifiedOrbits ? 0.0 : ((orbitAphelion - orbitPerihelion) / 2.0) * au * orbitProjectionFactor
    property real orbitA: simplifiedOrbits ? orbitSimplifiedRadius : positionCorrectionFactorX * a1 * au * orbitProjectionFactor
    property real orbitB: simplifiedOrbits ? orbitSimplifiedRadius : positionCorrectionFactorY * a1 * au * Math.sqrt(1.0 - e1 * e1)

    // -----------------------------------------------------------------------
    // orbital elements

    // semi-major axis
    property real a1
    property real a2

    // eccentricity
    property real e1
    property real e2

    // inclination
    property real i1
    property real i2

    // mean anomaly
    property real l1
    property real l2

    // additional terms of the mean anomaly
    property real b
    property real c
    property real s
    property real f

    // argument of perihelion
    property real w1
    property real w2

    // longitude of ascending node
    property real o1
    property real o2

    // -----------------------------------------------------------------------
    // result of position is multiplied by these factors. slightly improve planet image and orbit alignment

    property real positionCorrectionFactorX: 1
    property real positionCorrectionFactorY: 1

    // -----------------------------------------------------------------------
    // result of last calculation

    property real calculatedX
    property real calculatedY
    property real calculatedShadowRotation
}
