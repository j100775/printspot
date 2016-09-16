package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;


	public class ThumbnailsMC extends MovieClip {

		private var thumbXmlList: XMLList = new XMLList();
		private var thumbXmlLen: int;

		private var enableTrack: Boolean;
		private var trackXmlList: XMLList = new XMLList();

		private var thumbImgNo: int;

		private var imgAnimArr: Array = new Array();
		private var imgArrLen: int;
		private var imgArrNo: int;

		private var galModArr: Array = new Array();
		private var galArrLen: int;
		private var galArrNo: int;

		private var isthumbBkBtn: Boolean;
		private var objTNBackBtn: MovieClip = new ThumbBackBtn();

		public function ThumbnailsMC() {
			// constructor code
		}

		public function loadData(pXml: XMLList) {
			isthumbBkBtn = false;
			enableTrack = false;
			imgArrNo = 0;
			imgAnimArr.length = 0;
			galModArr.length = 0;
			galArrNo = 0;
			thumbXmlList = pXml..thumbdata;
			thumbXmlLen = thumbXmlList.length();
			for (var i: int = 0; i < thumbXmlLen; i++) {
				if (thumbXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createThumbImage(thumbXmlList[i].imageslide);
				} else if (thumbXmlList[i].@type == AppConst.AD_BACK_BTN) {
					isthumbBkBtn = true;
				} else if (thumbXmlList[i].@type == AppConst.AD_THUMB_GAL) {
					createThumbGal(thumbXmlList[i].thumbgallery); // close btn position
				}
			}

			if (pXml.enabletracking.length() > 0)
				enableTrack = pXml.enabletracking.toLowerCase() == "true";

			if (pXml.trackingurl.length() > 0)
				trackXmlList = pXml.trackingurl;

			if (isthumbBkBtn) {
				this.addChild(objTNBackBtn);
				objTNBackBtn.setTNBackBtnProp(thumbXmlList.backbtn);
			}

		}

		private function createThumbImage(pXml: XMLList): void {
			imgArrNo++;
			var objImageModule: MovieClip = new ImageMC();
			objImageModule.name = "img" + imgArrNo;
			this.addChild(objImageModule);
			objImageModule.loadImage(pXml);
			imgAnimArr.push(objImageModule.name);
		}

		private function createThumbGal(pXml: XMLList): void {
			galArrNo++;
			var objThumbGal: MovieClip = new ThumbGalleryMC();
			objThumbGal.width = int(pXml.tgalwidth)*AppConst.MULTIPLIER;
			objThumbGal.height = int(pXml.tgalheight)*AppConst.MULTIPLIER;
			objThumbGal.x = int(pXml.tgaloffsetx)*AppConst.MULTIPLIER;
			objThumbGal.y = int(pXml.tgaloffsety)*AppConst.MULTIPLIER;

			objThumbGal.name = AppConst.AD_THUMB_GAL + "_" + galArrNo;

			addChild(objThumbGal);
			this.setChildIndex(objThumbGal, this.numChildren - 1);
			objThumbGal.loadPhotos(pXml);
			galModArr.push(objThumbGal.name);

		}

		public function StopAndHideGal(): void {
			galArrLen = galModArr.length;
			for (var k: int = 0; k < galArrLen; k++) {
				MovieClip(this.getChildByName(galModArr[k])).StopAndHideAll();
			}
		}
		public function doThumbAnim(): void {
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

		public function showFirstMedia(): void {
			for (var m: int = 0; m < galModArr.length; m++) {
				MovieClip(this.getChildByName(galModArr[m])).showGallryItem(0);
			}
		}

	} //class

}