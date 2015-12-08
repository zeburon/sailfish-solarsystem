#include "projector.h"
#include "datetime.h"
#include <QtMath>
#include <QDebug>

// -----------------------------------------------------------------------

const float Projector::AXIAL_TILT_COS                   = qCos(qDegreesToRadians(-23.43f));
const float Projector::AXIAL_TILT_SIN                   = qSin(qDegreesToRadians(-23.43f));
const QVector3D Projector::INVISIBLE_SCREEN_COORDINATES = QVector3D(0.0f, 0.0f, -1.0f);

// -----------------------------------------------------------------------

Projector::Projector(QObject *parent) : QObject(parent), m_date_time(0),
    m_longitude(0.0f), m_latitude(0.0f), m_longitude_offset(0.0f), m_latitude_offset(0.0f),
    m_width(0.0f), m_height(0.0f), m_projected_size(0.0f), m_zoom(0.0f), m_field_of_view(0.0f),
    m_field_of_view_tan(0.0f)
{
}

// -----------------------------------------------------------------------

Projector::~Projector()
{
}

// -----------------------------------------------------------------------

void Projector::update()
{
    if (!m_date_time)
        return;

    m_projected_size = qMax(m_width, m_height) / 2.0f;
    m_field_of_view_tan = qTan(qDegreesToRadians(m_field_of_view / 2.0f));

    float limited_latitude = qMax(-89.9f, qMin(89.9f, m_latitude));
    float offset = -(m_date_time->getMeanSiderealTime() / 24.0f) * 360.0f;
    m_azimuthal_up = sphericalToRectangularCoordinates(offset, qMin(89.9f, limited_latitude), 1.0f);
    m_azimuthal_right.setX(m_azimuthal_up.y());
    m_azimuthal_right.setY(-m_azimuthal_up.x());
    m_azimuthal_right.normalize();
    m_azimuthal_view = QVector3D::crossProduct(m_azimuthal_right, m_azimuthal_up);
    m_azimuthal_view.normalize();

    m_eye_view = sphericalToRectangularCoordinates(m_longitude_offset - 90.0f, m_latitude_offset, 1.0f);
    m_eye_right.setX(m_eye_view.y());
    m_eye_right.setY(-m_eye_view.x());
    m_eye_right.setZ(0.0f);
    m_eye_right.normalize();
    m_eye_up = QVector3D::crossProduct(m_eye_right, m_eye_view);
    m_eye_up.normalize();

    m_eye_right = toAzimuthalCoordinates(m_eye_right);
    m_eye_view = toAzimuthalCoordinates(m_eye_view);
    m_eye_up = toAzimuthalCoordinates(m_eye_up);
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularEquatorialToScreenCoordinates(const QVector3D &coordinates) const
{
    return eyeToScreenCoordinates(toEyeCoordinates(coordinates));
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularEquatorialToScreenCoordinates(float x, float y, float z) const
{
    return rectangularEquatorialToScreenCoordinates(QVector3D(x, y, z));
}

// -----------------------------------------------------------------------

QVector3D Projector::sphericalEquatorialToScreenCoordinates(float longitude, float latitude, float distance) const
{
    return rectangularEquatorialToScreenCoordinates(sphericalToRectangularCoordinates(longitude, latitude, distance));
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularEclipticToScreenCoordinates(const QVector3D &coordinates) const
{
    QVector3D equatorial_coordinates = eclipticToEquatorialCoordinates(coordinates);
    return rectangularEquatorialToScreenCoordinates(equatorial_coordinates);
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularEclipticToScreenCoordinates(float x, float y, float z) const
{
    return rectangularEclipticToScreenCoordinates(QVector3D(x, y, z));
}

// -----------------------------------------------------------------------

QVector3D Projector::sphericalEclipticToScreenCoordinates(float longitude, float latitude, float distance) const
{
    return rectangularEclipticToScreenCoordinates(sphericalToRectangularCoordinates(longitude, latitude, distance));
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularAzimuthalToScreenCoordinates(const QVector3D &coordinates) const
{
    QVector3D azimuthal_coordinates = toAzimuthalCoordinates(coordinates);

    QVector3D eye_coordinates;
    eye_coordinates.setX(azimuthal_coordinates.x() * m_eye_right.x() + azimuthal_coordinates.y() * m_eye_right.y() + azimuthal_coordinates.z() * m_eye_right.z());
    eye_coordinates.setY(azimuthal_coordinates.x() * m_eye_view.x()  + azimuthal_coordinates.y() * m_eye_view.y()  + azimuthal_coordinates.z() * m_eye_view.z());
    eye_coordinates.setZ(azimuthal_coordinates.x() * m_eye_up.x()    + azimuthal_coordinates.y() * m_eye_up.y()    + azimuthal_coordinates.z() * m_eye_up.z());
    return eyeToScreenCoordinates(eye_coordinates);
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularAzimuthalToScreenCoordinates(float x, float y, float z) const
{
    return rectangularAzimuthalToScreenCoordinates(QVector3D(x, y, z));
}

// -----------------------------------------------------------------------

QVector3D Projector::sphericalAzimuthalToScreenCoordinates(float longitude, float latitude, float distance) const
{
    return rectangularAzimuthalToScreenCoordinates(sphericalToRectangularCoordinates(longitude, latitude, distance));
}

// -----------------------------------------------------------------------

float Projector::getImageRotation(float longitude, float latitude) const
{
    QVector3D projected_coordinates1 = sphericalEclipticToScreenCoordinates(longitude, latitude, 1.0f);
    QVector3D projected_coordinates2 = sphericalEclipticToScreenCoordinates(longitude + 0.01f, latitude, 1.0f);
    return qRadiansToDegrees(qAtan2(projected_coordinates2.x() - projected_coordinates1.x(),
                                    -(projected_coordinates2.y() - projected_coordinates1.y()))) + 90.0f;
}

// -----------------------------------------------------------------------

QVector3D Projector::sphericalToRectangularCoordinates(float longitude, float latitude, float distance) const
{
    longitude = qDegreesToRadians(longitude);
    latitude = qDegreesToRadians(latitude);

    QVector3D rectangular_coordinates;
    rectangular_coordinates.setX(distance * qCos(latitude) * qCos(longitude));
    rectangular_coordinates.setY(distance * qCos(latitude) * qSin(longitude));
    rectangular_coordinates.setZ(distance * qSin(latitude));
    return rectangular_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::eclipticToEquatorialCoordinates(const QVector3D &ecliptic_coordinates) const
{
    QVector3D equatorial_coordinates;
    equatorial_coordinates.setX(ecliptic_coordinates.x());
    equatorial_coordinates.setY(AXIAL_TILT_COS * ecliptic_coordinates.y() - AXIAL_TILT_SIN * ecliptic_coordinates.z());
    equatorial_coordinates.setZ(AXIAL_TILT_SIN * ecliptic_coordinates.y() + AXIAL_TILT_COS * ecliptic_coordinates.z());
    return equatorial_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::equatorialToEclipticCoordinates(const QVector3D &equatorial_coordinates) const
{
    QVector3D ecliptic_coordinates;
    ecliptic_coordinates.setX(equatorial_coordinates.x());
    ecliptic_coordinates.setY(AXIAL_TILT_COS * equatorial_coordinates.y() + AXIAL_TILT_SIN * equatorial_coordinates.z());
    ecliptic_coordinates.setZ(-AXIAL_TILT_SIN * equatorial_coordinates.y() + AXIAL_TILT_COS * equatorial_coordinates.z());
    return ecliptic_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::toAzimuthalCoordinates(const QVector3D &coordinates) const
{
    QVector3D azimuthal_coordinates;
    azimuthal_coordinates.setX(coordinates.x() * m_azimuthal_right.x() + coordinates.y() * m_azimuthal_view.x() + coordinates.z() * m_azimuthal_up.x());
    azimuthal_coordinates.setY(coordinates.x() * m_azimuthal_right.y() + coordinates.y() * m_azimuthal_view.y() + coordinates.z() * m_azimuthal_up.y());
    azimuthal_coordinates.setZ(coordinates.x() * m_azimuthal_right.z() + coordinates.y() * m_azimuthal_view.z() + coordinates.z() * m_azimuthal_up.z());
    return azimuthal_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::toEyeCoordinates(const QVector3D &coordinates) const
{
    QVector3D eye_coordinates;
    eye_coordinates.setX(coordinates.x() * m_eye_right.x() + coordinates.y() * m_eye_right.y() + coordinates.z() * m_eye_right.z());
    eye_coordinates.setY(coordinates.x() * m_eye_view.x()  + coordinates.y() * m_eye_view.y()  + coordinates.z() * m_eye_view.z());
    eye_coordinates.setZ(coordinates.x() * m_eye_up.x()    + coordinates.y() * m_eye_up.y()    + coordinates.z() * m_eye_up.z());
    return eye_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::eyeToScreenCoordinates(const QVector3D &eye_coordinates) const
{
    // make sure we only calculate visible coordinates
    if (eye_coordinates.y() < 0.001f)
        return INVISIBLE_SCREEN_COORDINATES;

    float distance = m_zoom / eye_coordinates.y();

    QVector3D normalized_coordinates;
    normalized_coordinates.setX(distance * eye_coordinates.x() / m_field_of_view_tan);
    normalized_coordinates.setZ(distance * eye_coordinates.z() / m_field_of_view_tan);
    float normalized_length = qCos(normalized_coordinates.length());

    // hide coordinates that are not facing the user
    if (normalized_length < 0.3f)
        return INVISIBLE_SCREEN_COORDINATES;

    float k = m_zoom * (1.0f + normalized_length);
    QVector3D projected_coordinates;
    projected_coordinates.setX(m_projected_size * normalized_coordinates.x() * k);
    projected_coordinates.setY(-m_projected_size * normalized_coordinates.z() * k);
    projected_coordinates.setZ(eye_coordinates.y());
    return projected_coordinates;
}
