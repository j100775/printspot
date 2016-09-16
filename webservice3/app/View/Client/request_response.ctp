<?php echo stripslashes(str_replace('\n','',json_encode(array('status'=>$response_code,'body'=>$response_body))));?>
