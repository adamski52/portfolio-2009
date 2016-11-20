package display {
	import flash.display.MovieClip;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.Elastic;
	public class Swinger extends MovieClip {
		private const TWEEN_TIME:Number = .5;
		private const USE_SECONDS:Boolean = true;
		private const MAX_SCALE:Number = 1.1;
		private var tweens:Array = new Array();
		public function Swinger() {
			this.cacheAsBitmap = true;
			addEventListener(MouseEvent.ROLL_OVER, doMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, doMouseOut);
		}
		public function set scale(s:Number):void {
			scaleX = scaleY = s;
		}
		public function kill():void {
			removeEventListener(MouseEvent.ROLL_OVER, doMouseOver);
			removeEventListener(MouseEvent.ROLL_OUT, doMouseOut);
		}
		public function addItem(mc:DisplayObject):DisplayObject {
			mc.cacheAsBitmap = true;
			var added = addChild(mc);
			var maxW:Number = 0;
			var maxH:Number = 0;
			for(var i:uint = 0; i < numChildren; i++) {
				if(getChildAt(i).width > maxW) {
					maxW = getChildAt(i).width;
				}
				if(getChildAt(i).height > maxH) {
					maxH = getChildAt(i).height;
				}
			}
			for(i = 0; i < numChildren; i++) {
				getChildAt(i).x = -maxW/2;
				getChildAt(i).y = -maxH/2;
			}
			return added;
		}
		public function init(xx:Number, yy:Number):void {
/*			trace("set");
			startX = xx;
			startY = yy;*/
		}
		private function doMouseOver(e:MouseEvent):void {
			tweens.push(new Tween(this, "scale", Elastic.easeOut, scaleX, MAX_SCALE, TWEEN_TIME, USE_SECONDS));
			tweens[tweens.length-1].start();
		}
		private function doMouseOut(e:MouseEvent):void {
			tweens.push(new Tween(this, "scale", Elastic.easeOut, scaleX, 1, TWEEN_TIME, USE_SECONDS));
			tweens[tweens.length-1].start();
		}
	}
}