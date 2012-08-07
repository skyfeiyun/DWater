package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class ProgressBar extends Component 
	{
		private var _percent:uint;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		public function ProgressBar(parent:Sprite, x:Number, y:Number) 
		{
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "ProgressBar";
			super(parent, x, y);
			_textField.text = "0%";
		}
		override protected function refreshStyle():void {
			super.refreshStyle();
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			
			var thickness:Number = _styleObject.outerRadius - _styleObject.innerRadius;
			var radius:Number = (_styleObject.outerRadius + _styleObject.innerRadius) / 2;
			
			graphics.lineStyle(thickness, _styleObject.backColor);
			graphics.drawCircle(0, 0, radius);
			graphics.beginFill(_styleObject.frontColor);
			var a:Number = _percent / 50 * Math.PI / 0.01;
			
			graphics.lineStyle(undefined,_styleObject.frontColor);
			graphics.moveTo(0,- _styleObject.innerRadius);
		    for (var i:int=0; i<=a; i++) {
				graphics.curveTo(Math.sin((i-0.5)*0.01)*_styleObject.innerRadius,-Math.cos((i-0.5)*0.01)*_styleObject.innerRadius,Math.sin(i*0.01)*_styleObject.innerRadius,-Math.cos(i*0.01)*_styleObject.innerRadius);
			}
			graphics.lineTo(Math.sin(a * 0.01) * _styleObject.outerRadius, -Math.cos(a * 0.01) * _styleObject.outerRadius);
			for (i=a; i>=0; i--) {
				graphics.curveTo(Math.sin((i-0.5)*0.01)*_styleObject.outerRadius,-Math.cos((i-0.5)*0.01)*_styleObject.outerRadius,Math.sin(i*0.01)*_styleObject.outerRadius,-Math.cos(i*0.01)*_styleObject.outerRadius);
			}
			graphics.lineTo(0, - _styleObject.innerRadius);
			graphics.endFill();
			
			graphics.beginFill(_styleObject.frontColor);
			graphics.drawCircle(0, -radius, thickness/2);
			graphics.drawCircle(Math.sin(a * 0.01) * radius, -Math.cos(a * 0.01) * radius,thickness/2);
			graphics.endFill();
			
			_textField.x = -_textField.width / 2;
			_textField.y = -_textField.height/ 2;
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		public function set percent(value:uint):void {
			_percent = value % 100;
			_textField.text = _percent.toString()+"%";
			_changed=true;
		}
		public function get percent():uint {
			return _percent;
		}
	}

}