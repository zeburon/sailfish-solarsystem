import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool coverActive: status === Cover.Active

    // -----------------------------------------------------------------------

    function refresh()
    {
        var currentDate = new Date(Date.now());
        if (currentDate.getDate() !== solarSystem.date.getDate() || currentDate.getMonth() !== solarSystem.date.getMonth())
        {
            solarSystem.date = currentDate;
            solarSystem.updatePlanetPositions();
        }
        solarSystem.paintOrbits();
        refreshPlanetDistance();
    }

    // -----------------------------------------------------------------------

    function refreshPlanetDistance()
    {
        // check if selected planet is still visible (e.g. dwarf planets are still enabled)
        if (!solarSystem.planetInfos[settings.distancePlanetIdx].visible)
            selectPreviousPlanet();

        var result = solarSystem.getDistanceToEarth(settings.distancePlanetIdx);
        labelName.text = qsTr("Distance to %1").arg(solarSystem.planetInfos[settings.distancePlanetIdx].name);
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
        var planetIdx = settings.distancePlanetIdx;
        while (planetIdx > 0)
        {
            --planetIdx;
            var planetInfo = solarSystem.planetInfos[planetIdx];
            if (planetInfo.useInPlanetDistanceList && planetInfo.visible)
            {
                settings.distancePlanetIdx = planetIdx;
                refreshPlanetDistance();
                break;
            }
        }
    }

    // -----------------------------------------------------------------------

    function selectNextPlanet()
    {
        var planetIdx = settings.distancePlanetIdx;
        while (planetIdx < solarSystem.planetInfos.length - 1)
        {
            ++planetIdx;
            var planetInfo = solarSystem.planetInfos[planetIdx];
            if (planetInfo.useInPlanetDistanceList && planetInfo.visible)
            {
                settings.distancePlanetIdx = planetIdx;
                refreshPlanetDistance();
                break;
            }
        }
    }

    // -----------------------------------------------------------------------

    onCoverActiveChanged:
    {
        if (coverActive)
            refresh();
    }

    // -----------------------------------------------------------------------

    Column
    {
        anchors { fill: parent }
        spacing: 0

        SolarSystem
        {
            id: solarSystem

            width: parent.width
            height: width
            orbitThickness: 2
            showOrbits: settings.showOrbits
            showLabels: false
            showDwarfPlanets: settings.showDwarfPlanets
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
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            opacity: 0.9
        }
    }
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
