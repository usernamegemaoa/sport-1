<?php
interface GUIFactory
{
    public function createButton();
}
 
class WinFactory implements GUIFactory
{
    public function createButton()
    {
        return new WinButton();
    }
}
 
class LinFactory implements GUIFactory
{
    public function createButton()
    {
        return new LinButton();
    }
}
 
abstract class Button
{
    private $_caption;
    public abstract function render();
 
    public function getCaption()
    {
        return $this->_caption;
    }
    public function setCaption($caption)
    {
        $this->_caption = $caption;
    }
}
 
class WinButton extends Button
{
    public function render()
    {
        echo "I am WinButton: ".$this->getCaption();
    }
}
 
class LinButton extends Button
{
    public function render()
    {
        echo "I am LinButton: ".$this->getCaption();
    }
}
####
/**
* Класс инкапсулирует логику конструирования алгоритма создания каких-либо структур
* например (GUI, алгоритмов доступа к БД, и т.д.). Класс ничего "не знает" о платформе, на которой он работает.
*/
class Application {
    public function __construct(GUIFactory $factory) {
		$button = $factory->createButton();
		$button->setCaption("Start");
		$button->render();
    }
}