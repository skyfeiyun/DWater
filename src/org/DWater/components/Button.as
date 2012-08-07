package org.DWater.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class Button extends Component
	{
		private static const UP:String = "up";
		private static const OVER:String = "over";
		private static const DOWN:String = "down";
		private static const DISABLED:String = "disabled";
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _text:String;
		
		private var _enabled:Boolean;
		private var _state:String;
		
		private var _icon:Sprite;
		
		public function Button(parent:Sprite, x:Number = 0, y:Number = 0, label:String = ""):void {
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "Button";
			_enabled = true;
			_state = UP;
			super(parent, x, y);
			this.label = label;
			mouseChildren = false;
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
			_textFormat.align = TextFormatAlign.CENTER;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			switch(_state) {
				case UP:
					_textFormat.color = _styleObject.upFontColor;
					graphics.beginFill(_styleObject.upFillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					break;
				case OVER:
					_textFormat.color = _styleObject.overFontColor;
					graphics.beginFill(_styleObject.overFillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					break;
				case DOWN:
					_textFormat.color = _styleObject.downFontColor;
					graphics.beginFill(_styleObject.downFillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					break;
				case DISABLED:
					_textFormat.color = _styleObject.disabledFontColor;
					graphics.beginFill(_styleObject.disabledFillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					break;
			}
			_textField.setTextFormat(_textFormat);
			_textField.x = (_rectWidth - _textField.width) / 2;
			_textField.y = (_rectHeight - _textField.height) / 2;
		}
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.MOUSE_OVER, onMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.MOUSE_OUT, onMouse);
		}
		protected function onMouse(evt:MouseEvent):void {
			switch(evt.type) {
				case MouseEvent.MOUSE_OVER:
					_state = OVER;
					break;
				case MouseEvent.MOUSE_UP:
					_state = UP;
					break;
				case MouseEvent.MOUSE_OUT:
					_state = UP;
					break;
				case MouseEvent.MOUSE_DOWN:
					_state = DOWN;
					break;
			}
			_changed = true;
		}
		
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			if (value< (_textField.width+_styleObject.paddingX)) {
				return;
			}
			_rectWidth = value;
			_changed=true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			if (value< (_textField.height+_styleObject.paddingY)) {
				return;
			}
			_rectHeight = value;
			_changed=true;
		}
		public function get label():String {
			return _text;
		}
		public function set label(value:String):void {
			_textField.text = value;
			_text = value;
			var idealWidth:Number = _textField.width + _styleObject.paddingX;
			if (idealWidth>_rectWidth) {
				_rectWidth = idealWidth;
			}
			_changed = true;
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(value:Boolean):void {
			if (value) {
				_state = UP;
				mouseEnabled = true;
			}else {
				_state = DISABLED;
				mouseEnabled = false;
			}
			_changed=true;
		}
		public function set icon(source:Sprite):void {
			_icon = source;
		}
		public function get icon():Sprite {
			return _icon;
		}
		internal function set labelSize(value:Number):void {
			_textFormat.size = value;
			_changed=true;
		}
	}
	
}