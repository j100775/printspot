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


	public class PhotoContainerMC extends MovieClip {

		private var galXMLList: XMLList;
		private var prvBtnMC: MovieClip = new PreviousBtnMC();
		private var nextBtnMC: MovieClip = new NextBtnNewMC();


		//private var objImgGalMC: MovieClip = new ImgGalleryMC();

		private var objVidPlayerMC: MovieClip = new VidPlayerMC(); // for playing video

		private var objYoutubePlayer: MovieClip; // for playing video



		private var hideTwn: Tween;
		private var showTwn: Tween;


		private var nextBtnLoader: Loader = new Loader();
		//private var nextBtn: Sprite = new Sprite();

		private var prvBtnTween: Tween;
		private var nextBtnTween: Tween;

		private var navBtnTweenType: String;
		private var navBtnsTwnDur: Number = .6;

		private var picXmlList: XMLList = new XMLList();
		private var currentPhoto: int;
		private var picTotalLen: int = 0;
		private var showTrackXmlList: XMLList = new XMLList();
		private var enableTrack: Boolean;

		private var firstPicNo: int = 0; /// display images at first time
		private var isDataNotLoaded: Boolean;

		private var objBackBtn: MovieClip = new BackBtnMC();
		private var isBackBtnXML: XMLList = new XMLList();

		//---------new var
		private var slideXmlList: XMLList = new XMLList();
		private var slideTotNo: int;
		private var galType: String = "";
		private var photoXmlList: XMLList = new XMLList();
		private var slideCntr: int;
		private var photoCntr: int;
		private var photoTotNo: int;
		private var objSlideBar: Sprite = new Sprite();
		private var slideArray: Array = new Array();
		private var photoArray: Array;
		private var slideLTween: Tween;
		private var slideRTween: Tween;
		private var slideTwnDur: Number = .8;
		private var movingCntr: int;
		private var slideImageArr: Array = new Array();
		private var slideVideoArr: Array = new Array();
		private var curAnim: String = "none";
		
		var bgShape: Shape = new Shape();


		public function PhotoContainerMC() {

			this.addEventListener(Event.ADDED_TO_STAGE, addtostage, false, 0, true);
			this.addEventListener(AppConst.EVENT_ANIM_COMP, animComp, false, 0, true);
			this.addEventListener(AppConst.EVENT_PLAY_GAL_VID, galVidPlaying, false, 0, true);

		}



		function addtostage(e: Event): void {
			this.removeEventListener(Event.ADDED_TO_STAGE, addtostage)
			addAllModules();

		}

		private function addAllModules(): void {


			bgShape.graphics.beginFill(0x000000, 1);
			bgShape.graphics.drawRect(0, 0, AppConst.SCREEN_WIDTH, AppConst.SCREEN_HEIGHT);
			bgShape.graphics.endFill();
			bgShape.x = 0;
			bgShape.y = 0;
			bgShape.visible = false;
			this.addChildAt(bgShape, 0);

			//this.addChild(objImgGalMC);
			this.addChild(objVidPlayerMC);

			this.addChild(objBackBtn);
			objBackBtn.visible = false;

		}

		public function showPhotos(pData: XMLList): void {
			isBackBtnXML = null;
			enableTrack = false;
			galXMLList = pData;
			slideXmlList = galXMLList..slide;
			slideTotNo = slideXmlList.length();
			galType = galXMLList.type;
			slideCntr = 0;
			photoCntr = 0;

			if (galXMLList.trackingurl.length() > 0)
				showTrackXmlList = galXMLList.trackingurl;

			if (galXMLList.enabletracking.length() > 0)
				enableTrack = galXMLList.enabletracking.toLowerCase() == "true";
			else
				enableTrack = false;

			isBackBtnXML = galXMLList..backbtn;
			if ((isBackBtnXML.length()) > 0) // if gallery back button exists
			{
				objBackBtn.loadGalBkImg(galXMLList..backbtn);
				objBackBtn.visible = true;
			}

			loadSlides();
			//apply mask
			var maskShape: Shape = new Shape();
			maskShape.graphics.beginFill(0xff0000, .2);
			maskShape.graphics.drawRect(0, 0, AppConst.SCREEN_WIDTH, AppConst.SCREEN_HEIGHT);
			maskShape.graphics.endFill();
			maskShape.x = 0;
			maskShape.y = 0;
			this.addChild(maskShape);
			this.mask = maskShape;

		}

		private function loadSlides(): void {
			if (slideTotNo == slideCntr) {
				showGallery();
			} else {
				photoCntr = 0;
				photoXmlList = slideXmlList[slideCntr]..photo;
				photoTotNo = photoXmlList.length() - 1;
				slideCntr++;
				loadPhotos();
			}

		}


		private function loadPhotos(): void {
			try {
				if (photoXmlList[photoCntr].@type == AppConst.AD_IMAGE_SLIDE) {
					var objPic: MovieClip = new ImgGalleryMC();
					objPic.name = "pic" + photoTotNo + "" + photoCntr;
					objPic.loadImage(photoXmlList[photoCntr].imageslide);
					slideImageArr.push(objPic);

				} else if (photoXmlList[photoCntr].@type == AppConst.AD_CLICK_THRU) {
					var objClickTh: MovieClip = new ClickthruMovie();
					objClickTh.name = "ct" + photoTotNo + "" + photoCntr;
					objClickTh.urlReq(photoXmlList[photoCntr]..clickthru);
					slideImageArr.push(objClickTh);

				} else if (photoXmlList[photoCntr].@type == AppConst.AD_VIDEO_PLAYER) {
					slideVideoArr[slideCntr - 1] = "" + photoCntr;
				} else if (photoXmlList[photoCntr].@type == AppConst.AD_YOUTUBE) {
					slideVideoArr[slideCntr - 1] = "" + photoCntr;
				}


				if (photoCntr == photoTotNo) {
					var spSlide: Sprite = new Sprite();
					spSlide.x = int(slideCntr - 1) * int(AppConst.SCREEN_WIDTH);

					for (var i: int = 0; i < slideImageArr.length; i++) {
						spSlide.addChild(MovieClip(slideImageArr[i]));
						slideArray.push(spSlide);
					}
					slideImageArr.length = 0;
					loadSlides();

				} else {

					photoCntr++;
					loadPhotos();
				}

			} catch (e: Error) {
				trace("----loadPhotos-- error:" + e.message.toString());
			}
		}



		private function showGallery(): void {
			StopAndHideAll();


			for (var j: int = 0; j < slideArray.length; j++) {
				objSlideBar.addChild(slideArray[j]);
			}

			objSlideBar.x = 0;
			objSlideBar.y = 0;
			this.addChild(objSlideBar);

			if (slideTotNo > 1)
				prvnextBtns();
			else
				prvNextEnabled();

			this.setChildIndex(objBackBtn, numChildren - 1);

		}


		public function resetGallery(): void {
			objSlideBar.x = 0;
			objSlideBar.y = 0;
			movingCntr = 0;
			curAnim = "none";

		}


		public function showContainer(picno: int): void {
			//	try {


			StopAndHideAll();
			prvNextDisabled();
			movingCntr = picno;

			if (galType == "video") {

				if (slideXmlList[picno].photo[slideVideoArr[picno]].@type == AppConst.AD_VIDEO_PLAYER) {
					bgShape.visible = true;
					objVidPlayerMC.loadnPlayVideo(slideXmlList[picno].photo[slideVideoArr[picno]].vidplayer);
					objVidPlayerMC.showPlayVideo();
					prvNextEnabled();

				} else if (slideXmlList[picno].photo[slideVideoArr[picno]].@type == AppConst.AD_YOUTUBE) {

					bgShape.visible = true;
					objYoutubePlayer = new YoutubeMC();
					this.addChildAt(objYoutubePlayer, 1);
					objYoutubePlayer.showPlayer(slideXmlList[picno].photo[slideVideoArr[picno]].youtube);
					prvNextEnabled();

				}
			} else {

				prvNextEnabled();
				bgShape.visible = false;
			}

		}

		public function StopAndHideAll(): void {
			objVidPlayerMC.hideStopVideo(); // hide video and stop for playing sound in the background
			if ((objYoutubePlayer != null) && this.contains(getChildByName(AppConst.AD_YOUTUBE))) {
				objYoutubePlayer.hidePaused();
				this.removeChild(objYoutubePlayer);
				objYoutubePlayer = null;
			}

		}

		public function hideGalleryBgImg(): void {
			//objImgGalMC.removeBgGalImgs();
		}


		public function showTrackGal(): void {
			if (enableTrack) {
				Pmi5Tracking.doShowTrack(showTrackXmlList);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(showTrackXmlList), true));
			}
		}


		function prvClick(e: Event): void {
			if (isDataNotLoaded)
				return;

			if (galType == "video") {
				movingCntr--;
				if (movingCntr < 0) {
					movingCntr = 0;
					trace("return movingcCntr=" + movingCntr);
					return;
				}

				showContainer(movingCntr);
				objSlideBar.x = (objSlideBar.x + int(AppConst.SCREEN_WIDTH));

			} else if (galType == "image") {
				if ((slideLTween != null) && (slideLTween.isPlaying))
					return;

				if (objSlideBar.x == 0) {
					objSlideBar.x = (-int(AppConst.SCREEN_WIDTH) * int(slideTotNo - 1) - int(AppConst.SCREEN_WIDTH));
					doSlideLTween();
					return;
				}
				doSlideLTween();
			}
		}


		function nextClick(e: Event): void {

			if (isDataNotLoaded)
				return;

			if (galType == "video") {
				movingCntr++;
				if (movingCntr == slideTotNo) {
					movingCntr = slideTotNo - 1;
					return;
				}
				showContainer(movingCntr);
				objSlideBar.x = (objSlideBar.x - int(AppConst.SCREEN_WIDTH));

			} else if (galType == "image") {

				if ((slideLTween != null) && (slideLTween.isPlaying))
					return;


				if (objSlideBar.x == (-int(AppConst.SCREEN_WIDTH) * int(slideTotNo - 1))) {
					objSlideBar.x = int(AppConst.SCREEN_WIDTH);
					doSlideRTween();
					return;
				}
				doSlideRTween();
			}
		}

		function doSlideLTween(): void {
			slideLTween = new Tween(objSlideBar, "x", Strong.easeOut, objSlideBar.x, (objSlideBar.x + int(AppConst.SCREEN_WIDTH)), slideTwnDur, true);
			slideLTween.addEventListener(TweenEvent.MOTION_FINISH, slideLeftFinish, false, 0, true);
			slideLTween.stop();
			slideLTween.start();
			prvNextDisabled();
		}

		function slideLeftFinish(e: TweenEvent): void {
			e.target.removeEventListener(TweenEvent.MOTION_FINISH, slideLeftFinish);
			if (slideLTween != null)
				slideLTween = null;
			prvNextEnabled();
		}

		function doSlideRTween(): void {
			slideRTween = new Tween(objSlideBar, "x", Strong.easeOut, objSlideBar.x, (objSlideBar.x - int(AppConst.SCREEN_WIDTH)), slideTwnDur, true);
			slideRTween.addEventListener(TweenEvent.MOTION_FINISH, slideRTweenFinish, false, 0, true);
			slideRTween.stop();
			slideRTween.start();
			prvNextDisabled();
		}


		function slideRTweenFinish(e: TweenEvent): void {
			slideRTween.removeEventListener(TweenEvent.MOTION_FINISH, slideRTweenFinish);
			if (slideRTween != null)
				slideRTween = null;
			prvNextEnabled();
		}



		function animComp(e: Event): void {

			if (galType == "video") {
				////trace("-- listen anim_comp --=" + curAnim + ", isDataNotLoaded=" + isDataNotLoaded);
				if (curAnim == "none") {
					//doSlideRTween();
				} else {

				}
			}
			prvNextEnabled();
		}

		function galVidPlaying(e: Event): void {

			if (galType == "video") {
				prvNextEnabled();
				
			}

		}


		function prvNextEnabled(): void {
			isDataNotLoaded = false;
			prvBtnMC.enabled = true;
			nextBtnMC.enabled = true;
		}

		function prvNextDisabled(): void {
			isDataNotLoaded = true;
			prvBtnMC.enabled = false;
			nextBtnMC.enabled = false;
		}


		function prvnextBtns(): void {
			//load previous button
			prvBtnMC.addEventListener("prvbtnloaded", prvbtnLoaded, false, 0, true);
			prvBtnMC.addEventListener(AppConst.EVENT_PREVIOUS_CLICK, prvClick, false, 0, true);

			this.addChild(prvBtnMC);
			this.setChildIndex(prvBtnMC, this.numChildren - 1);
			prvBtnMC.loadPrvBtnImg(galXMLList..navbtnleftimg);

		}


		function prvbtnLoaded(e: Event): void {
			prvBtnMC.removeEventListener("prvbtnloaded", prvbtnLoaded);
			//load next button
			nextBtnMC.addEventListener("nextbtnloaded", nextbtnLoaded, false, 0, true);
			nextBtnMC.addEventListener(AppConst.EVENT_NEXT_CLICK, nextClick, false, 0, true);
			this.addChildAt(nextBtnMC, numChildren - 1);
			nextBtnMC.loadNextBtnImg(galXMLList..navbtnrightimg);
		}

		function nextbtnLoaded(e: Event): void {
			nextBtnMC.removeEventListener("nextbtnloaded", nextbtnLoaded);
			prvBtnMC.visible = true;
			nextBtnMC.visible = true;
			prvNextEnabled();
		}

	} //class

}