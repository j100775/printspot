<?php
        echo $this->Html->css( 
								array(
								'jquery-ui/css/no-theme/jquery-ui-1.10.3.custom.min',
								'font-icons/entypo/css/entypo',
								//'font-icons/font-awesome/css/font-awesome.min',
                                                              //  'http://fonts.googleapis.com/css?family=Noto+Sans:400,700,400italic',
								'bootstrap',
								'neon-core',
                                                                'neon',
								'neon-theme',
								'neon-forms',
                                                                'custom',
                                                                'studio'
								)
						);
		
        echo $this->fetch('css');
        echo $this->Html->script('jquery-1.11.0.min'); 
        
        $skin = array ('black','blue','cafe','green','purple','red','white');
		if (AuthComponent::user('id')) {
            if(null!=$this->Session->read("style") && in_array($this->Session->read("style"),$skin)) {
                echo $this->Html->css('skins/'.$this->Session->read("style"));
                    } 
                } 
		
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
						,'jquery-ui/js/jquery-ui-1.10.3.minimal.min'
						,'bootstrap'
						,'joinable'
						,'resizeable'
						,'neon-api'
						,'neon-custom'
						,'neon-demo'
					)
			);
       
        echo $this->fetch('script');
        echo $this->fetch('inline'); 
	  echo $this->Html->script(array( 'jscolor/jscolor'));	
        
         
         
  /*       
    echo $this->Html->script(array('simple-slider', 'jscolor/jscolor'));
    echo $this->Html->css('simple-slider');
   // echo $this->Html->script(array('jquery.min'));
    echo $this->Html->script(array('jquery.form.new'));*/
  //  echo $this->Html->script(array('jquery.colorbox'));
  //  echo $this->Html->css('colorbox');
    
 
    echo $this->Html->css(array('jquery.plupload.queue','jquery.ui.plupload'));
        echo $this->Html->script(array('plupload/plupload.full','plupload/jquery.plupload.queue/jquery.plupload.queue'));
    
    ?>
 <!----------this is for loader------------>
 <!--
<style>
        .loading-div-background 
    {
        display:none;
        position:fixed;
        top:0;
        left:0;
        background:black;
        width:100%;
        height:100%;
        opacity: 0.8;
     }
    .loading-div
    {
         width: 300px;
         height: 200px;
         background-color: #0c0b0b;
         text-align:center;
         position:absolute;
         left: 50%;
         top: 50%;
         margin-left:-150px;
         margin-top: -100px;
     }
</style>
 -->
<script type="text/javascript">
      
function ShowProgress(id) {
    $("#"+id).show();
}
function HideProgress(id) {
    $("#"+id).hide();
}

 </script>
 <!----------Loader ends------------>
           
<?php  echo $this->fetch('content');?>


        <?php // echo $this->element('sql_dump'); ?>
   
 
         
<?php         echo $this->Html->css(array('../js/jvectormap/jquery-jvectormap-1.2.2','../js/rickshaw/rickshaw.min'));?>
 <?php  echo $this->Html->script('gsap/main-gsap');
 echo $this->Html->script('jquery-ui/js/jquery-ui-1.10.3.minimal.min');
 echo $this->Html->script('bootstrap');
 echo $this->Html->script('joinable');
 echo $this->Html->script('neon-api');
 echo $this->Html->script('jvectormap/jquery-jvectormap-1.2.2.min');
 echo $this->Html->script('jvectormap/jquery-jvectormap-europe-merc-en');
 echo $this->Html->script('jquery.sparkline.min');
 echo $this->Html->script('rickshaw/vendor/d3.v3');
 echo $this->Html->script('rickshaw/rickshaw.min');
 echo $this->Html->script('raphael-min');
 echo $this->Html->script('morris.min');
 echo $this->Html->script('toastr');
 echo $this->Html->script('resizeable');
 echo $this->Html->script('neon-chat');
 echo $this->Html->script('neon-custom');
 echo $this->Html->script('neon-demo'); 
 ?>
	