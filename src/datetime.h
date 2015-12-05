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
    Q_PROPERTY(int seconds READ getSeconds NOTIFY signalSecondsChanged)

    Q_PROPERTY(int julianDay READ getJulianDay NOTIFY signalJulianDayChanged)
    Q_PROPERTY(float daysSinceJ2000 READ getDaysSinceJ2000 NOTIFY signalDaysSinceJ2000Changed)
    Q_PROPERTY(float centuriesSinceJ2000 READ getCenturiesSinceJ2000 NOTIFY signalCenturiesSinceJ2000Changed)
    Q_PROPERTY(float meanSiderealTime READ getMeanSiderealTime NOTIFY signalMeanSiderealTimeChanged)

    Q_PROPERTY(bool daylightSavingsTime READ isDaylightSavingsTime NOTIFY signalDaylightSavingsTimeChanged)
    Q_PROPERTY(QString timezone READ getTimezone NOTIFY signalTimezoneChanged)

    Q_PROPERTY(QString string READ getString WRITE setString NOTIFY signalStringChanged)
    Q_PROPERTY(QDateTime value READ getValue NOTIFY signalValueChanged)

public:
    explicit DateTime(QObject *parent = 0);
    virtual ~DateTime();

    Q_INVOKABLE void set(int year, int month, int day, int hours, int minutes, int seconds = 0);
    Q_INVOKABLE void setNow();
    Q_INVOKABLE void setToday();

    Q_INVOKABLE void addDays(int days);
    Q_INVOKABLE void addSeconds(int seconds);

    int getYear() const { return m_year; }
    int getMonth() const { return m_month; }
    int getDay() const { return m_day; }
    int getHours() const { return m_hours; }
    int getMinutes() const { return m_minutes; }
    int getSeconds() const { return m_seconds; }
    bool isDaylightSavingsTime() const { return m_daylight_savings_time; }
    const QString &getTimezone() const { return m_timezone; }
    int getJulianDay() const { return m_julian_day; }
    float getDaysSinceJ2000() const { return m_days_since_j2000; }
    float getCenturiesSinceJ2000() const { return m_centuries_since_j2000; }
    float getMeanSiderealTime() const { return m_mean_sidereal_time; }
    void setString(const QString &string);
    QString getString() const;
    const QDateTime &getValue() const { return m_date_time; }

signals:
    void signalYearChanged();
    void signalMonthChanged();
    void signalDayChanged();
    void signalHoursChanged();
    void signalMinutesChanged();
    void signalSecondsChanged();
    void signalDaylightSavingsTimeChanged();
    void signalTimezoneChanged();
    void signalDaysSinceJ2000Changed();
    void signalCenturiesSinceJ2000Changed();
    void signalJulianDayChanged();
    void signalMeanSiderealTimeChanged();
    void signalStringChanged();
    void signalValueChanged();

private:
    void setDateTimeAndUpdate(const QDateTime &date_time);

    QDateTime m_date_time;

    int m_year;
    int m_month;
    int m_day;
    int m_hours;
    int m_minutes;
    int m_seconds;
    bool m_daylight_savings_time;
    QString m_timezone;

    int m_julian_day;
    float m_days_since_j2000;
    float m_centuries_since_j2000;
    float m_mean_sidereal_time;

};

// -----------------------------------------------------------------------

#endif // DATETIME_H
