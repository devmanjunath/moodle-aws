<?php  // Moodle configuration file

unset($CFG);
global $CFG;
$CFG = new stdClass();

$CFG->dbtype    = 'auroramysql';
$CFG->dblibrary = 'native';
$CFG->dbhost    = getenv('DB_HOST');;
$CFG->dbname    = 'moodle';
$CFG->dbuser    = getenv('DB_USER');;
$CFG->dbpass    = getenv('DB_PASSWORD');;
$CFG->prefix    = 'mdl_';
$CFG->dboptions = array (
  'dbpersist' => 0,
  'dbport' => 3306,
  'dbsocket' => '',
  'dbcollation' => 'utf8mb4_0900_ai_ci',
);

$CFG->wwwroot   = 'https://'.getenv('HOST_NAME');
$CFG->dataroot  = '/var/moodledata';
$CFG->admin     = 'admin';

$CFG->directorypermissions = 0777;

#$CFG->session_handler_class = '\core\session\memcached';
// $CFG->session_memcached_save_path = '127.0.0.1:11211';
// $CFG->session_memcached_prefix = 'memc.sess.key.';
// $CFG->session_memcached_acquire_lock_timeout = 120;
// $CFG->session_memcached_lock_expire = 7200;       // Ignored if PECL memcached is below version 2.2.0
// $CFG->session_memcached_lock_retry_sleep = 150;

require_once(__DIR__ . '/lib/setup.php');

// There is no php closing tag in this file,
// it is intentional because it prevents trailing whitespace problems!
