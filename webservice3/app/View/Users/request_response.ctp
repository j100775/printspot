
<h1>Response Code</h1>
<p><?php echo $response_code; ?></p>

<h1>Response Body</h1>

<p><?php echo $response_body['name']; ?></p>
<p><?php echo $response_body['username']; ?></p>
<?php
 foreach($cart as $product):
     if($product['product_id'] == 3){
     echo $product['product_name']. " " ;
        echo $product['price']." ";
     }
     endforeach;?>









