package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class FPSMeter extends Component 
	{
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		
		private var _milliseconds:int;
		private var _frequent:Number;
		private var _frequents:Vector.<Number>;
		private var _usedMemories:Vector.<Number>;
		private var _totalMemory:Number;
		private var _usedMemory:Number;
		private var _prefix:String;
		private var _showChart:Boolean;
		public function FPSMeter(parent:Sprite, x:Number, y:Number, prefix:String="" ) 
		{
			_textFormat = new TextFormat();
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.RIGHT;
			_textField.selectable = false;
			_textField.embedFonts = true;
			addChild(_textField);
			_name = "FPSMeter";
			_showChart = true;
			_prefix = prefix;
			_milliseconds = getTimer();
			_frequents = new Vector.<Number>();
			_usedMemories = new Vector.<Number>();
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
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.RIGHT;
			_textField.defaultTextFormat = _textFormat;
		}
		override protected function draw():void {
			super.draw();
			var frameRate:Number = stage.frameRate;
			_textField.text = _prefix + "FPS:" + _frequent.toFixed(1) + "   "+ _usedMemory.toFixed(2) + "/" + _totalMemory.toFixed(2)+"MB";
			if (_showChart) {
				_textField.autoSize = TextFieldAutoSize.RIGHT;
				_textFormat.align = TextFormatAlign.RIGHT;
				_textField.setTextFormat(_textFormat);
				graphics.beginFill(_styleObject.backColor);
				graphics.drawRect(0, 0, _rectWidth, _rectHeight);
				graphics.endFill();
				var a:uint = _frequents.length;
				graphics.lineStyle(0, _styleObject.fpsLineColor);
				if (a>0) {
					graphics.moveTo(0, Math.max(_rectHeight-_frequents[0] / frameRate * _rectHeight,0));
				}
				for (var i:int = 1; i < a;i++ ) {
					graphics.lineTo(i, Math.max(_rectHeight-_frequents[i] / frameRate * _rectHeight,0));
				}
				a = _usedMemories.length;
				graphics.lineStyle(0, _styleObject.memoryLineColor);
				if (a>0) {
					graphics.moveTo(0, Math.max(_rectHeight-_usedMemories[0] / _totalMemory * _rectHeight/2,0));
				}
				for (i = 1; i < a;i++ ) {
					graphics.lineTo(i, Math.max(_rectHeight-_usedMemories[i] / _totalMemory * _rectHeight/2,0));
				}
				_textField.x = _rectWidth - _textField.width;
				_textField.y = _rectHeight + _styleObject.padding;
			}else {
				_textField.autoSize = TextFieldAutoSize.LEFT;
				_textFormat.align = TextFormatAlign.LEFT;
				_textField.setTextFormat(_textFormat);
				_textField.x = 0;
				_textField.y = 0;
			}
		}
		override protected function update(evt:Event):void {
			var t:int = getTimer();
			var dt:int = t - _milliseconds;
			_milliseconds = t;
			_frequent = 1000 / dt;
			_totalMemory = System.totalMemory / 1024 / 1024;
			_usedMemory = _totalMemory - System.freeMemory / 1024 / 1024;
			_frequents.push(_frequent);
			_usedMemories.push(_usedMemory);
			if (_frequents.length>int(_rectWidth)) {
				_frequents.shift();
			}
			if (_usedMemories.length>int(_rectWidth)) {
				_usedMemories.shift();
			}
			_changed = true;
			super.update(evt);
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		public function start():void {
			if (!hasEventListener(Event.ENTER_FRAME)) {
				addEventListener(Event.ENTER_FRAME, update);
			}
		}
		public function stop():void {
			if (hasEventListener(Event.ENTER_FRAME)) {
				removeEventListener(Event.ENTER_FRAME, update);
			}
		}
		public function get showChart():Boolean {
			return _showChart;
		}
		public function set showChart(value:Boolean):void {
			if (value==showChart) {
				return;
			}
			_showChart = value;
			_changed = true;
		}
		public function get frequent():Number {
			return _frequent;
		}
		public function get totalMemory():Number {
			return _totalMemory;
		}
		public function get usedMemory():Number {
			return _usedMemory;
		}
		public function get prefix():String {
			return _prefix;
		}
		public function set prefix(value:String):void {
			_prefix = value;
			_changed = true;
		}
	}

}