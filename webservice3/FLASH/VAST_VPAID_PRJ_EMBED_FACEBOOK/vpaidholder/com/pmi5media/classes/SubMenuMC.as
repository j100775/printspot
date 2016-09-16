package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ErrorEvent;
	import flash.display.Sprite;
	import flash.display.Shape;


	public class SubMenuMC extends MovieClip {


		private var xmlLen: int;
		private var submenuXmlList: XMLList = new XMLList();

		private var bgImgPath: String;
		private var overImgPath: String;
		private var imgW: int;
		private var imgH: int;

		private var offsetX: int;
		private var offsetY: int;
		private var showat: String = "right";

		private var objBgShape: Sprite = new Sprite();
		private var objSubMenu: MovieClip = new MovieClip();
		private var overBgPicMC: Sprite = new Sprite(); // for small image which is background image of small landing image.
		private var overPicMC: Sprite = new Sprite();

		private var bgImgLoader: Loader = new Loader();
		private var imgOverLoader: Loader = new Loader(); // over image loader

		private var isSubMenuActive: Boolean;
		private var subMenuW: int;
		private var subMenuH: int;
		private var submenuLen: int;
		private var bgShape: Shape = new Shape();



		public function SubMenuMC() {
			// constructor code

			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
		}

		function added(e: Event): void {
			removeEventListener(Event.ADDED_TO_STAGE, added);

			this.addChild(overBgPicMC);
			overPicMC.addEventListener(MouseEvent.MOUSE_OVER, onOverPicMC, false, 0, true);
			overBgPicMC.buttonMode = true;
			this.addChild(overPicMC);
			objSubMenu.name = "submenu";
			this.addChild(objSubMenu);
			hideSubmenu();

			objBgShape.addEventListener(MouseEvent.MOUSE_OUT, onSubMenuOut, false, 0, true);
		}


		public function loadSubmenuData(pData: XMLList): void {
			submenuXmlList = pData.submenudata;
			bgImgPath = pData.bgimg;
			overImgPath = pData.overimg;
			imgW = pData.imgwidth;
			imgH = pData.imgheight;
			offsetX = pData.offsetx;
			offsetY = pData.offsety;
			showat = pData.showat;
			subMenuH = pData.submenuheight;
			subMenuW = pData.submenuwidth;

			bgImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, bgImgErrHandler, false, 0, true);
			bgImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, bgImgLoadHandler, false, 0, true);
			bgImgLoader.load(new URLRequest(bgImgPath));

		}

		function bgImgErrHandler(er: ErrorEvent): void {
			bgImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bgImgErrHandler);
			bgImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bgImgLoadHandler);
			bgImgLoader = null;

		}

		function bgImgLoadHandler(e: Event): void {
			bgImgLoader.width = imgW;
			bgImgLoader.height = imgH;

			//remove events
			bgImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, bgImgErrHandler);
			bgImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, bgImgLoadHandler);

			//over image
			imgOverLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, overImgError, false, 0, true);
			imgOverLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, overImgLoaded, false, 0, true);
			imgOverLoader.load(new URLRequest(overImgPath));

		}
		function overImgError(er: ErrorEvent): void {
			imgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			imgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);
			imgOverLoader = null;

		}

		function overImgLoaded(evt: Event): void {
			overBgPicMC.removeChildren();
			overBgPicMC.addChild(bgImgLoader);

			imgOverLoader.width = imgW;
			imgOverLoader.height = imgH;
			overPicMC.removeChildren();
			overPicMC.addChild(imgOverLoader);
			overBgPicMC.x = offsetX;
			overBgPicMC.y = offsetY;
			overPicMC.x = overBgPicMC.x;
			overPicMC.y = overBgPicMC.y;
			imgOverLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, overImgError);
			imgOverLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, overImgLoaded);

			createSubmenu();
		}

		function createSubmenu(): void {


			submenuLen = submenuXmlList.length() - 1;
			for (var i: int = 0; i <= submenuLen; i++) {
				if (submenuXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createImgItem(submenuXmlList[i].imageslide); // image slide
				} else if (submenuXmlList[i].@type == AppConst.AD_MENU_ITEM_APP) {
					createMenuItemApp(submenuXmlList[i].itemapp); // menu item app
				}
			}

			//draw bg
			bgShape.graphics.beginFill(0x0ff000, .8);
			bgShape.graphics.drawRect(0, 0, subMenuW + 100, 100);
			bgShape.graphics.endFill();

			bgShape.name = "bgshape";
			bgShape.x = offsetX;
			bgShape.y = 30;
			objBgShape.alpha = .5;
			objBgShape.addChild(bgShape);
			objSubMenu.addChild(objBgShape);



		}

		//FOR CREATING MENU ITEM WITH TWO IMAGES
		private function createMenuItemApp(pXml: XMLList): void {
			var objItemApp: MovieClip = new ItemAppMC();
			objItemApp.name = "objItemApp";
			objSubMenu.addChild(objItemApp);
			objItemApp.loadItemApp(pXml);
		}


		//FOR CREATING SINGLE IMAGE
		private function createImgItem(pXml: XMLList): void {

			var objImgItem: MovieClip = new ImageMC();
			objImgItem.name = "objImgItem";
			objSubMenu.addChild(objImgItem);

			objImgItem.loadImage(pXml);
		}



		function hideSubmenu(): void {
			objSubMenu.visible = false;
		}


		function onSubMenuOver(e: MouseEvent): void {
			trace(" -------over--------- ");

		}




		function showSubmenu(): void {
			objSubMenu.visible = true;
		}

		function onOverPicMC(e: MouseEvent): void {
			overPicMC.visible = false;
			showSubmenu();
		}

		function onOverBgPicOut(e: MouseEvent): void {
			//overPicMC.visible=true;
			//hideSubmenu();
		}

		function onSubMenuOut(e: MouseEvent): void {

			overPicMC.visible = true;

			trace(" ---)) onSubMenuOut item name=" + e.target.name + " ctarget=" + e.currentTarget.name);
			if (e.target.name == "submenu") hideSubmenu();

		}


	} //class

}