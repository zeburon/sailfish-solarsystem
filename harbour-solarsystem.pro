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

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n
TRANSLATIONS += \
    translations/harbour-solarsystem-de.ts \
    translations/harbour-solarsystem-sv.ts

HEADERS += \
    src/orbitalelementsplanet.h \
    src/orbitalelements.h \
    src/orbitalelementsmoon.h \
    src/projector.h \
    src/datetime.h \
    src/orbitalelementssun.h

SOURCES += \
    src/harbour-solarsystem.cpp \
    src/orbitalelementsplanet.cpp \
    src/orbitalelements.cpp \
    src/orbitalelementsmoon.cpp \
    src/projector.cpp \
    src/datetime.cpp \
    src/orbitalelementssun.cpp

OTHER_FILES += \
    qml/harbour-solarsystem.qml \
    rpm/harbour-solarsystem.changes.in \
    rpm/harbour-solarsystem.spec \
    rpm/harbour-solarsystem.yaml \
    translations/*.ts \
    harbour-solarsystem.desktop \
    qml/gfx/sun_light.png \
    qml/gfx/sun_flares.png \
    qml/gfx/sun_flames.png \
    qml/gfx/shadow.png \
    qml/pages/MainPage.qml \
    qml/pages/AboutPage.qml \
    qml/storage.js \
    qml/gfx/shadow2.png \
    qml/globals.js \
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
    qml/components/DetailsElement.qml \
    qml/gfx/s_saturn_rings.png \
    qml/gfx/zoom_in.png \
    qml/gfx/zoom_out.png \
    qml/components/TopView.qml \
    qml/components/TopViewSolarBodyPainter.qml \
    qml/components/SkyView.qml \
    qml/components/SkyViewSolarBodyPainter.qml \
    qml/components/SolarBody.qml \
    qml/gfx/m_moon.png \
    qml/gfx/s_moon.png \
    qml/components/SolarSystem.qml \
    qml/components/SolarBodyImage.qml \
    qml/components/SolarBodyLabel.qml \
    qml/components/SideSolarBodyImage.qml \
    qml/components/Galaxy.qml \
    qml/components/Star.qml \
    qml/covers/MainCover.qml \
    qml/components/DateTimeDisplay.qml \
    qml/gfx/now.png \
    qml/components/NowButton.qml \
    qml/gfx/l_earth.png \
    qml/gfx/l_jupiter.png \
    qml/gfx/l_mars.png \
    qml/gfx/l_mercury.png \
    qml/gfx/l_neptune.png \
    qml/gfx/l_pluto.png \
    qml/gfx/l_saturn.png \
    qml/gfx/l_saturn_rings.png \
    qml/gfx/l_uranus.png \
    qml/gfx/l_venus.png \
    qml/gfx/l_moon.png \
    qml/components/SunImage.qml \
    qml/components/RiseAndSetLabel.qml \
    qml/components/TopViewSolarBodyImage.qml \
    qml/components/SkyViewSolarBodyImage.qml \
    qml/covers/RiseSetCoverContent.qml \
    qml/covers/DistanceCoverContent.qml \
    qml/components/SkyViewRotationSensor.qml \
    qml/gfx/sensor.png

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256
