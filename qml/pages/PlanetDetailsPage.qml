import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool pageActive: status === PageStatus.Active
    property PlanetConfig planetConfig

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
            title: planetConfig.name
        }

        PlanetImage
        {
            id: planetImage

            useSmallImage: false
            planetConfig: page.planetConfig
            anchors { left: parent.left; leftMargin: 75; top: parent.top; topMargin: 75 }
            showShadowBehindPlanet: false
            shadowRotation: 180

            Item
            {
                id: axialTiltInfo

                anchors { centerIn: parent }
                rotation: planetConfig.axialTilt
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
                value: planetConfig.radius.toFixed(0)
                unit: "km"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Axial Tilt")
                value: planetConfig.axialTilt.toFixed(2)
                unit: "°"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Rot. Period")
                value: planetConfig.rotationPeriod.toFixed(2)
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
                value: formatExponentialNumber(planetConfig.volume)
                unit: "km³"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Mass")
                value: formatExponentialNumber(planetConfig.mass)
                unit: "kg"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Density")
                value: (planetConfig.density / 1000000000).toFixed(0)
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
                value: formatExponentialNumber(planetConfig.surface)
                unit: "km²"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Gravity")
                value: planetConfig.surfaceGravity.toFixed(2)
                unit: "m/s²"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Escape Velocity")
                value: (planetConfig.escapeVelocity / 1000).toFixed(2)
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
                value: planetConfig.satelliteCount
                unit: ""
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Temperature")
                value:
                {
                    if (settings.temperatureUnit === "°C")
                        return "~ " + (planetConfig.averageTemperature - 273.15).toFixed(0);
                    else
                        return "~ " + planetConfig.averageTemperature.toFixed(0);
                }
                unit: settings.temperatureUnit
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Pressure")
                value:
                {
                    if (planetConfig.pressure < 0)
                        return qsTr("plenty");
                    else if (planetConfig.pressure < 0.1)
                        return qsTr("trace");
                    else
                    {
                        if (settings.pressureUnit === "bar")
                            return (planetConfig.pressure / 100000).toFixed(2);
                        else
                            return formatExponentialNumber(planetConfig.pressure);
                    }
                }
                unit:
                {
                    if (planetConfig.pressure > 0.1)
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
                value: planetConfig.orbitalPeriod.toFixed(2)
                unit: "a"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Velocity")
                value: (planetConfig.orbitalVelocity / 1000).toFixed(2)
                unit: "km/s"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Inclination")
                value: planetConfig.i1.toFixed(2)
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
                value: planetConfig.orbitAverageDistance.toFixed(2)
                unit: "AU"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Minimum")
                value: planetConfig.orbitPerihelion.toFixed(2)
                unit: "AU"
            }
            DetailsElement
            {
                width: parent.width * 0.35
                title: qsTr("Maximum")
                value: planetConfig.orbitAphelion.toFixed(2)
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
            model: planetConfigs.length
            delegate: Item {
                property PlanetConfig planetConfig: planetConfigs[index]
                property real sizePercent: Math.sqrt(planetConfig.radius / jupiter.radius)
                property bool isDisplayed: planetConfig === page.planetConfig

                width: planetComparisonRow.width / visiblePlanetCount
                height: planetComparisonRow.height
                visible: planetConfig.visible

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
                        page.planetConfig = planetConfig;
                    }
                }
            }
        }
    }
}
