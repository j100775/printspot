package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import com.pmi5media.classes.*;

	public class CrossBtnMC extends MovieClip {


		private var bmpCrossRed: Bitmap;
		private var bmpCrossBtn: Bitmap

		public function CrossBtnMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, crossAdded, false, 0, true);
		}

		private function crossAdded(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, crossAdded);

			bmpCrossRed = IconsPmi5.getCrossBtnRed();
			this.addChild(bmpCrossRed);

			bmpCrossBtn = IconsPmi5.getCrossBtn();
			this.addChild(bmpCrossBtn);

			this.addEventListener(MouseEvent.MOUSE_OVER, onCOver, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, onCOut, false, 0, true);
			this.width = AppConst.CROSSBTN_W;
			this.height = AppConst.CROSSBTN_H;
		}

		function onCOver(e: MouseEvent): void {
			bmpCrossBtn.visible = false;
		}

		function onCOut(e: MouseEvent): void {
			bmpCrossBtn.visible = true;
		}


	} //class

}