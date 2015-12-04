#ifndef PROJECTOR_H
#define PROJECTOR_H

#include <QObject>
#include <QVector3D>
#include <QVariantList>

class DateTime;

// -----------------------------------------------------------------------

class Projector : public QObject
{
    Q_OBJECT

    Q_PROPERTY(DateTime* dateTime MEMBER m_date_time NOTIFY signalDateTimeChanged)
    Q_PROPERTY(float longitude MEMBER m_longitude NOTIFY signalLongitudeChanged)
    Q_PROPERTY(float latitude MEMBER m_latitude NOTIFY signalLatitudeChanged)
    Q_PROPERTY(float longitudeOffset MEMBER m_longitude_offset NOTIFY signalLongitudeOffsetChanged)
    Q_PROPERTY(float latitudeOffset MEMBER m_latitude_offset NOTIFY signalLatitudeOffsetChanged)
    Q_PROPERTY(float width MEMBER m_width NOTIFY signalWidthChanged)
    Q_PROPERTY(float height MEMBER m_height NOTIFY signalHeightChanged)
    Q_PROPERTY(float zoom MEMBER m_zoom NOTIFY signalZoomChanged)
    Q_PROPERTY(float fieldOfView MEMBER m_field_of_view NOTIFY signalFieldOfViewChanged)

public:
    explicit Projector(QObject *parent = 0);
    virtual ~Projector();

    Q_INVOKABLE void update();

    Q_INVOKABLE QVector3D rectangularEquatorialToScreenCoordinates(const QVector3D &coordinates) const;
    Q_INVOKABLE QVector3D rectangularEquatorialToScreenCoordinates(float x, float y, float z) const;
    Q_INVOKABLE QVector3D sphericalEquatorialToScreenCoordinates(float longitude, float latitude, float distance = 1.0f) const;

    Q_INVOKABLE QVector3D rectangularEclipticToScreenCoordinates(const QVector3D &coordinates) const;
    Q_INVOKABLE QVector3D rectangularEclipticToScreenCoordinates(float x, float y, float z) const;
    Q_INVOKABLE QVector3D sphericalEclipticToScreenCoordinates(float longitude, float latitude, float distance = 1.0f) const;

    Q_INVOKABLE QVector3D rectangularAzimuthalToScreenCoordinates(const QVector3D &coordinates) const;
    Q_INVOKABLE QVector3D rectangularAzimuthalToScreenCoordinates(float x, float y, float z) const;
    Q_INVOKABLE QVector3D sphericalAzimuthalToScreenCoordinates(float longitude, float latitude, float distance = 1.0f) const;

    Q_INVOKABLE float getImageRotation(float longitude, float latitude) const;

signals:
    void signalDateTimeChanged();
    void signalMeanSiderealTimeChanged();
    void signalLongitudeChanged();
    void signalLatitudeChanged();
    void signalLongitudeOffsetChanged();
    void signalLatitudeOffsetChanged();
    void signalWidthChanged();
    void signalHeightChanged();
    void signalZoomChanged();
    void signalFieldOfViewChanged();

private:
    static const float AXIAL_TILT_COS;
    static const float AXIAL_TILT_SIN;

    QVector3D sphericalToRectangularCoordinates(float longitude, float latitude, float distance) const;
    QVector3D eclipticToEquatorialCoordinates(const QVector3D &coordinates) const;
    QVector3D equatorialToEclipticCoordinates(const QVector3D &coordinates) const;
    QVector3D toAzimuthalCoordinates(const QVector3D &coordinates) const;
    QVector3D toEyeCoordinates(const QVector3D &coordinates) const;
    QVector3D eyeToScreenCoordinates(const QVector3D &eye_coordinates) const;

    QVector3D m_eye_up;
    QVector3D m_eye_right;
    QVector3D m_eye_view;

    QVector3D m_azimuthal_up;
    QVector3D m_azimuthal_right;
    QVector3D m_azimuthal_view;

    DateTime *m_date_time;
    float m_longitude;
    float m_latitude;
    float m_longitude_offset;
    float m_latitude_offset;
    float m_width;
    float m_height;
    float m_projected_size;
    float m_zoom;
    float m_field_of_view;
    float m_field_of_view_tan;

};

// -----------------------------------------------------------------------

#endif // PROJECTOR_H
