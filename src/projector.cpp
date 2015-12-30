#include "projector.h"
#include "datetime.h"
#include <QtMath>
#include <QDebug>

// -----------------------------------------------------------------------

const QVector3D Projector::INVISIBLE_SCREEN_COORDINATES = QVector3D(0.0f, 0.0f, -1.0f);

// -----------------------------------------------------------------------

Projector::Projector(QObject *parent) : QObject(parent), m_date_time(0),
    m_longitude(0.0f), m_latitude(0.0f), m_longitude_look_offset(0.0f), m_latitude_look_offset(0.0f),
    m_width(0.0f), m_height(0.0f), m_projected_size(0.0f), m_zoom(0.0f), m_field_of_view(0.0f),
    m_field_of_view_tan(0.0f), m_obliquity_of_ecliptic_sin(0.0f), m_obliquity_of_ecliptic_cos(0.0f)
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
    m_obliquity_of_ecliptic_sin = qSin(qDegreesToRadians(-m_date_time->getObliquityOfEcliptic()));
    m_obliquity_of_ecliptic_cos = qCos(qDegreesToRadians(-m_date_time->getObliquityOfEcliptic()));

    // azimuthal coordinate system @current point in time
    float latitude_limited = qMax(-89.9f, qMin(89.9f, m_latitude));
    float longitude_offset = -(m_date_time->getMeanSiderealTime() / 24.0f) * 360.0f;
    m_azimuthal_up = sphericalToRectangularCoordinates(longitude_offset, qMin(89.9f, latitude_limited));
    m_azimuthal_right.setX(m_azimuthal_up.y());
    m_azimuthal_right.setY(-m_azimuthal_up.x());
    m_azimuthal_right.normalize();
    m_azimuthal_view = QVector3D::crossProduct(m_azimuthal_right, m_azimuthal_up);
    m_azimuthal_view.normalize();

    // coordinate system @current location
    m_current_view = sphericalToRectangularCoordinates(-90.0f, 0.0f);
    m_current_right.setX(m_current_view.y());
    m_current_right.setY(-m_current_view.x());
    m_current_right.setZ(0.0f);
    m_current_right.normalize();
    m_current_up = QVector3D::crossProduct(m_current_right, m_current_view);
    m_current_up.normalize();

    m_current_right = toAzimuthalCoordinates(m_current_right);
    m_current_view = toAzimuthalCoordinates(m_current_view);
    m_current_up = toAzimuthalCoordinates(m_current_up);

    // coordinate system @current location using view direction
    m_look_view = sphericalToRectangularCoordinates(m_longitude_look_offset - 90.0f, m_latitude_look_offset);
    m_look_right.setX(m_look_view.y());
    m_look_right.setY(-m_look_view.x());
    m_look_right.setZ(0.0f);
    m_look_right.normalize();
    m_look_up = QVector3D::crossProduct(m_look_right, m_look_view);
    m_look_up.normalize();

    m_look_right = toAzimuthalCoordinates(m_look_right);
    m_look_view = toAzimuthalCoordinates(m_look_view);
    m_look_up = toAzimuthalCoordinates(m_look_up);
}

// -----------------------------------------------------------------------

QVector3D Projector::rectangularEquatorialToScreenCoordinates(const QVector3D &coordinates) const
{
    return toScreenCoordinates(coordinates);
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
    return toScreenCoordinates(toAzimuthalCoordinates(coordinates));
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

QVector2D Projector::eclipticToAzimuthalCoordinates(float longitude, float latitude) const
{
    QVector3D azimuthal_coordinates = (toCurrentCoordinates(eclipticToEquatorialCoordinates(sphericalToRectangularCoordinates(longitude, latitude))));

    float azimuthal_longitude = qRadiansToDegrees(qAtan2(-azimuthal_coordinates.y(), -azimuthal_coordinates.x())) - 90.0f;
    if (azimuthal_longitude < 0.0f)
    {
        azimuthal_longitude += 360.0f;
    }
    float azimuthal_latitude = qRadiansToDegrees(qAsin(azimuthal_coordinates.z()));
    return QVector2D(azimuthal_longitude, azimuthal_latitude);
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
    equatorial_coordinates.setY(m_obliquity_of_ecliptic_cos * ecliptic_coordinates.y() - m_obliquity_of_ecliptic_sin * ecliptic_coordinates.z());
    equatorial_coordinates.setZ(m_obliquity_of_ecliptic_sin * ecliptic_coordinates.y() + m_obliquity_of_ecliptic_cos * ecliptic_coordinates.z());
    return equatorial_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::equatorialToEclipticCoordinates(const QVector3D &equatorial_coordinates) const
{
    QVector3D ecliptic_coordinates;
    ecliptic_coordinates.setX(equatorial_coordinates.x());
    ecliptic_coordinates.setY(m_obliquity_of_ecliptic_cos * equatorial_coordinates.y() + m_obliquity_of_ecliptic_sin * equatorial_coordinates.z());
    ecliptic_coordinates.setZ(-m_obliquity_of_ecliptic_sin * equatorial_coordinates.y() + m_obliquity_of_ecliptic_cos * equatorial_coordinates.z());
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

QVector3D Projector::toCurrentCoordinates(const QVector3D &coordinates) const
{
    QVector3D normal_coordinates;
    normal_coordinates.setX(coordinates.x() * m_current_right.x() + coordinates.y() * m_current_right.y() + coordinates.z() * m_current_right.z());
    normal_coordinates.setY(coordinates.x() * m_current_view.x()  + coordinates.y() * m_current_view.y()  + coordinates.z() * m_current_view.z());
    normal_coordinates.setZ(coordinates.x() * m_current_up.x()    + coordinates.y() * m_current_up.y()    + coordinates.z() * m_current_up.z());
    return normal_coordinates;
}

// -----------------------------------------------------------------------

QVector3D Projector::toScreenCoordinates(const QVector3D &coordinates) const
{
    QVector3D look_coordinates;
    look_coordinates.setX(coordinates.x() * m_look_right.x() + coordinates.y() * m_look_right.y() + coordinates.z() * m_look_right.z());
    look_coordinates.setY(coordinates.x() * m_look_view.x()  + coordinates.y() * m_look_view.y()  + coordinates.z() * m_look_view.z());
    look_coordinates.setZ(coordinates.x() * m_look_up.x()    + coordinates.y() * m_look_up.y()    + coordinates.z() * m_look_up.z());

    // make sure we only calculate visible coordinates
    if (look_coordinates.y() < 0.001f)
        return INVISIBLE_SCREEN_COORDINATES;

    float distance = m_zoom / look_coordinates.y();

    QVector3D normalized_coordinates;
    normalized_coordinates.setX(distance * look_coordinates.x() / m_field_of_view_tan);
    normalized_coordinates.setZ(distance * look_coordinates.z() / m_field_of_view_tan);
    float normalized_length = qCos(normalized_coordinates.length());

    // hide coordinates that are not facing the user
    if (normalized_length < 0.3f)
        return INVISIBLE_SCREEN_COORDINATES;

    float k = m_zoom * (1.0f + normalized_length);
    QVector3D projected_coordinates;
    projected_coordinates.setX(m_projected_size * normalized_coordinates.x() * k);
    projected_coordinates.setY(-m_projected_size * normalized_coordinates.z() * k);
    projected_coordinates.setZ(look_coordinates.y());
    return projected_coordinates;
}
