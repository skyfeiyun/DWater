package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Queue 
	{
		public var start:QueueNode;
		public var end:QueueNode;
		private var length:int;
		
		public function Queue():void {
			length = 0;
		}
		public function push(_data:String):void {
			if (!start) {
				start = new QueueNode(_data);
				end = start;
			}else {
				var temp:QueueNode = new QueueNode(_data);
				end.next = temp;
				temp.prev = end;
				end = temp;
			}
			length++;
		}
		public function pop():QueueNode {
			if (length==0) {
				return null;
			}
			var temp:QueueNode = end;
			end = end.prev;
			if (end) {
				end.next = null;
			}else {
				start = null;
			}
			temp.prev = null;
			length--;
			return temp;
		}
		public function shift():QueueNode {
			if (length==0) {
				return null;
			}
			var temp:QueueNode = start;
			start = start.next;
			if (start) {
				start.prev = null;
			}else {
				end = null;
			}
			temp.next = null;
			length--;
			return temp;
		}
		public function unshift(_data:String):void {
			if (!start) {
				start = new QueueNode(_data);
				end = start;
			}else {
				var temp:QueueNode = new QueueNode(_data);
				start.prev = temp;
				temp.next = start;
				start = temp;
			}
			length++;
		}
		public function indexOf(_data:String,_startIndex:int=0):int {
			var pos:int = _startIndex;
			var current:QueueNode = getElement(_startIndex);
			while (current) {
				if (current.data==_data) {
					return pos;
				}
				current = current.next;
				pos++;
			}
			return -1;
		}
		public function lastIndexOf(_data:String, _startIndex:int = int.MAX_VALUE):int {
			if (_startIndex==int.MAX_VALUE) {
				_startIndex = length - 1;
			}
			var pos:int = _startIndex;
			var current:QueueNode = getElement(_startIndex);
			while (current) {
				if (current.data==_data) {
					return pos;
				}
				current = current.prev;
				pos--;
			}
			return -1;
		}
		public function insertAfter(_data:String, _index:int):void {
			if (_index>=length) {
				_index = length - 1;
			}
			if (_index<0) {
				_index = 0;
			}
			var temp:QueueNode = getElement(_index);
			var temp2:QueueNode = temp.next;
			
			if (_index==(length-1)) {
				push(_data);
			}else {
				var temp3:QueueNode=new QueueNode(_data);
				temp.next = temp3;
				temp3.prev = temp;
				temp2.prev = temp3;
				temp3.next = temp2;
				length++;
			}
		}
		public function insertBefore(_data:String, _index:int):void {
			if (_index>length) {
				_index = length;
			}
			if (_index<0) {
				_index = 0;
			}
			
			
			if (_index == 0) {
				unshift(_data);
			}else if (_index==length) {
				push(_data);
			}else {
				var temp:QueueNode = getElement(_index);
				var temp2:QueueNode = temp.prev;
				var temp3:QueueNode=new QueueNode(_data);
				temp.prev = temp3;
				temp3.next = temp;
				temp2.next = temp3;
				temp3.prev = temp2;
				length++;
			}
		}
		public function removeAt(_index:int):QueueNode {
			if (_index>=length||_index<0) {
				return null;
			}
			var temp:QueueNode = getElement(_index);
			if (_index==0) {
				return shift();
			}else if (_index==(length-1)) {
				return pop();
			}else {
				temp.prev.next = temp.next;
				temp.next.prev = temp.prev;
				temp.prev = null;
				temp.next = null;
				length--;
				return temp;
			}
		}
		public function substring(_startIndex:int, _endIndex:int):Queue {
			if ((_startIndex>=_endIndex)||(_startIndex<0)||(_endIndex>length)) {
				return null;
			}
			var result:Queue = new Queue();
			var current:QueueNode = getElement(_startIndex);
			while (_startIndex < _endIndex) {
				result.push(current.data);
				current = current.next;
				_startIndex++;
			}
			return result;
		}
		public function addQueueBefore(_source:Queue, _index:int):void {
			var temp:QueueNode = _source.start;
			while (temp) {
				insertBefore(temp.data, _index);
				_index++;
				temp = temp.next;
			}
		}
		public function addQueueAfter(_source:Queue, _index:int):void {
			var temp:QueueNode = _source.start;
			while (temp) {
				insertAfter(temp.data, _index);
				_index++;
				temp = temp.next;
			}
		}
		public function remove(_startIndex:int, _endIndex:int):void {
			if (!(_startIndex>=0&&_endIndex<=length)) {
				return;
			}
			var startNode:QueueNode = getElement(_startIndex);
			var endNode:QueueNode = getElement(_endIndex - 1);
			var prevNode:QueueNode = startNode.prev;
			var nextNode:QueueNode = endNode.next;
			
			startNode.prev = null;
			endNode.next = null;
			if (_startIndex==0) {
				start = nextNode;
			}
			if (_endIndex==length) {
				end = prevNode;
			}
			if (prevNode) {
				prevNode.next = nextNode;
			}
			if (nextNode) {
				nextNode.prev = prevNode;
			}
			length -= (_endIndex - _startIndex);
		}
		public function getElement(_index:int):QueueNode {
			if (_index>=length||_index<0) {
				return null;
			}
			var current:QueueNode = start;
			for (var i:int = 0; i < _index;i++ ) {
				current = current.next;
			}
			return current;
		}
		public function getLength():int {
			return length;
		}
		public function clone():Queue {
			var result:Queue = new Queue();
			var temp:QueueNode = start;
			while (temp) {
				result.push(temp.data);
				temp = temp.next;
			}
			return result;
		}
		public function toString():String {
			var current:QueueNode = start;
			var result:String = "";
			while (current) {
				result += current.data;
				current = current.next;
			}
			return result;
		}
	}
	
}