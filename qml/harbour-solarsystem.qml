import QtQuick 2.0
import Sailfish.Silica 1.0

import "cover"
import "pages"
import "components"

ApplicationWindow
{
    id: app

    // -----------------------------------------------------------------------

    property bool active: Qt.application.state === Qt.ApplicationActive
    property bool initialized: false

    // -----------------------------------------------------------------------

    property int realPlanetCount: 0
    property int dwarfPlanetCount: 0
    property int visiblePlanetCount: settings.showDwarfPlanets ? planetConfigs.length : realPlanetCount
    property list<PlanetConfig> planetConfigs:
    [
        PlanetConfig
        {
            id: mercury

            name: qsTr("Mercury")
            smallImageSource: "../gfx/s_mercury.png"
            smallImageScaleZoomedOut: 0.0
            mediumImageSource: "../gfx/m_mercury.png"
            orbitColor: "#668d8d8d"

            a1: 0.38709843; a2: 0.00000000
            e1: 0.20563661; e2: 0.00002123
            i1: 7.00559432; i2: -0.00590158
            l1: 252.25166724; l2: 149472.67486623
            w1: 77.45771895; w2: 0.15940013
            o1: 48.33961819; o2: -0.12214182

            axialTilt: 0.027
            rotationPeriod: 58.646
            satelliteCount: 0
            radius: 2439.7
            volume: 6.083e10
            mass: 3.3011e23
            surface: 7.48e7
        },
        PlanetConfig
        {
            id: venus

            name: qsTr("Venus")
            smallImageSource: "../gfx/s_venus.png"
            smallImageScaleZoomedOut: 0.1
            mediumImageSource: "../gfx/m_venus.png"
            orbitColor: "#66e8bb79"

            a1: 0.72332102; a2: -0.00000026
            e1: 0.00676399; e2: -0.00005107
            i1: 3.39777545; i2: 0.00043494
            l1: 181.97970850; l2: 58517.81560260
            w1: 131.76755713; w2: 0.05679648
            o1: 76.67261496; o2: -0.27274174

            axialTilt: 177.36
            rotationPeriod: -243.025
            satelliteCount: 0
            radius: 6051.8
            volume: 9.2843e11
            mass: 4.8675e24
            surface: 4.6e8
        },
        PlanetConfig
        {
            id: earth

            name: qsTr("Earth")
            smallImageSource: "../gfx/s_earth.png"
            smallImageScaleZoomedOut: 0.2
            mediumImageSource: "../gfx/m_earth.png"
            orbitColor: "#8cffffff"

            a1: 1.00000018; a2: -0.00000003
            e1: 0.01673163; e2: -0.00003661
            i1: -0.00054346; i2: -0.01337178
            l1: 100.46691572; l2: 35999.37306329
            w1: 102.93005885; w2: 0.31795260
            o1: -5.11260389; o2: -0.24123856

            axialTilt: 23.43
            rotationPeriod: 0.997
            satelliteCount: 1
            radius: 6378.1
            volume: 1.08321e12
            mass: 5.97237e24
            surface: 5.1e8
        },
        PlanetConfig
        {
            id: mars

            name: qsTr("Mars")
            smallImageSource: "../gfx/s_mars.png"
            smallImageScaleZoomedOut: 0.3
            mediumImageSource: "../gfx/m_mars.png"
            orbitColor: "#66e58e5c"

            a1: 1.52371243; a2: 0.00000097
            e1: 0.09336511; e2: 0.00009149
            i1: 1.85181869; i2: -0.00724757
            l1: -4.56813164; l2: 19140.29934243
            w1: -23.91744784;  w2: 0.45223625
            o1: 49.71320984; o2: -0.26852431

            axialTilt: 25.19
            rotationPeriod: 1.026
            satelliteCount: 2
            radius: 3389.5
            volume: 1.6318e11
            mass: 6.4171e23
            surface: 1.44e8
        },
        PlanetConfig
        {
            id: jupiter

            name: qsTr("Jupiter")
            smallImageSource: "../gfx/s_jupiter.png"
            smallImageScaleZoomedIn: 0.0
            mediumImageSource: "../gfx/m_jupiter.png"
            orbitColor: "#66e4d6cd"

            a1: 5.20248019; a2: -0.00002864
            e1: 0.04853590; e2: 0.00018026
            i1: 1.29861416; i2: -0.00322699
            l1: 34.33479152; l2: 3034.90371757; b: -0.00012452; c: 0.06064060; s: -0.35635438; f: 38.35125000
            w1: 14.27495244; w2: 0.18199196
            o1: 100.29282654; o2: 0.13024619

            axialTilt: 3.13
            rotationPeriod: 0.4135
            satelliteCount: 67
            radius: 69911
            volume: 1.4313e15
            mass: 1.8986e27
            surface: 6.14e10
        },
        PlanetConfig
        {
            id: saturn

            name: qsTr("Saturn")
            smallImageSource: "../gfx/s_saturn.png"
            smallImageOnTopSource: "../gfx/s_saturn_rings.png"
            smallImageScaleZoomedIn: 0.0
            mediumImageSource: "../gfx/m_saturn.png"
            mediumImageOnTopSource: "../gfx/m_saturn_rings.png"
            orbitColor: "#66e3c9a3"

            a1: 9.54149883; a2: -0.00003065
            e1: 0.05550825; e2: -0.00032044
            i1: 2.49424102; i2: 0.00451969
            l1: 50.07571329; l2: 1222.11494724; b: 0.00025899; c: 0.13434469; s: 0.87320147; f: 38.35125000
            w1: 92.86136063; w2: 0.54179478
            o1: 113.63998702; o2: -0.25015002

            axialTilt: 26.73
            rotationPeriod: 0.439
            satelliteCount: 62
            radius: 58232
            volume: 8.2713e14
            mass: 5.6846e26
            surface: 4.27e10
        },
        PlanetConfig
        {
            id: uranus

            name: qsTr("Uranus")
            smallImageSource: "../gfx/s_uranus.png"
            smallImageScaleZoomedIn: 0.0
            mediumImageSource: "../gfx/m_uranus.png"
            orbitColor: "#66c2e5eb"

            a1: 19.18797948; a2: -0.00020455
            e1: 0.04685740; e2: -0.00001550
            i1: 0.77298127; i2: -0.00180155
            l1: 314.20276625; l2: 428.49512595; b: 0.00058331; c: -0.97731848; s: 0.17689245; f: 7.67025000
            w1: 172.43404441; w2: 0.09266985
            o1: 73.96250215; o2: 0.05739699

            axialTilt: 97.77
            rotationPeriod: 0.718
            satelliteCount: 27
            radius: 25362
            volume: 6.833e13
            mass: 8.681e25
            surface: 8.11e9
        },
        PlanetConfig
        {
            id: neptune

            name: qsTr("Neptune")
            smallImageSource: "../gfx/s_neptune.png"
            smallImageScaleZoomedIn: 0.0
            mediumImageSource: "../gfx/m_neptune.png"
            orbitColor: "#6673a7fe"

            a1: 30.06952752; a2: 0.00006447
            e1: 0.00895439; e2: 0.00000818
            i1: 1.77005520; i2: 0.00022400
            l1: 304.22289287; l2: 218.46515314; b: -0.00041348; c: 0.68346318; s: -0.10162547; f: 7.67025000
            w1: 46.68158724; w2: 0.01009938
            o1: 131.78635853; o2: -0.00606302

            axialTilt: 28.32
            rotationPeriod: 0.671
            satelliteCount: 14
            radius: 24622
            volume: 6.254e13
            mass: 1.0243e26
            surface: 7.62e9
        },
        PlanetConfig
        {
            id: pluto

            name: qsTr("Pluto")
            smallImageSource: "../gfx/s_pluto.png"
            smallImageScaleZoomedIn: 0.0
            mediumImageSource: "../gfx/m_pluto.png"
            isDwarfPlanet: true
            orbitColor: "#66b08764"
            orbitCorrectionFactorX: 1.021
            orbitCorrectionFactorY: 0.982
            orbitCanShowZPosition: true

            a1: 39.48686035; a2: 0.00449751
            e1: 0.24885238; e2: 0.00006016
            i1: 17.14104260; i2: 0.00000501
            l1: 238.96535011; l2: 145.18042903; b: -0.01262724
            w1: 224.09702598; w2: -0.00968827
            o1: 110.30167986; o2: -0.00809981

            axialTilt: 119.59
            rotationPeriod: 6.387
            satelliteCount: 5
            radius: 1186
            volume: 6.99e9
            mass: 1.305e22
            surface: 1.77e7
        }
    ]

    // -----------------------------------------------------------------------

    function initPlanetIndices()
    {
        for (var planetIdx = 0; planetIdx < planetConfigs.length; ++planetIdx)
        {
            var PlanetConfig = planetConfigs[planetIdx];

            PlanetConfig.idxWithDwarfPlanets = planetIdx;
            if (PlanetConfig.isDwarfPlanet)
            {
                ++dwarfPlanetCount;
                PlanetConfig.visible = Qt.binding(function() { return settings.showDwarfPlanets });
            }
            else
            {
                PlanetConfig.idxWithoutDwarfPlanets = realPlanetCount;
                ++realPlanetCount;
            }
        }
    }

    // -----------------------------------------------------------------------

    cover: coverPage
    initialPage: mainPage

    // -----------------------------------------------------------------------

    Component.onCompleted:
    {
        // load and apply settings
        initPlanetIndices();
        settings.loadValues();
        mainPage.init();
        coverPage.init();
        settings.startStoringValueChanges();
        initialized = true;

        // update / redraw contents
        coverPage.refresh();
        mainPage.refresh();
        settingsPage.refresh();
    }
    onActiveChanged:
    {
        settings.animationEnabled = false;
        if (active)
            mainPage.refresh();
    }

    // -----------------------------------------------------------------------

    Settings
    {
        id: settings
    }

    CoverPage
    {
        id: coverPage
    }

    MainPage
    {
        id: mainPage
    }
    DistancePage
    {
        id: distancePage

        solarSystem: mainPage.solarSystem
    }
    PlanetDetailsPage
    {
        id: planetDetailsPage

        planetConfig: planetConfigs[0]
    }
    SettingsPage
    {
        id: settingsPage
    }
    AboutPage
    {
        id: aboutPage
    }
}
