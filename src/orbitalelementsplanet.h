#ifndef ORBITALELEMENTSPLANET_H
#define ORBITALELEMENTSPLANET_H

#include "orbitalelements.h"

// -----------------------------------------------------------------------

class OrbitalElementsPlanet : public OrbitalElements
{
    Q_OBJECT

    Q_PROPERTY(float semiMajorAxisStart MEMBER m_semi_major_axis_start NOTIFY signalSemiMajorAxisStartChanged)
    Q_PROPERTY(float semiMajorAxisPerCentury MEMBER m_semi_major_axis_per_century NOTIFY signalSemiMajorAxisPerCenturyChanged)

    Q_PROPERTY(float eccentricityStart MEMBER m_eccentricity_start NOTIFY signalEccentricityStartChanged)
    Q_PROPERTY(float eccentricityPerCentury MEMBER m_eccentricity_per_century NOTIFY signalEccentricityPerCenturyChanged)

    Q_PROPERTY(float inclinationStart MEMBER m_inclination_start NOTIFY signalInclinationStartChanged)
    Q_PROPERTY(float inclinationPerCentury MEMBER m_inclination_per_century NOTIFY signalInclinationPerCenturyChanged)

    Q_PROPERTY(float meanLongitudeStart MEMBER m_mean_longitude_start NOTIFY signalMeanLongitudeStartChanged)
    Q_PROPERTY(float meanLongitudePerCentury MEMBER m_mean_longitude_per_century NOTIFY signalMeanLongitudePerCenturyChanged)

    Q_PROPERTY(float meanAnomalyParameterB MEMBER m_mean_anomaly_parameter_b NOTIFY signalMeanAnomalyParameterBChanged)
    Q_PROPERTY(float meanAnomalyParameterC MEMBER m_mean_anomaly_parameter_c NOTIFY signalMeanAnomalyParameterCChanged)
    Q_PROPERTY(float meanAnomalyParameterS MEMBER m_mean_anomaly_parameter_s NOTIFY signalMeanAnomalyParameterSChanged)
    Q_PROPERTY(float meanAnomalyParameterF MEMBER m_mean_anomaly_parameter_f NOTIFY signalMeanAnomalyParameterFChanged)

    Q_PROPERTY(float longitudeOfPeriapsisStart MEMBER m_longitude_of_periapsis_start NOTIFY signalLongitudeOfPeriapsisStartChanged)
    Q_PROPERTY(float longitudeOfPeriapsisPerCentury MEMBER m_longitude_of_periapsis_per_century NOTIFY signalLongitudeOfPeriapsisPerCenturyChanged)

    Q_PROPERTY(float longitudeOfAscendingNodeStart MEMBER m_longitude_of_ascending_node_start NOTIFY signalLongitudeOfAscendingNodeStartChanged)
    Q_PROPERTY(float longitudeOfAscendingNodePerCentury MEMBER m_longitude_of_ascending_node_per_century NOTIFY signalLongitudeOfAscendingNodePerCenturyChanged)

public:
    explicit OrbitalElementsPlanet(QObject *parent = 0);
    virtual ~OrbitalElementsPlanet();

signals:
    void signalSemiMajorAxisStartChanged();
    void signalSemiMajorAxisPerCenturyChanged();
    void signalEccentricityStartChanged();
    void signalEccentricityPerCenturyChanged();
    void signalInclinationStartChanged();
    void signalInclinationPerCenturyChanged();
    void signalMeanLongitudeStartChanged();
    void signalMeanLongitudePerCenturyChanged();
    void signalMeanAnomalyParameterBChanged();
    void signalMeanAnomalyParameterCChanged();
    void signalMeanAnomalyParameterSChanged();
    void signalMeanAnomalyParameterFChanged();
    void signalLongitudeOfPeriapsisStartChanged();
    void signalLongitudeOfPeriapsisPerCenturyChanged();
    void signalLongitudeOfAscendingNodeStartChanged();
    void signalLongitudeOfAscendingNodePerCenturyChanged();

protected:
    virtual void updateElements();
    virtual void updateCoordinates();

private:
    static const int NUM_ITERATIONS;

    float m_semi_major_axis_start;
    float m_semi_major_axis_per_century;

    float m_eccentricity_start;
    float m_eccentricity_per_century;

    float m_inclination_start;
    float m_inclination_per_century;

    float m_mean_longitude_start;
    float m_mean_longitude_per_century;

    float m_mean_anomaly_parameter_b;
    float m_mean_anomaly_parameter_c;
    float m_mean_anomaly_parameter_s;
    float m_mean_anomaly_parameter_f;

    float m_longitude_of_periapsis_start;
    float m_longitude_of_periapsis_per_century;

    float m_longitude_of_ascending_node_start;
    float m_longitude_of_ascending_node_per_century;

};

// -----------------------------------------------------------------------

#endif // ORBITALELEMENTSPLANET_H
