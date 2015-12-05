import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool active: status === PageStatus.Active
    property SolarBody solarBody
    property SolarSystem solarSystem

    // -----------------------------------------------------------------------

    function formatExponentialNumber(value)
    {
        var exponent = 0;

        if (value >= 1)
        {
            while (value >= 10)
            {
                ++exponent;
                value /= 10;
            }
            return value.toFixed(0) + " × 10" + formatAsSuperscript(exponent);
        }
        else if (value >= 0.01)
        {
            return value.toFixed(2);
        }
        return "0";
    }

    // -----------------------------------------------------------------------

    function formatAsSuperscript(exponent)
    {
        // <sup> tag only makes font smaller...

        var str = exponent.toString();
        var result = "";
        for (var idx = 0; idx < str.length; ++idx)
        {
            switch (str[idx])
            {
                case "0": result += "⁰"; break;
                case "1": result += "¹"; break;
                case "2": result += "²"; break;
                case "3": result += "³"; break;
                case "4": result += "⁴"; break;
                case "5": result += "⁵"; break;
                case "6": result += "⁶"; break;
                case "7": result += "⁷"; break;
                case "8": result += "⁸"; break;
                case "9": result += "⁹"; break;
            }
        }
        return result;
    }

    // -----------------------------------------------------------------------

    Column
    {
        id: column

        anchors { left: parent.left; leftMargin: Theme.paddingSmall; right: parent.right }
        spacing: Theme.paddingSmall

        PageHeader
        {
            title: solarBody.name
        }

        SideSolarBodyImage
        {
            id: planetImage

            useSmallImage: false
            solarBody: page.solarBody
            anchors { left: parent.left; leftMargin: 75; top: parent.top; topMargin: 75 }
            shadowRotation: 180

            Item
            {
                id: axialTiltInfo

                anchors { centerIn: parent }
                rotation: solarBody.axialTilt
                opacity: 0.85

                Rectangle
                {
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top; bottomMargin: planetImage.imageHeight / 2 }
                    width: 2
                    height: 6
                    color: "red"

                    Label
                    {
                        id: northLabel

                        text: qsTr("N")
                        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top }
                        color: parent.color
                        horizontalAlignment: Text.AlignHCenter
                        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny * 0.75 }
                    }
                }

                Rectangle
                {
                    anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom; topMargin: planetImage.imageHeight / 2 }
                    width: 2
                    height: 6
                    color: "green"

                    Label
                    {
                        id: southLabel

                        text: qsTr("S")
                        anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom }
                        color: parent.color
                        horizontalAlignment: Text.AlignHCenter
                        font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny * 0.75 }
                    }
                }
            }
        }

        SectionHeader
        {
            text: qsTr("Physical characteristics")
        }
        Row
        {
            width: parent.width

            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Radius")
                value: solarBody.radius.toFixed(0)
                unit: "km"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Axial Tilt")
                value: solarBody.axialTilt.toFixed(2)
                unit: "°"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Rot. Period")
                value: solarBody.rotationPeriod.toFixed(2)
                unit: "d"
            }
        }
        Row
        {
            width: parent.width


            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Volume")
                value: formatExponentialNumber(solarBody.volume)
                unit: "km³"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Mass")
                value: formatExponentialNumber(solarBody.mass)
                unit: "kg"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Density")
                value: (solarBody.density / 1000000000).toFixed(0)
                unit: "kg/m³"
            }
        }
        Row
        {
            width: parent.width

            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Surface")
                value: formatExponentialNumber(solarBody.surface)
                unit: "km²"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Gravity")
                value: solarBody.surfaceGravity.toFixed(2)
                unit: "m/s²"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Escape Velocity")
                value: (solarBody.escapeVelocity / 1000).toFixed(2)
                unit: "km/s"
            }
        }
        Row
        {
            width: parent.width

            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Satellites")
                value: solarBody.satelliteCount
                unit: ""
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Temperature")
                value:
                {
                    if (settings.temperatureUnit === "°C")
                        return "~ " + (solarBody.averageTemperature - 273.15).toFixed(0);
                    else
                        return "~ " + solarBody.averageTemperature.toFixed(0);
                }
                unit: settings.temperatureUnit
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Pressure")
                value:
                {
                    if (solarBody.pressure < 0)
                        return qsTr("plenty");
                    else if (solarBody.pressure < 0.1)
                        return qsTr("trace");
                    else
                    {
                        if (settings.pressureUnit === "bar")
                            return (solarBody.pressure / 100000).toFixed(2);
                        else
                            return formatExponentialNumber(solarBody.pressure);
                    }
                }
                unit:
                {
                    if (solarBody.pressure > 0.1)
                        return settings.pressureUnit;
                    return "";
                }
            }
        }

        SectionHeader
        {
            text: qsTr("Orbital characteristics")
        }
        Row
        {
            width: parent.width

            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Orb. Period")
                value: solarBody.orbitalElements.period.toFixed(2)
                unit: "a"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Velocity")
                value: (solarBody.orbitalElements.averageVelocity / 1000).toFixed(2)
                unit: "km/s"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Inclination")
                value: (solarBody.orbitalElements.inclination * 180 / Math.PI).toFixed(2)
                unit: "°"
            }
        }

        SectionHeader
        {
            text: qsTr("Distance to sun")
        }
        Row
        {
            width: parent.width

            DetailsElement
            {
                width: parent.width * 0.3
                title: qsTr("Average")
                value: solarBody.orbitalElements.averageDistance.toFixed(2)
                unit: "AU"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Minimum")
                value: solarBody.orbitalElements.minimumDistance.toFixed(2)
                unit: "AU"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Maximum")
                value: solarBody.orbitalElements.maximumDistance.toFixed(2)
                unit: "AU"
            }
        }
    }
    Row
    {
        id: planetComparisonRow

        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; bottomMargin: Theme.paddingLarge }
        height: 50

        Repeater
        {
            width: parent.width
            height: parent.height
            model: solarSystem.solarBodies.length
            delegate: Item {
                property SolarBody solarBody: solarSystem.solarBodies[index]
                property real sizePercent: Math.sqrt(solarBody.radius / solarSystem.jupiter.radius)
                property bool isDisplayed: solarBody === page.solarBody

                width: planetComparisonRow.width / solarSystem.visiblePlanetCount
                height: planetComparisonRow.height
                visible: solarBody.visible && !solarBody.parentSolarBody

                Rectangle
                {
                    anchors { centerIn: parent }
                    width: parent.width * sizePercent
                    height: width
                    radius: width / 2
                    color: isDisplayed ? Theme.highlightColor : Theme.secondaryHighlightColor
                    opacity: isDisplayed ? 0.75 : 0.15
                }
                MouseArea
                {
                    anchors { fill: parent }
                    onClicked:
                    {
                        page.solarBody = solarBody;
                    }
                }
            }
        }
    }
}
