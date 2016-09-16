package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.text.TextFieldAutoSize;


	public class PlayerTimer extends MovieClip {

		private var xmlCampaignList: XMLList = new XMLList();

		// timer for deciding when the ad should end
		private var timer: Timer;

		// the ad duration  
		private var adDuration: Number;
		private var adRemainDuration: Number;

		// track how much time is left
		private var timeRemaining: Number;
		private var counterTimer: Timer;
		private var showCounter: Boolean;
		private var showCounterText: String = "Your Content will Begin in: ";
		private var showCounterTField: TextField = new TextField();
		private var showCounterTFormat: TextFormat = new TextFormat();
		private var counterXpos: int;
		private var counterYpos: int;
		private var counterColor: * ;
		private var stopCounter: Boolean;

		public function PlayerTimer() {
			// constructor code


		}


		private function createCounter(): void {
			showCounterTFormat.size = 12;

			showCounterTFormat.bold = true;
			showCounterTFormat.color = counterColor;
			showCounterTField.visible = showCounter;
			showCounterTField.x = counterXpos;
			showCounterTField.y = counterYpos;
			showCounterTField.autoSize = TextFieldAutoSize.LEFT;
			showCounterTField.defaultTextFormat = showCounterTFormat;

			this.addChild(showCounterTField);
			this.setChildIndex(showCounterTField, numChildren - 1);
			this.visible = false;

		}
		public function loadData(pData: XMLList): void {
			stopCounter = false;
			showCounter = false;
			adDuration = 0;

			xmlCampaignList = pData;
			this.adDuration = xmlCampaignList.durationseconds; // passing from content xml 
			this.showCounter = xmlCampaignList.showcounter.toLowerCase() == "true";
			this.stopCounter = xmlCampaignList.stopcounter.toLowerCase() == "true";
			this.counterXpos = xmlCampaignList.counteroffsetx;
			this.counterYpos = xmlCampaignList.counteroffsety;
			this.counterColor = xmlCampaignList.countercolor;
			createCounter();

		}


		private function oncounterTimer(e: TimerEvent): void {
			showCounterTField.text = showCounterText + (((adDuration / 4) + 1) - counterTimer.currentCount);
		}

		private function timerComplete(evt: Event): void {
			dispatchEvent(new Event(AppConst.EVENT_AD_REMOVE, true));
			this.visible = false;
		}

		private function onTimer(pEvent: TimerEvent): void {
			timeRemaining--;
			adRemainDuration--;
			switch (Math.round(adRemainDuration)) {
				case Math.round(adDuration * .75):
					dispatchEvent(new Event(AppConst.EVENT_I_QUARTILE, true));
					break;
				case Math.round(adDuration * .5):
					dispatchEvent(new Event(AppConst.EVENT_II_QUARTILE, true));
					break;
				case Math.round(adDuration * .25):
					dispatchEvent(new Event(AppConst.EVENT_III_QUARTILE, true));
					break;

			}
		}

		public function startPlTimer(): void {
			if (stopCounter) return;
			if (timer) timer.start();
			if (counterTimer) counterTimer.start();
		}

		public function stopPlTimer(): void {
			if (stopCounter) return;
			if (timer) timer.stop();
			if (counterTimer) counterTimer.stop();
		}

		public function setTimerDur(pVal: * ): void {
			showCounterTField.text = showCounterText + pVal;
			this.visible = true;
			if (int(pVal) < 1) {
				this.visible = false;
			}
		}

		public function setAndStartTimer(): void {

			showCounterTField.text = showCounterText + adDuration;
			//timer for counter
			counterTimer = new Timer(1000, (adDuration));
			counterTimer.addEventListener(TimerEvent.TIMER, oncounterTimer, false, 0, true);



			adDuration = adDuration * 4;
			adRemainDuration = Number(adDuration);
			timer = new Timer(250, adDuration);
			timer.addEventListener(TimerEvent.TIMER, onTimer);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);


			this.visible = true;
			if (!stopCounter)
				startPlTimer();
		}
	} //class

}