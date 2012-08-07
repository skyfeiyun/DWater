package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Pow extends AbstractOperator
	{
		public static const priority:int=2;
		public static const symbol:String="^";
		public static const funcName:String="pow";
		public static const pramNum:uint=2;
		public static const grammarType:String="1op2";
		public static function calculate(paramArray:Array):Array {
			var a:Number = paramArray.shift();
			var b:Number = paramArray.shift();
			paramArray.unshift(Math.pow(a,b));
			return paramArray;
		}
	}
	
}