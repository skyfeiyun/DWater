package org.DWater.events 
{
	import flash.events.Event;
	
	/**
	 * This class is used by the DWater components.
	 * @author Dong Dong
	 */
	public class DWaterSelectedEvent extends Event 
	{
		/**
		 * Dispatch when an item is selected.
		 */
		public static const SELECT:String = "select";
		/**
		 * Dispatch when an item is clicked.
		 */
		public static const ITEM_CLICK:String = "item_click";
		/**
		 * Dispatch when an item is clicked for twice.
		 */
		public static const ITEM_DOUBLE_CLICK:String = "item_double_click";
		
		/**
		 * The index of the item.
		 */
		public var index:int;
		/**
		 * Data the item contains.
		 */
		public var data:Object;
		public function DWaterSelectedEvent(type:String, index:int = -1,data:Object=null, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.data = data;
			this.index = index;
		}
		
	}

}