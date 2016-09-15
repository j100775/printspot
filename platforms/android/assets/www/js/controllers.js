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

})

.controller('PlaylistsCtrl', function($scope,$http) {
  $scope.playlists = [];
   $http.get('http://sirstech.in/printspot/category/?45452').then(function(result){
        data = result.data;
       // alert(data.category.pageTitle);
        $scope.pageTitle = data.category.pageTitle;
        $scope.playlists = data.category.items;
    });
})

.controller('PlaylistCtrl', function($scope,$http ,$stateParams, $ionicModal, $ionicPopup, $timeout, $cordovaCamera, $cordovaFile,$cordovaSQLite, $cordovaDevice,appConfig) {
 
	var range = [];
	var productId = $scope.productId = $stateParams.playlistId;
	$scope.pageTitle ='Product '+ productId;
	$scope.backgroundImage ='';
	if(productId==1){
  // Form data for the album modal
  	$scope.pageTitle = 'Album';

	 $scope.albumData = {};
	 $scope.albumData.numberofphoto = 17;
	 $scope.perpageOptions = [
	  {id: 2,label: '2',subItem: { name: '2 photos' }},
	  {id: 4,label: '4',subItem: { name: '4 photos' }},
	  {id: 6,label: '6',subItem: { name: '6 photos' }}
	 ];

	 $scope.themeOptions = [
	  {id: 0,name:'flora-design',image: 'http://sirstech.in/printspot/image/album_bk1.jpg'},
	  {id: 1,name:'floral-star',image: 'http://sirstech.in/printspot/image/album_bk2.jpeg'},
	  {id: 2,name:'floral',image: 'http://sirstech.in/printspot/image/album_bk3.jpg'},
	 ];
	$scope.albumData.theme =  $scope.themeOptions[0];
    $scope.backgroundImage = $scope.albumData.theme.image;
	$scope.albumData.perpage = $scope.perpageOptions[0];
	$scope.albumData.pages = Math.ceil($scope.albumData.numberofphoto / $scope.albumData.perpage.id);
  
	range = [];
	for(var i=0;i<$scope.albumData.pages;i++) {
	  holderstart = (i*$scope.albumData.perpage.id);
	  spread = holderstart + $scope.albumData.perpage.id;
	  holderends = (spread<$scope.albumData.numberofphoto)?spread:$scope.albumData.numberofphoto;
	  holders= [];
	  row = [];
	  for(j=holderstart;j<holderends;j++){
		//holders = [];
		row.push({'id':j,'image':'http://placehold.it/200/000000'});
		if(row.length==2 || j==holderends-1){
		holders.push(row);
		row = [];
		}
	  }
	  range.push({id:i,shels:holders});
	  
	}
	$scope.ranges = range;
	console.log($scope.ranges[8]['shels'][0][0].id);
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
  $scope.albumData.theme =  $scope.themeOptions[$scope.albumData.theme.id];
  $scope.backgroundImage = $scope.albumData.theme.image;
console.log($scope.backgroundImage);
 	range = [];
	for(var i=0;i<$scope.albumData.pages;i++) {
	  holderstart = (i*$scope.albumData.perpage.id);
	  spread = holderstart + $scope.albumData.perpage.id;
	  holderends = (spread<$scope.albumData.numberofphoto)?spread:$scope.albumData.numberofphoto;
	  holders= [];
	  rows = [];
	  for(j=holderstart;j<holderends;j++){
		//holders = [];
		rows.push({'id':j,'image':'http://placehold.it/200/000000','class':'opcity-05'});
		if(rows.length==2 || j==holderends-1){
		holders.push(rows);
		rows = [];
	    }
	  }
	  range.push({id:i,shels:holders});
	  
	}
	$scope.ranges = range;
	//console.log($scope.ranges);


    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $scope.closeSettings();
    }, 1000);
	};	
	$scope.saveAlbum = function(){
		console.log($cordovaDevice.getUUID());
		var uuid = $cordovaDevice.getUUID();
		window.localStorage.setItem(uuid,angular.toJson($scope.albumData));
		var savedData = window.localStorage.getItem(uuid);
		console.log(angular.toJson(savedData));

	};
	$scope.pageSettings = function(){
		$scope.modal.show();
	};
	// photo from camera file location
	$scope.setPhoto = function(r,s, c){
		      console.log('clicked on image of page'+r+'shelno '+s+' row'+c);

		var range = r, col = c;
		var options = {
			destinationType : Camera.DestinationType.FILE_URI,
			sourceType :Camera.PictureSourceType.PHOTOLIBRARY , // Camera.PictureSourceType.CAMERA
			allowEdit : false,
			encodingType: Camera.EncodingType.PNG,
			popoverOptions: CameraPopoverOptions,
	    };
		$cordovaCamera.getPicture(options).then(function(imageData) {
 
		// 4
		onImageSuccess(imageData);
 
		function onImageSuccess(fileURI) {
			console.log(fileURI);
			fileURI.replace('content:','file:\/');
			console.log(fileURI);
			console.log(r+' - '+c);
			//$scope.$apply(function () {
				$scope.ranges[r]['shels'][s][c].image = fileURI;
				//$scope.images.push(entry.nativeURL);
			//});
			console.log($scope.ranges);
			//createFileEntry(fileURI);
		}
 
		function createFileEntry(fileURI) {
			window.resolveLocalFileSystemURL(fileURI, copyFile, fail);
		}
 
		// 5
		function copyFile(fileEntry) {
			var name = fileEntry.fullPath.substr(fileEntry.fullPath.lastIndexOf('/') + 1);
			var newName = makeid() + name;
 
			window.resolveLocalFileSystemURL(cordova.file.dataDirectory, function(fileSystem2) {
			console.log(fileEntry.copyTo);
				fileEntry.copyTo(
					fileSystem2,
					newName,
					onCopySuccess,
					fail
				);
			},
			fail);
		}
		
		// 6
		function onCopySuccess(entry) {
			$scope.$apply(function () {
				$scope.ranges[r]['shels'][0][c].image = entry.nativeURL;
				//$scope.images.push(entry.nativeURL);
			});
		}
 
		function fail(error) {
			console.log("fail: " + error.code);
		}
 
		function makeid() {
			var text = "";
			var possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
 
			for (var i=0; i < 5; i++) {
				text += possible.charAt(Math.floor(Math.random() * possible.length));
			}
			return text;
		}
 
	}, function(err) {
		console.log(err);
	});	
		
      console.log('clicked on image of page'+r+' row'+c);
	//end line for setPhoto			
	};
  }
 //product id = 1 album settings
