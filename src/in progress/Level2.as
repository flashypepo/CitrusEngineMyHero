package {
	
	import flash.display.MovieClip;
	
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	
	public class Level2 extends GameLevel {
		public static const LEVELNAME:String = "Level2";
		
		
		public function Level2(lvl:MovieClip=null) 	{
			super(lvl);
		}
		
		// setup level 2 ...
		override public function initialize():void {
			// crash: override protected function init():void {
			trace(LEVELNAME + "::init() entered...");
			
			// level 2 values:
			gameWidth  = 3500;
			gameHeight = 1200;
			heroStartX =  142;
			heroStartY =  582;
			
			super.init();
			
			trace(LEVELNAME + "::init() - creating level-sensors ...");
			// create a sensor "fall" - see fla-file
			fall = getObjectByName("fall") as Sensor;
			fall.onBeginContact.add (onFall);
			
			// create a spikes sensor - see fla-file
			spikes = getObjectByName("spikes") as Sensor;
			spikes.onBeginContact.add (onDie);
			
			// create a end-level sensor - see fla-file
			end = getObjectByName("end") as Sensor;
			end.onBeginContact.add (onEnd);
		}

		// collision begin-contact - a b2dContact
		override protected function onFall(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(fall, contact) is Hero) {
				trace(LEVELNAME+": hero fell to his doom, you monster!");
			}
			// call common onFall-behaviour...
			super.onFall(contact);
		}
		
		// hero reaches end-of-level ..
		override protected function onEnd(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(end, contact) is Hero) {
				trace(LEVELNAME+": hero has reached the end");
			}
			// call common end-behaviour...
			super.onEnd(contact);
		}
		
	} // endof class
} // endof package