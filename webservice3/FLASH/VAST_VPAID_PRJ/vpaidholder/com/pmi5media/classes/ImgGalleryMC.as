package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import fl.transitions.Tween;
	import flash.display.Sprite;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	import flash.net.URLLoader;
	import flash.events.IEventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.navigateToURL;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	import fl.transitions.TweenEvent;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import com.pmi5media.classes.AppConst;
	import flash.display.Bitmap;
	import flash.system.LoaderContext;
	import com.pmi5media.classes.Pmi5Tracking;
	import flash.display.PixelSnapping;


	public class ImgGalleryMC extends MovieClip {

		private var imgLoader: Loader = new Loader();
		private var lc: LoaderContext = new LoaderContext();
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

		private var applyanim: Boolean;
		private var delayTimeAnim: Number;
		private var effectType: String;
		private var slideFrom: String = "left";
		private var imgTween: Tween;

		private var imgBgMC: MovieClip = new MovieClip();
		private var imgMC: MovieClip = new MovieClip();
		private var loader: URLLoader = new URLLoader();


		public function ImgGalleryMC() {
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC);
		}

		function addedImgMC(E: Event): void {
			this.addChild(imgBgMC);
			this.addChild(imgMC);
			lc.checkPolicyFile = false;
		}

		function onOver(e: MouseEvent): void {
			imgBgMC.filters = [new GlowFilter(0xffffff, 1, 10, 10, 2.5)];
		}

		function onOut(e: MouseEvent): void {
			imgBgMC.filters = null;
		}

		public function loadImage(pData: XMLList): void {
			_enableTrack = false;
			imgPath = pData.imgpath;
			offsetX = pData.offsetx;
			offsetY = pData.offsety;
			imgW = pData.imgwidth;
			if (imgW > 640) {
				imgW = 640;
				offsetX = 0;
			}


			imgH = pData.imgheight;
			if (imgH > 360) {
				imgH = 360;
				offsetY = 0;
			}

			enableClick = pData.enableclick.toLowerCase() == "true";
			clickURL = pData.clickurl;
			trackingURL = pData.trackingurl;

			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";

			applyGlow = pData.gloweffect.toLowerCase() == "true";

			applyanim = pData.applyanim.toLowerCase() == "true";
			delayTimeAnim = pData.delaytime;
			effectType = pData.effecttype.toLowerCase();
			slideFrom = pData.slidefrom.toLowerCase();

			clearAndUnload();

			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgError, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
			imgLoader.load(new URLRequest(imgPath), lc);
		}

		function imgLoaded(e: Event): void {
			imgLoader.width = imgW;
			imgLoader.height = imgH;
			imgLoader.x = offsetX;
			imgLoader.y = offsetY;
			if (applyGlow) {
				imgBgMC.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				imgBgMC.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			}

			if (enableClick) {
				imgBgMC.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				imgBgMC.buttonMode = true;
			}

			var bmpImg:Bitmap = imgLoader.content as Bitmap;
			bmpImg.width = imgW;
			bmpImg.height = imgH;
			bmpImg.x = offsetX;
			bmpImg.y = offsetY;
			bmpImg.smoothing=true;
			bmpImg.pixelSnapping=PixelSnapping.AUTO;
			imgBgMC.addChild(bmpImg);
			/*imgMC.addChild(imgLoader);
			this.addChild(imgMC);*/

			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

			/*if (applyanim)
				doAnim();
			else
				setImaage()*/
		}


		function onClick(e: MouseEvent): void {
			navigateToURL(new URLRequest(clickURL));
			if (_enableTrack) {
				Pmi5Tracking.doTrack(trackingURL);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackingURL), true));

			}

		}


		public function doAnim(): void {
			//delayAnim();
		}

		private function delayAnim(): void {
			imgMC.visible = true;

			if (effectType.toLowerCase() == "move") {
				doAnimation(slideFrom);
			} else {
				imgTween = new Tween(imgLoader, "alpha", Strong.easeOut, 0, 1, .5, true);
				imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
				imgTween.stop();
				imgTween.start();
			}
		}

		function doAnimation(pStr: String): void {
			trace("slide from=" + pStr);
			switch (pStr) {
				case "right":
					imgTween = new Tween(imgLoader, "x", Strong.easeOut, (AppConst.SCREEN_WIDTH + imgLoader.width + 50), offsetX, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "top":
					imgTween = new Tween(imgLoader, "y", Strong.easeOut, (-imgH), offsetY, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "bottom":
					imgTween = new Tween(imgLoader, "y", Strong.easeOut, (AppConst.SCREEN_HEIGHT), offsetY, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;


				default:
					//imgMC.x=100;
					//imgMC.y=offsetY;
					imgTween = new Tween(imgLoader, "x", Strong.easeOut, (-imgW * 1.5), offsetX, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();

			}
		}

		function tweenFinish(et: TweenEvent): void {
			imgTween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			imgTween = null;
			setImaage();

		}

		private function setImaage(): void {
			removeBgGalImgs(); // remove and hide bg image
			//crate duplicate image
			var duplicationBitmap: Bitmap = new Bitmap(Bitmap(imgLoader.content).bitmapData);
			imgBgMC.addChild(duplicationBitmap);
			imgBgMC.x = imgLoader.x;
			imgBgMC.y = imgLoader.y;
			imgBgMC.width = imgLoader.width;
			imgBgMC.height = imgLoader.height;
			imgBgMC.visible = true;

			imgMC.visible = false;
			deleteAllChild(imgMC);
		}

		public function clearAndUnload(): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

			imgMC.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			imgMC.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			imgMC.removeEventListener(MouseEvent.CLICK, onClick);
			deleteAllChild(imgMC);
		}

		public function removeBgGalImgs(): void {
			imgBgMC.visible = false;
			deleteAllChild(imgBgMC);
			imgMC.visible = false;
		}

		function deleteAllChild(obj: * ): void {
			for (var i: int = obj.numChildren - 1; i >= 0; i--) {
				obj.removeChildAt(i);
			}
		}

		function imgError(er: IOErrorEvent): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			imgLoader = null;
		}


	} // class

}