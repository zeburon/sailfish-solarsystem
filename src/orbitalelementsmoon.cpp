#include "orbitalelementsmoon.h"
#include <QtMath>

// -----------------------------------------------------------------------

OrbitalElementsMoon::OrbitalElementsMoon(QObject *parent) :
    OrbitalElements(parent), m_mean_distance_start(0.0f), m_mean_distance_per_century(0.0f), m_eccentricity_start(0.0f),
    m_eccentricity_per_century(0.0f), m_inclination_start(0.0f), m_inclination_per_century(0.0f), m_mean_anomaly_start(0.0f),
    m_mean_anomaly_per_century(0.0f), m_argument_of_periapsis_start(0.0f), m_argument_of_periapsis_per_century(0.0f),
    m_longitude_of_ascending_node_start(0.0f), m_longitude_of_ascending_node_per_century(0.0f)
{
}

// -----------------------------------------------------------------------

OrbitalElementsMoon::~OrbitalElementsMoon()
{
}

// -----------------------------------------------------------------------

void OrbitalElementsMoon::updateElements()
{
    setSemiMajorAxis(m_mean_distance_start + m_centuries_since_j2000 * m_mean_distance_per_century);
    setEccentricity(m_eccentricity_start + m_centuries_since_j2000 * m_eccentricity_per_century);
    setInclination(qDegreesToRadians(m_inclination_start + m_centuries_since_j2000 * m_inclination_per_century));
    setMeanAnomaly(qDegreesToRadians(m_mean_anomaly_start + m_centuries_since_j2000 * m_mean_anomaly_per_century));
    setArgumentOfPeriapsis(qDegreesToRadians(m_argument_of_periapsis_start + m_centuries_since_j2000 * m_argument_of_periapsis_per_century));
    setLongitudeOfAscendingNode(qDegreesToRadians(m_longitude_of_ascending_node_start + m_centuries_since_j2000 * m_longitude_of_ascending_node_per_century));
}

// -----------------------------------------------------------------------

void OrbitalElementsMoon::updateCoordinates()
{
    float e0 = m_mean_anomaly + m_eccentricity * qSin(m_mean_anomaly) * (1.0 + m_eccentricity * qCos(m_mean_anomaly));
    float e1 = e0 - (e0 - m_eccentricity * qSin(e0) - m_mean_anomaly) / (1.0 - m_eccentricity * qCos(e0));
    float eccentric_anomaly = e1;

    float x = m_semi_major_axis * (qCos(eccentric_anomaly) - m_eccentricity);
    float y = m_semi_major_axis * qSqrt(1.0f - m_eccentricity * m_eccentricity) * qSin(eccentric_anomaly);

    float distance = qSqrt(x * x + y * y);
    float true_anomaly = qAtan2(y, x);
    float true_anomaly_plus_argument_of_periapsis = true_anomaly + m_argument_of_periapsis;

    float x_ecliptic = distance * (qCos(m_longitude_of_ascending_node) * qCos(true_anomaly_plus_argument_of_periapsis) - qSin(m_longitude_of_ascending_node) * qSin(true_anomaly_plus_argument_of_periapsis) * qCos(m_inclination));
    float y_ecliptic = distance * (qSin(m_longitude_of_ascending_node) * qCos(true_anomaly_plus_argument_of_periapsis) + qCos(m_longitude_of_ascending_node) * qSin(true_anomaly_plus_argument_of_periapsis) * qCos(m_inclination));
    float z_ecliptic = distance * qSin(true_anomaly_plus_argument_of_periapsis) * qSin(m_inclination);

    float longitude = calculateLongitude(x_ecliptic, y_ecliptic);
    float latitude  = calculateLatitude(z_ecliptic);
    distance = calculateDistance(x_ecliptic, y_ecliptic, z_ecliptic);

    float sun_mean_anomaly = qDegreesToRadians(356.0470f + m_centuries_since_j2000 * 35999.0494417125f);
    float sun_longitude_of_periapsis = qDegreesToRadians(282.9404f + m_centuries_since_j2000 * 1.7200900875f);
    float sun_mean_longitude = sun_mean_anomaly + sun_longitude_of_periapsis;
    float mean_longitude = m_mean_anomaly + m_longitude_of_ascending_node + m_argument_of_periapsis;
    float mean_elongation = mean_longitude - sun_mean_longitude;
    float argument_of_latitude = mean_longitude - m_longitude_of_ascending_node;

    longitude +=
            - 1.274f * qSin(m_mean_anomaly - 2.0f * mean_elongation) // evection
            + 0.658f * qSin(2.0f * mean_elongation)                  // variation
            - 0.186f * qSin(sun_mean_anomaly)                        // yearly equation
            - 0.059f * qSin(2.0f * m_mean_anomaly - 2.0f * mean_elongation)
            - 0.057f * qSin(m_mean_anomaly - 2.0f * mean_elongation + sun_mean_anomaly)
            + 0.053f * qSin(m_mean_anomaly + 2.0f * mean_elongation)
            + 0.046f * qSin(2.0f * mean_elongation - sun_mean_anomaly)
            + 0.041f * qSin(m_mean_anomaly - sun_mean_anomaly)
            - 0.035f * qSin(mean_elongation)                         // parallactic equation
            - 0.031f * qSin(m_mean_anomaly + sun_mean_anomaly)
            - 0.015f * qSin(2.0f * argument_of_latitude - 2.0f * mean_elongation)
            + 0.011f * qSin(m_mean_anomaly - 4.0f * mean_elongation);

    latitude +=
            - 0.173f * qSin(argument_of_latitude - 2.0f * mean_elongation)
            - 0.055f * qSin(m_mean_anomaly - argument_of_latitude - 2.0f * mean_elongation)
            - 0.046f * qSin(m_mean_anomaly + argument_of_latitude - 2.0f * mean_elongation)
            + 0.033f * qSin(argument_of_latitude + 2.0f * mean_elongation)
            + 0.017f * qSin(2.0f * m_mean_anomaly + argument_of_latitude);

    distance += (m_semi_major_axis / 60.2666f) *
            (-0.58f * qCos(m_mean_anomaly - 2.0f * mean_elongation)
            - 0.46f * qCos(2.0f * mean_elongation));

    longitude = qDegreesToRadians(longitude);
    latitude = qDegreesToRadians(latitude);
    x_ecliptic = distance * qCos(latitude) * qCos(longitude);
    y_ecliptic = distance * qCos(latitude) * qSin(longitude);
    z_ecliptic = distance * qSin(latitude);

    setCoordinates(x_ecliptic, -y_ecliptic, z_ecliptic);
}

// -----------------------------------------------------------------------

void OrbitalElementsMoon::updateOrbitalLongitudeChangePerDay()
{
    // inverted direction
    float average_longitude_change_per_day = -360.0f / (m_period * 365.25f);
    if (average_longitude_change_per_day != m_average_longitude_change_per_day)
    {
        m_average_longitude_change_per_day = average_longitude_change_per_day;
        emit signalAverageLongitudeChangePerDayChanged();
    }
}
