<?php
/*
 * Debug Code
 */
/*
ini_set('display_errors', 'On');
error_reporting(E_ALL);
*/

/*
 * configuration
 */
$config = parse_ini_file("gts_config.ini", true);

$tiles_root = $config['tiles']['root'];

/* ----------------------------------------------------- */
/*                      SERVER SETUP                     */
/* ----------------------------------------------------- */

$db_connection = new mysqli($config['mysql']['host'], $config['mysql']['user'], $config['mysql']['password'], $config['mysql']['database'], $config['mysql']['port']);
if ($db_connection->connect_error) {
    error_log('MySql Connection failed: ' . $db_connection->connect_error);
    http_response_code(500);
    die(1);
}

/* 
 * Do not serve the tile without a proper Api Key
 * In case of unauthorized access, returns a HTTP 403 error code.
 */
if(isset( $_REQUEST['key'])){
    $key = $db_connection->real_escape_string($_REQUEST['key']);
} else {
    http_response_code(403);
    die(1);
}

/* 
 * Allowing serving tiles on the necessary conditions only:
 * - User must exist, and the key correspond to it.
 * - User must not have reached the max tile cap
 */

// First condition: wrong key? No user connected to it? -> Error 403
$result = $db_connection->query("SELECT Users.userid, Users.tilecount, Users.tilemax FROM Users INNER JOIN pkeys ON Users.userid = pkeys.userid WHERE pkeys.pkey = '" . $key . "';");
if (!$result) {
    http_response_code(403);
    die(1);
} else {
    $r_userdata = $result->fetch_row();
    $result->free();
    $userid =  $r_userdata[0];
    $curr_tile_count = $r_userdata[1];
    $max_tiles = $r_userdata[2];
}

// second condition: Reached the tile cap? -> Error 403
if (!$userid || $curr_tile_count >= $max_tiles){
    http_response_code(403);
    die(1);
}

/* ----------------------------------------------------- */
/*                    SERVER ROUTINES                    */
/* ----------------------------------------------------- */
    
/* Prepare Response */
$file = $tiles_root . $_REQUEST['z'] . '/' . $_REQUEST['x'] . '/' . $_REQUEST['y'];

/* Check file existence */
if(!file_exists($file)){
    $db_connection->close();
    http_response_code(404);
    die(1);
}

/* Update tile counters (per-user, and per-key counters) */
$db_connection->query("UPDATE Users INNER JOIN pkeys ON (Users.userid = pkeys.userid) SET Users.tilecount = Users.tilecount + 1, pkeys.tilecount = pkeys.tilecount + 1 WHERE pkeys.pkey = '" .$key . "';");

/* Actual Response */
$db_connection->close();

header('Content-Type: image/jpeg');        
readfile($file);
?>