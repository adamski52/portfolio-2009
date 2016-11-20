package display {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.display.Shape;
	public class AutoScroller extends MovieClip {
		private const USE_SECONDS:Boolean = true;
		private var OVER_FILTER:GlowFilter;
		private var ACTIVE_FILTER:GlowFilter;
		private var numLoaded:uint = 0;
		private var contentMc:MovieClip;
		private var curX:Number = 0;
		public var contents:XMLList;
		public var mainMask:Shape;
		public var elements:Array = new Array();
		public var spacing:Number;
		public var curItem:uint = 0;
		public var dir:Boolean;
		public var prevMouse:Number;
		public function AutoScroller(c:XMLList, w:Number, h:Number, s:Number = 3, gC:uint = 0x000000, gS:uint = 3, gStr:uint = 10, oC:uint = 0xFFFFFF):void {
			contents = c;
			spacing = s;
			ACTIVE_FILTER = new GlowFilter(gC, .7, gS, gS, gStr, 1, true);
			OVER_FILTER = new GlowFilter(oC, .7, gS, gS, gStr, 1, true);
			for(var i:uint = 0; i < contents..element.length(); i++) {
				var ldr:Loader = new Loader();
				ldr.load(new URLRequest(contents..element[i].tn));
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				elements.push(ldr);
			}
			contentMc = new MovieClip();
			addChild(contentMc);
			
			mainMask = new Shape();
			mainMask.graphics.beginFill(0x000000);
			mainMask.graphics.drawRect(0, 0, w, h);
			addChild(mainMask);
			
			contentMc.mask = mainMask;
		}
		private function moveItems(e:MouseEvent):void {
			contentMc.x = -((mainMask.mouseX/mainMask.width)*(contentMc.width-mainMask.width));
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
					contentMc.addChild(mc);
					break;
				}
			}
			if(++numLoaded >= contents..element.length()) {
				for(i = 0; i < elements.length; i++) {
					elements[i].parent.x = curX;
					curX += elements[i].parent.width + spacing;
				}
				addEventListener(MouseEvent.MOUSE_MOVE, moveItems);

				dispatchEvent(new Event(Event.COMPLETE));
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