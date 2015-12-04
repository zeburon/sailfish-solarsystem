import QtQuick 2.0
import harbour.solarsystem.OrbitalElements 1.0

QtObject
{
    // -----------------------------------------------------------------------
    // general configuration

    property string name
    property var orbitalElements
    property QtObject parentSolarBody
    property bool visible: true

    // image settings
    property string smallImageSourceBottom
    property string smallImageSourceTop
    property real smallImageScaleZoomedIn: 1.0
    property real smallImageScaleZoomedOut: 1.0
    property string mediumImageSourceBottom
    property string mediumImageSourceTop

    // orbit visualization
    property color orbitColor
    property real orbitCorrectionFactorX: 1.0
    property real orbitCorrectionFactorY: 1.0

    // -----------------------------------------------------------------------
    // detailed information

    property real axialTilt // degrees
    property real rotationPeriod // days
    property int satelliteCount
    property real radius // km
    property real volume // km³
    property real mass // kg
    property real surface // km²
    property real density: mass / volume // kg / km³
    property real surfaceGravity: (6.67384e-11 * mass) / Math.pow(radius * 1000, 2) // m / s²
    property real escapeVelocity: Math.sqrt((2 * 6.67e-11 * mass) / (radius * 1000)) // m / s
    property int averageTemperature // K
    property real pressure // Pa
}
