package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class QueueNode 
	{
		public var data:String;
		public var prev:QueueNode;
		public var next:QueueNode;
		
		public function QueueNode(_data:String = null):void {
			data = _data;
		}
	}
	
}