# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-solarsystem

CONFIG += sailfishapp

SOURCES += src/harbour-solarsystem.cpp

OTHER_FILES += qml/harbour-solarsystem.qml \
    qml/cover/CoverPage.qml \
    rpm/harbour-solarsystem.changes.in \
    rpm/harbour-solarsystem.spec \
    rpm/harbour-solarsystem.yaml \
    translations/*.ts \
    harbour-solarsystem.desktop \
    qml/gfx/sun_light.png \
    qml/gfx/sun_flares.png \
    qml/gfx/sun_flames.png \
    qml/gfx/shadow.png \
    qml/components/Sun.qml \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    qml/components/SolarSystem.qml \
    qml/storage.js \
    qml/calculation.js \
    qml/components/PlanetImage.qml \
    qml/components/PlanetLabel.qml \
    qml/gfx/shadow2.png \
    qml/components/PlanetInfo.qml \
    qml/globals.js \
    qml/components/DateDisplay.qml \
    qml/pages/SettingsPage.qml \
    qml/components/Settings.qml \
    qml/components/PlayButton.qml \
    qml/pages/DistancePage.qml \
    qml/pages/PlanetDetailsPage.qml \
    qml/gfx/s_earth.png \
    qml/gfx/s_jupiter.png \
    qml/gfx/s_mars.png \
    qml/gfx/s_mercury.png \
    qml/gfx/s_neptune.png \
    qml/gfx/s_pluto.png \
    qml/gfx/s_saturn.png \
    qml/gfx/s_uranus.png \
    qml/gfx/s_venus.png \
    qml/components/PlanetCalculationResult.qml \
    qml/components/OrbitPainter.qml \
    qml/gfx/m_earth.png \
    qml/gfx/m_jupiter.png \
    qml/gfx/m_mars.png \
    qml/gfx/m_mercury.png \
    qml/gfx/m_neptune.png \
    qml/gfx/m_pluto.png \
    qml/gfx/m_saturn.png \
    qml/gfx/m_uranus.png \
    qml/gfx/m_venus.png

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-solarsystem-de.ts \
    translations/harbour-solarsystem-sv.ts

