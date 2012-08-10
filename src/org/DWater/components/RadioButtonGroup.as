package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.DWater.events.DWaterSelectedEvent;
	[Event(name = "select", type = "org.DWater.events.DWaterSelectedEvent")]
	/**
	 * RadioButtonGroup is often used to make choice, you can only choose one item in a radioButton group. Besides, you shouldn't
	 *  use this component without RadioButton.
	 * @author Dong Dong
	 */
	public class RadioButtonGroup extends Component 
	{
		/**
		 * place the radioButton in horizon layout
		 */
		public static const HORIZON:String = "horizon";
		/**
		 * place the radioButton in vertical layout
		 */
		public static const VERTICAL:String = "vertical";
		private var _direction:String;
		private var _enabled:Boolean;
		private var _selectedIndex:int;
		private var _selectedItem:RadioButton;
		private var _group:Vector.<RadioButton>;
		private var _data:Array;
		private var _padding:Number;
		public function RadioButtonGroup(parent:Sprite, x:Number, y:Number,direction:String="vertical",data:Array=null) 
		{
			_name = "RadioButtonGroup";
			_enabled = true;
			_group = new Vector.<RadioButton>();
			_selectedIndex = -1;
			this.data = data;
			this.direction = direction;
			super(parent, x, y);
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			super.refreshStyle();
			_padding = _styleObject.padding;
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			var tempRadioButton:RadioButton;
			var i:uint;
			var a:uint = _group.length;
			var tempPadding:Number = Number.MIN_VALUE;
			if (_direction==HORIZON) {
				for (i = 0; i < a;i++ ) {
					tempRadioButton = _group[i];
					if (tempRadioButton.width< tempPadding) {
						tempPadding = tempRadioButton.width;
					}
					tempPadding += _padding;
				}
				for (i = 0; i < a;i++ ) {
					tempRadioButton = _group[i];
					if (_selectedIndex==i) {
						tempRadioButton.selected = true;
					}
					tempRadioButton.x = i * tempPadding;
				}
			}else if (direction == VERTICAL) {
				tempPadding = 0;
				for (i = 0; i < a;i++ ) {
					tempRadioButton = _group[i];
					if (_selectedIndex==i) {
						tempRadioButton.selected = true;
					}
					tempRadioButton.y = tempPadding;
					tempPadding += tempRadioButton.height;
				}
			}
		}
		private function onMouse(evt:MouseEvent):void {
			switch(evt.type) {
				case MouseEvent.CLICK:
					var tempRadioButton:RadioButton;
					var a:uint = _data.length;
					for (var i:uint = 0; i < a;i++ ) {
						tempRadioButton = _group[i];
						if (evt.target==tempRadioButton) {
							selectedIndex = i;
							break;
						}
					}
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
				for each(var tempRadioButton:RadioButton in _group) {
					tempRadioButton.enabled = false;
				}
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#getItemAt()
		 */
		public function getItemAt(index:uint):Object {
			var a:uint = _data.length;
			if (index>=0&&index<a) {
				return _data[index];
			}else {
				return null;
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#addItemAt()
		 */
		public function addItemAt(value:Object, index:uint):void {
			var a:uint = _data.length;
			if (index>=0&&index<a) {
				_data.splice(index, 0, value);
				var tempRadioButton:RadioButton = new RadioButton(this, 0, 0, value);
				tempRadioButton.addEventListener(MouseEvent.CLICK, onMouse);
				tempRadioButton.group = this;
				tempRadioButton.enabled = _enabled;
				_group.splice(index, 0,tempRadioButton);
				_changed = true;
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#removeItemAt()
		 */
		public function removeItemAt(index:uint):Object {
			var a:uint = _data.length;
			if (index >= 0 && index < a) {
				var data:Object;
				data = _data.splice(index, 1)[0];
				var tempRadioButton:RadioButton = _group.splice(index, 1)[0];
				tempRadioButton.group = null;
				tempRadioButton.removeEventListener(MouseEvent.CLICK, onMouse);
				_changed = true;
				return data;
			}else {
				return null;
			}
		}
		/*
		public function setItemAt(value:Object, index:int):void {
			var a:uint = _data.length;
			if (index >= 0 && index < a) {
				_data[index] = value;
				_group[index].data = value;
			}
		}*/
		/**
		 * @copy org.DWater.charts.BarChart#addItem()
		 */
		public function addItem(value:Object):void {
			_data.push(value);
			var tempRadioButton:RadioButton = new RadioButton(this, 0, 0, value);
			tempRadioButton.group = this;
			tempRadioButton.addEventListener(MouseEvent.CLICK, onMouse);
			tempRadioButton.enabled = _enabled;
			_group.push(tempRadioButton);
			_changed = true;
		}
		/**
		 * @copy org.DWater.charts.BarChart#removeItem()
		 */
		public function removeItem(value:Object):void {
			var index:int = _data.indexOf(value);
			var a:uint = _data.length;
			if (index >= 0 && index < a) {
				var data:Object;
				data = _data.splice(index, 1)[0];
				var tempRadioButton:RadioButton = _group.splice(index, 1)[0];
				tempRadioButton.group = null;
				tempRadioButton.removeEventListener(MouseEvent.CLICK, onMouse);
				_changed = true;
			}
		}
		/**
		 * @copy List#selectedIndex
		 */
		public function get selectedIndex():int{
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			if (_selectedIndex!=-1) {
				_group[_selectedIndex].selected = false;
			}
			if (value<0||value>=_group.length) {
				_selectedIndex = -1;
				_selectedItem = null;
			}else {
				_selectedIndex = value;
				_selectedItem = _group[_selectedIndex];
				_selectedItem.selected = true;
				dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.SELECT, value, _data[value]));
			}
		}
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function set selectedItem(value:Object):void {
			var index:int = _data.indexOf(value);
			if (_selectedIndex!=-1) {
				_group[_selectedIndex].selected = false;
			}
			if (index<0) {
				_selectedIndex = -1;
				_selectedItem = null;
			}else {
				_selectedIndex = index;
				_selectedItem = _group[_selectedIndex];
				_selectedItem.selected = true;
				dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.SELECT, index, _data[index]));
			}
		}
		/**
		 * @copy org.DWater.charts.BarChart#data
		 */
		public function get data():Array {
			return _data;
		}
		public function set data(value:Array):void {
			if (!_data) {
				_data = [];
			}
			var a:uint = value.length;
			var b:uint = _data.length;
			var c:uint = Math.min(a, b);
			var i:uint;
			var tempRadioButton:RadioButton;
			for (i = 0; i < c;i++ ) {
				_group[i].data = value[i];
			}
			for (; i < a;i++ ) {
				tempRadioButton = new RadioButton(this, 0, 0, value[i]);
				tempRadioButton.group = this;
				_group.push(tempRadioButton);
				tempRadioButton.addEventListener(MouseEvent.CLICK, onMouse);
			}
			for (; i < b;i++ ) {
				_data.pop();
				tempRadioButton = _group.pop();
				tempRadioButton.group = null;
				tempRadioButton.removeEventListener(MouseEvent.CLICK, onMouse);
			}
			selectedIndex = -1;
			_data = value;
			_changed = true;
		}
		/**
		 * @copy HGroup#padding
		 */
		public function get padding():Number {
			return _padding;
		}
		public function set padding(value:Number):void {
			_padding = value;
			_changed = true;
		}
		/**
		 * layout direction of this component
		 */
		public function get direction():String {
			return _direction;
		}
		public function set direction(value:String):void {
			_direction = value;
			_changed = true;
		}
	}

}