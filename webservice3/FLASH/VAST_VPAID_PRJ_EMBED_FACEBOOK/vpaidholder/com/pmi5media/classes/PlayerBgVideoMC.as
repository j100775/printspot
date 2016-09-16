package com.pmi5media.classes {

	import fl.video.*;
	import fl.video.FLVPlayback;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.display.StageDisplayState;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.accessibility.ISearchableText;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.transitions.TweenEvent;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.display.StageScaleMode;
	import flash.media.Video;



	public class PlayerBgVideoMC extends MovieClip {

		private var vidPlayer: FLVPlayback = new FLVPlayback();
		private var videoPath: String = "http://localhost/riaz/nike/video/nike.mp4";

		private var objMuteBtn: MovieClip = new MuteBtnMC();
		private var objPlayPause: MovieClip = new PlayPauseMC();
		private var objPlayBgIcon: MovieClip = new PlayBgIconMC();
		private var objPlayerRestart:MovieClip = new PlayerRestartMC();
		private var objBtnbar: MovieClip = new PlayerBtnBar();
		private var objPlayerClick: MovieClip = new PlayerVideoClick();

		private var soundOn: Boolean = true;
		private var isAutoPlay: Boolean;
		private var isVidPlaying: Boolean;
		private var showControls: Boolean;
		private var playerVolume: Number;
		private var barlen: int;

		//video
		private var totalLength: Number;
		private var firstQ: Number;
		private var secondQ: Number;
		private var thirdQ: Number;
		private var completeQ: Number;

		var objSkipAd: MovieClip = new PlayerSkipTimer();

		//video quartile
		private var quartileName: String;
		private var durationTime: String;
		private var vidTime: int;
		private var perc: Number;
		private var totalSeconds: * ;

		private var enableClick: Boolean;
		private var clickURL: String;
		private var trackingURL: XMLList;
		private var _enableTrack: Boolean;

		private var trackpointXmlList: XMLList = new XMLList();
		private var arrTP: Array = new Array();

		private var objsb: MovieClip = new PlayreSeekbar();
		private var objVolbar: MovieClip = new PlayerVolumebar();
		private var objFullScr: MovieClip = new PlayerFullScreen();
		private var objFullScrCustom:MovieClip = new PlayerFullScreenMC();
		private var objLogoVidaptiv:MovieClip = new LogoVidaptivMC();


		//countdown
		private var prvNo: int;

		private var barTimer: Timer = new Timer(1000, 3); // bar timer for hidiing after some time
		//resize
		private var isResize: Boolean;
		private var resizeDur: int;
		private var resizeCounter: int;
		private var resizeW: int;
		private var resizeH: int;
		private var resizeOffsetX: int;
		private var resizeOffsetY: int;
		private var animX: Tween;
		private var animY: Tween;
		private var animW: Tween;
		private var animH: Tween;
		
		private var isRestartWait:Boolean;
		
		private var spinner:PreloaderSpinner;

		public function PlayerBgVideoMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, addedTS, false, 0, true);
		}

		private function addedTS(e: Event): void {
			//try {

			barTimer.addEventListener(TimerEvent.TIMER_COMPLETE, barTimeComp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMove); // for showing and hiding the control bar
			this.width = AppConst.SCREEN_WIDTH;
			this.height = AppConst.SCREEN_HEIGHT;
			vidPlayer.x = 0;
			vidPlayer.y = 0;
			vidPlayer.width =AppConst.SCREEN_WIDTH;
			vidPlayer.height =AppConst.SCREEN_HEIGHT;
			vidPlayer.scaleMode = "exactFit";
			vidPlayer.addEventListener(fl.video.VideoEvent.READY, vidReady, false, 0, true);
			vidPlayer.addEventListener(MetadataEvent.METADATA_RECEIVED, timeListener);
			vidPlayer..addEventListener(MetadataEvent.CUE_POINT, cuePointHandler);
			vidPlayer.addEventListener(fl.video.VideoEvent.COMPLETE, vidComplete);
			vidPlayer.fullScreenTakeOver = false; // do not allow to take full screen takeover of the video 
			vidPlayer.visible = false;
			var vid:Video = vidPlayer.getVideoPlayer(0);
			vid.smoothing=true;
			
			addChild(vidPlayer);
			vidPlayer.stop();
			

			objPlayerClick.width = AppConst.SCREEN_WIDTH;
			objPlayerClick.height = AppConst.SCREEN_HEIGHT;
			objPlayerClick.x = 0;
			objPlayerClick.y = 0;
			addChild(objPlayerClick);

			setSoundOn();

			objPlayPause.width = AppConst.PLAY_PAUSE_BTN_W;
			objPlayPause.height = AppConst.PLAY_PAUSE_BTN_H;
			objPlayPause.addEventListener(MouseEvent.CLICK, playpauseClick);


			objMuteBtn.width = AppConst.SOUND_BTN_W;
			objMuteBtn.height = AppConst.SOUND_BTN_H;
			objMuteBtn.addEventListener(MouseEvent.CLICK,mutebtnClick);  //onFullScr

			objPlayerRestart.visible = false;
			objPlayerRestart.addEventListener(MouseEvent.CLICK,onRestart);
			this.addChild(objPlayerRestart);
			
			
			
			objPlayBgIcon.visible = false;
			objPlayBgIcon.addEventListener(MouseEvent.CLICK, playpauseClick);
			this.addChild(objPlayBgIcon);

			objBtnbar.addChild(objPlayPause);
			objBtnbar.addChild(objMuteBtn);
			
			
			//objFullScr.visible = false;
			//objFullScr.addEventListener(MouseEvent.MOUSE_DOWN, onFullScr);
			//objFullScr.x = 580;
			//objFullScr.y = 280;
			///objBtnbar.addChild(objFullScr);
			
			objFullScrCustom.addEventListener(MouseEvent.MOUSE_DOWN, onFullScr);
			objBtnbar.addChild(objFullScrCustom);
			
			
			objLogoVidaptiv.addEventListener(MouseEvent.CLICK,onLogoClick);
			objBtnbar.addChild(objLogoVidaptiv);

			objsb.addEventListener(MouseEvent.MOUSE_DOWN, onSeekBar);
			objBtnbar.addChild(objsb)

			objBtnbar.addChild(objVolbar);
			objVolbar.visible = false;
			objBtnbar.x = 0;
			this.addChild(objBtnbar);

			setPosEvents();
			barTimer.stop();
			barTimer.reset();
			
			spinner = new PreloaderSpinner(192, 192);
			spinner.setColors(0x000762C5, 0xFF0762C5);
			spinner.bgAlpha = 0.2;

			//load and show spinner
			spinner.x = (AppConst.SCREEN_WIDTH / 2) ;
			spinner.y = (AppConst.SCREEN_HEIGHT / 2) ;
			this.addChild(spinner);
		}

		function setPosEvents(): void {

			objBtnbar.addEventListener(MouseEvent.MOUSE_OUT, onBtnBarOut); // start time for hiding the control bar	

			objBtnbar.addEventListener(MouseEvent.MOUSE_MOVE, showFixBar);

			objPlayPause.addEventListener(MouseEvent.MOUSE_MOVE, showFixBar);
			objPlayPause.addEventListener(MouseEvent.MOUSE_OVER, showFixBar);

			objsb.addEventListener(MouseEvent.MOUSE_MOVE, showFixBar);
			objsb.addEventListener(MouseEvent.MOUSE_OVER, showFixBar);

			objMuteBtn.addEventListener(MouseEvent.MOUSE_MOVE, showFixBar);
			objMuteBtn.addEventListener(MouseEvent.MOUSE_OVER, showFixBar);

			objVolbar.addEventListener(MouseEvent.MOUSE_MOVE, showFixBar);
			objVolbar.addEventListener(MouseEvent.MOUSE_OVER, showFixBar);



			objBtnbar.x = (AppConst.SCREEN_WIDTH / 2) - (objBtnbar.width * .53);
			objBtnbar.y = (AppConst.SCREEN_HEIGHT) - (objBtnbar.height * 1.10);

			objPlayPause.x = 20// - (objPlayPause.width * .10);
			objPlayPause.y = objBtnbar.height / 2 - objPlayPause.height / 2;

			objsb.x = objPlayPause.x + (objPlayPause.width * 1.10);
			objsb.y = objBtnbar.height / 2 - objsb.height / 2;

			objMuteBtn.x = objsb.width + (objMuteBtn.width * 1.44);
			objMuteBtn.y = objBtnbar.height / 2 - objMuteBtn.height / 2;

			objVolbar.x = objMuteBtn.x + (objMuteBtn.width * 1.20);
			objVolbar.y = objBtnbar.height / 2 - (objVolbar.height * .60);
			
			objFullScrCustom.x = objVolbar.x + (objVolbar.width * 1.10);
			objFullScrCustom.y = objBtnbar.height/2 - (objFullScrCustom.height * .50);
			
			objLogoVidaptiv.x = objFullScrCustom.x + (objFullScrCustom.width*1.05);
			objLogoVidaptiv.y = objBtnbar.height/2 - (objLogoVidaptiv.height*.50);

		}

		function onBtnBarOut(e: MouseEvent): void {
			barShowStart();
		}

		function showFixBar(e: MouseEvent): void {
			showBtnBar();
		}

		function barTimeComp(e: TimerEvent): void {
			hideBtnBar();
		}

		function showBtnBar(): void {
			barTimerReset();
			objBtnbar.visible = true;
		}
		function hideBtnBar(): void {
			barTimerReset();
			objBtnbar.visible = false;
		}

		function barTimerReset(): void {
			barTimer.stop();
			barTimer.reset();
		}

		function onMove(e: MouseEvent): void {
			barShowStart();
		}

		function onSeekBar(evt: MouseEvent): void {
			//objsb.stopDrag();  //for stop dragging of seekbar pointer
		}

		function barShowStart(): void {
				
			if(isRestartWait) return;
			if (showControls) {
				showBtnBar();
				barTimer.start();
			}
		}

		function onFullScr(evt: MouseEvent): void {

			setUnsetFullScreen();

		}
		
		function onLogoClick(e:MouseEvent):void{
			navigateToURL(new URLRequest("http://www.vidaptiv.com"));
		}
		
		public function setUnsetFullScreen():void
		{
			try
			{
				if (this.stage.displayState == StageDisplayState.FULL_SCREEN) {
					this.stage.displayState = StageDisplayState.NORMAL;
						objFullScrCustom.gotoAndStop(1);
						dispatchEvent(new Event(AppConst.EVENT_NORMAL,true));
					} else {
						
						this.stage.displayState = StageDisplayState.FULL_SCREEN;
						objFullScrCustom.gotoAndStop(2);
						this.width = Capabilities.screenResolutionX;
						this.scaleY = this.scaleY;
						dispatchEvent(new Event(AppConst.EVENT_FULL_SCREEN,true));
					}
			}catch(e:Error){
					//dispatchEvent(new Event(AppConst.EVENT_NORMAL,true));
			}
		}
		
		public function setNormalIcon():void
		{
					objFullScrCustom.gotoAndStop(1);
		}
		
		
		public function setStage():void
		{

			resetScreen();
		}
		public function loadnPlayVideo(pXml: XMLList): void {
			try {

				resetVarData();
				videoPath = pXml.vidpath;
				showControls = pXml.showcontrols.toLowerCase() == "true";
				isAutoPlay = true;
				playerVolume = pXml.volume / 100;

				resetScreen();
				vidPlayer.source = videoPath;

				enableClick = pXml.enableclick.toLowerCase() == "true";
				clickURL = pXml.clickurl;
				trackingURL = pXml.trackingurl;

				if (pXml.enabletracking.length() > 0)
					_enableTrack = pXml.enabletracking.toLowerCase() == "true";

				if (enableClick) {
					objPlayerClick.addEventListener(MouseEvent.CLICK, onClick);
					objPlayerClick.buttonMode = true;
				}

				if (pXml.seekbartracking.length() > 0) {

					trackpointXmlList = pXml.seekbartracking.trackingurl;
				}


				barlen = pXml.btnbaroffsetx.length();
				//resize
				if (pXml.isresize.length() > 0) {
					isResize = pXml.isresize.toLowerCase() == "true";
					resizeDur = pXml.resizeduration;
					resizeH = int(pXml.resizeheight)*AppConst.MULTIPLIER;
					resizeW = int(pXml.resizewidth)*AppConst.MULTIPLIER;
					resizeOffsetX = int(pXml.resizeoffsetx)*AppConst.MULTIPLIER;
					resizeOffsetY = int(pXml.resizeoffsety)*AppConst.MULTIPLIER;
				}

				hideStopVideo();
				this.setChildIndex(spinner, numChildren - 1);
				showSpinner();	
				
			} catch (e: Error) {
				trace("video playing error" + e.message.toString());
			}
		}

		function showSpinner(): void {
			spinner.visible = true;
			spinner.startSpinner();
		}

		function hideSpinner(): void {
			spinner.visible = false;
			spinner.stopSpinner();
		}
		
		public function skipData2(data: XMLList): void {
			//objPlayerVideo.addChild(objSkipAd);
			//objSkipAd.loadSkipData(data);
			//objSkipAd.setSkipTimer();
		}

		public function doResize(): void {
			//trace("\n resize counter = " + resizeCounter + " resizeDur=" + resizeDur + " isResize=" + isResize);
			if (!isResize) return;
			resizeCounter++;
			//trace("\n resize counter = " + resizeCounter + " resizeDur=" + resizeDur);

			if (resizeCounter == resizeDur) {
				animResize();
			}
		}

		public function resetRC(): void {
			resizeCounter = 0;
			/*this.width = AppConst.SCREEN_WIDTH;
			this.height = AppConst.SCREEN_HEIGHT;
			vidPlayer.width=AppConst.SCREEN_WIDTH;
			vidPlayer.height = AppConst.SCREEN_HEIGHT;
			this.x = 0;
			this.y = 0;*/
		}

		function resetScreen():void
		{
			this.width = AppConst.SCREEN_WIDTH;
			this.height = AppConst.SCREEN_HEIGHT;
			//vidPlayer.width=AppConst.SCREEN_WIDTH;
			//vidPlayer.height = AppConst.SCREEN_HEIGHT;
			//this.x = 0;
			//this.y = 0;	
				if (this.stage.displayState == StageDisplayState.FULL_SCREEN) {
						objFullScrCustom.gotoAndStop(1);
					} else {
						objFullScrCustom.gotoAndStop(2);
					}
		}
		
		
		function animResize(): void {

			animX = new Tween(this, "x", Strong.easeOut, this.x, resizeOffsetX, 1.5, true);
			animX.addEventListener(TweenEvent.MOTION_FINISH, xFinish, false, 0, true);

			animY = new Tween(this, "y", Strong.easeOut, this.y, resizeOffsetY, 1.5, true);
			animY.addEventListener(TweenEvent.MOTION_FINISH, yFinish, false, 0, true);

			animW = new Tween(this, "width", Strong.easeOut, this.width, resizeW, 1.5, true);
			animW.addEventListener(TweenEvent.MOTION_FINISH, wFinish, false, 0, true);

			animH = new Tween(this, "height", Strong.easeOut, this.height, resizeH, 1.5, true);
			animH.addEventListener(TweenEvent.MOTION_FINISH, hFinish, false, 0, true);

			animW.stop();
			animW.start();

			animH.stop();
			animH.start();

			animX.stop();
			animX.start();

			animY.stop();
			animY.start();
		}

		private function xFinish(e: TweenEvent): void {
			animX.removeEventListener(TweenEvent.MOTION_FINISH, xFinish);
			animX = null;

		}

		private function yFinish(e: TweenEvent): void {
			animY.removeEventListener(TweenEvent.MOTION_FINISH, yFinish);
			animY = null;

		}

		private function wFinish(e: TweenEvent): void {
			animW.removeEventListener(TweenEvent.MOTION_FINISH, wFinish);
			animW = null;

		}

		private function hFinish(e: TweenEvent): void {
			animH.removeEventListener(TweenEvent.MOTION_FINISH, hFinish);
			animH = null;

		}

	
		private function resetRestartProp():void
		{
			resetVarData();
			vidPlayer.seek(0);	
			vidPlayer.stop();
			vidPlayer.visible=false;
			
			isVidPlaying = false;
			objPlayerRestart.visible=true;
			isRestartWait=true;
			hideBtnBar();
			resetScreen();
			
		}
		
		public function restartVideo():void
		{
			/*this.width = AppConst.SCREEN_WIDTH;
			this.height = AppConst.SCREEN_HEIGHT;
			vidPlayer.width=AppConst.SCREEN_WIDTH;
			vidPlayer.height = AppConst.SCREEN_HEIGHT;
			this.x = 0;
			this.y = 0;*/
			
			resetRestartProp();
			
			vidPlayer.play();
			isVidPlaying=true;
			objPlayerRestart.visible=false;
			objPlayBgIcon.visible = false;
			vidPlayer.visible=true;
			isRestartWait=false;
			durationTime = String(Math.floor(totalSeconds));
			

			prvNo = Math.floor((totalSeconds) - (vidPlayer.playheadTime)); // init no 
			objSkipAd.setSkipTimerDur();
			
			dispatchEvent(new PlayerVideoEvent(PlayerVideoEvent.VIDEO_DUR, durationTime, true));

			stage.addEventListener(Event.ENTER_FRAME, updateTime2);
			function updateTime2(event: Event): void {
				var elapsedSeconds = String(Math.floor(vidPlayer.playheadTime));
				var runTime: String = (elapsedSeconds);

				//trace("restart totalSeconds"+totalSeconds + " vidPlayer.playheadTime=" + vidPlayer.playheadTime);
				vidTime = Math.floor((totalSeconds) - (vidPlayer.playheadTime));
				
				if (vidTime < 1) {
					stage.removeEventListener(Event.ENTER_FRAME, updateTime2);
					

				} else {
						//trace("restart vidTime"+vidTime + " prvNo=" + prvNo);
						if (vidTime < prvNo) {
						dispatchEvent(new PlayerVideoEvent(PlayerVideoEvent.VIDEO_DUR, String(vidTime), true));
						prvNo = vidTime;
					}
				}
			}
		}

		private function timeListener(eventObject: MetadataEvent): void {

			totalSeconds = String(eventObject.info.duration);
			totalLength = Number(Math.floor(totalSeconds));

			durationTime = String(Math.floor(totalSeconds));
			firstQ = Math.floor(totalLength * .25);
			secondQ = Math.floor(totalLength * .50);
			thirdQ = Math.floor(totalLength * .75);

			vidPlayer.addASCuePoint(firstQ, AppConst.EVENT_I_QUARTILE);
			vidPlayer.addASCuePoint(secondQ, AppConst.EVENT_II_QUARTILE);
			vidPlayer.addASCuePoint(thirdQ, AppConst.EVENT_III_QUARTILE);
			vidPlayer.addASCuePoint(totalLength, AppConst.EVENT_IV_QUARTILE);

			//add custom que points	
			arrTP.length = 0;
			for (var i: int = 0; i < trackpointXmlList.length(); i++) {
				vidPlayer.addASCuePoint(trackpointXmlList[i].@timeval, "" + i);
				arrTP.push("" + i);
			}


			prvNo = Math.floor((eventObject.info.duration) - (vidPlayer.playheadTime)); // init no 
			
			objSkipAd.setSkipTimerDur();
			
			dispatchEvent(new PlayerVideoEvent(PlayerVideoEvent.VIDEO_DUR, durationTime, true));

			stage.addEventListener(Event.ENTER_FRAME, updateTime2);
			function updateTime2(event: Event): void {
				var elapsedSeconds = String(Math.floor(vidPlayer.playheadTime));
				var runTime: String = (elapsedSeconds);

				//trace("totalSeconds"+totalSeconds + " vidPlayer.playheadTime=" + vidPlayer.playheadTime);
				vidTime = Math.floor((eventObject.info.duration) - (vidPlayer.playheadTime));
				
				if (vidTime < 1) {
					stage.removeEventListener(Event.ENTER_FRAME, updateTime2);
					

				} else {

					//trace("vidTime"+vidTime + " prvNo=" + prvNo);
					if (vidTime < prvNo) {
						dispatchEvent(new PlayerVideoEvent(PlayerVideoEvent.VIDEO_DUR, String(vidTime), true));
						prvNo = vidTime;
					}
				}
			}

		}

		// Add cue point handler code
		function cuePointHandler(evet: MetadataEvent): void {
			quartileName = "";
			quartileName = evet.info.name.toLowerCase();
			//trace("CuePoint - quartileName" + quartileName);
			switch (quartileName) {
				case AppConst.EVENT_I_QUARTILE:
					dispatchEvent(new Event(AppConst.EVENT_I_QUARTILE, true));
					break;

				case AppConst.EVENT_II_QUARTILE:
					dispatchEvent(new Event(AppConst.EVENT_II_QUARTILE, true));
					break;

				case AppConst.EVENT_III_QUARTILE:
					dispatchEvent(new Event(AppConst.EVENT_III_QUARTILE, true));
					break;

			}


			for (var k: int = 0; k < arrTP.length; k++) {
				if (arrTP[k] == quartileName) {
					Pmi5Tracking.doTrack(XMLList(trackpointXmlList[k]));
					dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(XMLList(trackpointXmlList[k])), true));
				}
			}


		}
		
		function onRestart(e:MouseEvent):void
		{
			trace("-restart video-");
			restartVideo();
			dispatchEvent(new Event(AppConst.EVENT_RESTART,true));
		}

		function playpauseClick(e: MouseEvent): void {
			playPause(); 
		}

		public function playPause(): void {
			if (isVidPlaying) {
				pauseVid();
				dispatchEvent(new Event(AppConst.EVENT_PLR_PAUSE, true));
			} else {
				playVid();
				dispatchEvent(new Event(AppConst.EVENT_PLR_RESUME, true));
			}

		}

		public function pauseVid(): void {
			vidPlayer.pause();
			objPlayerClick.visible = false;
			isVidPlaying = false;
			setVidProp();
		}

		public function playVid(): void {

			vidPlayer.play();
			objPlayPause.gotoAndStop(2);
			objPlayBgIcon.visible = false;
			objPlayerClick.visible = true;
			vidPlayer.visible=true;
			isVidPlaying = true;
			objPlayerRestart.visible=false;
		}

		function stopVid(): void {
			vidPlayer.stop();
			setVidProp();

		}

		function setVidProp(): void {
			isVidPlaying = false;
			objPlayPause.gotoAndStop(1);
			objPlayBgIcon.visible = true;
			objPlayerRestart.visible=false;

		}

		function mutebtnClick(e: MouseEvent): void {
			/*if (soundOn) {
				vidPlayer.volume = 0;
				objMuteBtn.gotoAndStop(2);
				soundOn = false;
				dispatchEvent(new Event(AppConst.EVENT_MUTE, true));
			} else {
				setSoundOn();
				dispatchEvent(new Event(AppConst.EVENT_UNMUTE, true));
			}*/
			doMute();
		}
		
		public function doMute():void
		{
			if (soundOn) {
				/*vidPlayer.volume = 0;
				objMuteBtn.gotoAndStop(2);
				soundOn = false;
				dispatchEvent(new Event(AppConst.EVENT_MUTE, true));*/
				soundoff();
			} else {
				soundon();
			}
		}

		
		public function soundoff():void
		{
				vidPlayer.volume = 0;
				objMuteBtn.gotoAndStop(2);
				soundOn = false;
				dispatchEvent(new Event(AppConst.EVENT_MUTE, true));
		}
		
		public function soundon():void
		{
				setSoundOn();
				dispatchEvent(new Event(AppConst.EVENT_UNMUTE, true));
		}


		function vidReady(e: fl.video.VideoEvent): void {
			//vidPlayer.fullScreenButton = objFullScr.vidfullscreen;
			vidPlayer.seekBar = objsb.vidseekbar;
			vidPlayer.volumeBar = objVolbar.vidvolumebar;
			objVolbar.visible = true;
			hideSpinner();		
			
			barTimer.stop();
			barTimer.reset();
			barTimer.start();

		}



		function vidComplete(e: fl.video.VideoEvent): void {
			
			
			dispatchEvent(new Event(AppConst.EVENT_IV_QUARTILE, true));
			dispatchEvent(new PlayerVideoEvent(PlayerVideoEvent.VIDEO_DUR, String(vidTime), true)); // for hiding the timer on video complete
			//hideStopVideo();
			resetRestartProp();
		}

		function resetVarData(): void {
			//showControls = false;
			//isAutoPlay = false;
			resetRC();
			
		}


		function showHideControls(): void {
			if (showControls) {
				objBtnbar.visible = true;
			} else {
				objBtnbar.visible = false;
			}

		}
		
		
		public function showControlBar():void
		{
			showControls=true;
			showHideControls();
		}		
		
			
			public function hideControlBar():void
			{
				showControls=false;
				showHideControls();
			}

		public function totalDuration():String
			{
				return String(Math.floor(totalSeconds));
			}
			
		function setSoundOn(): void {
			vidPlayer.volume = playerVolume;
			soundOn = true;
			objMuteBtn.gotoAndStop(1);

		}

		public function hideStopVideo(): void {
			try {
				vidPlayer.volume = 0;
				vidPlayer.stop();
				vidPlayer.seek(0);
				vidPlayer.visible = false;
				objBtnbar.visible = false;
				objPlayBgIcon.visible = false;
			} catch (e: Error) {
				trace("video stopping error");
			}
		}

		/*public function switchToNL(): void {
			hideStopVideo();
			this.visible = false;
		}*/


		public function showPlayVideo(): void {
			try {
				trace("showPlayVideo");
				vidPlayer.stop();
				vidPlayer.seek(0);
				vidPlayer.visible = true;
				setSoundOn();
				showHideControls();
				if (isAutoPlay) {
					vidPlayer.play();
					isVidPlaying = true;
					objPlayPause.gotoAndStop(2);
				} else {
					stopVid();
				}

				this.dispatchEvent(new Event(AppConst.EVENT_ANIM_COMP, true));
			} catch (e: Error) {
				trace("video playing error");
			}
		}

		function onClick(e: MouseEvent): void {
			navigateToURL(new URLRequest(clickURL));
			if (_enableTrack) {
				Pmi5Tracking.doTrack(trackingURL);
				dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA, Pmi5Tracking.getJSTrackData(trackingURL), true));
			}

		}

	} //class

} //pkg