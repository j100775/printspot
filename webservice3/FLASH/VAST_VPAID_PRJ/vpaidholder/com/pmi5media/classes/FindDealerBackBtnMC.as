package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;


	public class FindDealerBackBtnMC extends MovieClip {

		private var btnXmlList: XMLList;
		private var _enableTrack: Boolean;

		private var backImgLoader: Loader = new Loader();
		private var backImgW: int;
		private var backImgH: int;

		public function FindDealerBackBtnMC() {
			// constructor code
			this.buttonMode = true;

		}


		public function onFDBkClick(): void {
			trace("FIND DEALER back btn");

			if (_enableTrack) {
				Pmi5Tracking.doTrack(btnXmlList);
				// js tracking is not working here so shifted in parent class - FindDealer.as
			}
		}


		public function loadImage(pData: XMLList): void {
			btnXmlList = pData.trackingurl;
			this.x = pData.offsetx;
			this.y = pData.offsety;
			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";

			if (pData.imgwidth.length() > 0)
				backImgW = pData.imgwidth;

			if (pData.imgheight.length() > 0)
				backImgH = pData.imgheight;


			if (pData.imgpath.length() > 0) {
				backImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, biLoaded, false, 0, true);
				backImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, biError, false, 0, true);
				backImgLoader.load(new URLRequest(pData.imgpath));
			} else {
				getDefDFBackBtn();
			}

		}

		private function biLoaded(e: Event): void {
			//backImgLoader.width = backImgW;
			//backImgLoader.height = backImgH;
			
			var bmpimg:Bitmap = backImgLoader.content as Bitmap;
			bmpimg.smoothing=true;
			bmpimg.pixelSnapping = PixelSnapping.AUTO;
			bmpimg.width = backImgW;
			bmpimg.height = backImgH;
			this.addChild(bmpimg);
			//this.addChild(backImgLoader);

			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);

		}
		private function biError(e: IOErrorEvent): void {
			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, biError);
			getDefDFBackBtn();
		}

		private function getDefDFBackBtn(): void {
			var bmpFDBackBtn: Bitmap = IconsPmi5.getBackBtn();
			bmpFDBackBtn.width = AppConst.BACK_BTN_W;
			bmpFDBackBtn.height = AppConst.BACK_BTN_H;
			this.addChild(bmpFDBackBtn);
		}

	} //class

} //pkg