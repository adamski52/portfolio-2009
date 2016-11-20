package {
	import PortfolioContainer;
	import display.Swinger;
	import flash.display.MovieClip;
	import display.MessySquareText;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	
	public class Hello extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const MIN_TIME:Number = 2;
		private const MAX_TIME:Number = 2.5;
		private var tweens:Array = new Array();

		public function Hello(c:XMLList):void {
			super(c);
			var swinger:Swinger = new Swinger();
			swinger.x = contents.@x;
			
			var txt:MessySquareText = new MessySquareText(contents.desc, contents.desc.@width, contents.desc.@size, contents.desc.@color);
			swinger.addItem(txt);
			addChild(swinger);
			tweens.push(new Tween(swinger, "y", Elastic.easeOut, OFF_STAGE, contents.@y, getRandomTime(), USE_SECONDS));
			tweens[0].start();
		}
		private function getRandomTime():Number {
			return MIN_TIME+(Math.random()*MAX_TIME);
		}
	}
}