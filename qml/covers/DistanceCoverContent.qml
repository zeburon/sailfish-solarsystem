import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Item
{
    id: root

    // -----------------------------------------------------------------------

    property int bodyIdx: settings.coverPlanetIdx
    property alias solarSystem: topView.solarSystem

    // -----------------------------------------------------------------------

    function init()
    {
        topView.init();
        update();
    }

    // -----------------------------------------------------------------------

    function update()
    {
        solarSystem.dateTime.setTodaysDate();
        topView.update(solarSystem.dateTime);
        updatePlanetDistanceLabel();
    }

    // -----------------------------------------------------------------------

    function updatePlanetDistanceLabel()
    {
        var solarBody = bodyIdx === -1 ? solarSystem.sun : solarSystem.solarBodies[bodyIdx];
        var result = solarSystem.getDistanceToEarth(solarBody);
        labelName.text     = qsTr("Distance to %1").arg(solarBody.name);
        labelDistance.text = result.toFixed(2) + " AU";
    }

    // -----------------------------------------------------------------------

    onBodyIdxChanged:
    {
        updatePlanetDistanceLabel();
    }

    // -----------------------------------------------------------------------

    Column
    {
        id: column

        anchors { fill: parent }
        spacing: 0

        TopView
        {
            id: topView

            width: column.width
            height: column.width
            orbitThickness: 2
            showOrbits: settings.showOrbits
            showLabels: false
            showDwarfPlanets: settings.showDwarfPlanets
            simplifiedOrbits: true
            animateSun: false
            radiusBorderOffset: Theme.paddingMedium
            imageScale: 0.6
        }
        Label
        {
            id: labelName

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        }
        Label
        {
            id: labelDistance

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
        }
    }
}
