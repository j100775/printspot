<?php

App::uses('Component', 'Controller');

class AnalyticsComponent extends Component {

    private $request = null;
    private $siteId = '7b7c627e958309732ad10690b153664f';
    private $appKey = '280ee5c09025a4c207a334b905055dde';
   // private $apiUrl = 'http://localhost/owa/api.php';
    private $apiUrl = 'http://traking.vidaptiv.com/api.php';
    public $website;
    public $pubId;

//    private $siteId = '2b28f9038098afd302dfd69bc27b9122';
//    private $appKey = '5ad3f9fbf71ede7a3feb6f0ba07fc12c';
//    private $apiUrl = 'http://devaws.pmi5media.com/owa/api.php';
    function getResultSet($sql_query) {
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_env.php';
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_coreAPI.php';

        $db = owa_coreAPI::dbSingleton();
        $db->_sqlParams['query_type'] = 'select';
        $result = $db->rawQuery($sql_query);
        return $result;
    }

    function getPage($campArr, $options = array('limit' => '0,10', 'order' => array(), 'keyword' => ''), $params) {
        extract($params);
        $owa_response = array();
        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '( action_fact.action_group ="' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';

                $i++;
            endforeach;
            if (!isset($urlId) || empty($urlId))
                $urlId = " ";
            if ($dimension_key == 'source') {
                $constraint .= ') AND LOCATE("' . $urlId . '", source_dim_via_.source_domain) > 0';
            } else {
                $constraint .= ') AND LOCATE("' . $urlId . '", action_fact.cv5_value) > 0';
            }
        endif;

        try {
            if ($dimension_key == 'source') {
                $columns = "document_via_document_id.url AS pageUrl, COUNT(DISTINCT action_fact.id) AS actions, COUNT(DISTINCT action_fact.session_id) AS uniqueActions ";
                $count_cols = "1 AS a";
                $sql_query = "SELECT %s
                            FROM owa_action_fact AS action_fact 
                            JOIN owa_source_dim AS source_dim_via_ ON action_fact.source_id = source_dim_via_.id 
                            JOIN owa_document AS document_via_document_id ON action_fact.document_id = document_via_document_id.id 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' %s
                            GROUP BY document_via_document_id.url";
                $owa_response['results_count_unfiltered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, "").") AS t");
                $owa_response['results_count_unfiltered'] = $owa_response['results_count_unfiltered'][0]['cnt'];
                if (!empty($options['keyword'])) { 
                    $owa_response['results_count_filtered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, " AND document_via_document_id.url LIKE '%" . $options['keyword'] . "%'").") AS t");
                    $owa_response['results_count_filtered'] = $owa_response['results_count_filtered'][0]['cnt'];
                    $sql_query = sprintf($sql_query, $columns, " AND document_via_document_id.url LIKE '%" . $options['keyword'] . "%'");
                } else {
                    $owa_response['results_count_filtered'] = $owa_response['results_count_unfiltered'];
                    $sql_query = sprintf($sql_query, $columns, "");
                }
                if (!empty($options['order'])) {
                    if ($options['order']['column'] == 0){
                        $sql_query .=" ORDER BY document_via_document_id.url {$options['order']['dir']}";
                    }
                }
                if (!empty($options['limit'])) {
                    $sql_query .=" LIMIT " . $options['limit'];
                }
            } else {
                $columns = "document_via_document_id.url AS pageUrl, COUNT(DISTINCT action_fact.id) AS actions, COUNT(DISTINCT action_fact.session_id) AS uniqueActions ";
                $count_cols = "1 AS a";
                $sql_query = "SELECT %s 
                            FROM owa_action_fact AS action_fact 
                            JOIN owa_document AS document_via_document_id ON action_fact.document_id = document_via_document_id.id 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' %s
                            GROUP BY document_via_document_id.url";
                $owa_response['results_count_unfiltered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, "").") AS t");
                $owa_response['results_count_unfiltered'] = $owa_response['results_count_unfiltered'][0]['cnt'];
                if (!empty($options['keyword'])) { 
                    $owa_response['results_count_filtered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, " AND document_via_document_id.url LIKE '%" . $options['keyword'] . "%'").") AS t");
                    $owa_response['results_count_filtered'] = $owa_response['results_count_filtered'][0]['cnt'];
                    $sql_query = sprintf($sql_query, $columns, " AND document_via_document_id.url LIKE '%" . $options['keyword'] . "%'");
                } else {
                    $owa_response['results_count_filtered'] = $owa_response['results_count_unfiltered'];
                    $sql_query = sprintf($sql_query, $columns, "");
                }
                
                if (!empty($options['order'])) {
                    if ($options['order']['column'] == 0){
                        $sql_query .=" ORDER BY document_via_document_id.url {$options['order']['dir']}";
                    }
                }
                if (!empty($options['limit'])) {
                    $sql_query .=" LIMIT " . $options['limit'];
                }
            }
            
            $owa_response['rows'] = $this->getResultSet($sql_query);
            $owa_response['results_count'] = !empty($owa_response['rows'])?count($owa_response['rows']):0;            
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        return $owa_response;
    }

    function compareRecord($campArr, $params) {
        $ga_dimensions = array('source' => 'source', 'location' => 'customVarValue5');

        extract($params);
        $dimension = $ga_dimensions[$dimension_key];

        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '( action_fact.action_group ="' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';
                $i++;
            endforeach;
            if ($dimension == "source") {
                $j = 1;
                foreach ($urlArr as $url):
                    if ($j == 1)
                        $constraint .= ') AND (source_dim_via_.source_domain = "' . $url . '"';
                    else
                        $constraint .= ' OR source_dim_via_.source_domain = "' . $url . '"';
                    $j++;
                endforeach;
                $constraint .= ')';
                $sql_query = "SELECT source_dim_via_.source_domain as source, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions
                            FROM owa_action_fact as action_fact JOIN owa_source_dim AS source_dim_via_ ON action_fact.source_id = source_dim_via_.id 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                            GROUP BY source_dim_via_.source_domain,action_fact.yyyymmdd";
            } else {
                $j = 1;
                foreach ($urlArr as $url):
                    if ($j == 1)
                        $constraint .= ') AND (action_fact.cv5_value = "' . $url . '"';
                    else
                        $constraint .= ' OR action_fact.cv5_value = "' . $url . '"';
                    $j++;
                endforeach;
                $constraint .= ')';
                $sql_query = "SELECT action_fact.cv5_value as customVarValue5, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions
                            FROM owa_action_fact as action_fact
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                            GROUP BY action_fact.cv5_value, action_fact.yyyymmdd";
            }
        endif;

        try {
            $owa_response = $this->getResultSet($sql_query);
            $owa_response_aggregates = $this->getResultSet($sql_query_total);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        $responseLineChart = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => 0));
        for ($i = 0; $i < count($owa_response); $i++) {
            $responseLineChart['rows'][$i][] = $owa_response[$i][$dimension];
            $responseLineChart['rows'][$i][] = $owa_response[$i]['date'];
            $responseLineChart['rows'][$i][] = $owa_response[$i]['actions'];
            $responseLineChart['totalsForAllResults']['total'] += $owa_response[$i]['actions'];
        }
        $responseLineChart['headers'] = array(Inflector::humanize(array_search($dimension, $ga_dimensions)), 'Date', 'Total');

        return compact("responseLineChart");
    }

    function getEmbededframeStatus($campArr, $domain_name, $start, $end, $camType, $options = array('limit' => '0,10', 'order' => array(), 'keyword' => '')) {
        $owa_response = array();
        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '( action_fact.action_group ="' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';
                $i++;
            endforeach;
            $constraint .= ')';
        endif;

        try {
            $columns = "action_fact.cv4_value AS customVarValue4, count(distinct action_fact.id) AS actions, count(distinct action_fact.session_id) AS uniqueActions";
            $count_cols = "1 AS a";
            $sql_query = "SELECT %s FROM 
                        owa_action_fact AS action_fact 
                        JOIN owa_source_dim AS source_dim_via_ 
                            ON action_fact.source_id = source_dim_via_.id 
                      WHERE " . $constraint .
                    " AND action_fact.action_name = 'impression' 
                              AND LOCATE('" . $domain_name . "', source_dim_via_.source_domain) > 0 
                              AND action_fact.yyyymmdd BETWEEN '" . date('Ymd', strtotime($start)) . "' AND '" . date('Ymd', strtotime($end)) . "' AND action_fact.site_id = '" . $this->siteId . "'";
            $sql_query .= " %s GROUP BY action_fact.cv4_value ";
//            echo sprintf($sql_query, $count_cols, "",",count(distinct action_fact.id),count(distinct action_fact.session_id)");
            $owa_response['results_count_unfiltered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, "").") AS t");
            $owa_response['results_count_unfiltered'] = $owa_response['results_count_unfiltered'][0]['cnt'];
            if (!empty($options['keyword'])) { 
                $owa_response['results_count_filtered'] = $this->getResultSet("SELECT COUNT(*) AS cnt FROM (".sprintf($sql_query, $count_cols, " AND action_fact.cv4_value LIKE '%" . $options['keyword'] . "%'").") AS t");
                $owa_response['results_count_filtered'] = $owa_response['results_count_filtered'][0]['cnt'];
                $sql_query = sprintf($sql_query, $columns, " AND action_fact.cv4_value LIKE '%" . $options['keyword'] . "%'");
            } else {
                $owa_response['results_count_filtered'] = $owa_response['results_count_unfiltered'];
                $sql_query = sprintf($sql_query, $columns, "");
            }
//            echo $sql_query;
            if (!empty($options['order'])) {
                if ($options['order']['column'] == 0)
                    $sql_query .=" ORDER BY SUBSTRING_INDEX(cv4_value, '#', 1) {$options['order']['dir']}";
                if ($options['order']['column'] == 1)
                    $sql_query .=" ORDER BY SUBSTRING_INDEX(cv4_value, '#', -1) {$options['order']['dir']}";
            }
            if (!empty($options['limit'])) {
                $sql_query .=" LIMIT " . $options['limit'];
            }
            $owa_response['rows'] = $this->getResultSet($sql_query);
            $owa_response['results_count'] = !empty($owa_response['rows'])?count($owa_response['rows']):0;            
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        return $owa_response;
    }

    function getReportingData($campArr, $page, $params) {
        $ga_dimensions = array('event' => 'actionName', 'operating_system' => 'osType', 'browser' => 'browserType', 'country' => 'country', 'region' => 'stateRegion', 'city' => 'city', 'screen_resolution' => 'resolutionType', 'device_category' => 'deviceType', 'source' => 'source', 'location' => 'customVarValue5', 'campaign_position' => 'customVarValue3');

        extract($params);
        $dimension = $ga_dimensions[$dimension_key];
        $metrics = 'actions,uniqueActions';

        list($totalMetric, $secondaryMetric) = explode(",", $metrics);

        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '(action_fact.action_group = "' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';

                if ($i == $total_creatives && !empty($this->website) && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '" AND action_fact.cv1_value = "' . $this->pubId . '"';
                } else if ($i == $total_creatives && !empty($this->website)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '"';
                } else if ($i == $total_creatives && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv1_value = "' . $this->pubId . '"';
                }

                $i++;
            endforeach;
            $constraint.= ' )';
        endif;
        $sql_query_total = "SELECT count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions FROM owa_action_fact as action_fact 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                            LIMIT 1";

        if ($dimension_key == 'event') {
            $sql_query = "SELECT action_fact.action_name as actionName, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact 
                        WHERE " . $constraint . " AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY action_fact.action_name, action_fact.yyyymmdd";
        } else if ($dimension_key == 'operating_system') {
            $sql_query = "SELECT os_via_.name as osType, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_os AS os_via_ ON action_fact.os_id = os_via_.id 
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY os_via_.name, action_fact.yyyymmdd";
        } else if ($dimension_key == 'browser') {
            $sql_query = "SELECT ua_via_.browser_type as browserType, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_ua AS ua_via_ ON action_fact.ua_id = ua_via_.id
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY ua_via_.browser_type, action_fact.yyyymmdd";
        } else if ($dimension_key == 'country') {
            $sql_query = "SELECT location_dim_via_.country as country, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_location_dim AS location_dim_via_ ON action_fact.location_id = location_dim_via_.id
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY location_dim_via_.country, action_fact.yyyymmdd";
        } else if ($dimension_key == 'region') {
            $sql_query = "SELECT location_dim_via_.state as stateRegion, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_location_dim AS location_dim_via_ ON action_fact.location_id = location_dim_via_.id 
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression'  AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY location_dim_via_.state, action_fact.yyyymmdd";
        } else if ($dimension_key == 'city') {
            $sql_query = "SELECT location_dim_via_.city as city, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_location_dim AS location_dim_via_ ON action_fact.location_id = location_dim_via_.id 
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY location_dim_via_.city, action_fact.yyyymmdd";
        } else if ($dimension_key == 'screen_resolution') {
            $sql_query = "SELECT resolution_via_.name as resolutionType, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_resolution AS resolution_via_ ON action_fact.resolution_id = resolution_via_.id 
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY resolution_via_.name, action_fact.yyyymmdd";
        } else if ($dimension_key == 'device_category') {
            $sql_query = "SELECT device_via_.name as deviceType, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_device AS device_via_ ON action_fact.device_id = device_via_.id
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY device_via_.name, action_fact.yyyymmdd";
        } else if ($dimension_key == 'source') {
            $sql_query = "SELECT source_dim_via_.source_domain as source, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact JOIN owa_source_dim AS source_dim_via_ ON action_fact.source_id = source_dim_via_.id
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY source_dim_via_.source_domain  ORDER BY actions DESC LIMIT 100";
        } else if ($dimension_key == 'location') {
            $sql_query = "SELECT action_fact.cv5_value as customVarValue5, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY action_fact.cv5_value ORDER BY actions DESC LIMIT 100";
        } else if ($dimension_key == 'campaign_position') {
            $sql_query = "SELECT action_fact.cv3_value as customVarValue3, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY action_fact.cv3_value, action_fact.yyyymmdd";
        }
        //echo $sql_query;
        try {
            $owa_response = $this->getResultSet($sql_query);
            $owa_response_aggregates = $this->getResultSet($sql_query_total);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        if (empty($owa_response)) {
            throw new Exception(__('No records found.'));
        }
        $response = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric], 'unique' => $owa_response_aggregates[0][$secondaryMetric]));
        $response['self'] = '';
        $response['next'] = '';
        $response['total_pages'] = 0;

        for ($i = 0; $i < count($owa_response); $i++) {
            $response1['rows'][$owa_response[$i][$dimension]][0] = $owa_response[$i][$dimension];
            if (isset($response1['rows'][$owa_response[$i][$dimension]][1]))
                $response1['rows'][$owa_response[$i][$dimension]][1] += $owa_response[$i][$totalMetric];
            else
                $response1['rows'][$owa_response[$i][$dimension]][1] = $owa_response[$i][$totalMetric];

            // $response1['rows'][$owa_response[$i][$dimension]][2] = $owa_response[$i][$secondaryMetric];
            if (isset($response1['rows'][$owa_response[$i][$dimension]][2]))
                $response1['rows'][$owa_response[$i][$dimension]][2] += $owa_response[$i][$secondaryMetric];
            else
                $response1['rows'][$owa_response[$i][$dimension]][2] = $owa_response[$i][$secondaryMetric];
        }

        $response['totalResults'] = count($response1['rows']);
        $j = 0;
        foreach ($response1['rows'] as $resKey => $resVal) {
            $response['rows'][$j] = $resVal;
            //  unset($response['rows'][$resKey]);
            $j++;
        }

        $response['headers'][] = Inflector::humanize(array_search($dimension, $ga_dimensions));
        $response['headers'][] = 'Total';
        $response['headers'][] = 'Unique';

//        echo "<pre>";
//        print_r($response);
//        die;

        $responseLineChart = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric]));

        for ($i = 0; $i < count($owa_response); $i++) {

            $responseLineChart['rows'][$i][] = $owa_response[$i][$dimension];
            if ($dimension_key == "source" || $dimension_key == "location")
                $false = false;
            else
                $responseLineChart['rows'][$i][] = $owa_response[$i]['date'];

            $responseLineChart['rows'][$i][] = $owa_response[$i][$totalMetric];
        }

        $responseLineChart['headers'] = array(Inflector::humanize(array_search($dimension, $ga_dimensions)), 'Date', 'Total');

//        echo "<pre>";
//        print_r($responseLineChart);
//        die;

        $responseForSmallLineChart = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric], 'unique' => $owa_response_aggregates[0][$secondaryMetric]));
        $dimArray = array();
        foreach ($responseLineChart['rows'] as $val) {
            $responseForSmallLineChart1['rows'][$val[1]][0] = $val[1];
            if (isset($responseForSmallLineChart1['rows'][$val[1]][1])) {
                if ($dimension_key == "source" || $dimension_key == "location")
                    $responseForSmallLineChart1['rows'][$val[1]][1] += $val[1];
                else
                    $responseForSmallLineChart1['rows'][$val[1]][1] += $val[2];
            }else {
                if ($dimension_key == "source" || $dimension_key == "location")
                    $responseForSmallLineChart1['rows'][$val[1]][1] = $val[1];
                else
                    $responseForSmallLineChart1['rows'][$val[1]][1] = $val[2];
            }
            if (!in_array($val[1] . $val[0], $dimArray)) {
                array_push($dimArray, $val[1] . $val[0]);
                if (isset($responseForSmallLineChart1['rows'][$val[1]][2]))
                    $responseForSmallLineChart1['rows'][$val[1]][2] += 1;
                else
                    $responseForSmallLineChart1['rows'][$val[1]][2] = 1;
            }
        }

        $responseForSmallLineChart['totalResults'] = count($responseForSmallLineChart1['rows']);

        $k = 0;
        foreach ($responseForSmallLineChart1['rows'] as $smallKey => $smallVal) {
            $responseForSmallLineChart['rows'][$k] = $smallVal;
            //    unset($responseForSmallLineChart['rows'][$smallKey]);
            $k++;
        }

