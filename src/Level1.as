package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.view.starlingview.StarlingArt;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;

	//import citrus.view.ACitrusCamera;
	//import citrus.view.starlingview.StarlingArt;
	//import citrus.view.starlingview.StarlingCamera;
	
	public class Level1 extends GameLevel {
		public static const LEVELNAME:String = "Level1"; // id of the level

		public function Level1(lvl:MovieClip) {
			trace(LEVELNAME+" constructor entered...");
			super(lvl);
		}

		/*	2014_0818 deprecated
		private function onAddedToStage(e:Event):void {
			trace(LEVELNAME+"::onAddedToStage() entered...");
			init();
		}
		*/		
		// setup level 1 ...
		//override public function initialize():void {
		// 2014_0818 okay, when hero as dragonbone sprite os used!!
		override protected function init():void {
			trace(LEVELNAME+"::init() entered...");
			
			gameWidth  = 3000;
			gameHeight =  800;
			heroStartX =  140;
			heroStartY =  293;
			
			super.init();
			
			trace(LEVELNAME+"::init() - creating level 1 sensors ...");
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
		
		// ouch, hero touches spikes...
		override protected function onDie(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(spikes, contact) is Hero) {
				trace(LEVELNAME+": hero died a horrible spikey death!");
			}
			// call common die-behaviour...
			super.onDie(contact);
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