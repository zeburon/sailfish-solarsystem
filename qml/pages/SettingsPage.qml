import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../calculation.js" as Calculation
import "../globals.js" as Globals

Page
{
    id: page

    function refresh()
    {
        orbitStyleComboBox.currentIndex = settings.simplifiedOrbits ? 0 : 1;
    }

    SilicaFlickable
    {
        anchors.fill: parent
        contentHeight: column.height

        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: qsTr("Settings")
            }
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
            Item
            {
                width: 1
                height: Theme.paddingLarge * 2
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
                text: qsTr("Show planet orbits")
                checked: settings.showOrbits
                onCheckedChanged:
                {
                    settings.showOrbits = checked;
                }
            }
            Item
            {
                width: 1
                height: Theme.paddingLarge * 2
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
            TextSwitch
            {
                text: qsTr("Show inclination of Pluto")
                description: qsTr("Display offset to Earth's ecliptic orbital plane.")
                checked: settings.showZPosition
                enabled: !settings.simplifiedOrbits && settings.showDwarfPlanets
                onCheckedChanged:
                {
                    settings.showZPosition = checked;
                }
            }
        }
    }
}
