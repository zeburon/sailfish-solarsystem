var finishedLoading = false;

function getDatabase()
{
    return LocalStorage.openDatabaseSync("harbour-solarsystem", "1.0", "StorageDatabase", 100000);
}

function startInit()
{
    var database = getDatabase();
    database.transaction(function(tx)
    {
        tx.executeSql('CREATE TABLE IF NOT EXISTS memory(name TEXT UNIQUE, value TEXT)');
    });
}

function finishInit()
{
    finishedLoading = true;
}

function setValue(name, value)
{
    if (!finishedLoading)
    {
        // ignore value changes as long as app is still loading
        return false;
    }

    var database = getDatabase();
    var result = false;
    database.transaction(function(tx)
    {
        var rs = tx.executeSql('INSERT OR REPLACE INTO memory VALUES (?,?);', [name, value.toString()]);
        result = rs.rowsAffected > 0;
    });
    return result;
}

function getValue(name)
{
    var database = getDatabase();
    var value = "";
    database.transaction(function(tx)
    {
        var result = tx.executeSql('SELECT value FROM memory WHERE name=?;', [name]);
        if (result.rows.length > 0)
        {
            value = result.rows.item(0).value;
        }
    });
    return value;
}

function destroyData()
{
    var database = getDatabase();
    database.transaction(function(tx)
    {
        var rs = tx.executeSql('DROP TABLE memory');
    });
}
