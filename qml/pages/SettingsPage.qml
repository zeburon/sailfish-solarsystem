import QtQuick 2.0
import QtPositioning 5.2
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    function init()
    {
        if (settings.coverName === "riseSet")
        coverContentComboBox.currentIndex = 1;

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
            // cover content
            ComboBox
            {
                id: coverContentComboBox

                label: qsTr("Cover content")
                menu: ContextMenu
                {
                    MenuItem
                    {
                        text: qsTr("planet distances")
                        onClicked:
                        {
                            settings.coverName = "distances";
                        }
                    }
                    MenuItem
                    {
                        text: qsTr("rise & set times")
                        onClicked:
                        {
                            settings.coverName = "riseSet";
                        }
                    }
                }
            }

            /*
            SectionHeader
            {
                text: qsTr("Formats and Units")
            }
            */

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
                text: qsTr("Position")

                BusyIndicator
                {
                    anchors { centerIn: parent }
                    size: BusyIndicatorSize.Small
                    running: fetchPositionTimer.running
                }
                Text
                {
                    id: fetchPositionResultText

                    anchors { centerIn: parent }
                    color: Theme.secondaryHighlightColor
                    font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
                    opacity: fetchPositionResultTimer.running ? 1 : 0

                    Behavior on opacity
                    {
                        NumberAnimation { easing.type: Easing.InOutQuart; duration: 500 }
                    }
                }
                Timer
                {
                    id: fetchPositionResultTimer

                    repeat: false
                    interval: 2000
                }
            }

            Button
            {
                anchors { horizontalCenter: parent.horizontalCenter }
                text: qsTr("Use current location")
                width: parent.width * 0.8
                enabled: !fetchPositionTimer.running
                onClicked:
                {
                    fetchPositionTimer.start();
                }
            }

            PositionSource
            {
                id: positionSource

                updateInterval: 1000
                active: fetchPositionTimer.running
                preferredPositioningMethods: PositionSource.SatellitePositioningMethods
                onPositionChanged:
                {
                    if (position.latitudeValid && position.longitudeValid)
                    {
                        var currentTime = new Date(Date.now());
                        // do not reuse old coordinates (first value always contains ancient coordinates)
                        if (currentTime - position.timestamp < Globals.POSITION_VALID_INTERVAL_MS)
                        {
                            textFieldLatitude.text  = position.coordinate.latitude;
                            textFieldLongitude.text = position.coordinate.longitude;
                            fetchPositionTimer.stop();
                            fetchPositionResultText.text = qsTr("Coordinates updated");
                            fetchPositionResultTimer.start();
                        }
                    }
                }
            }
            Timer
            {
                id: fetchPositionTimer

                repeat: false
                interval: Globals.FETCH_POSITION_INTERVAL_MS
                onTriggered:
                {
                    fetchPositionResultText.text = qsTr("Failed to update coordinates");
                    fetchPositionResultTimer.start();
                }
            }

            TextField
            {
                id: textFieldLatitude

                width: parent.width
                enabled: !fetchPositionTimer.running
                opacity: enabled ? 1.0 : 0.5
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
                id: textFieldLongitude

                width: parent.width
                enabled: !fetchPositionTimer.running
                opacity: enabled ? 1.0 : 0.5
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
