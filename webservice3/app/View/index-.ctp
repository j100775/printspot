<?php 
$this->start('inline');
$paging_params_array = array();
if (!empty($this->request->params['named']['sort']))
    $paging_params_array['sort'] = $this->request->params['named']['sort'];
if (!empty($this->request->params['named']['direction']))
    $paging_params_array['direction'] = $this->request->params['named']['direction'];
?>
<script type="text/javascript">
    function setLocation(){
        <?php if(isset($this->params['named']['type'])){?>
        var url='<?php echo $this->Html->url(array_merge(array('controller' => 'campaigns', 'action' => 'index', 'admin' => false, 'type'=>$this->params['named']['type']), $this->request->params['pass'], $paging_params_array), true); ?>';
        <?php }else{?>
        var url='<?php echo $this->Html->url(array_merge(array('controller' => 'campaigns', 'action' => 'index', 'admin' => false,''), $this->request->params['pass'], $paging_params_array), true); ?>';
        <?php }?>
        if($('#keyword').val()!='')
            url+='/keyword:'+$('#keyword').val();
        if($('#advertiser_id').val()!='')
            url+='/advertiser_id:'+$('#advertiser_id').val();
        if($('#publisher_id').val()!='')
            url+='/publisher_id:'+$('#publisher_id').val();
        window.location.href=url;
    }
   
    function clearAll(){
        $('.filters [name^=data]').val('');
        setLocation();
    }
	function del() {
		var ans = confirm("Are you sure want to delete?");
		if(ans==true) {
			return true;
		} else {
			return false;
		}
		return true;
	}
