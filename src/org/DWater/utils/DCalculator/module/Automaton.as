package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Automaton
	{
		private static const letter:String = "abcdefghijklmnopqrstuvwxyz";
		private static const digit:String = "0123456789";
		public var startNode:Node;
		public var currentNode:Node;
		public var lastNode:Node;
		public function Automaton():void {
			startNode = new Node();
			currentNode = startNode;
		}
		public function reset():void {
			currentNode = startNode;
		}
		public function iterate(code:String):Node {
			var type:String;
			if (letter.indexOf(code)!=-1) {
				type = "letter";
			}else if (digit.indexOf(code)!=-1) {
				type = "digit";
			}else if (code==".") {
				type = "dot";
			}else if (code=="(") {
				type = "leftP";
			}else if (code==")") {
				type = "rightP";
			}else if (code==",") {
				type = "comma";
			}else if(code == "_") {
				type == "underline";
			}else {
				type = "symbol";
			}
			lastNode = currentNode;
			currentNode = currentNode.transTo(type);
			return currentNode;
		}
		public static function createToken():Automaton {
			var symbol:Node = new Node("symbol",true);
			var value:Node=new Node("value",true);
			var dot:Node=new Node();
			var d1:Node=new Node("digit",true);
			var d2:Node=new Node("digit",true);
			var result:Automaton = new Automaton();
			result.startNode.addShift("leftP", symbol);
			result.startNode.addShift("rightP", symbol);
			result.startNode.addShift("comma", symbol);
			result.startNode.addShift("symbol", symbol);
			result.startNode.addShift("underline", value);
			result.startNode.addShift("letter", value);
			result.startNode.addShift("digit", d1);
			result.startNode.addShift("dot", dot);
			value.addShift("letter", value);
			value.addShift("digit", value);
			value.addShift("underline", value);
			d1.addShift("digit", d1);
			d1.addShift("dot", dot);
			dot.addShift("digit", d2);
			d2.addShift("digit", d2);
			return result;
		}
		public static function createDigit():Automaton {
			var dot:Node = new Node();
			var d1:Node = new Node("digit",true);
			var d2:Node = new Node("digit",true);
			var result:Automaton = new Automaton();
			result.startNode.addShift("dot", dot);
			result.startNode.addShift("digit", d1); 
			dot.addShift("digit", d2);
			d1.addShift("dot", dot);
			d1.addShift("digit", d1);
			d2.addShift("digit", d2);
			return result;
		}
		public static function createValue():Automaton {
			var s:Node = new Node("value",true);
			var result:Automaton = new Automaton();
			result.startNode.addShift("letter", s);
			s.addShift("underline", s);
			s.addShift("letter", s);
			s.addShift("digit", s);
			
			return result;
		}
	}
	
}