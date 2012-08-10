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
	
	[Event(name = "select", type = "org.DWater.events.DWaterSelectedEvent")]
	/**
	 * Checkbox is often used as swith.
	 * @author Dong Dong
	 */
	public class CheckBox extends Component 
	{	
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _text:String;
		private var _data:Object;
		
		private var _enabled:Boolean;
		
		private var _selected:Boolean;
		
		public function CheckBox(parent:Sprite, x:Number = 0, y:Number = 0, data:Object=null):void {
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "CheckBox";
			_enabled = true;
			_selected = false;
			super(parent, x, y);
			this.data = data;
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			super.refreshStyle();
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
			_rectWidth = _rectHeight = 0;
			_textField.defaultTextFormat = _textFormat;
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			var offset:Number = (_styleObject.outerSize-_styleObject.innerSize) / 2;
			if (_enabled) {
				graphics.beginFill(_styleObject.enabledOuterColor);
				graphics.drawRect(0, 0, _styleObject.outerSize, _styleObject.outerSize);
				graphics.endFill();
				if (_selected) {
					graphics.beginFill(_styleObject.innerColor);
					graphics.drawRect(offset, offset, _styleObject.innerSize, _styleObject.innerSize);
					graphics.endFill();
				}
			}else {
				graphics.beginFill(_styleObject.disabledOuterColor);
				graphics.drawRect(0, 0, _styleObject.outerSize, _styleObject.outerSize);
				graphics.endFill();
				if (_selected) {
					graphics.beginFill(_styleObject.innerColor);
					graphics.drawRect(offset, offset, _styleObject.innerSize, _styleObject.innerSize);
					graphics.endFill();
				}
			}
			_textField.x = _styleObject.outerSize + _styleObject.padding;
			_textField.y = (_styleObject.outerSize-_textField.textHeight) / 2-2;
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.CLICK, onMouse);
		}
		private function onMouse(evt:MouseEvent):void {
			switch(evt.type) {
				case MouseEvent.CLICK:
					selected = !_selected;
					break;
			}
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
		 * label of the checkBox item
		 */
		public function get label():String {
			return _text;
		}
		public function set label(value:String):void {
			_textField.text = value;
			_text = value;
			_changed=true;
		}
		/**
		 * @copy Button#enabled
		 */
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
		/**
		 * if the checkbox item is selected
		 */
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
			dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.SELECT,-1,_data));
			_changed=true;
		}
		/**
		 * @copy org.DWater.charts.BarChart#data
		 */
		public function get data():Object {
			return _data;
		}
		public function set data(value:Object):void {
			_data = value;
			label = data.label;
		}
	}
	
}