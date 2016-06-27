import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    function init()
    {
        var dateFormatIdx = Globals.DATE_FORMATS.indexOf(settings.dateFormat);
        dateFormatComboBox.currentIndex = dateFormatIdx;

        var pressureUnitIdx = Globals.PRESSURE_UNITS.indexOf(settings.pressureUnit);
        pressureUnitComboBox.currentIndex = pressureUnitIdx;

        var temperatureUnitIdx = Globals.TEMPERATURE_UNITS.indexOf(settings.temperatureUnit);
        temperatureUnitComboBox.currentIndex = temperatureUnitIdx;
    }

    // -----------------------------------------------------------------------

    SilicaFlickable
    {
        anchors { fill: parent }
        contentHeight: column.height

        VerticalScrollDecorator {}
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

            // -----------------------------------------------------------------------

            SectionHeader
            {
                text: qsTr("General Options")
            }

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
                text: qsTr("Show Pluto")
                checked: settings.showDwarfPlanets
                onCheckedChanged:
                {
                    settings.showDwarfPlanets = checked;
                }
            }

            // -----------------------------------------------------------------------

            SectionHeader
            {
                text: qsTr("Sky View")
            }

            TextField
            {
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("Latitude in degrees")
                labelVisible: true
                placeholderText: "Type latitude here"
                text: settings.latitude
                onTextChanged:
                {
                    settings.latitude = (text != "" ? text : 0.0);
                }
            }
            TextField
            {
                width: parent.width
                inputMethodHints: Qt.ImhFormattedNumbersOnly
                label: qsTr("Longitude in degrees")
                labelVisible: true
                placeholderText: "Type longitude here"
                text: settings.longitude
                onTextChanged:
                {
                    settings.longitude = (text != "" ? text : 0.0);
                }
            }
        }
    }
}
