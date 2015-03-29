/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

CoverBackground
{
    id: cover

    property bool coverActive: status === Cover.Active

    // -----------------------------------------------------------------------

    function refresh()
    {
        var currentDate = new Date(Date.now());
        if (currentDate.getDate() != solarSystem.date.getDate() || currentDate.getMonth() != solarSystem.date.getMonth())
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
            labelDirection.color = "red";
        }
        // distance is decreasing
        else
        {
            labelDirection.text = "↓";
            labelDirection.color = "green";
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
        {
            refresh();
        }
    }

    Column
    {
        anchors.fill: parent
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
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeTiny
        }
        Label
        {
            id: labelDistance

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeSmall
        }
        Label
        {
            id: labelDirection

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeMedium
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
