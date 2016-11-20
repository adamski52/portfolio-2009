package display {
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.MovieClip;
	import display.MessySquare;
	public class MessySquareText extends MovieClip {
		public var txt:TextField = new TextField();
		public var square:MessySquare;
		public var id:uint = 0;
		public function MessySquareText(t:String, w:uint, s:uint = 14, c:String = "FFFFFF", i:uint = 0, useS:Boolean = true):void {
			this.cacheAsBitmap = true;
			id = i;
			txt.defaultTextFormat = new TextFormat(new GrilledCheese().fontName, int(s), uint("0x"+c));
			txt.autoSize = "left";
			txt.multiline = txt.wordWrap = true;
			txt.selectable = false;
			txt.embedFonts = true;
			txt.width = w;
			txt.text = t;
			if(useS) {
				square = new MessySquare(txt.width, txt.height);
				addChild(square);
			}
			addChild(txt);
			x = -width/2;
			y = -height/2;
		}
	}
}