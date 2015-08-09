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

function mod2pi(angle)
{
    var result = angle - Math.floor(angle / (Math.PI * 2.0)) * Math.PI * 2.0;
    if (result < -Math.PI)
    {
        result += 2.0 * Math.PI
    }
    return result;
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

function setDate(newDate)
{
    var year = newDate.getFullYear();
    var month = newDate.getMonth() + 1;
    var day = newDate.getDate();
    daysSinceJ2000 = 367 * year - (7 * (year + ((month + 9) / 12))) / 4 + (275 * month) / 9 + day - 730530;
    centuriesSinceJ2000 = daysSinceJ2000 / 36525;
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

function calculateEclipticCoordinates(planet)
{
    var a = planet.a1 + centuriesSinceJ2000 * planet.a2;
    var e = planet.e1 + centuriesSinceJ2000 * planet.e2;
    var i = deg2rad(planet.i1 + centuriesSinceJ2000 * planet.i2);
    var l = deg2rad(planet.l1 + centuriesSinceJ2000 * planet.l2);
    var w = deg2rad(planet.w1 + centuriesSinceJ2000 * planet.w2);
    var o = deg2rad(planet.o1 + centuriesSinceJ2000 * planet.o2);

    var b = deg2rad(planet.b);
    var c = deg2rad(planet.c);
    var s = deg2rad(planet.s);
    var f = deg2rad(planet.f);

    var ww = w - o;
    var m = mod2pi(l - w  + b * centuriesSinceJ2000 * centuriesSinceJ2000 + c * Math.cos(f * centuriesSinceJ2000) + s * Math.sin(f * centuriesSinceJ2000));
    var ea = iterate(m, e);

    var x = a * (Math.cos(ea) - e);
    var y = a * Math.sqrt(1.0 - e * e) * Math.sin(ea);

    var xEcliptic = (Math.cos(ww) * Math.cos(o) - Math.sin(ww) * Math.sin(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.cos(o) - Math.cos(ww) * Math.sin(o) * Math.cos(i)) * y;
    var yEcliptic = (Math.cos(ww) * Math.sin(o) + Math.sin(ww) * Math.cos(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.sin(o) + Math.cos(ww) * Math.cos(o) * Math.cos(i)) * y;
    var zEcliptic = (Math.sin(ww) * Math.sin(i)) * x + (Math.cos(ww)* Math.sin(i)) * y;

    return [xEcliptic * planet.positionCorrectionFactorX, yEcliptic * planet.positionCorrectionFactorY, zEcliptic];
}

// -----------------------------------------------------------------------

function updateEclipticCoordinates(planet)
{
    planet.eclipticCoordinates = calculateEclipticCoordinates(planet);
}

// -----------------------------------------------------------------------

function updateOldEclipticCoordinates(planet)
{
    planet.oldEclipticCoordinates = calculateEclipticCoordinates(planet);
}

// -----------------------------------------------------------------------

function updateDisplayedCoordinates(planet)
{
    var eclipticCoordinates = planet.eclipticCoordinates;
    var x, y, z;
    if (simplified)
    {
        var angle = Math.atan2(eclipticCoordinates[1], eclipticCoordinates[0]);
        x = planet.orbitSimplifiedRadius * Math.cos(angle);
        y = planet.orbitSimplifiedRadius * Math.sin(angle);
        z = 0.0;
    }
    else
    {
        x = au * eclipticCoordinates[0];
        y = au * eclipticCoordinates[1];
        z = au * eclipticCoordinates[2];
    }
    planet.displayedCoordinates = [Math.round(x), Math.round(-y), Math.round(z)];
}

// -----------------------------------------------------------------------

function getDistanceBetweenPlanets(planet1, planet2, useOldCoordinates)
{
    var eclipticCoordinates1 = useOldCoordinates ? planet1.oldEclipticCoordinates : planet1.eclipticCoordinates;
    var eclipticCoordinates2 = useOldCoordinates ? planet2.oldEclipticCoordinates : planet2.eclipticCoordinates;
    var dx = eclipticCoordinates1[0] - eclipticCoordinates2[0];
    var dy = eclipticCoordinates1[1] - eclipticCoordinates2[1];
    var dz = eclipticCoordinates1[2] - eclipticCoordinates2[2];
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}

// -----------------------------------------------------------------------

function getDistanceToSun(planet, useOldCoordinates)
{
    var eclipticCoordinates = useOldCoordinates ? planet.oldEclipticCoordinates : planet.eclipticCoordinates;
    var dx = eclipticCoordinates[0];
    var dy = eclipticCoordinates[1];
    var dz = eclipticCoordinates[2];
    return Math.sqrt(dx * dx + dy * dy + dz * dz);
}
