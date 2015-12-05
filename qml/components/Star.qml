import QtQuick 2.0

QtObject
{
    property string name
    property real rightAscensionHours
    property real rightAscensionMinutes
    property real rightAscensionDegrees: 360 - 15 * (rightAscensionHours + rightAscensionMinutes / 60)
    property real declination
    property real magnitude

    property real displayedSize
}
