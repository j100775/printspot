package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.net.navigateToURL;
	import com.pmi5media.classes.AppConst;
	import flash.display.Bitmap;
	import com.pmi5media.classes.Pmi5Tracking;
	import flash.net.URLLoader;
	import flash.display.PixelSnapping;



	public class ImgKWMC extends MovieClip {


		private var imgLoader: Loader = new Loader();
		private var xmlList: XMLList = new XMLList();

		private var offsetX: int;
		private var offsetY: int;
		private var imgPath: String;
		private var imgW: int;
		private var imgH: int;
		private var applyGlow: Boolean;
		private var enableClick: Boolean;
		private var clickURL: String;
		private var trackingURL: XMLList;
		private var _enableTrack: Boolean;

		private var imgMC: MovieClip = new MovieClip();
		private var loader: URLLoader = new URLLoader();

		public function ImgKWMC() {
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC, false, 0, true);

		}

		function addedImgMC(E: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedImgMC);
			this.addChild(imgMC);
		}

		function onOver(e: MouseEvent): void {
			imgMC.filters = [new GlowFilter(0xffffff, 1, 20, 20, 2.5)];
		}

		function onOut(e: MouseEvent): void {
			imgMC.filters = null;
		}

		public function loadImage(pData: XMLList): void {
			imgPath = pData.imgpath;
			offsetX = int(pData.offsetx)*AppConst.MULTIPLIER;
			offsetY = int(pData.offsety)*AppConst.MULTIPLIER;
			imgW = int(pData.imgwidth)*AppConst.MULTIPLIER;
			if (imgW > AppConst.SCREEN_WIDTH) {
				imgW = AppConst.SCREEN_WIDTH;
				offsetX = 0;
			}


			imgH = int(pData.imgheight)*AppConst.MULTIPLIER;
			if (imgH > AppConst.SCREEN_HEIGHT) {
				imgH = AppConst.SCREEN_HEIGHT;
				offsetY = 0;
			}

			applyGlow = pData.gloweffect.toLowerCase() == "true";
			trackingURL = pData.trackingurl;

			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";
			clearAndUnload();
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgError, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
			imgLoader.load(new URLRequest(imgPath));
		}

		function imgLoaded(e: Event): void {
			imgLoader.width = imgW;
			imgLoader.height = imgH;
			imgLoader.x = offsetX;
			imgLoader.y = offsetY;
			if (applyGlow) {
				imgMC.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				imgMC.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			}


			imgMC.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			imgMC.buttonMode = true;

			var bmpImgLoader:Bitmap = imgLoader.content as Bitmap;
     		bmpImgLoader.smoothing=true;
			bmpImgLoader.pixelSnapping=PixelSnapping.AUTO;
			bmpImgLoader.width = imgW;
			bmpImgLoader.height = imgH;
			bmpImgLoader.x = offsetX;
			bmpImgLoader.y = offsetY;
			imgMC.addChild(bmpImgLoader);
		 		
			//imgMC.addChild(imgLoader);
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

		}

		public function clearAndUnload(): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

			imgMC.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			imgMC.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			imgMC.removeEventListener(MouseEvent.CLICK, onClick);
			deleteAllChild();
		}

		function deleteAllChild(): void {
			for (var i: int = imgMC.numChildren - 1; i >= 0; i--) {
				imgMC.removeChildAt(i);
			}
		}

		function onClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_KEEP_WATCH, true));
			if (_enableTrack) {
				Pmi5Tracking.doTrack(trackingURL);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackingURL), true));
			}

		}

		function imgError(er: IOErrorEvent): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			imgLoader = null;
		}



	} // class

} //pkg