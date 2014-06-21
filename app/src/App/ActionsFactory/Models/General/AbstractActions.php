<?php
namespace App\ActionsFactory\Models\General;

/**
* Actions
* 
* Abstract class for all actions models
* 
* @author Roman Morozov <engineer.morozov@gmail.com>
* @version 1.0
*/
abstract class AbstractActions
{
	/**
	 * DB connection from Silex Application
	 * @var Doctrine
	 */
	protected $conn;

	/**
	 * User model from Simple User
	 * @var User
	 */
	protected $user;

	/**
	 * Setter for $conn
	 * @param Doctrine $conn 
	 */
	public function setConn($conn) 
    {
        $this->conn = $conn;
    }

    /**
     * Setter for $user
     * @param User $user 
     */
    public function setUser($user) 
    {
        $this->user = $user;
    }

    /**
     * Action history for some days
     * @return array
     */
    public abstract function history();

    /**
     * Add action
     */
    public abstract function add();  
}