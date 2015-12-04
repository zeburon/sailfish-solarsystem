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

SOURCES += src/harbour-solarsystem.cpp \
    src/orbitalelementsplanet.cpp \
    src/orbitalelements.cpp \
    src/orbitalelementsmoon.cpp \
    src/projector.cpp \
    src/datetime.cpp

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
    qml/storage.js \
    qml/calculation.js \
    qml/gfx/shadow2.png \
    qml/globals.js \
    qml/components/DateDisplay.qml \
    qml/pages/SettingsPage.qml \
    qml/components/Settings.qml \
    qml/components/PlayButton.qml \
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
    qml/gfx/m_earth.png \
    qml/gfx/m_jupiter.png \
    qml/gfx/m_mars.png \
    qml/gfx/m_mercury.png \
    qml/gfx/m_neptune.png \
    qml/gfx/m_pluto.png \
    qml/gfx/m_saturn.png \
    qml/gfx/m_uranus.png \
    qml/gfx/m_venus.png \
    qml/components/PlanetPosition.qml \
    qml/components/DetailsElement.qml \
    qml/gfx/m_saturn_rings.png \
    qml/gfx/s_saturn_rings.png \
    qml/gfx/zoom_in.png \
    qml/gfx/zoom_out.png \
    qml/components/TopView.qml \
    qml/components/SkyView.qml \
    qml/components/StarConfig.qml

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += translations/harbour-solarsystem-de.ts \
    translations/harbour-solarsystem-sv.ts

HEADERS += \
    src/orbitalelementsplanet.h \
    src/orbitalelements.h \
    src/orbitalelementsmoon.h \
    src/projector.h \
    src/datetime.h

DISTFILES += \
    qml/components/SolarBody.qml \
    qml/components/TopOrbitPainter.qml \
    qml/gfx/m_moon.png \
    qml/gfx/s_moon.png \
    qml/components/SolarSystem.qml \
    qml/pages/PlanetDistancePage.qml \
    qml/components/SolarBodyImage.qml \
    qml/components/TopSolarBodyImage.qml \
    qml/components/SolarBodyLabel.qml \
    qml/components/SideSolarBodyImage.qml \
    qml/components/SkySolarBodyImage.qml

