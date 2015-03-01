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
TARGET = sailfish-solarsystem

CONFIG += sailfishapp

SOURCES += src/sailfish-solarsystem.cpp

OTHER_FILES += qml/sailfish-solarsystem.qml \
    qml/cover/CoverPage.qml \
    rpm/sailfish-solarsystem.changes.in \
    rpm/sailfish-solarsystem.spec \
    rpm/sailfish-solarsystem.yaml \
    translations/*.ts \
    sailfish-solarsystem.desktop \
    qml/gfx/venus.png \
    qml/gfx/uranus.png \
    qml/gfx/sun_light.png \
    qml/gfx/sun_flares.png \
    qml/gfx/sun_flames.png \
    qml/gfx/shadow.png \
    qml/gfx/saturn.png \
    qml/gfx/neptune.png \
    qml/gfx/mercury.png \
    qml/gfx/mars.png \
    qml/gfx/jupiter.png \
    qml/gfx/earth.png \
    qml/components/Sun.qml \
    qml/pages/MainPage.qml \
    qml/components/SolarSystem.qml \
    qml/storage.js \
    qml/calculation.js \
    qml/components/PlanetImage.qml \
    qml/components/PlanetLabel.qml \
    qml/gfx/shadow2.png \
    qml/components/PlanetInfo.qml \
    qml/components/PlanetOrbits.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/sailfish-solarsystem-de.ts

