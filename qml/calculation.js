var daysSinceJ2000;
var centuriesSinceJ2000;

// size of one astronomical unit
var au;

// use simplified calculation
var simplified = true;

// precision of iterate function
var numIterations = 3;

function deg2rad(angle)
{
    return angle * Math.PI / 180.0;
}

function mod2pi(angle)
{
    var result = angle - Math.floor(angle / (Math.PI * 2.0)) * Math.PI * 2.0;
    if (result < -Math.PI)
    {
        result += 2.0 * Math.PI
    }
    return result;
}

function setDate(newDate)
{
    var year = newDate.getFullYear();
    var month = newDate.getMonth() + 1;
    var day = newDate.getDate();
    daysSinceJ2000 = 367 * year - (7 * (year + ((month + 9) / 12))) / 4 + (275 * month) / 9 + day - 730530;
    centuriesSinceJ2000 = daysSinceJ2000 / 36525;
}

function setOrbitParameters(newAu, newSimplified)
{
    au = newAu;
    simplified = newSimplified;
}

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

function calculateEclipticCoordinates(planet)
{
    var a = planet.a1 + centuriesSinceJ2000 * planet.a2;
    var e = planet.e1 + centuriesSinceJ2000 * planet.e2;
    var i = deg2rad(planet.i1 + centuriesSinceJ2000 * planet.i2);
    var l = deg2rad(planet.l1 + centuriesSinceJ2000 * planet.l2);
    var w = deg2rad(planet.w1 + centuriesSinceJ2000 * planet.w2);
    var o = deg2rad(planet.o1 + centuriesSinceJ2000 * planet.o2);

    var ww = w - o;
    var m = mod2pi(l - w);
    var ea = iterate(m, e);

    var x = a * (Math.cos(ea) - e);
    var y = a * Math.sqrt(1.0 - e * e) * Math.sin(ea);

    var xEcliptic = ((Math.cos(ww) * Math.cos(o) - Math.sin(ww) * Math.sin(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.cos(o) - Math.cos(ww) * Math.sin(o) * Math.cos(i)) * y);
    var yEcliptic = ((Math.cos(ww) * Math.sin(o) + Math.sin(ww) * Math.cos(o) * Math.cos(i)) * x + (-Math.sin(ww) * Math.sin(o) + Math.cos(ww) * Math.cos(o) * Math.cos(i)) * y);
    return [xEcliptic, yEcliptic];
}

function updatePlanetPosition(planet)
{
    var coordinates = calculateEclipticCoordinates(planet);
    var x = au * coordinates[0];
    var y = au * coordinates[1];

    if (simplified)
    {
        var angle = Math.atan2(y, x);
        x = planet.orbitSimplifiedRadius * Math.cos(angle);
        y = planet.orbitSimplifiedRadius * Math.sin(angle);
    }

    planet.calculatedX = Math.round(x);
    planet.calculatedY = Math.round(-y);
    planet.calculatedShadowRotation = Math.atan2(planet.calculatedY, planet.calculatedX) * 180 / Math.PI;
}

function getDistanceBetweenPlanets(planet1, planet2)
{
    var coordinates1 = calculateEclipticCoordinates(planet1);
    var coordinates2 = calculateEclipticCoordinates(planet2);
    var dx = coordinates1[0] - coordinates2[0];
    var dy = coordinates1[1] - coordinates2[1];
    return Math.sqrt(dx * dx + dy * dy);
}
