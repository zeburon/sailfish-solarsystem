import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page
{
    id: page

    // -----------------------------------------------------------------------

    property SolarSystem solarSystem
    property bool pageActive: status === PageStatus.Active
    property int planetImageSize: column.width / (solarSystem.visiblePlanetCount + 1)

    // -----------------------------------------------------------------------

    signal triggerUpdate()

    // -----------------------------------------------------------------------

    Component
    {
        id: planetImageComponent

        PlanetImage
        {
            width: planetImageSize
            height: planetImageSize
            scale: 1.0
            opacity: 1.0
            showShadowBehindPlanet: false
        }
    }

    Component
    {
        id: planetDistanceComponent

        Item
        {
            property int planetIdx1
            property int planetIdx2
            property bool showDistanceToSun: planetIdx1 === planetIdx2

            function updateDistance()
            {
                var result;
                if (showDistanceToSun)
                    result = solarSystem.getDistanceToSun(planetIdx1);
                else
                    result = solarSystem.getDistanceBetweenPlanets(planetIdx1, planetIdx2);

                planetDistanceText.text = result[0].toFixed(2);
                if (result[1] === 1)
                    planetDistanceText.color = "red";
                else
                    planetDistanceText.color = "green";
            }

            width: planetImageSize
            height: planetImageSize
            visible: solarSystem.planetInfos[planetIdx1].visible && solarSystem.planetInfos[planetIdx2].visible

            Component.onCompleted:
            {
                page.triggerUpdate.connect(updateDistance);
            }

            Rectangle
            {
                id: planetDistanceBackground

                anchors { fill: parent }
                radius: width / 2
                color: "#ffdd00"
                visible: showDistanceToSun
                opacity: 0.15 * (1.0 - (planetIdx1 / (solarSystem.visiblePlanetCount - 1)) * 0.75)
            }

            Text
            {
                id: planetDistanceText

                anchors { centerIn: parent }
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny; bold: showDistanceToSun }
            }
        }
    }

    Column
    {
        id: column

        anchors { fill: parent; margins: Theme.paddingSmall }
        spacing: Theme.paddingMedium

        PageHeader
        {
            title: qsTr("Planet Distances")
        }
        DateDisplay
        {
            width: column.width

            Component.onCompleted:
            {
                dateSelected.connect(page.triggerUpdate);
            }
        }
        Grid
        {
            id: grid

            width: parent.width
            columns: solarSystem.visiblePlanetCount + 1
            spacing: 0

            Sun
            {
                width: planetImageSize
                height: planetImageSize
                animated: pageActive
            }

            Component.onCompleted:
            {
                var planetCount = solarSystem.planetInfos.length;

                for (var headerIdx = 0; headerIdx < planetCount; ++headerIdx)
                {
                    planetImageComponent.createObject(grid, {"planetInfo": solarSystem.planetInfos[headerIdx], "shadowRotation": 0});
                }

                for (var planetIdx = 0; planetIdx < planetCount; ++planetIdx)
                {
                    planetImageComponent.createObject(grid, {"planetInfo": solarSystem.planetInfos[planetIdx], "shadowRotation": 90});
                    for (var otherPlanetIdx = 0; otherPlanetIdx < planetCount; ++otherPlanetIdx)
                    {
                        planetDistanceComponent.createObject(grid, {"planetIdx1": planetIdx, "planetIdx2": otherPlanetIdx});
                    }
                }
            }
        }
        Text
        {
            width: parent.width
            text: qsTr("All distances are in astronomical units (AU).\n1 AU is roughly the distance from earth to sun, or about 150 million kilometers.")
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeSmall }
            wrapMode: Text.WordWrap
        }
        Text
        {
            width: parent.width
            text: qsTr("red number: distance is increasing\ngreen number: distance is decreasing")
            color: Theme.secondaryHighlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
            wrapMode: Text.WordWrap
        }
    }
}
