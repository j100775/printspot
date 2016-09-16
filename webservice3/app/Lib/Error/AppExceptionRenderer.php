<?php

App::uses('ExceptionRenderer', 'Error');

class AppExceptionRenderer extends ExceptionRenderer {
    public function __construct(Exception $exception) {
        parent::__construct($exception);
        $this->controller->layout = 'default';
    }    
}
?>
