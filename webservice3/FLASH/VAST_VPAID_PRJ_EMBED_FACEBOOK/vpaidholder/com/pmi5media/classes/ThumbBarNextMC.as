package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;


	public class ThumbBarNextMC extends MovieClip {


		public function ThumbBarNextMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);

			var bmpNext: Bitmap = IconsPmi5.getThumbNextBtnIcon();
			bmpNext.width=AppConst.TBAR_NEXT_W;
			bmpNext.height=AppConst.TBAR_NEXT_H;
			bmpNext.smoothing=true;
			bmpNext.pixelSnapping=PixelSnapping.AUTO;
			this.addChild(bmpNext);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, tbNextClick, false, 0, true);
			this.name = "thumbNextBtn";

		}

		function tbNextClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_TBAR_NEXT_CLK, true));
		}

	} //class

}