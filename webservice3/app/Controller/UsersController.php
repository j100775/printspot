<?php

App::uses('CakeEmail', 'Network/Email');

class UsersController extends AppController {

    public $uses = array('User', 'Cart', 'Category');
    public $components = array('RequestHandler');

    // public $id;
        
    function beforeFilter() {
        Parent::beforeFilter();
        // $id=array();
        $this->Auth->allow("login", "register", "Category", "getcategory", 'logout', 'productdetail','userdetail');         //functions will be execute ofter authentication
        //$this->Auth->allow("register");
        //$this->Auth->allow("Category");
        // $this->Auth->allow("getcategory");
    }

// login detail
    function login() {
        $this->layout = false;
        $this->autoLayout = false;
        if (isset($this->request->data) && !empty($this->request->data['email']) && !empty($this->request->data(['password']))) {
            $email = $this->request->data['email'];   // request get from admin 
            $password = $this->Auth->password($this->request->data['password']);
            $conditions = array(
                'User.email' => $email, // check request from data base match
                'User.password' => $password
            );

            //  if inserted data is matched
            if ($this->User->hasAny($conditions)) {
                // $userDetail = $this->User->find('first');  // data  fetched
                $this->User->bindModel(array('hasMany' => array('Cart' => array('foreignKey' => 'user_id'))));
                $userDetail = $this->User->find('first', array('conditions' => $conditions));
                print_r($userDetail);
                //   $Url= SITE_URL.'Users/'.$this->request->params['named']['Id'];
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
            $a = $this->User->find('count', array('conditions' => array('email' => $this->request->data['email'])));
            if ($a > 0) {
                $this->set('response_code', 3);
                $this->set('response_body', array('message' => 'email is already exist', 'code' => 1));
            }
            $c = $this->request->data['password'];
            if (strlen($c) < 6) {
                $this->set('response_code', 3);
                $this->set('response_body', array('message' => 'please enter atleast 6 char in password', 'code' => 1));
            } else {
                $data['User']['name'] = $this->request->data['name'];
                $data['User']['username'] = $this->request->data['username'];
                $data['User'] ['password'] = $this->Auth->password($this->request->data['password']);
                $data['User']['email'] = $this->request->data['email'];
                $data['User']['token'] = $this->request->data['token'];
                $data['User']['device_id'] = $this->request->data['device_id'];
                //  print_r($data);
                $this->User->save($data);    //data will save in user table
                $this->set('response_code', 0);
                $this->set('response_body', 'saved');
            }//ofter sucess full execution message is set with response code
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
        $fetch = $this->Category->find('all', array('limit' => 1, 'order' => array('id DESC')));
        // print_r($fetch);
        $this->set('response_code', 0);
        $this->set('response_body', $fetch);
        $this->render('/Client/request_response');
    }

    public function logout() {
        $this->Session->destroy();
        // $this->set('response_code', 0);
        // $this->set('response_body', 'jhj');
        // $this->Session->setFlash(__('You have successfully logged out.'));
        $this->Auth->loginRedirect = array('controller' => 'users', 'action' => 'login');
        return $this->redirect($this->Auth->redirectUrl());
        //$this->redirect($this->Auth->login());
        // $this->render('/Client/request_response');
        // 
        //echo"hi";
    }

    public function productdetail() {
        // $this->Category->bindModel(array('belongsTo'=>array('Cart')));  
//     // $this->Category->bindModel(array('hasMany' => array('Cart' =>array('foreignKey'=>'ctegory_id')))); 
//       $a =$this->params['named']['Category_type'];
//       print_r($a);
//       exit();
//         
//       $Url= SITE_URL.'Users/'.$this->request->params['named']['id'];
//       if($category_id!=0){
//      $this->Category->bindModel(array(
//         'belongsTo' =>array('Cart'=>array(
//           'foreignKey' => false,
//                        'condition'=>array('Category.id = Cart.category_id')
//        ))
//    ));
//      
//     $userDetail = $this->Category->find('all');
//      print_r($userDetail);
//    exit();
//       }
//         $this->Category->bindModel(array(
//          'belongsTo' =>array('Cart'=>array(
//           'foreignKey' => false,
//          'condition'=>array('Category.id = Cart.category_id')
//          ))
//          ));
        $name = isset($this->request->query['name']) ? $this->request->query['name'] : null;
        $id = isset($this->request->query['id']) ? $this->request->query['id'] : null;

        $conditions = array(
            'Category.category_name' => $name
        );
        $conditions1 = array(
            'Category.id' => $id
        );
        if ($this->Category->hasAny($conditions)) {
             $userDetail = $this->Category->find('all', array('conditions' => $conditions));
            print_r($userDetail);
            exit();
            } elseif ($this->Category->hasAny($conditions1)) {
            $userDetail = $this->Category->find('all', array('conditions' => $conditions1));
            print_r($userDetail);
            exit();
        } else {
            $this->Category->bindModel(array(
           'belongsTo' =>array('Cart'=>array(
            'foreignKey' => false,
           'condition'=>array('Category.id = Cart.category_id')
       ))
     ));
            $userDetail = $this->Category->find('all');
            print_r($userDetail);
            exit();
        }
       
    }
    public function userdetail()
            {
        // Here You cand find all dtail on the basis of any field of user
        $name = isset($this->request->query['name']) ? $this->request->query['name'] : null;
        $id = isset($this->request->query['id']) ? $this->request->query['id'] : null;
       $username = isset($this->request->query['username']) ? $this->request->query['username'] : null;
        $email = isset($this->request->query['email']) ? $this->request->query['email'] : null;
        $token =  isset($this->request->query['token']) ? $this->request->query['token'] :null;
        $deviceid =  isset($this->request->query['device_id']) ? $this->request->query['device_id'] :null;
     //        $conditions = array(
//            'User.name' => $name
//        );
         if ($id) {
             $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
            $userDetail = $this->User->findById($id);
           if ($userDetail) {
               $this->set('response_code', 0);
        $this->set('response_body', $userDetail);
        $this->render('/Client/request_response');
                 } else {
                $this->set('response_code', 3);
        $this->set('response_body', "record not found");
        
            }
          }
         elseif($name){
             $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
              $userDetail = $this->User->findByName($name);
              if($userDetail){
               $this->set('response_code', 0);
        $this->set('response_body', $userDetail);
              }
              else{
                  $this->set('response_code', 3);
        $this->set('response_body', "record not found");
              }
            }
            elseif($username){
                $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
                $userDetail = $this->User->findByUsername($username);
                if($userDetail){
                 $this->set('response_code', 0);
                $this->set('response_body', $userDetail);
              }
              else{
                  $this->set('response_code', 3);
                   $this->set('response_body', "record not found"); 
              }
            }
            elseif($email){
                $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
                $userDetail = $this->User->findByEmail($email);
               if($userDetail){
                 $this->set('response_code', 0);
        $this->set('response_body', $userDetail);  
              }
              else{
                 $this->set('response_code', 3);
        $this->set('response_body', "record not found");
              } 
            }
            elseif($token)
            {
                $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
               $userDetail = $this->User->findByToken($token); 
               if($userDetail){
                 $this->set('response_code', 0);
        $this->set('response_body', $userDetail);  
              }
              else{
                  $this->set('response_code', 3);
        $this->set('response_body', "record not found");
              }
            }
            elseif($deviceid){
              $userDetail = $this->User->findByDeviceid($deviceid);  
               if($userDetail){
                   $this->set('response_code', 0);
        $this->set('response_body', $userDetail);
                
              }
              else{
                   $this->set('response_code', 3);
        $this->set('response_body', "record not found"); 
              }
            }
            
        else {
            $this->User->bindModel(array(
                'belongsTo' => array('Cart' => array(
                        'foreignKey' => false,
                        'condition' => array('User.id = Cart.user_id')
                    ))
            ));
            $userDetail = $this->User->find('all');
            print_r($userDetail);
             $this->set('response_code', 0);
        $this->set('response_body', $userDetail);  
            exit();
        } $this->render('/Client/request_response');
 }
  }
            


