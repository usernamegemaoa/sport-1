<?php
namespace App\ActionsFactory\Factories;

use App\ActionsFactory\FactoryInterface;
use App\ActionsFactory\Models\Pullups;

class PullupFactory implements FactoryInterface
{
    public function createAction()
    {
        return new Pullups();
    }
}