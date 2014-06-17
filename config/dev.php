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


$app->register(new Silex\Provider\SecurityServiceProvider(), array(
    'security.firewalls' => array(
        'secured_area' => array(
            'pattern' => '^.*$',
            'anonymous' => true,
            'remember_me' => array(),
            'form' => array(
                'login_path' => '/user/login',
                'check_path' => '/user/login_check',
            ),
            'logout' => array(
                'logout_path' => '/user/logout',
            ),
            'users' => $app->share(function($app) { return $app['user.manager']; }),
        ),
    ),
));
// Note: As of this writing, RememberMeServiceProvider must be registered *after* SecurityServiceProvider or SecurityServiceProvider
// throws 'InvalidArgumentException' with message 'Identifier "security.remember_me.service.secured_area" is not defined.'
$app->register(new Silex\Provider\RememberMeServiceProvider());
// Register the SimpleUser service provider.
$app->register($u = new SimpleUser\UserServiceProvider());

// Optionally mount the SimpleUser controller provider.
$app->mount('/user', $u);