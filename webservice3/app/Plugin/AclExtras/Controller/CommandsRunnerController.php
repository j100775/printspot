<?php

App::uses('ShellDispatcher', 'Console');

class CommandsRunnerController extends AclExtrasAppController {

    function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->allow('aco_sync');
    }

    function aco_sync() {
        $this->autoLayout = false;
        $command = '-app ' . APP . ' AclExtras.AclExtras aco_sync';
        $args = explode(' ', $command);
        $dispatcher = new ShellDispatcher($args, false);
        try {
            $res = $dispatcher->dispatch();
        } catch (Exception $e) {
            echo $e->getMessage();
        }
        var_dump($res);
    }

}
