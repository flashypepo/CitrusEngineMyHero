/**
 * game level 0: portal to the other levels
 * 2014_0816 started
 */
package {
	
	import flash.display.MovieClip;
	
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	
	import citrus.objects.CitrusSprite;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;

	
	
	public class Level0 extends GameLevel {
		public static const LEVELNAME:String = "Level0";
		
		private var bg:CitrusSprite;
		private var port1:Sensor;
		private var port2:Sensor;

		public function Level0(lvl:MovieClip=null) {
			super(lvl);
		}

		// setup level 2 ...
		override public function initialize():void {
			// crash: override protected function init():void {
			trace(LEVELNAME + "::init() entered...");
			
			// level 0 values:
			gameWidth  = 1024;
			gameHeight = 768;
			heroStartX = 490;
			heroStartY = 560;

			// add a special backgroud before GameLevel::init()
			// values x and y: trial-and-error
			bg = new CitrusSprite("bg", {x:-250, y:-150, view:"../sprites/bg.swf"});
			add(bg);
			
			super.init();
			
			trace(LEVELNAME + "::init() - creating portals to the levels ...");
			// portal to level 1  - see fla-file
			port1 = getObjectByName("lvl1") as Sensor;
			port1.onBeginContact.add (onPort1); // signals!
			
			// portal to level 2  - see fla-file
			port2 = getObjectByName("lvl2") as Sensor;
			port2.onBeginContact.add (onPort2);

		}
		
		// portal to level 1...
		private function onPort1(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(end, contact) is Hero) {
				trace(LEVELNAME+": hero goes to level 1...");
			}
		}
		
		// portal to level 2...
		private function onPort2(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(end, contact) is Hero) {
				trace(LEVELNAME+": hero goes to level 2...");
			}
		}

	} // endof class
} /// endof package