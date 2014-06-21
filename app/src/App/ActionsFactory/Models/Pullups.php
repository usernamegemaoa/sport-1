<?php
namespace App\ActionsFactory\Models;

use App\ActionsFactory\Models\General\RepetitionActions;

class Pullups extends RepetitionActions
{
    public function history()
    {
    	// parent::$table = 'pullups';
        $tmp = array();
	    $sql = 'SELECT value, timestamp FROM pullups WHERE uid = :uid AND DATE_SUB(CURDATE(),INTERVAL :days DAY) <= timestamp LIMIT 1000';
	    $params = array(
	        'days' => 20,
	        'uid' => $this->user->getId()
	        );
	    foreach ($this->conn->fetchAll($sql, $params) as $item) {
	        $day = substr($item['timestamp'], 0, 10);
	        if (!isset($tmp[$day])) {
	            $tmp[$day] = 0;
	        }
	        $tmp[$day] += $item['value'];
	    }
	    foreach ($tmp as $date => $day) {
	        $history[] = array(
	            'period' => $date,
	            'pullups' => $day
	            );
	    }
	    return $history;
    }

    public function add()
    {
        echo "Pullups add: ";
    }
}