package 
{
	import flash.display.Sprite;
	import org.DWater.charts.BarChart;
	import org.DWater.charts.FlowChart;
	import org.DWater.components.Button;
	import org.DWater.components.CheckBox;
	import org.DWater.components.Clock;
	import org.DWater.components.FPSMeter;
	import org.DWater.components.HGroup;
	import org.DWater.components.InputText;
	import org.DWater.components.Label;
	import org.DWater.components.NumberStepper;
	import org.DWater.components.ProgressBar;
	import org.DWater.components.RadioButton;
	import org.DWater.components.RadioButtonGroup;
	import org.DWater.components.VGroup;
	
	/**
	 * ...
	 * @author dongdong
	 */
	public class DWaterTest1 extends Sprite 
	{
		public function DWaterTest1():void {
			var label:Label = new Label(this, 30, 45, "Label");
			label.border = true;
			var button:Button = new Button(this, 150, 25, "Button");
			var toggleButton:Button = new Button(this, 150, 55, "ToggleButton");
			toggleButton.toggle = true;
			
			var checkBox:CheckBox = new CheckBox(this, 270, 50, {label:"CheckBox",value:"test"});
			var progressBar:ProgressBar = new ProgressBar(this, 420, 55);
			progressBar.percent = 40;
			var numberStepper:NumberStepper = new NumberStepper(this, 30, 100, -100, 100, 0, 1);
			
			var datas:Array = [ { label:"test1", value:10 }, { label:"test2", value:20 }, { label:"test3", value:40 } ];
			var barChart:BarChart = new BarChart(this, 250, 100,datas , 5);
			barChart.showValue = true;
			barChart.addItem( { label:"add Item", value:20 } );
			barChart.removeItemAt(0);
			
			var inputText:InputText = new InputText(this, 30, 200, "inputText");
			
			var item1:Label = new Label(null, 0, 0, "item1");
			var item2:Label = new Label(null, 0, 0, "item2");
			var item3:Label = new Label(null, 0, 0, "item3");
			var vGroup:VGroup = new VGroup(this, 30, 230, [item1, item2, item3]);
			vGroup.height = 150;
			vGroup.align = VGroup.CENTER;
			
			var item4:Label = new Label(null, 0, 0, "item4");
			var item5:Label = new Label(null, 0, 0, "item5");
			var item6:Label = new Label(null, 0, 0, "item6");
			var hGroup:HGroup = new HGroup(this, 200, 280, [item4, item5, item6]);
			
			hGroup.align = HGroup.CENTER;
			
			var clock:Clock = new Clock(this, 350, 260);
			
			var flowChart:FlowChart = new FlowChart(this, 30, 400, [ { label:"flow1", value:"value1" }, { label:"flow2", value:"value2" }, { label:"flow3", value:"value3" } ]);
			
			var radioButtonGroup:RadioButtonGroup = new RadioButtonGroup(this, 30, 460, RadioButtonGroup.VERTICAL, [ { label:"radioButton1" }, { label:"radioButton2" }, { label:"radioButton3" }, { label:"radioButton4" } ]);
			
			var fpsMeter:FPSMeter = new FPSMeter(this, 350, 400);
			fpsMeter.showChart = true;
		}
	}
	
}