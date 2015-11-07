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
            surfaceGravity: 3.7
            escapeVelocity: 4250
            averageTemperature: 270
            pressure: 0
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
            surfaceGravity: 8.87
            escapeVelocity: 10360
            averageTemperature: 737
            pressure: 9.2e6
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
            surfaceGravity: 9.807
            escapeVelocity: 11186
            averageTemperature: 288
            pressure: 101.325e3
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
            surfaceGravity: 3.711
            escapeVelocity: 5027
            averageTemperature: 210
            pressure: 0.636e3
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
            surfaceGravity: 24.79
            escapeVelocity: 59500
            averageTemperature: 165
            pressure: -1
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
            surfaceGravity: 10.44
            escapeVelocity: 35500
            averageTemperature: 134
            pressure: -1

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
            surfaceGravity: 8.69
            escapeVelocity: 21300
            averageTemperature: 76
            pressure: -1
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
            surfaceGravity: 11.15
            escapeVelocity: 23500
            averageTemperature: 72
            pressure: -1
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
            surfaceGravity: 0.62
            escapeVelocity: 1212
            averageTemperature: 44
            pressure: 0.3
        },
        PlanetConfig
        {
            id: moon

            name: qsTr("Moon")
            parentPlanetConfig: earth
            smallImageSource: "../gfx/s_moon.png"
            mediumImageSource: "../gfx/s_moon.png"
            orbitColor: "#ffffff"

            a1: 60.2666//0.00257
            e1: 0.054900
            i1: 5.1454
            l1: 115.3654; l2: 477198.8675316225
            w1: 318.0634; w2: 6003.1511970075
            o1: 125.1228; o2: -1934.1378481575
        }
    ]

    property list<StarConfig> starConfigs:
    [
        StarConfig { name: "Sirius";            raHours: 06; raMinutes: 45; declination: -16.7; magnitude:-1.46 },
        StarConfig { name: "Canopus";           raHours: 06; raMinutes: 24; declination: -52.7; magnitude:-0.73 },
        StarConfig { name: "Rigil Kentaurus";   raHours: 14; raMinutes: 40; declination: -60.8; magnitude:-0.29 },
        StarConfig { name: "Arcturus";          raHours: 14; raMinutes: 16; declination: +19.2; magnitude:-0.05 },
        StarConfig { name: "Vega";              raHours: 18; raMinutes: 37; declination: +38.8; magnitude: 0.03 },
        StarConfig { name: "Capella";           raHours: 05; raMinutes: 17; declination: +46.0; magnitude: 0.07 },
        StarConfig { name: "Rigel";             raHours: 05; raMinutes: 15; declination:  -8.2; magnitude: 0.15 },
        StarConfig { name: "Procyon";           raHours: 07; raMinutes: 39; declination:  +5.2; magnitude: 0.36 },
        StarConfig { name: "Achernar";          raHours: 01; raMinutes: 38; declination: -57.2; magnitude: 0.45 },
        StarConfig { name: "Betelgeuse";        raHours: 05; raMinutes: 55; declination:  +7.4; magnitude: 0.55 },
        StarConfig { name: "Hadar";             raHours: 14; raMinutes: 04; declination: -60.4; magnitude: 0.61 },
        StarConfig { name: "Altair";            raHours: 19; raMinutes: 51; declination:  +8.9; magnitude: 0.77 },
        StarConfig { name: "Acrux";             raHours: 12; raMinutes: 27; declination: -63.1; magnitude: 0.79 },
        StarConfig { name: "Aldebaran";         raHours: 04; raMinutes: 36; declination: +16.5; magnitude: 0.86 },
        StarConfig { name: "Antares";           raHours: 16; raMinutes: 29; declination: -26.4; magnitude: 0.95 },
        StarConfig { name: "Spica";             raHours: 13; raMinutes: 25; declination: -11.2; magnitude: 0.97 },
        StarConfig { name: "Pollux";            raHours: 07; raMinutes: 45; declination: +28.0; magnitude: 1.14 },
        StarConfig { name: "Fomalhaut";         raHours: 22; raMinutes: 58; declination: -29.6; magnitude: 1.15 },
        StarConfig { name: "Deneb";             raHours: 20; raMinutes: 41; declination: +45.3; magnitude: 1.24 },
        StarConfig { name: "Mimosa";            raHours: 12; raMinutes: 48; declination: -59.7; magnitude: 1.26 },
        StarConfig { name: "Regulus";           raHours: 10; raMinutes: 08; declination: +12.0; magnitude: 1.36 },
        StarConfig { name: "Adhara";            raHours: 06; raMinutes: 59; declination: -29.0; magnitude: 1.50 },
        StarConfig { name: "Castor";            raHours: 07; raMinutes: 35; declination: +31.9; magnitude: 1.58 },
        StarConfig { name: "Shaula";            raHours: 17; raMinutes: 34; declination: -37.1; magnitude: 1.62 },
        StarConfig { name: "Gacrux";            raHours: 12; raMinutes: 31; declination: -57.1; magnitude: 1.63 },
        StarConfig { name: "Bellatrix";         raHours: 05; raMinutes: 25; declination:  +6.3; magnitude: 1.64 },
        StarConfig { name: "Elnath";            raHours: 05; raMinutes: 26; declination: +28.6; magnitude: 1.66 },
        StarConfig { name: "Miaplacidus";       raHours: 09; raMinutes: 13; declination: -69.7; magnitude: 1.67 },
        StarConfig { name: "Alnilam";           raHours: 05; raMinutes: 36; declination:  -1.2; magnitude: 1.69 },
        StarConfig { name: "Alnair";            raHours: 22; raMinutes: 08; declination: -47.0; magnitude: 1.74 },
        StarConfig { name: "Alnitak";           raHours: 05; raMinutes: 41; declination:  -1.9; magnitude: 1.75 },
        StarConfig { name: "Alioth";            raHours: 12; raMinutes: 54; declination: +56.0; magnitude: 1.77 },
        StarConfig { name: "Mirfak";            raHours: 03; raMinutes: 24; declination: +49.9; magnitude: 1.80 },
        StarConfig { name: "Dubhe";             raHours: 11; raMinutes: 04; declination: +61.8; magnitude: 1.80 },
        StarConfig { name: "Regor";             raHours: 08; raMinutes: 10; declination: -47.3; magnitude: 1.81 },
        StarConfig { name: "Wezen";             raHours: 07; raMinutes: 08; declination: -26.4; magnitude: 1.83 },
        StarConfig { name: "Kaus Australis";    raHours: 18; raMinutes: 24; declination: -34.4; magnitude: 1.84 },
        StarConfig { name: "Alkaid";            raHours: 13; raMinutes: 48; declination: +49.3; magnitude: 1.86 },
        StarConfig { name: "Sargas";            raHours: 17; raMinutes: 37; declination: -43.0; magnitude: 1.86 },
        StarConfig { name: "Avior";             raHours: 08; raMinutes: 23; declination: -59.5; magnitude: 1.87 },
        StarConfig { name: "Menkalinan";        raHours: 06; raMinutes: 00; declination: +44.9; magnitude: 1.90 },
        StarConfig { name: "Atria";             raHours: 16; raMinutes: 49; declination: -69.0; magnitude: 1.92 },
        StarConfig { name: "Alhena";            raHours: 06; raMinutes: 38; declination: +16.4; magnitude: 1.93 },
        StarConfig { name: "Peacock";           raHours: 20; raMinutes: 26; declination: -56.7; magnitude: 1.93 },
        StarConfig { name: "Koo She";           raHours: 08; raMinutes: 45; declination: -54.7; magnitude: 1.95 },
        StarConfig { name: "Mirzam";            raHours: 06; raMinutes: 23; declination: -18.0; magnitude: 1.98 },
        StarConfig { name: "Alphard";           raHours: 09; raMinutes: 28; declination:  -8.7; magnitude: 1.98 },
        StarConfig { name: "Polaris";           raHours: 02; raMinutes: 32; declination: +89.3; magnitude: 1.99 },
        StarConfig { name: "Algieba";           raHours: 10; raMinutes: 20; declination: +19.8; magnitude: 2.00 },
        StarConfig { name: "Hamal";             raHours: 02; raMinutes: 07; declination: +23.5; magnitude: 2.01 },
        StarConfig { name: "Diphda";            raHours: 00; raMinutes: 44; declination: -18.0; magnitude: 2.04 },
        StarConfig { name: "Nunki";             raHours: 18; raMinutes: 55; declination: -26.3; magnitude: 2.05 },
        StarConfig { name: "Menkent";           raHours: 14; raMinutes: 07; declination: -36.4; magnitude: 2.06 },
        StarConfig { name: "Alpheratz";         raHours: 00; raMinutes: 08; declination: +29.1; magnitude: 2.07 },
        StarConfig { name: "Mirach";            raHours: 01; raMinutes: 10; declination: +35.6; magnitude: 2.07 },
        StarConfig { name: "Saiph";             raHours: 05; raMinutes: 48; declination:  -9.7; magnitude: 2.07 },
        StarConfig { name: "Kochab";            raHours: 14; raMinutes: 51; declination: +74.2; magnitude: 2.07 },
        StarConfig { name: "Al Dhanab";         raHours: 22; raMinutes: 43; declination: -46.9; magnitude: 2.07 },
        StarConfig { name: "Rasalhague";        raHours: 17; raMinutes: 35; declination: +12.6; magnitude: 2.08 },
        StarConfig { name: "Algol";             raHours: 03; raMinutes: 08; declination: +41.0; magnitude: 2.09 },
        StarConfig { name: "Almach";            raHours: 02; raMinutes: 04; declination: +42.3; magnitude: 2.10 },
        StarConfig { name: "Denebola";          raHours: 11; raMinutes: 49; declination: +14.6; magnitude: 2.14 },
        StarConfig { name: "Cih";               raHours: 00; raMinutes: 57; declination: +60.7; magnitude: 2.15 },
        StarConfig { name: "Muhlifain";         raHours: 12; raMinutes: 42; declination: -49.0; magnitude: 2.20 },
        StarConfig { name: "Naos";              raHours: 08; raMinutes: 04; declination: -40.0; magnitude: 2.21 },
        StarConfig { name: "Aspidiske";         raHours: 09; raMinutes: 17; declination: -59.3; magnitude: 2.21 },
        StarConfig { name: "Alphecca";          raHours: 15; raMinutes: 35; declination: +26.7; magnitude: 2.22 },
        StarConfig { name: "Suhail";            raHours: 09; raMinutes: 08; declination: -43.4; magnitude: 2.23 },
        StarConfig { name: "Mizar";             raHours: 13; raMinutes: 24; declination: +54.9; magnitude: 2.23 },
        StarConfig { name: "Sadr";              raHours: 20; raMinutes: 22; declination: +40.3; magnitude: 2.23 },
        StarConfig { name: "Schedar";           raHours: 00; raMinutes: 41; declination: +56.5; magnitude: 2.24 },
        StarConfig { name: "Eltanin";           raHours: 17; raMinutes: 57; declination: +51.5; magnitude: 2.24 },
        StarConfig { name: "Mintaka";           raHours: 05; raMinutes: 32; declination:  -0.3; magnitude: 2.25 },
        StarConfig { name: "Caph";              raHours: 00; raMinutes: 09; declination: +59.2; magnitude: 2.28 },
        StarConfig { name: "";                  raHours: 13; raMinutes: 40; declination: -53.5; magnitude: 2.29 },
        StarConfig { name: "Dschubba";          raHours: 16; raMinutes: 00; declination: -22.6; magnitude: 2.29 },
        StarConfig { name: "Wei";               raHours: 16; raMinutes: 50; declination: -34.3; magnitude: 2.29 },
        StarConfig { name: "Men";               raHours: 14; raMinutes: 42; declination: -47.4; magnitude: 2.30 },
        StarConfig { name: "";                  raHours: 14; raMinutes: 36; declination: -42.2; magnitude: 2.33 },
        StarConfig { name: "Merak";             raHours: 11; raMinutes: 02; declination: +56.4; magnitude: 2.34 },
        StarConfig { name: "Izar";              raHours: 14; raMinutes: 45; declination: +27.1; magnitude: 2.35 },
        StarConfig { name: "Enif";              raHours: 21; raMinutes: 44; declination:  +9.9; magnitude: 2.38 },
        StarConfig { name: "Girtab";            raHours: 17; raMinutes: 42; declination: -39.0; magnitude: 2.39 },
        StarConfig { name: "Ankaa";             raHours: 00; raMinutes: 26; declination: -42.3; magnitude: 2.40 },
        StarConfig { name: "Phecda";            raHours: 11; raMinutes: 54; declination: +53.7; magnitude: 2.41 },
        StarConfig { name: "Sabik";             raHours: 17; raMinutes: 10; declination: -15.7; magnitude: 2.43 },
        StarConfig { name: "Scheat";            raHours: 23; raMinutes: 04; declination: +28.1; magnitude: 2.44 },
        StarConfig { name: "Aludra";            raHours: 07; raMinutes: 24; declination: -29.3; magnitude: 2.45 },
        StarConfig { name: "Alderamin";         raHours: 21; raMinutes: 19; declination: +62.6; magnitude: 2.45 },
        StarConfig { name: "Markeb";            raHours: 09; raMinutes: 22; declination: -55.0; magnitude: 2.47 },
        StarConfig { name: "Gienah";            raHours: 20; raMinutes: 46; declination: +34.0; magnitude: 2.48 },
        StarConfig { name: "Markab";            raHours: 23; raMinutes: 05; declination: +15.2; magnitude: 2.49 },
        StarConfig { name: "Menkar";            raHours: 03; raMinutes: 02; declination:  +4.1; magnitude: 2.54 },
        StarConfig { name: "Han";               raHours: 16; raMinutes: 37; declination: -10.6; magnitude: 2.54 },
        StarConfig { name: "Al Nair al Kent";   raHours: 13; raMinutes: 56; declination: -47.3; magnitude: 2.55 },
        StarConfig { name: "Zosma";             raHours: 11; raMinutes: 14; declination: +20.5; magnitude: 2.56 },
        StarConfig { name: "Graffias";          raHours: 16; raMinutes: 05; declination: -19.8; magnitude: 2.56 },
        StarConfig { name: "Arneb";             raHours: 05; raMinutes: 33; declination: -17.8; magnitude: 2.58 },
        StarConfig { name: "";                  raHours: 12; raMinutes: 08; declination: -50.7; magnitude: 2.58 },
        StarConfig { name: "Gienah Ghurab";     raHours: 12; raMinutes: 16; declination: -17.5; magnitude: 2.58 },
        StarConfig { name: "Ascella";           raHours: 19; raMinutes: 03; declination: -29.9; magnitude: 2.60 },
        StarConfig { name: "Zubeneschamali";    raHours: 15; raMinutes: 17; declination:  -9.4; magnitude: 2.61 },
        StarConfig { name: "Unukalhai";         raHours: 15; raMinutes: 44; declination:  +6.4; magnitude: 2.63 },
        StarConfig { name: "Sheratan";          raHours: 01; raMinutes: 55; declination: +20.8; magnitude: 2.64 },
        StarConfig { name: "Zubenelgenubi";     raHours: 14; raMinutes: 51; declination: -16.0; magnitude: 2.64 },
        StarConfig { name: "Phact";             raHours: 05; raMinutes: 40; declination: -34.1; magnitude: 2.65 },
        StarConfig { name: "";                  raHours: 06; raMinutes: 00; declination: +37.2; magnitude: 2.65 },
        StarConfig { name: "Kraz";              raHours: 12; raMinutes: 34; declination: -23.4; magnitude: 2.65 },
        StarConfig { name: "Ruchbah";           raHours: 01; raMinutes: 26; declination: +60.2; magnitude: 2.66 },
        StarConfig { name: "Muphrid";           raHours: 13; raMinutes: 55; declination: +18.4; magnitude: 2.68 },
        StarConfig { name: "Ke Kouan";          raHours: 14; raMinutes: 59; declination: -43.1; magnitude: 2.68 },
        StarConfig { name: "Hassaleh";          raHours: 04; raMinutes: 57; declination: +33.2; magnitude: 2.69 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 47; declination: -49.4; magnitude: 2.69 },
        StarConfig { name: "";                  raHours: 12; raMinutes: 37; declination: -69.1; magnitude: 2.69 },
        StarConfig { name: "Lesath";            raHours: 17; raMinutes: 31; declination: -37.3; magnitude: 2.70 },
        StarConfig { name: "";                  raHours: 07; raMinutes: 17; declination: -37.1; magnitude: 2.71 },
        StarConfig { name: "Kaus Meridionalis"; raHours: 18; raMinutes: 21; declination: -29.8; magnitude: 2.72 },
        StarConfig { name: "Tarazed";           raHours: 19; raMinutes: 46; declination: +10.6; magnitude: 2.72 },
        StarConfig { name: "Yed Prior";         raHours: 16; raMinutes: 14; declination:  -3.7; magnitude: 2.73 },
        StarConfig { name: "Aldhibain";         raHours: 16; raMinutes: 24; declination: +61.5; magnitude: 2.73 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 43; declination: -64.4; magnitude: 2.74 },
        StarConfig { name: "Porrima";           raHours: 12; raMinutes: 42; declination:  -1.5; magnitude: 2.74 },
        StarConfig { name: "Hatysa";            raHours: 05; raMinutes: 35; declination:  -5.9; magnitude: 2.75 },
        StarConfig { name: "";                  raHours: 13; raMinutes: 21; declination: -36.7; magnitude: 2.75 },
        StarConfig { name: "Cebalrai";          raHours: 17; raMinutes: 43; declination:  +4.6; magnitude: 2.76 },
        StarConfig { name: "Kursa";             raHours: 05; raMinutes: 08; declination:  -5.1; magnitude: 2.78 },
        StarConfig { name: "Kornephoros";       raHours: 16; raMinutes: 30; declination: +21.5; magnitude: 2.78 },
        StarConfig { name: "";                  raHours: 12; raMinutes: 15; declination: -58.7; magnitude: 2.79 },
        StarConfig { name: "Rastaban";          raHours: 17; raMinutes: 30; declination: +52.3; magnitude: 2.79 },
        StarConfig { name: "Cor Caroli";        raHours: 12; raMinutes: 56; declination: +38.3; magnitude: 2.80 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 35; declination: -41.2; magnitude: 2.80 },
        StarConfig { name: "Nihal";             raHours: 05; raMinutes: 28; declination: -20.8; magnitude: 2.81 },
        StarConfig { name: "Rutilicus";         raHours: 16; raMinutes: 41; declination: +31.6; magnitude: 2.81 },
        StarConfig { name: "";                  raHours: 00; raMinutes: 26; declination: -77.3; magnitude: 2.82 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 36; declination: -28.2; magnitude: 2.82 },
        StarConfig { name: "Kaus Borealis";     raHours: 18; raMinutes: 28; declination: -25.4; magnitude: 2.82 },
        StarConfig { name: "Algenib";           raHours: 00; raMinutes: 13; declination: +15.2; magnitude: 2.83 },
        StarConfig { name: "Turais";            raHours: 08; raMinutes: 08; declination: -24.3; magnitude: 2.83 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 55; declination: -63.4; magnitude: 2.83 },
        StarConfig { name: "";                  raHours: 03; raMinutes: 54; declination: +31.9; magnitude: 2.84 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 25; declination: -55.5; magnitude: 2.84 },
        StarConfig { name: "Choo";              raHours: 17; raMinutes: 32; declination: -49.9; magnitude: 2.84 },
        StarConfig { name: "Alcyone";           raHours: 03; raMinutes: 47; declination: +24.1; magnitude: 2.85 },
        StarConfig { name: "Vindemiatrix";      raHours: 13; raMinutes: 02; declination: +11.0; magnitude: 2.85 },
        StarConfig { name: "Deneb Algedi";      raHours: 21; raMinutes: 47; declination: -16.1; magnitude: 2.85 },
        StarConfig { name: "Head of Hydrus";    raHours: 01; raMinutes: 59; declination: -61.6; magnitude: 2.86 },
        StarConfig { name: "";                  raHours: 19; raMinutes: 45; declination: +45.1; magnitude: 2.86 },
        StarConfig { name: "Tejat";             raHours: 06; raMinutes: 23; declination: +22.5; magnitude: 2.87 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 19; declination: -68.7; magnitude: 2.87 },
        StarConfig { name: "";                  raHours: 22; raMinutes: 19; declination: -60.3; magnitude: 2.87 },
        StarConfig { name: "Acamar";            raHours: 02; raMinutes: 58; declination: -40.3; magnitude: 2.88 },
        StarConfig { name: "Albaldah";          raHours: 19; raMinutes: 10; declination: -21.0; magnitude: 2.88 },
        StarConfig { name: "Gomeisa";           raHours: 07; raMinutes: 27; declination: +08.3; magnitude: 2.89 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 59; declination: -26.1; magnitude: 2.89 },
        StarConfig { name: "";                  raHours: 03; raMinutes: 58; declination: +40.0; magnitude: 2.90 },
        StarConfig { name: "Alniyat";           raHours: 16; raMinutes: 21; declination: -25.6; magnitude: 2.90 },
        StarConfig { name: "Albireo";           raHours: 19; raMinutes: 31; declination: +28.0; magnitude: 2.90 },
        StarConfig { name: "Sadalsuud";         raHours: 21; raMinutes: 32; declination: -05.6; magnitude: 2.90 },
        StarConfig { name: "";                  raHours: 03; raMinutes: 05; declination: +53.5; magnitude: 2.91 },
        StarConfig { name: "";                  raHours: 09; raMinutes: 47; declination: -65.1; magnitude: 2.92 },
        StarConfig { name: "Matar";             raHours: 22; raMinutes: 43; declination: +30.2; magnitude: 2.93 },
        StarConfig { name: "";                  raHours: 06; raMinutes: 50; declination: -50.6; magnitude: 2.94 },
        StarConfig { name: "Algorel";           raHours: 12; raMinutes: 30; declination: -16.5; magnitude: 2.94 },
        StarConfig { name: "Sadalmelik";        raHours: 22; raMinutes: 06; declination: -00.3; magnitude: 2.95 },
        StarConfig { name: "Zaurak";            raHours: 03; raMinutes: 58; declination: -13.5; magnitude: 2.97 },
        StarConfig { name: "Alheka";            raHours: 05; raMinutes: 38; declination: +21.1; magnitude: 2.97 },
        StarConfig { name: "Ras Elased Austr";  raHours: 09; raMinutes: 46; declination: +23.8; magnitude: 2.97 },
        StarConfig { name: "Alnasl";            raHours: 18; raMinutes: 06; declination: -30.4; magnitude: 2.98 },
        StarConfig { name: "";                  raHours: 13; raMinutes: 19; declination: -23.2; magnitude: 2.99 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 48; declination: -40.1; magnitude: 2.99 },
        StarConfig { name: "Deneb el Okab";     raHours: 19; raMinutes: 05; declination: +13.9; magnitude: 2.99 },
        StarConfig { name: "";                  raHours: 02; raMinutes: 10; declination: +35.0; magnitude: 3.00 },
        StarConfig { name: "";                  raHours: 11; raMinutes: 10; declination: +44.5; magnitude: 3.00 },
        StarConfig { name: "Pherkad Major";     raHours: 15; raMinutes: 21; declination: +71.8; magnitude: 3.00 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 52; declination: -38.0; magnitude: 3.00 },
        StarConfig { name: "";                  raHours: 21; raMinutes: 54; declination: -37.4; magnitude: 3.00 },
        StarConfig { name: "";                  raHours: 03; raMinutes: 43; declination: +47.8; magnitude: 3.01 },
        StarConfig { name: "Phurad";            raHours: 06; raMinutes: 20; declination: -30.1; magnitude: 3.02 },
        StarConfig { name: "";                  raHours: 07; raMinutes: 03; declination: -23.8; magnitude: 3.02 },
        StarConfig { name: "Minkar";            raHours: 12; raMinutes: 10; declination: -22.6; magnitude: 3.02 },
        StarConfig { name: "Almaaz";            raHours: 05; raMinutes: 02; declination: +43.8; magnitude: 3.03 },
        StarConfig { name: "";                  raHours: 12; raMinutes: 46; declination: -68.1; magnitude: 3.04 },
        StarConfig { name: "Seginus";           raHours: 14; raMinutes: 32; declination: +38.3; magnitude: 3.04 },
        StarConfig { name: "Dabih";             raHours: 20; raMinutes: 21; declination: -14.8; magnitude: 3.05 },
        StarConfig { name: "Mebsuta";           raHours: 06; raMinutes: 44; declination: +25.1; magnitude: 3.06 },
        StarConfig { name: "Tania Australis";   raHours: 10; raMinutes: 22; declination: +41.5; magnitude: 3.06 },
        StarConfig { name: "Tais";              raHours: 19; raMinutes: 13; declination: +67.7; magnitude: 3.07 },
        StarConfig { name: "";                  raHours: 18; raMinutes: 18; declination: -36.8; magnitude: 3.10 },
        StarConfig { name: "";                  raHours: 08; raMinutes: 55; declination: +05.9; magnitude: 3.11 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 50; declination: -16.2; magnitude: 3.11 },
        StarConfig { name: "";                  raHours: 11; raMinutes: 36; declination: -63.0; magnitude: 3.11 },
        StarConfig { name: "Persian";           raHours: 20; raMinutes: 38; declination: -47.3; magnitude: 3.11 },
        StarConfig { name: "Wazn";              raHours: 05; raMinutes: 51; declination: -35.8; magnitude: 3.12 },
        StarConfig { name: "Talita";            raHours: 08; raMinutes: 59; declination: +48.0; magnitude: 3.12 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 59; declination: -56.0; magnitude: 3.12 },
        StarConfig { name: "Sarin";             raHours: 17; raMinutes: 15; declination: +24.8; magnitude: 3.12 },
        StarConfig { name: "Ke Kwan";           raHours: 14; raMinutes: 59; declination: -42.1; magnitude: 3.13 },
        StarConfig { name: "";                  raHours: 09; raMinutes: 21; declination: +34.4; magnitude: 3.14 },
        StarConfig { name: "";                  raHours: 09; raMinutes: 31; declination: -57.0; magnitude: 3.16 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 15; declination: +36.8; magnitude: 3.16 },
        StarConfig { name: "";                  raHours: 06; raMinutes: 38; declination: -43.2; magnitude: 3.17 },
        StarConfig { name: "Al Haud";           raHours: 09; raMinutes: 33; declination: +51.7; magnitude: 3.17 },
        StarConfig { name: "Aldhibah";          raHours: 17; raMinutes: 09; declination: +65.7; magnitude: 3.17 },
        StarConfig { name: "";                  raHours: 18; raMinutes: 46; declination: -27.0; magnitude: 3.17 },
        StarConfig { name: "Hoedus II";         raHours: 05; raMinutes: 07; declination: +41.2; magnitude: 3.18 },
        StarConfig { name: "";                  raHours: 14; raMinutes: 43; declination: -65.0; magnitude: 3.18 },
        StarConfig { name: "Tabit";             raHours: 04; raMinutes: 50; declination: +07.0; magnitude: 3.19 },
        StarConfig { name: "";                  raHours: 05; raMinutes: 05; declination: -22.4; magnitude: 3.19 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 58; declination: +09.4; magnitude: 3.19 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 50; declination: -37.0; magnitude: 3.19 },
        StarConfig { name: "";                  raHours: 21; raMinutes: 13; declination: +30.2; magnitude: 3.21 },
        StarConfig { name: "Errai";             raHours: 23; raMinutes: 39; declination: +77.6; magnitude: 3.21 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 21; declination: -40.6; magnitude: 3.22 },
        StarConfig { name: "Yed Posterior";     raHours: 16; raMinutes: 18; declination: -04.7; magnitude: 3.23 },
        StarConfig { name: "Alava";             raHours: 18; raMinutes: 21; declination: -02.9; magnitude: 3.23 },
        StarConfig { name: "Alphirk";           raHours: 21; raMinutes: 29; declination: +70.6; magnitude: 3.23 },
        StarConfig { name: "";                  raHours: 06; raMinutes: 48; declination: -61.9; magnitude: 3.24 },
        StarConfig { name: "";                  raHours: 20; raMinutes: 11; declination: -00.8; magnitude: 3.24 },
        StarConfig { name: "";                  raHours: 07; raMinutes: 29; declination: -43.3; magnitude: 3.25 },
        StarConfig { name: "";                  raHours: 14; raMinutes: 06; declination: -26.7; magnitude: 3.25 },
        StarConfig { name: "Brachium";          raHours: 15; raMinutes: 04; declination: -25.3; magnitude: 3.25 },
        StarConfig { name: "Sulaphat";          raHours: 18; raMinutes: 59; declination: +32.7; magnitude: 3.25 },
        StarConfig { name: "";                  raHours: 03; raMinutes: 47; declination: -74.2; magnitude: 3.26 },
        StarConfig { name: "";                  raHours: 00; raMinutes: 39; declination: +30.9; magnitude: 3.27 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 22; declination: -25.0; magnitude: 3.27 },
        StarConfig { name: "Skat";              raHours: 22; raMinutes: 55; declination: -15.8; magnitude: 3.27 },
        StarConfig { name: "";                  raHours: 05; raMinutes: 13; declination: -16.2; magnitude: 3.29 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 14; declination: -70.0; magnitude: 3.29 },
        StarConfig { name: "Edasich";           raHours: 15; raMinutes: 25; declination: +59.0; magnitude: 3.29 },
        StarConfig { name: "";                  raHours: 04; raMinutes: 34; declination: -55.0; magnitude: 3.30 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 32; declination: -61.7; magnitude: 3.30 },
        StarConfig { name: "";                  raHours: 13; raMinutes: 50; declination: -42.5; magnitude: 3.30 },
        StarConfig { name: "Propus";            raHours: 06; raMinutes: 15; declination: +22.5; magnitude: 3.31 },
        StarConfig { name: "Rasalgethi";        raHours: 17; raMinutes: 15; declination: +14.4; magnitude: 3.31 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 25; declination: -56.4; magnitude: 3.31 },
        StarConfig { name: "";                  raHours: 01; raMinutes: 06; declination: -46.7; magnitude: 3.32 },
        StarConfig { name: "Gorgonea Tertia";   raHours: 03; raMinutes: 05; declination: +38.8; magnitude: 3.32 },
        StarConfig { name: "Megrez";            raHours: 12; raMinutes: 15; declination: +57.0; magnitude: 3.32 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 12; declination: -43.2; magnitude: 3.32 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 59; declination: -09.8; magnitude: 3.32 },
        StarConfig { name: "";                  raHours: 19; raMinutes: 07; declination: -27.7; magnitude: 3.32 },
        StarConfig { name: "";                  raHours: 04; raMinutes: 14; declination: -62.5; magnitude: 3.33 },
        StarConfig { name: "Chort";             raHours: 11; raMinutes: 14; declination: +15.4; magnitude: 3.33 },
        StarConfig { name: "Asmidiske";         raHours: 07; raMinutes: 49; declination: -24.9; magnitude: 3.34 },
        StarConfig { name: "Segin";             raHours: 01; raMinutes: 54; declination: +63.7; magnitude: 3.35 },
        StarConfig { name: "Algjebbah";         raHours: 05; raMinutes: 24; declination: -02.4; magnitude: 3.35 },
        StarConfig { name: "Alzirr";            raHours: 06; raMinutes: 45; declination: +12.9; magnitude: 3.35 },
        StarConfig { name: "Muscida";           raHours: 08; raMinutes: 30; declination: +60.7; magnitude: 3.35 },
        StarConfig { name: "";                  raHours: 19; raMinutes: 25; declination: +03.1; magnitude: 3.36 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 23; declination: -44.7; magnitude: 3.37 },
        StarConfig { name: "Heze";              raHours: 13; raMinutes: 35; declination: -00.6; magnitude: 3.38 },
        StarConfig { name: "";                  raHours: 08; raMinutes: 47; declination: +06.4; magnitude: 3.38 },
        StarConfig { name: "Meissa";            raHours: 05; raMinutes: 35; declination: +09.9; magnitude: 3.39 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 17; declination: -61.3; magnitude: 3.39 },
        StarConfig { name: "Auva";              raHours: 12; raMinutes: 56; declination: +03.4; magnitude: 3.39 },
        StarConfig { name: "";                  raHours: 22; raMinutes: 11; declination: +58.2; magnitude: 3.39 },
        StarConfig { name: "";                  raHours: 04; raMinutes: 29; declination: +15.9; magnitude: 3.40 },
        StarConfig { name: "";                  raHours: 01; raMinutes: 28; declination: -43.3; magnitude: 3.41 },
        StarConfig { name: "";                  raHours: 04; raMinutes: 01; declination: +12.5; magnitude: 3.41 },
        StarConfig { name: "";                  raHours: 13; raMinutes: 50; declination: -41.7; magnitude: 3.41 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 12; declination: -52.1; magnitude: 3.41 },
        StarConfig { name: "";                  raHours: 20; raMinutes: 45; declination: +61.8; magnitude: 3.41 },
        StarConfig { name: "Homam";             raHours: 22; raMinutes: 41; declination: +10.8; magnitude: 3.41 },
        StarConfig { name: "Mothallah";         raHours: 01; raMinutes: 53; declination: +29.6; magnitude: 3.42 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 00; declination: -38.4; magnitude: 3.42 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 46; declination: +27.7; magnitude: 3.42 },
        StarConfig { name: "";                  raHours: 20; raMinutes: 45; declination: -66.2; magnitude: 3.42 },
        StarConfig { name: "";                  raHours: 09; raMinutes: 11; declination: -58.9; magnitude: 3.43 },
        StarConfig { name: "Adhafera";          raHours: 10; raMinutes: 17; declination: +23.4; magnitude: 3.43 },
        StarConfig { name: "Althalimain";       raHours: 19; raMinutes: 06; declination: -04.9; magnitude: 3.43 },
        StarConfig { name: "Tania Borealis";    raHours: 10; raMinutes: 17; declination: +42.9; magnitude: 3.45 },
        StarConfig { name: "Sheliak";           raHours: 18; raMinutes: 50; declination: +33.4; magnitude: 3.45 },
        StarConfig { name: "Achird";            raHours: 00; raMinutes: 49; declination: +57.8; magnitude: 3.46 },
        StarConfig { name: "Dheneb";            raHours: 01; raMinutes: 09; declination: -10.2; magnitude: 3.46 },
        StarConfig { name: "";                  raHours: 07; raMinutes: 57; declination: -53.0; magnitude: 3.46 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 16; declination: +33.3; magnitude: 3.46 },
        StarConfig { name: "Kaffaljidhma";      raHours: 02; raMinutes: 43; declination: +03.2; magnitude: 3.47 },
        StarConfig { name: "";                  raHours: 10; raMinutes: 07; declination: +16.8; magnitude: 3.48 },
        StarConfig { name: "";                  raHours: 16; raMinutes: 43; declination: +38.9; magnitude: 3.48 },
        StarConfig { name: "";                  raHours: 01; raMinutes: 44; declination: -15.9; magnitude: 3.49 },
        StarConfig { name: "";                  raHours: 07; raMinutes: 02; declination: -27.9; magnitude: 3.49 },
        StarConfig { name: "Alula Borealis";    raHours: 11; raMinutes: 18; declination: +33.1; magnitude: 3.49 },
        StarConfig { name: "Nekkar";            raHours: 15; raMinutes: 02; declination: +40.4; magnitude: 3.49 },
        StarConfig { name: "";                  raHours: 18; raMinutes: 27; declination: -46.0; magnitude: 3.49 },
        StarConfig { name: "";                  raHours: 22; raMinutes: 49; declination: -51.3; magnitude: 3.49 },
        StarConfig { name: "";                  raHours: 06; raMinutes: 50; declination: -32.5; magnitude: 3.50 },
        StarConfig { name: "Wasat";             raHours: 07; raMinutes: 20; declination: +22.0; magnitude: 3.50 },
        StarConfig { name: "";                  raHours: 22; raMinutes: 50; declination: +66.2; magnitude: 3.50 },
        StarConfig { name: "";                  raHours: 19; raMinutes: 59; declination: +19.5; magnitude: 3.51 },
        StarConfig { name: "Sadalbari";         raHours: 22; raMinutes: 50; declination: +24.6; magnitude: 3.51 },
        StarConfig { name: "Rana";              raHours: 03; raMinutes: 43; declination: -09.8; magnitude: 3.52 },
        StarConfig { name: "Subra";             raHours: 09; raMinutes: 41; declination: +09.9; magnitude: 3.52 },
        StarConfig { name: "Tseen Ke";          raHours: 09; raMinutes: 57; declination: -54.6; magnitude: 3.52 },
        StarConfig { name: "";                  raHours: 18; raMinutes: 58; declination: -21.1; magnitude: 3.52 },
        StarConfig { name: "Baham";             raHours: 22; raMinutes: 10; declination: +06.2; magnitude: 3.52 },
        StarConfig { name: "Ain";               raHours: 04; raMinutes: 29; declination: +19.2; magnitude: 3.53 },
        StarConfig { name: "Tarf";              raHours: 08; raMinutes: 17; declination: +09.2; magnitude: 3.53 },
        StarConfig { name: "";                  raHours: 11; raMinutes: 33; declination: -31.9; magnitude: 3.54 },
        StarConfig { name: "";                  raHours: 15; raMinutes: 50; declination: -03.4; magnitude: 3.54 },
        StarConfig { name: "";                  raHours: 17; raMinutes: 38; declination: -15.4; magnitude: 3.54 }
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
        skyPage.init();
        coverPage.init();
        settingsPage.init();
        settings.startStoringValueChanges();
        initialized = true;
    }
    onActiveChanged:
    {
        // automatically stop animation when active status of application changes (e.g. switched to background)
        settings.animationEnabled = false;

        if (active)
            mainPage.repaint();
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
    SkyPage
    {
        id: skyPage
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
