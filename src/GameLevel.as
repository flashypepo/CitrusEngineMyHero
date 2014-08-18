/**
 * superclass for all game levels 
 * 
 * 2014_0815 based upon pseudosam video tutorial: 
 *    https://www.youtube.com/watch?v=tWEIp1zvjPQ&list=PLYtGhZ0r8VnNLMrD0KAhYI4TypvocCIEh&index=7
 */
package {
	
	import flash.display.MovieClip;
	import flash.events.Event;
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
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	public class GameLevel extends StarlingState {
		public static const LEVELNAME:String = "GameLevel"; // id of the level

		protected var level:MovieClip;
		
		protected var hero:Hero;
		protected var fall:Sensor;
		protected var spikes:Sensor;
		protected var end:Sensor;
		
		protected var reset:Boolean = false; // initial value
		
		protected var camera:StarlingCamera;
		protected var verbose:Boolean = false; // true: extra console output - should use environment var ???
		
		protected var gameWidth:int;
		protected var gameHeight:int;
		protected var heroStartX:int;
		protected var heroStartY:int;

		private var factory:StarlingFactory;
		private var arm:Armature;

		[Embed(source="../sprites/dragon.png", mimeType="application/octet-stream")]
		private var heroDragon:Class;
		
		public function GameLevel(lvl:MovieClip = null) {
			trace("GameLevel constructor entered...lvl=" + lvl);			
			super();
			
			level = lvl;
			// array of possible objects in the engine ...
			var objectsUsed:Array = [Hero, Platform, Sensor, Crate, Enemy, Coin, MovingPlatform];
			
			//* load hero Dragonbones spritesheet with Starling factory...
			factory = new StarlingFactory();
			factory.addEventListener(Event.COMPLETE, onDragon);
			factory.parseData(new heroDragon());
			
			trace(LEVELNAME + " constructor processed...");
		}
		
		// hero spritesheet is loaded...
		protected function onDragon(event:Event):void {
			trace(LEVELNAME + "::onDragon() entered ...");
			arm = factory.buildArmature("hero");
			arm.animation.timeScale = .75;
			init();
		}

		// setup scene ...
		protected function init():void {
			trace(LEVELNAME + "::init() entered...");
			//should be removed when init() is used in Level1... 
			//2014_0818: super.initialize();
			
			var b2d:Box2D = new Box2D("box2d");
			b2d.visible = false; // true: show enclosing box, false: show the graphics
			add(b2d);
			
			// turn level MovieClip into Citrus-level to use in the game...
			ObjectMaker2D.FromMovieClip(level);
			
			// create our hero from SWF-file...
			// hero.swf: hero = new Hero("hero", {x:heroStartX, y:heroStartY, width:66, height:92, view:"../sprites/hero.swf"});
			// 2014_0818 hero dragonbones - must be in GameLevel...
			hero = new Hero("hero", {x:heroStartX, y:heroStartY, width:66, height:92, offsetX:33, offsetY:46, view:arm});
			add(hero);
			
			// setup animation loops... i.a. repeat "idle"
			StarlingArt.setLoopAnimations(["idle"]);
			
			// voegtoe camera om hero te volgen, platform te scrollen etc...
			// camera setup volgens video tutorial, echter dat werkt niet in CE die ik gebruik....
			// 2014_0814 uitgaande van default-argumenten, bleek bounds nodig te zijn voor correcte camera view en meebewegen (center). 
			// 			 Overige parameters, zoals center en easing zijn default(null) of trial-and-error
			camera = view.camera as StarlingCamera;
			camera.setUp(hero
				, new Rectangle (0,0,gameWidth,gameHeight) 	/*bounding area for camera*/
				, null  						/*center point - must be default value*/
				, new Point(0.2, 0.2)			/*easing point - trial-and-error*/
			);
			camera.parallaxMode = ACitrusCamera.PARALLAX_MODE_TOPLEFT;
		}
		
		// update() is de plek waar elementen op scherm aangepast kunnen worden, 
		// zoals een hero die gevallen is (detectie met fall-sensor)
		override public function update(timeDelta:Number):void {
			super.update(timeDelta);
			if (reset) { resetHero(heroStartX, heroStartY); }
		}
		
		private function resetHero(x:int, y:int):void {
			hero.x = x;
			hero.y = y;
			reset = false; // vergeet niet de reset-flag ook te re-setten!
		}

		protected function onFall(contact:b2PolygonContact):void {
			trace(LEVELNAME + ": hero felt... TODO");
			reset = true;
		}
		
		// ouch, hero touches spikes...
		protected function onDie(contact:b2PolygonContact):void {
			if (Box2DUtils.CollisionGetOther(spikes, contact) is Hero) {
				trace(LEVELNAME + ": hero died a horrible spikey death!");
				reset = true; // update() regelt de rest...
			}
		}
		
		protected function onEnd(contact:b2PolygonContact):void {
			trace(LEVELNAME + ": hero has reached the end ... TODO");
		}

		
	} // endof class
} // endof package