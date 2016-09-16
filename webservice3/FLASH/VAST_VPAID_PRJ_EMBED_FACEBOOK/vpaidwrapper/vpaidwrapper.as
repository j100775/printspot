package {

	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.external.ExternalInterface;
	import flash.display.LoaderInfo;
	import flash.text.TextFormat;
	import flash.net.URLLoader;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.display.Shape;
	
	
	public class vpaidwrapper extends Sprite implements IVPAID {

		
		private var playerVol:Number=0;
		
		protected var timerAdStart: Timer;

		// timer for deciding when the ad should end
		protected var timer: Timer;

		
		
		// the ad duration  
		protected var adDuration: Number;
		private var adRemainDuration: Number;

		// track how much time is left
		protected var timeRemaining: Number;

		// the width of the ad area as passed in to initAd()
		protected var initWidth: Number;

		// the height of the ad area as passed in to initAd()
		protected var initHeight: Number;

		// the view mode for the ad as passed in to initAd() or resizeAd()
		private var viewMode: String;


		// whether or not the ad is linear. default is false (non-linear).
		// change this variable value to adjust the ad type for testing.
		protected var isLinearAd: Boolean;

		// VPAID version of this ad
		private static const VPAID_VERSION: String = "1.0";

		protected var isAdExpanded: Boolean;
		
		protected var adSkippableState:Boolean;

		private var pmi5adLoader: Loader = new Loader();
		private var loaderContext: LoaderContext = new LoaderContext();
		private var pmi5adMC: MovieClip;

		private var xmlData: XML = new XML();

		private var xmlDataParams:XML = new XML();
		private var loadFromParams:Boolean;
		
		private var xmlCampaignList: XMLList = new XMLList();
		private var debugText: TextField = new TextField(); // for debugging
		private var xmlLoader: URLLoader = new URLLoader();
		private var fullPath: String;
		private var swfFileName: String;
		private var showDebugger: Boolean;
		private var stopCounter: Boolean;
		private var isLinearServed: Boolean;
		private var switchToNonlin:Boolean;
		private var isBgVideoHide:Boolean;


		private var counterTime: Timer;
		private var showCounter: Boolean;
		private var showCounterTField: TextField = new TextField();
		private var showCounterTFormat: TextFormat = new TextFormat();
		private var counterXpos: int;
		private var counterYpos: int;
		
		
		private var urlPath = loaderInfo.loaderURL;


		var allParams: * ;
		var xmlPath: String;

		var txtTrace: TextField = new TextField();
		var debugTxtFormat: TextFormat = new TextFormat();

		private const maxSwfWidth: int = 640;
		private const maxSwfHeight: int = 360;

		private var adCustomWidth: int;
		private var adCustomHeight: int;
		
		private var jsReady:Boolean;
		private var jstagSend:Boolean;
		private var arrJsData:Array = new Array();
		private var arrCustEvent:Array = new Array();

		//video quartile
		var firstQuartileName: String = "firstquartile";
		var secondQuartilName: String = "secondquartile";
		var thirdQuartileName: String = "thirdquartile";
		var forthQuartileName: String = "forthquartile";

		public function vpaidwrapper() {
			super();

			Security.allowDomain("*");
			// ignore mouse events here and instead have Ad handle them 
			mouseEnabled = false;

			this.addEventListener("oncollapsead", colAd); //for collapse ad
			this.addEventListener("onexpandad", expAd); //for expand ad
			this.addEventListener("eventplayerbgvideo", onPlayerBgVideo); // for player bg video 


			this.addEventListener("ppause",onPPause,false,0,true);
			this.addEventListener("presume",onPResume,false,0,true);
			this.addEventListener("mute",onPlayerMute,false,0,true);
			this.addEventListener("unmute",onPlayerUnmute,false,0,true);
			
			
			this.addEventListener("eventplayplayer", playPlayer,false,0,true);//for collapse ad
			this.addEventListener("eventstopplayer", stopPlayer,false,0,true); //for expand ad
			this.addEventListener("eventadremove", removeAllAd, false, 0, true);
			this.addEventListener("skipad",onSkipad,false,0,true);

			
			

			//event listener for video quartile
			this.addEventListener(firstQuartileName, firstQuarComplete, false, 0, true);
			this.addEventListener(secondQuartilName, secondQuarComplete, false, 0, true);
			this.addEventListener(thirdQuartileName, thirdQuarComplete, false, 0, true);
			this.addEventListener(forthQuartileName, forthQuarComplete, false, 0, true);

			//event listener for img click
			this.addEventListener("campaignclick", campClickHandler);

			//event listener for cross btn
			this.addEventListener("crossclick", onAdUClosed, false, 0, true);

			this.allParams = this.loaderInfo.parameters;
			this.xmlPath = this.loaderInfo.parameters.xmlurl; // reading path from url
		}

		
		function onJSTracking(evt:*):void
		{
					
			SplitJSdata(evt.data.toString());
			
		}
		
		function SplitJSdata(evt:*):void
		{
			arrJsData.length=0;
			arrJsData = evt.split(",");
			//pmi5Trace(" [0]="+ arrJsData[0] + " [1]=" + arrJsData[1]);
			sendAnalytics(arrJsData[0],arrJsData[1]);
			
		}
		
		public function initAd(initWidth: Number, initHeight: Number, viewMode: String, desiredBitrate: Number,
			creativeData: String, environmentVars: String): void {
				
			// Uncomment the below if you'd like to use the <Duration> element in VAST to dynamically
			// set the duration of your VPAID ad.
			//pmi5Trace(" initAd==creDATA=" + creativeData + " Len="+ creativeData.length +  " enV=" +environmentVars );
			this.initWidth = initWidth;	
			this.initHeight = initHeight;
			this.viewMode = viewMode;
				log("pmiLog=InitAd() W=" + this.initWidth + ",H="+this.initHeight + ",viewMode="+this.viewMode);
				
			if(creativeData!=null && creativeData!="")
			{
				xmlDataParams = XML(creativeData);
				loadFromParams=true;
			}
			else
			{
				loadFromParams=false;
			}
			loadAd();
		}

		/**
		 * Load the needed libraries and an ad.
		 */
		protected function loadAd(): void {
			if(loadFromParams)
			{
				pmi5Trace("DATA LOADED FROM <AdParameters> vast Tag");
				xmlDataFromParams();
			}
			else
			{
			 
				pmi5Trace("DATA LOADED FROM XML");
				loadXMlData();	
			}
			
			 
			
		}

		function xmlDataFromParams(): void {
			
			isLinearServed = false;
			isBgVideoHide=false;
			fullPath="";
			swfFileName="";
			xmlData = xmlDataParams;
			xmlCampaignList = xmlData.campaign;
			fullPath = xmlCampaignList.livepath;
			this.isLinearServed = xmlCampaignList.islinearad.toLowerCase() == "true";
			this.showDebugger = xmlCampaignList.showdebugger.toLowerCase() == "true";
			this.switchToNonlin =xmlCampaignList.switchtononlinear.toLowerCase() == "true";

			this.showCounter = xmlCampaignList.showcounter.toLowerCase() == "true";
			this.stopCounter = xmlCampaignList.stopcounter.toLowerCase() == "true";
			this.counterXpos = xmlCampaignList.counteroffsetx;
			this.counterYpos = xmlCampaignList.counteroffsety;

			swfFileName = xmlCampaignList.swffile;
			pmi5Trace("From AdParameters isLinearServed=" + isLinearServed);
			pmi5Trace(" xml=" + xmlCampaignList.islinearad.toLowerCase());
			injectJS();  // write javascript files in browser
			loadswf();

		}
		
		function xmlDataLoaded(evt: Event): void {
			
			isLinearServed = false;
			isBgVideoHide=false;
			fullPath="";
			swfFileName="";
		

			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataLoaded);

			xmlData = XML(evt.currentTarget.data);
			xmlCampaignList = xmlData.campaign;
			fullPath = xmlCampaignList.livepath;
			this.isLinearServed = xmlCampaignList.islinearad.toLowerCase() == "true";
			this.showDebugger = xmlCampaignList.showdebugger.toLowerCase() == "true";
			this.switchToNonlin =xmlCampaignList.switchtononlinear.toLowerCase() == "true";

			this.showCounter = xmlCampaignList.showcounter.toLowerCase() == "true";
			this.stopCounter = xmlCampaignList.stopcounter.toLowerCase() == "true";
			this.counterXpos = xmlCampaignList.counteroffsetx;
			this.counterYpos = xmlCampaignList.counteroffsety;

			swfFileName = xmlCampaignList.swffile;
			pmi5Trace(" isLinearServed=" + isLinearServed);
			injectJS();
			loadswf();

		}
		
		function loadXMlData(): void {
			//load xml data
			
			xmlLoader.load(new URLRequest(this.xmlPath));
			xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, xmlDataError, false, 0, true);
			xmlLoader.addEventListener(Event.COMPLETE, xmlDataLoaded, false, 0, true);
		}

		

		function injectJS(): void {
				var js3: Array = [
				'var script3 = document.createElement("SCRIPT")',
				'script3.src = "http://dev.pmi5media.com/repoadmin2/js/vidaptivplayer.js"',
				'var head3 = document.getElementsByTagName("script")[0]',

				'head3.parentNode.insertBefore(script3,head3)'
			];
			ExternalInterface.call('(function(){' + js3.join(';') + '})()');
			
			var js2: Array = [
				'var script2 = document.createElement("SCRIPT")',
				'script2.src = "http://devaws.pmi5media.com/owa/modules/base/js/owa.custom.js"',
				'var head2 = document.getElementsByTagName("script")[0]',
				'head2.parentNode.insertBefore(script2,head2)'
			];
			ExternalInterface.call('(function(){' + js2.join(';') + '})()');
			
			
			var js: Array = [
				'var script = document.createElement("SCRIPT")',
				'script.src = "http://devaws.pmi5media.com/owa/modules/base/js/owa.tracker-combined-min.js"',
				'var head = document.getElementsByTagName("script")[0]',
				'head.parentNode.insertBefore(script,head)',
			];
			ExternalInterface.call('(function(){ if(typeof owa_tracker == "undefined"){console.log("Enter in cond");' + js.join(';') + '}else{console.log("not enter");}})()');
			
			//timer for counter
			counterTime = new Timer(1000,30);
			counterTime.addEventListener(TimerEvent.TIMER, onCounterTimer,false,0,true);
		}
		
		
			
	
		function sendAnalytics(evt:String,grp:String):void
		{
			if(int(xmlCampaignList.campid)>0)
			{	
				if(ExternalInterface.available)
				{
					if(jsReady)
					{
					 ExternalInterface.call('VidPlayer.TrackForVpaid',evt,int(xmlCampaignList.campid),grp);
						
						if(!jstagSend){
						  pmi5Trace(",jstagSend="+ jstagSend+ ", jstag==="+xmlCampaignList.jstag + " \n");
						  jstagSend=true;
							ExternalInterface.call('writeThirdPartyJsTag',"'"+xmlCampaignList.jstag+"'");
						}
					}
					else
					{
						arrCustEvent.push(evt+","+int(xmlCampaignList.campid)+","+grp);
					}
			
					pmi5Trace("evt="+evt+" ");
				}
			}
			else
			{
				pmi5Trace(" CompaignId not found ! ");
			}
		}

		function xmlDataError(er: IOErrorEvent): void {
			xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, xmlDataError);
			xmlLoader.removeEventListener(Event.COMPLETE, xmlDataLoaded);
			xmlLoader = null;
			doAdError(er);
		}

		function loadswf(): void {

			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			loaderContext.securityDomain = SecurityDomain.currentDomain; // Sets the security 

			pmi5adLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, finishLoading, false, 0, true);
			pmi5adLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, swfLoadingError, false, 0, true);
			pmi5adLoader.load(new URLRequest(fullPath + swfFileName), loaderContext);
		}


		function finishLoading(loadEvent: Event): void {
			pmi5adLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, finishLoading);
			pmi5adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, swfLoadingError);

			pmi5adMC = MovieClip(loadEvent.target.content);
			pmi5adMC.x = 0;
			pmi5adMC.y = 0;

			this.addEventListener("jsdata",onJSTracking);
			
			this.addChild(pmi5adMC);
			createDebugger();
			pmi5Trace("finishLoading()");
			passXmlData();

			adDuration = xmlCampaignList.durationseconds; // passing from content xml 

			if (isLinearServed) {
				pmi5Trace(" in < " + isLinearAd + " >" + isLinearServed + " >");
				isLinearAd = true;
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange));
			} else {
				isLinearAd = false;
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange));
				pmi5Trace(" else < " + isLinearAd + " >" + isLinearServed + " >");
			}
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
		}

		private function onCounterTimer(e:TimerEvent): void {
			jsReady = ExternalInterface.call("hanu");
			pmi5Trace(" J="+jsReady+ ", ");
			if(jsReady)
			{
				
				counterTime.stop();
				counterTime.removeEventListener(TimerEvent.TIMER, onCounterTimer);
				pmi5Trace(" stop-remove-timer ")
				
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStarted));
			
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
				sendAnalytics("impression",String(xmlCampaignList.campgroup));
			
				dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoStart));
				sendAnalytics("start",String(xmlCampaignList.campgroup));
				
				for(var i:int=0;i<arrCustEvent.length;i++)
				{
					SplitJSdata(arrCustEvent[i]);
					
				}
				arrCustEvent.length=0;
				arrCustEvent = null;
				
			}			
		}


		function doAdError(arg1: * ): void {
			log("error:" + arg1);
			pmi5Trace("error:" + arg1);
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError, arg1));
			stopAd();

		}

		function swfLoadingError(errorEvent: Event): void {
			pmi5adLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, finishLoading);
			pmi5adLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, swfLoadingError);
			pmi5adLoader = null;
			doAdError("swfLoadingError");
		}




		/**
		 * VPAID function.
		 */
		public function startAd(): void {
			log("Beginning the display of the ad -startAd() viewMode=" + this.viewMode + " initW=" + initWidth + " initH=" + initHeight);
			resetAd();
			counterTime.start();
			pmi5Trace("-TimerStart-");
		}

		public function passXmlData(): void {
			pmi5adMC.rcvAdData(xmlData);
		}
		function createDebugger(): void {
			debugTxtFormat.size = 10;
			debugText.visible = showDebugger; //received from xml
			debugText.wordWrap = true;
			debugText.border = true;
			debugText.textColor = 0xFFFFFF;
			debugText.borderColor = 0xFF0000;
			debugText.x = 0;
			debugText.width = 550;
			debugText.height = 250;
			debugText.defaultTextFormat = debugTxtFormat;
			this.addChild(debugText);
		}

		

		function pmi5Trace(str: String): void {
			debugText.appendText(str);

		}


		/**
		 * Called to end the ad.  stopAd() is called because the ad is done
		 */
		protected function timerComplete(event: Event): void {
			pmi5Trace("timer comp -- video complete");
			pmi5adMC.clearAllAds();
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoComplete));
			sendAnalytics("complete",String(xmlCampaignList.campgroup));
			changeLinerToNonLinear();
			stopAd();

		}

		function removeAllAd(e: Event): void {
			pmi5adMC.clearAllAds();
			this.removeEventListener("eventadremove", removeAllAd);
			stopAd();
		}
		
		function onSkipad(e:Event):void
		{
			pmi5Trace(" AdSkipped-stop-");
			adSkippableState=true;
			
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdUserClose));
			sendAnalytics("skip",String(xmlCampaignList.campgroup));
			pmi5adMC.clearAllAds();
			stopAd();
		}

		function onPlayerMute(e:Event):void
		{
			pmi5Trace("-AdVol(Mute)-");
			log("--from player mute>--");
			playerVol=0;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVolumeChange));
			sendAnalytics("mute",String(xmlCampaignList.campgroup));
			
			
		}
		
		function onPlayerUnmute(e:Event):void
		{
			pmi5Trace("-AdVol(Unmute)-");
			playerVol=1;
			log("--from player Unmute+--");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVolumeChange));
			sendAnalytics("unmute",String(xmlCampaignList.campgroup));
			
			
		}
		
		
		function onPPause(e:Event):void
		{
			pmi5Trace("-onPause-");
			log("--from player Paused+--");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPaused));
			sendAnalytics("pause",String(xmlCampaignList.campgroup));
		}
		
		function onPResume(e:Event):void
		{
			pmi5Trace("-onResume-");
			log("--from player Playing--");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPlaying));
			sendAnalytics("resume",String(xmlCampaignList.campgroup));
		}
		
		

		function onAdUClosed(e: Event): void {
			pmi5adMC.clearAllAds();
			this.removeEventListener("crossclick", onAdUClosed);
			sendAnalytics("close",String(xmlCampaignList.campgroup));
			stopAd();
		}

		function changeLinerToNonLinear(): void {
			log("ad type changed linear to non linear");
			isLinearServed=false;
			isLinearAd = false;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange));
			sendAnalytics("linear change",String(xmlCampaignList.campgroup));
			
		}


		public function stopAd(): void {
			log("Stopping the display of the VPAID Ad");
			if (counterTime) {
				counterTime.stop();
				counterTime.removeEventListener(TimerEvent.TIMER, onCounterTimer);
				counterTime = null;

			}
			
			if(pmi5adMC)
			{
				pmi5adMC.hidePlayerBgVideo();
				
			}

			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
			sendAnalytics("stop",String(xmlCampaignList.campgroup));
			if(pmi5adMC)
				{
					pmi5adMC.unloadAndStop();
					log("Unload and stop ");
				}
		}

		/**
		 * VPAID function.
		 */
		public function resizeAd(width: Number, height: Number, viewMode: String): void {

			log("resizeAd-width="+ int(width) + " height" + int(height));
			this.initWidth = width;
			this.initHeight = height;
			this.viewMode = viewMode;
			resetAd();
			if (this.viewMode == "fullscreen") {
				pmi5Trace("--fullScrnRA--");
				this.x = 0;
				this.y = 0;

			} else {
				this.x = 0;
				this.y = 0;
			
			}
		}


		/**
		 * Resizing Ad with the initWidth and initHeight.
		 */
		protected function resetAd(): void {
			log("resetAd="+ int(initWidth) + " initH" + int(initHeight)+",ParentW*H=" +this.parent.width + "*"+ this.parent.height);
			pmi5Trace("resetAd"+ int(initWidth) + "," + int(initHeight) + ","+ viewMode+",ParentW,H:" +this.parent.parent.width + ", "+ this.parent.parent.height);

			var holderRatio:Number = initWidth/initHeight;
            var contentRatio:Number = maxSwfWidth/maxSwfHeight;
            //compare both ratios to get the maximum area
            if(holderRatio < contentRatio){
                pmi5adMC.width = initWidth;
				pmi5Trace("xWidth=" + pmi5adMC.scaleX + ", x=" + (pmi5adMC.scaleX).toFixed(2));
				pmi5adMC.scaleX = Number((pmi5adMC.scaleX).toFixed(2));
                pmi5adMC.scaleY = Number((pmi5adMC.scaleX).toFixed(2));
            }else{
                pmi5adMC.height = initHeight;
				pmi5Trace("xHeight=" + pmi5adMC.scaleY + ", Y=" + (pmi5adMC.scaleY).toFixed(2));
				pmi5adMC.scaleY = Number((pmi5adMC.scaleY).toFixed(2));;
                pmi5adMC.scaleX =Number((pmi5adMC.scaleY).toFixed(2));
            }
            //now the size is ok, lets center the thing
            pmi5adMC.x =((initWidth - pmi5adMC.width )/2);
            pmi5adMC.y = ((initHeight - pmi5adMC.height)/2);
			
			log("stgR="+ holderRatio + ",conR=" + contentRatio + ",iW="+ Math.round(holderRatio) +", iH=" + Math.floor(holderRatio)+ " x="+ Math.ceil(contentRatio)+ ",y=" + Math.floor(contentRatio));
			pmi5Trace("stgR="+ holderRatio + ",conR=" + contentRatio + ",iW="+ Math.round(holderRatio) +", iH=" + Math.floor(holderRatio)+ " x="+ Math.ceil(contentRatio)+ ",y=" + Math.floor(contentRatio));

			
			var bgShape:Shape = new Shape();
				bgShape.graphics.beginFill(0x000000,1);
				bgShape.graphics.drawRect(0,0,initWidth,initHeight);
				bgShape.graphics.endFill();
			this.addChild(bgShape);
			this.setChildIndex(pmi5adMC,numChildren-1);
			
		}

		/**
		 * Position FakeAd with the initWidth and initHeight.  The ad is put in the middle
		 * of the available area
		 */
		protected function positionAd(): void {
			if (pmi5adMC) {
				pmi5Trace("positionAd(->");
				var widthAndHeight: Number = Math.min(initHeight, initWidth);
				if (this.viewMode == "fullscreen") {
					pmi5Trace("(FullScrn)");
					this.x = (initWidth / 2) - (adCustomWidth / 2);
					this.y = (initHeight / 2) - (adCustomHeight / 2);
				} else {
					pmi5Trace("(Normal)");
					this.x = 0;
					this.y = 0;
				}
			}
		}

		/**
		 * VPAID function.  Pauses the ad if necessary.
		 */
		public function pauseAd(): void {
			/*if (timer) {
				timer.stop();
			}*/

		}

		/**
		 * VPAID function.  Resumes the ad if necessary.
		 */
		public function resumeAd(): void {
			/*if (timer) {
				timer.start();
			}*/
		}

		public function playPlayer(e: Event): void {
			if(isLinearServed) return;
			debugText.appendText("-PlayPlaer()-StartAd-");
			isLinearAd = false;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange));
			

		}

		private function onPlayerBgVideo(e: Event): void {
			//pmi5Trace("-Player Video-");
			if (timer) timer.stop();
		}

		public function stopPlayer(e: Event): void {
			if(isLinearServed) return;
			isLinearAd = true;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLinearChange));
			debugText.appendText("--Add paused3---");
		}

		function firstQuarComplete(e: Event): void {
			this.removeEventListener(firstQuartileName, firstQuarComplete);
			log("from first quartile");
			pmi5Trace("firstQuartileName");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoFirstQuartile));
			sendAnalytics("q1",String(xmlCampaignList.campgroup));
		}


		function secondQuarComplete(e: Event): void {
			this.removeEventListener(secondQuartilName, secondQuarComplete);
			log("from second quartile");
			pmi5Trace("MidQuartile");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoMidpoint));
			sendAnalytics("q2",String(xmlCampaignList.campgroup));
		}

		function thirdQuarComplete(e: Event): void {
			this.removeEventListener(thirdQuartileName, thirdQuarComplete);
			log("from Third quartile");
			pmi5Trace("3Quartile");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoThirdQuartile));
			sendAnalytics("q3",String(xmlCampaignList.campgroup));
		}

		function forthQuarComplete(e: Event): void {
			this.removeEventListener(forthQuartileName, forthQuarComplete);
			//log("from Fourth quartile- video complete");
			pmi5Trace("FourthComplete");
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoComplete));
			sendAnalytics("complete",String(xmlCampaignList.campgroup));
			changeLinerToNonLinear();
			if(switchToNonlin)
			{
				pmi5adMC.hidePlayerBgVideo();
				pmi5Trace("-HidePlayerVid-");
			}
			else
			{
				
				stopAd();
			}

		}


		function campClickHandler(e: Event): void {
			var data: Object = {
				"playerHandles": true
			};

			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdClickThru, data));
			pmi5Trace(" ?CampainClick");
			sendAnalytics("click",String(xmlCampaignList.campgroup));
		}



		/**
		 * VPAID function.  Returns the amount of time left in the ad play.
		 */
		public function get adRemainingTime(): Number {
			return timeRemaining;
		}

		/**
		 * Handler for clicking on ad, which dispatches an event for the player to handle
		 * the click-thru
		 */
		protected function onAdClick(event: MouseEvent): void {
			var data: Object = {
				"playerHandles": true
			};
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdClickThru, data));
			pmi5Trace("onAdClick( --- ");
			sendAnalytics("click",String(xmlCampaignList.campgroup));
		}



		/**
		 * VPAID function.  Returns the real VPAID object, which is this object for the
		 * example.
		 */
		public function getVPAID(): Object {
			return this;
		}

		/**
		 * VPAID function.
		 */
		public function get adLinear(): Boolean {
			return isLinearAd;
		}

		/**
		 * VPAID function.  This ad is never expanded
		 */
		public function get adExpanded(): Boolean {
			return isAdExpanded; //false;   

		}



		/**
		 * VPAID function.  This ad never has a volume
		 */
		public function get adVolume(): Number {
			return playerVol;
			
		}

		/**
		 * VPAID function.  This ad never has a volume
		 */
		public function set adVolume(value: Number): void {
			
			}

		/**
		 * VPAID function.
		 */
		public function handshakeVersion(playerVPAIDVersion: String): String {
			log("The player supports VPAID version " + playerVPAIDVersion + " and the ad supports " +
				VPAID_VERSION);
			// "1.0" MUST be returned for the VPAID version, otherwise the ad won't play.
			return VPAID_VERSION;
		}

		/**
		 * Logs a message using the player's logging functionality which shows the message
		 * here: http://admin.brightcove.com/viewer/BrightcoveDebugger.html
		 */
		protected function log(mesg: String): void {
			var data: Object = {
				"message": mesg
			};
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLog, data));
		}
		/**
		 * Retrieves the VAST Duration, which is passed to VPAID via creativeData.
		 */
		private function getDurationValue(creativeData: String): void {

			
		}

		private function expAd(e: Event): void {
			expandAd();
		}

		/**
		 * VPAID function.  Nothing to expand in this ad
		 */
		public function expandAd(): void {
			isAdExpanded = true;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdExpandedChange));
			pmi5Trace("-exp-trac-Play");
			sendAnalytics("expand",String(xmlCampaignList.campgroup));
			pmi5Trace("-exp-jsReady2-" + jsReady);
		}

		private function colAd(e: Event): void {

			collapseAd();
		}

		/**
		 * VPAID function.  Nothing to collapse in this ad
		 */
		public function collapseAd(): void {
			isAdExpanded = false;
			dispatchEvent(new VPAIDEvent(VPAIDEvent.AdExpandedChange));
			sendAnalytics("collapse",String(xmlCampaignList.campgroup));
			pmi5Trace("-col-track-Resume-");
			
		}

	}
}