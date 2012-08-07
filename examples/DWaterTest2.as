package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import org.DWater.components.Calendar;
	import org.DWater.components.List;
	import org.DWater.components.Panel;
	import org.DWater.components.PopupButton;
	import org.DWater.components.Slider;
	import org.DWater.components.TextArea;
	import org.DWater.components.Window;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class DWaterTest2 extends Sprite 
	{
		[Embed(source="/../assets/testPic.jpg")]
		public var Picture:Class;
		public function DWaterTest2() 
		{
			var calendar:Calendar = new Calendar(this, 30, 30);
			var slider1:Slider = new Slider(this, 220, 50, Slider.HORIZON, 0, 100, 0);
			slider1.showLabel = true;
			slider1.showValue = true;
			slider1.width = 100;
			
			var slider2:Slider = new Slider(this, 430, 30, Slider.VERTICAL, 0, 100, 0);
			slider2.liveDrag = true;
			slider2.showLabel = true;
			slider2.showValue = true;
			slider2.width = 5;
			slider2.height = 100;
			
			var textArea:TextArea = new TextArea(this, 30, 190, "DWater belongs to DD&WaterSpeaker.");
			
			
			var window:Window = new Window(this, 240, 190, "Window");
			var pic1:Bitmap = new Picture();
			window.addComponent(pic1);
			window.draggable = true;
			
			var panel:Panel = new Panel(this, 30, 350);
			var pic2:Bitmap = new Picture();
			panel.addComponent(pic2);
			
			var listData:Array = [];
			for (var i:int = 0; i < 100;i++ ) {
				listData.push( { label:"item" + i.toString()});
			}
			var list:List = new List(this, 240, 350, listData);
			list.itemHeight = 40;
			
			var popUpButotn:PopupButton = new PopupButton(this, 400, 350);
			popUpButotn.width = 120;
			for (i = 0; i < 20;i++ ) {
				popUpButotn.addItem( { label:"selectItem(DD)" + i.toString()} );
			}
		}
	}

}