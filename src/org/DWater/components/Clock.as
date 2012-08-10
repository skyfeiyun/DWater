package org.DWater.components 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	/**
	 * Clock is often used to show time.
	 * @author Dong Dong
	 */
	public class Clock extends Component 
	{
		private var _time:Date;
		private var _milliseconds:int;
		public function Clock(parent:Sprite, x:Number = 0, y:Number = 0,time:Array=null) 
		{
			_time = new Date();
			this.time = time;
			_name = "Clock";
			super(parent, x, y);
		}
		/**
		 * @private
		 */
		override protected function refreshStyle():void {
			super.refreshStyle();
		}
		/**
		 * @private
		 */
		override protected function draw():void {
			super.draw();
			
			graphics.beginFill(_styleObject.hoursBackColor);
			graphics.drawCircle(0, 0, _styleObject.hoursRadius);
			graphics.endFill();
			
			var a:Number = ((_time.hours+_time.minutes/60)%12) / 6 * Math.PI / 0.01;
			graphics.beginFill(_styleObject.hoursColor);
			graphics.moveTo(0, 0);
			graphics.lineTo(0,- _styleObject.hoursRadius);
		    for (var i:int=0; i<=a; i++) {
				graphics.curveTo(Math.sin((i-0.5)*0.01)*_styleObject.hoursRadius,-Math.cos((i-0.5)*0.01)*_styleObject.hoursRadius,Math.sin(i*0.01)*_styleObject.hoursRadius,-Math.cos(i*0.01)*_styleObject.hoursRadius);
			}
			graphics.lineTo(0, 0);
			graphics.endFill();
			
			graphics.beginFill(_styleObject.minutesBackColor);
			graphics.drawCircle(0, 0, _styleObject.minutesRadius);
			graphics.endFill();
			
			a = (_time.minutes+_time.seconds/60)/ 30 * Math.PI / 0.01;
			graphics.beginFill(_styleObject.minutesColor);
			graphics.moveTo(0, 0);
			graphics.lineTo(0,- (_styleObject.minutesRadius+1));
		    for (i=0; i<=a; i++) {
				graphics.curveTo(Math.sin((i-0.5)*0.01)*(_styleObject.minutesRadius+1),-Math.cos((i-0.5)*0.01)*(_styleObject.minutesRadius+1),Math.sin(i*0.01)*(_styleObject.minutesRadius+1),-Math.cos(i*0.01)*(_styleObject.minutesRadius+1));
			}
			graphics.lineTo(0, 0);
			graphics.endFill();
		}
		/**
		 * @private
		 */
		override protected function update(evt:Event):void {
			var t:int = getTimer();
			var dt:int = t - _milliseconds;
			_milliseconds = t;
			_time.milliseconds += dt;
			_changed = true;
			super.update(evt);
		}
		/**
		 * @private
		 */
		override public function set width(value:Number):void {
			
		}
		/**
		 * @private
		 */
		override public function set height(value:Number):void {
			
		}
		/**
		 * current time in array, hours first, minutes second, seconds third
		 */
		public function get time():Array {
			return [_time.hours, _time.minutes, _time.seconds];
		}
		public function set time(value:Array):void {
			_milliseconds = getTimer();
			if (!value) {
				return;
			}
			_time.hours = value[0];
			_time.minutes = value[1];
			_time.seconds = value[2];
			_changed = true;
		}
	}

}