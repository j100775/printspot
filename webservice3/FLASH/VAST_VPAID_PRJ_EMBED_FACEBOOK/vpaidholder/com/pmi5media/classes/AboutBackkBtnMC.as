package com.pmi5media.classes {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.Loader;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	
	public class AboutBackkBtnMC extends MovieClip {
		
		private var abtBackXml:XMLList;
		private var _enableTrack:Boolean;
		private var backImgLoader:Loader = new Loader();
		private var backImgW:int;
		private var backImgH:int;
		
		public function AboutBackkBtnMC() {
			// constructor code
			this.buttonMode = true;
		}
		
		public function onBgTrack():void
		{
			
			if(_enableTrack)
			{
				Pmi5Tracking.doTrack(abtBackXml);
				// js tracking is not working here so shifted in parent class - About.as
			}
		}
		
		
		public function loadAbgBkImg(pData:XMLList):void
		{
			abtBackXml=pData.trackingurl;
			this.x = int(pData.offsetx)*AppConst.MULTIPLIER;
			this.y = int(pData.offsety)*AppConst.MULTIPLIER;
			
			if(pData.enabletracking.length()>0)
			   _enableTrack=pData.enabletracking.toLowerCase()=="true";
			
			if(pData.imgwidth.length()>0)
				backImgW = int(pData.imgwidth)*AppConst.MULTIPLIER;
			
			if(pData.imgheight.length()>0)
				backImgH = int(pData.imgheight)*AppConst.MULTIPLIER;

		
			if(pData.imgpath.length()>0)
			{
			backImgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,biLoaded,false,0,true);
			backImgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,biError,false,0,true);
			backImgLoader.load(new URLRequest(pData.imgpath));
			}
			else
			{
				getDefAbtBackBtn();
			}
		}
		
		private function biLoaded(e:Event):void{
			//backImgLoader.width = backImgW;
			//backImgLoader.height = backImgH;
			
			var bmpImg:Bitmap = backImgLoader.content as Bitmap;
			bmpImg.smoothing=true;
			bmpImg.pixelSnapping = PixelSnapping.AUTO;
			bmpImg.width = backImgW;
			bmpImg.height = backImgH;
			this.addChild(bmpImg);
			
			//this.addChild(backImgLoader);
				
			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,biError);
			
		}
		private function biError(e:IOErrorEvent):void
		{
			backImgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,biLoaded);
			backImgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,biError);
			getDefAbtBackBtn();
		}
		
		private function getDefAbtBackBtn():void
		{
			var bmpAbtBackBtn:Bitmap = IconsPmi5.getBackBtn();
			bmpAbtBackBtn.width = AppConst.BACK_BTN_W;
			bmpAbtBackBtn.height = AppConst.BACK_BTN_H;
			this.addChild(bmpAbtBackBtn);
		}
		
	}//class
}
