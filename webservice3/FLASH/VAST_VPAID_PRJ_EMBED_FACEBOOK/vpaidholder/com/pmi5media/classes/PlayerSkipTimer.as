package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.filters.GlowFilter;
	import fl.video.SkinErrorEvent;


	public class PlayerSkipTimer extends MovieClip {

		private var skipAdCounter: Timer;
		private var SkipDur: Number;
		private var showSkipCounter: Boolean;
		private var skipCounterText: String = "Skip in ";
		private var skipCounterTField: TextField = new TextField();
		private var skipCounterTFormat: TextFormat = new TextFormat();
		private var skipXpos: int;
		private var skipYpos: int;
		private var skipColor: * ;
		private var bgCreated: Boolean;
		private var isCountFinish: Boolean;
		var btnSkipAd: Sprite = new Sprite();
		var sp: Bitmap;

		public function PlayerSkipTimer() {
			// constructor code
		}


		public function loadSkipData(pData: XMLList): void {
			SkipDur = 0;

			this.showSkipCounter = pData.showskipad.toLowerCase() == "true";
			this.SkipDur = pData.skipadvalue; // passing from content xml 
			this.skipXpos = pData.skipadoffsetx;
			this.skipYpos = pData.skipadoffsety;
			this.skipColor = pData.skipadcolor;
			createCounter();
		}

		public function testSkipData(): void {
			SkipDur = 0;

			this.showSkipCounter = true;
			this.SkipDur = 5; // passing from content xml 
			this.skipXpos = 500;
			this.skipYpos = 200;
			this.skipColor = "0xf000ff";
			createCounter();
		}

		private function createCounter(): void {
			bgCreated = false;
			skipCounterTFormat.size = 10;
			skipCounterTFormat.bold = true;
			skipCounterTFormat.color = skipColor;

			skipCounterTFormat.leading = .5;
			skipCounterTField.selectable = false;
			skipCounterTField.visible = showSkipCounter;
			skipCounterTField.x = skipXpos;
			skipCounterTField.y = skipYpos;
			skipCounterTField.width = 62;
			skipCounterTField.defaultTextFormat = skipCounterTFormat;
			addChild(skipCounterTField);

			skipCounterTField.text = skipCounterText + SkipDur;
			this.setChildIndex(skipCounterTField, numChildren - 1);
			this.visible = false;
		}

		public function setSkipTimer(): void {
			skipCounterTField.text = skipCounterText + SkipDur;

			skipAdCounter = new Timer(1000, SkipDur);
			skipAdCounter.addEventListener(TimerEvent.TIMER, oncounterTimer, false, 0, true);
			skipAdCounter.addEventListener(TimerEvent.TIMER_COMPLETE, onSkipComp, false, 0, true);

			this.visible = true;
			this.setChildIndex(skipCounterTField, numChildren - 1);

		}

		public function startSkipTimer(): void {
			skipAdCounter.start();
		}

		private function onSkipComp(evt: TimerEvent): void {
			skipAdCounter.removeEventListener(TimerEvent.TIMER_COMPLETE, onSkipComp);
			skipAdCounter.removeEventListener(TimerEvent.TIMER, oncounterTimer);
			trace("skip timer complete");
			countdownComplete();

		}

		private function countdownComplete(): void {
			skipCounterTField.visible = false;
			sp = IconsPmi5.getSkipAdIcon();
			btnSkipAd.x = skipCounterTField.x;
			btnSkipAd.y = skipCounterTField.y;
			btnSkipAd.addChild(sp);
			this.addChild(btnSkipAd);
			btnSkipAd.addEventListener(MouseEvent.CLICK, skipClicked, false, 0, true);
			btnSkipAd.addEventListener(MouseEvent.MOUSE_OVER, skipOver, false, 0, true);
			btnSkipAd.addEventListener(MouseEvent.MOUSE_OUT, skipOut, false, 0, true);
			btnSkipAd.buttonMode = true;
		}

		private function skipOver(e: MouseEvent): void {
			btnSkipAd.filters = [new GlowFilter(0xffffff, 1, 10, 10, 2.5)];
		}

		private function skipOut(e: MouseEvent): void {
			btnSkipAd.filters = null;
		}

		private function oncounterTimer(e: TimerEvent): void {
			skipCounterTField.text = skipCounterText + ((SkipDur + 1) - skipAdCounter.currentCount);
		}

		public function setSkipTimerDur(): void {
			if (isCountFinish) return;
			skipCounterTField.text = skipCounterText + (SkipDur--);
			this.visible = true;
			if (int(SkipDur) < 0) {
				isCountFinish = true;
				countdownComplete();
			}
		}

		private function skipClicked(evt: MouseEvent): void {
			btnSkipAd.removeEventListener(MouseEvent.CLICK, skipClicked);
			btnSkipAd.removeEventListener(MouseEvent.MOUSE_OVER, skipOver);
			btnSkipAd.removeEventListener(MouseEvent.MOUSE_OUT, skipOut);
			dispatchEvent(new Event(AppConst.EVENT_SKIPAD, true));
		}
		
		public function hideStop():void
		{
			if(skipAdCounter!=null)
				skipAdCounter.stop();
			
			this.visible = false;
		}

	} //class

}