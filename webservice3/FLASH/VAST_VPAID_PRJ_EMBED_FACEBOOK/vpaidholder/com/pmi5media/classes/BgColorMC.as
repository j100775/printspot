package com.pmi5media.classes {
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.geom.ColorTransform;
	import flash.events.Event;
	
	
	public class BgColorMC extends MovieClip {
		
		
		private var shapeBG:Shape = new Shape();
		private var objBgColor:ColorTransform = new ColorTransform();
		
		public function BgColorMC() {
			// constructor code
			
		}

		public function drawModuleBg(pData:XMLList):void
		{
			objBgColor.color=pData.color;
			drawBg();			
		}
		
		function drawBg():void
		{
			shapeBG.graphics.clear();
			shapeBG.graphics.beginFill(objBgColor.color,1);
			shapeBG.graphics.drawRect(0,0,AppConst.SCREEN_WIDTH,AppConst.SCREEN_HEIGHT);
			shapeBG.graphics.endFill();
			addChild(shapeBG);
		}
	}
	
}
