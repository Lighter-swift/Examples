-- This is the SQL that is going to create our database.
-- The file is picked up by the "Enlighter" plugin, which needs to be
-- enabled in the Xcode target settings. The plugin will then generate
-- the proper Swift code to access this database.

-- A table containing information about solar bodies.
-- Note that we use proper SQL style, snake_case. Camel-case works too!
CREATE TABLE solar_body (
    id             TEXT NOT NULL PRIMARY KEY,
    name           TEXT NOT NULL,
    english_name   TEXT NOT NULL,
    body_type      TEXT NOT NULL,
    densitity      REAL,
    gravity        REAL,
    discovered_by  TEXT,
    discovery_date TEXT
);

-- Setting a user version is useful for migrations. It can be used to
-- detect what schema version a database file has (and is also exposed
-- as a property in the generated Swift database structure).
PRAGMA user_version = 1;
