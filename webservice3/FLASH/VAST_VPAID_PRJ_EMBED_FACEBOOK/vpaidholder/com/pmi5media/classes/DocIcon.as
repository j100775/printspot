package com.pmi5media.classes {
	import fl.transitions.*;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;

	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.display.PixelSnapping;


	public class DocIcon extends MovieClip {

		private var _docIconURL: String;
		private var xPosTween: Tween;
		private var _docTrackXml: XMLList;
		private var _enableTrack: Boolean;

		public function DocIcon() {
			// constructor code
			this.buttonMode = true;
			this.useHandCursor = true;
			this.addEventListener(MouseEvent.CLICK, docIconClick, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, iconOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, iconOut, false, 0, true);
		}

		public function crateDocIcon(pIconNo: int): void {
			//---create icons 
			var icBitmap: Bitmap;
			icBitmap = IconsPmi5.getIcon(pIconNo);
			icBitmap.width=AppConst.DOC_ICON_W;
			icBitmap.height=AppConst.DOC_ICON_H;
			addChild(icBitmap);
			this.name = "docicon_" + pIconNo;
		}

		public function docIconURL(pXml: XML): void {
			this._docTrackXml = pXml.trackingurl;
			this._docIconURL = pXml.iconurl;
			_enableTrack = false;
			if (pXml.enabletracking.length() > 0) {
				_enableTrack = pXml.enabletracking.toLowerCase() == "true";
			}
		}


		function docIconClick(evt: MouseEvent): void {
			navigateToURL(new URLRequest(_docIconURL), "_blank");
			if (_enableTrack) {
				Pmi5Tracking.doTrack(_docTrackXml);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(_docTrackXml), true));
			}
		}

		function iconOver(evt: MouseEvent): void {
			this.filters = [new GlowFilter(0xffffff, 1, this.width / 2, this.height / 2, 2)];
			this.y = this.y - 1;
			this.scaleY = 1.02;
		}

		function iconOut(evt: MouseEvent): void {
			this.filters = [];
			this.y = this.y + 1;
			this.scaleY = 1;
		}

	}

}