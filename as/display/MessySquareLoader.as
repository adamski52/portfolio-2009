package display {
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.display.MovieClip;
	import display.MessySquare;
	public class MessySquareLoader extends MovieClip {
		private var useSquare:Boolean = false;
		public var img:Loader;
		public var square:MessySquare;
		public var path:String = "";
		public var id:uint = 0;
		public function MessySquareLoader(p:String, i:uint = 0, useS:Boolean = true):void {
			this.cacheAsBitmap = true;
			path = p;
			id = i;
			useSquare = useS;
			try {
				img = new Loader();
				img.load(new URLRequest(path));
				img.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaderComplete);
				if(useSquare) {
					img.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
				}
			}
			catch(e:Error) { }
		}
		private function onLoaderComplete(e:Event):void {
			if(useSquare) {
				//square.x = -square.width/2;
				//square.y = -square.height/2;
				addChild(square);
			}
			e.target.loader.cacheAsBitmap = true;
			addChild(e.target.loader);
			x = -width/2;
			y = -height/2;
			dispatchEvent(new Event("messySquareComplete"));
		}
		private function onLoaderInit(e:Event):void {
			square = new MessySquare(e.target.loader.width, e.target.loader.height);
		}
	}
}