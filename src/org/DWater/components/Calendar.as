package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class Calendar extends Component 
	{
		private var _clickItem:String = "";
		
		private var _firstLeftRectangle:Rectangle;
		private var _firstRightRectangle:Rectangle;
		private var _secondLeftRectangle:Rectangle;
		private var _secondRightRectangle:Rectangle;
		private var _datesRectangle:Rectangle;
		
		private var _totalDates:uint;
		private var _startDay:uint;
		
		private var _titleTextField:TextField;
		private var _textFields:Vector.<TextField>;
		private var _textFormat1:TextFormat;
		private var _textFormat2:TextFormat;
		
		private var _selectedText:TextField;
		
		private var _datesWidth:Number;
		private var _datesHeight:Number;
		
		private var _monthParam:Array = [0, 2, 4, 6, 7, 9, 11];
		private var _months:Array = ["JAN" , "FEB" , "MAR" , "APR" , "MAY" , "JUN" , "JUL" , "AUG" , "SEP" , "OCT" , "NOV" , "DEC"];
		
		private var _date:Date;
		public function Calendar(parent:Sprite, x:Number, y:Number,dateData:Date=null) 
		{
			_textFormat1 = new TextFormat();
			_textFormat2 = new TextFormat();
			
			_titleTextField = new TextField();
			_titleTextField.multiline = false;
			_titleTextField.autoSize = TextFieldAutoSize.LEFT;
			_titleTextField.selectable = false;
			_titleTextField.embedFonts = true;
			_textFields = new Vector.<TextField>();
			
			addChild(_titleTextField);
			_name = "Calendar";
			this.dateData = dateData;
			this.mouseChildren = false;
			super(parent, x, y);
		}
		override protected function initEvent():void {
			super.initEvent();
			addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			addEventListener(MouseEvent.MOUSE_UP, onMouse);
			addEventListener(MouseEvent.MOUSE_OUT, onMouse);
		}
		private function onMouse(evt:MouseEvent):void {
			if (evt.type == MouseEvent.MOUSE_DOWN) {
				_clickItem = getHitArea(mouseX, mouseY);
				if (_clickItem=="firstLeft") {
					month = Math.max(0, _date.month - 1);
				}else if (_clickItem=="firstRight") {
					month = Math.min(_date.month + 1, 11);
				}else if (_clickItem=="secondLeft") {
					year = Math.max(0, _date.fullYear-1);
				}else if (_clickItem=="secondRight") {
					year = _date.fullYear + 1;
				}else if (_clickItem == "") {
					
				}else {
					var selectedDate:int = parseInt(_clickItem)-_startDay+1;
					if (selectedDate >=1 && (selectedDate <= _totalDates)) {
						_date.date = selectedDate;
					}
				}
			}else if (evt.type == MouseEvent.MOUSE_UP || evt.type == MouseEvent.MOUSE_OUT) {
				_clickItem = "";
			}
			_changed = true;
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
			_textFormat1.font=_textFormat2.font = _styleObject.fontName;
			_textFormat1.size = _textFormat2.size = _styleObject.fontSize;
			_textFormat1.color = _styleObject.fontColor;
			_textFormat2.color = _styleObject.backColor;
			_textFormat1.align = _textFormat2.align = TextFormatAlign.LEFT;
			_titleTextField.defaultTextFormat = _textFormat1;
			_titleTextField.text = "00";
			
			var tempText:TextField;
			var offsetX:Number = _styleObject.margin;
			var offsetY:Number = _styleObject.titleHeight + _styleObject.margin;
			
			var paddingX:Number = (_rectWidth - 2 * _styleObject.margin - _titleTextField.width) / 6;
			var paddingY:Number = (_rectHeight - _styleObject.titleHeight - 2 * _styleObject.margin - _titleTextField.height) / 5;
			var isNull:Boolean = (_textFields.length == 0);
			for (var i:int = 0; i < 6;i++ ) {
				for (var j:int = 0; j < 7; j++ ) {
					if (isNull) {
						tempText = new TextField();
						tempText.autoSize = TextFieldAutoSize.LEFT;
						tempText.selectable = false;
						tempText.embedFonts = true;
						addChild(tempText);
						_textFields.push(tempText);
					}else {
						tempText = _textFields[i * 7 + j];
					}
					tempText.defaultTextFormat = _textFormat1;
					tempText.text = "00";
					tempText.x = offsetX + j * paddingX;
					tempText.y = offsetY + i * paddingY;
				}
			}
			_datesWidth = _rectWidth - 2 * _styleObject.margin;
			_datesHeight = _rectHeight-_styleObject.titleHeight-2*_styleObject.margin;
			_titleTextField.y = (_styleObject.titleHeight - _titleTextField.height) / 2;
			
			_firstLeftRectangle = new Rectangle(_styleObject.arrowFirstPadding-3,
												(_styleObject.titleHeight - _styleObject.arrowHeight) / 2-3,
												_styleObject.arrowWidth+6, _styleObject.arrowHeight+6);
			_firstRightRectangle=new Rectangle(_rectWidth-_styleObject.arrowFirstPadding-_styleObject.arrowWidth-3,
												(_styleObject.titleHeight - _styleObject.arrowHeight) / 2-3,
												_styleObject.arrowWidth+6, _styleObject.arrowHeight+6);
			_secondLeftRectangle = new Rectangle(_styleObject.arrowSecondPadding-3,
												(_styleObject.titleHeight - _styleObject.arrowHeight) / 2-3,
												_styleObject.arrowPadding + _styleObject.arrowWidth+6, _styleObject.arrowHeight+6);
			_secondRightRectangle = new Rectangle(_rectWidth-_styleObject.arrowSecondPadding-_styleObject.arrowPadding - _styleObject.arrowWidth-3,
												(_styleObject.titleHeight - _styleObject.arrowHeight) / 2-3,
												_styleObject.arrowPadding + _styleObject.arrowWidth+6, _styleObject.arrowHeight+6);
			_datesRectangle = new Rectangle(_styleObject.margin, _styleObject.titleHeight + _styleObject.margin, _rectWidth - 2 * _styleObject.margin, _rectHeight - _styleObject.titleHeight - 2 * _styleObject.margin);
		}
		override protected function draw():void {
			super.draw();
			selectedText = _textFields[_startDay + _date.date-1];
			graphics.beginFill(_styleObject.backColor);
			graphics.drawRect(0, 0, _rectWidth, _rectHeight);
			graphics.endFill();
			_titleTextField.text = _months[_date.month] + " " + _date.fullYear.toString();
			_titleTextField.x = (_rectWidth - _titleTextField.width) / 2;
			_selectedText.text = "00";
			var offsetX:Number = _selectedText.x + (_selectedText.width - _styleObject.tileWidth) / 2;
			var offsetY:Number = _selectedText.y + (_selectedText.height - _styleObject.tileHeight) / 2;
			
			graphics.beginFill(_styleObject.fontColor);
			graphics.drawRect(offsetX, offsetY, _styleObject.tileWidth, _styleObject.tileHeight);
			graphics.endFill();
			
			if (_clickItem=="secondLeft") {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickColor);
			}else {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.fontColor);
			}
			graphics.moveTo(_styleObject.arrowSecondPadding + _styleObject.arrowWidth,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_styleObject.arrowSecondPadding, _styleObject.titleHeight / 2);
			graphics.lineTo(_styleObject.arrowSecondPadding + _styleObject.arrowWidth,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);
			graphics.moveTo(_styleObject.arrowSecondPadding + _styleObject.arrowWidth+_styleObject.arrowPadding,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_styleObject.arrowSecondPadding+_styleObject.arrowPadding, _styleObject.titleHeight / 2);
			graphics.lineTo(_styleObject.arrowSecondPadding + _styleObject.arrowWidth+_styleObject.arrowPadding,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);	
			if (_clickItem=="secondRight") {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickColor);
			}else {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.fontColor);
			}				
			graphics.moveTo(_rectWidth-(_styleObject.arrowSecondPadding + _styleObject.arrowWidth),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_rectWidth-_styleObject.arrowSecondPadding, _styleObject.titleHeight / 2);
			graphics.lineTo(_rectWidth-(_styleObject.arrowSecondPadding + _styleObject.arrowWidth),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);
							
			graphics.moveTo(_rectWidth-(_styleObject.arrowSecondPadding + _styleObject.arrowWidth+_styleObject.arrowPadding),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_rectWidth-(_styleObject.arrowSecondPadding+_styleObject.arrowPadding), _styleObject.titleHeight / 2);
			graphics.lineTo(_rectWidth-(_styleObject.arrowSecondPadding + _styleObject.arrowWidth+_styleObject.arrowPadding),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);
							
			if (_clickItem=="firstLeft") {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickColor);
			}else {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.fontColor);
			}
			graphics.moveTo(_styleObject.arrowFirstPadding + _styleObject.arrowWidth,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_styleObject.arrowFirstPadding, _styleObject.titleHeight / 2);
			graphics.lineTo(_styleObject.arrowFirstPadding + _styleObject.arrowWidth,
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);
			if (_clickItem=="firstRight") {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.clickColor);
			}else {
				graphics.lineStyle(_styleObject.lineStrength, _styleObject.fontColor);
			}			
			graphics.moveTo(_rectWidth-(_styleObject.arrowFirstPadding + _styleObject.arrowWidth),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2);
			graphics.lineTo(_rectWidth-_styleObject.arrowFirstPadding, _styleObject.titleHeight / 2);
			graphics.lineTo(_rectWidth-(_styleObject.arrowFirstPadding + _styleObject.arrowWidth),
							(_styleObject.titleHeight - _styleObject.arrowHeight) / 2 + _styleObject.arrowHeight);
							
			graphics.lineStyle(1, _styleObject.fontColor);
			graphics.moveTo((_rectWidth - _styleObject.lineWidth) / 2, _styleObject.titleHeight);
			graphics.lineTo((_rectWidth + _styleObject.lineWidth) / 2, _styleObject.titleHeight);
			
			var iteration:int = 1;
			
			for (var i:int = 0; i < 6; i++ ) {
				for (var j:int = 0; j < 7; j++ ) {
					if ((i * 7 + j) >= _startDay) {
						if (iteration<=_totalDates) {
							_textFields[i * 7 + j].text = (iteration >= 10)?iteration.toString():("0" + iteration.toString());
						}else {
							_textFields[i * 7 + j].text = "";
						}
						iteration++;
					}else {
						_textFields[i * 7 + j].text = "";
					}
				}
			}
			_selectedText.setTextFormat(_textFormat2);
		}
		private function getHitArea(x:Number, y:Number):String {
			var item:String = "";
			if (_firstLeftRectangle.contains(x,y)) {
				item = "firstLeft";
			}else if (_firstRightRectangle.contains(x,y)) {
				item = "firstRight";
			}else if (_secondLeftRectangle.contains(x,y)) {
				item = "secondLeft";
			}else if (_secondRightRectangle.contains(x,y)) {
				item = "secondRight";
			}else if (_datesRectangle.contains(x, y)) {
				var xIndex:uint = Math.floor((x - _datesRectangle.x) * 7 / _datesRectangle.width);
				var yIndex:uint = Math.floor((y - _datesRectangle.y) * 6 / _datesRectangle.height);
				item = (yIndex * 7 + xIndex).toString();
			}
			return item;
		}
		private function changedDateParam():void {
			if (_monthParam.indexOf(_date.month)!=-1) {
				_totalDates = 31;
			}else if (_date.month==1) {
				if (((_date.fullYear%4==0)&&(_date.fullYear%100!=0))||(_date.fullYear%400==0)) {
					_totalDates = 29;
				}else {
					_totalDates = 28;
				}
			}else {
				_totalDates = 30;
			}
			var temp:Number = _date.date;
			_date.date = 1;
			_startDay = _date.day;
			_date.date = temp;
		}
		override public function set width(value:Number):void {
			
		}
		override public function set height(value:Number):void {
			
		}
		private function set selectedText(value:TextField):void {
			if (_selectedText) {
				_selectedText.setTextFormat(_textFormat1);
			}
			_selectedText = value;
			_selectedText.setTextFormat(_textFormat2);
		}
		public function get day():Number {
			return _date.day;
		}
		public function get date():Number {
			return _date.date;
		}
		public function set date(value:Number):void {
			_date.date = value;
			_changed = true;
		}
		public function get month():Number {
			return _date.month;
		}
		public function set month(value:Number):void {
			_date.month = value;
			changedDateParam();
			_changed = true;
		}
		public function get year():Number {
			return _date.fullYear;
		}
		public function set year(value:Number):void {
			_date.fullYear = value;
			changedDateParam();
			_changed = true;
		}
		public function set dateData(value:Date):void {
			if (!value) {
				_date = new Date();
			}else {
				_date = value;
			}
			changedDateParam();
			_changed = true;
		}
	}

}