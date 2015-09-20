import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property SolarSystem solarSystem
    property bool pageActive: status === PageStatus.Active
    property var planetDistanceItems: []

    // properties used by PlanetImage items
    property int planetImageSize: column.width / (visiblePlanetCount + 1)

    // -----------------------------------------------------------------------

    signal updated()

    // -----------------------------------------------------------------------

    function updateDistances()
    {
        solarSystem.prepareDistanceCoordinates();
        for (var idx = 0; idx < planetDistanceItems.length; ++idx)
        {
            planetDistanceItems[idx].update();
        }
        updated();
    }

    // -----------------------------------------------------------------------

    onVisibleChanged:
    {
        if (visible)
        {
            updateDistances();
        }
    }

    // -----------------------------------------------------------------------

    // image used by horizontal & vertical headers
    Component
    {
        id: planetImageComponent

        PlanetImage
        {
            width: planetImageSize
            height: planetImageSize
            showShadowBehindPlanet: false
        }
    }
    // distance label
    Component
    {
        id: planetDistanceComponent

        Item
        {
            property int planetIdxX
            property int planetIdxY
            property bool showDistanceToSun: planetIdxX === planetIdxY

            function update()
            {
                // fetch distance value
                var result;
                if (showDistanceToSun)
                    result = solarSystem.getDistanceToSun(planetIdxX);
                else
                    result = solarSystem.getDistanceBetweenPlanets(planetIdxX, planetIdxY);

                // apply new value
                planetDistanceText.text = result[0].toFixed(2);
                if (result[1] === 1)
                    planetDistanceText.color = Globals.DISTANCE_INCREASING_COLOR;
                else
                    planetDistanceText.color = Globals.DISTANCE_DECREASING_COLOR;
            }

            width: planetImageSize
            height: planetImageSize
            visible: planetInfos[planetIdxX].visible && planetInfos[planetIdxY].visible

            // yellow background to highlight distance to sun fields
            Rectangle
            {
                id: planetDistanceBackground

                anchors { fill: parent }
                radius: width / 2
                color: "#ffdd00"
                visible: showDistanceToSun
                opacity: 0.175 * (1.0 - (planetIdxX / (visiblePlanetCount - 1)) * 0.5)
            }

            // distance in AU
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

    // -----------------------------------------------------------------------

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
                dateSelected.connect(page.updateDistances);
            }
        }

        // table displaying distance values. sun is in top-left corner, distance to sun in diagonal
        Grid
        {
            id: grid

            width: parent.width
            columns: visiblePlanetCount + 1
            spacing: 0

            Sun
            {
                width: planetImageSize
                height: planetImageSize
                animated: pageActive
            }

            Component.onCompleted:
            {
                var planetCount = planetInfos.length;

                // horizontal header
                for (var headerIdx = 0; headerIdx < planetCount; ++headerIdx)
                {
                    planetImageComponent.createObject(grid, {"planetInfo": planetInfos[headerIdx], "shadowRotation": 0});
                }

                for (var planetIdxY = 0; planetIdxY < planetCount; ++planetIdxY)
                {
                    // vertical header
                    planetImageComponent.createObject(grid, {"planetInfo": planetInfos[planetIdxY], "shadowRotation": 90});

                    // distance items for planet with index planetIdxY
                    for (var planetIdxX = 0; planetIdxX < planetCount; ++planetIdxX)
                    {
                        var item = planetDistanceComponent.createObject(grid, {"planetIdxX": planetIdxX, "planetIdxY": planetIdxY});
                        planetDistanceItems.push(item);
                    }
                }
            }
        }

        // footer with additional information
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
