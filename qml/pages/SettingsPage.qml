import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../calculation.js" as Calculation
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    function refresh()
    {
        orbitStyleComboBox.currentIndex = settings.simplifiedOrbits ? 0 : 1;

        var dateFormatIdx = Globals.DATE_FORMATS.indexOf(settings.dateFormat);
        dateFormatComboBox.currentIndex = dateFormatIdx;

        var pressureUnitIdx = Globals.PRESSURE_UNITS.indexOf(settings.pressureUnit);
        pressureUnitComboBox.currentIndex = pressureUnitIdx;

        var temperatureUnitIdx = Globals.TEMPERATURE_UNITS.indexOf(settings.temperatureUnit);
        temperatureUnitComboBox.currentIndex = temperatureUnitIdx;
    }

    // -----------------------------------------------------------------------

    Column
    {
        id: column

        width: page.width
        spacing: 0

        PageHeader
        {
            title: qsTr("Settings")
        }

        SectionHeader
        {
            text: qsTr("Formats and Units")
        }

        // date format
        ComboBox
        {
            id: dateFormatComboBox

            label: qsTr("Date format")
            menu: ContextMenu
            {
                Repeater
                {
                    model: Globals.DATE_FORMATS.length

                    MenuItem
                    {
                        text: Globals.DATE_FORMATS[index]
                        onClicked:
                        {
                            settings.dateFormat = text;
                        }
                    }
                }
            }
        }

        // pressure unit
        ComboBox
        {
            id: pressureUnitComboBox

            label: qsTr("Pressure unit")
            menu: ContextMenu
            {
                Repeater
                {
                    model: Globals.PRESSURE_UNITS.length

                    MenuItem
                    {
                        text: Globals.PRESSURE_UNITS[index]
                        onClicked:
                        {
                            settings.pressureUnit = text;
                        }
                    }
                }
            }
        }

        // pressure unit
        ComboBox
        {
            id: temperatureUnitComboBox

            label: qsTr("Temperature unit")
            menu: ContextMenu
            {
                Repeater
                {
                    model: Globals.TEMPERATURE_UNITS.length

                    MenuItem
                    {
                        text: Globals.TEMPERATURE_UNITS[index]
                        onClicked:
                        {
                            settings.temperatureUnit = text;
                        }
                    }
                }
            }
        }

        SectionHeader
        {
            text: qsTr("Display Mode")
        }

        // orbit style: simplified or realistic
        ComboBox
        {
            id: orbitStyleComboBox

            label: qsTr("Style")
            menu: ContextMenu
            {
                MenuItem
                {
                    text: qsTr("simplified")
                    onClicked:
                    {
                        settings.simplifiedOrbits = true;
                    }
                }
                MenuItem
                {
                    text: qsTr("realistic")
                    onClicked:
                    {
                        settings.simplifiedOrbits = false;
                    }
                }
            }
            description:
            {
                if (currentIndex === 0)
                    return qsTr("Orbits are depicted as regular circles.");
                else
                    return qsTr("Orbits are drawn to scale.");
            }
        }

        // optional information
        TextSwitch
        {
            text: qsTr("Show planet names")
            checked: settings.showLabels
            onCheckedChanged:
            {
                settings.showLabels = checked;
            }
        }
        TextSwitch
        {
            text: qsTr("Show planet orbits")
            checked: settings.showOrbits
            onCheckedChanged:
            {
                settings.showOrbits = checked;
            }
        }

        // pluto settings
        TextSwitch
        {
            text: qsTr("Show Pluto")
            checked: settings.showDwarfPlanets
            onCheckedChanged:
            {
                settings.showDwarfPlanets = checked;
            }
        }
        TextSwitch
        {
            text: qsTr("Show inclination of Pluto")
            description: qsTr("Display distance to ecliptic via y-axis.")
            checked: settings.showZPosition
            enabled: !settings.simplifiedOrbits && settings.showDwarfPlanets
            onCheckedChanged:
            {
                settings.showZPosition = checked;
            }
        }
    }
}