</script>
<?php
$this->end();
?>
<div class="row-fluid no-margin">
    <div class="span12">

        <ul class="quicktasks">
            <li>
                <?php echo $this->Html->link($this->Html->image("icons/essen/32/campaigns.png", array('alt' => '')) . ' <span>Add New Campaign</span>', array('controller' => 'campaigns', 'action' => 'addCat'), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Add New Campaign"))); ?>

            </li>

        </ul>
    </div>
    
</div>

<div class="row-fluid">
    
    <div class="span12">
        <div class="box">
            <div class="box-content filters" style="padding: 10px 15px 0;">
                <span id="error_msg"></span>
                <div class="control-group" style="float: left;padding-right: 10px;" >
                    <label class="control-label"  ><?php echo __('Keyword'); ?>:</label>
                    <div class="controls" style="float: left; ">
                        <?php echo $this->Form->input('keyword', array('label' => false, 'value' => @$this->request->params['named']['keyword'])) ?>
                    </div>
                </div>

                <div class="control-group" style="float: left;padding-right: 10px;">
                    <label class="control-label"  ><?php echo __('Advertiser'); ?>:</label>
                    <div class="controls">
                        <?php echo $this->Form->select('advertiser_id', $advertisers, array('onchange' => "setLocation()", 'empty' => __('All'), 'value' => @$this->request->params['named']['advertiser_id']));
                        ?>
                    </div>
                </div>
                <div class="control-group" style="float: left;padding-right: 10px;">
                    <label class="control-label"  ><?php echo __('Publisher'); ?>:</label>
                    <div class="controls">
                        <?php echo $this->Form->select('publisher_id', $publishers, array('onchange' => "setLocation()", 'empty' => __('All'), 'value' => @$this->request->params['named']['publisher_id']));
                        ?>
                    </div>
                </div>
                <?php echo $this->Form->button(__('Submit'), array('type' => "button", 'class' => "btn btn-primary", 'style' => "float: left; margin: 23px 10px 0 0;", 'onclick' => 'setLocation()')) ?>
                <?php echo $this->Form->button(__('Reset'), array('type' => "button", 'class' => "btn btn-primary", 'style' => "float: left; margin: 23px 10px 0 0;", 'onclick' => "clearAll();")) ?>
                <div style="clear: both;"></div>
            </div>
            <div class="box-head tabs">
							
							<ul class="nav nav-tabs" style="float:left;">
								
                                                                
                                                                <?php 
                                                               $name='Script/iframe';
                                                                foreach (AppController::$campaigns_type as $k => $v) {
                                                                    
                                                                preg_match('/^[a-zA-Z]+/', $v, $matches);?>
                                                            <li class="<?php echo (isset($type) && strtolower($matches[0]) == $type) ? 'active' : ''; ?>"><?php echo $this->Html->link($v, array('controller'=>'campaigns','action'=>'index','type'=>strtolower($matches[0]))); ?></li>
                                                                 <?php      
                                                                 if(isset($type) && strtolower($matches[0]) == $type){
                                                                      $name=$v;
                                                                 }
                                                                   } 
                                                                
                                                                ?> 
							</ul>
						</div>
            
            
            
            
  <?php          
  if(!isset($this->params['named']['type']) ||(isset($this->params['named']['type']) && $this->params['named']['type']!='vast')){
$direction = $this->Paginator->sortDir();
$image = 'sort_' . $direction . '.png';
$key = $this->Paginator->sortKey();
$id_link = ($key == 'Campaign.id') ? $this->Html->image($image) : '';
$name_link = ($key == 'Campaign.name') ? $this->Html->image($image) : '';
$advertiser_name_link = ($key == 'Advertiser.full_name') ? $this->Html->image($image) : '';
$publisher_name_link = ($key == 'Publisher.full_name') ? $this->Html->image($image) : '';
$campaign_type_link = ($key == 'Campaign.campaign_type') ? $this->Html->image($image) : '';
$created_link = ($key == 'Campaign.created') ? $this->Html->image($image) : '';
$modified_link = ($key == 'Campaign.modified') ? $this->Html->image($image) : '';
?>          
            
            
            
            
            
            
            
            <div class="box-head">
                
                <h3><?php echo __($name); ?></h3>
            </div>
            
            <div class="box-content box-nomargin">
                <?php echo $this->Session->flash('campaign_add'); ?>
                <?php echo $this->Session->flash('campaign_player_welcome_image_add'); ?>
                <?php echo $this->Session->flash('campaign_edit'); ?>
                <?php echo $this->Session->flash('campaign_player_welcome_image_edit'); ?>
                <?php echo $this->Session->flash('campaign_delete'); ?>
                <!--<table class='table table-striped dataTable dataTable-noheader dataTable-nofooter table-bordered'>-->
                <table class='table table-striped table-bordered'>
                    <thead>
                        <tr>
                            <th>
                                <?php
                                echo $this->Paginator->sort('Campaign.id', __('Id') . $id_link, array('escape' => false));
                                ?>
                            </th>
                            <th>
                                <?php
                                echo $this->Paginator->sort('Campaign.name', __('Name') . $name_link, array('escape' => false));
                                ?>
                            </th>
                            <th>
                                <?php
                                echo $this->Paginator->sort('Advertiser.full_name', __('Advertiser Name') . $advertiser_name_link, array('escape' => false));
                                ?>
                            </th>
                            <th>
                                <?php
                                echo $this->Paginator->sort('Publisher.full_name', __('Publisher Name') . $publisher_name_link, array('escape' => false));
                                ?>
                            </th>                            
                            <th>
                                <?php echo $this->Paginator->sort('Campaign.campaign_type', __('Campaign Type') . $campaign_type_link, array('escape' => false)); ?>
                            </th>

                            <th>
                                <?php echo $this->Paginator->sort('Campaign.created', __('Created') . $created_link, array('escape' => false)); ?>
                            </th>
                            <th>
                                <?php echo $this->Paginator->sort('Campaign.modified', __('Modified') . $modified_link, array('escape' => false)); ?>
                            </th>
                            <th><?php echo __('Action'); ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
//                        echo "<pre>";pr($CampaignList);die;
                        for ($i = 0, $Campaign_count = count($CampaignList); $i < $Campaign_count; $i++) {
                            if ($CampaignList[$i]['Campaign']['campaign_type'] == 1) {
                                $video_name = md5($CampaignList[$i]['Campaign']['media_library_id']);
                                //$frame_rate = floor($MsliderMediaLibrariesSetting['MsliderMediaLibrariesSetting']['frame_rate']);
                                $duration = floor($CampaignList[$i]['Campaign']['video_duration']);
                                $spriteCount = floor($duration);
                                $banner_image = $CampaignList[$i]['Campaign']['banner_image'];
                                $campaignId = $CampaignList[$i]['Campaign']['id'];
                                ob_start();
                                $jsUrlArray = array('controller' => 'mslider_themes', 'action' => 'view');
                                $jsUrlParams = array();
                                if (!empty($CampaignList[$i]['MediaSetting'][0]['skin_id'])) {
                                    array_push($jsUrlParams, $CampaignList[$i]['MediaSetting'][0]['skin_id']);
                                } else {
                                    array_push($jsUrlParams, 1);
                                }
                                if (!empty($CampaignList[$i]['MediaSetting'][0]['mslider_overlayad_id'])) {
                                    array_push($jsUrlParams, $CampaignList[$i]['MediaSetting'][0]['mslider_overlayad_id']);
                                }
                                array_push($jsUrlParams, 'createVideo.js');

                                $jsUrlArray = array_merge($jsUrlArray, $jsUrlParams);
                                ?><script type="text/javascript">var siteUrl = "<?php echo MSLIDER_ASSET_URL; ?>";var video_name = "<?php echo $video_name; ?>";var video_duration = "<?php echo $duration; ?>";var sprite_count = "<?php echo $spriteCount; ?>";var banner_image = "<?php echo $banner_image; ?>";var url=[["<?php echo MEDIA_LIB_VIDEOS_URL . substr($video_name, -2) . "/" . $video_name . "/"; ?>sprite/_a.mp4","<?php echo $campaignId;?>","192103"]];</script><script type="text/javascript" src="<?php echo $this->Html->url($jsUrlArray, true); ?>"></script><script type="text/javascript">init();</script>
                    OR 
<script type="text/javascript" src="<?php echo $this->Html->url(array('controller' => 'campaigns', 'action' => 'view', urlencode( base64_encode($campaignId)), 'player.js'), true) ?>"></script><script type="text/javascript">init();</script> 
                   <?php                             
                        $mslider_code = ob_get_clean();

                        $mslider_code = htmlentities($mslider_code);
                    }
                    echo "<tr>";
                    echo "<td>" . $CampaignList[$i]['Campaign']['id'] . "</td>";
                    echo "<td>" . $CampaignList[$i]['Campaign']['name'] . "</td>";
                    echo "<td>" . $CampaignList[$i]['Advertiser']['full_name'] . "</td>";
                    echo "<td>" . $CampaignList[$i]['Publisher']['full_name'] . "</td>";
                    echo "<td>" . AppController::$campaigns_type[$CampaignList[$i]['Campaign']['campaign_type']] . "</td>";
                    echo "<td>" . $CampaignList[$i]['Campaign']['created'] . "</td>";
                    echo "<td>" . $CampaignList[$i]['Campaign']['modified'] . "</td>";
                    echo "<td class='actions_big'><div class='btn-group'>";
					if($CampaignList[$i]['Campaign']['campaign_type']==0) {
                    echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => 'add', $CampaignList[$i]['Campaign']['campaign_type'], $CampaignList[$i]['Campaign']['id'],'type'=>'general'), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));
					} else {
                    echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => 'edit', $CampaignList[$i]['Campaign']['id'], $CampaignList[$i]['Campaign']['campaign_type']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));
					}
					
                    echo ' <span style="float:left">|</span> ' . $this->Html->link($this->Html->image("icons/fugue/cross.png"), array('controller' => 'campaigns', 'action' => 'delete', $CampaignList[$i]['Campaign']['id']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Delete")), "Are you sure?");
                    echo ' <span style="float:left">|</span> ' . $this->Html->link('</>', '#Embed' . $CampaignList[$i]['Campaign']['id'], array('escape' => true, "class" => "btn btn-mini tip", "data-toggle" => "modal", "title" => __("Share")));
                    $width = (!empty($CampaignList[$i]['MediaSetting'][0]['width']) ? $CampaignList[$i]['MediaSetting'][0]['width'] : "100%");
                    $height = (!empty($CampaignList[$i]['MediaSetting'][0]['height']) ? $CampaignList[$i]['MediaSetting'][0]['height'] : "100%");
                    $otherAttr = 'scrolling="no" frameborder="0" style="border: 0 none white; overflow: hidden;"';
                    echo '<div id="Embed' . $CampaignList[$i]['Campaign']['id'] . '" class="modal hide" ><div class="modal-header"><button data-dismiss="modal" class="close" type="button">X</button><h3>Share</h3></div><div class="modal-body"><div class="box-head"><h3>Embed Code</h3></div><pre>' . htmlentities('<iframe src="' . $this->Html->url(array('controller' => 'campaigns', 'action' => 'view', $CampaignList[$i]['Campaign']['id']), true) . '" width="' . $width . '" height="' . $height . '" ' . $otherAttr . '></iframe>') . '</pre><div class="box-head"><h3>Javascript</h3></div><pre>' . htmlentities('<script type="text/javascript">') . 'document.getElementById("iholder").innerHTML=\'' . htmlentities('<iframe src="' . $this->Html->url(array('controller' => 'campaigns', 'action' => 'view', $CampaignList[$i]['Campaign']['id']), true) . '" width="' . $width . '" height="' . $height . '" ' . $otherAttr . '></iframe>\'</script>') . '</pre><div class="box-head"><h3>Script Tag</h3></div><pre>' . htmlentities('<script type="text/javascript" src="' . $this->Html->url(array('controller' => 'campaigns', 'action' => 'view', $CampaignList[$i]['Campaign']['id'], 'player.js'), true) . '"></script>') . '</pre>' . (($CampaignList[$i]['Campaign']['campaign_type'] == 1) ? '<div class="box-head"><h3>Script Tag For Mslider</h3></div><pre>' . $mslider_code . '</pre>' : '') . '</div><div class="modal-footer"><a data-dismiss="modal" class="btn" href="#">Close</a></div></div>';
                    echo "</div></td></tr>";
                }
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="box">
        <div class="box-head">
            <div class="dataTables_paginate paging_bootstrap pagination">
                <ul>
                    <?php
                    echo @$this->Paginator->first("First", array('escape' => false, 'tag' => 'li'), null, array('class' => 'first disabled', 'escape' => false, 'tag' => 'li'));
                    echo @$this->Paginator->prev("&larr; Previous", array('escape' => false, 'tag' => 'li'), null, array('class' => 'prev disabled', 'escape' => false, 'tag' => 'li'));

                    echo '&nbsp;' . @$this->Paginator->numbers(array('tag' => 'li', 'separator' => '', 'currentClass' => 'active'));
                    echo @$this->Paginator->next("Next &rarr;", array('escape' => false, 'tag' => 'li'), null, array('class' => 'next disabled', 'escape' => false, 'tag' => 'li'));
                    echo @$this->Paginator->last("Last", array('escape' => false, 'tag' => 'li'), null, array('class' => 'last disabled', 'escape' => false, 'tag' => 'li'));
                    ?>
                </ul>
            </div>
        </div>
    </div>
</div>








<?php
}elseif(isset($this->params['named']['type']) && $this->params['named']['type']=='vast'){
$direction = $this->Paginator->sortDir('Vpaid');
$image = 'sort_' . $direction . '.png';
$key = $this->Paginator->sortKey('Vpaid');
$id_link = ($key == 'Vpaid.id') ? $this->Html->image($image) : '';
$is_vast_link = ($key == 'Vpaid.is_vast') ? $this->Html->image($image) : '';
$created_link = ($key == 'Vpaid.created') ? $this->Html->image($image) : '';
$modified_link = ($key == 'Vpaid.modified') ? $this->Html->image($image) : '';
?>

<div class="row-fluid">
    <div class="span12">
        <div class="box">
            <div class="box-head">
             
                
                <h3><?php echo __('VAST/VPAID'); ?></h3>
            </div>

            <div class="box-content box-nomargin">
                <?php echo $this->Session->flash('vpaid_add'); ?>
                <?php echo $this->Session->flash('vpaid_add_vast'); ?>
                <!--<table class='table table-striped dataTable dataTable-noheader dataTable-nofooter table-bordered'>-->
                <table class='table table-striped table-bordered'>
                    <thead>
                        <tr>
                            <th>
                                <?php
                                echo $this->Paginator->sort('Vpaid.id', __('Id') . $id_link, array('escape' => false));
                                ?>
                            </th>                                                       
                            <th>
                                <?php echo $this->Paginator->sort('Vpaid.is_vast', __('Is Vast?') . $is_vast_link, array('escape' => false)); ?>
                            </th>
                            <th>
                                <?php echo $this->Paginator->sort('Vpaid.created', __('Created') . $created_link, array('escape' => false)); ?>
                            </th>
                            <th>
                                <?php echo $this->Paginator->sort('Vpaid.modified', __('Modified') . $modified_link, array('escape' => false)); ?>
                            </th>
                            <th><?php echo __('Action'); ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        for ($i = 0, $Vpaid_count = count($VpaidList); $i < $Vpaid_count; $i++) {
                            echo "<tr>";
                            echo "<td>" . $VpaidList[$i]['Vpaid']['id'] . "</td>";
                            echo "<td>" . ($VpaidList[$i]['Vpaid']['is_vast'] ? __('Yes') : __('No')) . "</td>";
                            echo "<td>" . $VpaidList[$i]['Vpaid']['created'] . "</td>";
                            echo "<td>" . $VpaidList[$i]['Vpaid']['modified'] . "</td>";
                            echo "<td class='actions_big'><div class='btn-group'>";
                            echo $this->Html->link($this->Html->image("icons/essen/16/zoom.png"), array('controller' => 'vpaid', 'action' => 'view', $VpaidList[$i]['Vpaid']['id']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("View"), 'target' => '_blank'));
                            //echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => 'edit', $VpaidList[$i]['Vpaid']['id'], ($VpaidList[$i]['Vpaid']['is_vast'] ? 2 : 3)), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));
                            /*echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => ($VpaidList[$i]['Vpaid']['type']=='linear')? 'editLinear' : 'editNonlinear', $VpaidList[$i]['Vpaid']['id']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));*/
							if($VpaidList[$i]['Vpaid']['type']=="linear") {
							 echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => 'addLinear', $VpaidList[$i]['Vpaid']['id'],'type'=>'general'), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));
						} else {
                            echo $this->Html->link($this->Html->image("icons/essen/16/edit.png"), array('controller' => 'campaigns', 'action' => ($VpaidList[$i]['Vpaid']['type']=='linear')? 'editLinear' : 'editNonlinear', $VpaidList[$i]['Vpaid']['id']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Edit")));
						}
                            
							 echo $this->Html->link($this->Html->image("icons/fugue/cross.png"), array('controller' => 'campaigns', 'action' => 'delete_vast', $VpaidList[$i]['Vpaid']['id']), array('escape' => false, "class" => "btn btn-mini tip", "title" => __("Delete"),"onclick"=>"return del();"));
                            
                             echo ' <span style="float:left">|</span> ' . $this->Html->link('</>', '#EmbedVpaid' . $VpaidList[$i]['Vpaid']['id'], array('escape' => true, "class" => "btn btn-mini tip", "data-toggle" => "modal", "title" => __("Share")));
                    $width = "100%";
                    $height = "100%";
                    $otherAttr = 'scrolling="no" frameborder="0" style="border: 0 none white; overflow: hidden;"';
                    echo '<div id="EmbedVpaid' . $VpaidList[$i]['Vpaid']['id']. '" class="modal hide" ><div class="modal-header"><button data-dismiss="modal" class="close" type="button">X</button><h3>Share</h3></div><div class="modal-body"><div class="box-head"><h3>Url</h3></div><pre>' . htmlentities($this->Html->url(array('controller' => 'campaigns', 'action' => 'vastXml', $VpaidList[$i]['Vpaid']['id']), true) ) . '</pre><div class="box-head"><h3>Javascript</h3></div>'.html_entity_decode('<iframe runat="server" src="' . $this->Html->url(array('controller' => 'campaigns', 'action' => 'vastXml', $VpaidList[$i]['Vpaid']['id']), true) . '" width="' . $width . '" height="' . $height . '" ' . $otherAttr . '></iframe>').'<div class="box-head"><h3>Script Tag</h3></div><pre>' . htmlentities('<script type="text/javascript" src="' . $this->Html->url(array('controller' => 'vpaids', 'action' => 'view', $VpaidList[$i]['Vpaid']['id'], 'player.js'), true) . '"></script>') . '</pre>' . '</div><div class="modal-footer"><a data-dismiss="modal" class="btn" href="#">Close</a></div></div>';
                            
                            echo "</div></td></tr>";
                        }
                        ?>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <div class="box">
        <div class="box-head">
            <div class="dataTables_paginate paging_bootstrap pagination">
                <ul>
                    <?php
                    echo @$this->Paginator->first("First", array('escape' => false, 'tag' => 'li', 'model' => 'Vpaid'), null, array('class' => 'first disabled', 'escape' => false, 'tag' => 'li', 'model' => 'Vpaid'));
                    echo @$this->Paginator->prev("&larr; Previous", array('escape' => false, 'tag' => 'li', 'model' => 'Vpaid'), null, array('class' => 'prev disabled', 'escape' => false, 'tag' => 'li', 'model' => 'Vpaid'));

                    echo '&nbsp;' . @$this->Paginator->numbers(array('tag' => 'li', 'separator' => '', 'currentClass' => 'active', 'model' => 'Vpaid'));
                    echo @$this->Paginator->next("Next &rarr;", array('escape' => false, 'tag' => 'li', 'model' => 'Vpaid'), null, array('class' => 'next disabled', 'escape' => false, 'tag' => 'li', 'model' => 'Vpaid'));
                    echo @$this->Paginator->last("Last", array('escape' => false, 'tag' => 'li', 'model' => 'Vpaid'), null, array('class' => 'last disabled', 'escape' => false, 'tag' => 'li', 'model' => 'Vpaid'));
                    ?>
                </ul>
            </div>
        </div>
    </div>
</div>
<?php }?>