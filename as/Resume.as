package {
	import PortfolioContainer;
	import display.Swinger;
	import flash.display.MovieClip;
	import display.MessySquareText;
	import display.MessySquareLoader;
	import flash.events.Event;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;

	public class Resume extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const MIN_TIME:Number = 2;
		private const MAX_TIME:Number = 2.5;
		private var swingers:Array = new Array();
		private var tweens:Array = new Array();
		public function Resume(c:XMLList):void {
			super(c.elements);
			for(var i:uint = 0; i < contents.element.length(); i++) {
				var ldr:MessySquareLoader = new MessySquareLoader(contents.element[i].img, i);
				ldr.name = "ldr";
				ldr.addEventListener("messySquareComplete", onSquareComplete);
				var title:MessySquareText = new MessySquareText(contents.element[i].title, contents.element[i].title.@width, contents.@titleSize, contents.@titleColor);
				title.name = "title";
				var desc:MessySquareText = new MessySquareText(contents.element[i].desc, contents.element[i].desc.@width, contents.@size, contents.@color);
				desc.name ="desc";
				var swinger:Swinger = new Swinger();
				swinger.addItem(ldr);
				swinger.addItem(title);
				swinger.addItem(desc);
				swingers.push(swinger); // id and index will match
				tweens.push(null);
			}
			
		}
		private function onSquareComplete(e:Event):void {
			swingers[e.target.id].x = contents.element[e.target.id].@x;
			tweens[e.target.id] = new Tween(swingers[e.target.id], "y", Elastic.easeOut, OFF_STAGE, contents.element[e.target.id].@y, getRandomTime(), USE_SECONDS);
			tweens[e.target.id].start();
			var ldr = swingers[e.target.id].getChildByName("ldr");
			var title = swingers[e.target.id].getChildByName("title");
			var desc = swingers[e.target.id].getChildByName("desc");
			
			ldr.x = contents.element[e.target.id].img.@x;
			ldr.y = contents.element[e.target.id].img.@y;
			title.x = contents.element[e.target.id].title.@x;
			title.y = contents.element[e.target.id].title.@y;
			desc.x = contents.element[e.target.id].desc.@x;
			desc.y = contents.element[e.target.id].desc.@y;
	
			addChild(swingers[e.target.id]);
		}
		private function getRandomTime():Number {
			return MIN_TIME+(Math.random()*MAX_TIME);
		}
	}
}