package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.events.Event;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.TweenEvent;
	import flash.utils.setInterval;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	import flash.display.SimpleButton;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;

	public class View360Gallery extends MovieClip {

		private var photosXMLList: XMLList;
		private var objImgGalMC: MovieClip = new ImgView360GalleryMC();
		private var objRotLeftBtn: MovieClip = new RotLeftBtnMC();
		private var objRotRightBtn: MovieClip = new RotRightBtnMC();
		private var picXmlList: XMLList = new XMLList();
		private var currentPhoto: int;
		private var picTotlaLen: int = 0;
		private var showTrackXmlList: XMLList = new XMLList();
		private var enableTrack: Boolean;

		private var firstPicNo: int = 0; /// display images at first time
		private var spinner: PreloaderSpinner;

		private var isConLoaded: Boolean;

		private var objBackBtn: MovieClip = new BackBtnMC();
		private var isBackBtnXML: XMLList = new XMLList();

		private var previousX: Number = 0;
		private var previousY: Number = 0;
		private var currentX: Number = 0;
		private var currentY: Number = 0;
		private var xDir: String;
		private var yDir: String;

		private var dir1: TextField = new TextField();
		private var dir2: TextField = new TextField();

		private var dragObj: Sprite = new Sprite();
		private var shapObj: Shape = new Shape();
		private var curX: Number = 0;
		private var curY: Number = 0;
		private var oldX: Number = 0;
		private var oldY: Number = 0;
		private var gridUnit: Number = 25;
		private var countNo: int = 0;
		private var maxCountNo: int;
		private var xDiff: Number;
		private var yDiff: Number;
		private var counter: int = 0;
		private var loadedArray: Array = new Array();
		private var maxArrLenNo: uint = 0;

		public function View360Gallery() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addtostage, false, 0, true);

		}

		function addtostage(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addtostage);
			addAllModules();
		}

		private function addAllModules(): void {
			this.addChild(objImgGalMC);
			this.addChild(objBackBtn);
			objBackBtn.visible = false;

			objRotLeftBtn.addEventListener(MouseEvent.CLICK, onRotLeftClick, false, 0, true);
			objRotLeftBtn.addEventListener(MouseEvent.MOUSE_DOWN, dragIt);

			objRotRightBtn.addEventListener(MouseEvent.CLICK, onRotRightClick, false, 0, true);
			objRotRightBtn.addEventListener(MouseEvent.MOUSE_DOWN, dragIt);

			this.addChild(objRotLeftBtn);
			this.addChild(objRotRightBtn);

			spinner = new PreloaderSpinner(120, 120);
			spinner.setColors(0x000762C5, 0xFF0762C5);
			spinner.bgAlpha = 0.2;

			//load and show spinner
			spinner.x = (AppConst.SCREEN_WIDTH / 2) + (spinner.width * .10);
			spinner.y = (AppConst.SCREEN_HEIGHT / 2) + (spinner.height * .10);
			this.addChild(spinner);


		}

		function loadImage(): void {
			var loader: Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaded, false, 0, true);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errOnLoad, false, 0, true);

			if (picXmlList[counter].@type == AppConst.AD_IMAGE_SLIDE) {
				loader.load(new URLRequest(picXmlList[counter].imageslide.imgpath));
			}

		}



		function loaded(e: Event): void {
			e.target.removeEventListener(Event.COMPLETE, loaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, errOnLoad);
			
			var bmpimg:Bitmap = e.target.content as Bitmap;
			bmpimg.smoothing = true;
			bmpimg.pixelSnapping = PixelSnapping.AUTO;
			loadedArray.push(bmpimg);

			//loadedArray.push(e.target.content);

			maxArrLenNo = loadedArray.length - 1;

			loadedArray[maxArrLenNo].x = 0;
			loadedArray[maxArrLenNo].y = 0;
			loadedArray[maxArrLenNo].width = AppConst.SCREEN_WIDTH;
			loadedArray[maxArrLenNo].height = AppConst.SCREEN_HEIGHT;
			addChild(loadedArray[maxArrLenNo]);
			this.setChildIndex(spinner, numChildren - 1);

			if (counter == picTotlaLen) {
				hideShowImages(0);
				hideSpinner();
				prvNextEnabled();
			} else {
				counter++;
				loadImage();
				this.setChildIndex(spinner, numChildren - 1);
			}
		}

		function errOnLoad(e: IOErrorEvent): void {
			e.target.removeEventListener(Event.COMPLETE, loaded);
			e.target.removeEventListener(IOErrorEvent.IO_ERROR, errOnLoad);
			var tempImg: Sprite = new Sprite();
			tempImg.name = "img" + counter;
			loadedArray.push(tempImg);
			counter++;
			loadImage();
		}

		function showSpinner(): void {
			spinner.visible = true;
			spinner.startSpinner();
		}

		function hideSpinner(): void {
			spinner.visible = false;
			spinner.stopSpinner();
		}

		public function loadPhotos(pData: XMLList): void {
			isBackBtnXML = null;
			enableTrack = false;
			photosXMLList = pData;

			if (photosXMLList.trackingurl.length() > 0)
				showTrackXmlList = photosXMLList.trackingurl;

			if (photosXMLList.enabletracking.length() > 0)
				enableTrack = photosXMLList.enabletracking.toLowerCase() == "true";
			else
				enableTrack = false;


			picXmlList = photosXMLList..photo;
			picTotlaLen = picXmlList.length() - 1;
			isBackBtnXML = photosXMLList..backbtn;

			if ((isBackBtnXML.length()) > 0) // if gallery back button exists
			{
				objBackBtn.loadGalBkImg(photosXMLList..backbtn);
				objBackBtn.visible = true;
			}
			this.setChildIndex(objRotLeftBtn, numChildren - 1);
			this.setChildIndex(objRotRightBtn, numChildren - 1);

			loadImage();
			showSpinner();
			prvNextDisabled();
		}


		function hideShowImages(picno: int): void {
			currentPhoto = picno;
			for (var k: uint = 0; k < loadedArray.length; k++) {
				loadedArray[k].visible = false;
			}
			loadedArray[picno].visible = true;
		}



		public function StopAndHideAll(): void {
			objImgGalMC.clearAndUnload(); // hide images
		}

		public function hideGalleryBgImg2(): void {
			objImgGalMC.removeBgGalImgs();
		}


		public function showTrackV360Gal(): void {
			if (enableTrack) {
				Pmi5Tracking.doShowTrack(showTrackXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(showTrackXmlList), true));

			}
		}


		function onRotLeftClick(e: Event): void {
			showLeftImg();
		}

		function showLeftImg(): void {
			if (isConLoaded) return;
			currentPhoto--;
			if (currentPhoto < 0) {
				currentPhoto = picTotlaLen;
			}
			hideShowImages(currentPhoto);
		}

		function onRotRightClick(e: Event): void {
			showRightImg();
		}

		function showRightImg(): void {
			if (isConLoaded) return;
			currentPhoto++;
			if (currentPhoto > picTotlaLen) {
				currentPhoto = 0;
			}
			hideShowImages(currentPhoto);
		}

		function prvNextEnabled(): void {
			isConLoaded = false;
			objRotLeftBtn.enabled = true;
			objRotRightBtn.enabled = true;
		}

		function prvNextDisabled(): void {
			isConLoaded = true;
			objRotLeftBtn.enabled = false;
			objRotRightBtn.enabled = false;
		}


		function checkDirection(e: MouseEvent): void {
			getHorizontalDirection();
			getVerticalDirection();
		}

		function getHorizontalDirection(): void {
			previousX = currentX;
			currentX = stage.mouseX;

			if (previousX > currentX) {
				xDir = "left";
			} else if (previousX < currentX) {
				xDir = "right";
			} else {
				//xDir = "none";
			}
		}

		function getVerticalDirection(): void {
			previousY = currentY;
			currentY = stage.mouseY;

			if (previousY > currentY) {
				yDir = "up";
			} else if (previousY < currentY) {
				yDir = "down";
			} else {
				yDir = "none";
			}
		}

		function dragIt(e: MouseEvent): void {

			if (isConLoaded) return;
			oldX = mouseX;
			oldY = mouseY;

			// add mouse up listener so you know when it is released
			stage.addEventListener(MouseEvent.MOUSE_UP, dropIt);
			stage.addEventListener(Event.ENTER_FRAME, moveIt);

		}

		function moveIt(e: Event): void {
			getHorizontalDirection();
			getVerticalDirection();


			curX = mouseX;
			curY = mouseY;

			// figure out which is the larger number and subtract the smaller to get diff
			xDiff = curX > oldX ? curX - oldX : oldX - curX;
			yDiff = curY > oldY ? curY - oldY : oldY - curY;

			if (xDiff < 1) {
				if (xDiff > yDiff) {
					//dragObj.x = snapNearest(mouseX, gridUnit);
				} else {
					//dragObj.y = snapNearest(mouseY, gridUnit);
				}


			} else {
				if (xDir == "left") {
					countNo--;
					if (countNo < 0) countNo = picTotlaLen;
					showLeftImg();

				} else {
					countNo++;
					if (countNo >= picTotlaLen) countNo = 0;
					showRightImg();
				}



			}

			oldX = mouseX;
			oldY = mouseY;


		}

		function dropIt(e: MouseEvent): void {

			//remove mouse up event
			stage.removeEventListener(MouseEvent.MOUSE_UP, dropIt);
			stage.removeEventListener(Event.ENTER_FRAME, moveIt);

		}


		// snap to grid
		function snapNearest(n: Number, units: Number): Number {

			var num: Number = n / units;
			num = Math.round(num);
			num *= units;

			return num;

		}

	} //class

}