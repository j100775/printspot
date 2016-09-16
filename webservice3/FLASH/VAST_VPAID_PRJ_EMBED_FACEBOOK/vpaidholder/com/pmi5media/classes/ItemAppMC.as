package com.pmi5media.classes {

	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.display.MovieClip;
	import flash.events.Event;
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
	import com.pmi5media.classes.*;
	import flash.events.IOErrorEvent;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;




	public class ItemAppMC extends MovieClip {

		private var loader: URLLoader = new URLLoader();

		private var bgImgPath: String;
		private var overImgPath: String;
		private var imgW: int;
		private var imgH: int;

		private var offsetX: int;
		private var offsetY: int;

		private var widgettype: String;
		private var widgetname: String;


		private var applyanim: Boolean;
		private var effectType: String;
		private var slideFrom: String = "left";

		private var enableClick: Boolean;
		private var clickURL: String;
		private var trackingURL: XMLList;
		private var enableTracking: Boolean;

		private var smallImgLoader: Loader = new Loader();
		private var smallImgOverLoader: Loader = new Loader(); // over image loader

		private var overBgPicMC: Sprite = new Sprite(); // for small image which is background image of small landing image.
		private var overPicMC: Sprite = new Sprite();
		private var curShowing: String;

		public function ItemAppMC() {

			//trace("-- constructor --");
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC, false, 0, true);

		}

		function addedImgMC(E: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedImgMC);

			this.addChild(overBgPicMC);
			overPicMC.addEventListener(MouseEvent.MOUSE_OVER, onMenuOver, false, 0, true);
			overBgPicMC.addEventListener(MouseEvent.MOUSE_OUT, onMenuOut, false, 0, true);
			overBgPicMC.addEventListener(MouseEvent.CLICK, onSmallImgClick, false, 0, true);
			overBgPicMC.buttonMode = true;
			this.addChild(overPicMC);


		}




		public function loadItemApp(pData: XMLList): void {
			widgettype = pData.type;
			widgetname = pData.widgetname;
			bgImgPath = pData.bgimg;
			overImgPath = pData.overimg;
			imgW = int(pData.imgwidth)*AppConst.MULTIPLIER;
			imgH = int(pData.imgheight)*AppConst.MULTIPLIER;
			offsetX = int(pData.offsetx)*AppConst.MULTIPLIER;
			offsetY = int(pData.offsety)*AppConst.MULTIPLIER;

			enableClick = pData.enableclick.toLowerCase() == "true";
			clickURL = pData.clickurl;

			enableTracking = pData.enabletracking.toLowerCase() == "true";
			trackingURL = pData.trackingurl;

			smallImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler, false, 0, true);
			smallImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, smallImgLoadHandler, false, 0, true);
			smallImgLoader.load(new URLRequest(bgImgPath));
		}

		function smallImgErrHandler(er: ErrorEvent): void {
			smallImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler);
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, smallImgLoadHandler);
			smallImgLoader = null;
		}


		function smallImgLoadHandler(e: Event): void {
			//smallImgLoader.width = imgW;
			//smallImgLoader.height = imgH;

			//remove events
			smallImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, smallImgErrHandler);
			smallImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, smallImgLoadHandler);

			//over image
			smallImgOverLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, overImgError, false, 0, true);
			smallImgOverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, overImgLoaded, false, 0, true);
			smallImgOverLoader.load(new URLRequest(overImgPath));

		}


		function overImgLoaded(evt: Event): void {

			deleteAllChild(overBgPicMC);
			
			var bmp:Bitmap = smallImgLoader.content as Bitmap;
			bmp.smoothing=true;
			bmp.pixelSnapping = PixelSnapping.AUTO;
			bmp.width = imgW;
			bmp.height = imgH;
			bmp.x = offsetX;
			bmp.y = offsetY;
			
			//overBgPicMC.x = offsetX;
			//overBgPicMC.y = offsetY;
			overBgPicMC.addChild(bmp);
			
			
			overPicMC.x = overBgPicMC.x;
			overPicMC.y = overBgPicMC.y;
			
			//overBgPicMC.addChild(smallImgLoader);

			//smallImgOverLoader.width = imgW;
			//smallImgOverLoader.height = imgH;

			deleteAllChild(overPicMC);			
			var bmpover:Bitmap = smallImgOverLoader.content as Bitmap;
			bmpover.smoothing = true;
			bmpover.pixelSnapping = PixelSnapping.AUTO;
			bmpover.width = imgW;
			bmpover.height = imgH;
			bmpover.x = offsetX;
			bmpover.y = offsetY;
			
			overPicMC.addChild(bmpover);
			//overPicMC.addChild(smallImgOverLoader);			

			//over image event
			smallImgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			smallImgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);

			
		}

		function deleteAllChild(obj: * ): void {
			for (var i: int = obj.numChildren - 1; i >= 0; i--) {
				obj.removeChildAt(i);
			}
		}



		function overImgError(er: ErrorEvent): void {
			smallImgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			smallImgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);
			smallImgOverLoader = null;

		}


		//  small lanuching image
		function onSmallImgClick(e: MouseEvent): void {
			if (widgettype == "widget") {
				dispatchEvent(new MenuItemEvent(MenuItemEvent.ITEM_CLICK, widgetname, true));

			} else if (widgettype == "click") {
				openClientPage();
			}

			if (enableTracking) {
				Pmi5Tracking.doTrack(trackingURL);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackingURL), true));
			}

		}

		function openClientPage(): void {
			if (enableClick)
				navigateToURL(new URLRequest(clickURL));
		}


		function onMenuOver(e: MouseEvent): void {
			showItemBgImg();
		}

		function showItemBgImg(): void {
			overPicMC.visible = false;
		}

		function onMenuOut(e: MouseEvent): void {
			if (curShowing == this.name) {
				///trace("menu if curShowing="+curShowing + " this.name="+this.name);
			} else {
				overPicMC.visible = true;
			}
		}

		public function setCurMenu(pStr: String): void {
			if (this.name == pStr) {
				showItemBgImg();
			} else {
				overPicMC.visible = true;
			}
			curShowing = pStr;
		}

		public function resetOver():void{
			overPicMC.visible = true;
		}

	} //class

} //pkg