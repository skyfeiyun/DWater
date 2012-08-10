package org.DWater.components 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.DWater.skin.Style;
	
	/**
	 * Panel is often used to organize components.
	 * @author Dong Dong
	 */
	public class Panel extends ContainerComponent 
	{
		private var _backColor:uint;
		private var _borderColor:uint;
		private var _borderStrength:Number;
		private var _border:Boolean;
		
		private var _scrollRect:Rectangle;
		
		private var _vSlider:Slider;
		private var _hSlider:Slider;
		private var _sliderStyle:Object;
		
		private var _mask:Sprite;
		private var _inner:ContainerComponent;
		
		public function Panel(parent:Sprite, x:Number, y:Number) 
		{
			_mask = new Sprite();
			addChild(_mask);
			_inner = new ContainerComponent(this, 0, 0);
			_inner.mask = _mask;
			_vSlider = new Slider(null, 0, 0, Slider.VERTICAL);
			_hSlider = new Slider(null, 0, 0);
			_vSlider.liveDrag = true;
			_hSlider.liveDrag = true;
			_name = "Panel";
			_border = true;
			_scrollRect = new Rectangle();
			super(parent, x, y);
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
			if (!lastStyle||((_styleObject.backColor!=lastStyle.backColor)&&(lastStyle.backColor==_backColor))) {
				_backColor = _styleObject.backColor;
			}
			if (!lastStyle||((_styleObject.borderColor!=lastStyle.borderColor)&&(lastStyle.borderColor==_borderColor))) {
				_borderColor = _styleObject.borderColor;
			}
			if (!lastStyle||((_styleObject.borderStrength!=lastStyle.borderStrength)&&(lastStyle.borderStrength==_borderStrength))) {
				_borderStrength = _styleObject.borderStrength;
			}
			_inner.x = _styleObject.margin;
			_inner.y = _styleObject.margin;
			_mask.x = _inner.x;
			_mask.y = _inner.y;
			_scrollRect.x = 0;
			_scrollRect.y = 0;
			_hSlider.value = 0;
			_vSlider.value = 0;
			_hSlider.width = _rectWidth - _sliderStyle.barHeight;
			_vSlider.x = _hSlider.width;
			_vSlider.height = _rectHeight - _sliderStyle.barHeight;
			_hSlider.y = _vSlider.height;
			_scrollRect.width = _rectWidth-2*_styleObject.margin;
			_scrollRect.height = _rectHeight-2*_styleObject.margin;
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			_hSlider.addEventListener(Event.CHANGE, onScroll);
			_vSlider.addEventListener(Event.CHANGE, onScroll);
		}
		private function onScroll(evt:Event):void {
			if (evt.target==_hSlider) {
				_scrollRect.x = _hSlider.value / 100 * (_inner.width - _scrollRect.width);
			}else {
				_scrollRect.y = _vSlider.value / 100 * (_inner.height - _scrollRect.height);
			}
			_inner.x = -_scrollRect.x;
			_inner.y = -_scrollRect.y;
		}
		/**
		 * @private
		 */
		override protected function update(evt:Event):void {
			if (_scrollRect.height< _inner.height) {
				if (!contains(_vSlider)) {
					_scrollRect.width = _rectWidth - 2 * _styleObject.margin - _vSlider.width;
					addChild(_vSlider);
					_changed = true;
				}
			}else {
				if (contains(_vSlider)) {
					_scrollRect.width = _rectWidth - 2 * _styleObject.margin;
					removeChild(_vSlider);
					_changed = true;
				}
			}
			if (_scrollRect.width < _inner.width) {
				if (!contains(_hSlider)) {
					_scrollRect.height = _rectHeight-2*_styleObject.margin-_hSlider.height;
					addChild(_hSlider);
					_changed = true;
				}
			}else {
				if (contains(_hSlider)) {
					_scrollRect.width = _rectHeight-2*_styleObject.margin;
					removeChild(_hSlider);
					_changed = true;
				}
			}
			super.update(evt);
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF);
			_mask.graphics.drawRect(0, 0, _scrollRect.width, _scrollRect.height);
			_mask.graphics.endFill();
			if (_border) {
				graphics.lineStyle(_borderStrength, _borderColor);
			}
			graphics.beginFill(_backColor);
			graphics.drawRect(0, 0, _rectWidth, _rectHeight);
			graphics.endFill();
		}
		
		override public function set width(value:Number):void {
			var minWidth:Number = _sliderStyle.barWidth+_sliderStyle.barHeight;
			if (value < minWidth) {
				value = minWidth;
			}
			_rectWidth = value;
			_scrollRect.width = _rectWidth-2*_styleObject.margin;
			_hSlider.width = _rectWidth - _sliderStyle.barHeight;
			_vSlider.x = _hSlider.width;
			_changed = true;
		}
		override public function set height(value:Number):void {
			var minHeight:Number = _sliderStyle.barWidth+_sliderStyle.barHeight;
			if (value < minHeight) {
				
				value = minHeight;
			}
			_rectHeight = value;
			_scrollRect.height = _rectHeight-2*_styleObject.margin;
			_vSlider.height = _rectHeight - _sliderStyle.barHeight;
			_hSlider.y = _vSlider.height;
			_changed = true;
		}
		/**
		 * add new component to this panel, you should call this function instead of call addChild()
		 */
		override public function addComponent(component:DisplayObject):Boolean {
			var result:Boolean = _inner.addComponent(component);
			_changed = true;
			return true;
		}
		/**
		 * add new component to this panel, you should call this function instead of call removeChild()
		 */
		override public function removeComponent(component:DisplayObject):Boolean {
			var result:Boolean = _inner.removeComponent(component);
			_changed = true;
			return result;
		}
		/**
		 * return if this panel contains a specific child, you should call this function instead of call contains()
		 */
		public function containComponent(child:DisplayObject):Boolean {
			return _inner.contains(child);
		}
		/**
		 * back color of this panel
		 */
		public function get backColor():uint {
			return _backColor;
		}
		public function set backColor(value:uint):void {
			_backColor = value;
			_changed = true;
		}
		/**
		 * border color of this panel
		 */
		public function get borderColor():uint {
			return _borderColor;
		}
		public function set borderColor(value:uint):void {
			_borderColor = value;
			_changed = true;
		}
		/**
		 * line strength of the border of this panel
		 */
		public function get borderStrength():Number {
			return _borderStrength;
		}
		public function set borderStrength(value:Number):void {
			_borderStrength = value;
			_changed = true;
		}
		/**
		 * if this panel should show border
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