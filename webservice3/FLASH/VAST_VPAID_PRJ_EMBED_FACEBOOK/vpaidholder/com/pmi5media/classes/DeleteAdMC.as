package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;


	public class DeleteAdMC extends MovieClip {


		public function DeleteAdMC() {
			// constructor code
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}

		function onOver(e: MouseEvent): void {
			gotoAndStop(2);
		}

		function onOut(e: MouseEvent): void {
			gotoAndStop(1);
		}

	}

}