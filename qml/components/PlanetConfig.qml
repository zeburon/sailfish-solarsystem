import QtQuick 2.0

QtObject
{
    // -----------------------------------------------------------------------
    // general configuration

    property string name
    property bool isDwarfPlanet: false
    property bool visible: true

    property int idxWithDwarfPlanets
    property int idxWithoutDwarfPlanets

    property string smallImageSource
    property string smallImageOnTopSource
    property real smallImageScaleZoomedIn: 1.0
    property real smallImageScaleZoomedOut: 1.0
    property string mediumImageSource
    property string mediumImageOnTopSource

    // adjust to improve planet image and orbit alignment
    property color orbitColor
    property real orbitCorrectionFactorX: 1
    property real orbitCorrectionFactorY: 1
    property bool orbitCanShowZPosition: false

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
    // detailed information

    property real orbitAverageDistance: a1 * (1 + Math.pow(e1, 2) / 2) // au
    property real orbitPerihelion: a1 * (1.0 - e1) // au
    property real orbitAphelion: a1 * (1.0 + e1) // au
    property real orbitalPeriod: 360 / (l2 / 100) // years
    property real orbitalVelocity: ((2 * Math.PI * a1 * 1.4960e11) / (orbitalPeriod * 365.25 * 24 * 3600)) * (1 - (1 * Math.pow(e1, 2)) / 4 - (3 * Math.pow(e1, 4)) / 64 - (5 * Math.pow(e1, 6)) / 256 - (175 * Math.pow(e1, 8)) / 16384) // m / s
    property real axialTilt // degrees
    property real rotationPeriod // days
    property int satelliteCount
    property real radius // km
    property real volume // km³
    property real mass // kg
    property real surface // km²
    property real density: mass / volume // kg / km³
    property real surfaceGravity: (6.67e-11 * mass) / Math.pow(radius * 1000, 2) // m / s²
    property real escapeVelocity: Math.sqrt((2 * 6.67e-11 * mass) / (radius * 1000)) // m / s
}
