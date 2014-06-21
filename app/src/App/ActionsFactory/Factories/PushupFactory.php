<?php
namespace App\ActionsFactory\Factories;

use App\ActionsFactory\FactoryInterface;
use App\ActionsFactory\Models\Pushups;

class PushupFactory implements FactoryInterface
{
    public function createAction()
    {
        return new Pushups();
    }
}