package org.DWater.charts 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.components.Component;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class BarChart extends Component 
	{
		private var _base:Number;
		private var _data:Array;
		private var _textFormat:TextFormat
		private var _valueFormat:TextFormat;
		private var _textFields:Vector.<TextField>;
		private var _valueFields:Vector.<TextField>;
		private var _showValue:Boolean = false;
		private var _fixedLength:int;
		public function BarChart(parent:Sprite, x:Number, y:Number,data:Array=null,base:Number=10) 
		{
			_textFormat = new TextFormat();
			_valueFormat = new TextFormat();
			_textFields = new Vector.<TextField>();
			_valueFields = new Vector.<TextField>();
			_name = "BarChart";
			_fixedLength = -1;
			super(parent, x, y);
			this.base = base;
			this.data = data;
			this.showValue = true;
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		override protected function refreshStyle():void {
			var lastStyle:Object = _styleObject;
			super.refreshStyle();
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.RIGHT;
			
			_valueFormat.font = _styleObject.fontName;
			_valueFormat.size = _styleObject.fontSize;
			_valueFormat.color = _styleObject.fontColor;
			_valueFormat.align = TextFormatAlign.LEFT;
		}
		override protected function draw():void {
			super.draw();
			var a:int = _textFields.length;
			var padding:Number = _styleObject.barWidth + _styleObject.paddingBar;
			graphics.beginFill(_styleObject.barColor);
			for (var i:uint = 0; i < a; i++ ) {
				if (_fixedLength==-1){
					_valueFields[i].text = _data[i].value.toString();
				}else{
					_valueFields[i].text = _data[i].value.toFixed(_fixedLength);
				}
				
				_textFields[i].x = -(_styleObject.paddingX + _textFields[i].width);
				_textFields[i].y = (_styleObject.barWidth + _styleObject.paddingBar) * i + (_styleObject.barWidth - _textFields[i].height) / 2;
				_valueFields[i].x = _base * _data[i].value + _styleObject.paddingX;
				_valueFields[i].y = (_styleObject.barWidth + _styleObject.paddingBar) * i + (_styleObject.barWidth - _valueFields[i].height) / 2;
				
				graphics.drawRect(0, i * padding, _data[i].value * base, _styleObject.barWidth);
			}
			graphics.endFill();
			graphics.lineStyle(_styleObject.lineStrength, _styleObject.fontColor);
			graphics.moveTo(0, -_styleObject.paddingY);
			graphics.lineTo(0, (a-1) * padding + _styleObject.paddingY + _styleObject.barWidth);
		}
		public function findMax():uint {
			var max:Number = Number.MIN_VALUE;
			var index:uint;
			var a:uint = _data.length;
			for (var i:int = 0; i < a;i++ ) {
				if (_data[i].value>max) {
					max = _data[i].value;
					index = i;
				}
			}
			return index;
		}
		public function findMin():uint {
			var min:Number = Number.MAX_VALUE;
			var index:uint;
			var a:uint = _data.length;
			for (var i:int = 0; i < a;i++ ) {
				if (_data[i].value < min) {
					min = _data[i].value;
					index = i;
				}
			}
			return index;
		}
		public function getItemAt(index:uint):Object {
			if (_data.length==0||index>=_data.length) {
				return null;
			}else {
				return _data[index];
			}
		}
		public function addItemAt(value:Object, index:uint):void {
			if (!_data) {
				_data = [];
			}
			if (index>=_data.length) {
				return;
			}
			_data.splice(index, 0, value);
			var newText:TextField = new TextField();
			newText.autoSize = TextFieldAutoSize.RIGHT;
			newText.embedFonts = true;
			newText.selectable = false;
			newText.defaultTextFormat = _textFormat;
			newText.text = value.label;
			_textFields.splice(index, 0, newText);
			addChild(newText);
			
			newText = new TextField();
			newText.autoSize = TextFieldAutoSize.LEFT;
			newText.embedFonts = true;
			newText.selectable = false;
			newText.defaultTextFormat = _valueFormat;
			_valueFields.splice(index, 0, newText);
			if (showValue) {
				addChild(newText);
			}
			_changed = true;
		}
		public function removeItemAt(index:uint):void {
			if (!_data) {
				return;
			}
			if (index>=_data.length) {
				return;
			}
			_data.splice(index, 1);
			removeChild(_textFields.splice(index, 1)[0]);
			var valueText:TextField = _valueFields.splice(index, 1)[0];
			if (showValue) {
				removeChild(valueText);
			}
			_changed = true;
		}
		public function addItem(value:Object):void {
			if (!_data) {
				_data = [];
			}
			_data.push(value);
			var newText:TextField = new TextField();
			newText.autoSize = TextFieldAutoSize.RIGHT;
			newText.embedFonts = true;
			newText.selectable = false;
			newText.defaultTextFormat = _textFormat;
			newText.text = value.label;
			_textFields.push(newText);
			addChild(newText);
			
			newText = new TextField();
			newText.autoSize = TextFieldAutoSize.LEFT;
			newText.embedFonts = true;
			newText.selectable = false;
			newText.defaultTextFormat = _valueFormat;
			_valueFields.push(newText);
			if (showValue) {
				addChild(newText);
			}
			
			_changed = true;
		}
		public function removeItem(value:Object):void {
			var index:int = data.indexOf(value);
			if (index==-1) {
				return;
			}
			_data.splice(index, 1);
			removeChild(_textFields.splice(index, 1)[0]);
			var valueText:TextField = _valueFields.splice(index, 1)[0];
			if (showValue) {
				removeChild(valueText);
			}
			_changed = true;
		}
		public function get data():Array {
			return _data;
		}
		public function set data(value:Array):void {
			if (!value) {
				data = [];
				return;
			}
			var tempText:TextField;
			var tempValue:TextField;
			var a:uint = Math.min(value.length, _textFields.length);
			var b:uint = value.length;
			var c:uint = _textFields.length;
			for (var i:uint = 0; i < a;i++ ) {
				tempText = _textFields[i];
				tempText.text = value[i].label;
				
				tempValue = _valueFields[i];
			}
			for (; i < b;i++ ) {
				tempText = new TextField();
				tempText.autoSize = TextFieldAutoSize.RIGHT;
				tempText.embedFonts = true;
				tempText.selectable = false;
				tempText.defaultTextFormat = _textFormat;
				tempText.text = value[i].label;
				
				tempValue = new TextField();
				tempValue.autoSize = TextFieldAutoSize.LEFT;
				tempValue.embedFonts = true;
				tempValue.selectable = false;
				tempValue.defaultTextFormat = _valueFormat;
				
				_textFields.push(tempText);
				_valueFields.push(tempValue);
				addChild(tempText);
				if (showValue) {
					addChild(tempValue);
				}
			}
			for (; i < c;i++ ) {
				removeChild(_textFields.pop());
				tempValue = _valueFields.pop();
				if (_showValue) {
					removeChild(tempValue);
				}
			}
			_data = value;
			_changed = true;
		}
		public function get base():Number {
			return _base;
		}
		public function set base(value:Number):void {
			if (value<0) {
				return;
			}
			_base = value;
			_changed = true;
		}
		public function get showValue():Boolean {
			return _showValue;
		}
		public function set showValue(value:Boolean):void {
			_showValue = value;
			var a:uint = _valueFields.length;
			if (_showValue) {
				for (var i:int = 0; i < a;i++ ) {
					addChild(_valueFields[i]);
				}
			}else {
				for (i = 0; i < a;i++ ) {
					removeChild(_valueFields[i]);
				}
			}
		}
		public function get fixedLength():int {
			return _fixedLength;
		}
		public function set fixedLength(value:int):void {
			if (value < 0) {
				value = -1;
			}else {
				_fixedLength = value;
			}
			_changed = true;
		}
	}

}