package {
	import PortfolioContainer;
	import display.Swinger;
	import flash.display.MovieClip;
	import display.MessySquareButton;
	import display.MessySquare;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	public class Recreation extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const MIN_TIME:Number = 2;
		private const MAX_TIME:Number = 2.5;
		private const BTN_Y:Number = 200;
		private var tweens:Array = new Array();
		private var yesBtn:Swinger = new Swinger();
		private var noBtn:Swinger = new Swinger();
		private var warning:Swinger = new Swinger();
			private var warningSquare:MessySquare;
			private var txt:TextField = new TextField();
			private var warningFormat:TextFormat;
		
		public function Recreation(c:XMLList):void {
			super(c.elements);
			yesBtn.addItem(new MessySquareButton(contents.@yesText,function() { navigateToURL(new URLRequest("http://www.organbiter.com/"), "_blank"); }, contents.@btnSize, contents.@btnColor, contents.@btnColorOver));
			yesBtn.x = 50;
			yesBtn.init(yesBtn.x, BTN_Y);
			addChild(yesBtn);
			new Tween(yesBtn, "y", Elastic.easeOut, OFF_STAGE, BTN_Y, getRandomTime(), USE_SECONDS).start();
			
			noBtn.addItem(new MessySquareButton(contents.@noText, function() { navigateToURL(new URLRequest("http://www.jonathanadamski.com/"), "_blank"); }, contents.@btnSize, contents.@btnColor, contents.@btnColorOver));
			noBtn.x = 100;
			noBtn.init(noBtn.x, BTN_Y);
			addChild(noBtn);
			new Tween(noBtn, "y", Elastic.easeOut, OFF_STAGE, BTN_Y, getRandomTime(), USE_SECONDS).start();

			txt.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(contents.@warningSize), uint("0x"+contents.@warningColor));
			txt.width = 350;
			txt.text = contents.@warningText;
			txt.selectable = false;
			txt.wordWrap = txt.multiline = true;
			txt.embedFonts = true;
			txt.autoSize = "left";
			warningSquare = new MessySquare(txt.width, txt.height);
			warning.addItem(warningSquare);
			warning.addItem(txt);
			warning.x = warning.width/2;
			warning.init(warning.width/2, 100);
			addChild(warning);
			new Tween(warning, "y", Elastic.easeOut, OFF_STAGE, 100, getRandomTime(), USE_SECONDS).start();
		}
		private function getRandomTime():Number {
			return MIN_TIME+(Math.random()*MAX_TIME);
		}
	}
}