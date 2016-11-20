package display {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.display.Shape;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	public class Scroller extends MovieClip {
		private const USE_SECONDS:Boolean = true;
		private const TWEEN_TIME:uint = 1;
		private var OVER_FILTER:GlowFilter;
		private var ACTIVE_FILTER:GlowFilter;
		private var numLoaded:uint = 0;
		private var leftArrow:MovieClip;
		private var rightArrow:MovieClip;
		private var minItem:uint = 0;
		private var tweenOut:Tween;
		private var tweenIn:Tween;
		private var arrowSize:Number;
		private var minX:Number;
		public var contents:XMLList;
		public var elements:Array = new Array();
		public var spacing:Number;
		public var curItem:uint = 0;
		public var numDisplay:uint;
		public function Scroller(c:XMLList, disp:uint, s:Number = 3, gC:uint = 0x000000, gS:uint = 3, gStr:uint = 10, oC:uint = 0xFFFFFF, aS:Number = 6, aC:uint = 0xFFFFFF):void {
			minX = aS*2;
			arrowSize = aS;
			contents = c;
			spacing = s;
			numDisplay = disp;
			leftArrow = createArrow("l", aS, aC, leftArrowClick);
			rightArrow = createArrow("r", aS, aC, rightArrowClick);
			addChild(leftArrow);
			addChild(rightArrow);
			ACTIVE_FILTER = new GlowFilter(gC, .7, gS, gS, gStr, 1, true);
			OVER_FILTER = new GlowFilter(oC, .7, gS, gS, gStr, 1, true);
			for(var i:uint = 0; i < contents..element.length(); i++) {
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest(contents..element[i].tn));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				elements.push(ldr);
			}
		}
		private function createArrow(dir:String, aS:uint, aC:uint, cb:Function):MovieClip {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(aC);
			shape.graphics.moveTo(0, -aS/2);
			shape.graphics.lineTo(0, aS);
			switch(dir.toLowerCase()) {
				case "l":
					shape.graphics.lineTo(-aS, aS/2);
					break;
				default:
					shape.graphics.lineTo(aS, aS/2);
					break;
			}
			shape.graphics.endFill();
			var mc:MovieClip = new MovieClip();
			mc.addChild(shape);
			mc.buttonMode = true;
			mc.addEventListener(MouseEvent.CLICK, cb);
			return mc;
		}
		private function leftArrowClick(e:MouseEvent):void {
			moveItems(-1);
		}
		private function rightArrowClick(e:MouseEvent):void {
			moveItems(1);
		}
		public function moveItems(dir:int):void {
			leftArrow.visible = minItem + dir > 0;
			rightArrow.visible = minItem + numDisplay + dir < elements.length;
			var inItem:MovieClip;
			var outItem:MovieClip;
			if(minItem+numDisplay < elements.length || minItem > 0) {
				if(dir > 0) {
					inItem = elements[minItem+numDisplay].parent;
					outItem = elements[minItem].parent;
				}
				else if(dir < 0) {
					outItem = elements[minItem+numDisplay-1].parent;
					inItem = elements[minItem-1].parent;
				}
				if(minItem + dir > 0 && minItem + dir < elements.length) {
					minItem += dir;
				}
				if(dir != 0) {
					tweenOut = new Tween(outItem, "alpha", Regular.easeOut, outItem.alpha, 0, TWEEN_TIME, USE_SECONDS);
					tweenIn = new Tween(inItem, "alpha", Regular.easeOut, inItem.alpha, 1, TWEEN_TIME, USE_SECONDS);
					tweenOut.start();
					tweenIn.start();
					sort();
				}

			}
		}
		private function onComplete(e:Event):void {
			for(var i:uint = 0; i < elements.length; i++) {
				if(elements[i] == e.target.loader) {
					var mc:MovieClip = new MovieClip();
					mc.id = i;
					mc.addEventListener(MouseEvent.CLICK, onClick);
					mc.addEventListener(MouseEvent.ROLL_OVER, doRollOver);
					mc.addEventListener(MouseEvent.ROLL_OUT, doRollOut);
					mc.addChild(e.target.loader);
					addChild(mc);
					break;
				}
			}
			if(++numLoaded >= contents..element.length()) {
				moveItems(0);
				sort(true);
				positionArrows();
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		public function positionArrows():void {
			leftArrow.x = arrowSize;
			rightArrow.x = width+arrowSize;
			leftArrow.y = rightArrow.y = height/2-arrowSize/2;
		}
		private function setLevels():void {
			for(var i:uint = 0; i < elements.length; i++) {
				setChildIndex(elements[i].parent, 0);
			}
			if(minItem + numDisplay < elements.length) {
				for(i = minItem; i < minItem + numDisplay; i++) {
					trace(elements[i].parent.id);
					setChildIndex(elements[i].parent, elements.length-1);
				}
			}
		}
		private function doRollOver(e:MouseEvent):void {
			if(e.target.filters.length <= 0) {
				e.target.filters = [OVER_FILTER];
			}
		}
		private function doRollOut(e:MouseEvent):void {
			e.target.filters = [];
		}
		private function sort(init:Boolean = false):void {
			var curX:Number = minX;
			if(!init) {
				for(var i:uint = 0; i < elements.length; i++) {
					var tween:Tween = new Tween(elements[i].parent, "x", Regular.easeOut, elements[i].parent.x, curX, TWEEN_TIME, USE_SECONDS);
					tween.start();
					if(i >= minItem && i < minItem + numDisplay-1) {
						curX += elements[i].parent.width + spacing;
					}
				}
			}
			else {
				for(i = 0; i < elements.length; i++) {
					if(i < numDisplay) {
						elements[i].parent.x = (i > 0) ? elements[i-1].parent.x + elements[i-1].parent.width + spacing : minX;
					}
					else {
						elements[i].parent.x = elements[numDisplay-1].parent.x;
						elements[i].parent.alpha = 0;
					}
				}
			}
			setLevels();
		}
		private function onClick(e:MouseEvent):void {
			setCurItem(e.target.parent.id);
			dispatchEvent(new Event("itemClick"));
		}
		private function setCurItem(it:uint):void {
			curItem = it;
			for(var i:uint = 0; i < elements.length; i++) {
				elements[i].filters = [];
			}
			elements[it].filters = [ACTIVE_FILTER];
		}
	}
}