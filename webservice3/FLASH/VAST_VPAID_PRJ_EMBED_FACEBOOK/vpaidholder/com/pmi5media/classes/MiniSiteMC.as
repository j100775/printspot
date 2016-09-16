package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import com.pmi5media.classes.*;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;

	public class MiniSiteMC extends MovieClip {

		private var msXmlList: XMLList = new XMLList();
		private var youtubeXmlList: XMLList;
		private var msTotalLen: int;
		private var objBgColor: MovieClip = new BgColorMC();
		private var objMinisiteStage: MovieClip = new MinisiteConMC(); // container for handling module like galery,about etc.
		private var objAdMenu: MovieClip = new MenuMC();

		private var objImageApp: MovieClip = new ImageAppMC(); // image app
		private var objFindDealer: MovieClip = new FindDealer(); //find a dealer movie clip
		private var objYoutubePlayer: MovieClip; // for playing youtube video
		private var objCloseBtn: MovieClip;

		private var view360No: int;
		private var thumbNo: int;
		private var aboutNo: int;

		private var imgAnimArr: Array = new Array();
		private var imgArrLen: int;
		private var imgArrNo: int;
		private var galleryNo: int;
		private var isWelcomeFound: Boolean;
		private var isMenuFound: Boolean;
		private var fromTopIndex: int = 1;
		private var isRemoveAd: Boolean;
		private var showOnTop: Boolean;
		private var showFirstWidget: Boolean;
		private var arrTotalModules: Array = new Array();
		private var arrModName: Array = new Array(); // using for hide/show module on the basis of name which are showing by menu in the minisite
		private var arrFreeModule: Array = new Array();
		private var curWidget: String = "";
		private var exists: Boolean;
		private var backBtnParent: String = "";


		public function MiniSiteMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedminiSiteMC, false, 0, true);

		}

		function addedminiSiteMC(E: Event): void {

			removeEventListener(Event.ADDED_TO_STAGE, addedminiSiteMC);
			objMinisiteStage.width = AppConst.SCREEN_WIDTH;
			objMinisiteStage.height = AppConst.SCREEN_HEIGHT;
			objMinisiteStage.addEventListener(AppConst.EVENT_CLOSE_CLICK, closeclicked);

			objMinisiteStage.addEventListener(AppConst.EVENT_BACK_BTN, backClicked);
			objMinisiteStage.addEventListener(MenuItemEvent.ITEM_CLICK, itemClick); // menu item click in case of widget
			this.addChild(objMinisiteStage);

		}


		function backClicked(e: Event): void {
			backBtnParent = "";
			backBtnParent = e.target.parent.name.toString()
			trace("back btn in minisite back btn =" + backBtnParent);
			if (findElement(backBtnParent, arrFreeModule)) {
				if (backBtnParent.indexOf(AppConst.AD_GALLERY) >= 0) {
					if (objMinisiteStage.getChildByName(backBtnParent) != null)
						MovieClip(objMinisiteStage.getChildByName(backBtnParent)).StopAndHideAll();
					objMinisiteStage.getChildByName(backBtnParent).visible = false;
				} else if (backBtnParent.indexOf(AppConst.AD_THUMBNAILS) >= 0) {
					if (objMinisiteStage.getChildByName(backBtnParent) != null)
						MovieClip(objMinisiteStage.getChildByName(backBtnParent)).StopAndHideGal();
					objMinisiteStage.getChildByName(backBtnParent).visible = false;
				} else {
					objMinisiteStage.getChildByName(backBtnParent).visible = false;
				}
			} else {
				hideAllMod();				
				stopHideGalModules(); // for hidding gallery items
				stopHideTNailsMod(); //thumnails gallery

			}
		}


		function itemClick(e: MenuItemEvent): void {

			showMItemData(e.data);

		}

		function showMItemData(pData: * ): void {
			try {

				hideAllMod();
				stopHideGalModules(); // for hidding gallery items
				stopHideTNailsMod(); //thumnails gallery
				curWidget = pData;

				if (curWidget.indexOf(AppConst.AD_GALLERY) >= 0) {
					curWidget = AppConst.AD_GALLERY;
				}

				if (curWidget.indexOf(AppConst.AD_VIEW360) >= 0) {
					curWidget = AppConst.AD_VIEW360;
				}

				if (curWidget.indexOf(AppConst.AD_THUMBNAILS) >= 0) {
					curWidget = AppConst.AD_THUMBNAILS;
				}
				if (curWidget.indexOf(AppConst.AD_ABOUT) >= 0) {
					curWidget = AppConst.AD_ABOUT;
				}

				switch (curWidget) {
					case AppConst.AD_ABOUT:
						
						for (var abt: int = 0; abt < arrModName.length; abt++) {
							
							MovieClip(objMinisiteStage.getChildByName(arrModName[abt])).visible = false;
							if (arrModName[abt] == pData) {
								trace("showMItemData about menu curWidget==" + curWidget + " --- pData="+pData);
								//display on top
								objMinisiteStage.setChildIndex(MovieClip(objMinisiteStage.getChildByName(arrModName[abt])), objMinisiteStage.numChildren - fromTopIndex);
								MovieClip(objMinisiteStage.getChildByName(arrModName[abt])).visible = true;
								MovieClip(objMinisiteStage.getChildByName(arrModName[abt])).doAboutAnim();
								MovieClip(objMinisiteStage.getChildByName(arrModName[abt])).doShowTracking();
							}
						}


						break;

					case AppConst.AD_GALLERY:

						for (var i: int = 0; i < arrModName.length; i++) {
							if (arrModName[i] == pData) {
								//display on top
								objMinisiteStage.setChildIndex(objMinisiteStage.getChildByName(arrModName[i]), objMinisiteStage.numChildren - fromTopIndex);
								MovieClip(objMinisiteStage.getChildByName(arrModName[i])).visible = true;
								MovieClip(objMinisiteStage.getChildByName(arrModName[i])).resetGallery();
								MovieClip(objMinisiteStage.getChildByName(arrModName[i])).showContainer(0);
								MovieClip(objMinisiteStage.getChildByName(arrModName[i])).showTrackGal();

							}
						}
						break;

					case AppConst.AD_FIND_DEALER:
						objMinisiteStage.setChildIndex(objFindDealer, objMinisiteStage.numChildren - fromTopIndex);
						objFindDealer.visible = true;
						objFindDealer.animateDealer();
						objFindDealer.doShowTracking();
						break;

					case AppConst.AD_VIEW360:
						for (var k: int = 0; k < arrModName.length; k++) {
							if (arrModName[k] == pData) {
								//display on top
								objMinisiteStage.setChildIndex(objMinisiteStage.getChildByName(arrModName[k]), objMinisiteStage.numChildren - fromTopIndex);
								MovieClip(objMinisiteStage.getChildByName(arrModName[k])).visible = true;
								MovieClip(objMinisiteStage.getChildByName(arrModName[k])).doView360Anim();
								MovieClip(objMinisiteStage.getChildByName(arrModName[k])).doShowTracking();
							}
						}
						break;
					case AppConst.AD_THUMBNAILS:
						for (var m: int = 0; m < arrModName.length; m++) {
							if (arrModName[m] == pData) {
								//display on top
								objMinisiteStage.setChildIndex(objMinisiteStage.getChildByName(arrModName[m]), objMinisiteStage.numChildren - fromTopIndex);
								MovieClip(objMinisiteStage.getChildByName(arrModName[m])).doShowTracking();
								MovieClip(objMinisiteStage.getChildByName(arrModName[m])).visible = true;
								MovieClip(objMinisiteStage.getChildByName(arrModName[m])).doThumbAnim();
								MovieClip(objMinisiteStage.getChildByName(arrModName[m])).showFirstMedia();

							}
						}
						break;


					case AppConst.AD_YOUTUBE:
						objYoutubePlayer.showPlayer(youtubeXmlList);
						break;

				}

				objMinisiteStage.setChildIndex(objCloseBtn, objMinisiteStage.numChildren - 1)

			} catch (e: Error) {
				trace("\n ----------------itemclick - error" + e.message.toString() + "\n");
			}

		}

		function closeclicked(e: Event): void {
			hideAllMod();

			stopHideGalModules(); // for hidding gallery items
			stopHideTNailsMod(); //thumnails gallery
			StopFreeModsGal();

			if (isWelcomeFound) {
				if (!isRemoveAd) {

					objImageApp.doImageAppAnim();
					dispatchEvent(new Event(AppConst.EVENT_COLLAPSE, true));
				} else {
					dispatchEvent(new Event(AppConst.EVENT_AD_REMOVE, true));
				}

			} else {
				dispatchEvent(new Event(AppConst.EVENT_AD_REMOVE, true));
			}


			objMinisiteStage.visible = false;
			dispatchEvent(new Event(AppConst.EVENT_PLAY_PLAYER, true));
		}

		function stopHideGalModules(): void {
			for (var i: int = 0; i < arrModName.length; i++) {

				if (arrModName[i].indexOf(AppConst.AD_GALLERY) >= 0) {
					if (objMinisiteStage.getChildByName(arrModName[i]) != null)
						MovieClip(objMinisiteStage.getChildByName(arrModName[i])).StopAndHideAll();
				}
			}
		}

		function stopHideTNailsMod(): void {
			for (var i: int = 0; i < arrModName.length; i++) {
				
				if (arrModName[i].indexOf(AppConst.AD_THUMBNAILS) >= 0) {
					if (objMinisiteStage.getChildByName(arrModName[i]) != null)
						MovieClip(objMinisiteStage.getChildByName(arrModName[i])).StopAndHideGal();
						trace("\n------stopHideTNailsMod=" + arrModName[i]);
				}
			}
		}

		function showMiniSite(e: Event): void {
			startMiniSite();
		}

		public function loadMiniSiteData(pData: XMLList): void {
			msXmlList = null;
			isRemoveAd = false;
			msTotalLen=0;
			
			msXmlList = pData..mscontent;
			msTotalLen = msXmlList.length();

			isMenuFound = false;
			isWelcomeFound = false;
			showOnTop = false;
			showFirstWidget = false;
			imgArrNo =0;
			imgAnimArr.length = 0;
			arrModName.length = 0;
			arrTotalModules.length = 0;
			galleryNo = 0; // using in gallery name
			view360No = 0; //using in view360 name for menu
			thumbNo = 0;
			aboutNo = 0;
			for (var i: int = 0; i < msTotalLen; i++) {

				if (msXmlList[i].@type == AppConst.AD_BG_COLOR) {
					createBgColor(msXmlList.bgcolor);
				} else if (msXmlList[i].@type == AppConst.AD_IMAGE_APP) {
					isWelcomeFound = true;
					createImageApp(msXmlList[i].imageapp); // image app
				} else if (msXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createImage(msXmlList[i].imageslide); // image slide
				} else if (msXmlList[i].@type == AppConst.AD_CLOSE_BTN) {
					createCloseBtn(msXmlList[i].closebtn); // close btn position
				} else if (msXmlList[i].@type == AppConst.AD_ABOUT) {
					createAbout(msXmlList[i].about); // about data
				} else if (msXmlList[i].@type == AppConst.AD_GALLERY) {
					createGallery(msXmlList[i].gallery); // close btn position
				} else if (msXmlList[i].@type == AppConst.AD_MENU) {
					createAdMenu(msXmlList[i].admenu); // menu data
				} else if (msXmlList[i].@type == AppConst.AD_FIND_DEALER) {
					createFindDealer(msXmlList[i].finddealer); // find a dealer data
				} else if (msXmlList[i].@type == AppConst.AD_YOUTUBE) {
					createYouTubePlayer(msXmlList[i].youtube);
				} else if (msXmlList[i].@type == AppConst.AD_VIEW360) {
					createView360(msXmlList[i].view360); // view 360 data
				} else if (msXmlList[i].@type == AppConst.AD_THUMBNAILS) {
					createThumbNails(msXmlList[i].thumbnails); // view 360 data
				}
			} // for


			//access freeModule name from total module name
			arrFreeModule.length = 0;
			for (var no: int = 0; no < arrTotalModules.length; no++) {
				if (!(findElement(arrTotalModules[no], arrModName))) {
					trace("Not Related to Menu=" + arrTotalModules[no]);
					arrFreeModule.push(arrTotalModules[no]);
				}
			}


			//hideAllMod();
			//stopHideGalModules();   // for hidding gallery items
			//stopHideTNailsMod();    //thumnails gallery
			//StopFreeModsGal(); //stop all gallery modules of free widget

			//

			//if (isWelcomeFound) {
			//	objMinisiteStage.visible = false;
			//	this.setChildIndex(objImageApp, numChildren - 1);
			//} else {
			//	objMinisiteStage.visible = true;
			//	startMiniSite();
			//}
			//
			//if (isMenuFound) {

			//	objMinisiteStage.setChildIndex(objAdMenu, objMinisiteStage.numChildren - 1);
			//	if (showOnTop) fromTopIndex = 3;
			//}

			doStart();
		} //function
		
		
		function doStart():void
		{
			hideAllMod();

			stopHideGalModules(); // for hidding gallery items
			stopHideTNailsMod(); //thumnails gallery
			StopFreeModsGal();

			if (isWelcomeFound) {
				objMinisiteStage.visible = false;
				this.setChildIndex(objImageApp, numChildren - 1);
			
			} else {
				objMinisiteStage.visible = true;
				startMiniSite();
			}
			
			if (isMenuFound) {

				objMinisiteStage.setChildIndex(objAdMenu, objMinisiteStage.numChildren - 1);
				if (showOnTop) fromTopIndex = 3;
			}
		}
		
	public	function restartMiniSite():void
		{
			trace(">----------restartMiniSite --");
			
			doStart();
			if (isWelcomeFound) {
			 objImageApp.doImageAppAnim();  //animate welcome
			}
			
		}


		private function createImage(pXml: XMLList): void {
			var objImageModule: MovieClip = new ImageMC();
			objImageModule.name = "imgname" + imgArrNo;
			objMinisiteStage.addChild(objImageModule);
			objImageModule.loadImage(pXml);
			imgAnimArr[imgArrNo] = objImageModule.name;
			imgArrNo++;

		}

		private function createImageApp(pXml: XMLList): void {
			objImageApp.addEventListener(AppConst.EVENT_IMGAPP_SHOW, showMiniSite);
			this.addChild(objImageApp);
			objImageApp.loadImageApp(pXml);
		}

		private function createCloseBtn(pXml: XMLList): void {

			objCloseBtn = new CloseBtnMC();
			objMinisiteStage.addChild(objCloseBtn);
			objCloseBtn.btnData(pXml);

			if (pXml.removead == undefined) {
				isRemoveAd = false;
			} else if (pXml.removead == null) {
				isRemoveAd = false;
			} else if (pXml.hasOwnProperty("removead")) {
				isRemoveAd = pXml.removead.toLowerCase() == "true";
			}

		}


		private function createAdMenu(pXml: XMLList): void {

			for (var i: int = 0; i <= pXml..itemapp.length() - 1; i++) {
				if (pXml..itemapp[i].type == "widget")
					arrModName.push(pXml..itemapp[i].widgetname);
			}
			objAdMenu.name="objmenu";
			objMinisiteStage.addChild(objAdMenu);
			isMenuFound = true;
			if (pXml.showontop.length() > 0)
				showOnTop = pXml.showontop.toLowerCase() == "true";
			if (pXml.showfirstwidget.length() > 0)
				showFirstWidget = pXml.showfirstwidget.toLowerCase() == "true";
			objAdMenu.loadMenuItems(pXml);

		}

		private function createGallery(pXml: XMLList): void {
			++galleryNo;
			var objPhotoCon: MovieClip = new PhotoContainerMC();
			objPhotoCon.width = int(pXml.galwidth)*AppConst.MULTIPLIER;
			objPhotoCon.height = int(pXml.galheight)*AppConst.MULTIPLIER;
			objPhotoCon.x = int(pXml.galoffsetx)*AppConst.MULTIPLIER;
			objPhotoCon.y = int(pXml.galoffsety)*AppConst.MULTIPLIER;

			objPhotoCon.name = AppConst.AD_GALLERY + "_" + galleryNo;
			objMinisiteStage.addChild(objPhotoCon);
			objPhotoCon.showPhotos(pXml);
			arrTotalModules.push(objPhotoCon.name); //for hide/show
		}

		private function createAbout(pXml: XMLList): void {
			++aboutNo;
			var objAbout: MovieClip = new About();
			objAbout.name = AppConst.AD_ABOUT + "_" + aboutNo;
			objMinisiteStage.addChild(objAbout);
			objAbout.loadData(pXml);
			arrTotalModules.push(objAbout.name); //for hide/show
		}

		private function createFindDealer(pXml: XMLList): void {
			objFindDealer.name = AppConst.AD_FIND_DEALER;
			objMinisiteStage.addChild(objFindDealer);
			objFindDealer.loadDealerData(pXml);
			arrTotalModules.push(objFindDealer.name); //for hide/show
		}

		private function createView360(pXml: XMLList): void {
			++view360No;
			var objView360: MovieClip = new View360();
			objView360.name = AppConst.AD_VIEW360 + "_" + view360No;
			objMinisiteStage.addChild(objView360);
			objView360.loadData(pXml);
			arrTotalModules.push(objView360.name); //for hide/show
		}

		//thumbnails begin
		function createThumbNails(pXml: XMLList): void {
			++thumbNo;
			var objThumbN: MovieClip = new ThumbnailsMC();
			objThumbN.name = AppConst.AD_THUMBNAILS + "_" + thumbNo;
			objMinisiteStage.addChild(objThumbN);
			objThumbN.loadData(pXml);
			arrTotalModules.push(objThumbN.name); //for hide/show
		}
		//thumbnails end

		private function createYouTubePlayer(pXml: XMLList): void {
			youtubeXmlList = pXml; // for multy time use
			objYoutubePlayer = new YoutubeMC();
			objYoutubePlayer.visible = true;
			objMinisiteStage.addChild(objYoutubePlayer);
			arrTotalModules.push(AppConst.AD_YOUTUBE); //for hide/show

		}

		//hide all module
		private function hideAllMod(): void {
			stopHideGalModules(); // hide multiple gallery modules
			stopHideTNailsMod(); //thumnails gallery
			for (var i: int = 0; i < arrModName.length; i++) {
				if (objMinisiteStage.getChildByName(arrModName[i]) != null){
					MovieClip(objMinisiteStage.getChildByName(arrModName[i])).visible = false;
					trace("menu mods="+objMinisiteStage.getChildByName(arrModName[i]).name);
				if (arrModName[i].indexOf(AppConst.AD_ABOUT) >= 0) {
					MovieClip(objMinisiteStage.getChildByName(arrModName[i])).clearAboutGalData();
				}
			}
				//--
			}
			
			

			if ((objYoutubePlayer != null)) {
				objYoutubePlayer.hidePaused();
			}
		}

		private function StopFreeModsGal(): void {
			for (var i: int = 0; i < arrFreeModule.length; i++) {

				if (arrFreeModule[i].indexOf(AppConst.AD_GALLERY) >= 0) {
					if (objMinisiteStage.getChildByName(arrFreeModule[i]) != null)
						MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).StopAndHideAll();
				}
			}
		}


		private function findElement(word: Object, arr: Array): Boolean {
			exists = false;
			for (var i: uint = 0; i < arr.length; i++) {
				if (arr[i] == word) {
					exists = true;
				}
			}
			return exists;
		}

		public function startMiniSite(): void {
			hideAllMod();
			
			imgArrLen=0;
			imgArrLen = imgAnimArr.length;
			objMinisiteStage.visible = true;
			
			
			

			//lanuch freewidget gallery in 
			for (var i: int = 0; i < arrFreeModule.length; i++) {
				MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).visible = true;
				if ((arrFreeModule[i].indexOf(AppConst.AD_FIND_DEALER) >= 0))
					MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).doShowTracking();

				if (arrFreeModule[i].indexOf(AppConst.AD_GALLERY) >= 0) {
					MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).resetGallery();
					MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).showContainer(0);
					MovieClip(objMinisiteStage.getChildByName(arrFreeModule[i])).showTrackGal();
				}

			}
			
			
			
			
			for (var k: int = 0; k < imgArrLen; k++) {
				trace("\n--->>imgArrLen="+imgArrLen + " imgname="+objMinisiteStage.getChildByName(imgAnimArr[k]).name);
				MovieClip(objMinisiteStage.getChildByName(imgAnimArr[k])).doAnim();
			}
			
			////---------------
			//
			//for (var m: int = 0; m < arrModName.length; m++) {
			//	
			//	//objMinisiteStage.getChildAt(m).visible = false;
			//	this.objMinisiteStage.getChildByName(arrModName[m]).visible=false;
			//		trace("hidemodule=" +m + " arrModName=" + objMinisiteStage.getChildAt(m).name );
			//
			//	
			//}
			////---------------

			//lanuch freewidget gallery in 
			objAdMenu.doMenuAnim();
			if (showFirstWidget)
				showMItemData(arrModName[0]); // show first item menu data
			
			
			dispatchEvent(new Event(AppConst.EVENT_STOP_PLAYER, true));
			
		}

		public function ClearMinisiteData(): void {
			
			hideAllMod();
			stopHideGalModules(); // for hidding gallery items
			stopHideTNailsMod(); //thumnails gallery
			StopFreeModsGal();
			//removeAllCreatedData();
			
		}
		
		//function removeAllCreatedData():void
		//{
		//	//&&&&& for hiding all menu related module
		//	for (var k: int = 0; k < arrModName.length; k++) {
		//		if(objMinisiteStage.getChildByName(arrModName[k])!=null)
		//		//objMinisiteStage.removeChild(objMinisiteStage.getChildByName(arrModName[k]));
		//	}
		//	//-------
		//	for (var i: int = 0; i < arrModName.length; i++) {

		//		if (arrModName[i].indexOf(AppConst.AD_GALLERY) >= 0) {
		//			if (objMinisiteStage.getChildByName(arrModName[i]) != null){
		//				MovieClip(objMinisiteStage.getChildByName(arrModName[i])).StopAndHideAll();
		//				//objMinisiteStage.removeChild(objMinisiteStage.getChildByName(arrModName[i]));}
		//			
		//		}
		//	}
		//	//&&&&
		//	
		//	for (var k2: int = 0; k2 < imgArrLen; k2++) {
		//		//trace("\n--->>imgArrLen="+imgArrLen + " imgname="+objMinisiteStage.getChildByName(imgAnimArr[k2]).name);
		//		if(objMinisiteStage.getChildByName(imgAnimArr[k2])!=null)
		//		//objMinisiteStage.removeChild(objMinisiteStage.getChildByName(imgAnimArr[k2]));
		//	}
		//	
		//	if(objMinisiteStage.getChildByName("objmenu")!=null){
		//	//objMinisiteStage.removeChild(objMinisiteStage.getChildByName("objmenu"));}
		//	
		//	
		//}//functiona
		//
		
		

		function createBgColor(pXml: XMLList): void {
			objMinisiteStage.addChild(objBgColor);
			objBgColor.drawModuleBg(pXml);



		}
	}

}