package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.events.DWaterSelectedEvent;
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class RadioButton extends Component 
	{
		private var _group:RadioButtonGroup;
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _text:String;
		private var _data:Object;
		
		private var _enabled:Boolean;
		
		private var _selected:Boolean;
		
		public function RadioButton(parent:Sprite, x:Number = 0, y:Number = 0, data:Object=null):void {
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "RadioButton";
			_enabled = true;
			_selected = false;
			super(parent, x, y);
			this.data = data;
		}
		override protected function refreshStyle():void {
			super.refreshStyle();
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			_rectWidth = _rectHeight = 0;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			if (_enabled) {
				graphics.beginFill(_styleObject.enabledOuterColor);
				graphics.drawCircle(_styleObject.outerSize, _styleObject.outerSize, _styleObject.outerSize);
				graphics.endFill();
				if (_selected) {
					graphics.beginFill(_styleObject.innerColor);
					graphics.drawCircle(_styleObject.outerSize, _styleObject.outerSize, _styleObject.innerSize);
					graphics.endFill();
				}
			}else {
				graphics.beginFill(_styleObject.disabledOuterColor);
				graphics.drawCircle(_styleObject.outerSize, _styleObject.outerSize, _styleObject.outerSize);
				graphics.endFill();
				if (_selected) {
					graphics.beginFill(_styleObject.innerColor);
					graphics.drawCircle(_styleObject.outerSize, _styleObject.outerSize, _styleObject.innerSize);
					graphics.endFill();
				}
			}
			_textField.x = 2*_styleObject.outerSize + _styleObject.padding;
			_textField.y = (2*_styleObject.outerSize-_textField.textHeight) / 2-2;
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		public function get label():String {
			return _text;
		}
		public function set label(value:String):void {
			if (!value) {
				return;
			}
			_textField.text = value;
			_text = value;
			_changed=true;
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(value:Boolean):void {
			_enabled = value;
			if (value) {
				mouseEnabled = true;
				mouseChildren = true;
			}else {
				mouseEnabled = false;
				mouseChildren = false;
			}
			_changed=true;
		}
		internal function get selected():Boolean {
			return _selected;
		}
		internal function set selected(value:Boolean):void {
			_selected = value;
			_changed=true;
		}
		public function get data():Object {
			return _data;
		}
		public function set data(value:Object):void {
			_data = value;
			label = _data.label;
		}
		public function get group():RadioButtonGroup {
			return _group;
		}
		public function set group(value:RadioButtonGroup):void {
			if (_group) {
				_group.removeChild(this);
				_group = value;
				_group.addChild(this);
			}else {
				_group = value;
			}
		}
	}

}