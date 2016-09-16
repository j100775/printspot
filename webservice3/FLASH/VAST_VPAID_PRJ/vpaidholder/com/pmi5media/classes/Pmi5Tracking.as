package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;


	public class Pmi5Tracking extends MovieClip {

		private static var tEnable: Boolean;
		private static var jsData: String = "";

		public function Pmi5Tracking() {
			// constructor code

		}

		public static function doTrack(pData: XMLList): void {
			for (var i: int = 0; i < pData.data.length(); i++) {
				tEnable = false;
				if ((pData.data[i].@enable.length() > 0)) {
					tEnable = pData.data[i].@enable.toLowerCase() == "true";
					if (tEnable) {

						if ((pData.data[i].@usefor.length() > 0)) {
							trace("");
						} else {
							var urlloader2: HitUrl = new HitUrl();
							urlloader2.loadUrldata(pData.data[i]);

						}
					}
				}
			}
		} //function




		public static function doShowTrack(pData: XMLList): void {
			for (var i: int = 0; i < pData.data.length(); i++) {
				tEnable = false;
				if ((pData.data[i].@enable.length() > 0)) {
					tEnable = pData.data[i].@enable.toLowerCase() == "true";
					if (tEnable) {
						if (pData.data[i].@mode.toString().toLowerCase() == "show") {

							if ((pData.data[i].@usefor.length() > 0)) {

							} else {
								var urlload: HitUrl = new HitUrl();
								urlload.loadUrldata(pData.data[i]);
							}

						}

					}
				}
			}

		}

		public static function getJSTrackData(pData: XMLList): String {

			jsData = "none,";

			for (var i: int = 0; i < pData.data.length(); i++) {
				tEnable = false;
				if ((pData.data[i].@enable.length() > 0)) {
					tEnable = pData.data[i].@enable.toLowerCase() == "true";
					if (tEnable) {

						if ((pData.data[i].@usefor.length() > 0)) {

							switch (pData.data[i].@usefor.toString()) {
								case "vid":
								case "VID":
								case "Vid":
									jsData = pData.data[i];
									break;

							}
						}

					}
				}
			}
			return jsData;
		} //function

	} //class
} //pkg