/**
 * 2014_0811 sample of Citrus Level editor
 * based upon pseudosam tutorial https://www.youtube.com/watch?v=h3gb5B0Fy3U
 * more... https://www.youtube.com/watch?v=h3gb5B0Fy3U&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh
 * 
 * TODO:
 * 1: Character animation:
 *    - https://www.youtube.com/watch?v=rKSEyWo3Kds&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=2
 * 2: Sprite sheet animation:
 *    - https://www.youtube.com/watch?v=QC8mRAQkwEQ&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=3
 * 3: Citrus Level editor Optimized:
 *    - https://www.youtube.com/watch?v=xorPMmb1F90&index=5&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh
 * 4: Citrus Engine with Particles:
 *    - https://www.youtube.com/watch?v=UErhy6xfopk&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=6
 * 5: Citrus Level Manager:
 *    - https://www.youtube.com/watch?v=tWEIp1zvjPQ&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=7
 * 6: Citrus Engine Level Transitions
 *    - https://www.youtube.com/watch?v=KLHpsLB9hnE&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=8
 * 7: Citrus Hero Properties
 *    - https://www.youtube.com/watch?v=Dpl9tH_iJ_s&index=9&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh
 * 8: Citrus Fullscreen
 *    - https://www.youtube.com/watch?v=yQlj-NRzIEA&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=10
 * 9: Citrus on Mobile
 *    - https://www.youtube.com/watch?v=rhl-NoTG5q8&index=11&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh
 * 10:when coin is hit: update earnings, when hit by enemy: reduce earnings
 * 
 */

package {
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import citrus.core.starling.StarlingCitrusEngine;
	
	[SWF(width="1024", height="768", frameRate="60", backgroundColor="0xCFF3F2")]
	public class CitrusEditor extends StarlingCitrusEngine {
		
		private var loader:Loader; // 2014_0813 created with shortcut "Command-1" while cursus on "loader" in constructor...
		private var _level:Number = 1; // level number ...
		
		public function CitrusEditor() {
			setUpStarling(true);
			//* 2014_0814 eigen level-loader, more re-usable... 
			//2014_0817: loadLevel("../levels/level1.swf");
			loadLevel("../levels/level1.swf");
			/*/
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest("../levels/level1.swf"));
			//*/
		}
		
		protected function onLoad(e:Event):void {
			trace("level"+_level+" about to load ...");
			switch (_level) {
				/*case 0:
					state = new Level0(e.target.loader.content);
					break;   */
				case 1:
					state = new Level1(e.target.loader.content);
					break;
				/* het idee:
				case 2:
					state = new Level2(e.target.loader.content);
					break;
				*/
				default:
					trace("level ["+_level+"] is illegal value...");
			}
			
			// cleanup...
			loader.removeEventListener(Event.COMPLETE, onLoad);
			loader.unloadAndStop(true);
		}
		
		// eigen Level-loader
		private function loadLevel(resource:String):void {
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
			loader.load(new URLRequest(resource));
		}
		
	} // endof class
} // endof package