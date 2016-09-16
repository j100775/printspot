package com.pmi5media.classes {

	import fl.video.*;
	import fl.video.FLVPlayback;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Shape;
	import flash.media.Video;


	public class VidPlayerMC extends MovieClip {

		private var vidPlayer: FLVPlayback = new FLVPlayback();
		private var videoPath: String = "";

		private var objMuteBtn: MovieClip = new MuteBtnMC();
		private var objPlayPause: MovieClip = new PlayPauseMC();
		private var objPlayBgIcon: MovieClip = new PlayBgIconMC();
		private var objBtnbar: MovieClip = new MovieClip();

		private var soundOn: Boolean = true;
		private var isAutoPlay: Boolean;
		private var isVidPlaying: Boolean;
		private var showControls: Boolean;
		private var playerVolume: Number;
		private var barlen: int;

		private var spinner: PreloaderSpinner;
		private var vidTime: int;
		//countdown
		private var prvNo: int;


		public function VidPlayerMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedTS, false, 0, true);
		}

		private function addedTS(e: Event): void {
			try {
				this.width = AppConst.SCREEN_WIDTH;
				this.height = AppConst.SCREEN_HEIGHT;

				vidPlayer.x = 0;
				vidPlayer.y = 0;
				vidPlayer.width = AppConst.SCREEN_WIDTH;
				vidPlayer.height = AppConst.SCREEN_HEIGHT;
				vidPlayer.scaleMode = "exactFit";
				vidPlayer.addEventListener(fl.video.VideoEvent.READY, vidReady, false, 0, true);
				vidPlayer.addEventListener(fl.video.VideoEvent.COMPLETE, vidComplete);
				vidPlayer.visible = false;
				vidPlayer.fullScreenTakeOver=false;
				
				
				addChild(vidPlayer);
				var vid:Video = vidPlayer.getVideoPlayer(0);
				vid.smoothing=true;
				vidPlayer.stop();

				//setSoundOn();


				//spinner = new PreloaderSpinner(150, 150);
				//spinner.setColors(0x000762C5, 0xFF0762C5);
				//spinner.bgAlpha = 0.8;

				//load and show spinner
				//spinner.x = this.width / 2;
				//spinner.y = this.height / 2;

				//this.addChild(spinner);				


				objPlayPause.x = 0;
				objPlayPause.width = 64;
				objPlayPause.height = 64;
				objPlayPause.y = 0;
				objPlayPause.addEventListener(MouseEvent.CLICK, playpauseClick);


				objMuteBtn.width = 64;
				objMuteBtn.height = 64;
				objMuteBtn.x = objPlayPause.width;
				objMuteBtn.y = 0;
				objMuteBtn.addEventListener(MouseEvent.CLICK, mutebtnClick);

				objPlayBgIcon.visible = false;
				objPlayBgIcon.addEventListener(MouseEvent.CLICK, playpauseClick);
				this.addChild(objPlayBgIcon);

				var bgShape2: Shape = new Shape();
				bgShape2.graphics.beginFill(0x000000, .4);
				bgShape2.graphics.drawRect(0, 0, 128, 64);
				bgShape2.graphics.endFill();

				objBtnbar.addChild(bgShape2);

				objBtnbar.addChild(objPlayPause);
				objBtnbar.addChild(objMuteBtn);
				this.addChild(objBtnbar);
			} catch (e: Error) {
				trace("video addeing error");
			}
		}

		private function vidTimeListener(eventObject: MetadataEvent): void {


			prvNo = Math.floor((eventObject.info.duration) - (vidPlayer.playheadTime)); // init no 
			stage.addEventListener(Event.ENTER_FRAME, updateTime2);

			function updateTime2(event: Event): void {
				if (int(Math.floor(vidPlayer.playheadTime)) > 0) {
					stage.removeEventListener(Event.ENTER_FRAME, updateTime2);
				}

			}

		}

		function doEvt(): void {
			this.dispatchEvent(new Event(AppConst.EVENT_PLAY_GAL_VID, true));
			//hideSpinner();
			vidPlayer.visible = true;
		}

		function showSpinner(): void {
			spinner.visible = true;
			spinner.startSpinner();
		}

		function hideSpinner(): void {
			spinner.visible = false;
			spinner.stopSpinner();
		}

		function playpauseClick(e: MouseEvent): void {
			if (isVidPlaying) {
				vidPlayer.pause();
				objPlayPause.gotoAndStop(1);
				objPlayBgIcon.visible = true;
				isVidPlaying = false;
			} else {
				vidPlayer.play();
				objPlayPause.gotoAndStop(2);
				objPlayBgIcon.visible = false;
				isVidPlaying = true;
				setSoundOn();
				
			}


		}

		function mutebtnClick(e: MouseEvent): void {
			if (soundOn) {
				vidPlayer.volume = 0;
				objMuteBtn.gotoAndStop(2);
				soundOn = false;
			} else {
				setSoundOn();
			}
		}



		function vidReady(e: fl.video.VideoEvent): void {
			showPlayVideo();
			doEvt();

		}

		function vidComplete(e: fl.video.VideoEvent): void {
			vidPlayer.seek(0);
			doEvt();
		}

		function resetVarData(): void {
			showControls = false;
			isAutoPlay = false;
		}


		public function loadnPlayVideo(pXml: XMLList): void {
			try {

				resetVarData();
				//showSpinner();

				videoPath = pXml.vidpath;
				showControls = pXml.showcontrols.toLowerCase() == "true";
				isAutoPlay = pXml.autoplay.toLowerCase() == "true";
				playerVolume = pXml.volume / 100;

				//vidPlayer.width = AppConst.SCREEN_WIDTH; //  pXml.vidwidth;
				//vidPlayer.height = AppConst.SCREEN_HEIGHT; // pXml.vidheight;
				vidPlayer.x = 0; //  pXml.offsetx;
				vidPlayer.y = 0; //   pXml.offsety;
				vidPlayer.source = videoPath;

				barlen = pXml.btnbaroffsetx.length();
				if (barlen > 0) {
					objBtnbar.x = int(pXml.btnbaroffsetx)*AppConst.MULTIPLIER;
					objBtnbar.y = int(pXml.btnbaroffsety)*AppConst.MULTIPLIER;
				} else {
					objBtnbar.x = 0;
					objBtnbar.y = AppConst.SCREEN_HEIGHT - objPlayPause.height;
				}

			} catch (e: Error) {
				trace("video playing error- " + e.message.toString());
			}
		}

		public function showPlayVideo(): void {
			try {
				vidPlayer.stop();
				vidPlayer.seek(0);
				setSoundOn();
				showHideControls();
				if (isAutoPlay) {
					vidPlayer.play();
					isVidPlaying = true;
					objPlayPause.gotoAndStop(2);
					objPlayBgIcon.visible = false;
				} else {
					vidPlayer.stop();
					isVidPlaying = false;
					objPlayPause.gotoAndStop(1);
					objPlayBgIcon.visible = true;
					vidPlayer.volume = 0;
					objMuteBtn.gotoAndStop(2);
					soundOn = false;
				}

				vidPlayer.visible = true;
				doEvt();
				////hideSpinner();

			} catch (e: Error) {
				trace("video playing error");
			}
		}


		function showHideControls(): void {
			if (showControls) {
				objBtnbar.visible = true;
			} else {
				objBtnbar.visible = false;
			}
		}

		function setSoundOn(): void {
			vidPlayer.volume = playerVolume;
			soundOn = true;
			objMuteBtn.gotoAndStop(1);

		}
		public function hideStopVideo(): void {
			try {
				vidPlayer.visible = false;
				vidPlayer.volume = 0;
				vidPlayer.stop();
				vidPlayer.seek(0);

				objBtnbar.visible = false;
				objPlayBgIcon.visible = false;
				////hideSpinner();
			} catch (e: Error) {
				trace("video stopping error");
			}
		}
	}

}