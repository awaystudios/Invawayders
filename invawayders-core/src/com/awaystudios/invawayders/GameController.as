package com.awaystudios.invawayders
{
	import com.awaystudios.invawayders.archetypes.*;
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.input.*;
	import com.awaystudios.invawayders.nodes.*;
	import com.awaystudios.invawayders.sounds.*;
	import com.awaystudios.invawayders.systems.*;
	import com.awaystudios.invawayders.utils.*;
	
	import away3d.containers.*;
	import away3d.materials.lightpickers.*;
	
	import ash.core.*;
	import ash.integration.swiftsuspenders.*;
	import ash.signals.*;
	import ash.tick.*;
	
	import flash.geom.*;
	
	import org.swiftsuspenders.*;
	
	public class GameController
	{
		private var view : View3D;
		private var soundLibrary : SoundLibrary;
		private var accelerometerPoll : AccelerometerPoll;
		private var injector : Injector;
		private var engine : SwiftSuspendersEngine;
		
		private var gameManager : GameManager;
		
		private var entityCreator : EntityManager;
		
		private var tickProvider : FrameTickProvider;
		
		/**
		 * A signal that is dispatched whenever the game state is updated
		 */
		public var gameStateUpdated : Signal1 = new Signal1( GameState );

		public function GameController( view : View3D, saveStateManager : SaveStateManager, cameraLightPicker : StaticLightPicker, lightPicker : StaticLightPicker, stageProperties : StageProperties )
		{
			this.view = view;
			
			//setup the sound library
			soundLibrary = SoundLibrary.getInstance();
			
			//setup accelerometer poll
			accelerometerPoll = new AccelerometerPoll();
			
			//setup injector for game
			injector = new Injector();
			engine = new SwiftSuspendersEngine( injector );
			
			//establish injector maps
			injector.map( Engine ).toValue( engine );
			injector.map( View3D ).toValue( view );
			injector.map( StaticLightPicker, "cameraLightPicker" ).toValue( cameraLightPicker );
			injector.map( StaticLightPicker, "lightPicker" ).toValue( lightPicker );
			injector.map( SaveStateManager ).toValue( saveStateManager );
			injector.map( StageProperties ).toValue( stageProperties );
			injector.map( SoundLibrary ).toValue( soundLibrary );
			injector.map( EntityManager ).asSingleton();
			injector.map( KeyPoll ).toValue( new KeyPoll( view.stage ) );
			injector.map( MousePoll ).toValue( new MousePoll( view ) );
			injector.map( AccelerometerPoll ).toValue( accelerometerPoll );
			injector.map( Signal1 ).toValue( gameStateUpdated );
			
			//create game manager system
			gameManager = new GameManager();
			
			//add game systems
			engine.addSystem( gameManager, SystemPriorities.manager );
			engine.addSystem( new AnimationSystem(), SystemPriorities.animations );
			engine.addSystem( new PlayerControlSystem(), SystemPriorities.control );
			engine.addSystem( new MovementSystem(), SystemPriorities.move );
			engine.addSystem( new CollisionSystem(), SystemPriorities.collisions );
			engine.addSystem( new RenderSystem(), SystemPriorities.render );
			
			//create entity creator
			entityCreator = injector.getInstance( EntityManager );
			
			//setup the tick provider
			tickProvider = new FrameTickProvider( view );
			tickProvider.add( engine.update );
			
			//upload all archetypes content to the gpu
			var archetype:ArchetypeBase;
			var i:uint;
			var entity : Entity;
			for each (archetype in ArchetypeLibrary.archetypes) {
				if (archetype.subTypes.length) {
					for (i=0;i< archetype.subTypes.length; i++) {
						entity = entityCreator.createEntity(0, 0, 0, new Vector3D(), archetype.id, i);
						(entity.get(Display) as Display).container.z = 80000;
					}
				} else {
					entity = entityCreator.createEntity(0, 0, 100000, new Vector3D(), archetype.id);
					(entity.get(Display) as Display).container.z = 80000;
				}
			}
			
			//add sound system after object have been initialised
			engine.addSystem( new SoundSystem(), SystemPriorities.sounds );
		}
		
		/**
		 * Restarts the game. Called by the play button or restart button
		 */
		public function restart():void
		{
			// Reset all game entities
			var entity : Entity;
			for each (entity in engine.entities)
				entityCreator.destroyEntity(entity);
			
			//create a new game
			entityCreator.createGame();
			
			//resume play
			resume();
		}
		
		/**
		 * Halts the game logic. Called by the pause button or when the player's lives decrease to zero
		 */
		public function pause():void
		{
			//play sound
			soundLibrary.playSound( SoundLibrary.UFO, 0.5 );
			
			//remove player node
			entityCreator.destroyEntity(engine.getNodeList(PlayerNode).head.entity);
			
			tickProvider.stop();
		}
		
		/**
		 * Resumes the game. Called on game start or by the resume button.
		 */
		public function resume():void
		{
			//play sound
			soundLibrary.playSound( SoundLibrary.UFO, 0.5 );
			
			//reset accelerometer center
			accelerometerPoll.centerY = accelerometerPoll.accelerometerY;
			
			//reset spawn times
			var id : uint;
			var invawayderArchetype : InvawayderArchetype;
			for each (id in InvawayderArchetype.invawayders) {
				invawayderArchetype = ArchetypeLibrary.getArchetype(ArchetypeLibrary.INVAWAYDER).getSubType(id) as InvawayderArchetype;
				invawayderArchetype.spawnTimer = invawayderArchetype.spawnRate * gameManager.games.head.state.spawnTimeFactor * MathUtils.rand( 0.9, 1.1 );
			}
			
			entityCreator.createEntity(0, 0, -1000, new Vector3D(), ArchetypeLibrary.PLAYER);
			
			tickProvider.start();
		}
		
		
		/**
		 * Ends the game. Called on game over.
		 */
		public function end():void
		{
			//remove game
			entityCreator.destroyEntity(engine.getNodeList(GameNode).head.entity);
			
			//remove player node
			entityCreator.destroyEntity(engine.getNodeList(PlayerNode).head.entity);
		}
	}
}
