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

        while (value >= 10)
        {
            ++exponent;
            value /= 10;
        }
        return value.toFixed(0) + " × 10" + formatAsSuperscript(exponent);
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

    onPageActiveChanged:
    {
        if (pageActive)
        {
            flickable.scrollToTop();
        }
    }

    // -----------------------------------------------------------------------

    SilicaFlickable
    {
        id: flickable

        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        contentHeight: column.height

        Column
        {
            id: column

            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: planetConfig.name

                PlanetImage
                {
                    id: planetImage

                    useSmallImage: false
                    planetConfig: page.planetConfig
                    anchors { left: parent.left; leftMargin: Theme.paddingLarge + totalWidth / 2; verticalCenter: parent.verticalCenter }
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

                                text: "N"
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

                                text: "S"
                                anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom }
                                color: parent.color
                                horizontalAlignment: Text.AlignHCenter
                                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny * 0.75 }
                            }
                        }
                    }
                }
            }

            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Satellites")
                    value: planetConfig.satelliteCount
                    unit: ""
                }
            }

            DetailsHeader
            {
                text: qsTr("Physical characteristics")
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Radius")
                    value: planetConfig.radius.toFixed(0)
                    unit: "km"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Axial Tilt")
                    value: planetConfig.axialTilt.toFixed(2)
                    unit: "°"
                }
                DetailsElement
                {
                    width: parent.width / 3
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
                    width: parent.width / 3
                    title: qsTr("Volume")
                    value: formatExponentialNumber(planetConfig.volume)
                    unit: "km³"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Mass")
                    value: formatExponentialNumber(planetConfig.mass)
                    unit: "kg"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Density")
                    value: formatExponentialNumber(planetConfig.density)
                    unit: "kg/km³"
                }
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Surface")
                    value: formatExponentialNumber(planetConfig.surface)
                    unit: "km²"
                }

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Gravity")
                    value: planetConfig.surfaceGravity.toFixed(2)
                    unit: "m/s²"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Escape Velocity")
                    value: (planetConfig.escapeVelocity / 1000).toFixed(2)
                    unit: "km/s"
                }
            }

            DetailsHeader
            {
                text: qsTr("Orbital characteristics")
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Orb. Period")
                    value: planetConfig.orbitalPeriod.toFixed(2)
                    unit: "a"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Velocity")
                    value: (planetConfig.orbitalVelocity / 1000).toFixed(2)
                    unit: "km/s"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Inclination")
                    value: planetConfig.i1.toFixed(2)
                    unit: "°"
                }
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Eccentricity")
                    value: planetConfig.e1.toFixed(2)
                    unit: ""
                }
            }

            DetailsHeader
            {
                text: qsTr("Distance to sun")
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Average")
                    value: planetConfig.orbitAverageDistance.toFixed(2)
                    unit: "AU"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Minimum")
                    value: planetConfig.orbitPerihelion.toFixed(2)
                    unit: "AU"
                }
                DetailsElement
                {
                    width: parent.width / 3
                    title: qsTr("Maximum")
                    value: planetConfig.orbitAphelion.toFixed(2)
                    unit: "AU"
                }
            }
        }
    }
}
