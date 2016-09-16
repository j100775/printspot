<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="description" content="">
      	<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
		<meta name="description" content="Admin Panel" />
        <title><?php echo $title_for_layout; ?></title>
	<?php
        echo $this->Html->css( 
								array(
								'jquery-ui/css/no-theme/jquery-ui-1.10.3.custom.min',
								'font-icons/entypo/css/entypo',
								'font-icons/font-awesome/css/font-awesome.min',
								'bootstrap',
								'neon-core',
								'neon-theme',
								'neon-forms',

								)
						);
		
        $skin = array ('black','blue','cafe','green','purple','red','white');
		if (AuthComponent::user('id')) {
            if(null!=$this->Session->read("style") && in_array($this->Session->read("style"),$skin)) {
                echo $this->Html->css('skins/'.$this->Session->read("style"));
            } 
        } 
		 echo $this->Html->css('custom');  
		 echo $this->fetch('css');
		 echo $this->Html->script('jquery-1.11.0.min');
		 echo $this->Html->css(array('jquery.plupload.queue','jquery.ui.plupload'));
         echo $this->Html->script(array('bootstrap-colorpicker.min','plupload/plupload.full','plupload/jquery.plupload.queue/jquery.plupload.queue','jscolor/jscolor'));
        ?>
		<!--[if lt IE 9]><?php  echo $this->Html->script('ie8-responsive-file-warning'); ?><![endif]-->
		<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!--[if lt IE 9]>
		<?php
			echo $this->Html->script('https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js');
			echo $this->Html->script('https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js');
		?>
		<![endif]-->
        <script type="text/javascript">
            var SITE_URL = '<?php echo SITE_URL ?>';
        </script>
        <?php
            echo $this->Html->script(
            array(
            'gsap/main-gsap'
            ,'jquery-ui/js/jquery-ui-1.10.3.custom.min'
            ,'bootstrap'
            ,'joinable'
            ,'resizeable'
            ,'neon-api'
            ,'neon-custom'
            ,'neon-demo'          
            ,'jquery.validate.min'
            )
            );

            echo $this->fetch('script');
            echo $this->fetch('inline');

        ?>
        
    </head>
    <body class="page-body  page-fade <?php echo (isset($page_extra_css))?$page_extra_css:"";?>" data-url="<?php echo SITE_URL ?>';">
	    <?php
		//echo $this->element('header');
        echo $this->fetch('content');
        
       
        ?>
        <?php // echo $this->element('sql_dump'); ?>
           <div class="modal fade" id="modal-7" aria-hidden="false" style="display: none; width: auto;"> </div>  
	</body>
</html>