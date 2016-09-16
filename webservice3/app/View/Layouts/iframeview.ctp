<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title><?php echo $title_for_layout; ?></title>
        <meta name="description" content="">
        <!--<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1">-->
        <meta name="viewport" content="width=device-width">
        <?php
        echo $this->Html->css(array(SITE_URL.'css/bootstrap.css', SITE_URL.'css/bootstrap-responsive.css',/* SITE_URL.'css/uniform.default.css', /*'bootstrap.datepicker',*/ SITE_URL.'css/jquery.cleditor.css', SITE_URL.'css/jquery.plupload.queue.css', SITE_URL.'css/jquery.tagsinput.css', SITE_URL.'css/jquery.ui.plupload.css', SITE_URL.'css/chosen.css', SITE_URL.'css/jquery.fancybox.css'));

        if (AuthComponent::user('id')) {
            if ($this->Session->read("style") == "red") {
                echo $this->Html->css(SITE_URL.'css/red.css');
            } elseif ($this->Session->read("style") == "green") {
                echo $this->Html->css(SITE_URL.'css/green.css');
            } elseif ($this->Session->read("style") == "blue") {
                echo $this->Html->css(SITE_URL.'css/blue.css');
            } else {
                echo $this->Html->css(SITE_URL.'css/style.css');
            }
        } else {
            echo $this->Html->script(array('jquery'));
            echo $this->Html->css(SITE_URL.'css/style.css');
        }
        ?>
        <style type="text/css">
            .pagination .disabled, .pagination .active  {
                -moz-border-bottom-colors: none;
                -moz-border-left-colors: none;
                -moz-border-right-colors: none;
                -moz-border-top-colors: none;
                border-color: #DDDDDD;
                border-image: none;
                border-style: solid;
                border-width: 1px;
                float: left;
                line-height: 34px;
                padding: 0 14px;
                text-decoration: none;
                background-color: #F5F5F5;
                color: #999999;
                cursor: default;
                border-radius: 3px 0 0 3px;
            }
            .pagination .active {
                border-left: 0px;
            }
            .pagination .disabled {
                background-color: transparent;
            }
        </style>
        <script type="text/javascript">
            var SITE_URL = '<?= SITE_URL ?>';
            //alert(SITE_URL);
           
        </script>
        <?php 
        echo $this->Html->script(array(SITE_URL.'js/jquery.js', SITE_URL.'js/less.js', SITE_URL.'js/bootstrap.min.js', SITE_URL.'js/jquery.uniform.min.js', SITE_URL.'js/bootstrap.timepicker.js', SITE_URL.'js/bootstrap.datepicker.js', SITE_URL.'js/chosen.jquery.min.js', SITE_URL.'js/jquery.fancybox.js',SITE_URL.'js/jquery.peity.js',SITE_URL.'js/jquery.flot.js',SITE_URL.'js/jquery.flot.pie.js',SITE_URL.'js/jquery.flot.resize.js',SITE_URL.'js/jquery.flot.orderBars.js', SITE_URL.'js/plupload/plupload.full.js', SITE_URL.'js/plupload/jquery.plupload.queue/jquery.plupload.queue.js', SITE_URL.'js/jquery.cleditor.min.js', SITE_URL.'js/jquery.inputmask.min.js', SITE_URL.'js/jquery.tagsinput.min.js', SITE_URL.'js/jquery.mousewheel.js', SITE_URL.'js/jquery.dataTables.min.js', SITE_URL.'js/jquery.dataTables.bootstrap.js', SITE_URL.'js/jquery.textareaCounter.plugin.js', SITE_URL.'js/ui.spinner.js', SITE_URL.'js/jquery.form.js', SITE_URL.'js/jquery.validate.min.js',SITE_URL.'js/jquery.color.js',SITE_URL.'resizeable.js', SITE_URL.'js/custom.js', SITE_URL.'js/neon-custom.js'));
        echo $this->fetch('css');
        echo $this->fetch('script');
        echo $this->fetch('inline');
         echo $this->Html->script(array( 'jscolor/jscolor'));
        ?>
        <script> $(document).ready(function(){$('#debug-kit-toolbar').html('');});</script>
    </head>
    <body>
       <?php echo $this->fetch('content'); ?>
    </body>
</html>