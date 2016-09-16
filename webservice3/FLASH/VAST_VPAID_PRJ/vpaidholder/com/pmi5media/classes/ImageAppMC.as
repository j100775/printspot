package com.pmi5media.classes {

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.display.Sprite;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.pmi5media.classes.AppConst;
	import com.pmi5media.classes.Pmi5Tracking;
	import fl.controls.ProgressBar;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import fl.controls.ProgressBarMode;
	import flash.system.LoaderContext;
	import flash.system.ApplicationDomain;
	import flash.system.SecurityDomain;
	import flash.display.PixelSnapping;
	import flash.display.Bitmap;


	public class ImageAppMC extends MovieClip {

		private var loader: URLLoader = new URLLoader();

		private var bgImgPath: String;
		private var overImgPath: String;
		private var imgW: int;
		private var imgH: int;

		private var offsetX: int;
		private var offsetY: int;

		private var openGal: Boolean;
		private var openGalOnOver: Boolean;
		private var applyGlow: Boolean;
		private var applyanim: Boolean;
		private var effectType: String;
		private var slideFrom: String = "left";

		private var enableClick: Boolean;
		private var clickURL: String;
		private var trackingURL: XMLList;


		private var smallImgLoader: Loader = new Loader();
		private var smallImgOverLoader: Loader = new Loader(); // over image loader

		private var overBgPicMC: Sprite = new Sprite(); // for small image which is background image of small landing image.
		private var overPicMC: Sprite = new Sprite();

		private var imgTween: Tween;
		private var overImgTween: Tween;
		private var hideTween: Tween;

		private var objCrossBtn: MovieClip;
		private var showCroosbtn: Boolean;
		private var alignCrossbtn: String = "topright";

		private var repeater: Number = 1;
		private var expandAfter: Number;
		private var welPB: ProgressBar = new ProgressBar();
		private var pbt: Timer;

		private var objSWFMC: MovieClip = new SWFMc();
		private var overlayType: String;

		public function ImageAppMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC);
		}

		function addedImgMC(E: Event): void {

			this.addChild(objSWFMC);
			objSWFMC.addEventListener(AppConst.overlayExpand, overlayExp, false, 0, true);
			objSWFMC.visible = false;
			objSWFMC.buttonMode = true;

			this.addChild(overBgPicMC);

			overPicMC.addEventListener(MouseEvent.MOUSE_OVER, onImgOver, false, 0, true);
			overPicMC.addEventListener(MouseEvent.MOUSE_OUT, onImgOut, false, 0, true);
			overPicMC.addEventListener(MouseEvent.CLICK, onSmallImgClick, false, 0, true);
			overPicMC.buttonMode = true;
			this.addChild(overPicMC);

			welPB.indeterminate = false;
			welPB.mode = ProgressBarMode.MANUAL;
			welPB.visible = false;
			this.addChild(welPB);
		}


		public function loadImageApp(pData: XMLList): void {
			openGal = pData.opengallery.toLowerCase() == "true";
			openGalOnOver = pData.openonover.toLowerCase() == "true";
			showCroosbtn = pData.showcrossbtn.toLowerCase() == "true";
			alignCrossbtn = pData.aligncrossbtn;
			offsetX = pData.offsetx;
			offsetY = pData.offsety;
			trackingURL = pData.trackingurl;

			if (pData.expandafter.length() > 0) {
				expandAfter = pData.expandafter;
				pbt = new Timer(10, (expandAfter / 20));
				pbt.addEventListener(TimerEvent.TIMER, timerHandler);
				pbt.addEventListener(TimerEvent.TIMER_COMPLETE, timerComp);
			}

			overlayType = pData.overlaytype;


			switch (overlayType) {
				case AppConst.OVERLAY_SWF:
					objSWFMC.visible = true;
					objSWFMC.loadSWFData(pData);
					break;
				case AppConst.OVERLAY_IMAGE:
					bgImgPath = pData.bgimg;
					overImgPath = pData.overimg;
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

					applyGlow = pData.gloweffect.toLowerCase() == "true";

					applyanim = pData.applyanim.toLowerCase() == "true";
					effectType = pData.effecttype.toLowerCase();
					slideFrom = pData.slidefrom.toLowerCase();

					//trace("bgimgPath="+ bgImgPath+ " overImg="+ overImgPath + " applyGlow=" + applyGlow + " openGal="+openGal);
					smallImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler, false, 0, true);
					smallImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, smallImgLoadHandler, false, 0, true);
					smallImgLoader.load(new URLRequest(bgImgPath));

					break;

			} //switch



		}


		function timerHandler(event: TimerEvent): void {
			welPB.setProgress(welPB.value + 20, welPB.maximum);
			trace("time=" + event.currentTarget.currentCount);
			trace("repeatCount=" + event.currentTarget.repeatCount);
		}

		function smallImgErrHandler(er: ErrorEvent): void {
			smallImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler);
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, smallImgLoadHandler);
			smallImgLoader = null;
		}


		function smallImgLoadHandler(e: Event): void {
			smallImgLoader.width = imgW;
			smallImgLoader.height = imgH;

			//remove events
			smallImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler);
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, smallImgLoadHandler);

			//over image
			smallImgOverLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, overImgError, false, 0, true);
			smallImgOverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, overImgLoaded, false, 0, true);
			smallImgOverLoader.load(new URLRequest(overImgPath));

		}

		function onImgOver(e: MouseEvent): void {
			if (applyGlow) {
				overBgPicMC.filters = [new GlowFilter(0xffffff, 1, 10, 10, 2.5)];
			}
			if (openGal) {
				if (openGalOnOver) {
					//openMinisite();//openGallery();
					pbt.stop();
					pbt.reset();
					pbt.start();
					welPB.visible = true;
				}
			}

		}

		function timerComp(e: TimerEvent): void {
			openMinisite();
		}

		function onImgOut(e: MouseEvent): void {
			if (applyGlow) {
				overBgPicMC.filters = null;
			}
			if (openGalOnOver) {
				pbt.stop();
				pbt.reset();
				welPB.setProgress(0, welPB.maximum);
				welPB.visible = false;
			}
		}

		function overImgLoaded(evt: Event): void {
			
			trace("overimage loaded");
			var smallImgLoaderBmp:Bitmap = smallImgLoader.content as Bitmap;
			smallImgLoaderBmp.smoothing=true;
			smallImgLoaderBmp.pixelSnapping = PixelSnapping.AUTO;
			overBgPicMC.addChild(smallImgLoaderBmp);
			//overBgPicMC.addChild(smallImgLoader);
			smallImgLoaderBmp.width = imgW;
			smallImgLoaderBmp.height = imgH;
			
			smallImgOverLoader.width = imgW;
			smallImgOverLoader.height = imgH;

			deleteAllChild(overPicMC);
			
			var sioBmp:Bitmap = smallImgOverLoader.content as Bitmap;
			sioBmp.smoothing=true;
			sioBmp.pixelSnapping=PixelSnapping.AUTO;
			sioBmp.width = imgW;
			sioBmp.height = imgH;
			overPicMC.addChild(sioBmp);
			
			//overPicMC.addChild(smallImgOverLoader);
			overPicMC.alpha = 0;

			//over image event
			smallImgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			smallImgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);

			welPB.maximum = expandAfter;
			welPB.setSize((imgW * .98), imgW * .015);
			welPB.move(offsetX + (imgW * .01), offsetY + (imgH * .90));
			adCrossBtn();

			doImageAppAnim();
			Pmi5Tracking.doShowTrack(trackingURL);

			
			this.setChildIndex(welPB, numChildren - 1);
		}

		function adCrossBtn(): void {
			objCrossBtn = new CrossBtnMC();
			objCrossBtn.name = "crossbtn";
			objCrossBtn.addEventListener(MouseEvent.CLICK, crossClicked, false, 0, true);
			this.addChild(objCrossBtn);
			objCrossBtn.visible = false;
		}

		function crossClicked(e: MouseEvent): void {
			trace("Cross Clicked");
			//Pmi5Tracking.doCrossBtnTrack(trackingURL);
			dispatchEvent(new Event(AppConst.EVENT_CROSSBTN_CLICK, true));

		}

		function deleteAllChild(obj: * ): void {
			for (var i: int = obj.numChildren - 1; i >= 0; i--) {
				obj.removeChildAt(i);
			}
		}

		public function doImageAppAnim(): void {

			if (overlayType == AppConst.OVERLAY_IMAGE) {
				doSmallImgAni(slideFrom);
			} else if (AppConst.OVERLAY_SWF) {
				objSWFMC.visible = true;
				objSWFMC.resetSWF();
			}

			Pmi5Tracking.doShowTrack(trackingURL);
		}

		function doSmallImgAni(pStr: String): void {
			overBgPicMC.alpha = 1;
			this.visible = true;
			switch (pStr) {


				case "right":
					overBgPicMC.x = 100;
					overBgPicMC.y = offsetY;
					imgTween = new Tween(overBgPicMC, "x", Strong.easeOut, (AppConst.SCREEN_WIDTH + overBgPicMC.width + 50), offsetX, 1, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, onFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "top":
					overBgPicMC.x = offsetX;
					overBgPicMC.y = 100;
					imgTween = new Tween(overBgPicMC, "y", Strong.easeOut, (-imgH), offsetY, 1, true);
					//imgTween = new Tween(overBgPicMC, "y", Strong.easeOut, (-overBgPicMC.height+(overBgPicMC.height*.5)),offsetY, 1, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, onFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				case "bottom":
					//trace("h="+this.height);
					overBgPicMC.x = offsetX;
					overBgPicMC.y = 100;
					imgTween = new Tween(overBgPicMC, "y", Strong.easeOut, (AppConst.SCREEN_HEIGHT), offsetY, 1, true);
					//imgTween = new Tween(overBgPicMC, "y", Strong.easeOut, this.height,(this.height-(overBgPicMC.height+offsetY)), 1, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, onFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

				default:
					overBgPicMC.x = 100;
					overBgPicMC.y = offsetY;
					imgTween = new Tween(overBgPicMC, "x", Strong.easeOut, (-imgW * 1.5), offsetX, 1, true);
					imgTween.addEventListener(TweenEvent.MOTION_FINISH, onFinish, false, 0, true);
					imgTween.stop();
					imgTween.start();
					break;

			}


		}



		function onFinish(e: TweenEvent): void {
			imgTween.removeEventListener(TweenEvent.MOTION_FINISH, onFinish);
			imgTween = null;

			overPicMC.x = overBgPicMC.x;
			overPicMC.y = overBgPicMC.y;
			overPicMC.visible = true;

			//set cross btn position
			setCrossBtn(alignCrossbtn);


			overImgTween = new Tween(overPicMC, "alpha", Strong.easeOut, 0, 1, .5, true);
			overImgTween.addEventListener(TweenEvent.MOTION_FINISH, onOverFinish, false, 0, true);
			overImgTween.stop();
			overImgTween.start();

		}
		function setCrossBtn(str: String): void {
			//str="topright";
			switch (str) {
				case "topright":
					objCrossBtn.x = (overPicMC.x + overPicMC.width) - objCrossBtn.width;
					objCrossBtn.y = overPicMC.y;
					break;
				case "bottomright":
					objCrossBtn.x = (overPicMC.x + overPicMC.width) - objCrossBtn.width;
					objCrossBtn.y = (overPicMC.y + overPicMC.height) - objCrossBtn.height;
					break;
				case "bottomleft":
					objCrossBtn.x = overPicMC.x;
					objCrossBtn.y = (overPicMC.y + overPicMC.height) - objCrossBtn.height;
					break;
				default:
					objCrossBtn.x = overPicMC.x;
					objCrossBtn.y = overPicMC.y;
					break;
			}
			if (showCroosbtn)
				objCrossBtn.visible = true;
		}

		function onOverFinish(e: TweenEvent): void {
			overImgTween.removeEventListener(TweenEvent.MOTION_FINISH, onOverFinish);
			overImgTween = null;
		}

		function overImgError(er: ErrorEvent): void {
			smallImgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			smallImgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);
			smallImgOverLoader = null;

			//campError();

		}
		private function openGallery(): void {

			if (overlayType == AppConst.OVERLAY_IMAGE) {
				overPicMC.visible = false;
				objCrossBtn.visible = false;
				hideTween = new Tween(overBgPicMC, "alpha", Strong.easeIn, 1, 0, .2, true);
				hideTween.addEventListener(TweenEvent.MOTION_FINISH, hideLandingImg, false, 0, true);
				hideTween.stop();
				hideTween.start();
			} else if (overlayType == AppConst.OVERLAY_SWF) {
				dispatchEvent(new Event(AppConst.EVENT_IMGAPP_SHOW, true));
				objSWFMC.visible = false;
			}
		}

		function onSWFClick(e: MouseEvent): void {
			if (!openGalOnOver)
				openMinisite();
		}

		function overlayExp(e: Event): void {
			if (!openGalOnOver)
				openMinisite();
		}

		//  small lanuching image
		function onSmallImgClick(e: MouseEvent): void {
			if (!openGalOnOver)
				openMinisite();

		}

		function openMinisite(): void {
			dispatchEvent(new Event(AppConst.EVENT_EXPAND, true));
			Pmi5Tracking.doTrack(trackingURL);
			openGallery();
		}

		function hideLandingImg(e: TweenEvent): void {
			trace("hidelandingimg--/n");
			overPicMC.visible = false;
			overPicMC.alpha = 0;
			this.visible = false;
			hideTween.removeEventListener(TweenEvent.MOTION_FINISH, hideLandingImg);
			hideTween = null;
			dispatchEvent(new Event(AppConst.EVENT_IMGAPP_SHOW, true));
		}

	} //class
} //pkg