package org.DWater.utils.DCalculator.module
{
	
	/**
	 * ...
	 * @author dd
	 */
	public class Multiple extends AbstractOperator 
	{
		public static const priority:int=1;
		public static const symbol:String="*";
		public static const funcName:String="mul";
		public static const pramNum:uint=2;
		public static const grammarType:String="1op2";
		public static function calculate(paramArray:Array):Array {
			var a:Number = paramArray.shift();
			var b:Number = paramArray.shift();
			paramArray.unshift(a * b);
			return paramArray;
		}
	}
	
}