package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;

	public class About extends MovieClip {

		private var abtXmlList: XMLList = new XMLList();
		private var abtXmlLen: int;

		private var enableTrack: Boolean;
		private var trackXmlList: XMLList = new XMLList();

		private var abtImgNo: int;
		private var imgAnimArr: Array = new Array();
		private var imgArrLen: int;
		private var imgArrNo: int;
		private var isAbtBkBtn: Boolean;
		private var enableBkBtnTrack: Boolean;
		private var galNo: int;
		private var thumbGalNo: int;
		private var galNamesArr: Array = new Array();
		private var thumbGalNameArr: Array = new Array();

		var objAbtBkBtn: MovieClip = new AboutBackkBtnMC();

		public function About() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addtostage, false, 0, true);
		}

		function addtostage(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addtostage);
			//this.addChild(objTxt);
			this.addChild(objAbtBkBtn);
			objAbtBkBtn.visible = false;
		}

		public function loadData(pXml: XMLList) {
			galNo = 0;
			thumbGalNo = 0;
			isAbtBkBtn = false;
			enableTrack = false;
			imgArrNo = 0;
			imgAnimArr.length = 0;
			galNamesArr.length = 0;
			thumbGalNameArr.length = 0;
			abtXmlList = pXml..adata;
			abtXmlLen = abtXmlList.length();
			for (var i: int = 0; i < abtXmlLen; i++) {
				if (abtXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createAbtImage(abtXmlList[i].imageslide);
				} else if (abtXmlList[i].@type == AppConst.AD_ABOUT_TEXT) {
					createAbtText(abtXmlList[i].abouttext);
				} else if (abtXmlList[i].@type == AppConst.AD_BACK_BTN) {
					isAbtBkBtn = true;
				} else if (abtXmlList[i].@type == AppConst.AD_GALLERY) {
					createGalleryAbt(abtXmlList[i].gallery);
				} else if (abtXmlList[i].@type == AppConst.AD_THUMBNAILS) {

					createThumbNailsFW(abtXmlList[i].thumbnails); //thumbnails free widget
				}


			}

			if (pXml.enabletracking.length() > 0)
				enableTrack = pXml.enabletracking.toLowerCase() == "true";

			if (pXml.trackingurl.length() > 0)
				trackXmlList = pXml.trackingurl;

			if (isAbtBkBtn) {

				objAbtBkBtn.loadAbgBkImg(abtXmlList..backbtn);
				//this.addChild(objAbtBkBtn);
				objAbtBkBtn.visible = true;
				objAbtBkBtn.addEventListener(MouseEvent.CLICK, abtBkClick);
				this.setChildIndex(objAbtBkBtn, numChildren - 1);
				enableBkBtnTrack = abtXmlList..backbtn.enabletracking.toLowerCase() == "true";
			}

		}


		//-------------------
		function createThumbNailsFW(pXml: XMLList): void {
			thumbGalNo++;
			var objThumbN: MovieClip = new ThumbnailsMC();
			objThumbN.name = AppConst.AD_THUMBNAILS + "_" + thumbGalNo;
			objThumbN.addEventListener(AppConst.EVENT_BACK_BTN, onTNBackBtn, false, 0, true);
			this.addChild(objThumbN);
			objThumbN.loadData(pXml);
			thumbGalNameArr.push(objThumbN.name);
		}

		function onTNBackBtn(e: Event): void {
			//thumbgallery back btn
			trace("about - thumb gallery back btn on root" + e.currentTarget.name.toString());
			MovieClip(this.getChildByName(e.currentTarget.name)).StopAndHideGal();
			MovieClip(this.getChildByName(e.currentTarget.name)).visible = false;
		}

		function createGalleryAbt(pXml: XMLList): void {
			galNo++;
			var objGalleryAbt: MovieClip = new PhotoContainerMC();
			objGalleryAbt.name = AppConst.AD_GALLERY + "_" + galNo;
			objGalleryAbt.addEventListener(AppConst.EVENT_BACK_BTN, galBackBtn, false, 0, true);
			objGalleryAbt.width = pXml.galwidth;
			objGalleryAbt.height = pXml.galheight;
			objGalleryAbt.x = pXml.galoffsetx;
			objGalleryAbt.y = pXml.galoffsety;
			this.addChild(objGalleryAbt);
			galNamesArr.push(objGalleryAbt.name);


			objGalleryAbt.showPhotos(pXml);
			objGalleryAbt.resetGallery();
			objGalleryAbt.showContainer(0);

		}

		function galBackBtn(e: Event): void {
			MovieClip(this.getChildByName(e.currentTarget.name)).StopAndHideAll();
			MovieClip(this.getChildByName(e.currentTarget.name)).hideGalleryBgImg();
			MovieClip(this.getChildByName(e.currentTarget.name)).visible = false;
		}


		function abtBkClick(e: MouseEvent): void {
			if (enableBkBtnTrack) {
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(abtXmlList..backbtn.trackingurl), true));
				objAbtBkBtn.onBgTrack();
			}

			//gallery
			for (var i: int = 0; i < galNamesArr.length; i++) {
				MovieClip(this.getChildByName(galNamesArr[i])).StopAndHideAll();
				MovieClip(this.getChildByName(galNamesArr[i])).hideGalleryBgImg();
			}

			//thumb gallery
			for (var k: int = 0; k < thumbGalNameArr.length; k++) {
				MovieClip(this.getChildByName(thumbGalNameArr[k])).StopAndHideGal();
			}

			dispatchEvent(new Event(AppConst.EVENT_BACK_BTN, true));

			//stop and hide gallery 
		}

		private function createAbtImage(pXml: XMLList): void {
			imgArrNo++;
			var objImageModule: MovieClip = new ImageMC();
			objImageModule.name = "img" + imgArrNo;
			this.addChild(objImageModule);
			objImageModule.loadImage(pXml);
			imgAnimArr.push(objImageModule.name);
		}

		public function doAboutAnim(): void {
			imgArrLen = imgAnimArr.length;
			for (var i: int = 0; i < imgArrLen; i++) {
				MovieClip(this.getChildByName(imgAnimArr[i])).doAnim();
			}

			for (var j: int = 0; j < galNamesArr.length; j++) {
				trace("-- about gallery name=" + galNamesArr[j] + "\n");
				MovieClip(this.getChildByName(galNamesArr[j])).resetGallery();
				MovieClip(this.getChildByName(galNamesArr[j])).showContainer(0);
			}

			for (var k2: int = 0; k2 < thumbGalNameArr.length; k2++) {
				trace("--<>>>>><><>< about thumbGalNameArr name=" + thumbGalNameArr[k2] + "\n");
				MovieClip(this.getChildByName(thumbGalNameArr[k2])).doThumbAnim();
				MovieClip(this.getChildByName(thumbGalNameArr[k2])).showFirstMedia();
				MovieClip(this.getChildByName(thumbGalNameArr[k2])).doShowTracking
			}
		}

		private function createAbtText(pXml: XMLList): void {
			var objTxt: MovieClip = new TxtFieldMC();
			this.addChild(objTxt);
			objTxt.loadData(pXml);
		}

		public function doShowTracking(): void {
			if (enableTrack) {
				Pmi5Tracking.doShowTrack(trackXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackXmlList), true));



				for (var i: int = 0; i < galNamesArr.length; i++) {
					MovieClip(this.getChildByName(galNamesArr[i])).showTrackGal();
				}

				for (var k: int = 0; k < thumbGalNameArr.length; k++) {
					MovieClip(this.getChildByName(thumbGalNameArr[k])).doShowTracking();
				}

			}
		}

		public function clearAboutGalData(): void {

			//gallery
			for (var i: int = 0; i < galNamesArr.length; i++) {
				MovieClip(this.getChildByName(galNamesArr[i])).StopAndHideAll();
			}

			//thumb gallery
			for (var k: int = 0; k < thumbGalNameArr.length; k++) {
				MovieClip(this.getChildByName(thumbGalNameArr[k])).StopAndHideGal();
			}
		}


	} //class

} //pkg