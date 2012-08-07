package org.DWater.charts 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.components.Component;
	import org.DWater.utils.DCalculator.DParser;
	
	/**
	 * ...
	 * @author Dong Dong
	 */
	public class Coordinate extends Component 
	{
		private var _lbText:TextField;
		private var _rbText:TextField;
		private var _ltText:TextField;
		private var _rtText:TextField;
		
		private var _textFormat:TextFormat;
		
		private var _xMin:Number;
		private var _xMax:Number;
		private var _yMin:Number;
		private var _yMax:Number;
		
		private var _funcs:Array;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		private var _contentChanged:Boolean;
		
		private var _canvasBMD:BitmapData;
		private var _canvasBMP:Bitmap;
		
		private var _bmdX:Number;
		private var _bmdY:Number;
		
		private var _showTile:Boolean;
		public function Coordinate(parent:Sprite = null, x:Number = 0, y:Number = 0, xMin:Number = 0, xMax:Number = 100, yMin:Number = 0,yMax:Number=100 ) 
		{	
			_canvasBMP = new Bitmap();
			addChild(_canvasBMP);
			
			_textFormat = new TextFormat();
			
			_lbText = new TextField();
			_lbText.autoSize = TextFieldAutoSize.RIGHT;
			_lbText.selectable = false;
			_lbText.embedFonts = true;
			addChild(_lbText);
			
			_ltText = new TextField();
			_ltText.autoSize = TextFieldAutoSize.RIGHT;
			_ltText.selectable = false;
			_ltText.embedFonts = true;
			addChild(_ltText);
			
			_rtText = new TextField();
			_rtText.autoSize = TextFieldAutoSize.LEFT;
			_rtText.selectable = false;
			_rtText.embedFonts = true;
			addChild(_rtText);
			
			_rbText = new TextField();
			_rbText.autoSize = TextFieldAutoSize.LEFT;
			_rbText.selectable = false;
			_rbText.embedFonts = true;
			addChild(_rbText);
			
			_xMin = xMin;
			_xMax = xMax;
			_yMin = yMin;
			_yMax = yMax;
			
			_funcs = [];
			
			_showTile = false;
			_contentChanged = true;
			
			_name = "Coordinate";
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
			if (isNaN(_tileWidth)||((_styleObject.tileWidth!=lastStyle.tileWidth)&&(lastStyle.tileWidth==_tileWidth))) {
				_tileWidth = _styleObject.tileWidth;
			}
			if (isNaN(_tileHeight)||((_styleObject.tileHeight!=lastStyle.tileHeight)&&(lastStyle.tileHeight==_tileHeight))) {
				_tileHeight = _styleObject.tileHeight;
			}
			
			_textFormat.font = _styleObject.fontName;
			_textFormat.size = _styleObject.fontSize;
			_textFormat.color = _styleObject.fontColor;
			_textFormat.align = TextFormatAlign.CENTER;
			_lbText.defaultTextFormat = _textFormat; 
			_ltText.defaultTextFormat = _textFormat; 
			_rbText.defaultTextFormat = _textFormat; 
			_rtText.defaultTextFormat = _textFormat; 
			
			if (_canvasBMD) {
				_canvasBMD.dispose();
			}
			_canvasBMD = new BitmapData(_rectWidth, _rectHeight, true, 0);
			_canvasBMP.bitmapData = _canvasBMD;
			_canvasBMP.y = -_rectHeight;
		}
		override protected function draw():void {
			super.draw();
			
			_lbText.text = "(" + _xMin.toString() + "," + _yMin.toString() + ")";
			_ltText.text = "(" + _xMin.toString() + "," + _yMax.toString() + ")";
			_rbText.text = "(" + _xMax.toString() + "," + _yMin.toString() + ")";
			_rtText.text = "(" + _xMax.toString() + "," + _yMax.toString() + ")";
			
			_lbText.x = -_lbText.width - _styleObject.paddingX;
			_lbText.y = _styleObject.paddingY;
			
			_ltText.x = -_ltText.width - _styleObject.paddingX;
			_ltText.y = -_rectHeight - _ltText.height - _styleObject.paddingY;
			
			_rbText.x = _rectWidth + _styleObject.paddingX;
			_rbText.y = _styleObject.paddingY;
			
			_rtText.x = _rectWidth + _styleObject.paddingX;
			_rtText.y = -_rectHeight - _rtText.height - _styleObject.paddingY;
			
			graphics.lineStyle(_styleObject.lineStrength, _styleObject.borderColor);
			graphics.beginFill(_styleObject.backColor);
			graphics.drawRect(0, -_rectHeight, _rectWidth, _rectHeight);
			graphics.endFill();
			if (_showTile) {
				var xLines:uint = Math.floor(_rectWidth / _tileWidth);
				var yLines:uint = Math.floor(_rectHeight / _tileHeight);
				
				var xPos:Number = _tileWidth;
				var yPos:Number = -_tileHeight;
				for (var i:int = 0; i < xLines;i++ ) {
					graphics.moveTo(xPos, 0);
					graphics.lineTo(xPos, -_rectHeight);
					xPos += _tileWidth;
				}
				for (i = 0; i < yLines;i++ ) {
					graphics.moveTo(0, yPos);
					graphics.lineTo(_rectWidth, yPos);
					yPos -= _tileHeight;
				}
			}
			
			graphics.lineStyle(_styleObject.lineStrength, _styleObject.axisColor);
			if (_xMin<=0&&_xMax>=0) {
				graphics.moveTo( -_xMin / (_xMax - _xMin) * _rectWidth, 0);
				graphics.lineTo( -_xMin / (_xMax - _xMin) * _rectWidth, -_rectHeight);
			}
			if (_yMin <= 0 && _yMax>=0) {
				graphics.moveTo(0, _yMin / (_yMax - _yMin) * _rectHeight);
				graphics.lineTo(_rectWidth,_yMin / (_yMax - _yMin) * _rectHeight);
			}
			if (_contentChanged) {
				_contentChanged = false;
				var a:uint = _funcs.length;
				if (a==0) {
					return;
				}
				_canvasBMD.lock();
				_canvasBMD.fillRect(_canvasBMD.rect, 0);
				var w:int = _canvasBMD.width;
				var h:int = _canvasBMD.height;
				
				var xBase:Number = (_xMax - _xMin)/w;
				var yBase:Number = (_yMax - _yMin)/h;
				var distBase:Number = Math.sqrt(xBase * xBase + yBase * yBase);
				
				var heightMap:Vector.<Vector.<int>> = new Vector.<Vector.<int>>(w,true);
				var yIndex:Vector.<int>;
				var func:Object;
				for (var i:int = 0; i < w; i++ ) {
					yIndex= new Vector.<int>(h, true);
					heightMap[i] = yIndex;
					for (var j:int = 0; j < h; j++ ) {
						yIndex[j] = -1;
						for (var k:int = a - 1; k >=0;k-- ) {
							func = _funcs[k];
							if (func.type=="DParser2") {
								if (Math.abs(func.funcObject.calculate([ { name:func.xVarName, value:i * xBase + _xMin }, { name:func.yVarName, value:_yMin + (h - j) * yBase } ])) < func.error * distBase) {
									yIndex[j] = k;
									_canvasBMD.setPixel32(i, j, func.color);
									break;
								}
							}else if(func.type=="Function2"){
								if (Math.abs(func.funcObject(i * xBase + _xMin, _yMin + (h - j) * yBase)) < func.error*distBase) {
									yIndex[j] = k;
									_canvasBMD.setPixel32(i, j, func.color);
									break;
								}
							}
						}
					}
				}
				var xpos:Number;
				var ypos:Number;
				var lastRight:Boolean;
				for (k = a - 1; k >= 0; k-- ) {
					func = _funcs[k];
					lastRight = false;
					bmdMoveTo(0, 0);
					if (func.type=="DParser1") {
						if (func.reverse) {
							for (i = 0; i < h; i++ ) {
								xpos = func.funcObject.calculate( { name:func.varName, value:i * xBase + _xMin } );
								
								if (!isNaN(xpos)) {
									xpos = int((xpos - _xMin) / xBase);
									if (lastRight) {
										bmdLineTo(_canvasBMD, xpos, i, func.color,heightMap,k);
									}else {
										bmdMoveTo(xpos, i);
										_canvasBMD.setPixel32(xpos, i, func.color);
									}
									lastRight = true;
								}else {
									lastRight = false;
								}
							}
						}else {
							for (i = 0; i < w; i++ ) {
								ypos = func.funcObject.calculate( { name:func.varName, value:i * xBase + _xMin } );
								if (!isNaN(ypos)) {
									ypos = int(h - (ypos - yMin) / yBase);
									if (lastRight) {
										bmdLineTo(_canvasBMD, i, ypos, func.color,heightMap,k);
									}else {
										bmdMoveTo(i, ypos);
										_canvasBMD.setPixel32(i,ypos, func.color);
									}
									lastRight = true;
								}else {
									lastRight = false;
								}
							}
						}
					}else if (func.type=="Function1") {
						if (func.reverse) {
							for (i = 0; i < h; i++ ) {
								xpos = func.funcObject((h-i) * yBase + _yMin);
								if (!isNaN(xpos)) {
									xpos = int((xpos - _xMin) / xBase);
									if (lastRight) {
										bmdLineTo(_canvasBMD, xpos, i, func.color,heightMap,k);
									}else {
										bmdMoveTo(xpos, i);
										_canvasBMD.setPixel32(xpos, i, func.color);
									}
									lastRight = true;
								}else {
									lastRight = false;
								}
							}
						}else {
							for (i = 0; i < w; i++ ) {
								ypos = func.funcObject(i * xBase + _xMin);
								
								if (!isNaN(ypos)) {
									ypos = int(h - (ypos - yMin) / yBase);
									if (lastRight) {
										bmdLineTo(_canvasBMD, i, ypos, func.color, heightMap, k);
									}else {
										bmdMoveTo(i, ypos);
										_canvasBMD.setPixel32(i,ypos, func.color);
									}
									lastRight = true;
								}else {
									lastRight = false;
								}
							}
						}
					}
				}
				_canvasBMD.unlock();
			}
		}
		override public function set width(value:Number):void {
			var temp:BitmapData = new BitmapData(value, _rectHeight, true, 0);
			var scale:Matrix = new Matrix();
			scale.scale(value / _rectWidth, 1);
			temp.lock();
			temp.draw(_canvasBMD, scale);
			temp.unlock();
			_canvasBMD.dispose();
			_canvasBMP.bitmapData = temp;
			_canvasBMD = temp;
			_rectWidth = value;
			_changed = true;
		}
		override public function set height(value:Number):void {
			var temp:BitmapData = new BitmapData(_rectWidth, value, true, 0);
			var scale:Matrix = new Matrix();
			scale.scale(1, value / _rectHeight);
			temp.lock();
			temp.draw(_canvasBMD, scale);
			temp.unlock();
			_canvasBMD.dispose();
			_canvasBMP.bitmapData = temp;
			_canvasBMP.y = -value;
			_canvasBMD = temp;
			_rectHeight = value;
			_changed = true;
		}
		public function get xMin():Number {
			return _xMin;
		}
		public function set xMin(value:Number):void {
			_xMin = value;
			_changed = true;
			_contentChanged = true;
		}
		public function get xMax():Number {
			return _xMax;
		}
		public function set xMax(value:Number):void {
			_xMax = value;
			_changed = true;
			_contentChanged = true;
		}
		public function get yMin():Number {
			return _yMin;
		}
		public function set yMin(value:Number):void {
			_yMin = value;
			_changed = true;
			_contentChanged = true;
		}
		public function get yMax():Number {
			return _yMax;
		}
		public function set yMax(value:Number):void {
			_yMax = value;
			_changed = true;
			_contentChanged = true;
		}
		public function get showTile():Boolean {
			return _showTile;
		}
		public function set showTile(value:Boolean):void {
			_showTile = value;
			_changed = true;
		}
		
		public function drawFunction3(functionString:String, xVarName:String="x",yVarName:String="y",lineColor:uint=0xff000000,error:Number=1e-3):void {
			var func:Object = new Object();
			var parser:DParser=new DParser(functionString, [xVarName, yVarName]);
			func.funcObject = parser;
			func.type = "DParser2";
			func.xVar = xVarName;
			func.yVar = yVarName;
			func.error = error;
			func.color = lineColor;
			
			_canvasBMD.lock();
			var w:int = _canvasBMD.width;
			var h:int = _canvasBMD.height;
			
			var xBase:Number = (_xMax - _xMin)/w;
			var yBase:Number = (_yMax - _yMin)/h;
			var distBase:Number = Math.sqrt(xBase * xBase + yBase * yBase);
			
			for (var i:int = 0; i < w;i++ ) {
				for (var j:int = 0; j < h;j++ ) {
					if (Math.abs(parser.calculate([{name:xVarName,value:i*xBase+_xMin},{name:yVarName,value:_yMin+(h-j)*yBase}]))<error*distBase) {
						_canvasBMD.setPixel32(i, j, lineColor);
					}
				}
			}
			_canvasBMD.unlock();
			_funcs.push(func);
		}
		public function drawFunction4(functionObject:Function,lineColor:uint=0xff000000,error:Number=1e-3):void {
			var func:Object = new Object();
			func.funcObject = functionObject;
			func.type = "Function2";
			func.error = error;
			func.color = lineColor;
			
			_canvasBMD.lock();
			var w:int = _canvasBMD.width;
			var h:int = _canvasBMD.height;
			
			var xBase:Number = (_xMax - _xMin)/w;
			var yBase:Number = (_yMax - _yMin)/h;
			var distBase:Number = Math.sqrt(xBase * xBase + yBase * yBase);
			
			for (var i:int = 0; i < w;i++ ) {
				for (var j:int = 0; j < h;j++ ) {
					if (Math.abs(functionObject(i*xBase+_xMin,_yMin+(h-j)*yBase))<error*distBase) {
						_canvasBMD.setPixel32(i, j, lineColor);
					}
				}
			}
			_canvasBMD.unlock();
			_funcs.push(func);
		}
		public function drawFunction2(functionObject:Function, lineColor:uint = 0xff000000, reverse:Boolean = false):void {
			var func:Object = new Object();
			func.funcObject = functionObject;
			func.type = "Function1";
			func.color = lineColor;
			func.reverse = reverse;
			
			_canvasBMD.lock();
			var w:int = _canvasBMD.width;
			var h:int = _canvasBMD.height;
			
			var xBase:Number = (_xMax - _xMin)/w;
			var yBase:Number = (_yMax - _yMin)/h;
			var i:int;
			var xpos:Number;
			var ypos:Number;
			var lastRight:Boolean = false;
			if (reverse) {
				for (i = 0; i < h; i++ ) {
					xpos = functionObject((h-i) * yBase + _yMin);
					
					if (!isNaN(xpos)) {
						xpos = int((xpos - _xMin) / xBase);
						if (lastRight) {
							bmdLineTo(_canvasBMD, xpos, i, lineColor);
						}else {
							bmdMoveTo(xpos, i);
							_canvasBMD.setPixel32(xpos, i, lineColor);
						}
						lastRight = true;
					}else {
						lastRight = false;
					}
				}
			}else {
				for (i = 0; i < w; i++ ) {
					ypos = functionObject(i * xBase + _xMin);
					if (!isNaN(ypos)) {
						ypos = int(h - (ypos - yMin) / yBase);
						if (lastRight) {
							bmdLineTo(_canvasBMD, i, ypos, lineColor);
						}else {
							bmdMoveTo(i, ypos);
							_canvasBMD.setPixel32(i,ypos, lineColor);
						}
						lastRight = true;
					}else {
						lastRight = false;
					}
				}
			}
			_canvasBMD.unlock();
			_funcs.push(func);
		}
		public function drawFunction(functionString:String,varName:String="x", lineColor:uint = 0xff000000, reverse:Boolean = false):void {
			var func:Object = new Object();
			var parser:DParser=new DParser(functionString, [varName]);
			func.funcObject = parser;
			func.type = "DParser1";
			func.varName = varName;
			func.color = lineColor;
			func.reverse = reverse;
			
			_canvasBMD.lock();
			var w:int = _canvasBMD.width;
			var h:int = _canvasBMD.height;
			
			var xBase:Number = (_xMax - _xMin)/w;
			var yBase:Number = (_yMax - _yMin)/h;
			var i:int;
			var xpos:Number;
			var ypos:Number;
			var lastRight:Boolean=false;
			if (reverse) {
				for (i = 1; i < h; i++ ) {
					xpos = parser.calculate([ { name:varName, value:(h - i) * yBase + _yMin } ]);
					if (!isNaN(xpos)) {
						xpos = int((xpos - _xMin) / xBase);
						if (lastRight) {
							bmdLineTo(_canvasBMD, xpos, i, lineColor);
						}else {
							bmdMoveTo(xpos, i);
							_canvasBMD.setPixel32(xpos, i, lineColor);
						}
						lastRight = true;
					}else {
						lastRight = false;
					}
				}
			}else {
				for (i = 1; i < w; i++ ) {
					ypos = parser.calculate([ { name:varName, value:i * xBase + _xMin } ]);
					
					if (!isNaN(ypos)) {
						ypos = int(h - (ypos - yMin) / yBase);
						if (lastRight) {
							bmdLineTo(_canvasBMD, i, ypos, lineColor);
						}else {
							bmdMoveTo(i, ypos);
							_canvasBMD.setPixel32(i,ypos, lineColor);
						}
						lastRight = true;
					}else {
						lastRight = false;
					}
				}
			}
			_canvasBMD.unlock();
			_funcs.push(func);
		}
		private function bmdMoveTo(x:Number, y:Number):void {
			_bmdX = x;
			_bmdY = y;
		}
		private function bmdLineTo(bmd:BitmapData, x:Number, y:Number,color:uint, heightMap:Vector.<Vector.<int>>=null,index:int=-1):void {
			var startX:Number = _bmdX;
			var startY:Number = _bmdY;
			var endX:Number = x;
			var endY:Number = y;
			
			var colStepper:int=1;
			var rowStepper:int=1;
			var delta:int;
			var nowX:uint;
			var nowY:uint;
			var colLength:int;
			var rowLength:int;
			var i:uint;
			
			colLength = Math.abs(endX - startX);
			rowLength = Math.abs(endY - startY);
			if (startX>endX) {
				colStepper = -1;
			}
			if (startY>endY) {
				rowStepper = -1;
			}
			if (colLength>rowLength) {
				delta = rowLength - colLength;
				nowX = startX;
				nowY = startY;
				for (i = 0; i < colLength; i++ ) {
					if (heightMap) {
						if (index > heightMap[nowX][nowY]) {
							heightMap[nowX][nowY] = index;
							bmd.setPixel32(nowX, nowY, color);
						}
					}else {
						bmd.setPixel32(nowX, nowY, color);
					}
					delta += rowLength;
					nowX+=colStepper;
					if (delta>0) {
						delta -= colLength;
						nowY+=rowStepper;
					}
				}
			}else {
				delta = colLength-rowLength;
				nowX = startX;
				nowY = startY;
				for (i = 0; i < rowLength; i++ ) {
					if (heightMap) {
						if (index > heightMap[nowX][nowY]) {
							heightMap[nowX][nowY] = index;
							bmd.setPixel32(nowX, nowY, color);
						}
					}else {
						bmd.setPixel32(nowX, nowY, color);
					}
					delta += colLength;
					nowY += rowStepper;
					if (delta>0) {
						delta -= rowLength;
						nowX += colStepper;
					}
				}
			}
			
			_bmdX = x;
			_bmdY = y;
		}
		public function clearFunctionAt(index:uint):void {
			_funcs.splice(index, 1);
			_changed = true;
			_contentChanged = true;
		}
		public function clearCanvas():void {
			_funcs = [];
			_canvasBMD.lock()
			_canvasBMD.fillRect(_canvasBMD.rect, 0);
			_canvasBMD.unlock();
		}
	}

}