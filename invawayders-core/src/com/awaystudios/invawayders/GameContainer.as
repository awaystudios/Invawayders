package com.awaystudios.invawayders
{
	import com.awaystudios.invawayders.components.*;
	import com.awaystudios.invawayders.utils.*;
	
	import away3d.containers.*;
	import away3d.debug.*;
	import away3d.entities.*;
	import away3d.lights.*;
	import away3d.materials.*;
	import away3d.materials.lightpickers.*;
	import away3d.primitives.*;
	import away3d.textures.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.system.*;
	import flash.text.*;
	import flash.ui.*;
	
	public class GameContainer extends Sprite
	{
		//skybox textures
		[Embed(source="/../embeds/skybox/space_posX.jpg")]
		private var SkyboxImagePosX:Class;
		[Embed(source="/../embeds/skybox/space_negX.jpg")]
		private var SkyboxImageNegX:Class;
		[Embed(source="/../embeds/skybox/space_posY.jpg")]
		private var SkyboxImagePosY:Class;
		[Embed(source="/../embeds/skybox/space_negY.jpg")]
		private var SkyboxImageNegY:Class;
		[Embed(source="/../embeds/skybox/space_posZ.jpg")]
		private var SkyboxImagePosZ:Class;
		[Embed(source="/../embeds/skybox/space_negZ.jpg")]
		private var SkyboxImageNegZ:Class;
		
		//engine variables
		private var _view : View3D;
		
		//scene variables
		private var _cameraLightPicker:StaticLightPicker;
		private var _lightPicker:StaticLightPicker;
		private var _cubeMap:BitmapCubeTexture;
		
		private var _invawayders : GameController;
		
		protected var _saveStateManager : SaveStateManager;
		protected var _stageProperties : StageProperties;
		
		//interaction variables
		private var _showingMouse:Boolean = true;
		
		//hud variables
		private var _hudContainer:Sprite;
		private var _scoreText:TextField;
		private var _livesText:TextField;
		private var _restartButton:MovieClip;
		private var _pauseButton:MovieClip;
		
		//popup variables
		private var _activePopUp:MovieClip;
		private var _popUpContainer:Sprite;
		private var _splashPopUp:MovieClip;
		private var _playButton:MovieClip;
		private var _pausePopUp:MovieClip;
		private var _resumeButton:MovieClip;
		private var _gameOverPopUp:MovieClip;
		private var _goScoreText:TextField;
		private var _goHighScoreText:TextField;
		private var _playAgainButton:MovieClip;
		private var _liveIconsContainer:Sprite;
		private var _crossHair:Sprite;
		
		public function GameContainer(saveStateManager:SaveStateManager)
		{
			_saveStateManager = saveStateManager;
			
			addEventListener( Event.ADDED_TO_STAGE, init );
		}
		
		private function init( event : Event ) : void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			initGlobal();
			initEngine();
			initScene();
			initHUD();
			initGame();
			initListeners();
		}
		
		/**
		 * Initialise the global settings of the game
		 */		
		protected function initGlobal():void
		{
			//set stage properties
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_stageProperties = new StageProperties();
			
			//determine the platform we are running on (used for screen dimension variables)
			var man:String = Capabilities.manufacturer;
			_stageProperties.isDesktop = (man.indexOf('Win')>=0 || man.indexOf('Mac')>=0);
		}
		
		/**
		 * Initialise the engine
		 */
		private function initEngine():void
		{
			//setup the 3d view
			_view = new View3D();
			_view.addSourceURL("srcview/index.html");
			_view.camera.lens.near = 50;
			_view.camera.lens.far = 100000;
			_view.camera.z = -2000;
			addChild( _view );
			
			// add awaystats if in debug mode
			if( GameSettings.debugMode ) {
				addChild( new AwayStats( _view ) );
				_view.scene.addChild( new Trident() );
			}
		}
		
		private function initScene():void
		{
			// initialise lights
			var frontLight:DirectionalLight = new DirectionalLight();
			frontLight.direction = new Vector3D( 0.5, 0, 1 );
			frontLight.color = 0xFFFFFF;
			frontLight.ambient = 0.1;
			frontLight.ambientColor = 0xFFFFFF;
			_view.scene.addChild( frontLight );
			var cameraLight : PointLight = new PointLight();
			cameraLight.y = 500;
			cameraLight.z = 1000;
			_view.camera.addChild( cameraLight );
			_cameraLightPicker = new StaticLightPicker( [ cameraLight ] );
			_lightPicker = new StaticLightPicker( [ frontLight ] );


			// create skybox texture
			_cubeMap = new BitmapCubeTexture(
				new SkyboxImagePosX().bitmapData, new SkyboxImageNegX().bitmapData,
				new SkyboxImagePosY().bitmapData, new SkyboxImageNegY().bitmapData,
				new SkyboxImagePosZ().bitmapData, new SkyboxImageNegZ().bitmapData
			);
			
			var cubeMaterial:SkyBoxMaterial = new SkyBoxMaterial(_cubeMap);
			cubeMaterial.bothSides = true;
			var cube:Mesh = new Mesh(new CubeGeometry(100000, 100000, 100000), cubeMaterial);
			
			_view.scene.addChild( cube );
		}
		
		/**
		 * Initialise the game HUD
		 */		
		private function initHUD():void
		{
			// initialise the HUD container
			_hudContainer = new Sprite();
			addChild(_hudContainer);
			
			// initialise the cross hair graphic
			_crossHair = new Crosshair();
			_hudContainer.addChild( _crossHair );
			
			// initialise the score text
			var scoreClip:CustomTextField = new CustomTextField();
			_scoreText = scoreClip.tf;
			_hudContainer.addChild( _scoreText );
			
			// initialise the lives text
			var livesClip:CustomTextField = new CustomTextField();
			_livesText = livesClip.tf;
			_hudContainer.addChild( _livesText );
			
			// initialise the lives icons
			_liveIconsContainer = new Sprite();
			_hudContainer.addChild( _liveIconsContainer );
			for( var i:uint; i < GameSettings.playerLives; i++ ) {
				var live:Sprite = new InvawayderLive();
				live.x = i * ( live.width + 5 );
				_liveIconsContainer.addChild( live );
			}
			
			// initialise the restart button
			_restartButton = new RestartButton();
			_restartButton.buttonMode = true;
			_restartButton.mouseChildren = false;
			_restartButton.stop();
			_restartButton.addEventListener( MouseEvent.MOUSE_UP, onRestart );
			_hudContainer.addChild( _restartButton );
			
			// initialise the pause button
			_pauseButton = new PauseButton();
			_pauseButton.buttonMode = true;
			_pauseButton.mouseChildren = false;
			_pauseButton.stop();
			_pauseButton.addEventListener( MouseEvent.MOUSE_UP, onPause );
			_hudContainer.addChild( _pauseButton );
			
			// initialise the popup container
			_popUpContainer = new Sprite();
			addChild(_popUpContainer);
			
			// initialise the splash popup
			_splashPopUp = new SplashPopUp();
			_splashPopUp.visible = false;
			_popUpContainer.addChild(_splashPopUp);
			_playButton = _splashPopUp.playButton;
			_playButton.buttonMode = true;
			_playButton.mouseChildren = false;
			_playButton.stop();
			_playButton.addEventListener( MouseEvent.MOUSE_UP, onRestart );
			
			// initialise the pause popup
			_pausePopUp = new PausePopUp();
			_pausePopUp.visible = false;
			_popUpContainer.addChild(_pausePopUp);
			_resumeButton = _pausePopUp.resumeButton;
			_resumeButton.buttonMode = true;
			_resumeButton.mouseChildren = false;
			_resumeButton.stop();
			_resumeButton.addEventListener( MouseEvent.MOUSE_UP, onResume );
			
			// initialise the game over popup
			_gameOverPopUp = new GameOverPopUp();
			_gameOverPopUp.visible = false;
			_popUpContainer.addChild(_gameOverPopUp);
			_playAgainButton = _gameOverPopUp.playAgainButton;
			_playAgainButton.buttonMode = true;
			_playAgainButton.mouseChildren = false;
			_playAgainButton.stop();
			_playAgainButton.addEventListener( MouseEvent.MOUSE_UP, onRestart, false, 0, true );
			_goScoreText = _gameOverPopUp.scoreText;
			_goHighScoreText = _gameOverPopUp.highScoreText;
			
			// set the splash popup to visible
			showPopUp( _splashPopUp );
		}
		
		/**
		 * Initialise the game
		 */		
		private function initGame():void
		{
			_invawayders = new GameController( _view, _saveStateManager, _cameraLightPicker, _lightPicker, _stageProperties );
			_invawayders.gameStateUpdated.add(onUpdateGameState);
		}
		
		/**
		 * Initialise the listeners
		 */
		private function initListeners():void
		{
			stage.addEventListener( Event.RESIZE, onResize);
			stage.addEventListener( Event.ENTER_FRAME, onEnterFrame);
			onResize();
		}
		
		/**
		 * Hides the active popup.
		 */
		private function hidePopUp():void
		{
			_stageProperties.popupVisible = false;
			
			_hudContainer.visible = true;
			_activePopUp.visible = false;
		}
		
		/**
		 * Shows the popup defined in the argument.
		 * 
		 * @param popUp The moviecip containing the desired popup graphics.
		 */
		private function showPopUp( popUp:MovieClip ):void
		{
			_stageProperties.popupVisible = true;
			
			_activePopUp = popUp;
			_hudContainer.visible = false;
			_activePopUp.visible = true;
		}
		
		/**
		 * Hides the mouse cursor for desktop implementations.
		 */
		private function hideMouse():void
		{
			if( !_showingMouse )
				return;
			
			Mouse.hide();
			
			_showingMouse = false;
		}
		
		/**
		 * Shows the mouse cursor for desktop implementations.
		 */
		private function showMouse():void
		{
			if( _showingMouse )
				return;
			
			Mouse.show();
			
			_showingMouse = true;
		}
		
		/**
		 * Updates the UI to reflect the current game state
		 */
		private function onUpdateGameState( gameState : GameState):void
		{
			// Update lives icons.
			for( var i:uint; i < GameSettings.playerLives; i++ )
				_liveIconsContainer.getChildAt( i ).visible = gameState.lives >= i + 1;
			
			// Update lives text.
			_livesText.text = "LIVES " + gameState.lives + "";
			_livesText.width = _livesText.textWidth * 1.05;
			
			//Update score text
			_scoreText.text = "SCORE " + StringUtils.uintToSameLengthString( gameState.score, 5 ) + "   HIGH-SCORE " + StringUtils.uintToSameLengthString( gameState.highScore, 5 );
			_scoreText.width = int(_scoreText.textWidth * 1.05);
			
			//reset layout to account for lives and score text
			onResize();
			
			if (!gameState.lives && !_stageProperties.popupVisible) {
				//prepare game over popup
				_goScoreText.text =     "SCORE................................... " + StringUtils.uintToSameLengthString( gameState.score, 5 );
				_goHighScoreText = _gameOverPopUp.highScoreText;
				_goHighScoreText.text = "HIGH-SCORE.............................. " + StringUtils.uintToSameLengthString( gameState.highScore, 5 );
				_goScoreText.width = int(_goScoreText.textWidth * 1.05);
				_goScoreText.x = -int(_goScoreText.width / 2);
				_goHighScoreText.width = int(_goHighScoreText.textWidth * 1.05);
				_goHighScoreText.x = -int(_goHighScoreText.width / 2);
				
				showPopUp( _gameOverPopUp );
				
				_invawayders.end();
			}
		}
		
		// -----------------------------
		// User interface event handlers.
		// -----------------------------
		
		/**
		 * Button handler for mouse events, broadcast when the resume button is clicked.
		 */
		private function onResume( event:MouseEvent ):void
		{
			hidePopUp();
			
			_invawayders.resume();
		}
		
		/**
		 * Button handler for mouse events, broadcast when the pause button is clicked.
		 */
		private function onPause( event:MouseEvent ):void
		{
			showPopUp( _pausePopUp );
			
			_invawayders.pause();
		}
		
		/**
		 * Button handler for mouse events, broadcast when the restart button is clicked.
		 */
		private function onRestart( event:MouseEvent ):void
		{
			hidePopUp();
			
			_invawayders.restart();
		}
		
		/**
		 * Handler for enterframe events from the stage
		 */
		private function onEnterFrame(event:Event):void
		{
			_view.render();
			
			if( _stageProperties.popupVisible || mouseY < 50*_stageProperties.scale )
				showMouse();
			else
				hideMouse();
		}
		
		/**
		 * Handler for resize events from the stage
		 */
		private function onResize(event:Event = null):void
		{
			var w : uint, h : uint, hw : uint, hh : uint, scale : Number;
			
			_stageProperties.width = w = _stageProperties.isDesktop? stage.stageWidth : stage.fullScreenWidth;
			_stageProperties.height = h = _stageProperties.isDesktop? stage.stageHeight : stage.fullScreenHeight;
			_stageProperties.halfWidth = hw = w/2;
			_stageProperties.halfHeight = hh = h/2;
			
			//adjust the scale of buttons and text according to the resolution
			if (w < 800) {
				_stageProperties.scale = 0.5; //smaller mobile handsets
			} else if (w > 1600) {
				_stageProperties.scale = 2; //large cinema displays and ipad3
			} else {
				_stageProperties.scale = 1; // normal resolution
			}
			scale = _stageProperties.scale;
			
			//update view size
			_view.width = w;
			_view.height = h;
			
			//update crosshair & popup position
			_popUpContainer.scaleX = _popUpContainer.scaleY = scale;
			_popUpContainer.x = _crossHair.x = hw;
			_popUpContainer.y = _crossHair.y = hh;
			
			//update lives text position
			_livesText.scaleX = _livesText.scaleY = scale;
			_livesText.x = hw - _livesText.width / 2 - _liveIconsContainer.width / 2 - 5*scale;
			_livesText.y = h - 35*scale;
			
			_liveIconsContainer.scaleX = _liveIconsContainer.scaleY = scale;
			_liveIconsContainer.x = _livesText.x + _livesText.width + 10*scale;
			_liveIconsContainer.y = _livesText.y + 8*scale;
			
			_restartButton.scaleX = _restartButton.scaleY = scale;
			
			_pauseButton.scaleX = _pauseButton.scaleY = scale;
			_pauseButton.x = w - _pauseButton.width;
			
			_scoreText.scaleX = _scoreText.scaleY = scale;
			_scoreText.x = hw - _scoreText.width / 2 + 20*scale;
			_scoreText.y = 7*scale;
		}
	}
}
