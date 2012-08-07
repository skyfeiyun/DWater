package org.DWater.components
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author dongdong
	 */
	public class ContainerComponent extends Component
	{
		internal var _registX:Number;
		internal var _registY:Number;
		
		public function ContainerComponent(parent:Sprite, x:Number, y:Number):void {
			_registX = 0;
			_registY = 0;
			super(parent, x, y);
		}
		public function addComponent(component:DisplayObject):Boolean {
			var x:Number = component.x;
			var y:Number = component.y;
			if (!contains(component) && component) {
				if (component is Component) {
					(component as Component).container = this;
				}else {
					component.x = _registX + component.x;
					component.y = _registY + component.y;
				}
				addChild(component);
				return true;
			}else {
				return false;
			}
		}
		public function removeComponent(component:DisplayObject):Boolean {
			if (contains(component) && component) {
				if (component is Component) {
					(component as Component).container = null;
				}else {
					component.x = component.x - _registX;
					component.y = component.y - _registY;
				}
				removeChild(component);
				return true;
			}else {
				return false;
			}
		}
		public function get registX():Number {
			return _registX;
		}
		public function get registY():Number {
			return _registY;
		}
	}
	
}