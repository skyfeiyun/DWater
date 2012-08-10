package org.DWater.charts 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.components.Component;
	
	/**
	 * LineChart is often used to show some datas. 
	 */
	public class LineChart extends Component 
	{
		private var _base:Number;
		private var _data:Array;
		private var _textFormat:TextFormat
		private var _valueFormat:TextFormat;
		private var _textFields:Vector.<TextField>;
		private var _valueFields:Vector.<TextField>;
		private var _showValue:Boolean = false;
		
		private var _fixedLength:int;
		
		private var _startText:TextField;
		private var _endText:TextField;
		
		private var _startWithZero:Boolean;
		private var _labelPadding:Number;
		public function LineChart(parent:Sprite, x:Number, y:Number,data:Array=null,base:Number=10) 
		{
			_textFormat = new TextFormat();
			_valueFormat = new TextFormat();
			_startText = new TextField();
			_startText.autoSize = TextFieldAutoSize.RIGHT;
			_startText.embedFonts = true;
			_startText.selectable = false;
			_endText = new TextField();
			_endText.autoSize = TextFieldAutoSize.RIGHT;
			_endText.embedFonts = true;
			_endText.selectable = false;
			addChild(_startText);
			addChild(_endText);
			
			_textFields = new Vector.<TextField>();
			_valueFields = new Vector.<TextField>();
			_name = "LineChart";
			_startWithZero = true;
			_data = [];
			_base = base;
			_fixedLength = -1;
			super(parent, x, y);
			this.data = data;
			this.showValue = true;
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			
		}
		/**
		 * @private
		 */
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
			
			_startText.defaultTextFormat = _valueFormat;
			_endText.defaultTextFormat = _valueFormat;
			
			_startText.x = _styleObject.baseOffsetX;
			_startText.y = _styleObject.baseOffsetY;
			_endText.x = _styleObject.baseOffsetX;
			
			if (isNaN(_labelPadding)||((_styleObject.labelPadding!=lastStyle.labelPadding)&&(lastStyle.labelPadding==_labelPadding))) {
				_labelPadding = _styleObject.paddingX;
			}
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			var a:int = _data.length;
			if (a==0) {
				return;
			}
			var endX:Number = a * _labelPadding;
			var endY:Number;
			var startValue:Number;
			var endValue:Number = _data[findMax()].value;
			if (_startWithZero) {
				startValue = 0;
			}else {
				startValue = _data[findMin()].value;
			}
			endY = (startValue-endValue) * _base;
			_endText.y = _styleObject.baseOffsetY + endY;
			
			graphics.lineStyle(_styleObject.lineStrength, _styleObject.lineColor);
			graphics.moveTo(0, 0);
			graphics.lineTo(0, endY);
			graphics.moveTo(0, 0);
			graphics.lineTo(endX, 0);
			
			var dotX:Number = _labelPadding / 2;
			var dotY:Number = -(_data[0].value-startValue) * _base;
			
			if (_fixedLength==-1) {
				_startText.text = startValue.toString();
				_endText.text = endValue.toString();
				_valueFields[0].text = _data[0].value.toString();
			}else {
				_startText.text = startValue.toFixed(_fixedLength);
				_endText.text = endValue.toFixed(_fixedLength);
				_valueFields[0].text = _data[0].value.toFixed(_fixedLength);
			}
			_valueFields[0].x = dotX - _valueFields[0].width / 2;
			_valueFields[0].y = dotY - _valueFields[0].height - _styleObject.labelPadding;
			_textFields[0].x = dotX - _textFields[0].width / 2;
			_textFields[0].y = _styleObject.paddingY;
			
			graphics.moveTo(dotX, dotY);
			graphics.beginFill(_styleObject.lineColor);
			graphics.drawCircle(dotX,dotY , _styleObject.dotRadius);
			graphics.endFill();
			for (var i:uint = 1; i < a; i++ ) {
				dotX += _labelPadding;
				dotY = -(_data[i].value-startValue) * _base;
				if (_fixedLength==-1) {
					_valueFields[i].text = _data[i].value.toString();
				}else {
					_valueFields[i].text = _data[i].value.toFixed(_fixedLength);
				}
				_valueFields[i].x = dotX - _valueFields[i].width / 2;
				_valueFields[i].y = dotY - _valueFields[i].height - _styleObject.labelPadding;
				_textFields[i].x = dotX - _textFields[0].width / 2;
				_textFields[i].y = _styleObject.paddingY;
				
				graphics.lineTo(dotX, dotY);
				graphics.beginFill(_styleObject.lineColor);
				graphics.drawCircle(dotX,dotY , _styleObject.dotRadius);
				graphics.endFill();
			}
		}
		/**
		 * @copy BarChart#findMax()
		 */
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
		/**
		 * @copy BarChart#findMin()
		 */
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
		/**
		 * @copy BarChart#getItemAt()
		 */
		public function getItemAt(index:uint):Object {
			if (_data.length==0||index>=_data.length) {
				return null;
			}else {
				return _data[index];
			}
		}
		/**
		 * @copy BarChart#addItemAt()
		 */
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
		/**
		 * @copy BarChart#removeItemAt()
		 */
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
		/**
		 * @copy BarChart#addItem()
		 */
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
		/**
		 * @copy BarChart#removeItem()
		 */
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
		/**
		 * @copy BarChart#data
		 */
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
		/**
		 * @copy BarChart#base
		 */
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
		/**
		 * @copy BarChart#showValue
		 */
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
		/**
		 * If the y-axis should start with zero.
		 */
		public function get startWithZero():Boolean {
			return _startWithZero;
		}
		public function set startWithZero(value:Boolean):void {
			_startWithZero = value;
			_changed = true;
		}
		/**
		 * Padding between labels.
		 */
		public function get labelPadding():Number {
			return _labelPadding;
		}
		public function set labelPadding(value:Number):void {
			_labelPadding = value;
			_changed = true;
		}
		/**
		 * @copy BarChart#fixedLength
		 */
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