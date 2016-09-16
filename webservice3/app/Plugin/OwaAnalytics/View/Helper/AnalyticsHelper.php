<?php

App::uses('AppHelper', 'View/Helper');

class AnalyticsHelper extends AppHelper {

    public $helpers = array('Html');
    private $ANALYTICS_ACCOUNT = '7b7c627e958309732ad10690b153664f';
    private  $owaBaseUrl = 'http://localhost/owa/';
	
    function foot($noScript = NULL) {
        ob_start();
        if(is_null($noScript)){
            echo '<script type="text/javascript">';
        }
        ?>
           // <![CDATA[
            var owa_baseUrl = '<?php echo $this->owaBaseUrl; ?>';
            var owa_cmds = owa_cmds || [];
            owa_cmds.push(['setSiteId', '<?php echo $this->ANALYTICS_ACCOUNT; ?>']);
            owa_cmds.push(['trackPageView']);
            owa_cmds.push(['trackClicks']);
            if(typeof mslider_campaign_type == 'undefined'){
              owa_cmds.push(['trackDomStream']);
            }  
        
            (function() {
                var _owa = document.createElement('script'); _owa.type = 'text/javascript'; _owa.async = true;
                owa_baseUrl = ('https:' == document.location.protocol ? window.owa_baseSecUrl || owa_baseUrl.replace(/http:/, 'https:') : owa_baseUrl );
                _owa.src = owa_baseUrl + 'modules/base/js/owa.tracker-combined-min.js';
                var _owa_s = document.getElementsByTagName('script')[0]; _owa_s.parentNode.insertBefore(_owa, _owa_s);
            }());
            //]]>
        
        <?php
         if(is_null($noScript)){
            echo '</script>';
         }
        return ob_get_clean();
    }

    function send() {
        return "owa_cmds.push(['trackAction', 'campaign-'+Campaign.Campaign.id, curr_event, curr_group ,10]);";
    }
    
    function trackPositioning() {
        return "owa_cmds.push(['setCustomVar', '3', 'Campaign Position',campaign_position, 'page']);";
    }
    
    function trackIframeStatus() {
        return "owa_cmds.push(['setCustomVar', '4', 'Iframe Status',errFlag, 'page']);";
    }
     function send_mobile() {
        return "owa_cmds.push(['trackAction', 'campaign-'+MobileCreative.MobileCreative.id, curr_event, curr_group ,10]);";
    }
    function send_mobile_creative() {
        return "owa_cmds.push(['trackAction', 'campaign-'+Campaign.MobileCreative.id, curr_event, curr_group ,10]);";
    }
}
