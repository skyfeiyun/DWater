package org.DWater.utils.DCalculator
{
	import org.DWater.utils.DCalculator.module.*;
	/**
	 * DParser is a Class for formula parsing. You can simply create a DParser Object, 
	 * pass your formula string to DParser compiler. After compiling this formula you can pass
	 *  the value of variable to the function calculate() to calculate the result.
	 * @author ...
	 */
	public class DParser 
	{
		private var _originCommand:String;
		private var _compiledCommand:Queue;
		private var _paramName:Array;
		private var _pramArray:Array;
		private var _funcSheet:Array = [Add, Substract, Multiple, Divide,Abs,Acos,Asin,Atan,Sin,Cos,Tan,Ceil,Floor,Round,Sqrt,Log,Pow,Min,Max];
		private var _constSheet:Array = [ { name:"pi", value:Math.PI }, { name:"e", value:Math.E } ];
		private var _splitToken:Queue;
		
		private var tokenAuto:Automaton;
		
		/**
		 * Create a new formula parser, for one formula you need one parser related to it. The formula string is not case sensitive.
		 * @param	originCommand A formula String you should pass to the constructor, such as x*x+3, these operator 
		 * is support in the parser:
			 * <p>+(add), -(substract), *(multiple), /(divide), ^(pow), abs, acos, asin, atan, sin, cos, tan, floor, ceil,
			 * round, max, min, log(base 2).
			 * </p>
		 * @param	paramName If your formula string contains a series of variable. Pass the varibale name using array of string.
		 */
		public function DParser(originCommand:String,paramName:Array) {
			tokenAuto = Automaton.createToken();
			_funcSheet.sortOn("priority", Array.NUMERIC | Array.DESCENDING);
			_originCommand = originCommand;
			_paramName = paramName;
			_compiledCommand = compileOrigin(_originCommand);
		}
		/**
		 * 
		 * @param	paramArray The variable parameters array. For example, if you have 2 variable x=1,y=2,
		 * 			you should pass the variable using this format:[{name:"x",value:1},{name:"y",value:2}]
		 * @return The result of this formula.
		 * 
		 *  * @example The following code show how to calculate the formula "x*x+y*y":
			 * <listing version="3.0">
			 * var parser:DParser=new DParser("x*x+y*y",["x","y"]);
			 * var result:Number;
			 * result=parser.calculate([{name:"x",value:3},{name:"y",value:4}]);
			 * trace(3,"*",3,"+",4,"*",4,"=",result);
			 * </listing>
		 */
		public function calculate(paramArray:Array):Number {
			_pramArray = paramArray;
			var tempStack:Array = new Array();
			var temp:Queue = replaceParamAndConst(_compiledCommand);
			makeStack(temp, tempStack);
			return doEval(tempStack);
		}
		private function compileOrigin(origin:String):Queue {
			var temp:String = preHandler(origin);
			_splitToken = createSplit(temp);
			var tempQ:Queue = _splitToken.clone();
			for each(var tempOpertor:Class in _funcSheet) {
				translateOperator(tempOpertor, tempQ);
			}
			return tempQ;
		}
		private function preHandler(origin:String):String {
			var result:String = origin;
			result = result.replace(/[\n ]+/g, "");
			result = result.toLowerCase();
			return result;
		}
		private function createSplit(origin:String):Queue {
			var pos:int = 0;
			var lastPos:int = 0;
			var l:int = origin.length;
			var resultQueue:Queue = new Queue();
			while (pos < l) {
				pos = nextToken(origin, pos);
				resultQueue.push(origin.substring(lastPos, pos));
				lastPos = pos;
			}
			return resultQueue;
		}
		private function replaceParamAndConst(compiled:Queue):Queue {
			var result:Queue = compiled.clone();
			var currentNode:QueueNode = result.start;
			var value:String;
			while (currentNode) {
				if (value=isConst(currentNode.data)) {
					currentNode.data = value;
				}else if (value=isParam(currentNode.data)) {
					currentNode.data = value;
				}
				currentNode = currentNode.next;
			}
			return result;
		}
		private function translateOperator(operator:Class, source:Queue):void {
			var maxPram:int = 20;
			var params:Vector.<Queue> = new Vector.<Queue>(maxPram, true);
			var grammerQueue:Queue = new Queue();
			var currentToken:String = "";
			var grammer:String = operator.grammarType;
			var i:int = 0;
			var l:int = grammer.length;
			var char:String;
			var ele:String = "";
			var tempParse:Automaton = new Automaton() ;
			var symbol:Node = new Node("symbol",true);
			var value:Node=new Node("value",true);
			var d:Node = new Node("digit", true);
			tempParse.startNode.addShift("leftP", symbol);
			tempParse.startNode.addShift("rightP", symbol);
			tempParse.startNode.addShift("comma", symbol);
			tempParse.startNode.addShift("digit", d);
			tempParse.startNode.addShift("letter", value);
			d.addShift("digit", d);
			value.addShift("letter", value);
			while (i<l) {
				char = grammer.charAt(i);
				if (!tempParse.iterate(char)) {
					grammerQueue.push(ele);
					ele = char;
					tempParse.reset();
				}else {
					ele += char;
				}
				i++;
			}
			grammerQueue.push(ele);
			var temp:QueueNode = grammerQueue.start;
			var opIndex:int = grammerQueue.indexOf("op");
			var opQueueNode:QueueNode = grammerQueue.getElement(opIndex);
			var tempSerachNode:QueueNode;
			var tokenQueueNode:QueueNode = source.start;
			var tokenSearchNode:QueueNode;
			var searchCount:int = 0;
			
			var leftLimit:int;
			var rightLimit:int;
			var tempLimit:int;
			while (tokenQueueNode) {
				if (tokenQueueNode.data==operator["symbol"]) {
					i = 0;
					tempSerachNode = opQueueNode;
					leftLimit = searchCount;
					rightLimit = searchCount;
					while (tempSerachNode=tempSerachNode.prev) {
						if (tempSerachNode.data==","||tempSerachNode.data=="("||tempSerachNode.data==")") {
							leftLimit--;
						}else {
							tempLimit = prevParam(source, leftLimit);
							params[parseInt(tempSerachNode.data) - 1] = source.substring(tempLimit, leftLimit);
							leftLimit = tempLimit;
						}
					}
					tempSerachNode = opQueueNode;
					while (tempSerachNode=tempSerachNode.next) {
						if (tempSerachNode.data==","||tempSerachNode.data=="("||tempSerachNode.data==")") {
							rightLimit++;
						}else {
							tempLimit = nextParam(source, rightLimit);
							params[parseInt(tempSerachNode.data) - 1] = source.substring(rightLimit+1, tempLimit+1);
							rightLimit = tempLimit;
						}
					}
					source.remove(leftLimit, rightLimit + 1);
					source.insertBefore(operator.funcName, leftLimit);
					leftLimit++;
					source.insertBefore("(", leftLimit);
					leftLimit++;
					while (params[i] != null) {
						source.addQueueAfter(params[i], leftLimit-1);
						leftLimit+=params[i].getLength();
						source.insertAfter(",", leftLimit-1);
						leftLimit++;
						i++;
					}
					source.getElement(leftLimit - 1).data = ")";
					tokenQueueNode = source.start;
					searchCount = 0;
					continue;
				}
				tokenQueueNode = tokenQueueNode.next;
				searchCount++;
			}
		}
		private function makeStack(commandString:Queue, stack:Array):void {
			var startIndex:int;
			var endIndex:int;
			while (commandString.start.data == "(" && commandString.end.data == ")") {
				commandString.shift();
				commandString.pop();
			}
			startIndex = commandString.indexOf("(");
			if (startIndex==-1) {
				stack.push(commandString.toString());
				return;
			}else {
				endIndex = commandString.lastIndexOf(")");
				stack.push(commandString.start.data);
				var tempString:Queue = commandString.substring(startIndex + 1, endIndex);
				var tempArray:Array = new Array();
				var l:int = tempString.getLength();
				var i:int = 0;
				var char:String = "";
				
				var current:QueueNode = tempString.start;
				var count:int = 0;
				var tempEle:Queue = new Queue();
				
				while (current) {
					char = current.data;
					if (char=="(") {
						count++;
						tempEle.push(char);
					}else if (char==")") {
						count--;
						tempEle.push(char);
					}else if (char==",") {
						if (count==0) {
							tempArray.push(tempEle);
							tempEle = new Queue();
						}else {
							tempEle.push(char);
						}
					}else {
						tempEle.push(char);
					}
					current = current.next;
				}
				tempArray.push(tempEle);
				for each(var temp:Queue in tempArray) {
					makeStack(temp, stack);
				}
			}
		}
		private function doEval(stack:Array):Number {
			var tempParamArray:Array=new Array();
			var tempElement:String;
			var tempFunc:Class;
			while (stack.length!=0) {
				tempElement = stack.pop();
				if (isFunction2(tempElement)) {
					tempFunc = getFuncByName(tempElement);
					tempParamArray = tempFunc["calculate"](tempParamArray);
				}else {
					tempParamArray.unshift(tempElement);
				}
			}
			return parseFloat(tempParamArray[0]);
		}
		private function nextParam(source:Queue, currentIndex:int):int {
			var currentNode:QueueNode = source.getElement(currentIndex);
			var result:int = currentIndex;
			var parenCount:int = 0;
			while (currentNode = currentNode.next) {
				result++;
				if (currentNode.data=="(") {
					parenCount++;
				}else if (currentNode.data == ")") {
					if (parenCount==0) {
						result--;
						break;
					}
					parenCount--;
				}else if (!(isParam2(currentNode.data) || isFunction2(currentNode.data) || isConst(currentNode.data) || (".0123456789".indexOf(currentNode.data.charAt(0))!=-1))) {
					if (parenCount==0) {
						result--;
						break;
					}
				}
			}
			return result;
		}
		private function prevParam(source:Queue, currentIndex:int):int {
			var currentNode:QueueNode = source.getElement(currentIndex);
			var result:int = currentIndex;
			
			var parenCount:int = 0;
			while (currentNode = currentNode.prev) {
				result--;
				if (currentNode.data == "(") {
					if (parenCount==0) {
						result++;
						break;
					}
					parenCount++;
				}else if (currentNode.data==")") {
					parenCount--;
				}else if (!(isParam2(currentNode.data) || isFunction2(currentNode.data) || isConst(currentNode.data) || (".0123456789".indexOf(currentNode.data.charAt(0))!=-1))) {
					if (parenCount==0) {
						result++;
						break;
					}
				}
			}
			return result;
		}
		private function nextToken(source:String, position:int):int {
			var l:int = source.length;
			while (position< l) {
				if (!tokenAuto.iterate(source.charAt(position))) {
					break;
				}
				position++;
			}
			tokenAuto.reset();
			return position;
		}
		
		private function isConst(input:String):String {
			for each(var constance:Object in _constSheet) {
				if (constance.name==input) {
					return constance.value.toString();
				}
			}
			return null;
		}
		private function isFunction(input:String):String {
			for each(var func:Class in _funcSheet) {
				if (func.symbol==input) {
					return func.funcName;
				}
			}
			return null;
		}
		private function isFunction2(input:String):String {
			for each(var func:Class in _funcSheet) {
				if (func.funcName==input) {
					return func.funcName;
				}
			}
			return null;
		}
		private function isParam2(input:String):Boolean {
			for each(var tempString:String in _paramName) {
				if (tempString==input) {
					return true;
				}
			}
			return false;
		}
		private function isParam(input:String):String {
			for each(var constance:Object in _pramArray) {
				if (constance.name==input) {
					return constance.value.toString();
				}
			}
			return null;
		}
		private function getFuncByName(name:String):Class {
			for each(var func:Class in _funcSheet) {
				if (func.funcName==name) {
					return func;
				}
			}
			return null;
		}
	}
	
}