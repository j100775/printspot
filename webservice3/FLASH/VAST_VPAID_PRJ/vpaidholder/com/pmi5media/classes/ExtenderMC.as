package com.pmi5media.classes {

	import flash.display.MovieClip;


	public class ExtenderMC extends MovieClip {

		private var extXmlList: XMLList = new XMLList();
		private var extXmlLen: int;

		private var enableTrack: Boolean;
		private var trackXmlList: XMLList = new XMLList();
		private var showAfter: int;

		public function ExtenderMC() {
			// constructor code
		}

		public function loadData(pXml: XMLList) {
			try {
				this.visible = false;
				showAfter = 0;
				showAfter = pXml.showafter;
				extXmlList = pXml..extdata;
				extXmlLen = extXmlList.length();

				for (var i: int = 0; i < extXmlLen; i++) {
					if (extXmlList[i].@type == AppConst.AD_IMAGE_SLIDE) {
						createImage(extXmlList[i].imageslide);
					}
				}

				createKW(pXml.kw.imageslide);
				createSC(pXml.sc.imageslide);
			} catch (e: Error) {
				trace("extender error=" + e.message.toString());
			}


		}

		function createKW(pXml: XMLList): void {
			var objImgKW: MovieClip = new ImgKWMC();
			objImgKW.loadImage(pXml);
			this.addChild(objImgKW);
		}

		function createSC(pXml: XMLList): void {
			var objImgSC: MovieClip = new ImgSCMC();
			objImgSC.loadImage(pXml);
			this.addChild(objImgSC);
		}

		function createImage(pXml: XMLList): void {
			var objImageModule: MovieClip = new ImageMC();
			this.addChild(objImageModule);
			objImageModule.loadImage(pXml);
		}

		public function showExt(pTime: int): Boolean {
			if (pTime == showAfter) {
				this.visible = true;
				return true;

			} else {
				return false;
			}

		}

		public function hideExt(): void {
			showAfter = -1;
			this.visible = false;
		}


	} //class
} //pkg