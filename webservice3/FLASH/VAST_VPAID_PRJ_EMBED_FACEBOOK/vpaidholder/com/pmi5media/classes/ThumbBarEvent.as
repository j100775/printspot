package com.pmi5media.classes {
	import flash.events.Event;


	public class ThumbBarEvent extends Event {
		public static const ICON_CLICK: String = "iconclick";
		private var _data: String;

		public function ThumbBarEvent(type: String, data: String, bubbles: Boolean = false, cancelable: Boolean = false): void {
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data(): String {
			return _data;
		}

		override public function clone(): Event {
			return new ThumbBarEvent(type, _data, bubbles, cancelable);
		}

		override public function toString(): String {
			return formatToString("ThumbBarEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}