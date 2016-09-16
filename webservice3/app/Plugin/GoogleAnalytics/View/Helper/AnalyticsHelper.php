<?php
    App::uses('AppHelper', 'View/Helper');

    class AnalyticsHelper extends AppHelper {

        public $helpers = array('Html');

        private $ANALYTICS_ACCOUNT = 'UA-46259768-1';

        function foot($noScript = NULL) {
            ob_start();
            if(is_null($noScript)){
                echo '<script type="text/javascript">';
            }
        ?>
        var _gaq = _gaq || [];
        _gaq.push(['_setAccount', '<?php echo $this->ANALYTICS_ACCOUNT; ?>']);
        _gaq.push(['_trackPageview']);

        (function() {
        var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);

        })();

        <?php
        if(is_null($noScript)){
            echo '</script>';
        }
        return ob_get_clean();
    }

    function send() {        
        return "_gaq.push(['_trackEvent', 'Campaign-'+Campaign.Campaign.id, curr_event, curr_group ,parseInt(Campaign.Campaign.id)]);";
    }
    function send_mobile() {
        return "_gaq.push(['_trackEvent', 'Mobile Creative-'+MobileCreative.MobileCreative.id, curr_event, curr_group ,parseInt(MobileCreative.MobileCreative.id)]);";
    }
    function send_mobile_creative() {
        return "_gaq.push(['_trackEvent', 'Mobile Creative-'+Campaign.MobileCreative.id, curr_event, curr_group ,parseInt(Campaign.MobileCreative.id)]);";
    }

}
