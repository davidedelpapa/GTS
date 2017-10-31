# GTS
PHP Tile Server with User (and keys) Management

**Important Notes**:

- As yet, the project has been tested only with Apache2 and MySql/MariaDB
- The system uses *.htaccess* and *mod-rewrite*
- You can use the scripts inside *DB-Config/* to set up the database for the project
- Configuration is handled by *gts_config.ini* file
- testing-tiles kindly provided by [SentinelMap.eu](https://sentinelmap.eu): to test it, use the *test.html* provided (after having set up the DB and gts.php)

## Status of the project

The project is in a working state right now. However, it is still to be considered alpha, because I have still to come to a decision on the API signature (so not to change it later on). Moreover, extensive tests are lacking, security issues are not even considered, etc, etc...

However, the server is fully functional. In a very modified way(*) it is at the core of [SentinelMap](https://sentinelmap.eu/) and [SentinelMap Services](https://devs.sentinelmap.eu/).

Enjoy!

(*) very modified way: It has been enhanced with an eye on high volumes, multiple map management, and tailored to support our own user database. Plus it as a UI connected to it, for key management and for visualizing the tile count.