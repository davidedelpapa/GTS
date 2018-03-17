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

## How to use

The script *gts.sh* has been provided in order to set up a docker environment to play with the tile server. The script itself is a thin wrapper around docker-compose, but it has grouped some niceties, including a wrapper for docker ps and stats, shells of containers and 'hot shells', i.e. shell for a running container, plus direct connection with the mysql interface of the running mysql container.

In order to use it,
```bash
./gts.sh build
./gts.sh start
#stop with
#./gts.sh stop
```

Now point your browser to [http://localhost:8000](http://localhost:8000) to be welcomed with the the two testing pages (for leaflet and openlayers respectively).

## Configuration

Database configuration can be done using the scripts provided under the *DB-Config* directory, adapted to your needs.

### Setting up the DB: Quick walkthrough

If you don't want to have the hustle to change everything in the DB, do the following. We'll use the docker environment, however, *mutatis mutandis* the procedure can be adapted to a non-containerized install as well.

Build the continers
```bash
./gts.sh build
```

Now, there are two undeclared commands inside *gts.sh*, namely *test-install* and *test-uninstall*

```bash
./gts.sh test-install
# test-uninstall to remove the installation
```
For user management we can do the following
```bash
./gts.sh mysql
# we should be now inside the mysql shell
mysql> INSERT INTO Users(username) VALUES('myusername');
# in oder to assign an apikey to the user:
mysql> INSERT INTO pkeys(pkey, userid) VALUES('apikey', (SELECT Users.userid FROM Users WHERE username = 'myusername'));
mysql> exit;
```

Alternatively you can use the poor man's UI provided inside the same *gts.sh*:

```bash
./gts.sh adduserp <username> <pkey>
```
(alias for `./gts.sh aup <username> <pkey>`)

```bash
./gts.sh adduser  <username>
```
(alias for `./gts.sh au  <username>`)

```bash
./gts.sh showuser <username>
```
Shows info on user identified by `<username>`.

```bash
./gts.sh showpkey <pkey>
```
(alias for `./gts.sh shk  <pkey>`)

```bash
./gts.sh addpkey  <username> <pkey>
```
Add a pkey (`<pkey>`) to a user identified by `<username>`.

```bash
./gts.sh delpkey  <pkey>
```
(alias for `./gts.sh dk  <pkey>`)

```bash
./gts.sh deluser  <username>
```
Delete user identified by `<username>`.

```bash
./gts.sh au  <username>
```
Add a user to the system identified by `<username>`.

```bash
./gts.sh aup <username> <pkey>
```
Add a user (`<username>`), and a pkey (`<pkey>`), at the same time.

```bash
./gts.sh shu <userid>
```
Show info on a user identified by `<userid>`.

```bash
./gts.sh shk <pkey>
```
Show user connected to the `<pkey>`

```bash
./gts.sh ak  <userid> <pkey>
```
Add a pkey (`<pkey>`) to a user identified by `<userid>`.

```bash
./gts.sh dk  <pkey>
```
Delete the `<pkey>` record.

```bash
./gts.sh du  <userid>
```
Delete user identified by `<userid>`.

### gts_config.ini
The *gts_config.ini* configures the tileserver and the access to the mysql instance.

#### gts_config.ini fields

[tiles]

- *root*: path to the root of the rendered tiles to display. **Important: the slash / at the end of the path!** Example: `./tiles/` 
- *mime*: mimetype of the images to serve as tiles. For the most common, see [MDN's incomplete list of MIME types](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Complete_list_of_MIME_types) Example: `image/json`

[mysql]

- *host*: mysql server host. Example: `localhost`
- *port*: mysql server port. Example: `3306`
- *database*: mysql database to use. Example: `gts`
- *user*: mysql server's user with writing access to the database to use. Example: `gtsuser`
- *password*: mysql user's password. Example: `test123`

## Changelog

*March 17, 2017 (St. Pat's)* 
 - added `mime` to *gts_config.ini* in order to pass whichever image type as tile to the server.
 - added *test_openlayers* as example of the use of openlayers.
 - changed a bit the environment and DB-Config.
 - added functionalities to *gts.sh*

## Note(s)
(*) *very modified way*: It has been enhanced with an eye on high volumes, multiple map management, and tailored to support our own user database. Plus it as a UI connected to it, for key management and for visualizing the tile count.