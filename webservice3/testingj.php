<?php
    echo $this->element('admin_header');
?>

<hr />
<ol class="breadcrumb bc-3">
    <li>
        <a href="#"><i class="entypo-home"></i>Home</a>
    </li>

    <li class="active">

        <strong>Dashboard</strong>
    </li>
</ol>

<h2>Dashboard </h2>
<br />

<div class="row">
    <?php if(isset($schools) && !empty($schools)){ ?>
        <div class="col-sm-3">

            <div class="tile-stats tile-red">
                <div class="icon"><i class="entypo-users"></i></div>
                <div class="num" data-start="0" data-end="<?php echo count($schools) ?>" data-postfix="" data-duration="1500" data-delay="0">0</div>

                <h3>Registered Driving Schools </h3>

            </div>

        </div>
        <?php } ?>
    <?php if($userType!=3){ ?>

        <div class="col-sm-3">

            <div class="tile-stats tile-green">
                <div class="icon"><i class="entypo-chart-bar"></i></div>
                <div class="num" data-start="0" data-end="<?php echo count($staff) ?>" data-postfix="" data-duration="1500" data-delay="600">0</div>

                <h3>Registered Office Staff</h3>
                <p>so far in our App.</p>
            </div>

        </div>

        <div class="col-sm-3">

            <div class="tile-stats tile-aqua">
                <div class="icon"><i class="entypo-mail"></i></div>
                <div class="num" data-start="0" data-end="<?php echo count($instructors) ?>" data-postfix="" data-duration="1500" data-delay="1200">0</div>

                <h3>Registered Driving Instructors</h3>

            </div>

        </div>

        <div class="col-sm-3">

            <div class="tile-stats tile-blue">
                <div class="icon"><i class="entypo-rss"></i></div>
                <div class="num" data-start="0" data-end="<?php echo count($studentCount) ?>" data-postfix="" data-duration="1500" data-delay="1800">0</div>

                <h3>Registered Students</h3>
                <p>so far in our App.</p>
            </div>

        </div>
        <?php } 
        else
        {
        ?>
        <div class="col-sm-3">
            <a href="<?php echo $this->Html->url(array('controller'=>'students','action'=>'my_class')) ?>">
                <div class="tile-stats tile-green">
                    <div class="icon"><i class="entypo-chart-bar"></i></div>
                    <div class="num"  data-end="" data-postfix="" data-duration="1500" data-delay="600">Get</div>
                    <h3>My Classes</h3>
                </div>
            </a>


        </div>
        <div class="col-sm-3">
            <a href="<?php echo $this->Html->url(array('controller'=>'students','action'=>'my_student')) ?>">
                <div class="tile-stats tile-green">
                    <div class="icon"><i class="entypo-chart-bar"></i></div>
                    <div class="num"  data-end="0" data-postfix="" data-duration="1500" data-delay="600"><?php echo count($student); ?></div>
                    <h3>My Students</h3>
                </div>
            </a>
        </div>
        <?php } ?>
</div>
