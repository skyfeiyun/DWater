package org.DWater.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * VGroup is often used for vertical layout.
	 * @author Dong Dong
	 */
	public class VGroup extends ContainerComponent 
	{
		public static const LEFT:String = "left";
		public static const RIGHT:String = "right";
		public static const CENTER:String = "center";
		
		private var _padding:Number;
		private var _children:Vector.<DisplayObject>;
		private var _fixedHeight:Boolean;
		private var _align:String;
		
		private var _equalPadding:Boolean;
		
		public function VGroup(parent:Sprite, x:Number, y:Number,children:Array=null) 
		{
			_name = "VGroup";
			_children = new Vector.<DisplayObject>();
			if (children) {
				var a:uint = children.length;
				for (var i:int = 0; i < a;i++ ) {
					addItem(children[i] as DisplayObject);
				}
			}
			_align = LEFT;
			_fixedHeight = true;
			_equalPadding = true;
			super(parent, x, y);
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
			if (isNaN(_rectHeight)||((_styleObject.rectHeight!=lastStyle.rectHeight)&&(lastStyle.rectHeight==_rectHeight))) {
				_rectHeight = _styleObject.rectHeight;
			}
			if (isNaN(_padding)||((_styleObject.padding!=lastStyle.padding)&&(lastStyle.padding==_padding))) {
				_padding = _styleObject.padding;
			}
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			var i:int;
			var a:int = _children.length;
			var tempItem:DisplayObject;
			var bound:Rectangle;
			if (a<=0) {
				return;
			}
			if (_fixedHeight) {
				var space:Number = (_rectHeight - _children[a - 1].height) / (a - 1);
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					bound = tempItem.getBounds(tempItem);
					tempItem.y = i * space-bound.y+offsetY;
					switch(_align) {
						case LEFT:
							tempItem.x = -bound.x+offsetX;
							break;
						case CENTER:
							tempItem.x = (_rectWidth - tempItem.width) / 2-bound.x+offsetX;
							break;
						case RIGHT:
							tempItem.x = _rectWidth - tempItem.width - bound.x+offsetX;
							break;
					}
				}
			}else {
				var pile:Number = 0;
				_rectWidth = Number.MIN_VALUE;
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					if (tempItem.width>_rectWidth) {
						_rectWidth = tempItem.width;
					}
				}
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					bound = tempItem.getBounds(tempItem);
					tempItem.y = pile-bound.y + offsetY;
					if (_equalPadding) {
						pile += padding;
					}else {
						pile += bound.height + padding;
					}
					switch(_align) {
						case LEFT:
							tempItem.x = -bound.x+offsetX;
							break;
						case CENTER:
							tempItem.x = (_rectWidth - tempItem.width) / 2-bound.x+offsetX;
							break;
						case RIGHT:
							tempItem.x = _rectWidth - tempItem.width - bound.x+offsetX;
							break;
					}
				}
				if (_equalPadding) {
					_rectHeight = a*_padding;
				}else {
					_rectHeight = _children[a - 1].y - _children[0].y + _children[a - 1].height;
				}
			}
		}
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			if (value>0) {
				_rectWidth = value;
			}
			_changed = true;
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			if (value>0) {
				_rectHeight = value;
				if (_fixedHeight) {
					_changed = true;
				}
			}
		}
		/**
		 * @copy HGroup#getItemAt()
		 */
		public function getItemAt(index:uint):DisplayObject {
			if (index>=_children.length) {
				return null;
			}else {
				return _children[index];
			}
		}
		/**
		 * @copy HGroup#addItem()
		 */
		public function addItem(item:DisplayObject):void {
			_children.push(item);
			addComponent(item);
			_changed = true;
		}
		/**
		 * @copy HGroup#removeItem()
		 */
		public function removeItem(item:DisplayObject):void {
			var index:int = _children.indexOf(item);
			if (index!=-1) {
				removeComponent(_children.splice(index, 1)[0]);
				_changed = true;
			}
		}
		/**
		 * @copy HGroup#addItemAt()
		 */
		public function addItemAt(item:DisplayObject, index:uint):void {
			if (index>=_children.length) {
				return;
			}
			_children.splice(index, 0, item);
			addComponent(item);
			_changed = true;
		}
		/**
		 * @copy HGroup#removeItemAt()
		 */
		public function removeItemAt(index:uint):void {
			if (index>=_children.length) {
				return;
			}
			removeComponent(_children.splice(index, 1)[0]);
			_changed = true;
		}
		/**
		 * @copy HGroup#removeAll()
		 */
		public function removeAll():void {
			var a:uint = _children.length;
			for (var i:uint = 0; i < a;i++ ) {
				removeComponent(_children.pop());
			}
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
			if (!_fixedHeight) {
				_changed = true;
			}
		}
		/**
		 * if this hGroup has a fixed height
		 */
		public function get fixedHeight():Boolean {
			return _fixedHeight;
		}
		public function set fixedHeight(value:Boolean):void {
			_fixedHeight = value;
			_changed = true;
		}
		/**
		 * @copy HGroup#align
		 */
		public function get align():String {
			return _align;
		}
		public function set align(value:String):void {
			_align = value;
			_changed = true;
		}
		/**
		 * @copy HGroup#equalPadding
		 */
		public function get equalPadding():Boolean {
			return _equalPadding;
		}
		public function set equalPadding(value:Boolean):void {
			_equalPadding = value;
			_changed = true;
		}
		public function set offsetX(value:Number):void {
			_offsetX = value;
			_changed = true;
		}
		public function set offsetY(value:Number):void {
			_offsetY = value;
			_changed = true;
		}
	}

}