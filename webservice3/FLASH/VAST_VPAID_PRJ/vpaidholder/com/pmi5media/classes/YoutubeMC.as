package com.pmi5media.classes {

	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Security;
	import flash.display.Shape;


	public class YoutubeMC extends MovieClip {

		Security.allowDomain("*");


		// This will hold the API player instance once it is initialized.
		private var player: Object;
		private var loader: Loader = new Loader();
		private var youtubeURL: String;
		private var isShowControls: Boolean;
		private var isAutoPlay: Boolean;
		private var youtubeVolume: int;

		public function YoutubeMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, added);
		}

		function added(e: Event): void {
			/* not working at local need to check online*/
			Security.allowDomain("www.youtube.com");
			Security.allowDomain("youtube.com");
			Security.allowDomain("s.ytimg.com");
			Security.allowDomain("i.ytimg.com");
			Security.loadPolicyFile("http://i.ytimg.com/crossdomain.xml");
			Security.loadPolicyFile("http://www.youtube.com/crossdomain.xml");
			Security.loadPolicyFile("http://s.ytimg.com/crossdomain.xml");
			this.name = AppConst.AD_YOUTUBE;

		}

		function loadYoutube(): void {
			try {

				//with controls
				loader.load(new URLRequest("http://www.youtube.com/v/zTK7iHUFWGc?version=3"));
				loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);

			} catch (e: Error) {
				trace("---loadYoutube youtube error");
			}

		}


		function onLoaderInit(event: Event): void {
			try {
				this.visible = true;
				addChild(loader);
				loader.content.addEventListener("onReady", onPlayerReady, false, 0, true);
				loader.content.addEventListener("onError", onPlayerError, false, 0, true);
				loader.content.addEventListener("onStateChange", onPlayerStateChange);
				loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange, false, 0, true);
			} catch (e: Error) {
				trace(" onLoaderInit youtube error=" + e.message.toString());
			}
		}

		function onPlayerReady(event: Event): void {
			try {
				loader.content.removeEventListener("onReady", onPlayerReady);

				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:2", Object(event).data);

				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				player = loader.content;
				// Set appropriate player dimensions for your application
				player.setSize(AppConst.SCREEN_WIDTH, AppConst.SCREEN_HEIGHT);
				player.loadVideoByUrl({
					'mediaContentUrl': youtubeURL,
					'suggestedQuality': 'large'
				});

				if (!isAutoPlay)
					player.stopVideo();
				player.setVolume(youtubeVolume);

			} catch (e: Error) {
				trace(" onPlayerReady youtube error=" + e.message.toString());
			}

		}

		function onPlayerError(event: Event): void {

			loader.content.removeEventListener("onError", onPlayerError);
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}

		function onPlayerStateChange(event: Event): void {
			//loader.content.removeEventListener("onStateChange", onPlayerStateChange);
			// Event.data contains the event parameter, which is the new player state
			trace("---player state:", Object(event).data);
			if (Object(event).data == 1) {
				dispatchEvent(new Event(AppConst.EVENT_PLAY_GAL_VID, true));
				trace(" youtube player is start playing");

			}

			if (Object(event).data == 0) {
				trace("video complete");
				player.stopVideo();
			}
		}

		function onVideoPlaybackQualityChange(event: Event): void {
			loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
			// Event.data contains the event parameter, which is the new video quality
			trace("video quality:", Object(event).data);
		}

		public function hidePaused(): void {
			this.visible = false;
			resetVars();

			if (player != null) {
				if (this.contains(loader)) {
					player.stopVideo();
					//player.visible=false;
					loader.content.removeEventListener("onReady", onPlayerReady);
					loader.content.removeEventListener("onError", onPlayerError);
					loader.content.removeEventListener("onStateChange", onPlayerStateChange);
					loader.content.removeEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
					this.removeChild(loader);

				}
				player.destroy();

			}
		}

		function resetVars(): void {
			isShowControls = false;
			isAutoPlay = false;
		}

		public function showPlayer(pData: XMLList): void {
			try {

				resetVars();
				trace(" ++ show youtube :" + pData.videourl);
				youtubeURL = pData.videourl;
				youtubeVolume = pData.volume;
				this.visible = true;
				isShowControls = pData.showcontrols.toLowerCase() == "true";
				isAutoPlay = pData.autoplay.toLowerCase() == "true";

				if (isShowControls) {
					//with controls
					loader.load(new URLRequest("http://www.youtube.com/v/zTK7iHUFWGc?version=3"));

				} else {
					// chromeless player
					loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
				}
				loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
				//loadYoutube();
			} catch (e: Error) {
				trace("showPlayer youtube error=" + e.message.toString());
			}
		}
	}
}