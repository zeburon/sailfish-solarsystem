#include "datetime.h"
#include <QtMath>

// -----------------------------------------------------------------------

DateTime::DateTime(QObject *parent) :
    QObject(parent), m_year(0), m_month(0), m_day(0), m_hours(0), m_minutes(0), m_seconds(0),
    m_daylight_savings_time(false), m_julian_day(0), m_days_since_j2000(0.0f), m_centuries_since_j2000(0.0f),
    m_mean_sidereal_time(0.0f)
{
}

// -----------------------------------------------------------------------

DateTime::~DateTime()
{
}

// -----------------------------------------------------------------------

void DateTime::set(int year, int month, int day, int hours, int minutes, int seconds)
{
    setDateTimeAndUpdate(QDateTime(QDate(year, month, day), QTime(hours, minutes, seconds)));
}

// -----------------------------------------------------------------------

void DateTime::setDate(int year, int month, int day)
{
    setDateTimeAndUpdate(QDateTime(QDate(year, month, day), m_date_time.time()));
}

// -----------------------------------------------------------------------

void DateTime::setTodaysDate()
{
    QDateTime date_time = QDateTime::currentDateTime();
    if (date_time.date() != m_date_time.date())
    {
        setDateTimeAndUpdate(date_time);
    }
}

// -----------------------------------------------------------------------

void DateTime::setTime(int hours, int minutes, int seconds)
{
    setDateTimeAndUpdate(QDateTime(m_date_time.date(), QTime(hours, minutes, seconds)));
}

// -----------------------------------------------------------------------

void DateTime::setNow()
{
    setDateTimeAndUpdate(QDateTime::currentDateTime());
}

// -----------------------------------------------------------------------

void DateTime::addDays(int days)
{
    setDateTimeAndUpdate(m_date_time.addDays(days));
}

// -----------------------------------------------------------------------

void DateTime::addSeconds(int seconds)
{
    setDateTimeAndUpdate(m_date_time.addSecs(seconds));
}

// -----------------------------------------------------------------------

void DateTime::setString(const QString &value)
{
    QDateTime date_time = QDateTime::fromString(value, Qt::ISODate);
    if (date_time.isValid())
    {
        setDateTimeAndUpdate(date_time);
    }
}

// -----------------------------------------------------------------------

QString DateTime::getString() const
{
    return m_date_time.toString(Qt::ISODate);
}

// -----------------------------------------------------------------------

void DateTime::setDateTimeAndUpdate(const QDateTime &date_time)
{
    if (!date_time.isValid())
    {
        setDateTimeAndUpdate(QDateTime::currentDateTime());
        return;
    }

    if (date_time == m_date_time)
        return;

    bool was_valid = m_date_time.isValid();
    m_date_time = date_time;
    if (!was_valid)
    {
        emit signalValidChanged();
    }

    int year = date_time.date().year();
    if (year != m_year)
    {
        m_year = year;
        emit signalYearChanged();
    }
    int month = date_time.date().month();
    if (month != m_month)
    {
        m_month = month;
        emit signalMonthChanged();
    }
    int day = date_time.date().day();
    if (day != m_day)
    {
        m_day = day;
        emit signalDayChanged();
    }
    int hours = date_time.time().hour();
    if (hours != m_hours)
    {
        m_hours = hours;
        emit signalHoursChanged();
    }
    int minutes = date_time.time().minute();
    if (minutes != m_minutes)
    {
        m_minutes = minutes;
        emit signalMinutesChanged();
    }
    int seconds = date_time.time().second();
    if (seconds != m_seconds)
    {
        m_seconds = seconds;
        emit signalSecondsChanged();
    }
    bool daylight_savings_time = date_time.isDaylightTime();
    if (daylight_savings_time != m_daylight_savings_time)
    {
        m_daylight_savings_time = daylight_savings_time;
        emit signalDaylightSavingsTimeChanged();
    }

    // calculate julian date
    float total_hours = m_hours + m_minutes / 60.0f + m_seconds / 3600.0f;
    if (m_daylight_savings_time)
    {
        total_hours -= 1.0f;
    }
    m_julian_day = date_time.date().toJulianDay();
    m_days_since_j2000 = m_julian_day - 2451543.5f + total_hours / 24.0f;
    m_centuries_since_j2000 = m_days_since_j2000 / 36525.0f;;

    // calculate mean sidereal time
    float t0 = 6.697374558f + m_centuries_since_j2000 * (2400.051336f + m_centuries_since_j2000 * 0.000025862f);
    m_mean_sidereal_time = fmod(t0 + total_hours * 1.002737909f, 24.0f);

    emit signalDaysSinceJ2000Changed();
    emit signalCenturiesSinceJ2000Changed();
    emit signalJulianDayChanged();
    emit signalMeanSiderealTimeChanged();
    emit signalValueChanged();
    emit signalStringChanged();
}

