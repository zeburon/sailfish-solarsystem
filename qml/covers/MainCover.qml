import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

CoverBackground
{
    id: cover

    // -----------------------------------------------------------------------

    property bool active: status === Cover.Active
    property SolarSystem solarSystem: distanceCoverContent.solarSystem

    // -----------------------------------------------------------------------

    function init()
    {
        distanceCoverContent.init();
        riseSetCoverContent.init();
    }

    // -----------------------------------------------------------------------

    function update()
    {
        if (distanceCoverContent.visible)
            distanceCoverContent.update();
        if (riseSetCoverContent.visible)
            riseSetCoverContent.update();
    }

    // -----------------------------------------------------------------------

    function selectPreviousPlanet()
    {
        var bodyIdx = settings.coverPlanetIdx;

        // switch to sun
        if (bodyIdx === 0)
        {
            bodyIdx = -1;
        }
        // switch to previous planet
        else
        {
            while (bodyIdx > 0)
            {
                --bodyIdx;
                var solarBody = solarSystem.solarBodies[bodyIdx];
                if (bodyIdx !== solarSystem.getIndex(solarSystem.earth) && solarBody.visible)
                {
                    break;
                }
            }
        }

        settings.coverPlanetIdx = bodyIdx;
        update();
    }

    // -----------------------------------------------------------------------

    function selectNextPlanet()
    {
        var bodyIdx = settings.coverPlanetIdx;
        if (bodyIdx === -1)
        {
            bodyIdx = 0;
        }
        else
        {
            while (bodyIdx < solarSystem.solarBodies.length - 1)
            {
                ++bodyIdx;
                var solarBody = solarSystem.solarBodies[bodyIdx];
                if (bodyIdx !== solarSystem.getIndex(solarSystem.earth) && solarBody.visible)
                {
                    break;
                }
            }
        }

        settings.coverPlanetIdx = bodyIdx;
        update();
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

    DistanceCoverContent
    {
        id: distanceCoverContent

        anchors { fill: parent }
        visible: cover.active && !riseSetCoverContent.visible
    }
    RiseSetCoverContent
    {
        id: riseSetCoverContent

        anchors { fill: parent }
        visible: cover.active && settings.coverName === "riseSet"
    }

    // -----------------------------------------------------------------------

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
