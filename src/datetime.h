#ifndef DATETIME_H
#define DATETIME_H

#include <QObject>
#include <QDateTime>

// -----------------------------------------------------------------------

class DateTime : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int year READ getYear NOTIFY signalYearChanged)
    Q_PROPERTY(int month READ getMonth NOTIFY signalMonthChanged)
    Q_PROPERTY(int day READ getDay NOTIFY signalDayChanged)
    Q_PROPERTY(int hours READ getHours NOTIFY signalHoursChanged)
    Q_PROPERTY(int minutes READ getMinutes NOTIFY signalMinutesChanged)

    Q_PROPERTY(int julianDay READ getJulianDay NOTIFY signalJulianDayChanged)
    Q_PROPERTY(float daysSinceJ2000 READ getDaysSinceJ2000 NOTIFY signalDaysSinceJ2000Changed)
    Q_PROPERTY(float centuriesSinceJ2000 READ getCenturiesSinceJ2000 NOTIFY signalCenturiesSinceJ2000Changed)
    Q_PROPERTY(float siderealTime READ getSiderealTime NOTIFY signalSiderealTimeChanged)
    Q_PROPERTY(float obliquityOfEcliptic READ getObliquityOfEcliptic NOTIFY signalObliquityOfEclipticChanged)

    Q_PROPERTY(bool daylightSavingsTime READ isDaylightSavingsTime NOTIFY signalDaylightSavingsTimeChanged)
    Q_PROPERTY(QString timezone READ getTimezone NOTIFY signalTimezoneChanged)

    Q_PROPERTY(QString string READ getString WRITE setString NOTIFY signalStringChanged)
    Q_PROPERTY(QDateTime value READ getValue NOTIFY signalValueChanged)
    Q_PROPERTY(bool valid READ isValid NOTIFY signalValidChanged)

public:
    explicit DateTime(QObject *parent = 0);
    virtual ~DateTime();

    Q_INVOKABLE void set(int year, int month, int day, int hours, int minutes);
    Q_INVOKABLE void setDate(int year, int month, int day);
    Q_INVOKABLE void setTodaysDate();
    Q_INVOKABLE void setTime(int hours, int minutes);
    Q_INVOKABLE void setCurrentTime();
    Q_INVOKABLE void setNow();

    Q_INVOKABLE void addDays(int days);
    Q_INVOKABLE void addMinutes(int minutes);

    int getYear() const { return m_year; }
    int getMonth() const { return m_month; }
    int getDay() const { return m_day; }
    int getHours() const { return m_hours; }
    int getMinutes() const { return m_minutes; }
    bool isDaylightSavingsTime() const { return m_daylight_savings_time; }
    const QString &getTimezone() const { return m_timezone; }
    int getJulianDay() const { return m_julian_day; }
    float getDaysSinceJ2000() const { return m_days_since_j2000; }
    float getCenturiesSinceJ2000() const { return m_centuries_since_j2000; }
    float getSiderealTime() const { return m_sidereal_time; }
    float getObliquityOfEcliptic() const { return m_obliquity_of_ecliptic; }
    void setString(const QString &string);
    QString getString() const;
    const QDateTime &getValue() const { return m_date_time; }
    bool isValid() const { return m_date_time.isValid(); }

signals:
    void signalYearChanged();
    void signalMonthChanged();
    void signalDayChanged();
    void signalHoursChanged();
    void signalMinutesChanged();
    void signalDaylightSavingsTimeChanged();
    void signalTimezoneChanged();
    void signalDaysSinceJ2000Changed();
    void signalCenturiesSinceJ2000Changed();
    void signalJulianDayChanged();
    void signalSiderealTimeChanged();
    void signalObliquityOfEclipticChanged();
    void signalStringChanged();
    void signalValueChanged();
    void signalValidChanged();

private:
    void setDateTimeAndUpdate(const QDateTime &date_time);

    QDateTime m_date_time;

    int m_year;
    int m_month;
    int m_day;
    int m_hours;
    int m_minutes;
    bool m_daylight_savings_time;
    QString m_timezone;

    int m_julian_day;
    float m_days_since_j2000;
    float m_centuries_since_j2000;
    float m_sidereal_time;
    float m_obliquity_of_ecliptic;

};

// -----------------------------------------------------------------------

#endif // DATETIME_H
