package  
{
	import flash.display.Sprite;
	import org.DWater.charts.Coordinate;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class DWaterTest4 extends Sprite 
	{
		
		public function DWaterTest4() 
		{
			var coord:Coordinate = new Coordinate(this, 70, 500 ,-3,3,-3,3);
			coord.width = 400;
			coord.height = 400;
			coord.showTile = true;
			coord.drawFunction("sin(x)", "x", 0xaa000000,1);
			coord.drawFunction2(testCoord, 0xff000000);
			coord.drawFunction("x*x","x", 0xff0000ff);
			coord.drawFunction4(testCoord3,0xffff0000, 7e-1);
		}
		private function testCoord(x:Number):Number {
			return Math.sin(5*x);
		}
		private function testCoord2(x:Number):Number {
			return Math.sqrt(9 - x * x);
		}
		private function testCoord3(x:Number, y:Number):Number {
			return x * x + y * y + y - Math.sqrt(x * x + y * y);
		}
	}

}