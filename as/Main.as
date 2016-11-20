package {
    import Projects;
	import flash.display.MovieClip;
	import flash.filters.BitmapFilter;
	import flash.filters.GlowFilter;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.geom.ColorTransform;
	import fl.transitions.TweenEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.text.TextFormat;
	import flash.geom.Point;
	public class Main extends MovieClip {
		private const TWEEN_TIME:uint = 3;
		private const UNLOAD_TIME:Number = .5;
		private const OVER_TWEEN_TIME:Number = 1;
		private const SWING_TIME:Number = 5;
		private const USE_SECONDS:Boolean = true;
		private const SCALE_OVER:Number = 1.1;
		private const SCALE_OFF:Number = 1;
		private const BLUR_FILTER:GlowFilter = new GlowFilter(0xFFFFFF, 1, 7, 7, 5);
		private const COLOR_TWEEN:Tween = new Tween(stage, "", Regular.easeOut, 0, 1, TWEEN_TIME, USE_SECONDS)
		private const TXT_FORMAT:TextFormat = new TextFormat("GrilledCheese", 20, 0xFFFFFF);
		private var unloadTimer:Timer;
		private var tweenX:Tween;
		private var tweenY:Tween;
		private var tweenR:Tween;
		private var tweenA:Tween;
		private var tweenF:Tween;
		private var tweenFA:Tween;
		private var tweenPlanetX:Tween;
		private var tweenPlanetY:Tween;
		private var tweenShine:Tween;
		private var tweenSwing:Tween;
		private var tweenUnload:Tween;
		private var NAV_ITEMS:Array;
		private var xml:XMLList;
		private var curItem:uint = 4;
		private var ldr:Loader;
		private var txt:TextField;
		private var bg:Shape = new Shape();
		private var header:Shape = new Shape();
		private var urlLoader:URLLoader = new URLLoader();
		public function Main():void {
			urlLoader.load(new URLRequest("xml/main.xml"));
			urlLoader.addEventListener(Event.COMPLETE, onComplete);
			
			resizeHeader();
			
			addChild(header);
			setChildIndex(header, 1);
			setChildIndex(headerText, 2);
			
			stage.addEventListener(Event.RESIZE, onStageResize);
		}
		private function onStageResize(e:Event):void {
			resizeHeader();
			resizeBg();
		}
		private function onComplete(e:Event):void {
			NAV_ITEMS = new Array();
			xml = new XMLList(new XML(e.target.data));
			for(var i:uint = 0; i < xml.section.length(); i++) {
				if(planet[xml.section[i].location]) {
					var obj:MovieClip = planet[xml.section[i].location];
					obj.addEventListener(MouseEvent.ROLL_OVER, doMouseOver);
					obj.addEventListener(MouseEvent.ROLL_OUT, doMouseOut);
					obj.addEventListener(MouseEvent.CLICK, doMouseClick);
					obj.id = i;
					obj.buttonMode = true;
					NAV_ITEMS.push({mc: obj, rot: -obj.rotation, bg: "0x"+xml.section[i].color, txt: xml.section[i].title});
				}
				else {
					NAV_ITEMS.push({bg: "0x"+xml.section[i].color});
				}
			}
			
			COLOR_TWEEN.addEventListener(TweenEvent.MOTION_CHANGE, onMotionChange);
			
			resizeBg();
			
			addChild(bg);
			setChildIndex(bg, 0);
			
			gotoItem(4);
		}
		private function resizeHeader():void {
			try {
				header.graphics.clear();
			}
			catch(e:Error) {}
			header.graphics.beginFill(0x000000);
			header.graphics.moveTo(0, 0);
			header.graphics.lineTo(stage.stageWidth, 0);
			header.graphics.lineTo(stage.stageWidth, 50);
			header.graphics.lineTo(0, 75);
			header.graphics.endFill();
		}
		private function resizeBg():void {
			try {
				bg.graphics.clear();
			}
			catch(e:Error) {}
			bg.graphics.beginFill(NAV_ITEMS[curItem].bg);
			bg.graphics.moveTo(0, 0);
			bg.graphics.lineTo(stage.stageWidth, 0);
			bg.graphics.lineTo(stage.stageWidth, stage.stageHeight);
			bg.graphics.lineTo(0, stage.stageHeight);
			bg.graphics.endFill();
		}
		private function onMotionChange(e:TweenEvent):void {
			var s:ColorTransform = new ColorTransform();
			s.color = bg.transform.colorTransform.color;
			
			var end:ColorTransform = new ColorTransform();
			end.color = NAV_ITEMS[curItem].bg;
			
			bg.transform.colorTransform = tweenColor(s, end, COLOR_TWEEN.position);
		}
		private function tweenColor(s:ColorTransform, e:ColorTransform, t:Number):ColorTransform {
			var ct:ColorTransform = new ColorTransform();
			ct.redMultiplier = s.redMultiplier + (e.redMultiplier - s.redMultiplier)*t;
			ct.greenMultiplier = s.greenMultiplier + (e.greenMultiplier - s.greenMultiplier)*t;
			ct.blueMultiplier = s.blueMultiplier + (e.blueMultiplier - s.blueMultiplier)*t;
			
			ct.redOffset = s.redOffset + (e.redOffset - s.redOffset)*t;
			ct.greenOffset = s.greenOffset + (e.greenOffset - s.greenOffset)*t;
			ct.blueOffset = s.blueOffset + (e.blueOffset - s.blueOffset)*t;
			
			return ct;
		}
		private function doMouseClick(e:MouseEvent):void {
			if(curItem == e.target.id || e.target.id == undefined) {
				return;
			}
			gotoItem(e.target.id);
		}
/*		private function makeSwinger(obj:MovieClip):void {
			obj.addEventListener(MouseEvent.MOUSE_MOVE, onSwingerMove);
			obj.addEventListener(MouseEvent.ROLL_OUT, onSwingerOut);
		}
		private function onSwingerMove(e:MouseEvent):void {
			e.target.parent.dir = e.target.parent.prevMouse > e.target.parent.mouseX;
			e.target.parent.prevMouse = e.target.parent.mouseX;
		}
		private function onSwingerOut(e:MouseEvent):void {
			tweenSwing = new Tween(e.target, "x", Elastic.easeOut, e.target.x + (e.target.dir ? 5 : -5), 0, SWING_TIME, USE_SECONDS);
			tweenSwing.start();
		}*/
		private function gotoItem(item:uint):void {
			curItem = item;
			if(item < 4) {
				for(var i:uint = 0; i < 4; i++) {
					NAV_ITEMS[i].mc.overTxt.text = "";
					NAV_ITEMS[i].mc.gotoAndStop("inactive");
				}
				NAV_ITEMS[item].mc.gotoAndStop("active");
				NAV_ITEMS[item].mc.overTxt.text = NAV_ITEMS[item].txt;
				tweenR = new Tween(NAV_ITEMS[item].mc.parent, "rotation", Elastic.easeOut, NAV_ITEMS[item].mc.parent.rotation, NAV_ITEMS[item].rot, TWEEN_TIME, USE_SECONDS);
				tweenR.start();
			}
			
			COLOR_TWEEN.start();
			
			loadSection();
		}
		private function onRemoveTimer(e:TimerEvent):void {
			while(content.numChildren) {
				content.removeChildAt(0);
			}
			displaySection();
		}
		private function unloadSection():void {
			tweenUnload = new Tween(content, "alpha", Regular.easeOut, 1, 0, UNLOAD_TIME, USE_SECONDS);
			tweenUnload.start();
			unloadTimer = new Timer(UNLOAD_TIME*1000, 1);
			unloadTimer.addEventListener("timer", onRemoveTimer);
			unloadTimer.start();
		}
		private function loadSection():void {
			if(content.numChildren) {
				unloadSection();
			}
			else {
				displaySection();
			}
		}
		private function displaySection():void {
			content.alpha = 100;
			var item:MovieClip;
			trace(curItem);
			switch(curItem) {
				case 0:
					item = new Projects(new XMLList(xml.section[curItem]));
					break;
				case 1:
					item = new Skills(new XMLList(xml.section[curItem]));
					break;
				/*case 2:
					tweenShine = new Tween(shine, "alpha", Regular.easeOut, 1, 0, TWEEN_TIME/2, USE_SECONDS);
					tweenShine.start();
					tweenPlanetX = new Tween(planet, "scaleX", Regular.easeIn, 1, 0, TWEEN_TIME/4, USE_SECONDS);
					tweenPlanetX.start();
					tweenPlanetY = new Tween(planet, "scaleY", Regular.easeIn, 1, 0, TWEEN_TIME/4, USE_SECONDS);
					tweenPlanetY.start();
					item = new Recreation(new XMLList(xml.section[curItem]));
					break;*/
				case 2:
					item = new Resume(new XMLList(xml.section[curItem]));
					break;
				case 3:
					item = new Contact(new XMLList(xml.section[curItem]));
					break;
				case 4:
					item = new Hello(new XMLList(xml.section[curItem]));
					break;
				default:
					break;
			}
			content.addChild(item);
		}
		private function doMouseOver(e:MouseEvent):void {
			if(curItem == e.target.id) {
				return;
			}
			linkName.text = NAV_ITEMS[e.target.id].txt;
			e.target.filters = [BLUR_FILTER];
			tweenY = new Tween(e.target, "scaleY", Elastic.easeOut, e.target.scaleY, SCALE_OVER, OVER_TWEEN_TIME, USE_SECONDS);
			tweenY.start();
			tweenX = new Tween(e.target, "scaleX", Elastic.easeOut, e.target.scaleY, SCALE_OVER, OVER_TWEEN_TIME, USE_SECONDS);
			tweenX.start();
			tweenA = new Tween(linkName, "alpha", Regular.easeOut, linkName.alpha, 1, OVER_TWEEN_TIME, USE_SECONDS);
			tweenA.start();
		}
		private function doMouseOut(e:MouseEvent):void {
			e.target.filters = [];
			tweenY = new Tween(e.target, "scaleY", Elastic.easeOut, e.target.scaleY, SCALE_OFF, OVER_TWEEN_TIME, USE_SECONDS);
			tweenY.start();
			tweenX = new Tween(e.target, "scaleX", Elastic.easeOut, e.target.scaleY, SCALE_OFF, OVER_TWEEN_TIME, USE_SECONDS);
			tweenX.start();
			tweenA = new Tween(linkName, "alpha", Regular.easeOut, linkName.alpha, 0, OVER_TWEEN_TIME, USE_SECONDS);
			tweenA.start();
		}
	}
}