<?php

use Silex\Provider\MonologServiceProvider;
// use Silex\Provider\WebProfilerServiceProvider;

// include the prod configuration
require __DIR__.'/prod.php';

// enable the debug mode
$app['debug'] = true;

$app->register(new MonologServiceProvider(), array(
    'monolog.logfile' => __DIR__.'/../var/logs/silex_dev.log',
));

// $app->register(new WebProfilerServiceProvider(), array(
//     'profiler.cache_dir' => __DIR__.'/../var/cache/profiler',
// ));

$app->register(new Silex\Provider\DoctrineServiceProvider());
$app['doctrine.options'] = array(
    'debug' => $app['debug'],
);

$dbConfig = array(
    'driver' => 'pdo_mysql', 
    'dbname' => 'sport',
    'host' => 'localhost',
    'password' => '',
    'user' => 'root',
    'charset' => 'utf8',
    'port'     => '3306'
);
$app['doctrine.connection'] = $dbConfig;
$dbConfig['dbname'] = 'sport';
unset($dbConfig['charset']);
$app['db.options'] = $dbConfig;

