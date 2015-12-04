// use simplified calculation
var simplified = true;

// size of one astronomical unit
var au;

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

function setOrbitParameters(newAu, newSimplified)
{
    au = newAu;
    simplified = newSimplified;
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
