var julianDate;
var daysSinceJ2000;
var centuriesSinceJ2000;

// use simplified calculation
var simplified = true;

// size of one astronomical unit
var au;

// precision of iterate function
var numIterations = 3;

// -----------------------------------------------------------------------

function deg2rad(angle)
{
    return angle * Math.PI / 180.0;
}

// -----------------------------------------------------------------------

function rad2deg(angle)
{
    return angle * 180.0 / Math.PI;
}

// -----------------------------------------------------------------------

function mod2pi(angle)
{
    var result = angle - Math.floor(angle / (Math.PI * 2.0)) * Math.PI * 2.0;
    if (result < -Math.PI)
    {
        result += 2.0 * Math.PI;
    }
    return result;
}

// -----------------------------------------------------------------------

function mod360(angle)
{
    var result = angle % 360.0;
    if (result < 0)
    {
        result += 360.0;
    }
    return result;
}

// -----------------------------------------------------------------------

function getFraction(value)
{
    return value - Math.floor(value);
}

// -----------------------------------------------------------------------

function isDateValid(d)
{
    if (Object.prototype.toString.call(d) !== "[object Date]")
    {
        return false;
    }
    return !isNaN(d.getTime());
}

// -----------------------------------------------------------------------

function setDateIfChanged(newDate)
{
    var year = newDate.getFullYear();
    var month = newDate.getMonth() + 1;
    var day = newDate.getDate();

    var newDaysSinceJ2000 = 367 * year - Math.floor((7 * (year + Math.floor((month + 9) / 12))) / 4) + Math.floor((275 * month) / 9) + day - 730530;
    if (newDaysSinceJ2000 === daysSinceJ2000)
        return false;

    daysSinceJ2000 = newDaysSinceJ2000;
    centuriesSinceJ2000 = daysSinceJ2000 / 36525;

    julianDate = 2415020.5 - 64; // 1.1.1900 - correction of algorithm
    if (month <= 2)
    {
        year--;
        month += 12;
    }
    julianDate += Math.floor((year - 1900) * 365.25);
    julianDate += Math.floor(30.6001 * (1 + month));
    julianDate += day + 0.5;
    return true;
}

// -----------------------------------------------------------------------

function getLongitudeOffset(hours)
{
    var jd = Math.floor(julianDate - 0.5) + 0.5; // JD at 0 hours UT
    var t = (jd - 2451545.0) / 36525.0;
    var t0 = 6.697374558 + t * (2400.051336 + t * 0.000025862);
    var meanSiderealTime = (t0 + (hours % 24) * 1.002737909) % 24;
    return (meanSiderealTime / 24) * 360;
}

// -----------------------------------------------------------------------

function setOrbitParameters(newAu, newSimplified)
{
    au = newAu;
    simplified = newSimplified;
}

// -----------------------------------------------------------------------

function iterate(m, e)
{
    var ea = m + e * Math.sin(m);
    for (var i = 0; i < numIterations; ++i)
    {
        var dm = m - (ea - e * Math.sin(e));
        var dea = dm / (1.0 - e * Math.cos(ea));
        ea += dea;
    }
    return ea;
}

// -----------------------------------------------------------------------

