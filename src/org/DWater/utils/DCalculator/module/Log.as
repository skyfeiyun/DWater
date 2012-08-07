package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Log extends AbstractOperator
	{
		public static const priority:int=2;
		public static const symbol:String="log";
		public static const funcName:String="Log";
		public static const pramNum:uint=2;
		public static const grammarType:String="op(1,2)";
		public static function calculate(paramArray:Array):Array {
			var a:Number = paramArray.shift();
			var b:Number = paramArray.shift();
			paramArray.unshift(Math.log(b)/Math.log(a));
			return paramArray;
		}
	}
	
}