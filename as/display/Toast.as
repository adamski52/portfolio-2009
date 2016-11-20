package display {
	import flash.display.MovieClip;
	import display.MessySquare;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	public class Toast extends MovieClip {
		private var startX:Number;
		private var startY:Number;
		private var time:Number;
		private var tweens:Array = new Array();
		public function Toast(msg:String, sX:Number, sY:Number, eX:Number, eY:Number, d:Number=3, s:int = 25, c:String = "FFFFFF", t:Number = 1) {
			startX = sX;
			startY = sY;
			time = t;
			var txt:TextField = new TextField();
			txt.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, s, int("0x"+c));
			txt.autoSize = "left";
			txt.width = 300;
			txt.multiline = txt.wordWrap = true;
			txt.text = msg;
			
			var ms:MessySquare = new MessySquare(txt.width, txt.height);
			addChild(ms);
			addChild(txt);
			
			tweens.push(new Tween(this, "x", Elastic.easeOut, sX, eX, t, true))
			tweens[tweens.length-1].start();
			tweens.push(new Tween(this, "y", Elastic.easeOut, sY, eY, t, true));
			tweens[tweens.length-1].start();
			var timer:Timer = new Timer(d*1000, 1);
			timer.addEventListener("timer", onTimer);
			timer.start();
		}
		private function onTimer(e:TimerEvent):void {
			tweens.push(new Tween(this, "x", Regular.easeIn, x, startX, time/2, true));
			tweens[tweens.length-1].start();
			tweens.push(new Tween(this, "y", Regular.easeIn, y, startY, time/2, true));
			tweens[tweens.length-1].start();
			var timer:Timer = new Timer((time*500)+100, 1);
			timer.addEventListener("timer", suicide);
			timer.start();
		}
		private function suicide(e:TimerEvent):void {
			parent.removeChild(this);
		}
	}
}