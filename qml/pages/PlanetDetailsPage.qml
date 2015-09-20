import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool pageActive: status === PageStatus.Active
    property PlanetConfig planetConfig

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
                title: planetConfig.name

                PlanetImage
                {
                    id: planetImage

                    small: false
                    planetConfig: page.planetConfig
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
                text: planetConfig.orbitAverageDistance + " AU"
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
                text: planetConfig.orbitPerihelion + " AU"
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
                text: planetConfig.orbitAphelion + " AU"
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
                text: planetConfig.orbitalPeriod + " a"
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
                text: planetConfig.orbitalVelocity + " m / s"
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
                text: planetConfig.rotationPeriod + " days"
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
                text: planetConfig.radius + " km"
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
                text: planetConfig.volume.toFixed(2) + " km³"
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
                text: planetConfig.mass.toFixed(2) + " kg"
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
                text: planetConfig.density.toFixed(2) + " kg / km³"
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
                text: planetConfig.surfaceGravity.toFixed(2) + " m / s²"
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
                text: planetConfig.escapeVelocity.toFixed(2) + " m / s"
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
                text: planetConfig.satelliteCount
                color: Theme.secondaryColor
                font { family: Theme.fontFamily; pixelSize: Theme.fontSizeMedium }
            }
        }
    }
}