if(productId==5){
	console.log(appConfig);
 // Open the mobile modal
   var productData = [];
   $scope.serviceUrl = appConfig.apiUrl;
   $scope.mobilesettings = [];
   $scope.mobileData = [];
   $http.get(appConfig.apiUrl+'category/5/?'+Math.random()).then(function(result){
        productData = result.data;
        $scope.pageTitle = productData.pageTitle;
        $scope.mobilecoverType = productData.mobilecoverType;
        $scope.mobilemodels = productData.products[0];
    });
	console.log(productData);
	

	$ionicModal.fromTemplateUrl('templates/mobilesettings.html', {
		scope: $scope
		}).then(function(modal) {
		$scope.modal = modal;
	});
	$scope.setPhoto = function(){
		var options = {
			destinationType : Camera.DestinationType.FILE_URI,
			sourceType :Camera.PictureSourceType.PHOTOLIBRARY , // Camera.PictureSourceType.CAMERA
			allowEdit : false,
			encodingType: Camera.EncodingType.PNG,
			popoverOptions: CameraPopoverOptions,
	    };
		$cordovaCamera.getPicture(options).then(function(imageData) {
 
		// 4
		onImageSuccess(imageData);
 
		function onImageSuccess(fileURI) {
			console.log(fileURI);
			fileURI.replace('content:','file:\/');
			console.log(fileURI);
				$scope.mobileData.design = fileURI;
		};
    });	
	};
	 $scope.album = function() {
    	$scope.mobileData.covertype = $scope.mobilecoverType[0];
		$scope.modal.show();
	  };
     // Triggered in the login modal to close it
	$scope.closeSettings = function() {
	$scope.modal.hide();
	};
	$scope.selectCoverType = function(){
	//console.log(productData.products);
	     $scope.mobilemodels = productData.products[$scope.mobileData.covertype.id-1];
	     $scope.designs = '';
	};
	$scope.selectMobile = function(){
		    $scope.mobileData.device =$scope.serviceUrl+'image/'+$scope.mobileData.mobilemodel.img;
            //$scope.mobileData.design ='../phones/designs/8.jpg';
            if($scope.mobileData.mobilemodel.design)
            $scope.designs = $scope.mobileData.mobilemodel.design;
            
            $scope.mobileData.design ='';
	};
	$scope.selectDesign = function(){
		console.log($scope.mobileData.designs.id);
            $scope.mobileData.design =$scope.serviceUrl+'image/'+$scope.mobileData.designs[$scope.mobileData.designs.id];
	};
	
	$scope.doMobile = function(){
		$timeout(function() {
		  $scope.closeSettings();
		}, 1000);
	};
    $scope.mobileData.device =$scope.serviceUrl+'image/phones/iPhone4A.png';
    $scope.mobileData.design =$scope.serviceUrl+'image/phones/designs/8.jpg';
   
   
   }//product Id  mobile settings
	
})

.controller('loginCtrl',function($scope, $state, $ionicPopup,$timeout, AuthService){
// login functionality goes here
   // Perform the login action when the user submits the login form
  $scope.doLogin = function() {
    console.log('Doing login', $scope.loginData);
	//AuthService.login($scope.loginData.username,$scope.loginData.password);
    // Simulate a login delay. Remove this and replace with your login
    // code if using a login system
    $timeout(function() {
      $state.go('app.playlists');
    }, 1000);
  };

})
;
