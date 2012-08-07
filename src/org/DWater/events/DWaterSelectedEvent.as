package org.DWater.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class DWaterSelectedEvent extends Event 
	{
		public static const SELECT:String = "select";
		public static const ITEM_CLICK:String = "item_click";
		public static const ITEM_DOUBLE_CLICK:String = "item_double_click";
		public var index:int;
		public var data:Object;
		public function DWaterSelectedEvent(type:String, index:int = -1,data:Object=null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.data = data;
			this.index = index;
		}
		
	}

}