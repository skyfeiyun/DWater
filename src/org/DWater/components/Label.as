package org.DWater.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.utils.Style;
	
	/**
	 * ...
	 * @author dongdong
	 */
	public class Label extends Component 
	{	
		private var _text:String;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _border:Boolean;
		
		public function Label(parent:Sprite, x:Number = 0, y:Number = 0, text:String = ""):void {
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "Label";
			super(parent, x, y);
			this.text = text;
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
			_textFormat.align = TextFormatAlign.CENTER;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			if (_border) {
				graphics.beginFill(_styleObject.fillColor);
				graphics.moveTo(_offsetX, _offsetY);
				graphics.lineTo(_offsetX, _rectHeight + _styleObject.arcHeight+_offsetY);
				graphics.lineTo(_styleObject.arcWidth+_offsetX, _rectHeight+_offsetY);
				graphics.lineTo(_rectWidth+_offsetX, _rectHeight+_offsetY);
				graphics.lineTo(_rectWidth+_offsetX, _offsetY);
				graphics.lineTo(_offsetX, _offsetY);
			}
			_textField.x = (_rectWidth - _textField.width) / 2+_offsetX;
			_textField.y = (_rectHeight - _textField.height) / 2+_offsetY;
		}
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			if (value< (_textField.width+_styleObject.paddingX)) {
				return;
			}
			_rectWidth = value;
			_changed = true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			if (value< (_textField.height+_styleObject.paddingY)) {
				return;
			}
			_rectHeight = value;
			_changed = true;
		}
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_textField.text = value;
			_text = value;
			var idealWidth:Number = _textField.width + _styleObject.paddingX;
			if (idealWidth>_rectWidth) {
				_rectWidth = idealWidth;
			}
			_changed=true;
		}
		public function get border():Boolean {
			return _border;
		}
		public function set border(value:Boolean):void {
			_border = value;
			if (_border) {
				_offsetX = 0;
				_offsetY = -(_rectHeight + _styleObject.arcHeight);
			}else {
				_offsetX = 0;
				_offsetY = 0;
			}
			_changed=true;
		}
	}
	
}