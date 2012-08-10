package org.DWater.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.events.DWaterSelectedEvent;
	import org.DWater.skin.Style;
	
	[Event(name = "item_click", type = "org.DWater.events.DWaterSelectedEvent")]
	[Event(name = "item_double_click", type = "org.DWater.events.DWaterSelectedEvent")]
	/**
	 * List is often used to list elements.
	 * @author Dong Dong
	 */
	public class List extends ContainerComponent 
	{
		private var _scrollRect:Rectangle;
		private var _itemHeight:Number;
		
		private var _textFormat:TextFormat;
		private var _renderItem:Class;
		
		private var _vSlider:Slider;
		private var _sliderStyle:Object;
		
		private var _mask:Sprite;
		private var _inner:VGroup;
		
		private var _overIndex:int;
		private var _selectedIndex:int;
		
		private var _border:Boolean;
		
		private var _data:Array;
		
		public function List(parent:Sprite, x:Number, y:Number,data:Array=null) 
		{
			_textFormat = new TextFormat();
			
			_mask = new Sprite();
			addChild(_mask);
			_inner = new VGroup(this, 0, 0);
			_inner.fixedHeight = false;
			_inner.mask = _mask;
			_vSlider = new Slider(null, 0, 0, Slider.VERTICAL);
			_vSlider.liveDrag = true;
			_name = "List";
			_renderItem = TextField;
			_scrollRect = new Rectangle();
			
			_border = true;
			_selectedIndex = -1;
			_overIndex = -1;
			super(parent, x, y);
			this.data = data;
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			var lastStyle:Object = _styleObject;
			super.refreshStyle();
			_sliderStyle = Style.instance.getStyleByName("Slider"); 
			if (isNaN(_rectWidth)||((_styleObject.rectWidth!=lastStyle.rectWidth)&&(lastStyle.rectWidth==_rectWidth))) {
				_rectWidth = _styleObject.rectWidth;
			}
			if (isNaN(_rectHeight)||((_styleObject.rectHeight!=lastStyle.rectHeight)&&(lastStyle.rectHeight==_rectHeight))) {
				_rectHeight = _styleObject.rectHeight;
			}
			_mask.x = _inner.x;
			_mask.y = _inner.y;
			_scrollRect.x = 0;
			_scrollRect.y = 0;
			_vSlider.value = 0;
			_vSlider.y=_styleObject.borderStrength;
			_vSlider.x = _rectWidth - _sliderStyle.barHeight-_styleObject.borderStrength;
			_vSlider.height = _rectHeight-2*_styleObject.borderStrength;
			_scrollRect.width = _rectWidth;
			_scrollRect.height = _rectHeight;
			_itemHeight = _styleObject.itemHeight;
			_inner.offsetX = _styleObject.paddingX;
			_inner.padding = _itemHeight;
			
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.LEFT;
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			_vSlider.addEventListener(Event.CHANGE, onScroll);
			addEventListener(MouseEvent.MOUSE_WHEEL, onScroll);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.DOUBLE_CLICK, onMouse);
			addEventListener(MouseEvent.MOUSE_OVER, onMouse);
			addEventListener(MouseEvent.MOUSE_MOVE, onMouse);
			addEventListener(MouseEvent.MOUSE_OUT, onMouse);
			
		}
		private function onScroll(evt:Event):void {
			if (evt.type==MouseEvent.MOUSE_WHEEL) {
				_vSlider.value -= (evt as MouseEvent).delta;
			}
			_scrollRect.y = _vSlider.value / 100 * (_inner.height - _scrollRect.height);
			_inner.y = -_scrollRect.y;
			_overIndex = getHitArea(mouseX, mouseY);
		}
		private function onMouse(evt:MouseEvent):void {
			if (evt.type==MouseEvent.MOUSE_DOWN) {
				_selectedIndex = getHitArea(mouseX, mouseY);
				if (_selectedIndex!=-1) {
					dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.ITEM_CLICK, _selectedIndex, _data[_selectedIndex]));
				}
			}else if (evt.type==MouseEvent.DOUBLE_CLICK) {
				_selectedIndex = getHitArea(mouseX, mouseY);
				if (_selectedIndex!=-1) {
					dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.ITEM_DOUBLE_CLICK, _selectedIndex, _data[_selectedIndex]));
				}
			}else if (evt.type == MouseEvent.MOUSE_OVER) {
				_overIndex = getHitArea(mouseX, mouseY);
			}else if (evt.type == MouseEvent.MOUSE_MOVE) {
				_overIndex = getHitArea(mouseX, mouseY);
			}else if (evt.type==MouseEvent.MOUSE_OUT) {
				_overIndex = -1;
			}
		}
		private function getHitArea(x:Number, y:Number):int {
			var item:int = -1;
			if (x>0&&x< _rectWidth&&y>0&&y< _rectHeight) {
				if (contains(_vSlider)&&x>(_rectWidth-_sliderStyle.barHeight)) {
					item = -1;
				}else {
					item = Math.floor((_scrollRect.y + y) / _itemHeight);
				}
			}
			return item;
		}
		/**
		 * @private
		 */
		override protected function update(evt:Event):void {
			_changed = true;
			super.update(evt);
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			if (_scrollRect.height< _inner.height) {
				if (!contains(_vSlider)) {
					_scrollRect.width = _rectWidth- _vSlider.width;
					addChild(_vSlider);
				}
			}else {
				if (contains(_vSlider)) {
					_scrollRect.width = _rectWidth;
					removeChild(_vSlider);
				}
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRect(0, 0, _scrollRect.width, _scrollRect.height);
			_mask.graphics.endFill();
			
			if (_border) {
				graphics.lineStyle(_styleObject.borderStrength, _styleObject.borderColor);
			}
			graphics.beginFill(_styleObject.backColor);
			graphics.drawRect(0, 0, _rectWidth, _rectHeight);
			graphics.endFill();
			
			
			var startY:Number = _itemHeight - (_scrollRect.y % _itemHeight);
			var lines:uint = Math.ceil((_rectHeight - startY) / _itemHeight);
			var startX:Number = _styleObject.paddingX;
			var endX:Number;
			var i:uint;
			if (contains(_vSlider)) {
				endX = _rectWidth - _styleObject.paddingX-_sliderStyle.barHeight;
			}else {
				endX=_rectWidth - _styleObject.paddingX;
			}
			var ry:Number;
			var rh:Number;
			if (_selectedIndex>=0) {
				ry = Math.min(Math.max(_selectedIndex * _itemHeight - _scrollRect.y, 0),_rectHeight);
				rh = Math.max(Math.min((_selectedIndex + 1) * _itemHeight - _scrollRect.y, _rectHeight),0)-ry;
				graphics.beginFill(_styleObject.selectedColor);
				graphics.drawRect(0, ry, _rectWidth, rh);
				graphics.endFill();
			}
			if (_overIndex>=0&&_overIndex!=selectedIndex) {
				ry = Math.max(_overIndex * _itemHeight - _scrollRect.y, 0);
				rh = Math.min((_overIndex + 1) * _itemHeight - _scrollRect.y, _rectHeight)-ry;
				graphics.beginFill(_styleObject.overColor);
				graphics.drawRect(0, ry, _rectWidth, rh);
				graphics.endFill();
			}
			for (i = 0; i < lines;i++ ) {
				graphics.moveTo(startX, startY);
				graphics.lineTo(endX, startY);
				startY += _itemHeight;
			}
			if (_data&&_data.length>0) {
				_inner.offsetY = (_itemHeight-_inner.getItemAt(0).height) / 2;
			}
		}
		override public function set width(value:Number):void {
			var minWidth:Number = _sliderStyle.barHeight;
			if (value < minWidth) {
				value = minWidth;
			}
			_rectWidth = value;
			_inner.width = _rectWidth;
			_scrollRect.width = _rectWidth;
			_vSlider.x = _rectWidth - _sliderStyle.barHeight-_styleObject.borderStrength;
			_changed = true;
		}
		override public function set height(value:Number):void {
			var minHeight:Number = _sliderStyle.barWidth;
			if (value < minHeight) {
				value = minHeight;
			}
			_rectHeight = value;
			_inner.height = _rectHeight;
			_scrollRect.height = _rectHeight;
			_vSlider.height = _rectHeight-2*_styleObject.borderStrength;
			_changed = true;
		}
		private function generateItemByClass(value:Object):DisplayObject{
			if (_renderItem==Button) {
				return new Button(null, 0, 0, value.label);
			}else if (_renderItem==CheckBox) {
				return new CheckBox(null, 0, 0, value);
			}else if (_renderItem==InputText) {
				return new InputText(null, 0, 0, value.text);
			}else if (_renderItem==Label) {
				return new Label(null, 0, 0, value.text);
			}else if (_renderItem==NumberStepper) {
				return new NumberStepper(null, 0, 0, value.minValue, value.maxValue, value.defaultValue, value.step);
			}else if (_renderItem==RadioButtonGroup) {
				return new RadioButtonGroup(null, 0, 0, value.direction, value.data);
			}else if (_renderItem==Slider) {
				return new Slider(null, 0, 0, value.direction, value.minValue, value.maxValue, value.defaultValue);
			}else if (_renderItem==TextArea) {
				return new TextArea(null, 0, 0, value.text);
			}else if (_renderItem == TextField) {
				var textField:TextField = new TextField();
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.selectable = false;
				textField.embedFonts = true;
				textField.defaultTextFormat = _textFormat;
				textField.text = value.label;
				return textField;
			}else {
				return new _renderItem(value);
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#getItemAt()
		 */
		public function getItemAt(index:uint):Object {
			if (index>=_data.length) {
				return null;
			}else {
				return _data[index];
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#addItem()
		 */
		public function addItem(value:Object):void {
			var item:DisplayObject = generateItemByClass(value);
			_inner.addItem(item);
			_data.push(value);
			_changed = true;
		}
		/**
		 * @copy org.DWater.charts.BarChart#removeItem()
		 */
		public function removeItem(value:Object):void {
			var index:int = _data.indexOf(value);
			if (index != -1) {
				_data.splice(index, 1);
				_inner.removeItemAt(index);
				_changed = true;
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#addItemAt()
		 */
		public function addItemAt(value:Object, index:uint):void {
			var item:DisplayObject = generateItemByClass(value);
			_inner.addItemAt(item, index);
			_data.splice(index, 0, value);
			_changed = true;
		}
		/**
		 * @copy org.DWater.charts.BarChart#removeItemAt()
		 */
		public function removeItemAt(index:uint):void {
			_data.splice(index, 1);
			_inner.removeItemAt(index);
			_changed = true;
		}
		/**
		 * @copy HGroup#removeAll()
		 */
		public function removeAll():void {
			_inner.removeAll();
			_data = [];
			_changed = true;
		}
		/**
		 * @copy org.DWater.charts.BarChart#data
		 */
		public function get data():Array {
			return _data;
		}
		public function set data(value:Array):void {
			_inner.removeAll();
			_data = value;
			if (_data) {
				var a:uint = _data.length;
				for (var i:int = 0; i < a;i++ ) {
					_inner.addItem(generateItemByClass(_data[i]));
				}
			}else {
				_data = [];
			}
			_changed = true;
		}
		/**
		 * height of each item
		 */
		public function get itemHeight():Number {
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void {
			_itemHeight = value;
			_inner.padding = value;
			_changed = true;
		}
		/**
		 * item to be rendered in the list, if you need two use other items instead of TextField in the list,
		 *  just pass the Class object to this parameter, this render item Class should accept an value object 
		 * as the parameter in its constructor
		 */
		public function get renderItem():Class {
			return _renderItem;
		}
		public function set renderItem(value:Class):void {
			if (_renderItem!=value) {
				_renderItem = value;
				_inner.removeAll();
				var a:uint = _data.length;
				for (var i:int = 0; i < a;i++ ) {
					_inner.addItem(generateItemByClass(_data[i]));
				}
			}
			_changed = true;
		}
		/**
		 * index of the selected item
		 */
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if (value>=0&&value<=_data.length) {
				_selectedIndex = value;
				_changed = true;
			}
		}
		/**
		 * if this list should show border
		 */
		public function get border():Boolean {
			return _border;
		}
		public function set border(value:Boolean):void {
			_border = value;
			_changed = true;
		}
	}

}