import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.solarsystem.Projector 1.0

import "../components"

Item
{
    property int bodyIdx: settings.coverPlanetIdx

    // -----------------------------------------------------------------------

    function init()
    {
        update();
    }

    // -----------------------------------------------------------------------

    function update()
    {
        solarSystem.dateTime.setNow();
        updateTimeLabels();
    }

    // -----------------------------------------------------------------------

    function updateTimeLabels()
    {
        projector.update();

        var solarBody = bodyIdx === -1 ? solarSystem.sun : solarSystem.solarBodies[bodyIdx];
        solarBodyImage.solarBody   = solarBody;
        solarBodyPainter.solarBody = solarBody;
        solarBodyPainter.calculateRelativeCoordinates();
        solarBodyPainter.calculatePhase();
        solarBodyPainter.applyRelativeCoordinates();

        var riseTransitSetTimes = projector.getRiseTransitSetTimes(solarBodyPainter.geocentricLongitude, solarBodyPainter.geocentricLatitude, solarBody.orbitalElements.averageLongitudeChangePerDay / 24.0);
        solarBodyLabel.text = solarBody.name;
        riseLabel.time      = riseTransitSetTimes.x;
        transitLabel.time   = riseTransitSetTimes.y;
        setLabel.time       = riseTransitSetTimes.z;
    }

    // -----------------------------------------------------------------------

    onBodyIdxChanged:
    {
        updateTimeLabels();
    }

    // -----------------------------------------------------------------------

    SolarSystem
    {
        id: solarSystem

        showDwarfPlanets: settings.showDwarfPlanets
    }
    Projector
    {
        id: projector

        dateTime: solarSystem.dateTime
        longitude: settings.longitude
        latitude: settings.latitude
    }
    SkyViewSolarBodyPainter
    {
        id: solarBodyPainter

        sun: solarSystem.sun
        earth: solarSystem.earth
        moon: solarSystem.moon
        mars: solarSystem.mars
    }

    Column
    {
        id: column

        anchors { fill: parent; margins: Theme.paddingMedium }
        spacing: 0

        SkyViewSolarBodyImage
        {
            id: solarBodyImage

            anchors { horizontalCenter: parent.horizontalCenter }
            width: parent.width
            height: imageHeight
            visible: true
            shadowPhase: solarBodyPainter.displayedPhase
            shadowOpacity: 0.4
            useSmallImage: false
            useLargeImage: true
            highlighted: true
            scale: 0.8
        }
        Label
        {
            id: solarBodyLabel

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.highlightColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        }
        Item
        {
            width: parent.width
            height: Theme.paddingMedium
        }
        Label
        {
            text: qsTr("Rise")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        }
        RiseAndSetLabel
        {
            id: riseLabel

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            highlighted: false
        }
        Label
        {
            text: qsTr("Transit")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        }
        RiseAndSetLabel
        {
            id: transitLabel

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            highlighted: false
        }
        Label
        {
            text: qsTr("Set")
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            color: Theme.secondaryColor
            font { family: Theme.fontFamily; pixelSize: Theme.fontSizeTiny }
        }
        RiseAndSetLabel
        {
            id: setLabel

            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            highlighted: false
        }
    }
}
