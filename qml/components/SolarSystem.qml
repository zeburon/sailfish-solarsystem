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
            a1: 0.38709843; a2: 0.00000000
            e1: 0.20563661; e2: 0.00002123
            i1: 7.00559432; i2: -0.00590158
            l1: 252.25166724; l2: 149472.67486623
            w1: 77.45771895; w2: 0.15940013
            o1: 48.33961819; o2: -0.12214182
        },
        PlanetInfo
        {
            id: venus

            name: qsTr("Venus")
            imageSource: "../gfx/venus.png"
            imageZoomedOutScale: 0.1
            orbitColor: "#e8bb79"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 1
            a1: 0.72332102; a2: -0.00000026
            e1: 0.00676399; e2: -0.00005107
            i1: 3.39777545; i2: 0.00043494
            l1: 181.97970850; l2: 58517.81560260
            w1: 131.76755713; w2: 0.05679648
            o1: 76.67261496; o2: -0.27274174
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
            a1: 1.00000018; a2: -0.00000003
            e1: 0.01673163; e2: -0.00003661
            i1: -0.00054346; i2: -0.01337178
            l1: 100.46691572; l2: 35999.37306329
            w1: 102.93005885; w2: 0.31795260
            o1: -5.11260389; o2: -0.24123856
        },
        PlanetInfo
        {
            id: mars

            name: qsTr("Mars")
            imageSource: "../gfx/mars.png"
            imageZoomedOutScale: 0.3
            orbitColor: "#e58e5c"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 3
            a1: 1.52371243; a2: 0.00000097
            e1: 0.09336511; e2: 0.00009149
            i1: 1.85181869; i2: -0.00724757
            l1: -4.56813164; l2: 19140.29934243
            w1: -23.91744784;  w2: 0.45223625
            o1: 49.71320984; o2: -0.26852431
        },
        PlanetInfo
        {
            id: jupiter

            name: qsTr("Jupiter")
            imageSource: "../gfx/jupiter.png"
            orbitColor: "#e4d6cd"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 4
            a1: 5.20248019; a2: -0.00002864
            e1: 0.04853590; e2: 0.00018026
            i1: 1.29861416; i2: -0.00322699
            l1: 34.33479152; l2: 3034.90371757; b: -0.00012452; c: 0.06064060; s: -0.35635438; f: 38.35125000
            w1: 14.27495244; w2: 0.18199196
            o1: 100.29282654; o2: 0.13024619
        },
        PlanetInfo
        {
            id: saturn

            name: qsTr("Saturn")
            imageSource: "../gfx/saturn.png"
            orbitColor: "#e3c9a3"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 5
            a1: 9.54149883; a2: -0.00003065
            e1: 0.05550825; e2: -0.00032044
            i1: 2.49424102; i2: 0.00451969
            l1: 50.07571329; l2: 1222.11494724; b: 0.00025899; c: 0.13434469; s: 0.87320147; f: 38.35125000
            w1: 92.86136063; w2: 0.54179478
            o1: 113.63998702; o2: -0.25015002
        },
        PlanetInfo
        {
            id: uranus

            name: qsTr("Uranus")
            imageSource: "../gfx/uranus.png"
            orbitColor: "#c2e5eb"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 6
            a1: 19.18797948; a2: -0.00020455
            e1: 0.04685740; e2: -0.00001550
            i1: 0.77298127; i2: -0.00180155
            l1: 314.20276625; l2: 428.49512595; b: 0.00058331; c: -0.97731848; s: 0.17689245; f: 7.67025000
            w1: 172.43404441; w2: 0.09266985
            o1: 73.96250215; o2: 0.05739699
        },
        PlanetInfo
        {
            id: neptune

            name: qsTr("Neptune")
            imageSource: "../gfx/neptune.png"
            orbitColor: "#73a7fe"
            orbitSimplifiedRadius: radiusSunOffset + radiusIncrement * 7
            a1: 30.06952752; a2: 0.00006447
            e1: 0.00895439; e2: 0.00000818
            i1: 1.77005520; i2: 0.00022400
            l1: 304.22289287; l2: 218.46515314; b: -0.00041348; c: 0.68346318; s: -0.10162547; f: 7.67025000
            w1: 46.68158724; w2: 0.01009938
            o1: 131.78635853; o2: -0.00606302
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
