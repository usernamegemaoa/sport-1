<?php
namespace App\ActionsFactory;

use App\ActionsFactory\Activity;
use App\ActionsFactory\Factories\PullupFactory;
use App\ActionsFactory\Factories\PushupFactory;
use App\ActionsFactory\Factories\RunningFactory;
/**
* LoadModelBy
* 
* Load endeed model in case of type. Abstract Factory
* 
* @author Roman Morozov <engineer.morozov@gmail.com>
* @version 1.0
*/
class LoadModelBy
{
    private $conn;
    private $user;

    public static function activity($activity = '') 
    {
        return new Activity(self::activitySelector($activity));
    }
 
    public static function activitySelector($activity) 
    {
        if ($activity === 'pullup') {
            $instance = new PullupFactory();
        } elseif ($activity === 'pushup') {
            $instance = new PushupFactory();
        } elseif ($activity === 'running') {
            $instance = new RunningFactory();
        }

        return $instance;
    }

}