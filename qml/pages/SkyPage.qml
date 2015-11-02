import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../calculation.js" as Calculation
import "../globals.js" as Globals

Page
{
    id: page

    // -----------------------------------------------------------------------

    property bool pageActive: status === PageStatus.Active
    property date myDate: settings.date

    // -----------------------------------------------------------------------

    function init()
    {
        sky.init();
        repaint();
    }

    // -----------------------------------------------------------------------

    function repaint()
    {
        sky.requestPaint();
    }

    // -----------------------------------------------------------------------

    onPageActiveChanged:
    {
        if (pageActive)
        {
            repaint();
        }
        sky.timerEnabled = pageActive;
    }
    Component.onCompleted:
    {
    }
    onMyDateChanged:
    {
        repaint();
    }

    // -----------------------------------------------------------------------


    SilicaFlickable
    {
        anchors { fill: parent }
        contentHeight: column.height
        visible: app.initialized

        Column
        {
            id: column

            width: page.width
            spacing: Theme.paddingSmall

            PageHeader
            {
                title: qsTr("Sky")
            }

            SkyView
            {
                id: sky

                width: parent.width
                height: parent.width
                date: settings.date
                clip: true
            }
        }
    }
}
