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
	import fl.motion.easing.Back;


	public class ThumbGalleryMC extends MovieClip {

		private var objThumbBar: MovieClip = new ThumbBarMC();

		private var prvBtnMC: MovieClip = new PreviousBtnMC();
		private var nextBtnMC: MovieClip = new NextBtnNewMC();
		private var objImgGalMC: MovieClip = new ImgGalleryMC();
		private var objBigImgHolder: MovieClip = new MovieClip();

		private var objVidPlayerMC: MovieClip = new VidPlayerMC(); // for playing video

		private var objYoutubePlayer: MovieClip; // for playing video
		private var hideTwn: Tween;

		private var nextBtnLoader: Loader = new Loader();
		private var nextBtn: Sprite = new Sprite();

		private var prvBtnTween: Tween;
		private var nextBtnTween: Tween;

		private var navBtnTweenType: String;
		private var navBtnsTwnDur: Number = .4;

		private var thumbGalXmlList: XMLList = new XMLList();
		private var photoXmlList: XMLList = new XMLList();
		private var bigXmlList: XMLList = new XMLList();
		private var currentPhoto: int;
		private var photoLen: int = 0;
		private var showTrackXmlList: XMLList = new XMLList();
		private var enableTrack: Boolean;

		private var firstPicNo: int = 0; /// display images at first time
		private var spinner: PreloaderSpinner;
		private var isConLoaded: Boolean;
		private var objBackBtn: MovieClip = new BackBtnMC();
		private var isBackBtnXML: XMLList = new XMLList();

		private var photoIndex: int = 0;
		private var bigIndex: int = 0;
		private var totalPhotos: int = 0;

		private var totalBigImgLen: int = 0;
		private var bigImgXmlList: XMLList = new XMLList();
		private var totBigInPhoto: XMLList = new XMLList();
		private var totBigInPhotoLen: int = 0;
		private var arrBigImgLen: Array = new Array();
		private var arrBigImg: Array = new Array();
		private var counter: int = 0;
		private var loadedArray: Array = new Array();
		private var maxArrLenNo2: uint = 0;
		private var loadedBigImgNo: int = 0;
		private var counter2: int = 0;
		private var bigimgPath: String = "";
		private var bigImgChildren: int = 0;
		private var thumbGalType: String = "";
		private var isBigImgsLoaded: Boolean;

		public function ThumbGalleryMC() {
			// constructor code
			this.addEventListener(Event.ADDED_TO_STAGE, addtostage, false, 0, true);
			this.addEventListener(AppConst.EVENT_ANIM_COMP, animComp, false, 0, true);
		}

		function addtostage(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addtostage)
			spinner = new PreloaderSpinner(75, 75);
			spinner.setColors(0x000762C5, 0xFF0762C5);
			spinner.x = AppConst.SCREEN_WIDTH / 2 - spinner.width / 2;
			spinner.y = AppConst.SCREEN_HEIGHT / 2 - spinner.height / 2;
			spinner.bgAlpha = 0.8;
			addAllModules();

		}

		private function addAllModules(): void {
			this.addChild(objImgGalMC);
			this.addChild(objVidPlayerMC);
			this.addChild(objBackBtn);
			objBackBtn.visible = false;
			this.addChild(objBigImgHolder);
			this.addChild(spinner);
			this.addChild(objThumbBar);
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
			thumbGalXmlList = pData;
			objVidPlayerMC.hideStopVideo();

			if (thumbGalXmlList.trackingurl.length() > 0)
				showTrackXmlList = thumbGalXmlList.trackingurl;

			if (thumbGalXmlList.enabletracking.length() > 0)
				enableTrack = thumbGalXmlList.enabletracking.toLowerCase() == "true";
			else
				enableTrack = false;

			photoXmlList = thumbGalXmlList..photo;

			photoLen = photoXmlList.length() - 1;
			thumbGalType = thumbGalXmlList.thumbbar.@galtype;
			if (thumbGalType == "image") {
				showSpinner();
				isBigImgsLoaded = false;
				loadAllBig();
			} else {
				isBigImgsLoaded = true;
				hideSpinner();
			}


			objThumbBar.loadBarData(thumbGalXmlList.thumbbar);
			objThumbBar.addEventListener(ThumbBarEvent.ICON_CLICK, onTBarIconClick);

			isBackBtnXML = thumbGalXmlList..backbtn;

			if ((isBackBtnXML.length()) > 0) // if gallery back button exists
			{
				objBackBtn.loadGalBkImg(thumbGalXmlList..backbtn);
				objBackBtn.visible = true;
			}

			var maskShape: Shape = new Shape();
			maskShape.graphics.beginFill(0xff0000, 1);
			maskShape.graphics.drawRect(0, 0, AppConst.SCREEN_WIDTH, AppConst.SCREEN_HEIGHT);
			maskShape.graphics.endFill();
			maskShape.x = 0;
			maskShape.y = 0;
			this.addChild(maskShape);
			this.mask = maskShape;
		}




		private function loadAllBig(): void {
			bigImgXmlList = thumbGalXmlList.thumbbar..photo;
			totalBigImgLen = bigImgXmlList.length();

			for (var row: int = 0; row < totalBigImgLen; row++) {
				totBigInPhoto = bigImgXmlList[row]..big;
				totBigInPhotoLen = totBigInPhoto.length();
				arrBigImgLen[row] = totBigInPhotoLen;
			}

			loadBigImg();
		}



		function loadBigImg(): void {
			if (counter == (arrBigImgLen.length)) {
				hideSpinner();
				isBigImgsLoaded = true;
				showBigImg(0);
			} else {
				counter2 = 0;
				loadImage();
			}
		}


		function loadImage(): void {


			if (counter2 == int(arrBigImgLen[counter])) {

				var objBigImgCon: MovieClip = new MovieClip();
				objBigImgCon.name = "bigimgcon_" + counter;
				objBigImgCon.visible = false;

				for (var no: int = 0; no < loadedArray.length; no++) {
					var objBigImg: MovieClip = new ThumbImgGalleryMC();
					objBigImg.name = "img_" + (no);
					objBigImgCon.addChild(objBigImg);
					objBigImg.loadImage(loadedArray[no]);
				}
				addChild(objBigImgCon);
				loadedArray.length = 0;
				counter++;
				loadBigImg();
				setChildIndex(objThumbBar, numChildren - 1);
			} else {
				counter2++;
				loadedArray.push(bigImgXmlList[counter].big[(counter2 - 1)].imageslide);
				maxArrLenNo2 = loadedArray.length - 1;
				loadImage();
			}
		}



		function onTBarIconClick(e: ThumbBarEvent): void {
			showGallryItem(e.data);
		}


		public function showGallryItem(pNo: * ): void {
			if (!isBigImgsLoaded) {
				trace("if - isBigImgsLoaded" + isBigImgsLoaded);
				return;
			} else {
				trace("else - isBigImgsLoaded" + isBigImgsLoaded);
			}

			if (thumbGalType == "image") {
				showBigImg(pNo);
			} else {
				LoadBigData(pNo);
			}
		}

		private function showBigImg(pNo: * ): void {

			for (var k: int = 0; k < arrBigImgLen.length; k++) {
				if (k == int(pNo)) {
					this.getChildByName("bigimgcon_" + pNo).visible = true;
					bigImgChildren = 0;
					bigImgChildren = MovieClip(this.getChildByName("bigimgcon_" + pNo)).numChildren;
					for (var imgNo: int = 0; imgNo < arrBigImgLen[pNo]; imgNo++) {
						MovieClip(MovieClip(this.getChildByName("bigimgcon_" + pNo)).getChildByName("img_" + imgNo)).doAnim();
					}

				} else {
					this.getChildByName("bigimgcon_" + k).visible = false;
				}

			}

		}


		function LoadBigData(pNo: * ): void {
			try {
				StopAndHideAll();
				objVidPlayerMC.hideStopVideo();
				deleteAllChild(objBigImgHolder);
				bigXmlList = photoXmlList[pNo]..big;
				for (var j: int = 0; j < (bigXmlList.length()); j++) {
					if (bigXmlList[j].@type == AppConst.AD_IMAGE_SLIDE) {
						var objBigImg: MovieClip = new ImgGalleryMC();
						objBigImgHolder.addChild(objBigImg);
						objBigImg.loadImage(bigXmlList[j].imageslide);
					}
					if (bigXmlList[0].@type == AppConst.AD_VIDEO_PLAYER) {
						objVidPlayerMC.loadnPlayVideo(bigXmlList[0].vidplayer);
						objVidPlayerMC.showPlayVideo();
					}
					if (bigXmlList[0].@type == AppConst.AD_YOUTUBE) {
						objYoutubePlayer = new YoutubeMC();
						this.addChildAt(objYoutubePlayer, 1);
						objYoutubePlayer.showPlayer(bigXmlList[0].youtube);
					}
				}



			} catch (e: Error) {
				trace("big data loading error=" + e.message.toString());
			}

		}

		function deleteAllChild(obj: * ): void {
			for (var i: int = obj.numChildren - 1; i >= 0; i--) {
				obj.removeChildAt(i);
			}
		}


		public function showContainer(picno: int): void {
			try {
				StopAndHideAll();
				currentPhoto = picno;
				prvNextDisabled();

				if (photoXmlList[picno].@type == AppConst.AD_IMAGE_SLIDE) {
					objVidPlayerMC.hideStopVideo();
					objImgGalMC.loadImage(photoXmlList[picno].imageslide);
				} else if (photoXmlList[picno].@type == AppConst.AD_VIDEO_PLAYER) {
					hideGalleryBgImg();
					objVidPlayerMC.loadnPlayVideo(photoXmlList[picno].vidplayer);
					objVidPlayerMC.showPlayVideo();
				} else if (photoXmlList[picno].@type == AppConst.AD_YOUTUBE) {
					hideGalleryBgImg();
					objYoutubePlayer = new YoutubeMC();
					this.addChildAt(objYoutubePlayer, 1);
					objYoutubePlayer.showPlayer(photoXmlList[picno].youtube);

				}


			} catch (e: Error) {
				trace("photo not found");
			}

		}

		public function StopAndHideAll(): void {

			objVidPlayerMC.hideStopVideo(); // hide video and stop for playing sound in the background
			objImgGalMC.clearAndUnload(); // hide images
			deleteAllChild(objBigImgHolder);

			if ((objYoutubePlayer != null) && this.contains(getChildByName(AppConst.AD_YOUTUBE))) {
				objYoutubePlayer.hidePaused();
				this.removeChild(objYoutubePlayer);
				objYoutubePlayer = null;
			}

		}

		public function hideGalleryBgImg(): void {
			objImgGalMC.removeBgGalImgs();
		}


		public function showTrackGal(): void {
			if (enableTrack) {
				Pmi5Tracking.doShowTrack(showTrackXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(showTrackXmlList), true));
			}
		}


		function prvClick(e: Event): void {

			if (isConLoaded)
				return;

			currentPhoto--;
			if (currentPhoto < 0) {
				currentPhoto = photoLen;
			}
			showContainer(currentPhoto);
		}

		function nextClick(e: Event): void {
			if (isConLoaded) return;
			currentPhoto++;
			if (currentPhoto > photoLen) {
				currentPhoto = 0;
			}

			showContainer(currentPhoto);
		}


		function animComp(e: Event): void {
			trace("-- listen anim_comp prvNextEnabled() --");

			prvNextEnabled();
		}

		function prvNextEnabled(): void {
			isConLoaded = false;
			prvBtnMC.enabled = true;
			nextBtnMC.enabled = true;
		}

		function prvNextDisabled(): void {
			isConLoaded = true;
			prvBtnMC.enabled = false;
			nextBtnMC.enabled = false;
		}


		function prvnextBtns(): void {
			//load previous button
			prvBtnMC.addEventListener("prvbtnloaded", prvbtnLoaded, false, 0, true);
			prvBtnMC.addEventListener(AppConst.EVENT_PREVIOUS_CLICK, prvClick, false, 0, true);
			this.addChild(prvBtnMC);
			this.setChildIndex(prvBtnMC, this.numChildren - 1);
			prvBtnMC.loadPrvBtnImg("left image path");
		}



		function prvbtnLoaded(e: Event): void {
			prvBtnMC.removeEventListener("prvbtnloaded", prvbtnLoaded);

			//load next button
			nextBtnMC.addEventListener("nextbtnloaded", nextbtnLoaded, false, 0, true);
			nextBtnMC.addEventListener(AppConst.EVENT_NEXT_CLICK, nextClick, false, 0, true);
			this.addChildAt(nextBtnMC, numChildren - 1);
			nextBtnMC.loadNextBtnImg("next btn image path");
		}

		function nextbtnLoaded(e: Event): void {
			nextBtnMC.removeEventListener("nextbtnloaded", nextbtnLoaded);
			prvBtnMC.visible = true;
			nextBtnMC.visible = true;
		}



		public function playPrevNextTween(): void {

			// if gallery has only one photo
			if (photoLen <= 0) {
				prvBtnMC.visible = false;
				nextBtnMC.visible = false;
				return;
			}

			prvBtnMC.visible = true;
			nextBtnMC.visible = true;

			navBtnTweenType = "move";
			prvBtnTween = new Tween(prvBtnMC, "x", Strong.easeOut, prvBtnMC.x + 100, 0, navBtnsTwnDur, true);
			prvBtnTween.addEventListener(TweenEvent.MOTION_FINISH, prvBtnTweenFinish, false, 0, true);

			nextBtnTween = new Tween(nextBtnMC, "x", Strong.easeOut, (nextBtnMC.x - 100), nextBtnMC.x, navBtnsTwnDur, true);
			nextBtnTween.addEventListener(TweenEvent.MOTION_FINISH, nextBtnTweenFinish, false, 0, true);

		}

		function prvBtnTweenFinish(e: TweenEvent): void {
			prvBtnTween.removeEventListener(TweenEvent.MOTION_FINISH, prvBtnTweenFinish);
			prvBtnTween = null;
		}


		function nextBtnTweenFinish(e: TweenEvent): void {
			nextBtnTween.removeEventListener(TweenEvent.MOTION_FINISH, nextBtnTweenFinish);
			nextBtnTween = null;
		}


	} //class

}