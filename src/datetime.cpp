#include "datetime.h"
#include <QtMath>

// -----------------------------------------------------------------------

DateTime::DateTime(QObject *parent) :
    QObject(parent), m_year(0), m_month(0), m_day(0), m_hours(0), m_minutes(0),
    m_daylight_savings_time(false), m_julian_day(0), m_days_since_j2000(0.0f),
    m_centuries_since_j2000(0.0f), m_mean_sidereal_time(0.0f), m_obliquity_of_ecliptic(0.0f)
{
}

// -----------------------------------------------------------------------

DateTime::~DateTime()
{
}

// -----------------------------------------------------------------------

void DateTime::set(int year, int month, int day, int hours, int minutes)
{
    setDateTimeAndUpdate(QDateTime(QDate(year, month, day), QTime(hours, minutes)));
}

// -----------------------------------------------------------------------

void DateTime::setDate(int year, int month, int day)
{
    setDateTimeAndUpdate(QDateTime(QDate(year, month, day), m_date_time.time()));
}

// -----------------------------------------------------------------------

void DateTime::setTodaysDate()
{
    setDateTimeAndUpdate(QDateTime(QDate::currentDate(), m_date_time.time()));
}

// -----------------------------------------------------------------------

void DateTime::setTime(int hours, int minutes)
{
    setDateTimeAndUpdate(QDateTime(m_date_time.date(), QTime(hours, minutes)));
}

// -----------------------------------------------------------------------

void DateTime::setCurrentTime()
{
    setDateTimeAndUpdate(QDateTime(m_date_time.date(), QTime::currentTime()));
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

void DateTime::addMinutes(int minutes)
{
    setDateTimeAndUpdate(m_date_time.addSecs(minutes * 60));
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
        setNow();
        return;
    }
    QDateTime date_time_without_seconds = QDateTime(date_time.date(), QTime(date_time.time().hour(), date_time.time().minute()));
    if (date_time_without_seconds == m_date_time)
        return;

    bool was_valid = m_date_time.isValid();
    m_date_time = date_time_without_seconds;
    if (!was_valid)
    {
        emit signalValidChanged();
    }

    int year = m_date_time.date().year();
    if (year != m_year)
    {
        m_year = year;
        emit signalYearChanged();
    }
    int month = m_date_time.date().month();
    if (month != m_month)
    {
        m_month = month;
        emit signalMonthChanged();
    }
    int day = m_date_time.date().day();
    if (day != m_day)
    {
        m_day = day;
        emit signalDayChanged();
    }
    int hours = m_date_time.time().hour();
    if (hours != m_hours)
    {
        m_hours = hours;
        emit signalHoursChanged();
    }
    int minutes = m_date_time.time().minute();
    if (minutes != m_minutes)
    {
        m_minutes = minutes;
        emit signalMinutesChanged();
    }
    bool daylight_savings_time = m_date_time.isDaylightTime();
    if (daylight_savings_time != m_daylight_savings_time)
    {
        m_daylight_savings_time = daylight_savings_time;
        emit signalDaylightSavingsTimeChanged();
    }

    // calculate julian date
    float total_hours = m_hours + m_minutes / 60.0f;
    if (m_daylight_savings_time)
    {
        total_hours -= 1.0f;
    }
    m_julian_day = m_date_time.date().toJulianDay();
    m_days_since_j2000 = m_julian_day - 2451543.5f + total_hours / 24.0f;
    m_centuries_since_j2000 = m_days_since_j2000 / 36525.0f;

    // calculate mean sidereal time
    float t0 = 6.697374558f + m_centuries_since_j2000 * (2400.051336f + m_centuries_since_j2000 * 0.000025862f);
    m_mean_sidereal_time = fmod(t0 + total_hours * 1.002737909f, 24.0f);

    // calculate obliquity of ecliptic
    m_obliquity_of_ecliptic = 23.0f + 26.0f / 60.0f + 21.448f / 3600.0f -
            (46.8150f * m_centuries_since_j2000 +
             0.00059f * m_centuries_since_j2000 * m_centuries_since_j2000 -
             0.001813f * m_centuries_since_j2000 * m_centuries_since_j2000 * m_centuries_since_j2000) / 3600.0f;

    emit signalDaysSinceJ2000Changed();
    emit signalCenturiesSinceJ2000Changed();
    emit signalJulianDayChanged();
    emit signalMeanSiderealTimeChanged();
    emit signalObliquityOfEclipticChanged();
    emit signalValueChanged();
    emit signalStringChanged();
}
