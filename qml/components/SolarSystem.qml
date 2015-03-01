import QtQuick 2.0
import Sailfish.Silica 1.0

import "../calculation.js" as Calculation

Item
{
    id: root

    property date date
    property int animationIncrement: 5
    property bool simplifiedOrbits: true
    property bool zoomedOut: false
    property bool showLabels: true
    property bool showOrbits: true
    property bool animateSun: true
    property real imageOpacity: 1.0
    property real imageScale: 1.0
    property int orbitThickness: 3

    property real radiusSunOffset: Math.max(40, Math.min(width, height) / 20) * imageScale
    property real radiusBorderOffset: 15
    property real radiusRange: Math.min(width / 2, height / 2) - radiusBorderOffset - radiusSunOffset
    property real radiusIncrement: radiusRange / 7
    property real au: earth.orbitSimplifiedRadius

    property real currentZoom: simplifiedOrbits ? 1.0 : currentZoomRealistic
    property real currentZoomRealistic: zoomedOut ? 0.08 : 1.0
    property bool animateZoom: false

    property list<PlanetInfo> planetInfos:
    [
        PlanetInfo
        {
            id: mercury

            name: qsTr("Mercury")
            imageSource: "../gfx/mercury.png"
            imageZoomedOutScale: 0.0
            orbitColor: "#8d8d8d"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 0
            o1: 48.33076593; o2: -0.12534081
            i1: 7.00497902; i2: -0.00594749
            w1: 77.45779628; w2: 0.16047689
            a1: 0.38709927; a2: 0.00000037
            e1: 0.20563593; e2: 0.00001906
            l1: 252.25032350; l2: 149472.67411175
        },
        PlanetInfo
        {
            id: venus

            name: qsTr("Venus")
            imageSource: "../gfx/venus.png"
            imageZoomedOutScale: 0.1
            orbitColor: "#e8bb79"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 1
            o1: 76.67984255; o2: -0.27769418
            i1: 3.39467605; i2: -0.00078890
            w1: 131.60246718; w2: 0.00268329
            a1: 0.72333566; a2: 0.00000390
            e1: 0.00677672; e2: -0.00004107
            l1: 181.97909950; l2: 58517.81538729
        },
        PlanetInfo
        {
            id: earth

            name: qsTr("Earth")
            imageSource: "../gfx/earth.png"
            imageZoomedOutScale: 0.2
            useInPlanetDistanceList: false
            orbitColor: "#ffffff"
            orbitAlpha: 0.55
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 2
            i1: -0.00001531; i2: -0.01294668
            w1: 102.93768193; w2: 0.32327364
            a1: 1.00000261; a2: 0.00000562
            e1: 0.01671123; e2: -0.00004392
            l1: 100.46457166; l2: 35999.37244981
        },
        PlanetInfo
        {
            id: mars

            name: qsTr("Mars")
            imageSource: "../gfx/mars.png"
            imageZoomedOutScale: 0.3
            orbitColor: "#e58e5c"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 3
            o1: 49.55953891; o2: -0.29257343
            i1: 1.84969142; i2: -0.00813131
            w1: -23.94362959;  w2: 0.44441088
            a1: 1.52371034; a2: 0.00001847
            e1: 0.09339410; e2: 0.00007882
            l1: -4.55343205; l2: 19140.30268499
        },
        PlanetInfo
        {
            id: jupiter

            name: qsTr("Jupiter")
            imageSource: "../gfx/jupiter.png"
            orbitColor: "#e4d6cd"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 4
            o1: 100.47390909; o2: 0.20469106
            i1: 1.30439695; i2: -0.00183714
            w1: 14.72847983; w2: 0.21252668
            a1: 5.20288700; a2: -0.00011607
            e1: 0.04838624; e2: -0.00013253
            l1: 34.39644051; l2: 3034.74612775
        },
        PlanetInfo
        {
            id: saturn

            name: qsTr("Saturn")
            imageSource: "../gfx/saturn.png"
            orbitColor: "#e3c9a3"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 5
            o1: 113.66242448; o2: -0.28867794
            i1: 2.48599187; i2: 0.00193609
            w1: 92.59887831; w2: -0.41897216
            a1: 9.53667594; a2: -0.00125060
            e1: 0.05386179; e2: -0.00050991
            l1: 49.95424423; l2: 1222.49362201
        },
        PlanetInfo
        {
            id: uranus

            name: qsTr("Uranus")
            imageSource: "../gfx/uranus.png"
            orbitColor: "#c2e5eb"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 6
            o1: 74.01692503; o2: 0.04240589
            i1: 0.77263783; i2: -0.00242939
            w1: 170.95427630; w2: 0.40805281
            a1: 19.18916464; a2: -0.00196176
            e1: 0.04725744; e2: -0.00004397
            l1: 313.23810451; l2: 428.48202785
        },
        PlanetInfo
        {
            id: neptune

            name: qsTr("Neptune")
            imageSource: "../gfx/neptune.png"
            orbitColor: "#73a7fe"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 7
            o1: 131.78422574; o2: -0.00508664
            i1: 1.77004347; i2: 0.00035372
            w1: 44.96476227; w2: -0.32241464
            a1: 30.06992276; a2: 0.00026291
            e1: 0.00859048; e2: 0.00005105
            l1: -55.12002969; l2: 218.45945325
        }
    ]

    signal clicked()

    function update()
    {
        Calculation.setOrbitParameters(au, simplifiedOrbits);
        Calculation.setDate(date);
        for (var planetIdx = 0; planetIdx < planetInfos.length; ++planetIdx)
        {
            Calculation.updatePlanetPosition(planetInfos[planetIdx]);
        }
    }

    function paintOrbits()
    {
        orbits.requestPaint();
    }

    function getDistanceToEarth(planetIdx)
    {
        var result = [0, 0];
        if (planetIdx >= 0 && planetIdx < planetInfos.length)
        {
            var lastDate = new Date(date);
            lastDate.setDate(lastDate.getDate() - 1);
            Calculation.setDate(lastDate)
            var lastDistance = Calculation.getDistanceBetweenPlanets(planetInfos[planetIdx], earth);
            Calculation.setDate(date);
            var currentDistance = Calculation.getDistanceBetweenPlanets(planetInfos[planetIdx], earth);
            result[0] = currentDistance;
            if (currentDistance > lastDistance)
                result[1] = 1;
            else
                result[1] = -1;
        }
        return result;
    }

    clip: true

    Component.onCompleted:
    {
        for (var planetIdx = 0; planetIdx < planetInfos.length; ++planetIdx)
        {
            var planetInfo = planetInfos[planetInfos.length - planetIdx - 1];
            var planetImage = planetImageComponent.createObject(images, {"planetInfo": planetInfo});
            var planetLabel = planetLabelComponent.createObject(labels, {"planetInfo": planetInfo, "yOffset": planetImage.size});
        }
    }
    onDateChanged:
    {
        update();
    }
    onSimplifiedOrbitsChanged:
    {
        update();
        paintOrbits();
    }

    Component
    {
        id: planetImageComponent

        PlanetImage
        {
        }
    }
    Component
    {
        id: planetLabelComponent

        PlanetLabel
        {
        }
    }
    MouseArea
    {
        anchors.fill: parent
        onClicked:
        {
            root.clicked();
        }
    }
    Sun
    {
        id: sun

        scale: imageScale * currentZoom
        animated: animateSun
        opacity: imageOpacity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 0
    }
    PlanetOrbits
    {
        id: orbits

        zoom: root.currentZoom
        planetInfos: root.planetInfos
        lineThickness: orbitThickness
        visible: showOrbits
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.fill: parent
        z: 1
    }
    Item
    {
        id: images

        opacity: imageOpacity
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 2
    }
    Item
    {
        id: labels

        visible: showLabels
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        z: 3
    }
    Behavior on currentZoomRealistic
    {
        enabled: animateZoom
        NumberAnimation { easing.type: Easing.InOutQuart; duration: 1000 }
    }
}
