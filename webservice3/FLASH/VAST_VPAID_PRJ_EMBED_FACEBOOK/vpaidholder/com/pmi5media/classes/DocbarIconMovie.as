package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.geom.ColorTransform;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import com.pmi5media.classes.DocIcon;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import flash.utils.setTimeout;
	import flash.display.PixelSnapping;



	public class DocbarIconMovie extends MovieClip {

		var xInitPos: int = 0;
		var xInitPos2: int = 0;
		var xOffSet: int = 0;
		var totW: int = 0;
		var objColor: ColorTransform = new ColorTransform();

		var my_square: Shape = new Shape();
		var my_color: ColorTransform = new ColorTransform();
		var docShadow: Shape = new Shape();
		var ColorBackground: Shape = new Shape();

		var totHight: int;
		var beforeScaleHeight: int;
		var outerIconH: int;

		var outerLIneSize: int = 2;


		var iconsList: XMLList = new XMLList();
		var iconsListLen: int = 0;

		var docYPos: int;
		var actYPos: int;

		var docAlignment: String;
		var hideBar: Boolean; // for show/hide the color background and icon's shadow bar
		var barOpacity: int = 0;
		var colorBg: String;
		var barScaleIcons: int = 25; /// range 25 - 200%
		var compBgBar: Sprite = new Sprite();
		var yPosTween: Tween;
		private var _showAfter: int;
		private var _hideAfter: int;

		public function DocbarIconMovie() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage);

		}

		public function addedToStage(evt: Event): void {
			objColor.color = 0xFF0000;
		}

		var widthAfterScale: Number;

		public function addDocIconsBar(pXmlList: XMLList): void {
			_showAfter = 0;
			_hideAfter = 0;
			//--- SETTING BAR PROPERTIES
			docAlignment = pXmlList.docalignment;
			barScaleIcons = pXmlList.scaleicons;

			//opacity
			barOpacity = pXmlList.opacity;

			//bar visibility
			hideBar = pXmlList.hidebackground.toLowerCase() == "true"; // check true/false from xml data

			//custom visibility
			if (pXmlList.showafter.length() > 0)
				_showAfter = pXmlList.showafter;
			if (pXmlList.hideafter.length() > 0)
				_hideAfter = pXmlList.hideafter;

			// CHANGE COLOR
			objColor.color = pXmlList.bgcolor;

			iconsList = null;
			iconsListLen = 0;
			iconsList = pXmlList..docicon; // fetch total doc icon
			iconsListLen = iconsList.length();

			var iconShadowBar: Sprite = new Sprite();
			var iconBar: Sprite = new Sprite();

			for (var i: int = 0; i < iconsListLen; i++) {

				//---create doc icons 
				var iconDoc: MovieClip = new DocIcon();
				iconDoc.crateDocIcon(iconsList[i].iconno);
				iconDoc.docIconURL(iconsList[i]);
				iconDoc.name = iconsList[i].tooltip;
				xOffSet = iconDoc.width / 4;
				iconDoc.x = xInitPos + xOffSet;

				if (hideBar) // background is hide
				{
					outerIconH = iconDoc.height * 0.40;
					if (docAlignment == "left" && i == 0) {

						xInitPos = 0;
						xOffSet = 0;
						iconDoc.x = 0;
					}
				} else {
					outerIconH = iconDoc.height * 0.50;
				}

				iconDoc.y = -outerIconH;
				iconBar.addChild(iconDoc);
				// added doc icon to bar;

				totHight = iconDoc.height;
				xInitPos += (iconDoc.width + xOffSet);
				totW += (iconDoc.width + xOffSet);

				if (!hideBar) {

					var icBitmap2: Bitmap;
					icBitmap2 = IconsPmi5.getShadowIcon(iconsList[i].iconno);
					icBitmap2.x = xInitPos2 + xOffSet;
					icBitmap2.y = (AppConst.DOC_ICON_H/2) - 1;
					icBitmap2.width=AppConst.DOC_ICON_W;
					icBitmap2.height=AppConst.DOC_ICON_H/2
					icBitmap2.alpha = .5;
					iconShadowBar.addChild(icBitmap2);
					// get icon from IconsPMI5 class;
					xInitPos2 += (icBitmap2.width + xOffSet);
				}

			}

			if (!hideBar) {
				ColorBackground.graphics.beginFill(objColor.color, 1);
				ColorBackground.graphics.lineStyle(outerLIneSize, 0x454444, 1);
				ColorBackground.graphics.drawRoundRect(0, 0, (totW + xOffSet), (totHight), 10, 10);
				ColorBackground.graphics.endFill();

				compBgBar.addChild(ColorBackground);
				// add color background;
				compBgBar.addChild(iconShadowBar);
				this.addChild(compBgBar);

			}


			this.addChild(iconBar);
			// add icons bar 

			beforeScaleHeight = this.height;
			var percentScaleH: Number = beforeScaleHeight / 100;
			var perScaleW: Number = this.width / 100;

			if (barScaleIcons <= 25) {
				barScaleIcons = 25;
			} else if (barScaleIcons >= 200) {
				barScaleIcons = 200;
			}


			this.height = percentScaleH * barScaleIcons;
			widthAfterScale = perScaleW * barScaleIcons;

			if (widthAfterScale >= AppConst.SCREEN_WIDTH) {
				this.width = AppConst.SCREEN_WIDTH;
			} else {
				this.width = widthAfterScale;
			}

			//setting position
			setDocAlign(docAlignment);

			//set opacity
			this.alpha = barOpacity / 100;
			animateDocBar();
			dispatchEvent(new Event("docbarcreated", true));
		}


		function animateDocBar(): void {
			actYPos = AppConst.SCREEN_HEIGHT - (this.height * .64);
			this.visible = true;
			yPosTween = new Tween(this, "y", Strong.easeOut, (AppConst.SCREEN_HEIGHT + this.height), actYPos, 1, true);

		}

		//-----------for show / hide on the basis of video timings
		public function showHide(pTime: int): void {
			trace("--docicon time = " + pTime);
			if (pTime == _showAfter) {
				this.visible = true;
				animateDocBar();
			}

			if (pTime == _hideAfter) {
				this.visible = false;
			}
		}

		//set x and y position of doc icon bar
		function setDocAlign(pData: String): void {
			docYPos = this.height;
			switch (pData.toLowerCase()) {
				case "middle":
					this.x = AppConst.SCREEN_WIDTH / 2 - (this.width * 0.50);
					this.y = docYPos;
					break;
				case "right":
					this.x = AppConst.SCREEN_WIDTH - (this.width);
					this.y = docYPos;
					break;
				default:
					this.x = 1;
					this.y = docYPos;
					break;
			}

		}

	}

}