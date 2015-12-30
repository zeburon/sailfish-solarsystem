import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool active: status === Cover.Active
    property bool initialized: false
    property SolarSystem solarSystem: topView.solarSystem

    // -----------------------------------------------------------------------

    function init()
    {
        topView.init();
        solarSystem.dateTime.signalValueChanged.connect(updatePlanetDistanceLabel);
        initialized = true;
        update();
    }

    // -----------------------------------------------------------------------

    function update()
    {
        if (!initialized)
            return;

        solarSystem.dateTime.setTodaysDate();
        topView.update(solarSystem.dateTime);
    }

    // -----------------------------------------------------------------------

    function updatePlanetDistanceLabel()
    {
        // check if selected planet is still visible (e.g. dwarf planets are still enabled)
        if (!solarSystem.solarBodies[settings.distancePlanetIdx].visible)
            selectPreviousPlanet();

        var solarBody = solarSystem.solarBodies[settings.distancePlanetIdx];
        var result = topView.solarSystem.getDistanceToEarth(solarBody);
        labelName.text = qsTr("Distance to %1").arg(solarBody.name);
        labelDistance.text = result.toFixed(2) + " AU";
    }

    // -----------------------------------------------------------------------

    function selectPreviousPlanet()
    {
        var bodyIdx = settings.distancePlanetIdx;
        while (bodyIdx > 0)
        {
            --bodyIdx;
            var solarBody = solarSystem.solarBodies[bodyIdx];
            if (bodyIdx !== solarSystem.getIndex(solarSystem.earth) && solarBody.visible && !solarBody.parentSolarBody)
            {
                settings.distancePlanetIdx = bodyIdx;
                updatePlanetDistanceLabel();
                return;
            }
        }
    }

    // -----------------------------------------------------------------------

    function selectNextPlanet()
    {
        var bodyIdx = settings.distancePlanetIdx;
        while (bodyIdx < solarSystem.solarBodies.length - 1)
        {
            ++bodyIdx;
            var solarBody = solarSystem.solarBodies[bodyIdx];
            if (bodyIdx !== solarSystem.getIndex(solarSystem.earth) && solarBody.visible && !solarBody.parentSolarBody)
            {
                settings.distancePlanetIdx = bodyIdx;
                updatePlanetDistanceLabel();
                return;
            }
        }
    }

    // -----------------------------------------------------------------------

    onActiveChanged:
    {
        if (active)
        {
            update();
        }
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

    // cover actions: select planet for distance calculation
    CoverActionList
    {
        CoverAction
        {
            iconSource: "image://theme/icon-l-left"
            onTriggered:
            {
                selectPreviousPlanet();
            }
        }
        CoverAction
        {
            iconSource: "image://theme/icon-l-right"
            onTriggered:
            {
                selectNextPlanet();
            }
        }
    }
}
