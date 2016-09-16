<?php

// app/Model/User.php
class User extends AppModel {

    var $name = 'User';
   // var $hasMany = 'Cart';
    var $hasMany = array('Cart' => array('foreignKey'=>'user_id'));
   
    
    
      }  
            
            
           
       
   


