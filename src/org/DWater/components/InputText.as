package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class InputText extends Component 
	{
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _focused:Boolean;
		public function InputText(parent:Sprite, x:Number, y:Number, text:String = "") 
		{
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.embedFonts = true;
			_textField.multiline = false;
			_textField.type = TextFieldType.INPUT;
			_focused = false;
			addChild(_textField);
			_name = "InputText";
			super(parent, x, y);
			this.text = text;
		}
		override protected function initEvent():void {
			super.initEvent();
			_textField.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, onFocus);
		}
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
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			_textField.width = value;
			_rectWidth = value;
			_changed = true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			
		}
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
			_textField.width = _rectWidth;
			_textField.height = _rectHeight;
			_textField.x = _styleObject.paddingX;
			_textField.y = _styleObject.paddintY;
		}
		private function onFocus(evt:FocusEvent):void {
			_changed = true;
			if (evt.type==FocusEvent.FOCUS_IN) {
				_focused = true;
			}else if (evt.type==FocusEvent.FOCUS_OUT) {
				_focused = false;
			}
		}
		public function get text():String {
			return _textField.text;
		}
		public function set text(value:String):void {
			_textField.text = value;
		}
		public function get password():Boolean {
			return _textField.displayAsPassword;
		}
		public function set password(value:Boolean):void {
			_textField.displayAsPassword = value;
		}
	}

}