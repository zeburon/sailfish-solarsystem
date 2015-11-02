import QtQuick 2.0

QtObject
{
    property string name
    property real raHours
    property real raMinutes
    property real raDegrees: 360 - 15 * (raHours + raMinutes / 60)
    property real declination
    property real magnitude
}
