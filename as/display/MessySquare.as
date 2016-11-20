package display {
	import flash.display.Shape;
	public class MessySquare extends Shape {
		private const MIN:uint = 2;
		private var bgColor:uint = 0x000000;
		private var variance:uint = 5;
		public function MessySquare(w:Number, h:Number, v:uint = 3, b:uint = 0x000000):void {
			this.cacheAsBitmap = true;
			variance = v;
			bgColor = b;
			
			this.graphics.beginFill(bgColor);
			this.graphics.moveTo(-MIN-(Math.random()*variance), -MIN-(Math.random()*variance));
			//this.graphics.moveTo(0, 0);
			this.graphics.lineTo(w+MIN+(Math.random()*variance), -MIN-(Math.random()*variance));
			//this.graphics.lineTo(w+MIN+(Math.random()*variance), 0);
			this.graphics.lineTo(w+MIN+(Math.random()*variance), h+MIN+(Math.random()*variance));
			this.graphics.lineTo(-MIN-(Math.random()*variance), h+MIN+(Math.random()*variance));
			//this.graphics.lineTo(0, h+MIN+(Math.random()*variance));
			this.graphics.endFill();
		}
	}
}