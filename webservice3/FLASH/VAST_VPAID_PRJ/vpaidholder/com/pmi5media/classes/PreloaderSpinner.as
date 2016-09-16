package  com.pmi5media.classes {
	
	 import flash.display.Sprite;
	 import flash.display.Shape;
	 import flash.events.Event;
	 import flash.geom.Rectangle;
	 import flash.filters.BlurFilter;
	
	public class PreloaderSpinner extends Sprite {

 		private var back:Shape;
		private var spinner:Shape;
		private var rectWidth:Number;
		private var rectHeight:Number;
		private var sticks:Vector.<Shape>;
		private var numSticks:int;
		private var count:int;
		private var dimColor:uint;
		private var brightColor:uint;
		private var colors:Vector.<uint>;
		private var alphas:Vector.<Number>;
		private var sticksHolder:Sprite;
		private var _bgAlpha:Number;
        
	 
		public function PreloaderSpinner(w:Number,h:Number) {
			// constructor code
			rectWidth=w;
		  	rectHeight=h;
		  	numSticks=12;
		  	count=0;
		  	
			_bgAlpha = 0.5;
			
		  	sticks= new Vector.<Shape>(numSticks);
		  
			sticksHolder = new Sprite();
			this.addChild(sticksHolder);
			sticksHolder.x=0;
			sticksHolder.y=0;
				
			var i:int;
			for(i=0;i<numSticks;i++){
				sticks[i]=new Shape();
				sticksHolder.addChild(sticks[i]);
				sticks[i].x=0;
				sticks[i].y=0;
			}
		
			setColors(0x0088DDFF, 0xFF88DDFF);
		}
		
		public function set bgAlpha(n:Number):void {
			_bgAlpha = n;
		}
		
		public function setColors(color1:uint, color2:uint):void {
			var a1:uint = (color1 >> 24) & 0xFF;
			var r1:uint = (color1 >> 16) & 0xFF;
			var g1:uint = (color1 >> 8) & 0xFF;
			var b1:uint = color1 & 0xFF;
			var a2:uint = (color2 >> 24) & 0xFF;
			var r2:uint = (color2 >> 16) & 0xFF;
			var g2:uint = (color2 >> 8) & 0xFF;
			var b2:uint = color2 & 0xFF;
			var a,r,g,b:Number;
			
			colors = new Vector.<uint>(numSticks);
			alphas = new Vector.<Number>(numSticks);
			var i:Number;
			var t:Number;
			for (i = 0; i < numSticks; i++) {
				t = i/(numSticks-1);
				t = t*t;
				a = a1 + t*(a2-a1);
				r = r1 + t*(r2-r1);
				g = g1 + t*(g2-g1);
				b = b1 + t*(b2-b1);
				colors[i] = (r << 16) | (g << 8) | b;
				alphas[i] = Number(a)/255;
			}
			
			drawSpinner(count);
		}
		
		 private function drawBack():void {
			this.graphics.clear();
			this.graphics.beginFill(0xFFFFFF,_bgAlpha);
			this.graphics.drawRoundRect(-rectWidth/2,-rectHeight/2,rectWidth,rectHeight,10,10);
			this.graphics.endFill();
		 }
		 
		 private function drawSpinner(k:int):void {
			  
			var minRad:Number=10;
			var maxRad:Number=25;
			var ang=Math.PI*2/numSticks;
			
			var i:Number;
			var t:Number;
			  
			for(i=0;i<numSticks;i++){
				t = i/(numSticks-1);
				t = t*t;
				
				sticks[i].graphics.clear();
				sticks[i].graphics.lineStyle(3,colors[i],alphas[i],false,"normal","round");
				sticks[i].graphics.moveTo(minRad*Math.cos(i*ang),minRad*Math.sin(i*ang));
				sticks[i].graphics.lineTo(maxRad*Math.cos(i*ang),maxRad*Math.sin(i*ang));
			}
		  }
		  
		  public function stopSpinner():void {
			  this.removeEventListener(Event.ENTER_FRAME,doSpin);
			  count=0;
		  }
		  
		  public function startSpinner():void {
			  this.addEventListener(Event.ENTER_FRAME,doSpin);
		  }
		  
		  private function doSpin(e:Event):void {
			  count+=1;
			  count=count%numSticks;
			  sticksHolder.rotation = 360*count/numSticks;
		  }

	}
	
}
