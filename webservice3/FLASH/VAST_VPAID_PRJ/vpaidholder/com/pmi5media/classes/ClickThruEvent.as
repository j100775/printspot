package com.pmi5media.classes {
	import flash.events.Event;
	
	public class ClickThruEvent extends Event  {

		public static const CLICK:String = "CLICK";
		public static const HIDE:String="HIDE";
		private var _data:String;
		
		public function ClickThruEvent(type:String,data:String,bubbles:Boolean=false,cancelable:Boolean=false):void
		{
			// constructor code
			super(type,bubbles,cancelable);
			_data=data;
		}
		
		public function get data():String{
			return _data;
		}
		
		override public function clone():Event
		{
			return new ClickThruEvent(type,_data,bubbles,cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("ClickThruEvent","type","data","bubbles","cancelable","eventPhase");
		}
		

	}
	
}
