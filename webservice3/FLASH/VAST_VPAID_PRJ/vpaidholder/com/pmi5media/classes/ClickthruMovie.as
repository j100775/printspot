package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import com.pmi5media.classes.IconsPmi5;
	import flash.filters.GlowFilter;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.events.ErrorEvent;
	import flash.display.Loader;
	import flash.display.PixelSnapping;


	public class ClickthruMovie extends MovieClip {

		private var _urlReq: String;
		public var toolTipHeight: int = 22;
		private var _clickXml: XMLList;
		private var _enableTrack: Boolean;
		private var enableClk: Boolean;
		private var _showAfter: int;
		private var _hideAfter: int;
		public var tipText: String = "";
		
		private var widgetType: String;
		private var widgetName: String = "false";
		private var fromX: int;
		private var fromY: int;
		private var imgW: int;
		private var imgH: int;

		private var toolWidth: int;
		private var toolHeight: int;
		private var toolX: int;
		private var toolY: int;
		private var toolbgColor: uint;
		private var toolLineColor: uint;
		private var tooltextColor: uint;

		var sp: Sprite = new Sprite()
		var txtBg: Shape = new Shape();

		var txtTooltip: TextField = new TextField();
		var txtTooltipFormat: TextFormat = new TextFormat();
		var toolTipFound: Boolean;
		var clickThLoader: Loader = new Loader();

		var showToolTip: Boolean;

		public function ClickthruMovie() {
			// constructor code

		}

		function createToolTips(): void {
			this.addChild(txtBg);
			this.setChildIndex(txtBg, numChildren - 1);

			txtTooltipFormat.size = 12;
			txtTooltipFormat.bold = true;
			txtTooltipFormat.color = tooltextColor;
			txtTooltipFormat.align = TextFormatAlign.LEFT;
			txtTooltip.width = toolWidth;
			txtTooltip.selectable = false;
			txtTooltip.defaultTextFormat = txtTooltipFormat;
			txtTooltip.x = 2;
			txtTooltip.y = 2;
			txtTooltip.multiline = true;
			txtTooltip.wordWrap = true;
			txtTooltip.visible = true;
			txtTooltip.autoSize = TextFieldAutoSize.CENTER;
			this.addChild(txtTooltip);
			this.setChildIndex(txtTooltip, numChildren - 1);

			toolTipFound = true;
		}

		function removeToolTip(): void {
			if (toolTipFound) {
				removeChild(txtBg);
				removeChild(txtTooltip);
				toolTipFound = false;
			}
		}

		function TooltipText(str: String): void {
			txtTooltip.text = str;
		}

		function drawBorder(pW: int, pH: int): void {
			txtBg.graphics.clear();
			txtBg.graphics.beginFill(toolbgColor, 1);
			txtBg.graphics.lineStyle(2, toolLineColor);
			txtBg.graphics.drawRoundRect(toolX, toolY, pW + 10, pH, 6, 6);
			txtBg.graphics.endFill();
		}

		public function urlReq(pXml: XMLList): void {
			widgetType = "";
			widgetName = "false";
			_enableTrack = false;
			_showAfter = 0;

			_hideAfter = 0;
			imgW = 32; // re set below if found
			imgH = 32; // re set below if found

			this._clickXml = pXml.trackingurl;
			this._urlReq = pXml.clickurl;




			fromX = pXml.fromleft;
			fromY = pXml.fromtop;

			this.x = fromX;
			this.y = fromY;

			if (pXml.enabletracking.length() > 0) {

				_enableTrack = pXml.enabletracking.toLowerCase() == "true";

			}

			if (pXml.enableclick.length() > 0)
				enableClk = pXml.enableclick.toLowerCase() == "true";

			if (enableClk) {
				this.addEventListener(MouseEvent.CLICK, clickURL, false, 0, true);
				this.buttonMode = true;
				this.useHandCursor = true;
			}

			if (pXml.showafter.length() > 0)
				_showAfter = pXml.showafter;

			if (pXml.hideafter.length() > 0)
				_hideAfter = pXml.hideafter;


			if (pXml.iconwidth.length() > 0)
				imgW = pXml.iconwidth;

			if (pXml.iconheight.length() > 0)
				imgH = pXml.iconheight;

			if (pXml.type.length() > 0)
				widgetType = pXml.type;

			if (pXml.widgetname.length() > 0)
				widgetName = pXml.widgetname;

			tipText = pXml.tooltip;
			toolWidth = pXml.tipwidth;
			toolHeight = pXml.tipheight;
			toolbgColor = pXml.tipbgcolor;
			toolLineColor = pXml.tiplinecolor;
			tooltextColor = pXml.tiptextcolor;

			toolX = pXml.tipoffsetx;
			toolY = pXml.tipoffsety;

			toolX = int(toolX) - int(fromX);
			toolY = int(toolY) - int(fromY);

			if (pXml.showtooltip.length() > 0){
				showToolTip = pXml.showtooltip.toLowerCase() == "true";
			}
			else
			{
				showToolTip = true;
			}

			if (showToolTip) {
				this.addEventListener(MouseEvent.MOUSE_OVER, onOver, false, 0, true);
				this.addEventListener(MouseEvent.MOUSE_OUT, onOut, false, 0, true);

			}

			addIconBg(pXml.iconno);
		}

		public function clickURL(evt: MouseEvent): void {
			if (enableClk) {
				if (widgetType == "widget") {
					dispatchEvent(new ClickThruEvent(ClickThruEvent.CLICK, widgetName, true));
					dispatchEvent(new Event(AppConst.EVENT_EXPAND, true));
					trace(" clickthru expnad");
				} else if (widgetType == "click") {
					widgetName = AppConst.AD_OPEN_CT_PAGE;
					dispatchEvent(new ClickThruEvent(ClickThruEvent.CLICK, widgetName, true));
					navigateToURL(new URLRequest(this._urlReq), "_blank");
				}

			}

			if (_enableTrack) {
				Pmi5Tracking.doTrack(_clickXml);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(_clickXml), true));
			}

		}

		public function showHide(pTime: int): void {
			//if (pTime == _showAfter) {
			//	this.visible = true;

			//}

			//if (pTime == _hideAfter) {
			//	this.visible = false;
			//	dispatchEvent(new ClickThruEvent(ClickThruEvent.HIDE, widgetName, true));
			//	//dispatch event here for hiding and removing the data of related modules  
			//}
			if (pTime >= _showAfter && pTime<= _hideAfter) {
				this.visible = true;
				//trace("intime- "+pTime);
			}

			if (pTime >= _hideAfter) {
				this.visible = false;
				dispatchEvent(new ClickThruEvent(ClickThruEvent.HIDE, widgetName, true));
				//dispatch event here for hiding and removing the data of related modules
			}
		}

		public function hideMe(): void {
			this.visible = false;
		}


		//apply glow on roll over
		function onOver(evt: MouseEvent): void {
			createToolTips();
			txtTooltip.width = toolWidth;
			TooltipText(tipText);
			txtTooltip.x = toolX + 6;
			txtTooltip.y = toolY + 6;
			txtTooltip.visible = true;
			drawBorder(toolWidth, toolHeight);

		}

		//remove glow on roll out
		function onOut(evt: MouseEvent): void {
			txtTooltip.width = 2;
			TooltipText("");
			txtTooltip.visible = false;
			txtBg.graphics.clear();
			removeToolTip();
		}

		//add image on background
		function addIconBg(pIcon: * ): void {
			clickThLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, clickImgComp, false, 0, true);
			clickThLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
			clickThLoader.load(new URLRequest(pIcon));
		}

		function clickImgComp(evt: Event): void {
			//clickThLoader.width = imgW;
			//clickThLoader.height = imgH;
			var bmpct:Bitmap = clickThLoader.content as Bitmap;
			bmpct.smoothing=true;
			bmpct.pixelSnapping=PixelSnapping.AUTO;
			bmpct.width = imgW;
			bmpct.height = imgH;
			this.addChild(bmpct);
			
			//this.addChild(clickThLoader);			
			clickThLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, clickImgComp);
			clickThLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}

		function ioErrorHandler(evt: ErrorEvent): void {
			clickThLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			clickThLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, clickImgComp);
			clickThLoader = null;
		}


	}
}