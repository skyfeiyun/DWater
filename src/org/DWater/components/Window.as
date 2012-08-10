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
	import org.DWater.skin.Style;
	
	/**
	 * Window is often used to organize components.
	 * @author Dong Dong
	 */
	public class Window extends ContainerComponent
	{
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		
		private var _hasCloseButton:Boolean;
		private var _hasMinimizeButton:Boolean;
		private var _draggable:Boolean;
		private var _title:String;
		private var _content:Panel;
		
		private var _minimizeButtonRect:Rectangle;
		private var _closeButtonRect:Rectangle;
		private var _titleButtonRect:Rectangle;
		
		private var _clickItem:String = "";
		
		private var _minimize:Boolean;
		public function Window(parent:Sprite, x:Number, y:Number,title:String="window") 
		{
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_content = new Panel(this, 0, 0);
			_content.border = false;
			
			_minimizeButtonRect = new Rectangle();
			_closeButtonRect = new Rectangle();
			_titleButtonRect = new Rectangle();
			
			_hasCloseButton = true;
			_hasMinimizeButton = true;
			_minimize = false;
			_name = "Window";
			super(parent, x, y);
			this.title = title;
			hasCloseButton = true;
			hasMinimizeButton = true;
			minimize = false;
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
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.CENTER;
			_textField.defaultTextFormat = _textFormat;
			
			_content.x = _styleObject.margin;
			_content.y = _styleObject.titleHeight;
			_content.width = _rectWidth -  2*_styleObject.margin;
			
			_content.height = _rectHeight - _styleObject.titleHeight - _styleObject.margin;
			
			_minimizeButtonRect.x = _styleObject.titleOffsetLeft-_styleObject.lineStrength;
			_minimizeButtonRect.y = (_styleObject.titleHeight - _styleObject.buttonHeight) / 2-_styleObject.lineStrength;
			_minimizeButtonRect.width = _styleObject.buttonWidth+2*_styleObject.lineStrength;
			_minimizeButtonRect.height = _styleObject.buttonHeight+2*_styleObject.lineStrength;
			
			_titleButtonRect.width = _rectWidth;
			_titleButtonRect.height = _styleObject.titleHeight;
			
			_closeButtonRect.x = _styleObject.titleOffsetRight+_rectWidth-_styleObject.rectWidth-_styleObject.lineStrength;
			_closeButtonRect.y = (_styleObject.titleHeight - _styleObject.buttonHeight) / 2-_styleObject.lineStrength;
			_closeButtonRect.width = _styleObject.buttonWidth+2*_styleObject.lineStrength;
			_closeButtonRect.height=_styleObject.buttonHeight+2*_styleObject.lineStrength;
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			graphics.beginFill(_styleObject.backColor);
			if (_minimize) {
				graphics.drawRect(0, 0, _rectWidth, _styleObject.titleHeight + _styleObject.margin);
				if (contains(_content)) {
					_content.container = null;
				}
			}else {
				graphics.drawRect(0, 0, _rectWidth, _rectHeight);
				if (!contains(_content)) {
					_content.container = this;
				}
			}
			graphics.endFill();
			
			graphics.beginFill(_styleObject.titleColor);
			graphics.moveTo(_styleObject.margin, _styleObject.titleHeight);
			graphics.lineTo(_styleObject.margin, _styleObject.titleHeight - _styleObject.margin - _styleObject.radius);
			graphics.curveTo(_styleObject.margin, _styleObject.margin, _styleObject.margin + _styleObject.radius, _styleObject.margin);
			graphics.lineTo(_rectWidth - _styleObject.margin, _styleObject.margin);
			graphics.lineTo(_rectWidth - _styleObject.margin, _styleObject.titleHeight);
			graphics.lineTo(_styleObject.margin, _styleObject.titleHeight);
			graphics.endFill();
			
			var closePath:Vector.<Number>;
			var i:int;
			var a:uint;
			var additionX:Number;
			var additionY:Number;
			var minimalPath:Vector.<Number>;
			if (_hasCloseButton) {
				a = _styleObject.closePath.length;
				closePath = new Vector.<Number>(a);
				additionX = _styleObject.titleOffsetRight + _rectWidth - _styleObject.rectWidth;
				additionY = (_styleObject.titleHeight + _styleObject.margin) / 2;
				for (i = 0; i < a;i+=2 ) {
					closePath[i] = _styleObject.closePath[i] + additionX;
				}
				for (i = 1; i < a;i+=2 ) {
					closePath[i] = _styleObject.closePath[i] + additionY;
				}
				if (_clickItem=="closeBtn" ) {
					graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickOnColor);
				}else {
					graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickOffColor);
				}
				graphics.drawPath(_styleObject.closeCommand, closePath);
			}
			if (_hasMinimizeButton) {
				if (_clickItem=="minimizeBtn" ) {
					graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickOnColor);
				}else {
					graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickOffColor);
				}
				if (minimize) {
					a = _styleObject.miniOnPath.length;
					minimalPath = new Vector.<Number>(a);
					additionX = _styleObject.titleOffsetLeft;
					additionY = (_styleObject.titleHeight + _styleObject.margin) / 2;
					for (i = 0; i < a;i+=2 ) {
						minimalPath[i] = _styleObject.miniOnPath[i]+additionX;
					}
					for (i = 1; i < a;i+=2 ) {
						minimalPath[i] = _styleObject.miniOnPath[i]+additionY;
					}
					graphics.drawPath(_styleObject.miniOnCommand, minimalPath);
				}else {
					a = _styleObject.miniOffPath.length;
					minimalPath = new Vector.<Number>(a);
					additionX = _styleObject.titleOffsetLeft;
					additionY = (_styleObject.titleHeight + _styleObject.margin) / 2;
					for (i = 0; i < a;i+=2 ) {
						minimalPath[i] = _styleObject.miniOffPath[i]+additionX;
					}
					for (i = 1; i < a;i+=2 ) {
						minimalPath[i] = _styleObject.miniOffPath[i]+additionY;
					}
					graphics.drawPath(_styleObject.miniOffCommand, minimalPath);
					
				}
				_textField.x = _styleObject.titleOffsetLeft + _styleObject.buttonWidth + _styleObject.padding;
				_textField.y = (_styleObject.titleHeight-_textField.height + _styleObject.margin) / 2;
			}else {
				_textField.x = _styleObject.titleOffsetLeft;
				_textField.y = (_styleObject.titleHeight-_textField.height + _styleObject.margin) / 2;
			}
		}
		/**
		 * @private
		 */
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
		}
		private function onMouse(evt:MouseEvent):void {
			if (evt.type==MouseEvent.MOUSE_DOWN) {
				_clickItem = getHitArea(mouseX, mouseY);
				switch(_clickItem) {
					case "title":
						if(_draggable) {
							this.startDrag();
						}
						break;
				}
			}else {
				switch(_clickItem) {
					case "minimizeBtn":
						minimize = !minimize;
						break;
					case "closeBtn":
						this.parent.removeChild(this);
						break;
					case "title":
						this.stopDrag();
						break;
				}
				_clickItem = "";
			}
			_changed = true;
		}
		private function getHitArea(x:Number, y:Number):String {
			var item:String = "";
			if (_minimizeButtonRect.contains(x,y)) {
				item = "minimizeBtn";
			}else if (_closeButtonRect.contains(x,y)) {
				item = "closeBtn";
			}else if (_titleButtonRect.contains(x,y)) {
				item = "title";
			}
			return item;
		}
		/**
		 * @copy Panel#addComponent()
		 */
		override public function addComponent(component:DisplayObject):Boolean {
			return _content.addComponent(component);
		}
		/**
		 * @copy Panel#removeComponent()
		 */
		override public function removeComponent(component:DisplayObject):Boolean {
			return _content.removeComponent(component);
		}
		/**
		 * @copy Panel#containComponent()
		 */
		public function containComponent(child:DisplayObject):Boolean {
			return _content.containComponent(child);
		}
		override public function set width(value:Number):void {
			var minWidth:Number = _styleObject.titleOffsetLeft + _styleObject.rectWidth - _styleObject.titleOffsetRight + _styleObject.buttonWidth + 2 * _styleObject.padding + _textField.textWidth;
			if (value< minWidth) {
				value = minWidth;
			}
			_rectWidth = value;
			_content.width = _rectWidth -  2 * _styleObject.margin;
			
			_titleButtonRect.width = _rectWidth;
			
			_closeButtonRect.x = _styleObject.titleOffsetRight-_styleObject.lineStrength+_rectWidth-_styleObject.rectWidth;
			_changed = true;
		}
		override public function set height(value:Number):void {
			_content.height = value-_styleObject.titleHeight;
			_rectHeight = _content.rectHeight + _styleObject.titleHeight+_styleObject.margin;
			_changed = true;
		}
		/**
		 * if this window should show a close button to close this window
		 */
		public function get hasCloseButton():Boolean {
			return _hasCloseButton;
		}
		public function set hasCloseButton(value:Boolean):void {
			_hasCloseButton = value;
			if (_hasCloseButton) {
				_closeButtonRect.width = _styleObject.buttonWidth+2*_styleObject.lineStrength;
			}else {
				_closeButtonRect.width = 0;
			}
			_changed = true;
		}
		/**
		 * if this window should show a minimize button to minimize this window
		 */
		public function get hasMinimizeButton():Boolean {
			return _hasMinimizeButton;
		}
		public function set hasMinimizeButton(value:Boolean):void {
			_hasMinimizeButton = value;
			if (_hasMinimizeButton) {
				_minimizeButtonRect.width = _styleObject.buttonWidth+2*_styleObject.lineStrength;
			}else {
				_minimizeButtonRect.width = 0;
			}
			_changed = true;
		}
		/**
		 * if this window should display in minimize
		 */
		public function get minimize():Boolean {
			return _minimize;
		}
		public function set minimize(value:Boolean):void {
			_minimize = value;
			_changed = true;
		}
		/**
		 * if this window can be dragged
		 */
		public function get draggable():Boolean {
			return _draggable;
		}
		public function set draggable(value:Boolean):void {
			_draggable = value;
		}
		/**
		 * title of this window
		 */
		public function get title():String {
			return _title;
		}
		public function set title(value:String):void {
			_title = value;
			_textField.text = value;
			width = width;
			_changed = true;
		}
		/**
		 * content panel of this window
		 */
		public function get content():Panel {
			return _content;
		}
	}

}