package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.display.PixelSnapping;


	public class ThumbBarPrvMC extends MovieClip {


		public function ThumbBarPrvMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}
		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);

			var bmpPrv: Bitmap = IconsPmi5.getThumbPrvBtnIcon();
			bmpPrv.width=AppConst.TBAR_NEXT_W;
			bmpPrv.height=AppConst.TBAR_NEXT_H;
			bmpPrv.smoothing=true;
			bmpPrv.pixelSnapping =PixelSnapping.AUTO;
			this.addChild(bmpPrv);
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, tbPrvClick, false, 0, true);
			this.name = "thumbPrvBtn";
		}

		function tbPrvClick(e: MouseEvent): void {
			dispatchEvent(new Event(AppConst.EVENT_TBAR_PRV_CLK, true));
		}

	} //class

}