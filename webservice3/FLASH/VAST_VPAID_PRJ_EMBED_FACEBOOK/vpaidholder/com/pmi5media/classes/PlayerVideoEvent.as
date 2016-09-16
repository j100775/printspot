package com.pmi5media.classes {
	import flash.events.Event;


	public class PlayerVideoEvent extends Event {
		public static const VIDEO_DUR: String = "VIDEO_DUR";
		private var _data: String;

		public function PlayerVideoEvent(type: String, data: String, bubbles: Boolean = false, cancelable: Boolean = false): void {
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data(): String {
			return _data;
		}

		override public function clone(): Event {
			return new PlayerVideoEvent(type, _data, bubbles, cancelable);
		}

		override public function toString(): String {
			return formatToString("PlayerVideoEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}