package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.events.DWaterSelectedEvent;
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class PopupButton extends Component 
	{
		
		private static const UP:String = "up";
		private static const OVER:String = "over";
		private static const DOWN:String = "down";
		private static const DISABLED:String = "disabled";
		
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _list:List;
		private var _selectedIndex:int;
		
		private var _titleRect:Rectangle;
		
		private var _data:Array;
		
		private var _minimize:Boolean;
		
		private var _enabled:Boolean;
		private var _state:String;
		
		public function PopupButton(parent:Sprite, x:Number = 0, y:Number = 0, data:Array=null,selectedIndex:int=-1):void {
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "PopupButton";
			_minimize = true;
			_enabled = true;
			_state = UP;
			_list = new List(null, 0, 0);
			_list.border = false;
			_titleRect = new Rectangle();
			super(parent, x, y);
			this.data = data;
			this.selectedIndex = selectedIndex;
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
			_titleRect.width = _rectWidth;
			_titleRect.height = _rectHeight;
			_list.y = _rectHeight;
			_list.width = _rectWidth-_styleObject.diff;
			_list.height = _styleObject.listHeight;
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.align = TextFormatAlign.LEFT;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			var a:uint;
			var i:uint;
			var miniPath:Vector.<Number>;
			var miniCommand:Vector.<int>;
			var paddingX:Number = _styleObject.padding;
			var paddingY:Number = _rectHeight / 2;
			_textField.x = _styleObject.padding+_styleObject.buttonWidth;
			_textField.y = (_rectHeight - _textField.height) / 2;
			
			switch(_state) {
				case UP:
					_textFormat.color = _styleObject.fontColor;
					graphics.beginFill(_styleObject.fillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					graphics.lineStyle(_styleObject.lineStrength,_styleObject.miniOffColor);
					break;
				case OVER:
					_textFormat.color = _styleObject.fontColor;
					graphics.beginFill(_styleObject.fillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					graphics.lineStyle(_styleObject.lineStrength,_styleObject.miniOnColor);
					break;
				case DOWN:
					_textFormat.color = _styleObject.fontColor;
					graphics.beginFill(_styleObject.fillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					graphics.lineStyle(_styleObject.lineStrength,_styleObject.miniOnColor);
					break;
				case DISABLED:
					_textFormat.color = _styleObject.disabledFontColor;
					graphics.beginFill(_styleObject.disabledFillColor);
					graphics.drawRect(0, 0, _rectWidth, _rectHeight);
					graphics.endFill();
					graphics.lineStyle(_styleObject.lineStrength,_styleObject.miniDisabledColor);
					break;
			}
			if (_minimize) {
				if (contains(_list)) {
					removeChild(_list);
				}
				miniCommand = _styleObject.miniOnCommand;
				a = _styleObject.miniOnPath.length;
				miniPath = new Vector.<Number>(a);
				for (i = 0; i < a;i+=2 ) {
					miniPath[i] = _styleObject.miniOnPath[i]+paddingX;
				}
				for (i = 1; i < a;i+=2 ) {
					miniPath[i] = _styleObject.miniOnPath[i]+paddingY;
				}
			}else {
				if (!contains(_list)) {
					addChild(_list);
				}
				miniCommand = _styleObject.miniOffCommand;
				a = _styleObject.miniOffPath.length;
				miniPath = new Vector.<Number>(a);
				for (i = 0; i < a;i+=2 ) {
					miniPath[i] = _styleObject.miniOffPath[i]+paddingX;
				}
				for (i = 1; i < a;i+=2 ) {
					miniPath[i] = _styleObject.miniOffPath[i]+paddingY;
				}
			}
			graphics.drawPath(miniCommand, miniPath);
			
			if (!_minimize) {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.miniOffColor);
				graphics.moveTo(_styleObject.lineStrength, _rectHeight);
				graphics.lineTo(_rectWidth-2*_styleObject.lineStrength, _rectHeight);
			}
			
			_textField.setTextFormat(_textFormat);
			
		}
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.MOUSE_OVER, onMouse);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.MOUSE_OUT, onMouse);
			_list.addEventListener(DWaterSelectedEvent.ITEM_CLICK, onList);
		}
		private function onList(evt:DWaterSelectedEvent):void {
			minimize = true;
			if (evt.index >= 0) {
				selectedIndex = evt.index;
				dispatchEvent(evt.clone());
			}
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
					if (_titleRect.contains(mouseX,mouseY)) {
						minimize = !minimize;
					}
					break;
			}
			_changed = true;
		}
		
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			var minWidth:Number = _textField.width + _styleObject.padding + _styleObject.buttonWidth;
			if (value< minWidth) {
				value = minWidth;
			}
			_rectWidth = value;
			_list.width = _rectWidth - _styleObject.diff;
			_changed=true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		public function set enabled(value:Boolean):void {
			if (value) {
				_state = UP;
				mouseEnabled = true;
			}else {
				_minimize = true;
				_state = DISABLED;
				mouseEnabled = false;
			}
			_changed=true;
		}
		public function getItemAt(index:uint):Object {
			return _list.getItemAt(index);
		}
		public function addItem(value:Object):void {
			_list.addItem(value);
		}
		public function removeItem(value:Object):void {
			_list.removeItem(value);
		}
		public function addItemAt(value:Object,index:uint):void {
			_list.addItemAt(value, index);
		}
		public function removeItemAt(index:uint):void {
			_list.removeItemAt(index);
		}
		public function get data():Array {
			return _data;
		}
		public function set data(value:Array):void {
			_list.data = value;
		}
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			_selectedIndex = value;
			var item:Object = _list.getItemAt(value);
			if (item) {
				_textField.text = item.label;
				if ((_styleObject.padding+_styleObject.buttonWidth+_textField.width)>_rectWidth) {
					_textField.text = _textField.text.substr(0,3)+"...";
				}
				_textField.setTextFormat(_textFormat);
			}else {
				_selectedIndex = -1;
			}
			_changed = true;
		}
		public function get minimize():Boolean {
			return _minimize;
		}
		public function set minimize(value:Boolean):void {
			_minimize = value;
			_changed = true;
		}
	}

}