package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import flash.events.Event;


	public class View360 extends MovieClip {


		private var viewsXmlList: XMLList = new XMLList();
		private var viewsXmlLen: int;

		private var enableTrack: Boolean;
		private var trackXmlList: XMLList = new XMLList();

		private var viewsImgNo: int;
		private var imgAnimArr: Array = new Array();
		private var imgArrLen: int;
		private var imgArrNo: int;
		private var isviewsBkBtn: Boolean;
		private var objViewBackBtn: MovieClip = new View360BackBtn();
		private var enableVBackTrack: Boolean;
		

		public function View360() {
			// constructor code
		}

		public function loadData(pXml: XMLList) {
			isviewsBkBtn = false;
			enableTrack = false;
			imgArrNo = 0;
			imgAnimArr.length = 0;
			viewsXmlList = pXml..viewdata;
			viewsXmlLen = viewsXmlList.length();
			for (var i: int = 0; i < viewsXmlLen; i++) {
				if (viewsXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createViewsImage(viewsXmlList[i].imageslide);
				} else if (viewsXmlList[i].@type == AppConst.AD_BACK_BTN) {
					isviewsBkBtn = true;
				} else if (viewsXmlList[i].@type == AppConst.AD_VIEW360_GAL) {
					createViewGal(viewsXmlList[i].viewgallery); // close btn position
				}
			}

			if (pXml.enabletracking.length() > 0)
				enableTrack = pXml.enabletracking.toLowerCase() == "true";

			if (pXml.trackingurl.length() > 0)
				trackXmlList = pXml.trackingurl;

			if (isviewsBkBtn) {
				objViewBackBtn.addEventListener(MouseEvent.CLICK, viewBackClk);
				this.addChild(objViewBackBtn);
				objViewBackBtn.setBackBtnProp(viewsXmlList..backbtn);
				enableVBackTrack = viewsXmlList..backbtn.enabletracking.toLowerCase() == "true";
			}

		}


		function viewBackClk(e: MouseEvent): void {
			if (enableVBackTrack) {
				objViewBackBtn.onBkClickTrack();
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(viewsXmlList..backbtn.trackingurl), true));
			}

			dispatchEvent(new Event(AppConst.EVENT_BACK_BTN, true));
		}


		private function createViewsImage(pXml: XMLList): void {
			imgArrNo++;
			var objImageModule: MovieClip = new ImageMC();
			objImageModule.name = "img" + imgArrNo;
			this.addChild(objImageModule);
			objImageModule.loadImage(pXml);
			imgAnimArr.push(objImageModule.name);
		}

		private function createViewGal(pXml: XMLList): void {

			var objVPhotoCon: MovieClip = new View360Gallery();

			objVPhotoCon.width = int(pXml.viewwidth)*AppConst.MULTIPLIER;
			objVPhotoCon.height = int(pXml.viewheight)*AppConst.MULTIPLIER;
			objVPhotoCon.x = int(pXml.viewoffsetx)* AppConst.MULTIPLIER;
			objVPhotoCon.y = int(pXml.viewoffsety)* AppConst.MULTIPLIER;;

			objVPhotoCon.name = AppConst.AD_VIEW360_GAL;
			addChild(objVPhotoCon);
			this.setChildIndex(objVPhotoCon, this.numChildren - 1);
			objVPhotoCon.loadPhotos(pXml);

		}

		public function doView360Anim(): void {
			imgArrLen = imgAnimArr.length;
			for (var i: int = 0; i < imgArrLen; i++) {
				MovieClip(this.getChildByName(imgAnimArr[i])).doAnim();
			}
		}

		public function doShowTracking(): void {
			if (enableTrack) {
				Pmi5Tracking.doShowTrack(trackXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackXmlList), true));
			}
		}


	} //class
} //pkg