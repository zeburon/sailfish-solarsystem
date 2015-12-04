#include "orbitalelementsplanet.h"
#include <QtMath>

// -----------------------------------------------------------------------

const int OrbitalElementsPlanet::NUM_ITERATIONS = 5;

// -----------------------------------------------------------------------

OrbitalElementsPlanet::OrbitalElementsPlanet(QObject *parent) :
    OrbitalElements(parent), m_semi_major_axis_start(0.0f), m_semi_major_axis_per_century(0.0f),
    m_eccentricity_start(0.0f), m_eccentricity_per_century(0.0f),
    m_inclination_start(0.0f), m_inclination_per_century(0.0f),
    m_mean_longitude_start(0.0f), m_mean_longitude_per_century(0.0f), m_mean_anomaly_parameter_b(0.0f),
    m_mean_anomaly_parameter_c(0.0f), m_mean_anomaly_parameter_s(0.0f), m_mean_anomaly_parameter_f(0.0f),
    m_longitude_of_periapsis_start(0.0f), m_longitude_of_periapsis_per_century(0.0f),
    m_longitude_of_ascending_node_start(0.0f), m_longitude_of_ascending_node_per_century(0.0f)
{
}

// -----------------------------------------------------------------------

OrbitalElementsPlanet::~OrbitalElementsPlanet()
{
}

// -----------------------------------------------------------------------

void OrbitalElementsPlanet::updateElements()
{
    setSemiMajorAxis(m_semi_major_axis_start + m_centuries_since_j2000 * m_semi_major_axis_per_century);
    setEccentricity(m_eccentricity_start + m_centuries_since_j2000 * m_eccentricity_per_century);
    setInclination(qDegreesToRadians(m_inclination_start + m_centuries_since_j2000 * m_inclination_per_century));
    setLongitudeOfAscendingNode(qDegreesToRadians(m_longitude_of_ascending_node_start + m_centuries_since_j2000 * m_longitude_of_ascending_node_per_century));

    float mean_longitude = qDegreesToRadians(m_mean_longitude_start + m_centuries_since_j2000 * m_mean_longitude_per_century);
    float mean_anomaly_parameters = qDegreesToRadians(m_mean_anomaly_parameter_b) * m_centuries_since_j2000 * m_centuries_since_j2000
            + qDegreesToRadians(m_mean_anomaly_parameter_c) * qCos(qDegreesToRadians(m_mean_anomaly_parameter_f) * m_centuries_since_j2000)
            + qDegreesToRadians(m_mean_anomaly_parameter_s) * qSin(qDegreesToRadians(m_mean_anomaly_parameter_f) * m_centuries_since_j2000);
    float longitude_of_periapsis = qDegreesToRadians(m_longitude_of_periapsis_start + m_centuries_since_j2000 * m_longitude_of_periapsis_per_century);

    setArgumentOfPeriapsis(longitude_of_periapsis - m_longitude_of_ascending_node);
    setMeanAnomaly(mean_longitude - longitude_of_periapsis + mean_anomaly_parameters);
}

// -----------------------------------------------------------------------

void OrbitalElementsPlanet::updateCoordinates()
{
    float eccentric_anomaly = m_mean_anomaly + m_eccentricity * qSin(m_mean_anomaly);
    for (int iteration = 0; iteration < NUM_ITERATIONS; ++iteration)
    {
        float mean_anomaly_delta = m_mean_anomaly - (eccentric_anomaly - m_eccentricity * qSin(m_eccentricity));
        float eccentric_anomaly_delta = mean_anomaly_delta / (1.0f - m_eccentricity * qCos(eccentric_anomaly));
        eccentric_anomaly += eccentric_anomaly_delta;
    }

    float heliocentric_x = m_semi_major_axis * (qCos(eccentric_anomaly) - m_eccentricity);
    float heliocentric_y = m_semi_major_axis * qSqrt(1.0f - m_eccentricity * m_eccentricity) * qSin(eccentric_anomaly);

    float ecliptic_x = (qCos(m_argument_of_periapsis) * qCos(m_longitude_of_ascending_node) - qSin(m_argument_of_periapsis) * qSin(m_longitude_of_ascending_node) * qCos(m_inclination)) * heliocentric_x + (-qSin(m_argument_of_periapsis) * qCos(m_longitude_of_ascending_node) - qCos(m_argument_of_periapsis) * qSin(m_longitude_of_ascending_node) * qCos(m_inclination)) * heliocentric_y;
    float ecliptic_y = (qCos(m_argument_of_periapsis) * qSin(m_longitude_of_ascending_node) + qSin(m_argument_of_periapsis) * qCos(m_longitude_of_ascending_node) * qCos(m_inclination)) * heliocentric_x + (-qSin(m_argument_of_periapsis) * qSin(m_longitude_of_ascending_node) + qCos(m_argument_of_periapsis) * qCos(m_longitude_of_ascending_node) * qCos(m_inclination)) * heliocentric_y;
    float ecliptic_z = (qSin(m_argument_of_periapsis) * qSin(m_inclination)) * heliocentric_x + (qCos(m_argument_of_periapsis)* qSin(m_inclination)) * heliocentric_y;
    setCoordinates(ecliptic_x, -ecliptic_y, ecliptic_z);
}
