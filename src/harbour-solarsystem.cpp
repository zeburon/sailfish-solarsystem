#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include "orbitalelementsmoon.h"
#include "orbitalelementsplanet.h"
#include "orbitalelementssun.h"
#include "projector.h"
#include "datetime.h"

int main(int argc, char *argv[])
{
    qmlRegisterUncreatableType<OrbitalElements>("harbour.solarsystem.OrbitalElements", 1, 0, "OrbitalElements", "Nono!");
    qmlRegisterType<OrbitalElementsMoon>("harbour.solarsystem.OrbitalElementsMoon", 1, 0, "OrbitalElementsMoon");
    qmlRegisterType<OrbitalElementsPlanet>("harbour.solarsystem.OrbitalElementsPlanet", 1, 0, "OrbitalElementsPlanet");
    qmlRegisterType<OrbitalElementsSun>("harbour.solarsystem.OrbitalElementsSun", 1, 0, "OrbitalElementsSun");
    qmlRegisterType<Projector>("harbour.solarsystem.Projector", 1, 0, "Projector");
    qmlRegisterType<DateTime>("harbour.solarsystem.DateTime", 1, 0, "DateTime");

    return SailfishApp::main(argc, argv);
}
