package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.text.Font;


	public class ToolTipMovie extends MovieClip {

		var txtBg: Shape = new Shape();

		var txtTooltip: TextField = new TextField();
		var txtTooltipFormat: TextFormat = new TextFormat();

		public function ToolTipMovie() {
			// constructor code
			createToolTips();
		}


		function drawBorder(pW: int): void {
			txtBg.graphics.clear();
			txtBg.graphics.beginFill(0x000000, .5);
			txtBg.graphics.lineStyle(2, 0xFFFFFF, 1);
			txtBg.graphics.drawRoundRect(-4, -4, pW + 10, 28, 6, 6);
			txtBg.graphics.endFill();
		}

		function createToolTips(): void {
			this.addChild(txtBg);

			txtTooltipFormat.size = 12;
			txtTooltipFormat.bold = true;
			txtTooltipFormat.color = 0xffffff;
			txtTooltipFormat.align = TextFormatAlign.LEFT;
			txtTooltip.height = 100;
			txtTooltip.defaultTextFormat = txtTooltipFormat;
			txtTooltip.x = 0;
			txtTooltip.y = 0;
			txtTooltip.wordWrap = false;
			txtTooltip.visible = true;
			txtTooltip.autoSize = TextFieldAutoSize.LEFT;
			this.addChild(txtTooltip);
		}


		public function TooltipText(str: String): void {
			txtTooltip.text = str;
			drawBorder(txtTooltip.width);
		}
	}

}