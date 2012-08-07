package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Cos extends AbstractOperator
	{
		public static const priority:int=2;
		public static const symbol:String="cos";
		public static const funcName:String="Cos";
		public static const pramNum:uint=1;
		public static const grammarType:String="op1";
		public static function calculate(paramArray:Array):Array {
			var a:Number = paramArray.shift();
			paramArray.unshift(Math.cos(a));
			return paramArray;
		}
	}
	
}