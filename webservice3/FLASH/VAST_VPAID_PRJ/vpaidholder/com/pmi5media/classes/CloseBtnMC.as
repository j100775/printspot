package com.pmi5media.classes {
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.PixelSnapping;
	
	
	public class CloseBtnMC extends MovieClip {
		
		
		private var txtClose:TextField = new TextField();
		private var clTextFormat:TextFormat = new TextFormat();
		private var _enableTrack:Boolean;
		private var closeTrackXMLList:XMLList;
		private var closeBtnLoader:Loader=new Loader();
				
		public function CloseBtnMC() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE,closeMCAdded,false,0,true);
			txtClose.text = "Close";
			txtClose.visible = false;
			txtClose.textColor = 0xffffff;
			txtClose.y=2;
			txtClose.x=30;
			txtClose.autoSize = TextFieldAutoSize.LEFT;
			
			clTextFormat.size=10;
			txtClose.defaultTextFormat = clTextFormat;
			
			
		}
		
		function closeMCAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,closeMCAdded);
			this.addChild(txtClose);
			addEventListener(MouseEvent.CLICK,onClsClick);
			this.buttonMode = true;
		}
		
		function onCTxtOver(e:MouseEvent):void
		{
			txtClose.visible=true;
		}
		
		function onCTxtOut(e:MouseEvent):void
		{
			txtClose.visible=false;
		}
		
		function onClsClick(e:MouseEvent):void
		{
			dispatchEvent(new Event(AppConst.EVENT_CLOSE_CLICK,true));
			if(_enableTrack)
			{
			Pmi5Tracking.doTrack(closeTrackXMLList);
			dispatchEvent(new JSDataEvent(JSDataEvent.JS_DATA,Pmi5Tracking.getJSTrackData(closeTrackXMLList),true));
				
			}
		}
		public function btnData(pXml:XMLList):void
		{
			if(int(pXml.offsetx)>550)
			txtClose.x =-35;
			this.x = pXml.offsetx;
			this.y= pXml.offsety;
			closeTrackXMLList = pXml.trackingurl;
			if(pXml.enabletracking.length()>0)
			   _enableTrack=pXml.enabletracking.toLowerCase()=="true";
			   
			loadCloseBtnImg(pXml.imgpath);
		}
		
		public function loadCloseBtnImg(path:String):void
		{
			//load close button
			if((path.length>0)&& (path!="default"))
			{
				deleteAllChild();
				closeBtnLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadComp,false,0,true);
				closeBtnLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler,false,0,true);
				closeBtnLoader.load(new URLRequest(path));
			}
			else
			{
				addDefCloseBtn();
			}
		}
		
		function loadComp(evt:Event):void
		{
			closeBtnLoader.width= AppConst.CLOSE_BTN_W;
			closeBtnLoader.height= AppConst.CLOSE_BTN_H;
			var bmp:Bitmap = closeBtnLoader.content as Bitmap;
			bmp.smoothing=true;
			bmp.pixelSnapping = PixelSnapping.AUTO;	
			bmp.width= AppConst.CLOSE_BTN_W;
			bmp.height= AppConst.CLOSE_BTN_H;
			this.addChild(bmp);
			//this.addChild(closeBtnLoader);
			closeBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComp);
			closeBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		
		function ioErrorHandler(evt:ErrorEvent):void
		{
			trace("close btn image loading error");
			closeBtnLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loadComp);
			closeBtnLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			closeBtnLoader=null;
			addDefCloseBtn();
			//dispatchEvent(new Event("cerror",true));
		}
		function addDefCloseBtn():void
		{
				var bmpCloseBtn:Bitmap=IconsPmi5.getCloseBtn();
				bmpCloseBtn.width = AppConst.CLOSE_BTN_W;
				bmpCloseBtn.height = AppConst.CLOSE_BTN_H;
				this.addChild(bmpCloseBtn);
		}
		
		function deleteAllChild():void
		{
			for(var i:int=this.numChildren-1;i>=0;i--)
			{
				this.removeChildAt(i);
			}
		}
		
	}//class
	
}
