package org.DWater.components 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	/**
	 * ColorChooser is often used to choose color.
	 * @author Dong Dong
	 */
	public class ColorChooser extends Component 
	{
		private var _textField:TextField;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _color:uint;
		private var _useInput:Boolean;
		public function ColorChooser(parent:Sprite, x:Number, y:Number) 
		{
			_textField = new TextField();
			addChild(_textField);
			_bitmap = new Bitmap();
			useInput = true;
			_name = "ColorChooser";
			super(parent, x, y);
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			super.refreshStyle();
			_styleObject.skins.textInputPart.refresh(this, _textField);
			_styleObject.skins.bitmapPart.refresh(this, _bitmap);
			_styleObject.skins.buttonPart.refresh(graphics);
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			_styleObject.skins.textInputPart.update(_color, _textField);
			_styleObject.skins.buttonPart.update(_color,graphics);
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(Event.ADDED_TO_STAGE, onStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onStage);
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
		private function onStage(e:Event):void {
			if (e.type==Event.ADDED_TO_STAGE) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			}else {
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouse);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			}
		}
		private function onMouse(e:MouseEvent):void {
			var item:String = getClickItem();
			if (e.type==MouseEvent.MOUSE_DOWN) {
				if (item=="buttonPart") {
					if (!contains(_bitmap)) {
						addChild(_bitmap);
					}else {
						_styleObject.skins.buttonPart.update(_color, graphics);
						removeChild(_bitmap);
					}
				}else if (item=="bitmapPart") {
					if (contains(_bitmap)) {
						color = _bitmapData.getPixel(_bitmap.mouseX, _bitmap.mouseY);
						removeChild(_bitmap);
					}
				}else {
					if (contains(_bitmap)) {
						_styleObject.skins.buttonPart.update(_color, graphics);
						removeChild(_bitmap);
					}
				}
			}else if (e.type == MouseEvent.MOUSE_MOVE) {
				if (item=="bitmapPart") {
					if (contains(_bitmap)) {
						_styleObject.skins.buttonPart.update(_bitmapData.getPixel(_bitmap.mouseX, _bitmap.mouseY), graphics);
					}
				}
				
			}
		}
		private function onText(e:KeyboardEvent):void {
			if (e.keyCode==Keyboard.ENTER) {
				color = parseInt(_textField.text, 16);
			}
		}
		private function getClickItem():String {
			var item:String = "";
			if (_styleObject.skins.buttonPart.rect.contains(mouseX,mouseY)) {
				item="buttonPart";
			}else if (_bitmap.getBounds(this).contains(mouseX,mouseY)) {
				item = "bitmapPart"; 
			}
			return item;
		}
		/**
		 * current color of this colorChooser
		 */
		public function get color():uint {
			return _color;
		}
		public function set color(value:uint):void {
			_color = value;
			_changed = true;
		}
		/**
		 * color map of this colorChooser
		 */
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		public function set bitmapData(value:BitmapData):void {
			if (_bitmapData) {
				_bitmapData.dispose();
			}
			_bitmapData = value;
			_bitmap.bitmapData = _bitmapData;
		}
		/**
		 * if the textField is used to change color
		 */
		public function get useInput():Boolean {
			return _useInput;
		}
		public function set useInput(value:Boolean):void {
			_useInput = value;
			if (value) {
				_textField.type = TextFieldType.INPUT;
				_textField.selectable = true;
				_textField.addEventListener(KeyboardEvent.KEY_DOWN, onText);
			}else {
				_textField.type = TextFieldType.DYNAMIC;
				_textField.selectable = false;
				_textField.removeEventListener(KeyboardEvent.KEY_DOWN, onText);
			}
		}
	}

}