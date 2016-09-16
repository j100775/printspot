package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;


	public class MinisiteConMC extends MovieClip {


		public function MinisiteConMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedStg, false, 0, true);
		}

		function addedStg(e: Event): void {
			this.width = AppConst.SCREEN_WIDTH;
			this.height = AppConst.SCREEN_HEIGHT;
			removeEventListener(Event.ADDED_TO_STAGE, addedStg);
		}
	}

}