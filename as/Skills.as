package {
	import PortfolioContainer;
	import display.Swinger;
	import flash.display.MovieClip;
	import display.MessySquareLoader;
	import display.MessySquare;
	import display.MessySquareText;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;

	public class Skills extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const MIN_TIME:Number = 2;
		private const MAX_TIME:Number = 2.5;
		private const BASE_VAL:uint = 40;
		private const COLS:uint = 4;
		private const SKILL_TIME:Number = .5;
		private const SPACING:uint = 15;
		private var tweens:Array = new Array();
		private var item:Swinger;
		private var fillbar:MovieClip = new MovieClip();
		private var skillbar:MessySquare; 
		private var fillbarBg:MessySquare;
		private var textbar:MessySquareText;
		public function Skills(c:XMLList):void {
			super(c.elements);
			for(var i:uint = 0; i < contents..element.length(); i++) {
				item = new Swinger();
				var msl:MessySquareLoader = new MessySquareLoader(contents..element[i], i);
				msl.addEventListener("messySquareComplete", onMessySquareComplete);
				msl.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				msl.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
				msl.buttonMode = true;
				item.addItem(msl);
				trace("go");
				tweens.push(null);
			}
			var numRows:uint = Math.ceil(contents..element.length()/COLS);
			fillbarBg = new MessySquare(contents.@barWidth, contents.@barHeight);
			textbar = new MessySquareText("", contents.@barWidth, contents.@titleSize, contents.@titleColor, 0, false);
			textbar.txt.text = contents.@default;
			skillbar = new MessySquare(contents.@skillWidth, contents.@skillHeight, 3, int("0x"+contents.@skillColor));
			skillbar.x = contents.@skillX;
			skillbar.y = contents.@skillY;
			skillbar.scaleX = 0;
			addChild(fillbar);
			fillbar.addChild(fillbarBg);
			fillbar.addChild(textbar);
			fillbar.addChild(skillbar);
			
			textbar.x = textbar.y = 0;
			tweens.push(new Tween(fillbar, "y", Elastic.easeOut, OFF_STAGE, BASE_VAL + (contents.@itemHeight * numRows) + (SPACING*numRows) - 40, getRandomTime(), USE_SECONDS));
			tweens[tweens.length-1].start();
		}
		private function getRandomTime():Number {
			return MIN_TIME+(Math.random()*MAX_TIME);
		}
		private function onMouseOver(e:MouseEvent):void {
			textbar.txt.text = contents.@default + contents..element[e.target.id].@skillName;
			tweens.push(new Tween(skillbar, "scaleX", Bounce.easeOut, skillbar.scaleX, contents..element[e.target.id].@skill, SKILL_TIME, USE_SECONDS));
			tweens[tweens.length-1].start();
		}
		private function onMouseOut(e:MouseEvent):void {
			textbar.txt.text = contents.@default;
			tweens.push(new Tween(skillbar, "scaleX", Bounce.easeOut, skillbar.scaleX, 0, SKILL_TIME, USE_SECONDS));
			tweens[tweens.length-1].start();
		}
		private function onMessySquareComplete(e:Event):void {
			// h and w are fixed
			var col:uint = e.target.id%COLS;
			var row:uint = Math.floor(e.target.id/COLS);
			var destX:Number = BASE_VAL + (contents.@itemWidth * col) + (SPACING * col);
			var destY:Number = BASE_VAL + (contents.@itemHeight * row) + (SPACING * row);
			e.target.parent.x = destX;
			addChild(Swinger(e.target.parent));
			tweens[e.target.id] = new Tween(e.target.parent, "y", Elastic.easeOut, OFF_STAGE, destY, getRandomTime(), USE_SECONDS);
			tweens[e.target.id].start();
		}
	}
}