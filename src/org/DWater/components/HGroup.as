package org.DWater.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class HGroup extends ContainerComponent 
	{
		public static const TOP:String = "top";
		public static const BOTTOM:String = "bottom";
		public static const CENTER:String = "center";
		
		private var _padding:Number;
		private var _children:Vector.<DisplayObject>;
		private var _fixedWidth:Boolean;
		private var _align:String;
		
		private var _equalPadding:Boolean;
		
		public function HGroup(parent:Sprite, x:Number, y:Number,children:Array=null) 
		{
			_name = "HGroup";
			_children = new Vector.<DisplayObject>();
			if (children) {
				var a:uint = children.length;
				for (var i:int = 0; i < a;i++ ) {
					addItem(children[i] as DisplayObject);
				}
			}
			_align = TOP;
			_fixedWidth = true;
			_equalPadding = true;
			super(parent, x, y);
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
			if (isNaN(_padding)||((_styleObject.padding!=lastStyle.padding)&&(lastStyle.padding==_padding))) {
				_padding = _styleObject.padding;
			}
		}
		override protected function draw():void {
			super.draw();
			var i:int;
			var a:int = _children.length;
			var tempItem:DisplayObject;
			var bound:Rectangle;
			if (a<=0) {
				return;
			}
			if (_fixedWidth) {
				var space:Number = (_rectWidth - _children[a - 1].width) / (a - 1);
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					bound = tempItem.getBounds(tempItem);
					tempItem.x = i * space-bound.x+offsetX;
					switch(_align) {
						case TOP:
							tempItem.y = -bound.y+offsetY;
							break;
						case CENTER:
							tempItem.y = (_rectHeight - tempItem.height) / 2-bound.y+offsetY;
							break;
						case BOTTOM:
							tempItem.y = _rectHeight - tempItem.height - bound.y+offsetY;
							break;
					}
				}
			}else {
				var pile:Number = 0;
				_rectHeight = Number.MIN_VALUE;
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					if (tempItem.height>_rectHeight) {
						_rectHeight = tempItem.height;
					}
				}
				for (i = 0; i < a; i++ ) {
					tempItem = _children[i];
					bound = tempItem.getBounds(tempItem);
					tempItem.x = pile-bound.x + offsetX;
					if (_equalPadding) {
						pile += padding;
					}else {
						pile += bound.width + padding;
					}
					switch(_align) {
						case TOP:
							tempItem.y = -bound.y+offsetY;
							break;
						case CENTER:
							tempItem.y = (_rectHeight - tempItem.height) / 2-bound.y+offsetY;
							break;
						case BOTTOM:
							tempItem.y = _rectHeight - tempItem.height - bound.y+offsetY;
							break;
					}
				}
				if (_equalPadding) {
					_rectHeight = a * _padding;
				}else {
					_rectWidth = _children[a - 1].x - _children[0].x + _children[a - 1].width;
				}
			}
		}
		override public function get width():Number {
			return _rectWidth;
		}
		override public function set width(value:Number):void {
			if (value>0) {
				_rectWidth = value;
				if (_fixedWidth) {
					_changed = true;
				}
			}
		}
		override public function get height():Number {
			return _rectHeight;
		}
		override public function set height(value:Number):void {
			if (value>0) {
				_rectHeight = value;
			}
			_changed = true;
		}
		public function addItem(item:DisplayObject):void {
			_children.push(item);
			addComponent(item);
			_changed = true;
		}
		public function removeItem(item:DisplayObject):void {
			var index:int = _children.indexOf(item);
			if (index!=-1) {
				removeComponent(_children.splice(index, 1)[0]);
				_changed = true;
			}
		}
		public function getItemAt(index:uint):DisplayObject {
			if (index>=_children.length) {
				return null;
			}else {
				return _children[index];
			}
		}
		public function addItemAt(item:DisplayObject, index:uint):void {
			if (index>=_children.length) {
				return;
			}
			_children.splice(index, 0, item);
			addComponent(item);
			_changed = true;
		}
		public function removeItemAt(index:uint):void {
			if (index>=_children.length) {
				return;
			}
			removeComponent(_children.splice(index, 1)[0]);
			_changed = true;
		}
		public function removeAll():void {
			var a:uint = _children.length;
			for (var i:uint = 0; i < a;i++ ) {
				removeComponent(_children.pop());
			}
			_changed = true;
		}
		public function get padding():Number {
			return _padding;
		}
		public function set padding(value:Number):void {
			_padding = value;
			if (!_fixedWidth) {
				_changed = true;
			}
		}
		public function get fixedWidth():Boolean {
			return _fixedWidth;
		}
		public function set fixedWidth(value:Boolean):void {
			_fixedWidth = value;
			_changed = true;
		}
		public function get align():String {
			return _align;
		}
		public function set align(value:String):void {
			_align = value;
			_changed = true;
		}
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