package {
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import Box2D.Dynamics.Contacts.b2PolygonContact;
	
	import citrus.core.starling.StarlingState;
	import citrus.objects.platformer.box2d.Coin;
	import citrus.objects.platformer.box2d.Crate;
	import citrus.objects.platformer.box2d.Enemy;
	import citrus.objects.platformer.box2d.Hero;
	import citrus.objects.platformer.box2d.MovingPlatform;
	import citrus.objects.platformer.box2d.Platform;
	import citrus.objects.platformer.box2d.Sensor;
	import citrus.physics.box2d.Box2D;
	import citrus.physics.box2d.Box2DUtils;
	import citrus.utils.objectmakers.ObjectMaker2D;
	import citrus.view.ACitrusCamera;
	import citrus.view.starlingview.StarlingArt;
	import citrus.view.starlingview.StarlingCamera;
	
	public class Level1 extends StarlingState {
		
		private var level:MovieClip;
		private var hero:Hero;
		private var fall:Sensor;
		private var spikes:Sensor;
		private var reset:Boolean = false; // initial value
		private var camera:StarlingCamera;
		private var verbose:Boolean = false; // true: extra console output - should use environment var ???
		
		public function Level1(lvl:MovieClip) {
			super();
			level = lvl;
			// array of possible objects in the engine ...
			var objectsUsed:Array = [Hero, Platform, Sensor, Crate, Enemy, Coin, MovingPlatform];
			
		}
		
		// setup scene ...
		override public function initialize():void {
			super.initialize();
			var b2d:Box2D = new Box2D("bo2d");
			
			/* debugging or not
			b2d.visible = true; // show enclosing box
			/*/
			b2d.visible = false; // show the graphics
			///*/
			add(b2d);
			// turn level MovieClip into Citrus-level to use in the game...
			ObjectMaker2D.FromMovieClip(level);
			
			// create our hero...
			/* 2014_0814 non-animated hero vs. animated hero: 
			hero = new Hero("hero", {x:140, y:293, width:66, height:92, view:"../sprites/front.png"});
			/*/
			hero = new Hero("hero", {x:140, y:293, width:66, height:92, view:"../sprites/hero.swf"});
			//*/
			add(hero);
			
			// create a sensor "fall" - see fla-file
			fall = getObjectByName("fall") as Sensor;
			fall.onBeginContact.add (onFall);

			// create a spikes sensor - see fla-file
			spikes = getObjectByName("spikes") as Sensor;
			spikes.onBeginContact.add (onDie);

			// setup animation loops... i.a. repeat "idle"
			StarlingArt.setLoopAnimations(["idle"]);
			
			// voegtoe camera om hero te volgen, platform te scrollen etc...
			camera = view.camera as StarlingCamera;
			if (verbose) {
				trace("stage width=" + stage.stageWidth + ", stage height=" + stage.stageHeight);
				trace("stage center point=(" + (stage.stageWidth >> 1) + ", " + (stage.stageHeight >> 1) + ")");
			}
			/* camera setup volgens video tutorial, echter dat werkt niet in CE die ik gebruik....
			camera.setUp(hero 
						, new Point(stage.stageWidth >> 1, stage.stageHeight >> 1)
						, new Rectangle (0,0,3000,800)
						, new Point(.2, .2)
						);
			/*/
			// 2014_0814 uitgaande van default-argumenten, bleek bounds nodig te zijn voor correcte camera view en meebewegen (center). 
			// 			 Overige parameters, zoals center en easing zijn default(null) of trial-and-error
			camera.setUp(hero
				, new Rectangle (0,0,3000,800) 	/*bounding area for camera*/
				, null  						/*center point - must be default value*/
				, new Point(0.2, 0.2)			/*easing point - trial-and-error*/
			);
			//*/
			camera.parallaxMode = ACitrusCamera.PARALLAX_MODE_TOPLEFT;
		}
		
		// update() is de plek waar elementen op scherm aangepast kunnen worden, zoals een hero die gevallen is (detectie met fall-sensor)
		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			if (reset) {
				resetHero(140, 293);
			}
		}
		
		private function resetHero(x:int, y:int):void
		{
			hero.x = x;
			hero.y = y;
			reset = false; // vergeet niet de reset-flag ook te re-setten!
		}
		
		// collision begin-contact - a b2dContact
		private function onFall(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(fall, contact) is Hero) {
				trace("hero falls...");
				reset = true; // update() regelt de rest...
			}
		}
		
		// ouch, hero touches spikes...
		private function onDie(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(spikes, contact) is Hero) {
				trace("hero died a horrible spikey death!");
				reset = true; // update() regelt de rest...
			}
		}
		
	} // endof class
} // endof package