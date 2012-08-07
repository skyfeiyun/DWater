package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class Slider extends Component 
	{
		private static const UP:String = "up";
		private static const OVER:String = "over";
		private static const DOWN:String = "down";
		
		public static const HORIZON:String = "horizon";
		public static const VERTICAL:String = "vertical";
		
		private var _direction:String;
		
		private var _controlBar:Sprite;
		
		private var _state:String;
		private var _valueLabel:Label;
		private var _minText:TextField;
		private var _maxText:TextField;
		private var _textFormat:TextFormat;
		private var _minValue:Number;
		private var _maxValue:Number;
		private var _value:Number;
		private var _preValue:Number;
		private var _defaultValue:Number;
		private var _showValue:Boolean;
		private var _showLabel:Boolean;
		private var _liveDrag:Boolean;
		
		public function Slider(parent:Sprite, x:Number, y:Number,direction:String="horizon",minValue:Number=0,maxValue:Number=100,defaultValue:Number=0) 
		{
			_textFormat = new TextFormat();
			_minText = new TextField();
			_minText.selectable = false;
			_minText.embedFonts = true;
			_minText.autoSize = TextFieldAutoSize.LEFT;
			
			_maxText = new TextField();
			_maxText.selectable = false;
			_maxText.embedFonts = true;
			_maxText.autoSize = TextFieldAutoSize.LEFT;
			
			_controlBar = new Sprite();
			addChild(_controlBar);
			
			_valueLabel = new Label(null);
			_valueLabel.border = true;
			_name = "Slider";
			_minValue = minValue;
			_maxValue=maxValue;
			_value = defaultValue;
			_showValue = false;
			_state = UP;	
			_direction = HORIZON;
			this.defaultValue = defaultValue;
			this.minValue = _minValue;
			this.maxValue = _maxValue;
			this.value = _value;
			super(parent, x, y);
			this.direction = direction;
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
			
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			
			_minText.defaultTextFormat = _textFormat;
			_maxText.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			_controlBar.graphics.clear();
			_minText.setTextFormat(_textFormat);
			_maxText.setTextFormat(_textFormat);
			if (_direction == Slider.HORIZON) {
				graphics.beginFill(_styleObject.backColor);
				graphics.drawRect(_offsetX, _offsetY, _rectWidth, _rectHeight);
				graphics.endFill();
				_minText.y = (_rectHeight - _minText.height) / 2;
				_maxText.x = _minText.width + 2 * _styleObject.padding + _rectWidth;
				_maxText.y = _minText.y;
				switch(_state) {
					case UP:
						_controlBar.graphics.beginFill(_styleObject.barUpColor);
						if (contains(_valueLabel)) {
							removeChild(_valueLabel);
						}
						break;
					case OVER:
						_controlBar.graphics.beginFill(_styleObject.barOverColor);
						if (!contains(_valueLabel)&&_showLabel) {
							addChild(_valueLabel);
						}
						break;
					case DOWN:
						_controlBar.graphics.beginFill(_styleObject.barOverColor);
						if (!contains(_valueLabel)&&_showLabel) {
							addChild(_valueLabel);
						}
						break;
						
				}
				_controlBar.graphics.drawRect(0, 0, _styleObject.barWidth, _rectHeight/_styleObject.rectHeight*_styleObject.barHeight);
				_valueLabel.text = Math.max(Math.min((_minValue + (_controlBar.x - offsetX) / (_rectWidth - _controlBar.width) * (_maxValue-_minValue)),_maxValue),_minValue).toFixed(2);
				_controlBar.graphics.endFill();
				_valueLabel.x = _controlBar.x;
				_valueLabel.y = _controlBar.y - _styleObject.labelPadding;
				if (_state!=DOWN) {
					_controlBar.x = _offsetX + (_value-_minValue) / (_maxValue-_minValue) * (_rectWidth-_styleObject.barWidth);
					_controlBar.y = _offsetY;
				}
			}else {
				graphics.beginFill(_styleObject.backColor);
				graphics.drawRect(_offsetX, _offsetY, _rectWidth, _rectHeight);
				graphics.endFill();
				_minText.x = (_rectWidth - _minText.width) / 2;
				_maxText.x = (_rectWidth - _maxText.width) / 2;
				_maxText.y = _minText.height + 2 * _styleObject.padding + _rectHeight;
				switch(_state) {
					case UP:
						_controlBar.graphics.beginFill(_styleObject.barUpColor);
						if (contains(_valueLabel)) {
							removeChild(_valueLabel);
						}
						break;
					case OVER:
						_controlBar.graphics.beginFill(_styleObject.barOverColor);
						if (!contains(_valueLabel)&&_showLabel) {
							addChild(_valueLabel);
						}
						break;
					case DOWN:
						_controlBar.graphics.beginFill(_styleObject.barOverColor);
						if (!contains(_valueLabel)&&_showLabel) {
							addChild(_valueLabel);
						}
						break;
				}
				_controlBar.graphics.drawRect(0, 0, _rectWidth/_styleObject.rectHeight*_styleObject.barHeight, _styleObject.barWidth);
				_valueLabel.text = Math.max(Math.min((_minValue + (_controlBar.y - _offsetY) / (_rectHeight - _controlBar.height) * (_maxValue-_minValue)),_maxValue),_minValue).toFixed(2);
				_controlBar.graphics.endFill();
				_valueLabel.x = _controlBar.x+_controlBar.width+ _styleObject.labelPadding;
				_valueLabel.y = _controlBar.y ;
				if (_state!=DOWN) {
					_controlBar.x = _offsetX ;
					_controlBar.y = _offsetY+ (_value-_minValue) / (_maxValue-_minValue) * (_rectHeight-_styleObject.barWidth);
				}
			}
		}
		override protected function initEvent():void {
			super.initEvent();
			
			_controlBar.addEventListener(MouseEvent.MOUSE_OVER, onMouse);
			_controlBar.addEventListener(MouseEvent.MOUSE_OUT, onMouse);
			_controlBar.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onStage);
		}
		private function onStage(evt:Event):void {
			if (evt.type==Event.ADDED_TO_STAGE) {
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			}else {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouse);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			}
		}
		private function onMouse(evt:MouseEvent):void {
			switch(evt.type) {
				case MouseEvent.MOUSE_OVER:
					if(_state!=DOWN) {
						_state = OVER;
						_changed = true;
					}
					break;
				case MouseEvent.MOUSE_OUT:
					if(_state==OVER) {
						_state = UP;
						_changed = true;
					}
					break;
				case MouseEvent.MOUSE_UP:
					_state = UP;
					if (_direction==HORIZON) {
						value = _minValue + (_controlBar.x - offsetX) / (_rectWidth - _controlBar.width) * (_maxValue-_minValue);
					}else {
						value = _minValue + (_controlBar.y - _offsetY) / (_rectHeight - _controlBar.height) * (_maxValue-_minValue);
					}
					dispatchEvent(new Event(Event.CHANGE));
					_controlBar.stopDrag();
					break;
				case MouseEvent.MOUSE_DOWN:
					_state = DOWN;
					if (_direction==HORIZON) {
						_controlBar.startDrag(false, new Rectangle(_offsetX, 0, _rectWidth-_styleObject.barWidth+2, 0));
					}else {
						_controlBar.startDrag(false, new Rectangle(0, _offsetY, 0, _rectHeight-_styleObject.barWidth+2));
					}
					break;
				case MouseEvent.MOUSE_MOVE:
					if (_state==DOWN) {
						if (_liveDrag) {
							if (_direction==HORIZON) {
								value = _minValue + (_controlBar.x - offsetX) / (_rectWidth - _controlBar.width) * (_maxValue-_minValue);
							}else {
								value = _minValue + (_controlBar.y - _offsetY) / (_rectHeight - _controlBar.height) * (_maxValue-_minValue);
							}
							dispatchEvent(new Event(Event.CHANGE));
						}
						_changed = true;
					}
					break;
			}
		}
		public function reset():void {
			value = _defaultValue;
		}
		public function get showValue():Boolean {
			return _showValue;
		}
		public function set showValue(value:Boolean):void {
			if (_direction==HORIZON) {
				if (value) {
					if (!contains(_minText)) {
						addChild(_minText);
						addChild(_maxText);
					}
					_offsetX = _minText.width + _styleObject.padding;
					_offsetY = 0;
				}else {
					if (contains(_minText)) {
						removeChild(_minText);
						removeChild(_maxText);
					}
					_offsetX =0;
					_offsetY = 0;
				}
			}else {
				if (value) {
					if (!contains(_minText)) {
						addChild(_minText);
						addChild(_maxText);
					}
					_offsetX = 0;
					_offsetY = _minText.height + _styleObject.padding;
				}else {
					if (contains(_minText)) {
						removeChild(_minText);
						removeChild(_maxText);
					}
					_offsetX = 0;
					_offsetY = 0;
				}
			}
			_showValue = value;
			_changed = true;
		}
		public function get showLabel():Boolean {
			return _showLabel;
		}
		public function set showLabel(value:Boolean):void {
			_showLabel = value;
			if (value) {
				if (!contains(_valueLabel)) {
					addChild(_valueLabel);
				}
			}else {
				if (contains(_valueLabel)) {
					removeChild(_valueLabel);
				}
			}
			_changed = true;
		}
		
		public function get liveDrag():Boolean {
			return _liveDrag;
		}
		public function set liveDrag(value:Boolean):void {
			_liveDrag = value;
		}
		override public function get width():Number {
			return _rectWidth;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set width(value:Number):void {
			if (_direction==HORIZON) {
				if (value< _styleObject.barWidth) {
					return;
				}
				_rectWidth = value;
			}else {
				if (value>0) {
					_rectWidth = value;
				}
			}
			_changed=true;
		}
		override public function set height(value:Number):void {
			if (_direction==VERTICAL) {
				if (value< _styleObject.barWidth) {
					return;
				}
				_rectHeight = value;
			}else {
				if (value>0) {
					_rectHeight = value;
				}
			}
			_changed=true;
		}
		
		public function get minValue():Number {
			return _minValue;
		}
		public function set minValue(value:Number):void {
			if (value>_maxValue&&!isNaN(_maxValue)) {
				return;
			}
			_minValue = value;
			_minText.text = value.toString();
			_changed = true;
		}
		public function get maxValue():Number {
			return _maxValue;
		}
		public function set maxValue(value:Number):void {
			if (value<_minValue&&!isNaN(_minValue)) {
				return;
			}
			_maxValue = value;
			_maxText.text = value.toString();
			_changed = true;
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
			_value = num;
			_changed = true;
		}
		public function get defaultValue():Number {
			return _defaultValue;
		}
		public function set defaultValue(value:Number):void {
			if (_minValue&&_maxValue) {
				_defaultValue = Math.min(Math.max(_minValue, value), _maxValue);
			}
		}
		public function get direction():String {
			return _direction;
		}
		public function set direction(value:String):void {
			if (value==HORIZON) {
				if (showValue) {
					_offsetX = _minText.width + _styleObject.padding;
					_offsetY = 0;
				}else {
					_offsetX =0;
					_offsetY = 0;
				}
			}else {
				if (showValue) {
					_offsetX = 0;
					_offsetY = _minText.height + _styleObject.padding;
				}else {
					_offsetX = 0;
					_offsetY = 0;
				}
			}
			if (_direction!=value) {
				var temp:Number = _rectWidth;
				_rectWidth = _rectHeight;
				_rectHeight = temp;
			}
			_direction = value;
			_changed = true;
		}
	}

}