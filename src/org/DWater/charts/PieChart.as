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
	public class PieChart extends Component 
	{
		private var _radius:Number;
		private var _data:Array;
		private var _textFormat:TextFormat
		private var _valueFormat:TextFormat;
		private var _textFields:Vector.<TextField>;
		private var _valueFields:Vector.<TextField>;
		private var _showValue:Boolean = false;
		
		private var _fixedLength:int;
		
		public function PieChart(parent:Sprite, x:Number, y:Number,data:Array=null) 
		{
			_textFormat = new TextFormat();
			_valueFormat = new TextFormat();
			
			_textFields = new Vector.<TextField>();
			_valueFields = new Vector.<TextField>();
			_name = "PieChart";
			_data = [];
			_fixedLength = 0;
			super(parent, x, y);
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
			_textFormat.size = _styleObject.labelFontSize;
			_textFormat.color = _styleObject.labelFontColor;
			_textFormat.align = TextFormatAlign.RIGHT;
			
			_valueFormat.font = _styleObject.fontName;
			_valueFormat.size = _styleObject.valueFontSize;
			_valueFormat.color = _styleObject.valueFontColor;
			_valueFormat.align = TextFormatAlign.LEFT;
			if (isNaN(_radius)||((_styleObject.outerRadius!=lastStyle.outerRadius)&&(lastStyle.outerRadius==_radius))) {
				_radius = _styleObject.outerRadius;
			}
		}
		override protected function draw():void {
			super.draw();
			var a:int = _data.length;
			var innerRadius:Number = _radius / _styleObject.outerRadius * _styleObject.innerRadius;
			var offsetX:Number = _styleObject.paddingX+2*_radius;
			var offsetY:Number = _styleObject.paddingY;
			var centerX:Number = _radius;
			var centerY:Number = _radius;
			var color:uint;
			var total:Number = 0;
			var percent:Number;
			var pilePercent:Number = 0;
			var start:Number;
			var end:Number;
			var j:int;
			for (var i:int = 0; i < a;i++ ) {
				total += _data[i].value;
			}
			for (i = 0; i < a; i++ ) {
				if (_data[i].color) {
					color = _data[i].color;
				}else {
					color = Math.random() * 0xFFFFFF;
				}
				percent = _data[i].value / total*100;
				graphics.beginFill(color);
				graphics.moveTo(innerRadius * Math.sin(Math.PI *  pilePercent/50)+centerX, -innerRadius * Math.cos(Math.PI * pilePercent/50)+centerY);
				graphics.lineTo(_radius * Math.sin(Math.PI *  pilePercent/50)+centerX, -_radius * Math.cos(Math.PI *  pilePercent/50)+centerY);
				
				start = pilePercent / 50 * Math.PI / 0.01;
				pilePercent += percent;
				end = pilePercent / 50 * Math.PI / 0.01;
				for (j=start; j<=end; j++) {
					graphics.curveTo(Math.sin((j-0.5)*0.01)*_radius+centerX,-Math.cos((j-0.5)*0.01)*_radius+centerY,Math.sin(j*0.01)*_radius+centerX,-Math.cos(j*0.01)*_radius+centerY);
				}
				graphics.lineTo(innerRadius * Math.sin(Math.PI *  pilePercent/50)+centerX, -innerRadius * Math.cos(Math.PI *  pilePercent/50)+centerY);
				for (j=end; j>=start; j--) {
					graphics.curveTo(Math.sin((j-0.5)*0.01)*innerRadius+centerX,-Math.cos((j-0.5)*0.01)*innerRadius+centerY,Math.sin(j*0.01)*innerRadius+centerX,-Math.cos(j*0.01)*innerRadius+centerY);
				}
				graphics.endFill();
				
				
				if (_fixedLength==-1) {
					_valueFields[i].text = percent.toString()+"%";
				}else {
					_valueFields[i].text = percent.toFixed(_fixedLength)+"%";
				}
				graphics.beginFill(color);
				graphics.drawRect(offsetX, offsetY, _styleObject.labelWidth, _styleObject.labelHeight);
				graphics.endFill();
				
				_valueFields[i].x = offsetX +(_styleObject.labelWidth- _valueFields[i].width) / 2;
				_valueFields[i].y = offsetY +(_styleObject.labelHeight - _valueFields[i].height) / 2;
				
				_textFields[i].x = offsetX + _styleObject.labelWidth + _styleObject.labelPaddingX;
				_textFields[i].y = offsetY +(_styleObject.labelHeight - _textFields[i].height) / 2;
				
				offsetY += _styleObject.labelPaddingY + _styleObject.labelHeight;
			}
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
			newText.autoSize = TextFieldAutoSize.LEFT;
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
			newText.autoSize = TextFieldAutoSize.LEFT;
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
		public function get radius():Number {
			return _radius;
		}
		public function set radius(value:Number):void {
			if (value<0) {
				return;
			}
			_radius = value;
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