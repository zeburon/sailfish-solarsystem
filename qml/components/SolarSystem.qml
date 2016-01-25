import QtQuick 2.0
import harbour.solarsystem.OrbitalElementsPlanet 1.0
import harbour.solarsystem.OrbitalElementsMoon 1.0
import harbour.solarsystem.OrbitalElementsSun 1.0
import harbour.solarsystem.DateTime 1.0

QtObject
{
    property DateTime dateTime: DateTime { }
    property bool valid: dateTime.valid

    // -----------------------------------------------------------------------

    property bool showDwarfPlanets: true
    property bool showMoon: true

    // -----------------------------------------------------------------------

    property alias mercury: mercury
    property alias venus: venus
    property alias earth: earth
    property alias moon: moon
    property alias mars: mars
    property alias jupiter: jupiter
    property alias saturn: saturn
    property alias uranus: uranus
    property alias neptune: neptune
    property alias pluto: pluto

    // -----------------------------------------------------------------------

    property int visibleBodyCount: 0
    property int visiblePlanetCount: 0

    // -----------------------------------------------------------------------

    property SolarBody sun: SolarBody
    {
        name: qsTr("Sun")
        smallImageScaleZoomedOut: 0.1
        largeImageSourceBottom: "../gfx/l_sun.png"
        largeImageSourceTop: "../gfx/l_sun_flares.png"
        orbitalElements: OrbitalElementsSun { }

        axialTilt: 7.25
        rotationPeriod: 25.05
        satelliteCount: 0
        radius: 696342
        volume: 1.41e18
        mass: 1.98855e30
        surface: 6.09e12
        surfaceGravity: 274.0
        escapeVelocity: 617700
        averageTemperature: 5788
        pressure: -1
    }

    property list<SolarBody> solarBodies:
    [
        SolarBody
        {
            id: mercury

            name: qsTr("Mercury")
            smallImageSourceBottom: "../gfx/s_mercury.png"
            smallImageScaleZoomedOut: 0.0
            largeImageSourceBottom: "../gfx/l_mercury.png"
            orbitColor: "#558d8d8d"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 0.38709843; semiMajorAxisPerCentury: 0.00000000
                eccentricityStart: 0.20563661; eccentricityPerCentury: 0.00002123
                inclinationStart: 7.00559432; inclinationPerCentury: -0.00590158
                meanLongitudeStart: 252.25166724; meanLongitudePerCentury: 149472.67486623
                longitudeOfPeriapsisStart: 77.45771895; longitudeOfPeriapsisPerCentury: 0.15940013
                longitudeOfAscendingNodeStart: 48.33961819; longitudeOfAscendingNodePerCentury: -0.12214182
            }

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
        SolarBody
        {
            id: venus

            name: qsTr("Venus")
            smallImageSourceBottom: "../gfx/s_venus.png"
            smallImageScaleZoomedOut: 0.1
            largeImageSourceBottom: "../gfx/l_venus.png"
            orbitColor: "#55e8bb79"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 0.72332102; semiMajorAxisPerCentury: -0.00000026
                eccentricityStart: 0.00676399; eccentricityPerCentury: -0.00005107
                inclinationStart: 3.39777545; inclinationPerCentury: 0.00043494
                meanLongitudeStart: 181.97970850; meanLongitudePerCentury: 58517.81560260
                longitudeOfPeriapsisStart: 131.76755713; longitudeOfPeriapsisPerCentury: 0.05679648
                longitudeOfAscendingNodeStart: 76.67261496; longitudeOfAscendingNodePerCentury: -0.27274174
            }

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
        SolarBody
        {
            id: earth

            name: qsTr("Earth")
            smallImageSourceBottom: "../gfx/s_earth.png"
            smallImageScaleZoomedOut: 0.2
            largeImageSourceBottom: "../gfx/l_earth.png"
            orbitColor: "#66ffffff"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 1.00000018; semiMajorAxisPerCentury: -0.00000003
                eccentricityStart: 0.01673163; eccentricityPerCentury: -0.00003661
                inclinationStart: -0.00054346; inclinationPerCentury: -0.01337178
                meanLongitudeStart: 100.46691572; meanLongitudePerCentury: 35999.37306329
                longitudeOfPeriapsisStart: 102.93005885; longitudeOfPeriapsisPerCentury: 0.31795260
                longitudeOfAscendingNodeStart: -5.11260389; longitudeOfAscendingNodePerCentury: -0.24123856
            }

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
        SolarBody
        {
            id: moon

            name: qsTr("Moon")
            parentSolarBody: earth
            visible: showMoon
            smallImageSourceBottom: "../gfx/s_moon.png"
            smallImageScaleZoomedOut: 0.0
            mediumImageSourceBottom: "../gfx/m_moon.png"
            largeImageSourceBottom: "../gfx/l_moon.png"
            orbitColor: "#55ffffff"
            orbitalElements: OrbitalElementsMoon
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                meanDistanceStart: 0.00257
                eccentricityStart: 0.054900
                inclinationStart: 5.1454
                meanAnomalyStart: 115.3654; meanAnomalyPerCentury: 477198.8675316225
                argumentOfPeriapsisStart: 318.0634; argumentOfPeriapsisPerCentury: 6003.1511970075
                longitudeOfAscendingNodeStart: 125.1228; longitudeOfAscendingNodePerCentury: -1934.1378481575
                periodOverride: 0.07481
            }

            axialTilt: 6.687 // to orbit plane
            rotationPeriod: 27.321582
            satelliteCount: 0
            radius: 1738.1
            volume: 2.1958e10
            mass: 7.342e22
            surface: 3.793e7
            surfaceGravity: 1.62
            escapeVelocity: 2380
            averageTemperature: 220
            pressure: 1e-7
        },
        SolarBody
        {
            id: mars

            name: qsTr("Mars")
            smallImageSourceBottom: "../gfx/s_mars.png"
            smallImageScaleZoomedOut: 0.2
            largeImageSourceBottom: "../gfx/l_mars.png"
            orbitColor: "#55e58e5c"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 1.52371243; semiMajorAxisPerCentury: 0.00000097
                eccentricityStart: 0.09336511; eccentricityPerCentury: 0.00009149
                inclinationStart: 1.85181869; inclinationPerCentury: -0.00724757
                meanLongitudeStart: -4.56813164; meanLongitudePerCentury: 19140.29934243
                longitudeOfPeriapsisStart: -23.91744784;  longitudeOfPeriapsisPerCentury: 0.45223625
                longitudeOfAscendingNodeStart: 49.71320984; longitudeOfAscendingNodePerCentury: -0.26852431
            }

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
        SolarBody
        {
            id: jupiter

            name: qsTr("Jupiter")
            smallImageSourceBottom: "../gfx/s_jupiter.png"
            smallImageScaleZoomedIn: 0.0
            largeImageSourceBottom: "../gfx/l_jupiter.png"
            orbitColor: "#55e4d6cd"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 5.20248019; semiMajorAxisPerCentury: -0.00002864
                eccentricityStart: 0.04853590; eccentricityPerCentury: 0.00018026
                inclinationStart: 1.29861416; inclinationPerCentury: -0.00322699
                meanLongitudeStart: 34.33479152; meanLongitudePerCentury: 3034.90371757; meanAnomalyParameterB: -0.00012452; meanAnomalyParameterC: 0.06064060; meanAnomalyParameterS: -0.35635438; meanAnomalyParameterF: 38.35125000
                longitudeOfPeriapsisStart: 14.27495244; longitudeOfPeriapsisPerCentury: 0.18199196
                longitudeOfAscendingNodeStart: 100.29282654; longitudeOfAscendingNodePerCentury: 0.13024619
            }

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
        SolarBody
        {
            id: saturn

            name: qsTr("Saturn")
            smallImageSourceBottom: "../gfx/s_saturn.png"
            smallImageSourceTop: "../gfx/s_saturn_rings.png"
            smallImageScaleZoomedIn: 0.0
            largeImageSourceBottom: "../gfx/l_saturn.png"
            largeImageSourceTop: "../gfx/m_saturn_rings.png"
            orbitColor: "#55e3c9a3"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 9.54149883; semiMajorAxisPerCentury: -0.00003065
                eccentricityStart: 0.05550825; eccentricityPerCentury: -0.00032044
                inclinationStart: 2.49424102; inclinationPerCentury: 0.00451969
                meanLongitudeStart: 50.07571329; meanLongitudePerCentury: 1222.11494724; meanAnomalyParameterB: 0.00025899; meanAnomalyParameterC: 0.13434469; meanAnomalyParameterS: 0.87320147; meanAnomalyParameterF: 38.35125000
                longitudeOfPeriapsisStart: 92.86136063; longitudeOfPeriapsisPerCentury: 0.54179478
                longitudeOfAscendingNodeStart: 113.63998702; longitudeOfAscendingNodePerCentury: -0.25015002
            }

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
        SolarBody
        {
            id: uranus

            name: qsTr("Uranus")
            smallImageSourceBottom: "../gfx/s_uranus.png"
            smallImageScaleZoomedIn: 0.0
            largeImageSourceBottom: "../gfx/l_uranus.png"
            orbitColor: "#55c2e5eb"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 19.18797948; semiMajorAxisPerCentury: -0.00020455
                eccentricityStart: 0.04685740; eccentricityPerCentury: -0.00001550
                inclinationStart: 0.77298127; inclinationPerCentury: -0.00180155
                meanLongitudeStart: 314.20276625; meanLongitudePerCentury: 428.49512595; meanAnomalyParameterB: 0.00058331; meanAnomalyParameterC: -0.97731848; meanAnomalyParameterS: 0.17689245; meanAnomalyParameterF: 7.67025000
                longitudeOfPeriapsisStart: 172.43404441; longitudeOfPeriapsisPerCentury: 0.09266985
                longitudeOfAscendingNodeStart: 73.96250215; longitudeOfAscendingNodePerCentury: 0.05739699
            }

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
        SolarBody
        {
            id: neptune

            name: qsTr("Neptune")
            smallImageSourceBottom: "../gfx/s_neptune.png"
            smallImageScaleZoomedIn: 0.0
            largeImageSourceBottom: "../gfx/l_neptune.png"
            orbitColor: "#5573a7fe"
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 30.06952752; semiMajorAxisPerCentury: 0.00006447
                eccentricityStart: 0.00895439; eccentricityPerCentury: 0.00000818
                inclinationStart: 1.77005520; inclinationPerCentury: 0.00022400
                meanLongitudeStart: 304.22289287; meanLongitudePerCentury: 218.46515314; meanAnomalyParameterB: -0.00041348; meanAnomalyParameterC: 0.68346318; meanAnomalyParameterS: -0.10162547; meanAnomalyParameterF: 7.67025000
                longitudeOfPeriapsisStart: 46.68158724; longitudeOfPeriapsisPerCentury: 0.01009938
                longitudeOfAscendingNodeStart: 131.78635853; longitudeOfAscendingNodePerCentury: -0.00606302
            }

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
        SolarBody
        {
            id: pluto

            name: qsTr("Pluto")
            smallImageSourceBottom: "../gfx/s_pluto.png"
            smallImageScaleZoomedIn: 0.0
            largeImageSourceBottom: "../gfx/l_pluto.png"
            visible: showDwarfPlanets
            orbitColor: "#55b08764"
            orbitCorrectionFactorX: 1.02
            orbitCorrectionFactorY: 0.98
            orbitalElements: OrbitalElementsPlanet
            {
                centuriesSinceJ2000: dateTime.centuriesSinceJ2000
                semiMajorAxisStart: 39.48686035; semiMajorAxisPerCentury: 0.00449751
                eccentricityStart: 0.24885238; eccentricityPerCentury: 0.00006016
                inclinationStart: 17.14104260; inclinationPerCentury: 0.00000501
                meanLongitudeStart: 238.96535011; meanLongitudePerCentury: 145.18042903; meanAnomalyParameterB: -0.01262724
                longitudeOfPeriapsisStart: 224.09702598; longitudeOfPeriapsisPerCentury: -0.00968827
                longitudeOfAscendingNodeStart: 110.30167986; longitudeOfAscendingNodePerCentury: -0.00809981
            }

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
        }
    ]
    property var solarBodyArray: []

    // -----------------------------------------------------------------------

    function getDistanceBetweenBodies(solarBody1, solarBody2)
    {
        var dx = solarBody1.orbitalElements.x - solarBody2.orbitalElements.x;
        var dy = solarBody1.orbitalElements.y - solarBody2.orbitalElements.y;
        var dz = solarBody1.orbitalElements.z - solarBody2.orbitalElements.z;
        return Math.sqrt(dx * dx + dy * dy + dz * dz);
    }

    function getDistanceToEarth(solarBody)
    {
        return getDistanceBetweenBodies(solarBody, earth);
    }

    function getIndex(solarBody)
    {
        return solarBodyArray.indexOf(solarBody);
    }

    function updateVisibleCounts()
    {
        var newVisibleBodyCount = 0, newVisiblePlanetCount = 0;
        for (var bodyIdx = 0; bodyIdx < solarBodies.length; ++bodyIdx)
        {
            if (solarBodies[bodyIdx].visible)
            {
                ++newVisibleBodyCount;
                if (!solarBodies[bodyIdx].parentSolarBody)
                {
                    ++newVisiblePlanetCount;
                }
            }
        }
        visibleBodyCount = newVisibleBodyCount;
        visiblePlanetCount = newVisiblePlanetCount;
    }

    // -----------------------------------------------------------------------

    Component.onCompleted:
    {
        for (var bodyIdx = 0; bodyIdx < solarBodies.length; ++bodyIdx)
        {
            solarBodyArray.push(solarBodies[bodyIdx]);
        }
        updateVisibleCounts();
        showDwarfPlanetsChanged.connect(updateVisibleCounts);
        showMoonChanged.connect(updateVisibleCounts);
    }
}
