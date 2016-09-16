<?php

App::uses('Component', 'Controller');

class AnalyticsComponent extends Component {

    private $request = null;

//    public function initialize(Controller $controller) {
//        $this->request = $controller->request;
//    }

    function getIt($campaign_id, $params) {
        $ga_dimensions = array('event' => 'ga:eventAction', 'operating_system' => 'ga:operatingSystem', 'browser' => 'ga:browser', 'country' => 'ga:country', 'region' => 'ga:region', 'city' => 'ga:city', 'screen_resolution' => 'ga:screenResolution', 'device_category' => 'ga:deviceCategory', 'source' => 'ga:source');
        App::import('Vendor', 'google-api-php-client/src/Google_Client');
        App::import('Vendor', 'google-api-php-client/src/contrib/Google_AnalyticsService');

        $client = new Google_Client();
        $client->setApplicationName(APP_NAME);


        $key = file_get_contents(KEY_FILE);
        $client->setAssertionCredentials(new Google_AssertionCredentials(SERVICE_ACCOUNT_NAME, array(SCOPES), $key));

        $client->setClientId(CLIENT_ID);
        $analytics = new Google_AnalyticsService($client);

        ////////////////////////////////////////////////
        extract($params);
        $dimension = $ga_dimensions[$dimension_key];        
        $metrics = 'ga:totalEvents,ga:uniqueEvents';
        if ($dimension == 'ga:source') {
            $metrics = "ga:visits,ga:newVisits";
        }
        list($totalMetric, $secondaryMetric) = explode(",", $metrics);
        
        try {
            $response = $analytics->data_ga->get(
                    'ga:' . PROFILE_ID, // profile id
                    $start->format('Y-m-d'), // start date
                    $end->format('Y-m-d'), // end date
                    $metrics
                    , array(
                'dimensions' => $dimension,
                'filters' => 'ga:eventCategory==Campaign-' . $campaign_id, // example url filter
                'max-results' => 200
                    ));
        } catch (Exception $e) {
            // Error from the API.
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        if (!empty($response['error'])) {
            throw new Exception(__('There was error in response:  ' . $response['error']['message'] . ' (' . $response['error']['code'] . ')'));
        }
        if (empty($response['rows'])) {
            throw new Exception(__('No records found.'));
        }
//        echo "<pre>";
//        print_r($response);        
//        die;
        $response = array_intersect_key($response, array('totalsForAllResults' => '', 'rows' => '', 'totalResults' => ''));
        $response['headers'][] = Inflector::humanize(array_search($dimension, $ga_dimensions));
        if ($dimension == 'ga:source') {
            $response['headers'][] = 'Visits';
            $response['headers'][] = 'New Visits';
        } else {
            $response['headers'][] = 'Total';
            $response['headers'][] = 'Unique';
        }
        $response['totalsForAllResults'] = array('total' => $response['totalsForAllResults']['ga:totalEvents'], 'unique' => $response['totalsForAllResults']['ga:uniqueEvents']);
//        echo "<pre>";
//        print_r($response);
//        die;
        /////////////////////////////////////////////////////////////////////////////////////////////////     
        $filtersForLineChart = 'ga:eventCategory==Campaign-' . $campaign_id . ';';
        for ($i = 0; $i < $response['totalResults']; $i++) {
            $filtersForLineChart.=($dimension . '==' . $response['rows'][$i][0] . ',');            
        }
        $filtersForLineChart = rtrim($filtersForLineChart, ",");
        try {
            $responseLineChart = $analytics->data_ga->get(
                    'ga:' . PROFILE_ID, // profile id
                    $start->format('Y-m-d'), // start date
                    $end->format('Y-m-d'), // end date
                    $totalMetric, array(
                'dimensions' => $dimension . ',ga:date',
                'max-results' => ($start->diff($end, true)->days * $response['totalResults']),
                'filters' => $filtersForLineChart,
                'sort' => $dimension
                    ));
        } catch (Exception $e) {
            // Error from the API.
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        if (!empty($responseLineChart['error'])) {
            throw new Exception(__('There was error in response:  ' . $responseLineChart['error']['message'] . ' (' . $responseLineChart['error']['code'] . ')'));
        }
        if (empty($responseLineChart['rows'])) {
            throw new Exception(__('No records found.'));
        }
//        echo "<pre>";
//        print_r($responseLineChart);
//        die;
        $responseLineChart = array_intersect_key($responseLineChart, array('totalsForAllResults' => '', 'rows' => '', 'totalResults' => ''));
        $responseLineChart['headers'] = array(Inflector::humanize(array_search($dimension, $ga_dimensions)), 'Date', 'Total');
        $responseLineChart['totalsForAllResults'] = array('total' => $responseLineChart['totalsForAllResults']['ga:totalEvents']);
//        echo "<pre>";
//        print_r($responseLineChart);
//        die;
        //////////////////////////////////////////////////////////////////////////
        try {
            $responseForSmallLineChart = $analytics->data_ga->get(
                    'ga:' . PROFILE_ID, // profile id
                    $start->format('Y-m-d'), // start date
                    $end->format('Y-m-d'), // end date
                    $metrics, array(
                'dimensions' => 'ga:date',
                'filters' => 'ga:eventCategory==Campaign-' . $campaign_id, // example url filter
                'max-results' => ($start->diff($end, true)->days)
                    ));
        } catch (Exception $e) {
            // Error from the API.
            throw new Exception(__('There was error while quering: ' . $e->getCode() . ' : ' . $e->getMessage()));
        }

        if (!empty($responseForSmallLineChart['error'])) {
            throw new Exception(__('There was error in response:  ' . $responseForSmallLineChart['error']['message'] . ' (' . $responseForSmallLineChart['error']['code'] . ')'));
        }
        if (empty($responseForSmallLineChart['rows'])) {
            throw new Exception(__('No records found.'));
        }
//        echo "<pre>";
//        print_r($responseForSmallLineChart);
//        die;
        $responseForSmallLineChart = array_intersect_key($responseForSmallLineChart, array('totalsForAllResults' => '', 'rows' => '', 'totalResults' => ''));
        $responseForSmallLineChart['headers'][] = 'Date';
        if ($dimension == 'ga:source') {
            $responseForSmallLineChart['headers'][] = 'Visits';
            $responseForSmallLineChart['headers'][] = 'New Visits';
        } else {
            $responseForSmallLineChart['headers'][] = 'Total';
            $responseForSmallLineChart['headers'][] = 'Unique';
        }
        $responseForSmallLineChart['totalsForAllResults'] = array('total' => $responseForSmallLineChart['totalsForAllResults']['ga:totalEvents'], 'unique' => $responseForSmallLineChart['totalsForAllResults']['ga:uniqueEvents']);
//        echo "<pre>";
//        print_r($response);
//        print_r($responseLineChart);
//        print_r($responseForSmallLineChart);
//        die;
        return compact("response", "responseLineChart", "responseForSmallLineChart");
    }

}