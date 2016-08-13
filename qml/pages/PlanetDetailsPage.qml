import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool active: status === PageStatus.Active
    property SolarSystem solarSystem
    property SolarBody solarBody
    property SolarBody earth: solarSystem.earth
    property bool isSun: solarBody === solarSystem.sun
    property bool compareToEarth: settings.compareToEarth
    readonly property real zeroKelvinInDegrees: -273.15

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
        else if (value > 0)
        {
            while (value < 1)
            {
                --exponent;
                value *= 10;
            }
            return value.toFixed(0) + " × 10" + formatAsSuperscript(exponent);
        }

        return "0";
    }

    // -----------------------------------------------------------------------

    function formatExponentialNumberIfNecessary(value)
    {
        if (value > 1 && value < 100)
            return value.toFixed(2);

        return formatExponentialNumber(value);
    }

    // -----------------------------------------------------------------------

    function formatScale(value)
    {
        if (value === 1.0)
            return qsTr("identical");
        else if (Math.abs(value) < 0.001)
            return "0 ×";
        else if (Math.abs(value) < 0.01)
            return value.toFixed(3) + " ×";
        else if (Math.abs(value) < 10)
            return value.toFixed(2) + " ×";
        else if (Math.abs(value) < 100)
            return value.toFixed(1) + " ×";
        else
            return value.toFixed(0) + " ×";
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
                case "-": result += "-"; break; // FIXME: "⁻" does not work
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

    SilicaFlickable
    {
        anchors { fill: parent }
        contentHeight: column.height

        Column
        {
            id: column

            anchors { left: parent.left; leftMargin: Theme.paddingSmall; right: parent.right }
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: solarBody.name

                Label
                {
                    anchors { right: parent.right; rightMargin: Theme.paddingLarge; bottom: parent.bottom }
                    text: qsTr("compared to %1").arg(earth.name)
                    visible: compareToEarth
                    color: Theme.secondaryHighlightColor
                    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
                }
            }

            SideSolarBodyImage
            {
                id: planetImage

                useSmallImage: false
                useLargeImage: true
                solarBody: page.solarBody
                anchors { left: parent.left; leftMargin: 75; top: parent.top; topMargin: 75 }
                shadowRotation: 180
                shadowOpacity: isSun ? 0.2 : 1.0
                axialTilt: solarBody.axialTilt
            }

            SectionHeader
            {
                id: physicalCharacteristicsSection

                text: qsTr("Physical characteristics")
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Radius")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.radius / earth.radius);
                        else
                            return solarBody.radius.toFixed(0);
                    }
                    unit: compareToEarth ? "" : "km"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Axial Tilt")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.axialTilt / earth.axialTilt);
                        else
                            return solarBody.axialTilt.toFixed(2);
                    }
                    unit: compareToEarth ? "" : "°"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Rot. Period")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.rotationPeriod / earth.rotationPeriod);
                        else
                            return solarBody.rotationPeriod.toFixed(2);
                    }
                    unit: compareToEarth ? "" : "d"
                }
            }
            Row
            {
                width: parent.width


                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Volume")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.volume / earth.volume);
                        else
                            return formatExponentialNumber(solarBody.volume);
                    }
                    unit: compareToEarth ? "" : "km³"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Mass")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.mass / earth.mass);
                        else
                            return formatExponentialNumber(solarBody.mass);
                    }
                    unit: compareToEarth ? "" : "kg"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Density")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.density / earth.density);
                        else
                            return (solarBody.density / 1000000000).toFixed(0);
                    }
                    unit: compareToEarth ? "" : "kg/m³"
                }
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Surface")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.surface / earth.surface);
                        else
                            return formatExponentialNumber(solarBody.surface)
                    }
                    unit: compareToEarth ? "" : "km²";
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Gravity")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.surfaceGravity / earth.surfaceGravity);
                        else
                            return solarBody.surfaceGravity.toFixed(2);
                    }
                    unit: compareToEarth ? "" : "m/s²"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Escape Velocity")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.escapeVelocity / earth.escapeVelocity);
                        else
                            return (solarBody.escapeVelocity / 1000).toFixed(2);
                    }
                    unit: compareToEarth ? "" : "km/s"
                }
            }
            Row
            {
                width: parent.width

                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Satellites")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.satelliteCount > 99)
                                return qsTr("more");
                            return formatScale(solarBody.satelliteCount / earth.satelliteCount);
                        }
                        else
                        {
                            if (solarBody.satelliteCount > 99)
                                return qsTr("countless");
                            return solarBody.satelliteCount;
                        }
                    }
                    unit: ""
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Temperature")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (settings.temperatureUnit === "°C")
                                return formatScale((solarBody.averageTemperature + zeroKelvinInDegrees) / (earth.averageTemperature + zeroKelvinInDegrees));
                            else
                                return formatScale(solarBody.averageTemperature / earth.averageTemperature);
                        }
                        else
                        {
                            if (settings.temperatureUnit === "°C")
                                return "~ " + (solarBody.averageTemperature + zeroKelvinInDegrees).toFixed(0);
                            else
                                return "~ " + solarBody.averageTemperature.toFixed(0);
                        }
                    }
                    unit: compareToEarth ? "" : settings.temperatureUnit
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Pressure")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.pressure < 0)
                                return qsTr("more");
                            else
                                return formatScale(solarBody.pressure / earth.pressure);
                        }
                        else
                        {
                            if (solarBody.pressure < 0)
                                return qsTr("plenty");
                            else if (solarBody.pressure < 0.1)
                                return qsTr("trace");
                            else if (settings.pressureUnit === "bar")
                                return (solarBody.pressure / 100000).toFixed(2);
                            else
                                return formatExponentialNumber(solarBody.pressure);
                        }
                    }
                    unit:
                    {
                        if (solarBody.pressure > 0.1 && !compareToEarth)
                            return settings.pressureUnit;
                        return "";
                    }
                }
            }

            SectionHeader
            {
                id: orbitalCharacteristicsSection

                text: qsTr("Orbital characteristics")
                opacity: isSun ? 0 : 1
            }
            Row
            {
                width: parent.width
                opacity: orbitalCharacteristicsSection.opacity

                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Orb. Period")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.orbitalElements.period / earth.orbitalElements.period);
                        else
                        {
                            if (solarBody.orbitalElements.period < 0.1)
                                return (solarBody.orbitalElements.period * 365.25).toFixed(2);

                            return solarBody.orbitalElements.period.toFixed(2);
                        }
                    }
                    unit:
                    {
                        if (compareToEarth)
                            return "";
                        if (solarBody.orbitalElements.period < 0.1)
                            return "d";

                        return "a";
                    }
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Velocity")
                    value:
                    {
                        if (compareToEarth)
                            return formatScale(solarBody.orbitalElements.averageVelocity / earth.orbitalElements.averageVelocity);
                        else
                            return (solarBody.orbitalElements.averageVelocity / 1000).toFixed(2);
                    }
                    unit: compareToEarth ? "" : "km/s"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Inclination")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.orbitalElements.inclination === earth.orbitalElements.inclination)
                                return formatScale(1.0);
                            else
                            {
                                var diff = solarBody.orbitalElements.inclination * 180 / Math.PI;
                                if (diff > 0.0)
                                    return "+" + diff.toFixed(2);
                                else
                                    diff.toFixed(2);
                            }
                        }
                        else if (solarBody.orbitalElements.inclination === earth.orbitalElements.inclination)
                            return qsTr("none");
                        else
                            return (solarBody.orbitalElements.inclination * 180 / Math.PI).toFixed(2);
                    }
                    unit: (compareToEarth || solarBody.orbitalElements.inclination === earth.orbitalElements.inclination) ? "" : "°"
                }
            }

            SectionHeader
            {
                id: distanceSection

                text: qsTr("Distance to ") + ((solarBody.parentSolarBody && !compareToEarth) ? solarBody.parentSolarBody.name : qsTr("Sun"))
                opacity: isSun ? 0 : 1
            }
            Row
            {
                width: parent.width
                opacity: distanceSection.opacity

                DetailsElement
                {
                    width: parent.width * 0.3
                    title: qsTr("Average")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.parentSolarBody)
                                return formatScale(solarBody.parentSolarBody.orbitalElements.averageDistance / earth.orbitalElements.averageDistance);
                            else
                                return formatScale(solarBody.orbitalElements.averageDistance / earth.orbitalElements.averageDistance);
                        }
                        else
                            return formatExponentialNumberIfNecessary(solarBody.orbitalElements.averageDistance);
                    }
                    unit: compareToEarth ? "" : "AU"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Minimum")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.parentSolarBody)
                                return formatScale(solarBody.parentSolarBody.orbitalElements.minimumDistance / earth.orbitalElements.minimumDistance);
                            else
                                return formatScale(solarBody.orbitalElements.minimumDistance / earth.orbitalElements.minimumDistance);
                        }
                        else
                            return formatExponentialNumberIfNecessary(solarBody.orbitalElements.minimumDistance);
                    }
                    unit: compareToEarth ? "" : "AU"
                }
                DetailsElement
                {
                    width: parent.width * 0.35
                    title: qsTr("Maximum")
                    value:
                    {
                        if (compareToEarth)
                        {
                            if (solarBody.parentSolarBody)
                                return formatScale(solarBody.parentSolarBody.orbitalElements.maximumDistance / earth.orbitalElements.maximumDistance);
                            else
                                return formatScale(solarBody.orbitalElements.maximumDistance / earth.orbitalElements.maximumDistance);
                        }
                        else
                            return formatExponentialNumberIfNecessary(solarBody.orbitalElements.maximumDistance);
                    }
                    unit: compareToEarth ? "" : "AU"
                }
            }
            Item
            {
                width: 1
                height: Theme.paddingLarge
            }

            Row
            {
                id: planetComparisonRow

                width: parent.width
                height: 100

                Repeater
                {
                    width: parent.width
                    height: parent.height
                    model: solarSystem.solarBodies.length
                    delegate: Item {
                        property SolarBody solarBody: solarSystem.solarBodies[index]
                        property real sizePercent: Math.sqrt(solarBody.radius / solarSystem.jupiter.radius)
                        property bool isDisplayed: solarBody === page.solarBody || solarBody == page.solarBody.parentSolarBody

                        width: planetComparisonRow.width / solarSystem.visiblePlanetCount
                        height: planetComparisonRow.height
                        visible: solarBody.visible && !solarBody.parentSolarBody

                        Rectangle
                        {
                            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.top; verticalCenterOffset: parent.width / 2 }
                            width: parent.width * sizePercent
                            height: width
                            radius: width / 2
                            color: isDisplayed ? Theme.highlightColor : Theme.secondaryHighlightColor
                            opacity: isDisplayed ? 0.75 : 0.15
                        }
                        Label
                        {
                            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                            text:
                            {
                                if (isDisplayed)
                                    return "↔";

                                var distance = solarSystem.getDistanceBetweenBodies(solarBody, page.solarBody);
                                return distance.toFixed(1) + "<sub>" + qsTr("AU") + "</unit>";
                            }
                            color:
                            {
                                if (isDisplayed)
                                    return Theme.highlightColor;
                                else
                                    return Theme.secondaryHighlightColor;
                            }
                            height: contentHeight
                            textFormat: Text.RichText
                            horizontalAlignment: Text.horizontalCenter
                            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
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

        PushUpMenu
        {
            MenuItem
            {
                text: settings.compareToEarth ? qsTr("Show absolute values") : qsTr("Compare with Earth values")
                onClicked:
                {
                    settings.compareToEarth = !settings.compareToEarth;
                }
            }
        }
    }
}
