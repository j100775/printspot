<?php

App::uses('CakeEmail', 'Network/Email');

class UsersController extends AppController {

    public $uses = array('User', 'Cart', 'Category');
    public $components = array('RequestHandler');
   // public $id;
    function beforeFilter() {
        Parent::beforeFilter();
        // $id=array();
        $this->Auth->allow("login");         //functions will be execute ofter authentication
        $this->Auth->allow("register");
        $this->Auth->allow("Category");
        $this->Auth->allow("getcategory");
    }
// login detail
    function login() {
        $this->layout = false;   
        $this->autoLayout = false;
       if (isset($this->request->data) && !empty($this->request->data['email']) && !empty($this->request->data(['password']))) {
           $email = $this->request->data['email'];   // request get from admin 
            $password = $this->Auth->password($this->request->data['password']);
            $conditions = array(
                'User.email' => $email,             // check request from data base match
                'User.password' => $password
            );

                    //  if inserted data is matched
            if ($this->User->hasAny($conditions)) {
               $userDetail = $this->User->find('first');  // data  fetched
               // print_r($userDetail);
               
//-------------createing token and enter it into user table---------//
                $token = "";
                $codeAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
                $codeAlphabet.= "abcdefghijklmnopqrstuvwxyz";
                $codeAlphabet.= "0123456789";
                $max = strlen($codeAlphabet) - 1;
                for ($i = 0; $i < 8; $i++) {
                    $token .= substr($codeAlphabet, (rand() % (strlen($codeAlphabet))), 1);  // token will be alternate change 
                }
                $this->set('response_code', 0);
                $this->set('response_body', $userDetail['User']);   // set variable for get in request_response
                $this->set('cart', $userDetail['Cart']);
            } else {
                $this->set('response_code', 3);
                $this->set('response_body', array('message' => 'No Records Found', 'code' => 1));
            }
        } elseif (empty($_POST['email'])) {
            $this->set('response_code', 1);
            $this->set('response_body', array('message' => 'Please Enter Email Address', 'code' => 1));
        } elseif (empty($_POST['password'])) {
            $this->set('response_code', 2);
            $this->set('response_body', array('message' => 'Please Enter Password', 'code' => 1));
        }

        $this->render('/users/request_response');    // display request response
    }
// new user will be register
    function register() {
        $this->autoLayout = false;
        $data = array();
        $this->User->create();
        // check condition any field is not empty
        if (isset($this->request->data) && !empty($this->request->data['email']) && preg_match(EMAIL_REGEX, $this->request->data['email']) && !empty($this->request->data['password']) && !empty($this->request->data['name']) && !empty($this->request->data['username']) && !empty($this->request->data['device_id']) && !empty($this->request->data['token'])) {
            $data['User']['name'] = $this->request->data['name'];
            $data['User']['username'] = $this->request->data['username'];
            $data['User'] ['password'] = $this->Auth->password($this->request->data['password']);
            $data['User']['email'] = $this->request->data['email'];
            $data['User']['token'] = $this->request->data['token'];
            $data['User']['device_id'] = $this->request->data['device_id'];
          //  print_r($data);
            $this->User->save($data);    //data will save in user table
            $this->set('response_code', 0);
            $this->set('response_body', 'saved');  //ofter sucess full execution message is set with response code
        } else {
            $this->set('response_code', 3);
            // check email is valid
            if (!preg_match(EMAIL_REGEX, $this->request->data['email'])) { 
                $this->set('response_body', array('message' => 'please enter valid mail', 'code' => 1));
            } else
                $this->set('response_body', array('message' => 'please enter data', 'code' => 1));
        }
        $this->render('/Client/request_response');
    }

    function category() {
        $this->autoLayout = false;
        $data = array();
        $this->Category->create();
        $data['Category']['category_name'] = $this->request->data['categoryname'];

        $data['Category']['category_type'] = $this->request->data['categorytype'];
        $data['Category']['category_discription'] = $this->request->data['discription'];
        //$data['Category']['category_img'] = $this->request->data['categoryimg'];

        $file = array();
        $file['name'] = $_FILES['categoryimg']['name'];

        $file['tmp_name'] = $_FILES['categoryimg']['tmp_name'];
        move_uploaded_file($file['tmp_name'], WWW_ROOT . 'img/uploads/users/' . $file['name']);
        $data['Category']['category_img'] = $file['name'];
       // print_r($data);
      
      $id = $this->Category->save($data);
      
           
        $this->set('response_code', 0);
        $this->set('response_body', 'saved');

        //$this->render('/Client/request_response');
        $this->redirect(array('action' => 'getcategory'));
    }

    function getcategory() {
         $this->autoLayout = false;
        $fetch = $this->Category->find('all', array('limit' => 1,'order'=>array('category_id DESC')));
       // print_r($fetch);
         $this->set('response_code', 0);
        $this->set('response_body', $fetch);
        $this->render('/Client/request_response');
        }

}
        
        
       
    
      
       
 
       

       
