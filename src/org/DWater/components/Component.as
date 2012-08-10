package org.DWater.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.DWater.skin.Style;
	
	/**
	 * Base class of the DWater UI framework.
	 * @author dongdong
	 */
	public class Component extends Sprite 
	{
		/**
		 * @private
		 */
		protected var _offsetX:Number;
		/**
		 * @private
		 */
		protected var _offsetY:Number;
		/**
		 * @private
		 */
		protected var _container:Sprite;
		/**
		 * @private
		 */
		protected var _styleObject:Object;
		/**
		 * @private
		 */
		protected var _name:String;
		/**
		 * @private
		 */
		protected var _rectWidth:Number;
		/**
		 * @private
		 */
		protected var _rectHeight:Number;
		/**
		 * @private
		 */
		protected var _changed:Boolean = false;
		public function Component(parent:Sprite, x:Number, y:Number):void {
			initOffsetXY();
			initEvent();
			this.x = x;
			this.y = y;
			if (parent is ContainerComponent) {
				container = parent;
			}else {
				if (parent) {
					parent.addChild(this);
				}
			}
			
			Style.instance.addEventListener(Event.CHANGE, onStyleChange);
			onStyleChange(null);
		}
		/**
		 * @private
		 */
		protected function refreshStyle():void {
			_styleObject = Style.instance.getStyleByName(_name);
		}
		/**
		 * @private
		 */
		protected function draw():void {
			_changed = false;
			graphics.clear();
		}
		/**
		 * @private
		 */
		protected function initEvent():void {
			addEventListener(Event.ENTER_FRAME, update);
		}
		/**
		 * @private
		 */
		protected function initOffsetXY():void {
			_offsetX = 0;
			_offsetY = 0;
		}
		/**
		 * @private
		 */
		protected function onStyleChange(evt:Event):void {
			refreshStyle();
			draw();
		}
		/**
		 * @private
		 */
		protected function update(evt:Event):void {
			if (!_changed||!stage) {
				return;
			}
			draw();
		}
		public function get offsetX():Number {
			return _offsetX;
		}
		public function get offsetY():Number {
			return _offsetY;
		}
		public function get container():Sprite {
			return _container;
		}
		public function set container(value:Sprite):void {
			if (_container && (_container.contains(this))) {
				_container.removeChild(this);
			}
			var x:Number = this.x;
			var y:Number = this.y;
			_container = value;
			if (_container&&!_container.contains(this)) {
				_container.addChild(this);
			}
			this.x =x;
			this.y =y;
		}
		/**
		 * @private
		 */
		internal function get rectWidth():Number {
			return _rectWidth;
		}
		/**
		 * @private
		 */
		internal function get rectHeight():Number {
			return _rectHeight;
		}
		override public function get x():Number {
			if (parent&&(parent is ContainerComponent)) {
				return super.x-(parent as ContainerComponent).registX;
			}else {
				return super.x;
			}
		}
		override public function set x(value:Number):void {
			if (parent && (parent is ContainerComponent)) {
				super.x = value + (parent as ContainerComponent).registX;
			}else {
				super.x = value;
			}
		}
		override public function get y():Number {
			if (parent&&(parent is ContainerComponent)) {
				return super.y - (parent as ContainerComponent).registY;
			}else {
				return super.y;
			}
		}
		override public function set y(value:Number):void {
			if (parent&&(parent is ContainerComponent)) {
				super.y = value + (parent as ContainerComponent).registY;
			}else {
				super.y = value;
			}
		}
	}
}
