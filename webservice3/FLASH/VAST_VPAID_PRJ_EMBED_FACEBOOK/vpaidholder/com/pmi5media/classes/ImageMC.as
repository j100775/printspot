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
	import flash.events.IOErrorEvent;
	import flash.net.navigateToURL;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	import fl.transitions.TweenEvent;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	import com.pmi5media.classes.AppConst;
	import flash.display.Bitmap;
	import com.pmi5media.classes.Pmi5Tracking;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;



	public class ImageMC extends MovieClip {

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

		private var applyanim: Boolean;
		private var delayTimeAnim: Number;
		private var effectType: String;
		private var slideFrom: String = "left";

		private var imgTween: Tween;
		private var imgBgMC: MovieClip = new MovieClip();
		private var imgMC: MovieClip = new MovieClip();
		
		private var multiplier:int=2;

		private var loader: URLLoader = new URLLoader();

		private var imgTimer: Timer;
		
		var bmp:Bitmap;

		public function ImageMC() {
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC, false, 0, true);

		}

		function addedImgMC(E: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedImgMC);
			var sprite: Sprite = new Sprite();
			imgBgMC.addChild(sprite);
			this.addChild(imgBgMC);
			this.addChild(imgMC);
		}

		function onOver(e: MouseEvent): void {

			imgMC.filters = [new GlowFilter(0xffffff, 1, 20, 20,2.5)];
		}

		function onOut(e: MouseEvent): void {
			imgMC.filters = null;
		}

		public function loadImage(pData: XMLList): void {
			imgPath = pData.imgpath;
			offsetX = int(pData.offsetx)*multiplier;
			offsetY = int(pData.offsety)*multiplier;
			imgW = int(pData.imgwidth)*multiplier;
			
			if (imgW > AppConst.SCREEN_WIDTH) {
				imgW = AppConst.SCREEN_WIDTH;
				offsetX = 0;
			}


			imgH = int(pData.imgheight)*multiplier;
			if (imgH > AppConst.SCREEN_HEIGHT) {
				imgH = AppConst.SCREEN_HEIGHT;
				offsetY = 0;
			}

			enableClick = pData.enableclick.toLowerCase() == "true";
			clickURL = pData.clickurl;
			trackingURL = pData.trackingurl;

			if (pData.enabletracking.length() > 0)
				_enableTrack = pData.enabletracking.toLowerCase() == "true";


			applyGlow = pData.gloweffect.toLowerCase() == "true";

			applyanim = pData.applyanim.toLowerCase() == "true";
			delayTimeAnim = int(pData.delaytime);
			effectType = pData.effecttype.toLowerCase();
			slideFrom = pData.slidefrom.toLowerCase();

			clearAndUnload();

			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgError, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
			imgLoader.load(new URLRequest(imgPath));
		}

		function imgLoaded(e: Event): void {
			/*imgLoader.width = imgW;
			imgLoader.height = imgH;
			imgLoader.x = offsetX;
			imgLoader.y = offsetY;*/
			

			bmp = imgLoader.content as Bitmap;
			bmp.smoothing=true;
			bmp.pixelSnapping= PixelSnapping.AUTO;	
			
			bmp.width = imgW;
			bmp.height = imgH;
			bmp.x = offsetX;
			bmp.y = offsetY;
			
			//imgMC.addChild(imgLoader);
			imgMC.addChild(bmp);	
			
			if (applyGlow) {
				imgMC.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				imgMC.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);
			}

			if (enableClick) {
				imgMC.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
				imgMC.buttonMode = true;
			}
			

			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);


			//if (applyanim) {
			//	this.visible = false; // hiding image before tweening
				doAnim();

			//}



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
			if (enableClick)
				navigateToURL(new URLRequest(clickURL));

			if (_enableTrack) {
				Pmi5Tracking.doTrack(trackingURL);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackingURL), true));
			}

		}

		public function doAnim(): void {
			if (applyanim) {
				this.visible = false;
				
				imgTimer = new Timer(delayTimeAnim, 1);
				imgTimer.addEventListener(TimerEvent.TIMER_COMPLETE, imgTimeComp, false, 0, true);
				imgTimer.stop();
				imgTimer.start();
				trace("img timer start");
			}

		}

		private function imgTimeComp(te: TimerEvent): void {
			imgTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, imgTimeComp);
			imgTimer = null;
			trace("img timer complete");
			try{
			delayAnim();
			}catch(e:Error)
			{
				trace("imageMC anim prob");
			}
		}

		private function delayAnim(): void {
			this.visible = true;
			if (effectType.toLowerCase() == "move") {
				doAnimation(slideFrom);
			} else {
				imgTween = new Tween(bmp, "alpha", Strong.easeOut, 0, 1, .5, true);
				imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
				imgTween.stop();
				imgTween.start();
			}
		}

		function doAnimation(pStr: String): void {
			switch (pStr) {

				case "right":
					imgTween = new Tween(bmp, "x", Strong.easeOut, (AppConst.SCREEN_WIDTH + bmp.width + 50), offsetX, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "top":
					imgTween = new Tween(bmp, "y", Strong.easeOut, (-imgH), offsetY, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "bottom":
					imgTween = new Tween(bmp, "y", Strong.easeOut, (AppConst.SCREEN_HEIGHT), offsetY, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;


				default:
					imgTween = new Tween(bmp, "x", Strong.easeOut, (-imgW * 1.5), offsetX, .5, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, tweenFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();

			}
		}

		function tweenFinish(et: TweenEvent): void {
			imgTween.removeEventListener(TweenEvent.MOTION_FINISH, tweenFinish);
			imgTween = null;
			//dispatchEvent(new Event(AppConst.EVENT_ANIM_COMP, true));

		}


		function imgError(er: IOErrorEvent): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			imgLoader = null;
		}



	} // class

} //pkg