import QtQuick 2.0
import Sailfish.Silica 1.0

import "cover"
import "pages"
import "components"

ApplicationWindow
{
    id: app

    property bool active: Qt.application.state === Qt.ApplicationActive
    property bool initialized: false

    initialPage: mainPage
    cover: cover

    Component.onCompleted:
    {
        // load settings
        settings.loadValues();
        mainPage.init();
        settings.startStoringValueChanges();
        initialized = true;

        // refresh pages
        cover.refresh();
        mainPage.refresh();
        settingsPage.refresh();
    }
    onActiveChanged:
    {
        settings.animationEnabled = false;
        mainPage.refresh();
    }

    Settings
    {
        id: settings
    }

    MainPage
    {
        id: mainPage
    }
    SettingsPage
    {
        id: settingsPage
    }
    AboutPage
    {
        id: aboutPage
    }

    CoverPage
    {
        id: cover
    }
}