//        echo "<pre>";
//        print_r($responseForSmallLineChart);
//        die;
        $responseForSmallLineChart['headers'][] = 'Date';
        $responseForSmallLineChart['headers'][] = 'Total';
        $responseForSmallLineChart['headers'][] = 'Unique';

//        echo "<pre>";
//        print_r($response);
//        print_r($responseLineChart);
//        print_r($responseForSmallLineChart);
//        die;
        return compact("response", "responseLineChart", "responseForSmallLineChart");
    }

    function getReportingInviewData($campArr, $start, $end) {
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_env.php';
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_coreAPI.php';

        $retArray = array();

        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($total_creatives == 1) {
                    $campaign = '( owa_domstream.cv1_value = "' . $camp . '"';
                } else {
                    if ($i == 1)
                        $campaign = '( owa_domstream.cv1_value = "' . $camp . '"';
                    else
                        $campaign .= ' OR owa_domstream.cv1_value = "' . $camp . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        endif;

        $db = owa_coreAPI::dbSingleton();
        $db->_sqlParams['query_type'] = 'select';
//echo 'SELECT owa_domstream.cv2_value,count(owa_domstream.cv2_value) as total  FROM owa_domstream  WHERE ' . $campaign . '  AND owa_domstream.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_domstream.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_domstream.cv2_name = "InView" AND owa_domstream.site_id = "' . $this->siteId . '" GROUP BY owa_domstream.cv2_value';die;
        $res = $db->rawQuery('SELECT owa_domstream.cv2_value,count(owa_domstream.cv2_value) as total  FROM owa_domstream  WHERE ' . $campaign . '  AND owa_domstream.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_domstream.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_domstream.cv2_name = "InView" AND owa_domstream.site_id = "' . $this->siteId . '" GROUP BY owa_domstream.cv2_value');

        if (count($res)) {
            foreach ($res as $val) {
                if (!empty($val['cv2_value']))
                    $retArray[$val['cv2_value']] = $val['total'];
            }
        }
        return $retArray;
    }

    function getReportingClickdata($campArr, $start, $end) {
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];

                if ($i == 1) {
                    if ($campArr[0] == 0) {
                        $campaign = '( (owa_click.camp_id = "' . $camp . '" AND owa_click.dom_element_id LIKE "%pmi5element%" )';
                    } else {
                        $campaign = '( owa_click.camp_id = "' . $camp . '"';
                    }
                } else {
                    if ($campArr[0] == 0) {
                        $campaign .= ' OR ( owa_click.camp_id = "' . $camp . '" AND owa_click.dom_element_id LIKE "%pmi5element%" )';
                    } else {
                        $campaign .= ' OR owa_click.camp_id = "' . $camp . '"';
                    }
                }
                if ($i == $total_creatives) {
                    if (!empty($this->website) && !empty($this->pubId)) {
                        $campaign.= ' ) AND ( owa_click.cv5_value = "' . $this->website . '" AND owa_click.cv1_value = "' . $this->pubId . '"';
                    } else if (!empty($this->website)) {
                        $campaign.= ' ) AND ( owa_click.cv5_value = "' . $this->website . '"';
                    } else if (!empty($this->pubId)) {
                        $campaign.= ' ) AND ( owa_click.cv1_value = "' . $this->pubId . '"';
                    }
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        endif;
        $sql_query = 'SELECT owa_click.click_x,owa_click.click_y,owa_click.page_width,owa_click.page_height,owa_click.dom_element_x,owa_click.dom_element_y  FROM owa_click  WHERE ' . $campaign . '  AND owa_click.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_click.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_click.site_id = "' . $this->siteId . '"';
        $res = $this->getResultSet($sql_query);

        return $res;
    }

    function getReportingMouseoverkdata($campArr, $start, $end) {
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];

                if ($i == 1)
                    $campaign = '( owa_domstream.camp_id = "' . $camp . '"';
                else
                    $campaign .= ' OR owa_domstream.camp_id = "' . $camp . '"';

                if ($i == $total_creatives) {
                    if (!empty($this->website) && !empty($this->pubId)) {
                        $campaign.= ' ) AND ( owa_domstream.cv5_value = "' . $this->website . '" AND owa_domstream.cv1_value = "' . $this->pubId . '"';
                    } else if (!empty($this->website)) {
                        $campaign.= ' ) AND ( owa_domstream.cv5_value = "' . $this->website . '"';
                    } else if (!empty($this->pubId)) {
                        $campaign.= ' ) AND ( owa_domstream.cv1_value = "' . $this->pubId . '"';
                    }
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        endif;

        $sql_query = 'SELECT owa_domstream.events  FROM owa_domstream  WHERE ' . $campaign . '  AND owa_domstream.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_domstream.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_domstream.site_id = "' . $this->siteId . '" AND owa_domstream.events!="" AND owa_domstream.events != "[]"';
        $res = $this->getResultSet($sql_query);

        return $res;
    }

    function geReportingtDomainListWithNestedIframe($campArr, $params) {
        extract($params);
        $domain_names = array();

        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '( action_fact.action_group ="' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';
                $i++;
            endforeach;
            $constraint .= ')';
        endif;
        $sql_query = "SELECT source_dim_via_.source_domain as source FROM owa_action_fact as action_fact JOIN owa_source_dim AS source_dim_via_ ON action_fact.source_id = source_dim_via_.id 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND LOCATE('Nested', action_fact.cv4_value) > 0 AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "'
                            GROUP BY source_dim_via_.source_domain";
        try {
            $owa_response = $this->getResultSet($sql_query);
            if (!empty($owa_response)) {
                foreach ($owa_response as $val) {
                    if ($val['source'] != '(none)')
                        $domain_names[] = $val['source'];
                }
            }
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        return $domain_names;
    }

    function getReportingDashboardData($campArr, $params) {
        extract($params);
        $dimension = 'country';
        $metrics = 'actions,uniqueActions';
        list($totalMetric, $secondaryMetric) = explode(",", $metrics);
        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $constraint = '( action_fact.action_group = "' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';

                if ($i == $total_creatives && !empty($this->website) && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '" AND action_fact.cv1_value = "' . $this->pubId . '"';
                } else if ($i == $total_creatives && !empty($this->website)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '"';
                } else if ($i == $total_creatives && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv1_value = "' . $this->pubId . '"';
                }
                $i++;
            endforeach;
            $constraint .= ')';
        endif;
        $sql_query_total = "SELECT count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions FROM owa_action_fact as action_fact 
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                            LIMIT 1";

        $sql_query = "SELECT location_dim_via_.country as country, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                            FROM owa_action_fact as action_fact JOIN owa_location_dim AS location_dim_via_ ON action_fact.location_id = location_dim_via_.id
                            WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                            GROUP BY location_dim_via_.country";
        try {
            $owa_response = $this->getResultSet($sql_query);
            $owa_response_aggregates = $this->getResultSet($sql_query_total);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        if (empty($owa_response)) {
            throw new Exception(__('No records found.'));
        }
        $responseC = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric], 'unique' => $owa_response_aggregates[0][$secondaryMetric]));

        for ($i = 0; $i < count($owa_response); $i++) {
            $responseC['rows'][$i][] = $owa_response[$i][$dimension];
            $responseC['rows'][$i][] = $owa_response[$i][$totalMetric];
            $responseC['rows'][$i][] = $owa_response[$i][$secondaryMetric];
        }

        $responseC['headers'][] = 'Country';
        $responseC['headers'][] = 'Total';
        $responseC['headers'][] = 'Unique';

        $owa_response = array();
        $sql_query = "";
        $dimension = 'customVarValue5';

        $sql_query = "SELECT action_fact.cv5_value as customVarValue5, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                      FROM owa_action_fact as action_fact 
                      WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                      GROUP BY action_fact.cv5_value  ORDER BY actions DESC LIMIT 10";
        try {
            $owa_response = $this->getResultSet($sql_query);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        if (empty($owa_response)) {
            throw new Exception(__('No records found.'));
        }
        $responseL = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric], 'unique' => $owa_response_aggregates[0][$secondaryMetric]));

        for ($i = 0; $i < count($owa_response); $i++) {
            $responseL['rows'][$i][] = $owa_response[$i][$dimension];
            $responseL['rows'][$i][] = $owa_response[$i][$totalMetric];
            $responseL['rows'][$i][] = $owa_response[$i][$secondaryMetric];
        }

        $responseL['headers'][] = 'Location';
        $responseL['headers'][] = 'Total';
        $responseL['headers'][] = 'Unique';

        $owa_response = array();
        $sql_query = "";
        $dimension = 'source';

        $sql_query = "SELECT source_dim_via_.source_domain as source, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                    FROM owa_action_fact as action_fact JOIN owa_source_dim AS source_dim_via_ ON action_fact.source_id = source_dim_via_.id 
                    WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                    GROUP BY source_dim_via_.source_domain ORDER BY actions DESC LIMIT 10 ";
        try {
            $owa_response = $this->getResultSet($sql_query);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        if (empty($owa_response)) {
            throw new Exception(__('No records found.'));
        }
        $responseR = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => $owa_response_aggregates[0][$totalMetric], 'unique' => $owa_response_aggregates[0][$secondaryMetric]));

        for ($i = 0; $i < count($owa_response); $i++) {
            $responseR['rows'][$i][] = $owa_response[$i][$dimension];
            $responseR['rows'][$i][] = $owa_response[$i][$totalMetric];
            $responseR['rows'][$i][] = $owa_response[$i][$secondaryMetric];
        }
        $responseR['headers'][] = 'Referrer';
        $responseR['headers'][] = 'Total';
        $responseR['headers'][] = 'Unique';

        return compact("responseC", "responseL", "responseR");
    }

    function compareCustomEventRecord($campArr, $params) {
        extract($params);
        $dimension = 'actionName';
        $constraint = '1=1';
        if ($total_creatives = count($campArr)):
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];

                if ($i == 1)
                    $constraint = '( action_fact.action_group ="' . $camp . '"';
                else
                    $constraint .= ' OR action_fact.action_group = "' . $camp . '"';

                if ($i == $total_creatives && !empty($this->website) && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '" AND action_fact.cv1_value = "' . $this->pubId . '"';
                } else if ($i == $total_creatives && !empty($this->website)) {
                    $constraint.= ' ) AND ( action_fact.cv5_value = "' . $this->website . '"';
                } else if ($i == $total_creatives && !empty($this->pubId)) {
                    $constraint.= ' ) AND ( action_fact.cv1_value = "' . $this->pubId . '"';
                }
                $i++;
            endforeach;

            $j = 1;
            foreach ($eventActionArr as $eventAction):
                if ($j == 1)
                    $constraint .= ') AND ( action_fact.action_name = "' . $eventAction . '"';
                else
                    $constraint .= ' OR action_fact.action_name = "' . $eventAction . '"';

                $j++;
            endforeach;
            $constraint .= ')';
        endif;
