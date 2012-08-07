package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Min extends AbstractOperator
	{
		public static const priority:int=2;
		public static const symbol:String="min";
		public static const funcName:String="Min";
		public static const pramNum:uint=2;
		public static const grammarType:String="op(1,2)";
		public static function calculate(paramArray:Array):Array {
			var a:Number = paramArray.shift();
			var b:Number = paramArray.shift();
			paramArray.unshift(Math.min(a,b));
			return paramArray;
		}
	}
	
}