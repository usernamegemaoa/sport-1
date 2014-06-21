<?php
namespace App\ActionsFactory\Models;

use App\ActionsFactory\Models\DistanceActions;

class Running extends DistanceActions
{
    public function history()
    {
        echo "Running History: ";
    }

    public function add()
    {
        echo "Running add: ";
    }
}