function calculateEclipticCoordinates(planetConfig)
{
    var a = planetConfig.a1 + centuriesSinceJ2000 * planetConfig.a2;
    var e = planetConfig.e1 + centuriesSinceJ2000 * planetConfig.e2;
    var i = deg2rad(planetConfig.i1 + centuriesSinceJ2000 * planetConfig.i2);
    var l = deg2rad(planetConfig.l1 + centuriesSinceJ2000 * planetConfig.l2);
    var w = deg2rad(planetConfig.w1 + centuriesSinceJ2000 * planetConfig.w2);
    var o = deg2rad(planetConfig.o1 + centuriesSinceJ2000 * planetConfig.o2);

    var x = 0, y = 0;
    var xEcliptic = 0 , yEcliptic = 0, zEcliptic = 0;
    if (planetConfig.name === "Moon")
    {
        var e0 = (l + e * Math.sin(l) * (1.0 + e * Math.cos(l)));
        var e1 = mod2pi(e0 - (e0 - e * Math.sin(e0) - l) / (1.0 - e * Math.cos(e0)));

        x = a * (Math.cos(e1) - e);
        y = a * Math.sqrt(1.0 - e * e) * Math.sin(e1);

        var r = Math.sqrt(x * x + y * y); // distance
        var v = mod2pi(Math.atan2(y, x)); // true anomaly

        xEcliptic = r * (Math.cos(o) * Math.cos(v + w) - Math.sin(o) * Math.sin(v + w) * Math.cos(i));
        yEcliptic = r * (Math.sin(o) * Math.cos(v + w) + Math.cos(o) * Math.sin(v + w) * Math.cos(i));
        zEcliptic = r * Math.sin(v + w) * Math.sin(i);

        var lon = rad2deg(mod2pi(Math.atan2(yEcliptic, xEcliptic)));
        var lat = rad2deg(Math.asin(zEcliptic / r));

        var lSun = deg2rad(mod360(356.0470 + centuriesSinceJ2000 * 35999.0494417125)); // Sun's  mean anomaly
        var sw = deg2rad(mod360(282.9404 + centuriesSinceJ2000 * 1.7059620375)); // sun longitude of perihelion
        var Ls = mod2pi(sw + lSun); // Sun's  mean longitude
        var Lm = o + w + l; // Moon's mean longitude
        var D =  Lm - Ls; // Moon's mean elongation
        var F =  Lm - o; // Moon's argument of latitude

        lon +=  -1.274 * Math.sin(l - 2 * D) //    (Evection)
                +0.658 * Math.sin(2 * D)      //   (Variation)
                -0.186 * Math.sin(lSun)       //   (Yearly equation)
                -0.059 * Math.sin(2 * l - 2 * D)
                -0.057 * Math.sin(l - 2 * D + lSun)
                +0.053 * Math.sin(l + 2 * D)
                +0.046 * Math.sin(2 * D - lSun)
                +0.041 * Math.sin(l - lSun)
                -0.035 * Math.sin(D)         //   (Parallactic equation)
                -0.031 * Math.sin(l + lSun)
                -0.015 * Math.sin(2 * F - 2 * D)
                +0.011 * Math.sin(l - 4 * D);

        lat +=  -0.173 * Math.sin(F - 2 * D)
                -0.055 * Math.sin(l - F - 2 * D)
                -0.046 * Math.sin(l + F - 2 * D)
                +0.033 * Math.sin(F + 2 * D)
                +0.017 * Math.sin(2 * l + F);
    }
    else
    {
        var b = deg2rad(planetConfig.b);
        var c = deg2rad(planetConfig.c);
        var s = deg2rad(planetConfig.s);
        var f = deg2rad(planetConfig.f);

        var ww = w - o;
        var m = mod2pi(l - w  + b * centuriesSinceJ2000 * centuriesSinceJ2000 + c * Math.cos(f * centuriesSinceJ2000) + s * Math.sin(f * centuriesSinceJ2000));
        var ea = iterate(m, e);

        x = a * (Math.cos(ea) - e);
        y = a * Math.sqrt(1.0 - e * e) * Math.sin(ea);

        xEcliptic = (Math.cos(ww) * Math.cos(o) - Math.sin(ww) * Math.sin(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.cos(o) - Math.cos(ww) * Math.sin(o) * Math.cos(i)) * y;
        yEcliptic = (Math.cos(ww) * Math.sin(o) + Math.sin(ww) * Math.cos(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.sin(o) + Math.cos(ww) * Math.cos(o) * Math.cos(i)) * y;
        zEcliptic = (Math.sin(ww) * Math.sin(i)) * x + (Math.cos(ww)* Math.sin(i)) * y;

        /*
        var lon = rad2deg(mod2pi(Math.atan2(yEcliptic, xEcliptic)));
        var lat = rad2deg(Math.asin(zEcliptic / a));
        console.log("LON: " + lon);
        console.log("LAT: " + lat);
        */
    }

    return [xEcliptic * planetConfig.orbitCorrectionFactorX, yEcliptic * planetConfig.orbitCorrectionFactorY, zEcliptic];
}

// -----------------------------------------------------------------------

function updateEclipticCoordinates(planetPosition)
{
    planetPosition.eclipticCoordinates = calculateEclipticCoordinates(planetPosition.planetConfig);
}

// -----------------------------------------------------------------------

function updateOldEclipticCoordinates(planetPosition)
{
    planetPosition.oldEclipticCoordinates = calculateEclipticCoordinates(planetPosition.planetConfig);
}

// -----------------------------------------------------------------------

function updateDisplayedCoordinates(planetPosition)
{
    var eclipticCoordinates = planetPosition.eclipticCoordinates;
    var x, y, z;
    if (simplified)
    {
        var angle = Math.atan2(eclipticCoordinates[1], eclipticCoordinates[0]);
        x = planetPosition.orbitSimplifiedRadius * Math.cos(angle);
        y = planetPosition.orbitSimplifiedRadius * Math.sin(angle);
        z = 0.0;
    }
    else
    {
        x = au * eclipticCoordinates[0];
        y = au * eclipticCoordinates[1];
        z = au * eclipticCoordinates[2];
    }
    planetPosition.displayedCoordinates = [x, -y, z];
}

// -----------------------------------------------------------------------

function getDistanceBetweenPlanets(planetPosition1, planetPosition2, useOldCoordinates)
{
    var eclipticCoordinates1 = useOldCoordinates ? planetPosition1.oldEclipticCoordinates : planetPosition1.eclipticCoordinates;
    var eclipticCoordinates2 = useOldCoordinates ? planetPosition2.oldEclipticCoordinates : planetPosition2.eclipticCoordinates;
    var dx = eclipticCoordinates1[0] - eclipticCoordinates2[0];
    var dy = eclipticCoordinates1[1] - eclipticCoordinates2[1];
    var dz = eclipticCoordinates1[2] - eclipticCoordinates2[2];
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}

// -----------------------------------------------------------------------

function getDistanceToSun(planetPosition, useOldCoordinates)
{
    var eclipticCoordinates = useOldCoordinates ? planetPosition.oldEclipticCoordinates : planetPosition.eclipticCoordinates;
    var dx = eclipticCoordinates[0];
    var dy = eclipticCoordinates[1];
    var dz = eclipticCoordinates[2];
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}
