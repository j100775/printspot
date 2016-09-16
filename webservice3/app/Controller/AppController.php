<?php

/**
 * Application level Controller
 *
 * This file is application-wide controller file. You can put all
 * application-wide controller-related methods here.
 *
 * PHP 5
 *
 * CakePHP(tm) : Rapid Development Framework (http://cakephp.org)
 * Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @copyright     Copyright (c) Cake Software Foundation, Inc. (http://cakefoundation.org)
 * @link          http://cakephp.org CakePHP(tm) Project
 * @package       app.Controller
 * @since         CakePHP(tm) v 0.2.9
 * @license       http://www.opensource.org/licenses/mit-license.php MIT License
 */
App::uses('Controller', 'Controller');

/**
 * Application Controller
 *
 * Add your application-wide methods in the class below, your controllers
 * will inherit them.
 *
 * @package		app.Controller
 * @link		http://book.cakephp.org/2.0/en/controllers.html#the-app-controller
 */
class AppController extends Controller {

    public $components = array( 'Auth', 'Session');
    public $helpers = array('Html', 'Session', 'Form');
    public function beforeFilter() {
        parent::beforeFilter();
        $this->Auth->authenticate = array('Form' => array('userModel' => 'User', 'fields' => array('username' => 'email', 'password' => 'password'), 'scope' => array('User.active' => 1)));
        //        $this->Auth->authorize = array('Controller');
        $actionPath = 'controllers';
        $this->Auth->authorize = array('Actions' => compact('actionPath'));
        $this->Auth->loginAction = array('controller' => 'users', 'action' => 'login');
  

        
        
    }

    function beforeRender() {
        parent::beforeRender();
     }

    //    function isAuthorized($user = null) {     
    //        if($user['role'] === 'super_admin'){
    //            return true;
    //        }
    //        if ($this->request->controller === 'publishers') {
    //            return (bool)($user['role'] === 'publisher');
    //        }
    //        if ($this->request->controller === 'advertisers') {
    //            return (bool)($user['role'] === 'advertiser');
    //        }
    //
    //        // Default deny
    //        return false;        
    //    }

   

}
