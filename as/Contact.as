package {
	import PortfolioContainer;
	import flash.display.MovieClip;
	import display.Swinger;
	import display.MessySquareLoader;
	import display.MessySquare;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import fl.transitions.easing.*;
	import fl.transitions.Tween;
	import fl.controls.TextArea;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.events.IOErrorEvent;
	import display.Toast;

	public class Contact extends PortfolioContainer {
		private const USE_SECONDS:Boolean = true;
		private const OFF_STAGE:Number = -100;
		private const MIN_TIME:Number = 2;
		private const MAX_TIME:Number = 2.5;
		private const COLS:uint = 3;
		private const BASE_VAL:uint = 49;
		private const SPACING:uint = 15;
		private const ARROW_START_X:uint = 105;
		private const ARROW_MARGIN_X:uint = 100;
		private const ARROW_START_Y:uint = 55;
		private const ARROW_MARGIN_Y:uint = 105;
		private const ARROW_REVERSE_OFFSET:int = -10;
		private const ARROW_ROTATE_OFFSET:int = 140;
		private const NAME_Y:uint = 250;
		private const MSG_Y:uint = 360;
		private const URL_Y:uint = 463;
		private var tweens:Array = new Array();
		private var item:MessySquareLoader;
		private var defaultName:String;
		private var defaultMessage:String;
		private var nameContainer:Swinger = new Swinger();
			private var nameMs:MessySquare;
			private var nameTxt:TextArea;
			private var nameTween:Tween;
		private var msgContainer:Swinger = new Swinger();
			private var msgMs:MessySquare;
			private var msgTxt:TextArea;
			private var msgTween:Tween;
		private var urlContainer:Swinger = new Swinger();
			private var urlTxt:TextField = new TextField();
			private var urlMs:MessySquare;
			private var urlTween:Tween;
		private var btnFormat:TextFormat;
		private var btnFormatOver:TextFormat;
		
		public function Contact(c:XMLList):void {
			super(c.elements);
			defaultName = contents.@defaultName;
			defaultMessage = contents.@defaultMessage;
			var i:uint = 0;
			for(i = 0; i < contents..element.length(); i++) {
				item = new MessySquareLoader(contents..element[i], i);
				item.addEventListener("messySquareComplete", onMessySquareComplete);
				tweens.push(null);
			}
			for(i = 0; i < contents..element.length()-1; i++) {
				item = new MessySquareLoader(contents.@arrow, tweens.length);
				item.addEventListener("messySquareComplete", onMessyArrowComplete);
				tweens.push(null);
			}
			
			var inputFormat:TextFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@inputSize), int("0x"+c.elements.@inputColor));
			btnFormat = new TextFormat(new GrilledCheese().fontName, int(c.elements.@btnSize), int("0x"+c.elements.@btnColor));
			btnFormatOver = new TextFormat(new GrilledCheese().fontName, int(c.elements.@btnSize), int("0x"+c.elements.@btnColorOver));
			nameTxt = new TextArea();
			nameTxt.setStyle("embedFonts", true);
			nameTxt.setStyle("textFormat", inputFormat);
			nameTxt.setSize(310, 40);
			nameTxt.editable = true;
			nameTxt.text = defaultName;
			nameTxt.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			nameTxt.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
			nameMs = new MessySquare(nameTxt.width, nameTxt.height);
			nameTxt.name = "nameTxt";
			nameContainer.addItem(nameMs);
			nameContainer.addItem(nameTxt);
			nameContainer.x = nameContainer.width/2;
			
			msgTxt = new TextArea();
			msgTxt.setStyle("embedFonts", true);
			msgTxt.setStyle("textFormat", inputFormat);
			msgTxt.setSize(310, 150);
			msgTxt.editable = true;
			msgTxt.text = defaultMessage;
			msgTxt.addEventListener(FocusEvent.FOCUS_IN, onFocus);
			msgTxt.addEventListener(FocusEvent.FOCUS_OUT, onBlur);
			msgTxt.name = "msgTxt";
			msgMs = new MessySquare(msgTxt.width, msgTxt.height);
			msgContainer.addItem(msgMs);
			msgContainer.addItem(msgTxt);
			msgContainer.x = msgContainer.width/2;
			addChild(msgContainer);
			addChild(nameContainer);
			
			urlContainer.mouseChildren = false;
			urlTxt.text = contents.@goText;
			urlTxt.embedFonts = true;
			urlTxt.autoSize = "left";
			urlTxt.setTextFormat(btnFormat);
			urlMs = new MessySquare(urlTxt.width, urlTxt.height);
			urlContainer.addItem(urlMs);
			urlContainer.addItem(urlTxt);
			urlContainer.buttonMode = true;
			urlContainer.addEventListener(MouseEvent.ROLL_OVER, onBtnOver);
			urlContainer.addEventListener(MouseEvent.ROLL_OUT, onBtnOut);
			urlContainer.addEventListener(MouseEvent.CLICK, onBtnClick);
			urlContainer.x = 295;
			addChild(urlContainer);
			
			nameTween = new Tween(nameContainer, "y", Elastic.easeOut, OFF_STAGE, NAME_Y, getRandomTime(), USE_SECONDS);
			nameTween.start();
			msgTween = new Tween(msgContainer, "y", Elastic.easeOut, OFF_STAGE, MSG_Y, getRandomTime(), USE_SECONDS);
			msgTween.start();
			urlTween = new Tween(urlContainer, "y", Elastic.easeOut, OFF_STAGE, URL_Y, getRandomTime(), USE_SECONDS);
			urlTween.start();
		}
		private function onBtnOver(e:MouseEvent):void {
			urlTxt.setTextFormat(btnFormatOver);
		}
		private function onBtnOut(e:MouseEvent):void {
			urlTxt.setTextFormat(btnFormat);
		}
		private function isValidEmail(email:String):Boolean {
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(email);
		}
		private function onBtnClick(e:MouseEvent):void {
			var emailValid:Boolean = isValidEmail(nameTxt.text);
			var msgValid:Boolean = msgTxt.text != "" && msgTxt.text != defaultMessage;
			if(emailValid && msgValid) {
				var vars:URLVariables = new URLVariables();
				vars.email = nameTxt.text;
				vars.message = msgTxt.text;
				
				var req:URLRequest = new URLRequest("contact.php");
				req.method = URLRequestMethod.POST;
				req.data = vars;
				
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.VARIABLES;
				loader.addEventListener(Event.COMPLETE, onSubmit);
				loader.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loader.load(req);
			}
			else if(!emailValid) {
				addChild(new Toast("Please enter a valid email address.", -400, -200, -400, 200, 3, 24, "FF0000"));
			}
			else {
				addChild(new Toast("Please enter a valid message.", -400, -200, -400, 200, 3, 24, "FF0000"));
			}
		}
		private function onError(e:IOErrorEvent):void {
			addChild(new Toast("You were unable to make contact.  I'm sorry.  It's my fault.", -400, -200, -400, 200, 3, 24, "FF0000"));
		}
		private function onSubmit(e:Event){
			urlContainer.enabled = false;
			addChild(new Toast("Your email has been sent.  Thanks!", -400, -200, -400, 200, 3, 24, "FF0000"));
		}
		private function onFocus(e:FocusEvent):void {
			if((e.target.parent == msgTxt && e.target.parent.text == defaultMessage) || (e.target.parent == nameTxt && e.target.parent.text == defaultName)) {
				e.target.parent.text = "";
			}
		}
		private function onBlur(e:FocusEvent):void {
			if((e.target.parent == msgTxt && e.target.parent.text == "")) {
				e.target.parent.text = defaultMessage;
			}
			else if(e.target.parent == nameTxt && e.target.parent.text == "") {
				e.target.parent.text = defaultName;
			}
		}
		private function getRandomTime():Number {
			return MIN_TIME+(Math.random()*MAX_TIME);
		}
		private function onMessyArrowComplete(e:Event):void {
			var col:uint = (e.target.id-contents..element.length())%(COLS-1);
			var row:uint = Math.floor((e.target.id-contents..element.length())/(COLS-1));
			var swinger:Swinger = new Swinger();
			swinger.x = (col*ARROW_MARGIN_X)+ARROW_START_X;
			var yOffset:Number = 0;
			switch(e.target.id) {
				case 10:
					swinger.x += ARROW_ROTATE_OFFSET;
					swinger.rotation = 90;
					yOffset = 155;
					break;
				case 8:
				case 9:
					swinger.scaleX = -1;
					swinger.x += ARROW_REVERSE_OFFSET;
					break;
				default:
					break;
			}
			addChild(swinger);
			swinger.addItem(MovieClip(e.target));
			var yy:Number = (row*ARROW_MARGIN_Y)+ARROW_START_Y-yOffset;
			tweens[e.target.id] = new Tween(swinger, "y", Elastic.easeOut, OFF_STAGE, yy, getRandomTime(), USE_SECONDS);
			tweens[e.target.id].start();
		}
		private function onMessySquareComplete(e:Event):void {
			var swinger:Swinger = new Swinger();
			
			// h and w are fixed
			var col:uint = e.target.id%COLS;
			var row:uint = Math.floor(e.target.id/COLS);
			swinger.x = BASE_VAL+(contents.@itemWidth * col) + (SPACING * col);
			var obj:MovieClip = MovieClip(e.target);
			swinger.addItem(obj);
			addChild(swinger);
			setChildIndex(swinger, 0);
			var yy:Number = BASE_VAL+(contents.@itemHeight * row) + (SPACING * row);
			tweens[e.target.id] = new Tween(swinger, "y", Elastic.easeOut, OFF_STAGE, yy, getRandomTime(), USE_SECONDS);
			tweens[e.target.id].start();
		}
	}
}