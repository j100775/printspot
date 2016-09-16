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


	public class ImgView360GalleryMC extends MovieClip {

		private var imgLoader: Loader = new Loader();
		private var lc: LoaderContext = new LoaderContext();
		private var xmlList: XMLList = new XMLList();
		private var imgPath: String;

		private var imgBgMC: MovieClip = new MovieClip();
		private var imgMC: MovieClip = new MovieClip();
		private var loader: URLLoader = new URLLoader();


		public function ImgView360GalleryMC() {
			addEventListener(Event.ADDED_TO_STAGE, addedImgMC, false, 0, true);
		}

		function addedImgMC(E: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedImgMC);
			this.addChild(imgBgMC);
			this.addChild(imgMC);
			lc.checkPolicyFile = false;
		}


		public function loadImage(pData: XMLList): void {
			imgPath = pData.imgpath;
			clearAndUnload();
			imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgError, false, 0, true);
			imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
			imgLoader.load(new URLRequest(imgPath), lc);
		}

		function imgLoaded(e: Event): void {
			imgLoader.width = AppConst.SCREEN_WIDTH;
			imgLoader.height = AppConst.SCREEN_HEIGHT;
			imgLoader.x = 0;
			imgLoader.y = 0;

			imgMC.addChild(imgLoader);
			this.addChild(imgMC);

			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);

			setImaage()
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

			dispatchEvent(new Event(AppConst.EVENT_ANIM_COMP, true));

		}

		public function clearAndUnload(): void {
			imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgError);
			imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
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
			//dispatchEvent(new Event("campaignerror",true));
			imgLoader = null;

		}


	} // class

}