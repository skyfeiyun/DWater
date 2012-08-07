package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Node {
		private var hashTable:Object;
		public var finalNode:Boolean;
		public var type:String;
		public function Node(_type:String=null,_finalNode:Boolean=false):void {
			hashTable = new Object();
			finalNode = _finalNode;
			type = _type;
		}
		public function addShift(hashCode:String,destination:Node):void {
			hashTable[hashCode] = destination;
		}
		public function transTo(code:String):Node {
			return hashTable[code] as Node;
		}
	}
	
}