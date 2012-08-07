package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class NumberStepper extends Component 
	{
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _minusBtn:Button;
		private var _addBtn:Button;
		
		private var _minWidth:Number=0;
		
		private var _value:Number;
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _defaultValue:Number;
		private var _step:Number;
		public function NumberStepper(parent:Sprite, x:Number, y:Number,minValue:Number=0,maxValue:Number=100,defaultValue:Number=0,step:Number=1) 
		{	
			
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.selectable = false;
			_textField.embedFonts = true;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			addChild(_textField);
			_minusBtn = new Button(this, 0, 0, "-");
			_addBtn = new Button(this, 0, 0, "+");
			_name = "NumberStepper";
			super(parent, x, y);
			_step = step;
			_minValue=minValue;
			_maxValue=maxValue;
			_value = defaultValue;
			this.defaultValue = defaultValue;
			this.step = _step;
			this.minValue = _minValue;
			this.maxValue = _maxValue;
			this.value = _value;
		}
		override protected function initEvent():void {
			super.initEvent();
			_minusBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			_addBtn.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
		}
		private function onMouse(evt:MouseEvent):void {
			if (evt.target == _minusBtn) {
				value = value-step;
			}else if (evt.target == _addBtn) {
				value = value + step;
			}
		}
		override protected function refreshStyle():void {
			var lastStyle:Object = _styleObject;
			super.refreshStyle();
			if (isNaN(_rectWidth)||((_styleObject.rectWidth!=lastStyle.rectWidth)&&(lastStyle.rectWidth==_rectWidth))) {
				_rectWidth = _styleObject.rectWidth;
			}
			if (isNaN(_rectHeight)||((_styleObject.rectHeight!=lastStyle.rectHeight)&&(lastStyle.rectHeight==_rectHeight))) {
				_rectHeight = _styleObject.rectHeight;
			}
			_textField.x = _styleObject.buttonWidth;
			_textField.y = 2;
			_minusBtn.width = _addBtn.width =_styleObject.buttonWidth;
			_minusBtn.height = _addBtn.height = _styleObject.rectHeight;
			_minusBtn.labelSize =_addBtn.labelSize= _styleObject.labelSize;
			
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			graphics.lineStyle(1, _styleObject.borderColor);
			graphics.beginFill(_styleObject.backColor);
			graphics.drawRect(0, 0, _rectWidth, _rectHeight);
			graphics.endFill();
			_addBtn.x = _rectWidth - _styleObject.buttonWidth;
		}
		public function reset():void {
			this.value = _defaultValue;
		}
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			if (value< _minWidth) {
				return;
			}
			_rectWidth = value;
			_changed=true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			
		}
		
		public function get minValue():Number {
			return _minValue;
		}
		public function set minValue(value:Number):void {
			if (value>_maxValue&&!isNaN(_maxValue)) {
				return;
			}
			_minValue = value;
			_textField.text = (value+step).toString();
			var idealWidth:Number = _textField.width + _styleObject.buttonWidth * 2;
			if (_minWidth< idealWidth) {
				_minWidth = idealWidth;
				_changed=true;
			}
			width = Math.max(_minWidth, _rectWidth);
			this.value = _value;
		}
		public function get maxValue():Number {
			return _maxValue;
		}
		public function set maxValue(value:Number):void {
			if (value< _minValue&&!isNaN(_minValue)) {
				return;
			}
			_maxValue = value;
			_textField.text = (value+step).toString();
			var idealWidth:Number = _textField.width + _styleObject.buttonWidth * 2;
			if (_minWidth< idealWidth) {
				_minWidth = idealWidth;
				_changed=true;
			}
			width = Math.max(_minWidth, _rectWidth);
			this.value = _value;
		}
		public function get value():Number {
			return _value;
		}
		public function set value(num:Number):void {
			if (num< _minValue&&!isNaN(_minValue)) {
				num = _minValue;
			}
			if (num>_maxValue&&!isNaN(_maxValue)) {
				num = _maxValue;
			}
			_value = parseFloat(num.toFixed(8));
			_textField.text = value.toString();
		}
		public function get step():Number {
			return _step;
		}
		public function set step(value:Number):void {
			if (value>(_maxValue-_minValue)) {
				return;
			}
			_textField.text = (value+_maxValue).toString();
			var idealWidth:Number = _textField.width + _styleObject.buttonWidth * 2;
			if (_minWidth< idealWidth) {
				_minWidth = idealWidth;
			}
			_textField.text = (value+_minValue).toString();
			idealWidth = _textField.width + _styleObject.buttonWidth * 2;
			if (_minWidth< idealWidth) {
				_minWidth = idealWidth;
				_changed=true;
			}
			width = Math.max(_minWidth, _rectWidth);
			this.value = this.value;
		}
		public function get defaultValue():Number {
			return _defaultValue;
		}
		public function set defaultValue(value:Number):void {
			if (_minValue&&_maxValue) {
				_defaultValue = Math.min(Math.max(_minValue, value), _maxValue);
			}
		}
	}

}