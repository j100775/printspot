package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;



	public class NextBtnNewMC extends MovieClip {

		var NextBtnLoader: Loader = new Loader();
		
		public function NextBtnNewMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			this.buttonMode = true;
			this.visible = false;
			this.addEventListener(MouseEvent.CLICK, nextClick, false, 0, true);
		}

		function nextClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_NEXT_CLICK, true));
		}
		public function loadNextBtnImg(path: String): void {
			try {
				if ((path.length > 0) && (path != "default")) {
					deleteAllChild();
					//load next button
					NextBtnLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadNextComp, false, 0, true);
					NextBtnLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
					NextBtnLoader.load(new URLRequest(path));
				} else {
					defNextImg();
				}
			} catch (e: Error) {
				trace("next img error - ");
				defNextImg();

			}
		}


		function loadNextComp(evt: Event): void {
			/*NextBtnLoader.width = AppConst.NEXT_BTN_W;
			NextBtnLoader.height = AppConst.NEXT_BTN_H;
			NextBtnLoader.x = AppConst.SCREEN_WIDTH - (AppConst.NEXT_BTN_W);
			NextBtnLoader.y = AppConst.SCREEN_HEIGHT / 2 - AppConst.NEXT_BTN_H / 2;
			this.addChild(NextBtnLoader);*/

			
			var bmpNextBtn:Bitmap = NextBtnLoader.content as Bitmap;
			bmpNextBtn.smoothing=true;
			bmpNextBtn.pixelSnapping=PixelSnapping.AUTO;
			bmpNextBtn.width = AppConst.NEXT_BTN_W;
			bmpNextBtn.height = AppConst.NEXT_BTN_H;
			bmpNextBtn.x = AppConst.SCREEN_WIDTH - (AppConst.NEXT_BTN_W);
			bmpNextBtn.y = AppConst.SCREEN_HEIGHT / 2 - AppConst.NEXT_BTN_H / 2;
			this.addChild(bmpNextBtn);
			
			
			

			NextBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadNextComp);
			NextBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			dispatchEvent(new Event("nextbtnloaded", true));
		}

		function ioErrorHandler(evt: ErrorEvent): void {
			NextBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			NextBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadNextComp);
			NextBtnLoader = null;
			defNextImg();
		}
		function deleteAllChild(): void {
			for (var i: int = this.numChildren - 1; i >= 0; i--) {
				this.removeChildAt(i);
			}
		}

		function defNextImg(): void {
			var bmpNext: Bitmap = IconsPmi5.getNextBtnIcon();
			bmpNext.width = AppConst.NEXT_BTN_W;
			bmpNext.height = AppConst.NEXT_BTN_H;
			bmpNext.x = AppConst.SCREEN_WIDTH - (AppConst.NEXT_BTN_W);
			bmpNext.y = AppConst.SCREEN_HEIGHT / 2 - AppConst.NEXT_BTN_H / 2;
			this.addChild(bmpNext);
			dispatchEvent(new Event("nextbtnloaded", true));
		}
	}

}