package org.DWater.skin
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import org.DWater.components.ColorChooser;
	import org.DWater.components.Component;
	
	/**
	 * ...
	 * @author dongdong
	 */
	[Event(name = "change", type = "flash.events.Event")]
	public class Style extends EventDispatcher
	{
		[Embed(source = "/../assets/font.ttf", embedAsCFF = "false", fontName = "ZHSCNMT-GBK", mimeType = "application/x-font",unicodeRange="U+0020,U+0041-005A,U+0020,U+0061-007A,U+0030-0039,U+002E,U+0020-002F,U+003A-0040,U+005B-0060,U+007B-007E,U+0020-002F,U+0030-0039,U+003A-0040,U+0041-005A,U+005B-0060,U+0061-007A,U+007B-007E")]
		protected var _DFont:Class;
		
		public static const WATER:String = "water";
		
		private static var _instantce:Style;
		private var _styleDictionary:Object;
		public function Style(_hide:Function):void {
			if (!_hide||_hide!=hide) {
				throw new Error("This class is a singleton.");
			}
			Font.registerFont(_DFont);
		}
		public function getStyleByName(componentName:String):Object {
			return _styleDictionary[componentName];
		}
		private static function hide():void {
			
		}
		public static function get instance():Style {
			if (!_instantce) {
				_instantce = new Style(hide);
				_instantce.setStyle(Style.WATER);
			}
			return _instantce;
		}
		public function setStyle(styleName:String):void {
			_styleDictionary = new Object();
			var styleObject:Object;
			var skins:Object;
			var textFieldPart:Object;
			var graphicsPart:Object;
			var bitmapDataPart:Object;
			switch(styleName) {
				case WATER:
					styleObject = new Object();
					styleObject.rectWidth = 80;
					styleObject.rectHeight = 20;
					styleObject.arcWidth = 6;
					styleObject.arcHeight = 9;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.fillColor = 0xAEDCD9;
					styleObject.paddingX = 20;
					styleObject.paddingY =5;
					
					_styleDictionary.Label = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 80;
					styleObject.rectHeight = 20;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.upFillColor = 0x6AC5CE;
					styleObject.upFontColor = 0xFFFFFF;
					styleObject.overFillColor = 0xAEDCD9;
					styleObject.overFontColor = 0xFFFFFF;
					styleObject.downFillColor = 0xAEDCD9;
					styleObject.downFontColor = 0x1DA0CC;
					styleObject.disabledFillColor = 0xCECECE;
					styleObject.disabledFontColor = 0x8C8C8C;
					styleObject.paddingX = 5;
					styleObject.paddingY =5;
					
					_styleDictionary.Button = styleObject;
					
					styleObject = new Object();
					styleObject.innerSize = 7;
					styleObject.outerSize = 12;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.disabledOuterColor = 0xCECECE;
					styleObject.innerColor = 0xFFFFFF;
					styleObject.enabledOuterColor = 0x6AC5CE;
					styleObject.padding = 5;
					
					_styleDictionary.CheckBox = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 14;
					styleObject.fontColor = 0x6AC5CE;
					styleObject.backColor = 0xCECECE;
					styleObject.frontColor = 0x6AC5CE;
					styleObject.innerRadius = 28;
					styleObject.outerRadius = 43;
					
					_styleDictionary.ProgressBar = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.buttonWidth = 20;
					styleObject.rectHeight = 20;
					styleObject.rectWidth = 80;
					styleObject.backColor = 0xD5ECEB;
					styleObject.borderColor = 0x6AC5CE;
					styleObject.labelSize = 16;
					
					_styleDictionary.NumberStepper = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0xFFFFFF;
					styleObject.disabledFontColor = 0x8C8C8C;
					styleObject.rectWidth = 80;
					styleObject.rectHeight = 20;
					styleObject.padding = 10;
					styleObject.diff = 5;
					styleObject.listHeight = 60;
					styleObject.fillColor = 0xAEDCD9;
					styleObject.disabledFillColor = 0xCECECE;
					styleObject.miniOnColor = 0xFFFFFF;
					styleObject.miniOffColor = 0x1DA0CC;
					styleObject.miniDisabledColor = 0x8C8C8C;
					styleObject.miniOnCommand = Vector.<int>([1, 2, 2]);
					styleObject.miniOffCommand = Vector.<int>([1, 2, 2]);
					styleObject.miniOnPath = Vector.<Number>([0, -4, 4, 0, 0, 4]);
					styleObject.miniOffPath = Vector.<Number>([0, 0, 4, 4, 8, 0]);
					styleObject.buttonWidth = 8;
					styleObject.buttonHeight = 8;
					styleObject.lineStrength = 2;
					
					_styleDictionary.PopupButton = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.barWidth = 14;
					styleObject.barHeight = 9;
					styleObject.rectWidth = 120;
					styleObject.rectHeight = 10;
					styleObject.barOverColor = 0xFFFFFF;
					styleObject.barUpColor = 0x6AC5CE;
					styleObject.backColor = 0xAEDCD9;
					styleObject.labelPadding = 5;
					styleObject.padding = 5;
					
					_styleDictionary.Slider = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 12;
					styleObject.fontColor = 0x333333;
					styleObject.backColor = 0xD5ECEB;
					styleObject.borderOnColor = 0x6AC5CE;
					styleObject.borderOutColor = 0xAEDCD9;
					styleObject.borderThickness = 2;
					styleObject.paddingX = 2;
					styleObject.paddingY = 0;
					styleObject.rectWidth = 195;
					styleObject.rectHeight = 20;
					
					_styleDictionary.InputText = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 12;
					styleObject.fontColor = 0x333333;
					styleObject.backColor = 0xD5ECEB;
					styleObject.borderOnColor = 0x6AC5CE;
					styleObject.borderOutColor = 0xAEDCD9;
					styleObject.borderThickness = 2;
					styleObject.paddingX = 2;
					styleObject.paddingY = 0;
					styleObject.rectWidth = 195;
					styleObject.rectHeight = 120;
					
					_styleDictionary.TextArea = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 12;
					styleObject.fontColor = 0xFFFFFF;
					styleObject.backColor = 0x6AC5CE;
					styleObject.titleColor =0xAEDCD9 ;
					styleObject.contentColor = 0xD5ECEB;
					styleObject.titleHeight = 20;
					styleObject.innerMargin = 5;
					styleObject.titleOffsetLeft = 10;
					styleObject.titleOffsetRight = 180;
					styleObject.clickOnColor = 0xE5ECEB;
					styleObject.clickOffColor = 0xFFFFFF;
					styleObject.padding = 5;
					styleObject.margin = 2;
					styleObject.radius = 10;
					styleObject.miniOnCommand = Vector.<int>([1, 2, 2]);
					styleObject.miniOffCommand = Vector.<int>([1, 2, 2]);
					styleObject.miniOnPath = Vector.<Number>([0, 0, 4, 4, 8, 0]);
					styleObject.miniOffPath = Vector.<Number>([0, -4, 4, 0, 0, 4]);
					styleObject.closeCommand = Vector.<int>([1, 2, 1, 2]);
					styleObject.closePath = Vector.<Number>([0, -4, 8, 4, 8, -4, 0, 4]);
					styleObject.lineStrength = 2;
					styleObject.buttonWidth = 8;
					styleObject.buttonHeight = 8;
					styleObject.rectWidth = 195;
					styleObject.rectHeight = 135;
					
					_styleDictionary.Window = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 195;
					styleObject.rectHeight = 135;
					styleObject.backColor = 0xD5ECEB;
					styleObject.borderColor = 0x6AC5CE;
					styleObject.borderStrength = 2;
					styleObject.margin = 0;
					
					_styleDictionary.Panel = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.rectWidth = 150;
					styleObject.rectHeight = 185;
					styleObject.backColor = 0xAEDCD9;
					styleObject.borderColor = 0x6AC5CE;
					styleObject.overColor = 0x6AC5CE;
					styleObject.selectedColor = 0x1DA0CC;
					styleObject.borderStrength = 1;
					styleObject.paddingX = 5;
					styleObject.itemHeight = 20;
					
					_styleDictionary.List = styleObject;
					
					styleObject = new Object();
					styleObject.minutesColor = 0x6AC5CE;
					styleObject.minutesBackColor = 0x373B3A;
					styleObject.hoursColor = 0xA6CA3C;
					styleObject.hoursBackColor = 0xAFAFAF;
					styleObject.minutesRadius = 60;
					styleObject.hoursRadius = 80;
					
					_styleDictionary.Clock = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 200;
					styleObject.rectHeight = 170;
					styleObject.padding = 10;
					
					_styleDictionary.HGroup = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 170;
					styleObject.rectHeight = 200;
					styleObject.padding = 10;
					
					_styleDictionary.VGroup = styleObject;
					
					styleObject = new Object();
					styleObject.innerSize = 3.5;
					styleObject.outerSize = 6;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.disabledOuterColor = 0xCECECE;
					styleObject.innerColor = 0xFFFFFF;
					styleObject.enabledOuterColor = 0x6AC5CE;
					styleObject.padding = 5;
					
					_styleDictionary.RadioButton = styleObject;
					
					styleObject = new Object();
					styleObject.padding = 10;
					
					_styleDictionary.RadioButtonGroup = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 150;
					styleObject.rectHeight = 100;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 10;
					styleObject.fontColor = 0x333333;
					styleObject.backColor = 0xCECECE;
					styleObject.fpsLineColor = 0x6AC5CE;
					styleObject.memoryLineColor = 0xDA4F59;
					styleObject.padding = 5;
					
					_styleDictionary.FPSMeter = styleObject;
					
					styleObject = new Object();
					styleObject.rectWidth = 180;
					styleObject.rectHeight = 130;
					styleObject.titleHeight = 25;
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0xFFFFFF;
					styleObject.backColor = 0x6AC5CE;
					styleObject.tileWidth = 22;
					styleObject.tileHeight = 12;
					styleObject.margin = 10;
					styleObject.lineWidth = 170;
					styleObject.lineStrength = 1.5;
					styleObject.arrowPadding = 4;
					styleObject.arrowFirstPadding = 45;
					styleObject.arrowSecondPadding = 8;
					styleObject.arrowWidth = 6;
					styleObject.arrowHeight = 12;
					styleObject.clickColor = 0xAEDCD9;
					
					_styleDictionary.Calendar = styleObject;
					
					
					styleObject = new Object();
					skins = new Object();
					skins.textInputPart = new SkinPart();
					skins.textInputPart.textFormat = new TextFormat("ZHSCNMT-GBK", 11, 0x333333, null, null, null, null, null, TextFormatAlign.LEFT);
					skins.textInputPart.refresh = function(target:ColorChooser, _textField:TextField):void {
						_textField.autoSize = TextFieldAutoSize.LEFT;
						_textField.embedFonts = true;
						_textField.restrict = "0123456789ABCDEFabcdefxX";
						_textField.defaultTextFormat = this.textFormat;
						_textField.x = 20;
						_textField.y = 0;
						target.color = 0xff0000;
					}
					skins.textInputPart.update = function(color:uint, _textField:TextField):void {
						var colorString:String = color.toString(16).toUpperCase();
						while (colorString.length<6) {
							colorString = "0" + colorString;
						}
						colorString = "0x" + colorString;
						_textField.text = colorString;
					}
					
					skins.bitmapPart = new SkinPart();
					skins.bitmapPart.refresh = function(target:ColorChooser, bitmap:Bitmap):void {
						if (!this.bitmapData) { 
							var h:Number,s:Number;
							var W:Number = 150;
							var H:Number = 100;
							var R:uint,G:uint,B:uint;
							var k:uint;
							var f:Number, a:Number, b:Number, c:Number;
							this.bitmapData = new BitmapData(W, H, false);
							this.bitmapData.lock();
							for (var i:int = 0; i < W;i++ ) {
								for (var j:int = 0; j < H; j++ ) {
									h = i/W  * 360;
									s = 1-j / H;
									if (s==0) {
										R = G = B = 255;
									}else {
										h /= 60;
										k = int(h);
										f = h - k;
										a = 255 * (1 - s);
										b = 255 * (1 - s * f);
										c = 255 * (1 - s * (1 - f));
										switch(k) {
											case 0:
												R = 255; G = c; B = a;
												break;
											case 1:
												R = b; G = 255; B = a;
												break;
											case 2:
												R = a; G = 255; B = c;
												break;
											case 3:
												R = a; G = b; B = 255;
												break;
											case 4:
												R = c; G = a; B = 255;
												break;
											case 5:
												R = 255; G = a; B = b;
												break;
										}
									}
									this.bitmapData.setPixel(i, j, (R<<16)|(G<<8)|B);
								}
							}
							this.bitmapData.unlock();
						}
						var bitmapData:BitmapData=this.bitmapData.clone();;
						target.bitmapData = bitmapData;
						bitmap.bitmapData = bitmapData;
						bitmap.x = 0;
						bitmap.y = 20;
					}
					
					skins.buttonPart = new SkinPart();
					skins.buttonPart.refresh = function(graphics:Graphics):void {
						graphics.beginFill(0xff0000);
						graphics.drawRect(0, 0, 15, 15);
						graphics.endFill();
					}
					skins.buttonPart.update = function(color:uint,graphics:Graphics):void {
						graphics.beginFill(color);
						graphics.drawRect(0, 0, 15, 15);
						graphics.endFill();
					}
					skins.buttonPart.rect = new Rectangle(0, 0, 15, 15);
					
					styleObject.skins = skins;
					_styleDictionary.ColorChooser = styleObject;
					
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.paddingX = 8;
					styleObject.paddingY = 5;
					styleObject.paddingBar = 10;
					styleObject.lineStrength = 1.5;
					styleObject.barWidth = 13;
					styleObject.barColor = 0x6AC5CE;
					
					_styleDictionary.BarChart = styleObject;
					
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.paddingX = 40;
					styleObject.paddingY = 5;
					styleObject.labelPadding = 5;
					styleObject.baseOffsetX = -10;
					styleObject.baseOffsetY = -15;
					styleObject.lineStrength = 1.5;
					styleObject.dotRadius = 4;
					styleObject.lineColor = 0x6AC5CE;
					
					_styleDictionary.LineChart = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.valueFontSize = 18;
					styleObject.labelFontSize = 14;
					styleObject.valueFontColor = 0xFFFFFF;
					styleObject.labelFontColor = 0x333333;
					styleObject.labelPaddingX = 10;
					styleObject.labelPaddingY = 10;
					styleObject.paddingX = 20;
					styleObject.paddingY = 20;
					styleObject.innerRadius = 45;
					styleObject.outerRadius = 66;
					styleObject.labelWidth = 60;
					styleObject.labelHeight = 30;
					
					_styleDictionary.PieChart = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 14;
					styleObject.fontUpColor = 0xFFFFFF;
					styleObject.fontOverColor = 0x333333;
					styleObject.fillUpColor = 0x6AC5CE;
					styleObject.fillOverColor = 0xAEDCD9;
					styleObject.rectWidth = 95;
					styleObject.rectHeight = 45;
					styleObject.arcWidth = 8;
					styleObject.arcHeight = 7.5;
					styleObject.padding = 10;
					styleObject.paddingX = 2;
					
					_styleDictionary.FlowChart = styleObject;
					
					styleObject = new Object();
					styleObject.fontName = "ZHSCNMT-GBK";
					styleObject.fontSize = 11;
					styleObject.fontColor = 0x333333;
					styleObject.backColor = 0xFAFAFA;
					styleObject.borderColor = 0xCECECE;
					styleObject.axisColor = 0x6AC5CE;
					styleObject.rectWidth = 200;
					styleObject.rectHeight = 200;
					styleObject.tileWidth = 10;
					styleObject.tileHeight = 10;
					styleObject.paddingX = 5;
					styleObject.paddingY = 5;
					styleObject.lineStrength = 0;
					
					_styleDictionary.Coordinate = styleObject;
					
					dispatchEvent(new Event(Event.CHANGE));
					break;
			}
		}
	}
	
}