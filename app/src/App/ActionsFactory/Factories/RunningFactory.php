<?php
namespace App\ActionsFactory\Factories;

use App\ActionsFactory\FactoryInterface;

class RunningFactory implements FactoryInterface
{
    public function createAction()
    {
        return new Running();
    }
}