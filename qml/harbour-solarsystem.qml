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

    cover: mainCover
    initialPage: mainPage

    // -----------------------------------------------------------------------

    Component.onCompleted:
    {
        // load and apply settings
        settings.loadValues();
        mainPage.init();
        mainCover.init();
        settingsPage.init();
        settings.startStoringValueChanges();
        initialized = true;
    }
    onActiveChanged:
    {
        // automatically stop animation when active status of application changes (e.g. switched to background)
        settings.animationEnabled = false;

        if (active)
            mainPage.reactivate();
    }

    // -----------------------------------------------------------------------

    Settings
    {
        id: settings
    }

    MainCover
    {
        id: mainCover
    }

    MainPage
    {
        id: mainPage
    }
    PlanetDetailsPage
    {
        id: planetDetailsPage

        solarSystem: mainPage.solarSystem
        solarBody: mainPage.solarSystem.solarBodies[1]
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
