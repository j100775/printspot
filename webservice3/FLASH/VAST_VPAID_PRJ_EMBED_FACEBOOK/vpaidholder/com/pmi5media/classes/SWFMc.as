package com.pmi5media.classes {


	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.system.LoaderContext;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;


	public class SWFMc extends MovieClip {

		//swf
		private var swfLoader: Loader = new Loader();
		private var swfConMC: MovieClip;
		private var swfPath: String;

		private var offsetX: int;
		private var offsetY: int;
		private var timeLineFound: Boolean;


		public function SWFMc() {
			// constructor code
		}

		public function loadSWFData(pData: XMLList) {
			timeLineFound = false;
			swfPath = pData.path;
			offsetX = int(pData.offsetx)*AppConst.MULTIPLIER;
			offsetY = int(pData.offsety)*AppConst.MULTIPLIER;
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishLoading, false, 0, true);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, swfLoadingError, false, 0, true);
			swfLoader.load(new URLRequest(swfPath));

		}
		function finishLoading(loadEvent: Event): void {
			swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, finishLoading);
			swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, swfLoadingError);
			try {
				swfConMC = MovieClip(loadEvent.target.content);
				swfConMC.x = offsetX;
				swfConMC.y = offsetY;

				this.addChild(swfConMC);
				timeLineFound = true;
			} catch (e: Error) {
				trace("error msg=" + e.message.toString());
				this.addChild(swfLoader);
				timeLineFound = false;
			}


		}

		function swfLoadingError(errorEvent: Event): void {
			swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, finishLoading);
			swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, swfLoadingError);
			swfLoader = null;
		}

		public function resetSWF(): void {

			swfConMC.playOverlay();
		}

	} //class
} //pkg