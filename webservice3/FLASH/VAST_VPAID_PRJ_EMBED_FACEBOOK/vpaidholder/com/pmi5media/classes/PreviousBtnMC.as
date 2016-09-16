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



	public class PreviousBtnMC extends MovieClip {

		var prvBtnLoader: Loader = new Loader();

		public function PreviousBtnMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedtostg, false, 0, true);
		}

		private function addedtostg(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, addedtostg);
			this.buttonMode = true;
			this.visible = false;
			addEventListener(MouseEvent.CLICK, prvClick, false, 0, true);
		}

		function prvClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_PREVIOUS_CLICK, true));
		}

		public function loadPrvBtnImg(path: String): void {
			try {
				//load previous button
				if ((path.length > 0) && (path != "default")) {
					deleteAllChild();
					prvBtnLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComp, false, 0, true);
					prvBtnLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
					prvBtnLoader.load(new URLRequest(path));
				} else {
					addDefPrvBtn();
				}
			} catch (e: Error) {
				trace("error prv imgae - default img loaded");
				addDefPrvBtn();
			}
		}

		function loadComp(evt: Event): void {
			/*prvBtnLoader.width = AppConst.PRV_BTN_W;
			prvBtnLoader.height = AppConst.PRV_BTN_H;
			prvBtnLoader.x = 0;
			prvBtnLoader.y = AppConst.SCREEN_HEIGHT / 2 - (AppConst.PRV_BTN_H / 2);*/

			
			var bmpPrvBtn:Bitmap = prvBtnLoader.content as Bitmap;
			bmpPrvBtn.width = AppConst.PRV_BTN_W;
			bmpPrvBtn.height = AppConst.PRV_BTN_H;
			bmpPrvBtn.x = 0;
			bmpPrvBtn.y = AppConst.SCREEN_HEIGHT / 2 - (AppConst.PRV_BTN_H / 2);
			bmpPrvBtn.smoothing=true;
			bmpPrvBtn.pixelSnapping = PixelSnapping.AUTO;
			this.addChild(bmpPrvBtn);
			//this.addChild(prvBtnLoader);
			
			prvBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComp);
			prvBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			dispatchEvent(new Event("prvbtnloaded", true));
		}

		function ioErrorHandler(evt: ErrorEvent): void {
			prvBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadComp);
			prvBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			prvBtnLoader = null;
			addDefPrvBtn();
		}
		function addDefPrvBtn(): void {
			var bmpPrvBtn: Bitmap = IconsPmi5.getPrvBtnIcon();
			bmpPrvBtn.width = AppConst.PRV_BTN_W;
			bmpPrvBtn.height = AppConst.PRV_BTN_H;
			bmpPrvBtn.x = 0;
			bmpPrvBtn.y = AppConst.SCREEN_HEIGHT / 2 - (AppConst.PRV_BTN_H / 2);

			this.addChild(bmpPrvBtn);
			dispatchEvent(new Event("prvbtnloaded", true));
		}

		function deleteAllChild(): void {
			for (var i: int = this.numChildren - 1; i >= 0; i--) {
				this.removeChildAt(i);
			}
		}

	}

}