#ifndef ORBITALELEMENTS_H
#define ORBITALELEMENTS_H

#include <QObject>

// -----------------------------------------------------------------------

class OrbitalElements : public QObject
{
    Q_OBJECT

    Q_PROPERTY(float semiMajorAxis READ getSemiMajorAxis NOTIFY signalSemiMajorAxisChanged)
    Q_PROPERTY(float eccentricity READ getEccentricity NOTIFY signalEccentricityChanged)
    Q_PROPERTY(float inclination READ getInclination NOTIFY signalInclinationChanged)
    Q_PROPERTY(float meanAnomaly READ getMeanAnomaly NOTIFY signalMeanAnomalyChanged)
    Q_PROPERTY(float argumentOfPeriapsis READ getArgumentOfPeriapsis NOTIFY signalArgumentOfPeriapsisChanged)
    Q_PROPERTY(float longitudeOfAscendingNode READ getLongitudeOfAscendingNode NOTIFY signalLongitudeOfAscendingNodeChanged)

    Q_PROPERTY(float averageDistance READ getAverageDistance NOTIFY signalAverageDistanceChanged)
    Q_PROPERTY(float minimumDistance READ getMinimumDistance NOTIFY signalMinimumDistanceChanged)
    Q_PROPERTY(float maximumDistance READ getMaximumDistance NOTIFY signalMaximumDistanceChanged)
    Q_PROPERTY(float period READ getPeriod WRITE setPeriod NOTIFY signalPeriodChanged)
    Q_PROPERTY(float averageLongitudeChangePerDay READ getAverageLongitudeChangePerDay NOTIFY signalAverageLongitudeChangePerDayChanged)
    Q_PROPERTY(float averageVelocity READ getAverageVelocity NOTIFY signalAverageVelocityChanged)

    Q_PROPERTY(float centuriesSinceJ2000 READ getCenturiesSinceJ2000 WRITE setCenturiesSinceJ2000 NOTIFY signalCenturiesSinceJ2000Changed)

    Q_PROPERTY(float x READ getX NOTIFY signalXChanged)
    Q_PROPERTY(float y READ getY NOTIFY signalYChanged)
    Q_PROPERTY(float z READ getZ NOTIFY signalZChanged)
    Q_PROPERTY(float longitude READ getLongitude NOTIFY signalLongitudeChanged)
    Q_PROPERTY(float latitude READ getLatitude NOTIFY signalLatitudeChanged)
    Q_PROPERTY(float distance READ getDistance NOTIFY signalDistanceChanged)

public:
    explicit OrbitalElements(QObject *parent = 0);
    virtual ~OrbitalElements();

    float getSemiMajorAxis() const { return m_semi_major_axis; }
    float getEccentricity() const { return m_eccentricity; }
    float getInclination() const { return m_inclination; }
    float getMeanAnomaly() const { return m_mean_anomaly; }
    float getArgumentOfPeriapsis() const { return m_argument_of_periapsis; }
    float getLongitudeOfAscendingNode() const { return m_longitude_of_ascending_node; }

    float getAverageDistance() const { return m_average_distance; }
    float getMinimumDistance() const { return m_minimum_distance; }
    float getMaximumDistance() const { return m_maximum_distance; }
    void setPeriod(float period);
    float getPeriod() const  { return m_period; }
    float getAverageLongitudeChangePerDay() const  { return m_average_longitude_change_per_day; }
    float getAverageVelocity() const { return m_average_velocity; }

    void setCenturiesSinceJ2000(float value);
    float getCenturiesSinceJ2000() const { return m_centuries_since_j2000; }

    float getX() const { return m_x; }
    float getY() const { return m_y; }
    float getZ() const { return m_z; }
    float getLongitude() const { return m_longitude; }
    float getLatitude() const { return m_latitude; }
    float getDistance() const { return m_distance; }

signals:
    void signalSemiMajorAxisChanged();
    void signalEccentricityChanged();
    void signalInclinationChanged();
    void signalMeanAnomalyChanged();
    void signalArgumentOfPeriapsisChanged();
    void signalLongitudeOfAscendingNodeChanged();

    void signalAverageDistanceChanged();
    void signalMinimumDistanceChanged();
    void signalMaximumDistanceChanged();
    void signalPeriodChanged();
    void signalAverageLongitudeChangePerDayChanged();
    void signalAverageVelocityChanged();

    void signalCenturiesSinceJ2000Changed();

    void signalXChanged();
    void signalYChanged();
    void signalZChanged();
    void signalLongitudeChanged();
    void signalLatitudeChanged();
    void signalDistanceChanged();

protected:
    virtual void updateElements() = 0;
    virtual void updateCoordinates() = 0;
    virtual void updateOrbitalCharacteristics();
    virtual void updateOrbitalDistances();
    virtual void updateOrbitalLongitudeChangePerDay();
    virtual void updateOrbitalVelocity();

    void setSemiMajorAxis(float value);
    void setEccentricity(float value);
    void setInclination(float value);
    void setMeanAnomaly(float value);
    void setArgumentOfPeriapsis(float value);
    void setLongitudeOfAscendingNode(float value);
    void setCoordinates(float x, float y, float z);

    float mod2pi(float angle) const;
    float calculateLongitude(float x, float y) const;
    float calculateLatitude(float z) const;
    float calculateDistance(float x, float y, float z) const;

    float m_semi_major_axis;
    float m_eccentricity;
    float m_inclination;
    float m_mean_anomaly;
    float m_argument_of_periapsis;
    float m_longitude_of_ascending_node;

    bool m_orbital_characteristics_calculated;
    float m_average_distance;
    float m_minimum_distance;
    float m_maximum_distance;
    float m_period;
    float m_average_longitude_change_per_day;
    float m_average_velocity;

    float m_centuries_since_j2000;

    float m_x;
    float m_y;
    float m_z;
    float m_longitude;
    float m_latitude;
    float m_distance;

};

// -----------------------------------------------------------------------

#endif // ORBITALELEMENTS_H
