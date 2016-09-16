package com.pmi5media.classes {
	
	import flash.display.MovieClip;
	
	
	public class PlayerRestartMC extends MovieClip {
		
		
		public function PlayerRestartMC() {
			// constructor code
			this.x=AppConst.SCREEN_WIDTH/2 - this.width/2;
			this.y = AppConst.SCREEN_HEIGHT/2 - this.height/2;
		}
	}
	
}
