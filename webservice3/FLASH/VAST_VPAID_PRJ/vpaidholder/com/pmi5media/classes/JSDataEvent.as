package  com.pmi5media.classes
{
	import flash.events.Event;

	
	public class JSDataEvent extends Event
	{
		public static const JS_DATA:String ="jsdata";
		private var _data:String;
		
		public function JSDataEvent(type:String, data:String, bubbles:Boolean = false, cancelable:Boolean = false):void 
		{ 
			super(type, bubbles, cancelable);
			_data = data;
		}

		public function get data():String
		{
			return _data;
		}

		override public function clone():Event 
		{ 
			return new JSDataEvent(type, _data, bubbles, cancelable);
		} 

		override public function toString():String 
		{ 
			return formatToString("JSDataEvent", "type", "data", "bubbles", "cancelable", "eventPhase"); 
		}
	}
}
