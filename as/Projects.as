package {
	import PortfolioContainer;
	import display.Swinger;
	import flash.display.MovieClip;
	import display.MessySquare;
	import display.AutoScroller;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.events.Event;
	import flash.text.TextFormat;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;

	public class Projects extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const ITEM_OUT:Number = -1000;
		private const ALPHA_TIME:Number = 1;
		private const TWEEN_TIME:uint = 2;
		private const AUTOSCROLL_Y:uint = 0;
		private const ITEM_Y:uint = 160;
		private const MARGIN_TOP:uint = 5;
		private var timer:Timer;
		
		private var curLdr:Loader;
		private var ldr:Loader;
		
		private var itemContainer:Swinger = new Swinger();
			private var itemMs:MessySquare;
			private var itemTween:Tween;
			private var itemAlphaTween:Tween;
		private var descContainer:Swinger = new Swinger();
			private var descMs:MessySquare;
			private var descTween:Tween;
			private var descAlphaTween:Tween;
			private var desc:TextField = new TextField();
		private var titleContainer:Swinger = new Swinger();
			private var titleMs:MessySquare;
			private var titleTween:Tween;
			private var titleAlphaTween:Tween;
			private var title:TextField = new TextField();
		private var urlContainer:Swinger = new Swinger();
			private var urlMs:MessySquare;
			private var urlTween:Tween;
			private var urlAlphaTween:Tween;
			private var url:TextField = new TextField();
			private var urlOverFormat:TextFormat;
			private var urlOutFormat:TextFormat;
			
		private var scrollTween:Tween;		
		private var scroller:MovieClip = new MovieClip();
		private var autoScroller:AutoScroller;
		public function Projects(c:XMLList):void {
			super(c.elements);
			autoScroller = new AutoScroller(this.contents, 305, 25, 3, uint("0x" + c.section.color), 10);
			autoScroller.addEventListener("itemClick", onScrollClick);
			autoScroller.addEventListener(Event.COMPLETE, onScrollComplete);
			addChild(scroller);
			
			title.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@titleSize), int("0x"+c.elements.@titleColor));
			desc.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@size), int("0x"+c.elements.@color));
			urlOutFormat = url.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@goSize), int("0x"+c.elements.@goColor));
			urlOverFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@goSize), int("0x"+c.elements.@goOverColor));
			
			title.selectable = desc.selectable = url.selectable = url.wordWrap = url.multiline = false;
			title.wordWrap = title.embedFonts = title.multiline = desc.wordWrap = desc.embedFonts = desc.multiline = url.embedFonts = true;
			title.autoSize = desc.autoSize = url.autoSize = "left";
		}
		private function onScrollClick(e:Event):void {
			ldr = new Loader();
			ldr.load(new URLRequest(this.contents.element[e.target.curItem].img));
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onScrollItemComplete);
		}
		private function onTimer(e:TimerEvent):void {
			try {
				removeChild(itemContainer);
				removeChild(titleContainer);
				removeChild(descContainer);
				removeChild(urlContainer);
			}
			catch(e:Error) { }
			showItem();
		}
		private function onScrollItemComplete(e:Event):void {
			if(!curLdr) {
				curLdr = e.target.loader;
				showItem();
			}
			else {
				curLdr = e.target.loader;
				new Tween(itemContainer, "y", Regular.easeOut, itemContainer.y, ITEM_OUT, ALPHA_TIME, USE_SECONDS).start();
				new Tween(titleContainer, "y", Regular.easeOut, titleContainer.y, ITEM_OUT, ALPHA_TIME, USE_SECONDS).start();
				new Tween(descContainer, "y", Regular.easeOut, descContainer.y, ITEM_OUT, ALPHA_TIME, USE_SECONDS).start();
				new Tween(urlContainer, "y", Regular.easeOut, urlContainer.y, ITEM_OUT, ALPHA_TIME, USE_SECONDS).start();
				
				timer = new Timer(ALPHA_TIME*1000, 1);
				timer.addEventListener("timer", onTimer);
				timer.start();
			}
		}
		private function onLaunchOver(e:MouseEvent):void {
			url.setTextFormat(urlOverFormat);
		}
		private function onLaunchOut(e:MouseEvent):void {
			url.setTextFormat(urlOutFormat);
		}
		private function showItem():void {
			itemContainer = new Swinger();
				var itemY:Number = ITEM_Y;
				itemMs = new MessySquare(ldr.width, ldr.height);
				itemContainer.addItem(itemMs);
				itemContainer.addItem(curLdr);
				itemContainer.x = scroller.x + itemContainer.width/2;
				
			titleContainer = new Swinger();
				title.text = this.contents.element[autoScroller.curItem].title;
				title.width = ldr.width;
				titleMs = new MessySquare(title.width, title.height);
				titleContainer.addItem(titleMs);
				titleContainer.addItem(title);
				var titleY:Number = itemY + (itemContainer.height/2) + (titleContainer.height/2) + MARGIN_TOP;
				titleContainer.x = scroller.x + titleContainer.width/2;
				
			descContainer = new Swinger();
				desc.text = this.contents.element[autoScroller.curItem].desc;
				desc.width = ldr.width;
				descMs = new MessySquare(desc.width, desc.height);
				descContainer.addItem(descMs);
				descContainer.addItem(desc);
				var descY:Number = titleY + (titleContainer.height/2) + (descContainer.height/2) + MARGIN_TOP;
				descContainer.x = scroller.x + descContainer.width/2;
			addChild(itemContainer);
			addChild(titleContainer);
			addChild(descContainer);
			itemTween = new Tween(itemContainer, "y", Elastic.easeOut, OFF_STAGE, itemY, TWEEN_TIME, USE_SECONDS);
			titleTween = new Tween(titleContainer, "y", Elastic.easeOut, OFF_STAGE, titleY, TWEEN_TIME, USE_SECONDS);
			descTween = new Tween(descContainer, "y", Elastic.easeOut, OFF_STAGE, descY, TWEEN_TIME, USE_SECONDS);
			
			if(this.contents.element[autoScroller.curItem].url) {
				urlContainer = new Swinger();
				urlContainer.mouseChildren = false;
					url.text = this.contents.@goText;
					url.width = ldr.width;
					urlMs = new MessySquare(url.width, url.height);
					urlContainer.addItem(urlMs);
					urlContainer.addItem(url);
				urlContainer.x = descContainer.x + (descContainer.width/2) - (urlContainer.width/2);
				urlContainer.addEventListener(MouseEvent.CLICK, onLaunchClick);
				urlContainer.addEventListener(MouseEvent.ROLL_OVER, onLaunchOver);
				urlContainer.addEventListener(MouseEvent.ROLL_OUT, onLaunchOut);
				urlContainer.buttonMode = true;
				var urlY:Number = descY + (descContainer.height/2) + (urlContainer.height/2) + MARGIN_TOP;
				addChild(urlContainer);
				urlTween = new Tween(urlContainer, "y", Elastic.easeOut, OFF_STAGE, urlY, TWEEN_TIME, USE_SECONDS);
			}
		}
		private function onLaunchClick(e:MouseEvent):void {
			navigateToURL(new URLRequest(this.contents.element[autoScroller.curItem].url), "_blank");
		}
		private function onScrollComplete(e:Event):void {
			var ms:MessySquare = new MessySquare(e.target.mainMask.width, e.target.mainMask.height);
			ms.x = 0;
			ms.y = 0;
			scroller.addChild(ms);
			scroller.addChild(MovieClip(e.target));
			
			scrollTween = new Tween(scroller, "y", Elastic.easeOut, OFF_STAGE, AUTOSCROLL_Y, TWEEN_TIME, USE_SECONDS);
		}
	}
}