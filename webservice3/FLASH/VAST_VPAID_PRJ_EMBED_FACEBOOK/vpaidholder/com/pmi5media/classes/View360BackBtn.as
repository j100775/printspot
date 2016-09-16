package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;


	public class View360BackBtn extends MovieClip {

		private var btnXmlList: XMLList;
		private var _enableTrack: Boolean;

		private var backImgLoader: Loader = new Loader();
		private var backImgW: int;
		private var backImgH: int;


		public function View360BackBtn() {
			this.buttonMode = true;
		}


		public function onBkClickTrack(): void {
			if (_enableTrack) {
				Pmi5Tracking.doTrack(btnXmlList);
				// js tracking is not working here so shifted in parent class - View360.as

			}
		}

		public function setBackBtnProp(pData: XMLList): void {
			btnXmlList = pData.trackingurl;
			this.x = int(pData.offsetx)*AppConst.MULTIPLIER;
			this.y = int(pData.offsety)*AppConst.MULTIPLIER;
			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";



			if (pData.imgwidth.length() > 0)
				backImgW = int(pData.imgwidth)* AppConst.MULTIPLIER;

			if (pData.imgheight.length() > 0)
				backImgH = int(pData.imgheight)* AppConst.MULTIPLIER;


			if (pData.imgpath.length() > 0) {
				backImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, biLoaded, false, 0, true);
				backImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, biError, false, 0, true);
				backImgLoader.load(new URLRequest(pData.imgpath));
			} else {
				getDefViewBackBtn();
			}

		}

		private function biLoaded(e: Event): void {
			backImgLoader.width = backImgW;
			backImgLoader.height = backImgH;
			
			
			var bmpImg:Bitmap = backImgLoader.content as Bitmap;
			bmpImg.smoothing=true;
			bmpImg.pixelSnapping = PixelSnapping.AUTO;			
			bmpImg.height = backImgH;
			bmpImg.width = backImgW;
			this.addChild(bmpImg);
			
			//this.addChild(backImgLoader);

			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);

		}
		private function biError(e: IOErrorEvent): void {
			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);
			getDefViewBackBtn();
		}

		private function getDefViewBackBtn(): void {
			var bmpViewBackBtn: Bitmap = IconsPmi5.getBackBtn();
			bmpViewBackBtn.width = AppConst.BACK_BTN_W;
			bmpViewBackBtn.height = AppConst.BACK_BTN_H;
			this.addChild(bmpViewBackBtn);
		}


	} //class
} //pkg