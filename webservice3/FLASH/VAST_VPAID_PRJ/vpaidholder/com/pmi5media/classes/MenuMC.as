package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import fl.transitions.easing.Strong;


	public class MenuMC extends MovieClip {


		private var menuXmlLen: int;
		private var menuItemXmlList: XMLList = new XMLList;

		private var offsetX: int;
		private var offsetY: int;

		private var applyanim: Boolean;
		private var delayTimeAnim: Number;
		private var effectType: String;
		private var slideFrom: String = "left";
		private var showfirstwidget: Boolean;

		private var menuTween: Tween;
		private var menuTimer: Timer;
		private var mItemCounter: int = 0;
		private var arrMenuItem: Array = new Array();



		public function MenuMC() {
			// constructor code


		}


		public function loadMenuItems(pData: XMLList): void {
			mItemCounter = 0;
			arrMenuItem.length = 0;
			menuItemXmlList = pData..mitem;
			//trace("menu99"+menuItemXmlList);
			menuXmlLen = menuItemXmlList.length() - 1;

			offsetX = pData.offsetx;
			offsetY = pData.offsety;

			applyanim = pData.applyanim.toLowerCase() == "true";
			delayTimeAnim = pData.delaytime;
			effectType = pData.effecttype.toLowerCase();
			slideFrom = pData.slidefrom.toLowerCase();

			showfirstwidget = pData.showfirstwidget.toLowerCase() == "true";

			this.x = offsetX;
			this.y = offsetY;


			for (var i: int = 0; i <= menuXmlLen; i++) {
				if (menuItemXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
					createImgItem(menuItemXmlList[i].imageslide); // image slide
				} else if (menuItemXmlList[i].@type == AppConst.AD_MENU_ITEM_APP) {
					createMenuItemApp(menuItemXmlList[i].itemapp); // menu item app
				} else if (menuItemXmlList[i].@type == AppConst.AD_SUB_MENU) {
					createSubMenu(menuItemXmlList[i].submenu); // menu item app
				}
			}

			this.addEventListener(MenuItemEvent.ITEM_CLICK, onmclick);
		}

		private function onmclick(e: MenuItemEvent): void {
			showClicekdItem(e.target.name);
		}

		private function showClicekdItem(pStr: String): void {
			for (var m: int = 0; m < arrMenuItem.length; m++) {
				MovieClip(this.getChildByName(arrMenuItem[m])).setCurMenu(pStr);
			}

		}

		function hLightFirstMenu(): void {
			if (arrMenuItem.length > 0 && showfirstwidget == true)
				showClicekdItem(arrMenuItem[0]);
		}




		//FOR CREATING MENU ITEM WITH TWO IMAGES
		private function createMenuItemApp(pXml: XMLList): void {
			mItemCounter++;
			var objItemApp: MovieClip = new ItemAppMC();
			objItemApp.name = "mitem_" + mItemCounter;
			this.addChild(objItemApp);
			objItemApp.loadItemApp(pXml);
			arrMenuItem.push(objItemApp.name);
		}


		//FOR CREATING SINGLE IMAGE
		private function createImgItem(pXml: XMLList): void {
			var objImgItem: MovieClip = new ImageMC();
			this.addChild(objImgItem);
			objImgItem.loadImage(pXml);
		}

		//FOR CREATING SUB MENU 
		private function createSubMenu(pXml: XMLList): void {
			var objSubmenu: MovieClip = new SubMenuMC();
			this.addChild(objSubmenu);
			objSubmenu.loadSubmenuData(pXml);
		}

		public function doMenuAnim(): void {
			if (applyanim) {
				this.visible = false;
				menuTimer = new Timer(delayTimeAnim, 1);
				menuTimer.addEventListener(TimerEvent.TIMER_COMPLETE, menuTimeComp, false, 0, true);
				menuTimer.stop();
				menuTimer.start();
			}
			hLightFirstMenu();
		}

		private function menuTimeComp(te: TimerEvent): void {
			menuTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, menuTimeComp);
			menuTimer = null;
			chooseAnim();
		}

		private function chooseAnim(): void {
			this.visible = true;
			if (effectType.toLowerCase() == "move") {
				doAnimation(slideFrom);
			} else {
				menuTween = new Tween(this, "alpha", Strong.easeOut, 0, 1, 1, true);
				menuTween.addEventListener(TweenEvent.MOTION_FINISH, menuTweenFin, false, 0, true);
				menuTween.stop();
				menuTween.start();
			}
		}

		private function doAnimation(pStr: String): void {
			switch (pStr) {
				case "right":
					menuTween = new Tween(this, "x", Strong.easeOut, AppConst.SCREEN_WIDTH + this.width + 50, offsetX, 1, true);
					menuTween.addEventListener(TweenEvent.MOTION_FINISH, menuTweenFin, false, 0, true);
					menuTween.stop();
					menuTween.start();
					break;

				case "top":
					menuTween = new Tween(this, "y", Strong.easeOut, -this.height, offsetY, 1, true);
					menuTween.addEventListener(TweenEvent.MOTION_FINISH, menuTweenFin, false, 0, true);
					menuTween.stop();
					menuTween.start();
					break;

				case "bottom":
					trace(("h=" + this.height));
					menuTween = new Tween(this, "y", Strong.easeOut, AppConst.SCREEN_HEIGHT, offsetY, 1, true);
					menuTween.addEventListener(TweenEvent.MOTION_FINISH, menuTweenFin, false, 0, true);
					menuTween.stop();
					menuTween.start();
					break;

				default:
					menuTween = new Tween(this, "x", Strong.easeOut, -this.width * 1.5, offsetX, 1, true);
					menuTween.addEventListener(TweenEvent.MOTION_FINISH, menuTweenFin, false, 0, true);
					menuTween.stop();
					menuTween.start();

			}


		}

		private function menuTweenFin(et: TweenEvent): void {
			menuTween.removeEventListener(TweenEvent.MOTION_FINISH, menuTweenFin);
			menuTween = null;
		}

	} //class

} //pkd