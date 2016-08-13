#ifndef ORBITALELEMENTSMOON_H
#define ORBITALELEMENTSMOON_H

#include "orbitalelements.h"

// -----------------------------------------------------------------------

class OrbitalElementsMoon : public OrbitalElements
{
    Q_OBJECT

    Q_PROPERTY(float meanDistanceStart MEMBER m_mean_distance_start NOTIFY signalMeanDistanceStartChanged)
    Q_PROPERTY(float meanDistancePerCentury MEMBER m_mean_distance_per_century NOTIFY signalMeanDistancePerCenturyChanged)

    Q_PROPERTY(float eccentricityStart MEMBER m_eccentricity_start NOTIFY signalEccentricityStartChanged)
    Q_PROPERTY(float eccentricityPerCentury MEMBER m_eccentricity_per_century NOTIFY signalEccentricityPerCenturyChanged)

    Q_PROPERTY(float inclinationStart MEMBER m_inclination_start NOTIFY signalInclinationStartChanged)
    Q_PROPERTY(float inclinationPerCentury MEMBER m_inclination_per_century NOTIFY signalInclinationPerCenturyChanged)

    Q_PROPERTY(float meanAnomalyStart MEMBER m_mean_anomaly_start NOTIFY signalMeanAnomalyStartChanged)
    Q_PROPERTY(float meanAnomalyPerCentury MEMBER m_mean_anomaly_per_century NOTIFY signalMeanAnomalyPerCenturyChanged)

    Q_PROPERTY(float argumentOfPeriapsisStart MEMBER m_argument_of_periapsis_start NOTIFY signalArgumentOfPeriapsisStartChanged)
    Q_PROPERTY(float argumentOfPeriapsisPerCentury MEMBER m_argument_of_periapsis_per_century NOTIFY signalArgumentOfPeriapsisPerCenturyChanged)

    Q_PROPERTY(float longitudeOfAscendingNodeStart MEMBER m_longitude_of_ascending_node_start NOTIFY signalLongitudeOfAscendingNodeStartChanged)
    Q_PROPERTY(float longitudeOfAscendingNodePerCentury MEMBER m_longitude_of_ascending_node_per_century NOTIFY signalLongitudeOfAscendingNodePerCenturyChanged)

public:
    explicit OrbitalElementsMoon(QObject *parent = 0);
    virtual ~OrbitalElementsMoon();

signals:
    void signalMeanDistanceStartChanged();
    void signalMeanDistancePerCenturyChanged();
    void signalEccentricityStartChanged();
    void signalEccentricityPerCenturyChanged();
    void signalInclinationStartChanged();
    void signalInclinationPerCenturyChanged();
    void signalMeanAnomalyStartChanged();
    void signalMeanAnomalyPerCenturyChanged();
    void signalArgumentOfPeriapsisStartChanged();
    void signalArgumentOfPeriapsisPerCenturyChanged();
    void signalLongitudeOfAscendingNodeStartChanged();
    void signalLongitudeOfAscendingNodePerCenturyChanged();
    void signalPeriodOverrideChanged();

protected:
    virtual void updateElements();
    virtual void updateCoordinates();
    virtual void updateOrbitalLongitudeChangePerDay();

private:
    float m_mean_distance_start;
    float m_mean_distance_per_century;

    float m_eccentricity_start;
    float m_eccentricity_per_century;

    float m_inclination_start;
    float m_inclination_per_century;

    float m_mean_anomaly_start;
    float m_mean_anomaly_per_century;

    float m_argument_of_periapsis_start;
    float m_argument_of_periapsis_per_century;

    float m_longitude_of_ascending_node_start;
    float m_longitude_of_ascending_node_per_century;
};

// -----------------------------------------------------------------------

#endif // ORBITALELEMENTSMOON_H
