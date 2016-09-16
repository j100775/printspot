<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title><?php echo $title_for_layout; ?></title>
        <meta name="description" content="">
        <!--<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1">-->
        <meta name="viewport" content="width=device-width">
        <?php
        echo $this->Html->css(array('bootstrap', 'bootstrap-responsive', 'uniform.default', 'jquery.cleditor', 'jquery.plupload.queue', 'jquery.tagsinput', 'jquery.ui.plupload', 'chosen', 'jquery.fancybox'));

        if (AuthComponent::user('id')) {
            if ($this->Session->read("style") == "red") {
                echo $this->Html->css('red');
            } elseif ($this->Session->read("style") == "green") {
                echo $this->Html->css('green');
            } elseif ($this->Session->read("style") == "blue") {
                echo $this->Html->css('blue');
            } else {
                echo $this->Html->css('style');
            }
        } else {
            echo $this->Html->script(array('jquery'));
            echo $this->Html->css('style');
        }        
        ?>
        <style type="text/css">
            .pagination:not(.widget) .disabled, .pagination:not(.widget) .active  {
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
            .pagination:not(.widget) .active {
                border-left: 0px;
            }
            .pagination:not(.widget) .disabled {
                background-color: transparent;
            }
        </style>
        <script type="text/javascript">
            var SITE_URL = '<?php echo SITE_URL ?>';
        </script>
        <?php
        echo $this->Html->script(array('jquery', 'less', 'bootstrap.min', 'jquery.uniform.min', 'bootstrap.timepicker', 'bootstrap.datepicker', 'chosen.jquery.min', 'jquery.fancybox','jquery.peity','jquery.flot','jquery.flot.pie','jquery.flot.resize','jquery.flot.orderBars', 'plupload/plupload.full', 'plupload/jquery.plupload.queue/jquery.plupload.queue', 'jquery.cleditor.min', 'jquery.inputmask.min', 'jquery.tagsinput.min', 'jquery.mousewheel', 'jquery.dataTables.min', 'jquery.dataTables.bootstrap', 'jquery.textareaCounter.plugin', 'ui.spinner', 'jquery.form.js', 'jquery.validate.min.js','jquery.color', 'custom'));
        echo $this->fetch('css');
        echo $this->fetch('script');
        echo $this->fetch('inline');
        ?>
        
    </head>
    <body>
        <?php
        if (AuthComponent::user('id')) {
            ?>
            <div class="style-toggler">
                <?php echo $this->Html->image('icons/fugue/color.png', array('alt' => "", 'class' => 'tip', 'title' => __("Toggle style-switcher"), 'data-placement' => "right")); ?>
            </div>
            <div class="style-switcher">
                <h3><?php echo __('Style-switcher'); ?></h3>
                <ul>
                    <li>
                        <?php echo $this->Html->link("Default", array("controller" => "users", "action" => "setstyle", "default")); ?>

                    </li>
                    <li>
                        <?php echo $this->Html->link("Blue", array("controller" => "users", "action" => "setstyle", "blue"), array("class" => "blue")); ?>
                    </li>
                    <li>
                        <?php echo $this->Html->link("Green", array("controller" => "users", "action" => "setstyle", "green"), array("class" => "green")); ?>
                    </li>
                    <li>
                        <?php echo $this->Html->link("Red", array("controller" => "users", "action" => "setstyle", "red"), array("class" => "red")); ?>
                    </li>
                </ul>
            </div>

            <?php
        }
        if (!($this->request->controller == 'users' && in_array($this->request->action, array('login', 'forgot_password'))))
            echo $this->element("header");
        echo $this->fetch('content');
        if (!($this->request->controller == 'users' && in_array($this->request->action, array('login', 'forgot_password'))))
            echo $this->element("footer");
        ?>
        <?php // echo $this->element('sql_dump'); ?>
    </body>
</html>