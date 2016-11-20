package {
	import flash.display.MovieClip;
	public class PortfolioContainer extends MovieClip {
		protected var contents:XMLList;
		public function PortfolioContainer(c:XMLList):void {
			contents = c;
		}
	}
}