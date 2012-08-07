package  
{
	import flash.display.Sprite;
	import org.DWater.charts.LineChart;
	import org.DWater.charts.PieChart;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class DWaterTest3 extends Sprite 
	{
		
		public function DWaterTest3() 
		{
			var i:int;
			var lineChart:LineChart = new LineChart(this, 50, 230);
			var itemData:Array = [];
			for (i = 0; i < 10;i++ ) {
				itemData.push( { label:"item" + i.toString(), value:Math.random()*100 } );
			}
			lineChart.base = 2;
			lineChart.labelPadding = 45;
			lineChart.startWithZero = false;
			lineChart.data = itemData;
			lineChart.fixedLength = 1;
			
			var pieChart:PieChart = new PieChart(this, 50, 300);
			itemData = [];
			for (i = 0; i < 5;i++ ) {
				itemData.push( { label:"item" + i.toString(), value:Math.random()*100} );
			}
			pieChart.data = itemData;
		}
		
	}

}