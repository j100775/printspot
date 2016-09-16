package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.text.TextFieldAutoSize;
	import flash.display.Shape;
	import flash.text.Font;
	import flash.text.TextFormatAlign;
	import flash.text.AntiAliasType;
	import flash.text.StyleSheet;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;


	public class TxtFieldMC extends MovieClip {

		private var txtBg: Shape = new Shape();
		private var bgW: int;
		private var abtXL: XMLList = new XMLList();
		private var maskShap: Shape = new Shape();
		private var upBtn: SimpleButton = new AbtUpBtn();
		private var downBtn: SimpleButton = new AbtDownBtn();


		private var objTxtFld: TextField = new TextField();
		private var objTxtFrmt: TextFormat = new TextFormat();
		private var isBackground: Boolean;

		public function TxtFieldMC() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addedtostg, false, 0, true);
		}

		private function addedtostg(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addedtostg);

			this.addChild(txtBg);



			objTxtFrmt.align = TextFormatAlign.LEFT;
			objTxtFrmt.leading = .5;
			objTxtFrmt.kerning = true;
			//objTxtFld.border = true;


			objTxtFld.defaultTextFormat = objTxtFrmt;
			objTxtFld.x = 100;
			objTxtFld.y = 150;
			objTxtFld.wordWrap = true;
			objTxtFld.multiline = true;
			objTxtFld.visible = true;
			objTxtFld.height = 100; // later set by xml data
			objTxtFld.width = 200; // later set by xml data
			objTxtFld.antiAliasType = AntiAliasType.ADVANCED;
			objTxtFld.condenseWhite = true;



			this.addChild(objTxtFld);
			upBtn.addEventListener(MouseEvent.MOUSE_DOWN, downScroll);


			downBtn.addEventListener(MouseEvent.MOUSE_DOWN, upScroll);


			this.addChild(upBtn);

			this.addChild(downBtn);
			this.addChild(maskShap);
		}

		function upScroll(e: MouseEvent): void {
			objTxtFld.scrollV++;
		}

		function downScroll(e: MouseEvent): void {
			objTxtFld.scrollV--;
		}

		function drawBg(pW: int): void {

			txtBg.graphics.clear();
			txtBg.graphics.beginFill(0x000000, .4);
			txtBg.graphics.drawRect(objTxtFld.x - 1, objTxtFld.y, (objTxtFld.width + AppConst.TEXT_DOWN_ARROW_W + 4), objTxtFld.height);
			txtBg.graphics.endFill();

		}

		function drawmask(): void {
			maskShap.graphics.clear();
			maskShap.graphics.beginFill(0xfff000, .5);
			maskShap.graphics.drawRect(objTxtFld.x - 1, objTxtFld.y, objTxtFld.width + 22, objTxtFld.height);
			maskShap.graphics.endFill();
		}


		public function loadData(pData: XMLList): void {
			isBackground = false;
			objTxtFrmt.size = pData.fontsize;
			objTxtFrmt.bold = pData.isbold.toLowerCase() == "true";
			objTxtFrmt.color = pData.fontcolor;

			objTxtFld.x = pData.offsetx;
			objTxtFld.y = pData.offsety;
			objTxtFld.width = pData.txtwidth;
			objTxtFld.height = pData.txtheight - 10;
			objTxtFld.selectable = false;
			objTxtFld.defaultTextFormat = objTxtFrmt;


			objTxtFld.htmlText = pData.desc;

			if (pData.showbackground.length() > 0) {
				isBackground = pData.showbackground.toLowerCase() == "true";
				if (isBackground)
					drawBg(objTxtFld.width);
			}

			upBtn.x = objTxtFld.x + objTxtFld.width + 2;
			upBtn.y = (objTxtFld.y + upBtn.height) - (upBtn.height - 1);

			downBtn.x = objTxtFld.x + objTxtFld.width + 2;
			downBtn.y = (objTxtFld.y + objTxtFld.height) - (downBtn.height + 1);

		}



	} //class

}