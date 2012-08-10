package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * TextArea if often used to type in multi line text.
	 * @author Dong Dong
	 */
	public class TextArea extends Component 
	{
		
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _focused:Boolean;
		private var _slider:Slider;
		private var _scrollRect:Rectangle;
		public function TextArea(parent:Sprite, x:Number, y:Number, text:String = "") 
		{
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.embedFonts = true;
			_textField.multiline = true;
			_textField.wordWrap = true;
			_textField.type = TextFieldType.INPUT;
			_focused = false;
			addChild(_textField);
			_slider = new Slider(null, 0, 0, Slider.VERTICAL);
			_slider.liveDrag = true;
			_name = "TextArea";
			_scrollRect = new Rectangle();
			super(parent, x, y);
			this.text = text;
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			_textField.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocus);
			
			_slider.addEventListener(Event.CHANGE, onScroll);
		}
		private function onScroll(evt:Event):void {
			_textField.scrollV = _slider.value / 100 * (_textField.maxScrollV-1)+1;
		}
		private function onFocus(evt:FocusEvent):void {
			_changed = true;
			if (evt.type==FocusEvent.FOCUS_IN) {
				_focused = true;
			}else if (evt.type==FocusEvent.FOCUS_OUT) {
				_focused = false;
			}
		}
		/**
		 * @private
		 */
		override protected function update(evt:Event):void {
			if (_textField.height< _textField.textHeight) {
				if (!contains(_slider)) {
					addChild(_slider);
				}
			}else {
				if (contains(_slider)) {
					removeChild(_slider);
				}
			}
			if (_focused) {
				_slider.value = (_textField.scrollV-1) / (_textField.maxScrollV-1)*100;
			}
			super.update(evt);
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			if (_focused) {
				graphics.lineStyle(_styleObject.borderThickness, _styleObject.borderOnColor);
			}else {
				graphics.lineStyle(_styleObject.borderThickness, _styleObject.borderOutColor);
			}
			graphics.beginFill(_styleObject.backColor);
			graphics.drawRect(0, 0, _rectWidth, _rectHeight);
			graphics.endFill();
		}
		override public function set width(value:Number):void {
			_textField.width = value-_slider.width-2*_styleObject.paddingX;
			_rectWidth = value;
			_slider.x = value - _slider.width;
			_scrollRect.width = _textField.width;
			_changed = true;
		}
		
		override public function set height(value:Number):void {
			_textField.height = value;
			_rectHeight = value-2*_styleObject.paddintY;
			_slider.height = value;
			_scrollRect.height = _textField.height;
			_changed = true;
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			var lastStyle:Object = _styleObject;
			super.refreshStyle();
			if (isNaN(_rectWidth)||((_styleObject.rectWidth!=lastStyle.rectWidth)&&(lastStyle.rectWidth==_rectWidth))) {
				_rectWidth = _styleObject.rectWidth;
			}
			if (isNaN(_rectHeight)||(_styleObject.rectHeight!=lastStyle.rectHeight)) {
				_rectHeight = _styleObject.rectHeight;
			}
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			_textField.defaultTextFormat = _textFormat;
			_textField.width = _rectWidth - _slider.width - 2 * _styleObject.paddingX;
			_textField.height = _rectHeight - 2 * _styleObject.paddingY;
			_scrollRect.width = _textField.width;
			_scrollRect.height = _textField.height;
			_textField.scrollRect = _scrollRect;
			_textField.x = _styleObject.paddingX;
			_textField.y = _styleObject.paddintY;
			_slider.x = _rectWidth - _slider.width;
			_slider.height = _rectHeight;
		}
		/**
		 * @copy InputText#text
		 */
		public function get text():String {
			return _textField.text;
		}
		public function set text(value:String):void {
			_textField.text = value;
		}
		/**
		 * @copy InputText#password
		 */
		public function get password():Boolean {
			return _textField.displayAsPassword;
		}
		public function set password(value:Boolean):void {
			_textField.displayAsPassword = value;
		}
	}

}