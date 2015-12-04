import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool coverActive: status === Cover.Active
    property SolarSystem solarSystem: topView.solarSystem

    // -----------------------------------------------------------------------

    function init()
    {
        topView.init();
        update();
    }

    // -----------------------------------------------------------------------

    function update()
    {
        // only update planet positions once a day
        /*
        var currentDate = new Date(Date.now());
        if (currentDate.getDate() !== topView.date.getDate() || currentDate.getMonth() !== topView.date.getMonth())
        {
            solarSystem.dateTime.setNow();
            updatePlanetDistanceLabel();
        }
        */
        topView.paintOrbits();
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
        labelDistance.text = result[0].toFixed(2) + " AU";

        // distance is increasing
        if (result[1] === 1)
        {
            labelDirection.text = "↑";
            labelDirection.color = Globals.DISTANCE_INCREASING_COLOR;
        }
        // distance is decreasing
        else
        {
            labelDirection.text = "↓";
            labelDirection.color = Globals.DISTANCE_DECREASING_COLOR;
        }
    }

    // -----------------------------------------------------------------------

    function selectPreviousPlanet()
    {
        var bodyIdx = settings.distancePlanetIdx;
        while (bodyIdx > 0)
        {
            --bodyIdx;
            var solarBody = solarSystem.solarBodies[bodyIdx];
            if (bodyIdx !== solarSystem.getIndex(solarSystem.earth) && solarBody.visible)
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
            if (bodyIdx !== 2 && solarBody.visible)
            {
                settings.distancePlanetIdx = bodyIdx;
                updatePlanetDistanceLabel();
                return;
            }
        }
    }

    // -----------------------------------------------------------------------

    onCoverActiveChanged:
    {
        if (coverActive)
            update();
    }

    // -----------------------------------------------------------------------

    Column
    {
        anchors { fill: parent }
        spacing: 0

        TopView
        {
            id: topView

            width: parent.width
            height: width
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
        Label
        {
            id: labelDirection

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium; bold: true }
            opacity: 0.9
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
