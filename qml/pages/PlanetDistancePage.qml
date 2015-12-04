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

    // properties used by PlanetImage items
    property int solarBodyImageSize: column.width / (solarSystem.visiblePlanetCount + 1)
    property var solarBodyDistanceItems: []

    // -----------------------------------------------------------------------

    function updateDistances()
    {
        for (var idx = 0; idx < solarBodyDistanceItems.length; ++idx)
        {
            solarBodyDistanceItems[idx].update();
        }
    }

    // -----------------------------------------------------------------------

    function showPlanetDetailsPage(solarBody)
    {
        planetDetailsPage.solarBody = solarBody;
        pageStack.push(planetDetailsPage);
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
        id: solarBodyImageComponent

        SideSolarBodyImage
        {
            width: solarBodyImageSize
            height: solarBodyImageSize

            MouseArea
            {
                anchors { fill: parent }
                onClicked:
                {
                    showPlanetDetailsPage(solarBody);
                }
            }
        }
    }
    // distance label
    Component
    {
        id: solarBodyDistanceComponent

        Item
        {
            property SolarBody solarBodyX
            property SolarBody solarBodyY
            property bool showDistanceToSun: solarBodyX === solarBodyY

            function update()
            {
                // fetch distance value
                var result;
                if (showDistanceToSun)
                    result = solarSystem.getDistanceToSun(solarBodyX);
                else
                    result = solarSystem.getDistanceBetweenBodies(solarBodyX, solarBodyY);

                // apply new value
                planetDistanceText.text = result[0].toFixed(2);
                if (result[1] === 1)
                    planetDistanceText.color = Globals.DISTANCE_INCREASING_COLOR;
                else
                    planetDistanceText.color = Globals.DISTANCE_DECREASING_COLOR;
            }

            width: solarBodyImageSize
            height: solarBodyImageSize
            visible: solarBodyX.visible && solarBodyY.visible

            // yellow background to highlight distance to sun fields
            Rectangle
            {
                id: planetDistanceBackground

                anchors { fill: parent }
                radius: width / 2
                color: "#ffdd00"
                visible: showDistanceToSun
                opacity: 0.1
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
            dateTime: solarSystem.dateTime
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
            columns: solarSystem.visiblePlanetCount + 1
            spacing: 0

            Sun
            {
                width: solarBodyImageSize
                height: solarBodyImageSize
                animated: pageActive
            }

            Component.onCompleted:
            {
                // prepare list of planets
                var planetBodies = [];
                for (var bodyIdx = 0; bodyIdx < solarSystem.solarBodies.length; ++bodyIdx)
                {
                    var solarBody = solarSystem.solarBodies[bodyIdx];
                    if (!solarBody.parentSolarBody)
                    {
                        planetBodies.push(solarBody);
                    }
                }
                var planetCount = planetBodies.length;

                // horizontal header
                for (var headerIdx = 0; headerIdx < planetCount; ++headerIdx)
                {
                    solarBodyImageComponent.createObject(grid, {"solarBody": planetBodies[headerIdx], "shadowRotation": 0});
                }

                for (var planetIdxY = 0; planetIdxY < planetCount; ++planetIdxY)
                {
                    // vertical header
                    solarBodyImageComponent.createObject(grid, {"solarBody": planetBodies[planetIdxY], "shadowRotation": 90});

                    // distance items for planet with index planetIdxY
                    for (var planetIdxX = 0; planetIdxX < planetCount; ++planetIdxX)
                    {
                        var item = solarBodyDistanceComponent.createObject(grid, {"solarBodyX": planetBodies[planetIdxX], "solarBodyY": planetBodies[planetIdxY]});
                        solarBodyDistanceItems.push(item);
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
