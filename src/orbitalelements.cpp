#include "orbitalelements.h"
#include <QtMath>

// -----------------------------------------------------------------------

OrbitalElements::OrbitalElements(QObject *parent) :
    QObject(parent), m_semi_major_axis(0.0f), m_eccentricity(0.0f), m_inclination(0.0f),
    m_mean_anomaly(0.0f), m_argument_of_periapsis(0.0f), m_longitude_of_ascending_node(0.0f),
    m_orbital_characteristics_calculated(false), m_average_distance(0.0f), m_minimum_distance(0.0f),
    m_maximum_distance(0.0f), m_period(0.0f), m_average_velocity(0.0f), m_centuries_since_j2000(0.0f),
    m_x(0.0f), m_y(0.0f), m_z(0.0f), m_longitude(0.0f), m_latitude(0.0f), m_distance(0.0f),
    m_previous_x(0.0f), m_previous_y(0.0f), m_previous_z(0.0f),
    m_previous_longitude(0.0f), m_previous_latitude(0.0f), m_previous_distance(0.0f)
{
}

// -----------------------------------------------------------------------

OrbitalElements::~OrbitalElements()
{
}

// -----------------------------------------------------------------------

void OrbitalElements::setSemiMajorAxis(float value)
{
    if (value != m_semi_major_axis)
    {
        m_semi_major_axis = value;
        emit signalSemiMajorAxisChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setEccentricity(float value)
{
    if (value != m_eccentricity)
    {
        m_eccentricity = value;
        emit signalEccentricityChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setInclination(float value)
{
    if (value != m_inclination)
    {
        m_inclination = value;
        emit signalInclinationChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setMeanAnomaly(float value)
{
    if (value != m_mean_anomaly)
    {
        m_mean_anomaly = value;
        emit signalMeanAnomalyChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setArgumentOfPeriapsis(float value)
{
    if (value != m_argument_of_periapsis)
    {
        m_argument_of_periapsis = value;
        emit signalArgumentOfPeriapsisChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setLongitudeOfAscendingNode(float value)
{
    if (value != m_longitude_of_ascending_node)
    {
        m_longitude_of_ascending_node = value;
        emit signalLongitudeOfAscendingNodeChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setCenturiesSinceJ2000(float value)
{
    if (value != m_centuries_since_j2000)
    {
        storePreviousCoordinates();

        m_centuries_since_j2000 = value;
        emit signalCenturiesSinceJ2000Changed();

        updateElements();
        updateCoordinates();
        updateOrbitalCharacteristics();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::updateOrbitalCharacteristics()
{
    float average_distance = m_semi_major_axis * (1.0f + m_eccentricity * m_eccentricity / 2.0f);
    if (average_distance != m_average_distance)
    {
        m_average_distance = average_distance;
        emit signalAverageDistanceChanged();
    }

    float minimum_distance = m_semi_major_axis * (1.0f - m_eccentricity);
    if (minimum_distance != m_minimum_distance)
    {
        m_minimum_distance = minimum_distance;
        emit signalMinimumDistanceChanged();
    }

    float maximum_distance = m_semi_major_axis * (1.0f + m_eccentricity);
    if (maximum_distance != m_minimum_distance)
    {
        m_maximum_distance = maximum_distance;
        emit signalMaximumDistanceChanged();
    }

    float period = 360.0f / m_mean_anomaly;
    if (period != m_period)
    {
        m_period = period;
        emit signalPeriodChanged();
    }

    float average_velocity = ((2.0f * M_PI * m_semi_major_axis * 1.4960e11) / (m_period * 365.25f * 24.0f * 3600.0f)) * (1.0f - (1.0f * qPow(m_eccentricity, 2)) / 4.0f - (3.0f * qPow(m_eccentricity, 4)) / 64.0f - (5.0f * qPow(m_eccentricity, 6)) / 256.0f - (175.0f * qPow(m_eccentricity, 8)) / 16384.0f);
    if (average_velocity != m_average_velocity)
    {
        m_average_velocity = average_velocity;
        emit signalAverageVelocityChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::setCoordinates(float x, float y, float z)
{
    if (x != m_x)
    {
        m_x = x;
        emit signalXChanged();
    }
    if (y != m_y)
    {
        m_y = y;
        emit signalYChanged();
    }
    if (z != m_z)
    {
        m_z = z;
        emit signalZChanged();
    }

    float longitude = calculateLongitude(x, y);
    if (longitude != m_longitude)
    {
        m_longitude = longitude;
        emit signalLongitudeChanged();
    }
    float latitude = calculateLatitude(z);
    if (latitude != m_latitude)
    {
        m_latitude = latitude;
        emit signalLatitudeChanged();
    }
    float distance = calculateDistance(x, y, z);
    if (distance != m_distance)
    {
        m_distance = distance;
        emit signalDistanceChanged();
    }
}

// -----------------------------------------------------------------------

void OrbitalElements::storePreviousCoordinates()
{
    if (m_x != m_previous_x)
    {
        m_previous_x = m_x;
        emit signalPreviousXChanged();
    }
    if (m_y != m_previous_y)
    {
        m_previous_y = m_y;
        emit signalPreviousYChanged();
    }
    if (m_z != m_previous_z)
    {
        m_previous_z = m_z;
        emit signalPreviousZChanged();
    }
    if (m_longitude != m_previous_longitude)
    {
        m_previous_longitude = m_longitude;
        emit signalPreviousLongitudeChanged();
    }
    if (m_latitude != m_previous_latitude)
    {
        m_previous_latitude = m_latitude;
        emit signalPreviousLatitudeChanged();
    }
    if (m_distance != m_previous_distance)
    {
        m_previous_distance = m_distance;
        emit signalPreviousDistanceChanged();
    }
}

// -----------------------------------------------------------------------

float OrbitalElements::mod2pi(float angle) const
{
    float result = fmod(angle, 2.0f * M_PI);
    if (result < -M_PI)
    {
        result += 2.0 * M_PI;
    }
    return result;
}

// -----------------------------------------------------------------------

float OrbitalElements::calculateLongitude(float x, float y) const
{
    float longitude = qRadiansToDegrees(mod2pi(qAtan2(y, x)));
    if (longitude < 0.0f)
    {
        longitude += 360.0f;
    }
    return longitude;
}

// -----------------------------------------------------------------------

float OrbitalElements::calculateLatitude(float z) const
{
    return qRadiansToDegrees(qAsin(z / m_semi_major_axis));
}

// -----------------------------------------------------------------------

float OrbitalElements::calculateDistance(float x, float y, float z) const
{
    return qSqrt(x * x + y * y + z * z);
}
