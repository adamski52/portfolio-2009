package display {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import display.MessySquare;
	public class MessySquareButton extends MovieClip {
		private var useSquare:Boolean;
		private var clickFunc:Function;
		public var overFormat:TextFormat;
		public var offFormat:TextFormat;
		public var txt:TextField = new TextField();
		public var square:MessySquare;
		public var id:uint = 0;
		public function MessySquareButton(t:String, cF:Function, s:uint = 14, c:String = "FFFFFF", cO:String = "FFCC00", i:uint = 0, useS:Boolean = true):void {
			this.cacheAsBitmap = true;
			id = i;
			useSquare = useS;
			clickFunc = cF;
			offFormat = txt.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(s), uint("0x"+c));
			overFormat = new TextFormat(new GrilledCheese().fontName, int(s), uint("0x"+cO));
			txt.text = t;
			txt.autoSize = "left";
			txt.multiline = txt.wordWrap = txt.selectable = mouseChildren = false;
			txt.embedFonts = buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
			addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			addEventListener(MouseEvent.CLICK, onMouseClick);
			if(useSquare) {
				square = new MessySquare(txt.width, txt.height);
				addChild(square);
			}
			addChild(txt);
			x = -width/2;
			y = -height/2;
		}
		private function onMouseOver(e:MouseEvent):void {
			txt.setTextFormat(overFormat);
		}
		private function onMouseOut(e:MouseEvent):void {
			txt.setTextFormat(offFormat);
		}
		private function onMouseClick(e:MouseEvent):void {
			clickFunc.call(null);
		}
	}
}