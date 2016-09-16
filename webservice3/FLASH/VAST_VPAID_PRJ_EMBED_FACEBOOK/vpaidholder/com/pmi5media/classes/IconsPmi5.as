/*******************************************************************************************************
 * Class Name			:	IconsPmi5.as
 * Input Parameter(s)	:	N/A
 * Purpose				:	Th is class loads icon image from library and return bitmap data of the icon.
 * Created By			:	Mohd Riaz, Webvirtue.
 *******************************************************************************************************/

/*
Icons details 
-----------------------
Amazon 1
Contact us2
coupon3
DailyMotion Video 4
Dealer Locator5
Facebook page6
Google Play7
Instagram8
More Info9
More Videos10

Newsletter Signup11
Pinterest12
Purchase Item13
Related Docs14
Special Offer15
Tickets & Showtimes16
Twitter Page17
YouTube Page18
iTunes19
Linked In20

RSS21
default iconany no. except above
*/

package com.pmi5media.classes {
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import fl.transitions.PixelDissolve;

	public class IconsPmi5 {

		public function IconsPmi5() {
			// constructor code
		}


		public static function getIcon(iconNo: int): Bitmap {
			//trace("icon no="+iconNo);
			//var iconBmp:Bitmap = new Bitmap(new IconAmazon(0,0));
			var iconBmp: Bitmap;

			switch (iconNo) {
				case 1:
					iconBmp = new Bitmap(new IconAmazon(0, 0));
					break;

				case 2:
					iconBmp = new Bitmap(new IconContactUs(0, 0));
					break;

				case 3:
					iconBmp = new Bitmap(new IconCoupons(0, 0));
					break;

				case 4:
					iconBmp = new Bitmap(new IconDailyMotionVideo(0, 0));
					break;

				case 5:
					iconBmp = new Bitmap(new IconDealerLocator(0, 0));
					break;

				case 6:
					iconBmp = new Bitmap(new IconFacebook(0, 0));
					break;

				case 7:
					iconBmp = new Bitmap(new IconGooglePlay(0, 0));
					break;


				case 8:
					iconBmp = new Bitmap(new IconInstagram(0, 0));
					break;

				case 9:
					iconBmp = new Bitmap(new IconMoreInfo(0, 0));
					break;

				case 10:
					iconBmp = new Bitmap(new IconMoreVideos(0, 0));
					break;

				case 11:
					iconBmp = new Bitmap(new IconNewsLetterSignup(0, 0));
					break;

				case 12:
					iconBmp = new Bitmap(new IconPinterest(0, 0));
					break;

				case 13:
					iconBmp = new Bitmap(new IconPurchaseItems(0, 0));
					break;

				case 14:
					iconBmp = new Bitmap(new IconRelatedDocs(0, 0));
					break;

				case 15:
					iconBmp = new Bitmap(new IconSpecialOffer(0, 0));
					break;

				case 16:
					iconBmp = new Bitmap(new IconTicketsShowtimes(0, 0));
					break;

				case 17:
					iconBmp = new Bitmap(new IconTwitter(0, 0));
					break;

				case 18:
					iconBmp = new Bitmap(new IconYoutube(0, 0));
					break;

				case 19:
					iconBmp = new Bitmap(new IconItune);
					break;

				case 20:
					iconBmp = new Bitmap(new IconLinkedIn(0, 0));
					break;

				case 21:
					iconBmp = new Bitmap(new IconRSS(0, 0));
					break;


				default:
					iconBmp = new Bitmap(new IconPmi5(0, 0));
					break;
			}
			iconBmp.pixelSnapping=PixelSnapping.AUTO;
			iconBmp.smoothing = true;
			return iconBmp;
		}

		//half icon
		public static function getShadowIcon(iconNo: int): Bitmap {

			var iconBmp: Bitmap;
			switch (iconNo) {
				case 1:
					iconBmp = new Bitmap(new IconAmazonHalf(0, 0));
					break;

				case 2:
					iconBmp = new Bitmap(new IconContactUsHalf(0, 0));
					break;

				case 3:
					iconBmp = new Bitmap(new IconCouponsHalf(0, 0));
					break;

				case 4:
					iconBmp = new Bitmap(new IconDailyMotionVideoHalf(0, 0));
					break;

				case 5:
					iconBmp = new Bitmap(new IconDealerLocatorHalf(0, 0));
					break;

				case 6:
					iconBmp = new Bitmap(new IconFacebookHalf(0, 0));
					break;

				case 7:
					iconBmp = new Bitmap(new IconGooglePlayHalf(0, 0));
					break;
				case 8:
					iconBmp = new Bitmap(new IconInstagramHalf(0, 0));
					break;
				case 9:
					iconBmp = new Bitmap(new IconMoreInfoHalf(0, 0));
					break;
				case 10:
					iconBmp = new Bitmap(new IconMoreVideosHalf(0, 0));
					break;
				case 11:
					iconBmp = new Bitmap(new IconNewsLetterSignupHalf(0, 0));
					break;

				case 12:
					iconBmp = new Bitmap(new IconPinterestHalf(0, 0));
					break;

				case 13:
					iconBmp = new Bitmap(new IconPurchaseItemsHalf(0, 0));
					break;

				case 14:
					iconBmp = new Bitmap(new IconRelatedDocsHalf(0, 0));
					break;

				case 15:
					iconBmp = new Bitmap(new IconSpecialOfferHalf(0, 0));
					break;

				case 16:
					iconBmp = new Bitmap(new IconTicketsShowtimesHalf(0, 0));
					break;

				case 17:
					iconBmp = new Bitmap(new IconTwitterHalf(0, 0));
					break;

				case 18:
					iconBmp = new Bitmap(new IconYoutubeHalf(0, 0));
					break;

				case 19:
					iconBmp = new Bitmap(new IconItuneHalf(0, 0));
					break;

				case 20:
					iconBmp = new Bitmap(new IconLinkedInHalf(0, 0));
					break;

				case 21:
					iconBmp = new Bitmap(new IconRSSHalf(0, 0));
					break;
				default:
					iconBmp = new Bitmap(new IconPmi5Half(0, 0));
					break;
			}
			iconBmp.smoothing = true;
			iconBmp.pixelSnapping=PixelSnapping.AUTO;
			return iconBmp;
		}

		// get close btn icon
		public static function getCloseBtn(): Bitmap {
			var iconClose: Bitmap;
			iconClose = new Bitmap(new CloseBtn(0, 0));
			iconClose.smoothing = true;
			iconClose.pixelSnapping=PixelSnapping.AUTO;
			return iconClose;
		}

		//get cross btn icon
		public static function getCrossBtn(): Bitmap {
			var iconCross: Bitmap;
			iconCross = new Bitmap(new CrossBtn(0, 0));
			iconCross.smoothing = true;
			iconCross.pixelSnapping=PixelSnapping.AUTO;
			return iconCross;
		}

		//get red cross btn icon
		public static function getCrossBtnRed(): Bitmap {
			var iconCrossRed: Bitmap;
			iconCrossRed = new Bitmap(new CrossBtnRed(0, 0));
			iconCrossRed.smoothing = true;
			iconCrossRed.pixelSnapping=PixelSnapping.AUTO;
			return iconCrossRed;
		}

		public static function getBackBtn(): Bitmap {
			var iconBackBtn: Bitmap;
			iconBackBtn = new Bitmap(new BackBtn(0, 0));
			iconBackBtn.smoothing = true;
			iconBackBtn.pixelSnapping = PixelSnapping.AUTO;
			return iconBackBtn;
		}

		// get previous btn icon for slider gallery
		public static function getPrvBtnIcon(): Bitmap {
			var iconPrv: Bitmap;
			iconPrv = new Bitmap(new IconPrvBtn(0, 0));
			iconPrv.smoothing = true;
			iconPrv.pixelSnapping=PixelSnapping.AUTO;
			return iconPrv;
		}

		// get next btn icon for slider gallery
		public static function getNextBtnIcon(): Bitmap {
			var iconNext: Bitmap;
			iconNext = new Bitmap(new IconNextBtn(0, 0));
			iconNext.smoothing = true;
			iconNext.pixelSnapping=PixelSnapping.AUTO;
			return iconNext;
		}

		
		// get previous btn icon for thumbar in thumnails gallery
		public static function getThumbPrvBtnIcon(): Bitmap {
			var iconPrv: Bitmap;
			iconPrv = new Bitmap(new IconThumbPrvBtn(0, 0));
			iconPrv.smoothing = true;
			iconPrv.pixelSnapping=PixelSnapping.AUTO;
			return iconPrv;
		}

		// get next btn icon for thumbar in thumnails gallery
		public static function getThumbNextBtnIcon(): Bitmap {
			var iconNext: Bitmap;
			iconNext = new Bitmap(new IconThumbNextBtn(0, 0));
			iconNext.smoothing = true;
			iconNext.pixelSnapping=PixelSnapping.AUTO;
			return iconNext;
		}

		//get skip ad icon- image
		public static function getSkipAdIcon(): Bitmap {
			var iconSkip: Bitmap;
			iconSkip = new Bitmap(new IconSkipAd(0, 0));
			iconSkip.smoothing = true;
			iconSkip.pixelSnapping=PixelSnapping.AUTO;
			return iconSkip;
		}


	}

}