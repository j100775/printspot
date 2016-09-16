package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;


	public class FindDealer extends MovieClip {


		private var fdXmlList: XMLList = new XMLList();
		private var fdUFormXmlList: XMLList = new XMLList();
		private var fdtXmlLen: int;
		private var imgAnimArr: Array = new Array();
		private var imgArrLen: int;
		private var imgArrNo: int;
		private var isUserForm: Boolean;
		private var isDealerBackBtn: Boolean;
		private var enableTrack: Boolean;
		private var trackXmlList: XMLList = new XMLList();
		private var enableBackBtnTrack: Boolean;

		private var objFDBackBtn: MovieClip = new FindDealerBackBtnMC();

		public function FindDealer() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			//this.width = AppConst.SCREEN_WIDTH;
			//this.height = AppConst.SCREEN_HEIGHT;
		}

		public function loadDealerData(pXml: XMLList) {
			isUserForm = false;
			isDealerBackBtn = false;
			fdXmlList = null;
			imgArrNo = 0;
			imgAnimArr.length = 0;
			enableTrack = false;

			fdXmlList = pXml..fddata;
			fdtXmlLen = fdXmlList.length();



			if (pXml.enabletracking.length() > 0)
				enableTrack = pXml.enabletracking.toLowerCase() == "true";

			if (pXml.trackingurl.length() > 0)
				trackXmlList = pXml.trackingurl;

			for (var i: int = 0; i < fdtXmlLen; i++) {
				trace(" --  i " + i + " typy= " + fdXmlList[i].@type);
				if (fdXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createDealerImage(fdXmlList[i].imageslide);
				} else if (fdXmlList[i].@type == AppConst.AD_DEALER_FORM) {
					//createUserForm(fdXmlList[i].dealerform); 
					fdUFormXmlList = fdXmlList[i].dealerform;
					isUserForm = true;
				} else if (fdXmlList[i].@type == AppConst.AD_BACK_BTN) {
					isDealerBackBtn = true;
				}

			} //for loop

			if (isUserForm)
				createUserForm(fdUFormXmlList);

			if (isDealerBackBtn) {
				this.addChild(objFDBackBtn);
				objFDBackBtn.addEventListener(MouseEvent.CLICK, backClk);
				objFDBackBtn.loadImage(fdXmlList..backbtn);
				enableBackBtnTrack = fdXmlList..backbtn.enabletracking.toLowerCase() == "true";
			}

		}

		function backClk(e: MouseEvent): void {

			if (enableBackBtnTrack) {
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(fdXmlList..backbtn.trackingurl), true));
				objFDBackBtn.onFDBkClick();
			}

			dispatchEvent(new Event(AppConst.EVENT_BACK_BTN, true));
		}

		private function createDealerImage(pXml: XMLList): void {
			imgArrNo++;
			var objImageModule: MovieClip = new ImageMC();
			objImageModule.name = "img" + imgArrNo;
			this.addChild(objImageModule);
			objImageModule.loadImage(pXml);
			imgAnimArr.push(objImageModule.name);
		}

		private function createUserForm(pXml: XMLList): void {
			var objForm: MovieClip = new DealerUserForm();
			this.addChild(objForm);
			objForm.formData(pXml);
		}

		public function animateDealer(): void {
			imgArrLen = imgAnimArr.length - 1;
			for (var i: int = 0; i <= imgArrLen; i++) {
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