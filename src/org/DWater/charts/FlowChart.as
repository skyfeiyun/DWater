package org.DWater.charts 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.components.Component;
	import org.DWater.events.DWaterSelectedEvent;
	/**
	 * ...
	 * @author Dong Dong
	 */
	[Event(name = "select", type = "org.DWater.events.DWaterEvent")]
	public class FlowChart extends Component
	{
		private var _charts:Vector.<Sprite>;
		private var _textFields:Vector.<TextField>;
		private var _textFormat:TextFormat;
		private var _idealWidth:Vector.<Number>;
		private var _textFormat2:TextFormat;
		
		private var _datas:Array;
		
		private var _overIndex:int;
		public function FlowChart(parent:Sprite, x:Number, y:Number,datas:Array) 
		{
			_textFormat = new TextFormat();
			_textFormat2 = new TextFormat();
			_textFields = new Vector.<TextField>();
			_idealWidth = new Vector.<Number>();
			_charts = new Vector.<Sprite>();
			_overIndex = -1;
			_name = "FlowChart";
			super(parent, x, y);
			this.datas = datas;
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
			_textFormat.font=_textFormat2.font = _styleObject.fontName;
			_textFormat.size=_textFormat2.size = _styleObject.fontSize;
			_textFormat.align = _textFormat2.align = TextFormatAlign.LEFT;
			_textFormat.color = _styleObject.fontUpColor;
			_textFormat2.color = _styleObject.fontOverColor;
		}
		override protected function draw():void {
			super.draw();
			var a:uint = _textFields.length;
			var y1:Number = (_rectHeight - _styleObject.arcHeight * 2) / 2;
			var y2:Number = _rectHeight - y1;
			if (a!=0) {
				if (0!=_overIndex) {
					_charts[0].graphics.beginFill(_styleObject.fillUpColor);
					_textFields[0].setTextFormat(_textFormat);
				}else {
					_charts[0].graphics.beginFill(_styleObject.fillOverColor);
					_textFields[0].setTextFormat(_textFormat2);
				}
				_charts[0].graphics.lineTo(_idealWidth[0], 0);
				_charts[0].graphics.lineTo(_idealWidth[0], y1);
				_charts[0].graphics.lineTo(_idealWidth[0] + _styleObject.arcWidth, y1 + _styleObject.arcHeight);
				_charts[0].graphics.lineTo(_idealWidth[0], y2);
				_charts[0].graphics.lineTo(_idealWidth[0], _rectHeight);
				_charts[0].graphics.lineTo(0, _rectHeight);
				_charts[0].graphics.lineTo(0, 0);
				_charts[0].graphics.endFill();
			}
			for (var i:int = 1; i < a;i++) {
				if (i!=_overIndex) {
					_charts[i].graphics.beginFill(_styleObject.fillUpColor);
					_textFields[i].setTextFormat(_textFormat);
				}else {
					_charts[i].graphics.beginFill(_styleObject.fillOverColor);
					_textFields[i].setTextFormat(_textFormat2);
				}
				_charts[i].graphics.lineTo(_idealWidth[i], 0);
				_charts[i].graphics.lineTo(_idealWidth[i], y1);
				_charts[i].graphics.lineTo(_idealWidth[i] + _styleObject.arcWidth, y1 + _styleObject.arcHeight);
				_charts[i].graphics.lineTo(_idealWidth[i], y2);
				_charts[i].graphics.lineTo(_idealWidth[i], _rectHeight);
				_charts[i].graphics.lineTo(0, _rectHeight);
				_charts[i].graphics.lineTo(0, y2);
				_charts[i].graphics.lineTo(_styleObject.arcWidth, y1 + _styleObject.arcHeight);
				_charts[i].graphics.lineTo(0, y1);
				_charts[i].graphics.lineTo(0, 0);
				_charts[i].graphics.endFill();
			}
		}
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.MOUSE_OUT, onItem);
		}
		private function onItem(evt:MouseEvent):void {
			if (evt.type==MouseEvent.MOUSE_OUT) {
				_overIndex = -1;
			}else if (evt.type==MouseEvent.MOUSE_OVER) {
				_overIndex = _charts.indexOf(evt.target);
			}else if (evt.type==MouseEvent.MOUSE_DOWN) {
				dispatchEvent(new DWaterSelectedEvent(DWaterSelectedEvent.SELECT, _charts.indexOf(evt.target)));
			}
			_changed = true;
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		public function addItemAt(value:Object, index:uint):void {
			if (!_datas) {
				_datas = [];
			}
			if (index>=_datas.length) {
				return;
			}
			_datas.splice(index, 0, value);
			var newText:TextField = new TextField();
			newText.mouseEnabled = false;
			newText.autoSize = TextFieldAutoSize.LEFT;
			newText.selectable = false;
			newText.embedFonts = true;
			newText.defaultTextFormat = _textFormat;
			newText.text = value.label;
			var idealWidth:Number = Math.max(newText.width + 2 * _styleObject.paddingX, _rectWidth);
			var chart:Sprite = new Sprite();
			chart.addEventListener(MouseEvent.MOUSE_OVER, onItem);
			chart.addEventListener(MouseEvent.MOUSE_DOWN, onItem);
			if (index>=1) {
				chart.x=_textFields[index-1].x + _idealWidth[index-1] + _styleObject.paddingX;
			}
			newText.x = chart.x + (idealWidth - newText.width) / 2
			newText.y = (_rectHeight - newText.height) / 2;
			_textFields.splice(index, 0, newText);
			_charts.splice(index, 0, chart);
			_idealWidth.splice(index, 0, idealWidth);
			addChild(chart);
			addChild(newText);
			
			var a:uint = _datas.length;
			for (var i:uint = index + 1; i < a; i++ ) {
				_charts[i].x += _styleObject.paddingX + idealWidth;
				_textFields[i].x += _styleObject.paddingX+idealWidth;
			}
			_changed = true;
		}
		public function removeItemAt(index:uint):void {
			if (!_datas) {
				return;
			}
			if (index>=_datas.length) {
				return;
			}
			_datas.splice(index, 1);
			var idealWidth:Number = _idealWidth.splice(index, 1)[0];
			var tempChart:Sprite = _charts.splice(index, 1)[0];
			tempChart.removeEventListener(MouseEvent.MOUSE_OVER, onItem);
			tempChart.removeEventListener(MouseEvent.MOUSE_DOWN, onItem);
			removeChild(_textFields.splice(index, 1)[0]);
			removeChild(tempChart);
			var a:uint = _datas.length;
			for (var i:uint = index; i < a;i++ ) {
				_charts[i].x -= _styleObject.paddingX + idealWidth;
				_textFields[i].x -= _styleObject.paddingX+idealWidth;
			}
			_changed = true;
		}
		public function addItem(value:Object):void {
			if (!_datas) {
				_datas = [];
			}
			_datas.push(value);
			var newText:TextField = new TextField();
			newText.mouseEnabled = false;
			newText.autoSize = TextFieldAutoSize.LEFT;
			newText.selectable = false;
			newText.embedFonts = true;
			newText.defaultTextFormat = _textFormat;
			newText.text = value.label;
			var idealWidth:Number = Math.max(newText.width + 2 * _styleObject.paddingX, _rectWidth);
			var chart:Sprite = new Sprite();
			chart.addEventListener(MouseEvent.MOUSE_OVER, onItem);
			chart.addEventListener(MouseEvent.MOUSE_DOWN, onItem);
			var index:int = _textFields.length;
			if (index>=1) {
				chart.x=_textFields[index-1].x + _idealWidth[index-1] + _styleObject.paddingX;
			}
			newText.x = chart.x + (idealWidth - newText.width) / 2
			newText.y = (_rectHeight - newText.height) / 2;
			_textFields.push(newText);
			_charts.push(chart);
			_idealWidth.push(idealWidth);
			addChild(chart);
			addChild(newText);
			
			_changed = true;
		}
		public function removeItem(value:Object):void {
			var index:int = datas.indexOf(value);
			if (index==-1) {
				return;
			}
			_datas.splice(index, 1);
			var idealWidth:Number = _idealWidth.splice(index, 1)[0];
			var tempChart:Sprite = _charts.splice(index, 1)[0];
			tempChart.removeEventListener(MouseEvent.MOUSE_OVER, onItem);
			tempChart.removeEventListener(MouseEvent.MOUSE_DOWN, onItem);
			removeChild(_textFields.splice(index, 1)[0]);
			removeChild(tempChart);
			var a:uint = _datas.length;
			for (var i:uint = index; i < a;i++ ) {
				_charts[i].x -= _styleObject.paddingX + idealWidth;
				_textFields[i].x -= _styleObject.paddingX+idealWidth;
			}
			_changed = true;
		}
		public function get datas():Array {
			return _datas;
		}
		public function set datas(value:Array):void {
			var tempText:TextField;
			var tempChart:Sprite;
			var a:uint = Math.min(value.length, _textFields.length);
			var b:uint = value.length;
			var c:uint = _textFields.length;
			
			var pileOffsetX:Number = 0;
			var idealWidth:Number;
			for (var i:uint = 0; i < a;i++ ) {
				tempText = _textFields[i];
				tempText.text = value[i].label;
				tempChart = _charts[i];
				tempChart.x = pileOffsetX;
				idealWidth = Math.max(tempText.width + 2 * _styleObject.paddingX, _rectWidth);
				_idealWidth[i] = idealWidth;
				pileOffsetX += idealWidth+_styleObject.paddingX;
				tempText.x = tempChart.x + (idealWidth - tempText.width) / 2;
			}
			for (; i < b;i++ ) {
				tempText = new TextField();
				tempText.mouseEnabled = false;
				tempText.autoSize = TextFieldAutoSize.LEFT;
				tempText.selectable = false;
				tempText.embedFonts = true;
				tempText.defaultTextFormat = _textFormat;
				tempText.text = value[i].label;
				tempChart = new Sprite();
				tempChart.addEventListener(MouseEvent.MOUSE_OVER, onItem);
				tempChart.addEventListener(MouseEvent.MOUSE_DOWN, onItem);
				tempChart.x = pileOffsetX;
				idealWidth = Math.max(tempText.width + 2 * _styleObject.paddingX, _rectWidth);
				_idealWidth.push(idealWidth);
				pileOffsetX += idealWidth+_styleObject.paddingX;
				tempText.x = tempChart.x + (idealWidth - tempText.width) / 2;
				tempText.y = (_rectHeight - tempText.height) / 2;
				
				_textFields.push(tempText);
				_charts.push(tempChart);
				addChild(tempChart);
				addChild(tempText);
			}
			for (; i < c; i++ ) {
				tempChart = _charts.pop();
				tempChart.removeEventListener(MouseEvent.MOUSE_OVER, onItem);
				tempChart.removeEventListener(MouseEvent.MOUSE_DOWN, onItem);
				removeChild(_textFields.pop());
				removeChild(tempChart);
				_idealWidth.pop();
			}
			_datas = value;
			_changed = true;
		}
	}

}