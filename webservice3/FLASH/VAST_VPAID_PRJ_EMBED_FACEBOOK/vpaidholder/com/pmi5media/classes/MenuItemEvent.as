package com.pmi5media.classes {
	import flash.events.Event;


	public class MenuItemEvent extends Event {
		public static const ITEM_CLICK: String = "itemclick";
		private var _data: String;

		public function MenuItemEvent(type: String, data: String, bubbles: Boolean = false, cancelable: Boolean = false): void {
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data(): String {
			return _data;
		}

		override public function clone(): Event {
			return new MenuItemEvent(type, _data, bubbles, cancelable);
		}

		override public function toString(): String {
			return formatToString("MenuItemEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
	}
}