package com.pmi5media.classes {
	import flash.net.URLLoader;
	import flash.events.Event;
	import flash.events.SecurityErrorEvent;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	import flash.events.IEventDispatcher;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.MovieClip;


	public class HitUrl extends MovieClip {

		private var loader: URLLoader = new URLLoader();
		private var lc: LoaderContext = new LoaderContext(true);

		public function HitUrl() {
			// constructor code
			configureListeners(loader);
		}

		public function loadUrldata(str: String): void {
			try {
				trace("----------------------------->HitURLtext=" + str + "\n");
				loader.load(new URLRequest(str));
			} catch (error: Error) {

			}

		}


		function configureListeners(dispatcher: IEventDispatcher): void {
			// trace("configureListener done");
			dispatcher.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
			dispatcher.addEventListener(Event.OPEN, openHandler);
			// dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
		}

		function completeHandler(event: Event): void {
			trace("-->>completeHandler: ");
		}

		function openHandler(event: Event): void {
			trace("-->>openHandler: ");
		}

		/*  function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }*/

		function securityErrorHandler(event: SecurityErrorEvent): void {
			// trace("-->>securityErrorHandler: " + event);
		}

		function httpStatusHandler(event: HTTPStatusEvent): void {
			// trace("-->>httpStatusHandler: " + event.status);
		}

		function ioErrorHandler(event: IOErrorEvent): void {
			//  trace("-->>ioErrorHandler: " + event.text);
		}

		//------------------	

	} //class
}