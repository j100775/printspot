package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;


	public class ThumbBackBtn extends MovieClip {

		private var btnXmlList: XMLList;
		private var _enableTrack: Boolean;

		private var backImgLoader: Loader = new Loader();
		private var backImgW: int;
		private var backImgH: int;

		public function ThumbBackBtn() {
			// constructor code
			this.buttonMode = true;
			addEventListener(Event.ADDED_TO_STAGE, backMCAdded, false, 0, true);
		}
		function backMCAdded(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, backMCAdded);
			addEventListener(MouseEvent.CLICK, onBkClick);
		}
		function onBkClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_BACK_BTN, true));
			if (_enableTrack) {
				Pmi5Tracking.doTrack(btnXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(btnXmlList), true));
			}
		}

		public function setTNBackBtnProp(pData: XMLList): void {
			btnXmlList = pData.trackingurl;
			this.x = int(pData.offsetx)*AppConst.MULTIPLIER;
			this.y = int(pData.offsety)*AppConst.MULTIPLIER;

			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";

			if (pData.imgwidth.length() > 0)
				backImgW =int(pData.imgwidth)*AppConst.MULTIPLIER;

			if (pData.imgheight.length() > 0)
				backImgH = int(pData.imgheight)*AppConst.MULTIPLIER;


			if (pData.imgpath.length() > 0) {
				backImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, biLoaded, false, 0, true);
				backImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, biError, false, 0, true);
				backImgLoader.load(new URLRequest(pData.imgpath));
			} else {
				getDefBackBtn();
			}

		}
		private function biLoaded(e: Event): void {
			//backImgLoader.width = backImgW;
			//backImgLoader.height = backImgH;
			var bmp:Bitmap = backImgLoader.content as Bitmap;
			bmp.smoothing =true;
			bmp.pixelSnapping = PixelSnapping.AUTO;
			bmp.width = backImgW;
			bmp.height = backImgH;
			this.addChild(bmp);
			
			//this.addChild(backImgLoader);

			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);

		}
		private function biError(e: IOErrorEvent): void {
			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);
			getDefBackBtn();
		}

		private function getDefBackBtn(): void {
			var bmpBackBtn: Bitmap = IconsPmi5.getBackBtn();
			bmpBackBtn.width = AppConst.BACK_BTN_W;
			bmpBackBtn.height = AppConst.BACK_BTN_H;
			this.addChild(bmpBackBtn);
		}

	} //class

}