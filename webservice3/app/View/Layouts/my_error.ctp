<!doctype html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title><?php echo $title_for_layout; ?></title>
        <meta name="description" content="">
        <!--<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1">-->
        <meta name="viewport" content="width=device-width">
        <?php
        echo $this->Html->css(array('bootstrap', 'jquery.fancybox', 'style'));

        echo $this->Html->script(array('jquery', 'jquery.fitText', 'error'));
        ?>
    </head>
    <body class='b_error'>
        <?php echo $this->fetch('content'); ?>

    </body>
</html>