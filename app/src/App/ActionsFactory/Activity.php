<?php
namespace App\ActionsFactory;

class Activity 
{

    private $action;

    public function __construct(FactoryInterface $factory) 
    {
        $this->action = $factory->createAction();
    }

    public function setConn($conn) 
    {
        $this->action->setConn($conn);
        return $this;
    }

    public function setUser($user) 
    {
        $this->action->setUser($user);
        return $this;
    }

    public function history() 
    {
        return $this->action->history();
    }

    public function add() 
    {
        return $this->action->add();
    }
    
}