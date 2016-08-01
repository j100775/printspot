angular.module('starter.controllers', [])

.controller('AppCtrl', function($scope, $ionicModal, $timeout) {

  // With the new view caching in Ionic, Controllers are only called
  // when they are recreated or on app start, instead of every page change.
  // To listen for when this page is active (for example, to refresh data),
  // listen for the $ionicView.enter event:
  //$scope.$on('$ionicView.enter', function(e) {
  //});

  // Form data for the login modal
  $scope.loginData = {};

  // Create the login modal that we will use later
  $ionicModal.fromTemplateUrl('templates/login.html', {
    scope: $scope
  }).then(function(modal) {
    $scope.modal = modal;
  });

  // Triggered in the login modal to close it
  $scope.closeLogin = function() {
    $scope.modal.hide();
  };

  // Open the login modal
  $scope.login = function() {
    $scope.modal.show();
  };

  // Perform the login action when the user submits the login form
  $scope.doLogin = function() {
    console.log('Doing login', $scope.loginData);

    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeLogin();
    }, 1000);
  };
})

.controller('PlaylistsCtrl', function($scope,$http) {
  $scope.playlists = [];
   $http.get('http://sirstech.in/printspot/category').then(function(result){
        data = result.data;
       // alert(data.category.pageTitle);
        $scope.pageTitle = data.category.pageTitle;
        $scope.playlists = data.category.items;
    });
})

.controller('PlaylistCtrl', function($scope, $stateParams, $ionicModal, $timeout) {
 
	var range = [];
	var productId = $scope.productId = $stateParams.playlistId;
	$scope.pageTitle ='Product '+ productId;
	$scope.backgroundImage ='';
	if(productId==1){
  // Form data for the album modal
  	$scope.pageTitle = 'Album';
    $scope.backgroundImage ='../../../img/album.jpeg';

  $scope.albumData = {};
  $scope.albumData.numberofphoto = 17;
  $scope.perpageOptions = [
  {id: 2,label: '2',subItem: { name: '2 photos' }},
  {id: 4,label: '4',subItem: { name: '4 photos' }},
  {id: 6,label: '6',subItem: { name: '6 photos' }}
  ];
$scope.fileNameChanged = function (ele) {
  var files = ele.files;
  var l = files.length;
  var namesArr = [];

  for (var i = 0; i < l; i++) {
    namesArr.push(files[i].name);
  }
}
  $scope.albumData.perpage = $scope.perpageOptions[0];
  $scope.albumData.pages = Math.ceil($scope.albumData.numberofphoto / $scope.albumData.perpage.id);
  
	range = [];
	for(var i=0;i<$scope.albumData.pages;i++) {
	  holderstart = (i*$scope.albumData.perpage.id);
	  spread = holderstart + $scope.albumData.perpage.id;
	  holderends = (spread<$scope.albumData.numberofphoto)?spread:$scope.albumData.numberofphoto;
	  holders= [];
	  for(j=holderstart;j<holderends;j++){
		//holders = [];
		holders.push(j);
	  }
	  range.push({id:i,shels:holders});
	  
	}
	$scope.ranges = range;

  // Create the album modal that we will use later
  $ionicModal.fromTemplateUrl('templates/albumsettings.html', {
    scope: $scope
  }).then(function(modal) {
    $scope.modal = modal;
  });

  // Triggered in the album modal to close it
  $scope.closeSettings = function() {
    $scope.modal.hide();
  };

  // Open the album modal
  $scope.album = function() {
    $scope.modal.show();
  };

  // Perform the album setting action when the user submits the login form
  $scope.doAlbum = function() {
   $scope.albumData.pages = Math.ceil($scope.albumData.numberofphoto / $scope.albumData.perpage.id);
	range = [];
	for(var i=0;i<$scope.albumData.pages;i++) {
	  holderstart = (i*$scope.albumData.perpage.id);
	  spread = holderstart + $scope.albumData.perpage.id;
	  holderends = (spread<$scope.albumData.numberofphoto)?spread:$scope.albumData.numberofphoto;
	  holders= [];
	  for(j=holderstart;j<holderends;j++){
		//holders = [];
		holders.push(j);
	  }
	  range.push({id:i,shels:holders});
	  
	}
	$scope.ranges = range;


    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeSettings();
    }, 1000);
  };	

	$scope.pageSettings = function(){
		$scope.modal.show();
	};
    }	
});
