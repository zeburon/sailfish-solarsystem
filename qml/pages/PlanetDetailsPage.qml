import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool pageActive: status === PageStatus.Active
    property PlanetInfo planetInfo

    // -----------------------------------------------------------------------

    onPageActiveChanged:
    {
        if (pageActive)
        {
            flickable.scrollToTop();
        }
    }

    // -----------------------------------------------------------------------

    SilicaFlickable
    {
        id: flickable

        anchors { fill: parent; leftMargin: Theme.paddingSmall; rightMargin: Theme.paddingSmall }
        contentHeight: column.height

        Column
        {
            id: column

            width: parent.width
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: planetInfo.name

                PlanetImage
                {
                    id: planetImage

                    small: false
                    planetInfo: page.planetInfo
                    anchors { left: parent.left; leftMargin: Theme.paddingLarge + imageWidth / 2; verticalCenter: parent.verticalCenter }
                    showShadowBehindPlanet: false
                    shadowRotation: 180
                }
            }

            Label
            {
                text: qsTr("Average Distance")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.orbitAverageDistance + " AU"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Minimum Distance")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.orbitPerihelion + " AU"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Maximum Distance")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.orbitAphelion + " AU"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Orbital Period")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.orbitalPeriod + " a"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Orbital Velocity")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.orbitalVelocity + " m / s"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Rotation Period")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.rotationPeriod + " days"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Radius")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.radius + " km"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Volume")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.volume.toFixed(2) + " km³"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Mass")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.mass.toFixed(2) + " kg"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Density")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.density.toFixed(2) + " kg / km³"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Surface Gravity")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.surfaceGravity.toFixed(2) + " m / s²"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Escape Velocity")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.escapeVelocity.toFixed(2) + " m / s"
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }

            Label
            {
                text: qsTr("Satellite Count")
                color: Theme.primaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
            Label
            {
                text: planetInfo.satelliteCount
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
        }
    }
}
