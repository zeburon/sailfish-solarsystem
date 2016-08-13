#ifndef ORBITALELEMENTSSUN_H
#define ORBITALELEMENTSSUN_H

#include "orbitalelements.h"

// -----------------------------------------------------------------------

class OrbitalElementsSun : public OrbitalElements
{
    Q_OBJECT

public:
    explicit OrbitalElementsSun(QObject *parent = 0);
    virtual ~OrbitalElementsSun();

protected:
    virtual void updateElements();
    virtual void updateCoordinates();
};

// -----------------------------------------------------------------------

#endif // ORBITALELEMENTSSUN_H
