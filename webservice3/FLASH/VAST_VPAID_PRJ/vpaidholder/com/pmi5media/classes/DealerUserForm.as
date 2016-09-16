package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.Event;
	import flash.text.TextFieldType;
	import flash.display.Shape;
	import flash.text.TextFormat;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;


	public class DealerUserForm extends MovieClip {

		private var objFindBtn: SimpleButton = new FindBtn();
		private var objUserInput: TextField = new TextField();
		private var objTextFormat: TextFormat = new TextFormat();
		private var formXMLList: XMLList = new XMLList();

		public function DealerUserForm() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		private function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);

			objTextFormat.font = "verdana";
			objTextFormat.bold = true;
			objTextFormat.size = 13;
			objUserInput.x = 17;
			objUserInput.y = 50;
			objUserInput.height = 22;
			objUserInput.width = 122;
			objUserInput.type = TextFieldType.INPUT;
			objUserInput.defaultTextFormat = objTextFormat;

			this.addChild(objUserInput);

			objFindBtn.x = 145;
			objFindBtn.y = 38;

			this.addChild(objFindBtn);

			objFindBtn.addEventListener(MouseEvent.CLICK, findClick, false, 0, true);


		}

		public function formData(pData: XMLList): void {
			formXMLList = pData;
			this.x = formXMLList.offsetx;
			this.y = formXMLList.offsety;

		}
		private function findClick(e: MouseEvent): void {
			navigateToURL(new URLRequest(formXMLList.mapurl + "" + formXMLList.keywords + "+" + objUserInput.text));
		}

	} //class
} //pkg