//echo $constraint;die;

        $sql_query = "SELECT action_fact.action_name as actionName, action_fact.yyyymmdd as date, count(distinct action_fact.id) as actions, count(distinct action_fact.session_id) as uniqueActions 
                        FROM owa_action_fact as action_fact 
                        WHERE " . $constraint . " AND action_fact.action_name = 'impression' AND action_fact.yyyymmdd BETWEEN '" . $start->format('Ymd') . "' AND '" . $end->format('Ymd') . "' AND action_fact.site_id = '" . $this->siteId . "' 
                        GROUP BY action_fact.action_name, action_fact.yyyymmdd";
        try {
            $owa_response = $this->getResultSet($sql_query);
        } catch (Exception $e) {
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }
        $responseLineChart = array('totalResults' => count($owa_response), 'totalsForAllResults' => array('total' => 0));
        for ($i = 0; $i < count($owa_response); $i++) {
            $responseLineChart['rows'][$i][] = $owa_response[$i][$dimension];
            $responseLineChart['rows'][$i][] = $owa_response[$i]['date'];
            $responseLineChart['rows'][$i][] = $owa_response[$i]['actions'];
            $responseLineChart['totalsForAllResults']['total'] += $owa_response[$i]['actions'];
        }
        $responseLineChart['headers'] = array('Event', 'Date', 'Total');

        return compact("responseLineChart");
    }

    function getReportingEventWiseInviewData($campArr, $start, $end) {
        $engagementEvents = array('View', 'Impression', 'view', 'impression', 'q1', 'q2', 'q3', 'Q1', 'Q2', 'Q3', 'complete', 'Complete');
        $retArray = array();
        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $campaign = '( action_group = "' . $camp . '"';
                else
                    $campaign .= ' OR action_group = "' . $camp . '"';

                if ($i == $total_creatives && !empty($this->website) && !empty($this->pubId)) {
                    $campaign.= ' ) AND ( cv5_value = "' . $this->website . '" AND cv1_value = "' . $this->pubId . '"';
                } else if ($i == $total_creatives && !empty($this->website)) {
                    $campaign.= ' ) AND ( cv5_value = "' . $this->website . '"';
                } else if ($i == $total_creatives && !empty($this->pubId)) {
                    $campaign.= ' ) AND ( cv1_value = "' . $this->pubId . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }

        $sql_query = 'SELECT COUNT(action_name) as total_visit FROM owa_action_fact WHERE ' . $campaign . ' AND action_name = "impression"  AND yyyymmdd >= "' . $start->format('Ymd') . '" AND yyyymmdd <= "' . $end->format('Ymd') . '" AND cv2_name = "InView" AND cv2_value != "" AND cv2_value != "true" AND cv2_value != "false" AND site_id = "' . $this->siteId . '"';
        $totalCount = $this->getResultSet($sql_query);

        $sql_query = 'SELECT action_name,SUM(cv2_value)/' . $totalCount[0]['total_visit'] . ' AS inviewpercent FROM owa_action_fact  WHERE ' . $campaign . '  AND yyyymmdd >= "' . $start->format('Ymd') . '" AND yyyymmdd <= "' . $end->format('Ymd') . '" AND cv2_name = "InView" AND cv2_value != "" AND cv2_value != "true" AND cv2_value != "false" AND site_id = "' . $this->siteId . '" GROUP BY action_name';
        $res = $this->getResultSet($sql_query);
        $response = array();
        $total = 0;
        $response['headers'] = array('Inview', 'Total', 'Unique');
        $response['rows'] = array();
        if (count($res)) {
            foreach ($res as $val) {
                if (is_numeric($val['action_name']) || in_array($val['action_name'], $engagementEvents)) {
                    $response['rows'][] = array($val['action_name'], $val['inviewpercent']);
                    $total += $val['inviewpercent'];
                }
            }
            $inViewPercent = $total / count($response['rows']);
//           echo $total."/".count($response['rows']);
        }
        return compact("response", "inViewPercent");
    }

    function getReportingSiteData($campArr, $start, $end) {
        $result = array();
        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($total_creatives == 1) {
                    $campaign = '( action_group = "' . $camp . '"';
                } else {
                    if ($i == 1)
                        $campaign = '( action_group = "' . $camp . '"';
                    else
                        $campaign .= ' OR action_group = "' . $camp . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }
        $sql_query = 'SELECT DISTINCT(cv5_value) FROM owa_action_fact  WHERE ' . $campaign . '  AND owa_action_fact.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_action_fact.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_action_fact.site_id = "' . $this->siteId . '"';
        $res = $this->getResultSet($sql_query);
        if (count($res)):
            foreach ($res as $val):
                $result[$val['cv5_value']] = $val['cv5_value'];
            endforeach;
        endif;
        return $result;
    }

    function getReportingEngagementRate($campArr, $start, $end) {
        $result = array();
        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($i == 1)
                    $campaign = '( action_group = "' . $camp . '"';
                else
                    $campaign .= ' OR action_group = "' . $camp . '"';
                if ($i == $total_creatives && !empty($this->website) && !empty($this->pubId)) {
                    $campaign.= ' ) AND ( cv5_value = "' . $this->website . '" AND cv1_value = "' . $this->pubId . '"';
                } else if ($i == $total_creatives && !empty($this->website)) {
                    $campaign.= ' ) AND ( cv5_value = "' . $this->website . '"';
                } else if ($i == $total_creatives && !empty($this->pubId)) {
                    $campaign.= ' ) AND ( cv1_value = "' . $this->pubId . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }
        if (!empty($start) && !empty($end)) {
            $campaign .= ' AND owa_action_fact.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_action_fact.yyyymmdd <= "' . $end->format('Ymd') . '"';
        }
        $sql_query = 'SELECT action_name,COUNT(action_name) AS total FROM owa_action_fact  WHERE ' . $campaign . ' AND owa_action_fact.site_id = "' . $this->siteId . '" AND ( owa_action_fact.action_name = "call" OR owa_action_fact.action_name = "sms" OR owa_action_fact.action_name="impression" OR owa_action_fact.action_name ="clickthrough" OR owa_action_fact.action_name ="expand" ) GROUP BY action_name';
        $res = $this->getResultSet($sql_query);

        if (count($res)):
            foreach ($res as $val):
                $result[$val['action_name']] = $val['total'];
            endforeach;
        endif;

        $clickthrough = (isset($result['clickthrough'])) ? $result['clickthrough'] : 0;
        $impression = (isset($result['impression'])) ? $result['impression'] : 1;
        $call = (isset($result['call'])) ? $result['call'] : 0;
        $sms = (isset($result['sms'])) ? $result['sms'] : 0;
        $expand = (isset($result['expand'])) ? $result['expand'] : 0;

        $responseCTR = round($clickthrough / $impression * 100, 2);
        $responseCTA = round(($call + $sms) / $impression * 100, 2);
        $responseER = round($expand / $impression * 100, 2);

        return compact("responseCTR", "responseCTA", "responseER");
    }

    function getReportingSiteWiseData($campArr) {
        $result = array();
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_env.php';
        require_once $_SERVER['DOCUMENT_ROOT'] . '/owa/owa_coreAPI.php';

        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($total_creatives > 1) {
                    if ($i == 1)
                        $campaign = '( action_group = "' . $camp . '"';
                    else
                        $campaign .= ' OR action_group = "' . $camp . '"';
                } else {
                    $campaign = '( action_group = "' . $camp . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }

        $sql_query = 'SELECT cv5_value,action_name,COUNT(action_name) AS total FROM owa_action_fact  WHERE ' . $campaign . ' AND owa_action_fact.site_id = "' . $this->siteId . '" AND ( owa_action_fact.action_name = "call" OR owa_action_fact.action_name = "sms" OR owa_action_fact.action_name="impression" OR owa_action_fact.action_name ="clickthrough" OR owa_action_fact.action_name ="expand" ) GROUP BY cv5_value,action_name';
        $res = $this->getResultSet($sql_query);

        if (count($res)):
            foreach ($res as $val):
                $result[$val['cv5_value']][$val['action_name']] = $val['total'];
            endforeach;
        endif;
        return $result;
    }

    function getReportingPublisherData($campArr, $start, $end) {
        $result = array();
        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($total_creatives == 1) {
                    $campaign = '( action_group = "' . $camp . '"';
                } else {
                    if ($i == 1)
                        $campaign = '( action_group = "' . $camp . '"';
                    else
                        $campaign .= ' OR action_group = "' . $camp . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }
        $sql_query = 'SELECT DISTINCT(cv1_value) FROM owa_action_fact  WHERE ' . $campaign . '  AND owa_action_fact.yyyymmdd >= "' . $start->format('Ymd') . '" AND owa_action_fact.yyyymmdd <= "' . $end->format('Ymd') . '" AND owa_action_fact.site_id = "' . $this->siteId . '" AND cv1_name="PubID"';
        $res = $this->getResultSet($sql_query);
        return $res;
    }

    function getTotalImpression($campArr) {
        $result = array();
        if ($total_creatives = count($campArr)) {
            $i = 1;
            foreach ($campArr as $cVal):
                $campArr = explode('_', $cVal);
                $camp = "campaign-" . $campArr[1];
                if ($total_creatives == 1) {
                    $campaign = '( action_group = "' . $camp . '"';
                } else {
                    if ($i == 1)
                        $campaign = '( action_group = "' . $camp . '"';
                    else
                        $campaign .= ' OR action_group = "' . $camp . '"';
                }
                $i++;
            endforeach;
            $campaign .= " ) ";
        } else {
            $campaign = "1=1";
        }
        $res = array();
        $sql_query = 'SELECT COUNT(action_name) as total_impression FROM owa_action_fact  WHERE ' . $campaign . ' AND action_name = "impression" AND owa_action_fact.site_id = "' . $this->siteId . '"';
        $res = $this->getResultSet($sql_query);
        if (!empty($res))
            $res = array_shift($res);

        return $res['total_impression'];
    }
    function getFilterTotalImpression($campArr,$date) {
        $camp = "campaign-".$campArr;
        //$camp = "campaign-641";
        $res = array();
         $sql_query = 'SELECT yyyymmdd,count(action_name) AS totalaction,action_name,action_label,cv5_value FROM owa_action_fact  WHERE  action_group =  "'. $camp .'" AND site_id = "' . $this->siteId . '" GROUP BY yyyymmdd, action_name';
       
        $res =  $this->getResultSet($sql_query);
        /*echo "<pre>";
        print_r($res);
        exit;*/
        return $res;
    }
    function getFilterTotalOs($campArr,$date) {
              
        $camp = "campaign-".$campArr;
        //$camp = "campaign-641";
        $sql_query = 'SELECT oa.yyyymmdd,count(oa.action_name) AS totalaction,os.name FROM owa_action_fact AS oa INNER JOIN owa_os AS os ON oa.os_id=os.id WHERE  oa.action_group =  "'. $camp .'" AND oa.action_name="impression" AND oa.site_id = "' . $this->siteId . '" GROUP BY oa.yyyymmdd, os.name';
       
        $res =  $this->getResultSet($sql_query);
        /*echo "<pre>";
        print_r($res);
        exit;*/
        return $res;
    }
    function getFilterTotalDevice($campArr,$date) {
              
        $camp = "campaign-".$campArr;
        //$camp = "campaign-617";
        $res = array();
        
        $sql_query = 'SELECT oa.yyyymmdd,count(oa.action_name) AS totalaction,od.name FROM owa_action_fact AS oa INNER JOIN owa_device AS od ON oa.device_id=od.id WHERE  oa.action_group =  "'. $camp .'" AND oa.action_name="impression" AND oa.site_id = "' . $this->siteId . '" GROUP BY oa.yyyymmdd, od.name';
       
        $res =  $this->getResultSet($sql_query);
        /*echo "<pre>";
        print_r($res);
        exit;*/
        return $res;
    }
    function getFilterTotalReferer($campArr,$date){
		$camp = "campaign-".$campArr;
        //$camp = "campaign-617";
        $res = array();
        
        $sql_query = 'SELECT oa.yyyymmdd,count(oa.action_name) AS totalaction,od.site FROM owa_action_fact AS oa INNER JOIN owa_referer AS od ON oa.referer_id=od.id WHERE  oa.action_group =  "'. $camp .'" AND oa.action_name="impression" AND oa.site_id = "' . $this->siteId . '" GROUP BY oa.yyyymmdd, od.site';
       
        $res =  $this->getResultSet($sql_query);
        /*echo "<pre>";
        print_r($res);
        exit;*/
        return $res;
	}
	function getFilterTotalCountry($campArr,$date){
		$camp = "campaign-".$campArr;
        $camp = "campaign-617";
        $res = array();
        
        $sql_query = 'SELECT oa.yyyymmdd,count(oa.action_name) AS totalaction,od.country FROM owa_action_fact AS oa INNER JOIN owa_location_dim AS od ON oa.location_id=od.id WHERE  oa.action_group =  "'. $camp .'" AND oa.action_name="impression" AND oa.site_id = "' . $this->siteId . '" GROUP BY oa.yyyymmdd, od.country';
       
        $res =  $this->getResultSet($sql_query);
        
        return $res;
	}

}
