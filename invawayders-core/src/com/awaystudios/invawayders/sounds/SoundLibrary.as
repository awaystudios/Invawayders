package com.awaystudios.invawayders.sounds
{
	import flash.media.*;
	import flash.utils.*;
	import com.awaystudios.invawayders.GameSettings;
	
	/**
	 * Singleton for managing the storage and playback of all game sounds.
	 */
	public class SoundLibrary
	{
		public static const PLAYER_FIRE:String = "sounds/player/fire";
		public static const EXPLOSION_SOFT:String = "sounds/fragments/soft";
		public static const EXPLOSION_STRONG:String = "sounds/fragments/strong";
		public static const INVAWAYDER_DEATH:String = "sounds/invawayder/death";
		public static const MOTHERSHIP:String = "sounds/mothership";
		public static const INVAWAYDER_FIRE:String = "sounds/boing";
		public static const THUCK:String = "sounds/thuck";
		public static const UFO:String = "sound/thuck1";
		public static const BOING:String = "sound/boing";
		
		private static var _instance:SoundLibrary;
		
		private var _sounds:Dictionary = new Dictionary();
		private var _volumes:Dictionary = new Dictionary();
		
		/**
		 * Returns a SoundLibrary instance
		 */
		public static function getInstance():SoundLibrary
		{
			if (_instance)
				return _instance;
			
			_instance = new SoundLibrary();
			_instance.registerSound( PLAYER_FIRE, new SoundShoot(), 0.25 );
			_instance.registerSound( INVAWAYDER_DEATH, new SoundInvawayderDeath() );
			_instance.registerSound( EXPLOSION_SOFT, new SoundExplosionSoft() );
			_instance.registerSound( EXPLOSION_STRONG, new SoundExplosionStrong() );
			_instance.registerSound( MOTHERSHIP, new SoundMothership() );
			_instance.registerSound( INVAWAYDER_FIRE, new SoundPlayerFire(), 0.5 );
			_instance.registerSound( THUCK, new SoundThuck() );
			_instance.registerSound( UFO, new SoundUfo(), 0.5 );
			_instance.registerSound( BOING, new SoundBoing() );
			
			return _instance;
		}
		
		/**
		 * Registers a sound object in the library, making it available for playback.
		 */
		public function registerSound( id:String, sound:Sound, globalVolume:Number = 1 ):void
		{
			_sounds[ id ] = sound;
			_volumes[ id ] = globalVolume;
		}
		
		/**
		 * Plays a sound object in the library
		 * 
		 * @param id A string representing the id of the sound to be played.
		 * @param volume A number representing the volume level of the sound to be played. Defaults to 1.
		 */
		public function playSound( id:String, volume:Number = 1 ):void
		{
			if( !GameSettings.useSound )
				return;
			
			var sound:Sound = _sounds[ id ] as Sound;
			var channel:SoundChannel = sound.play();
			channel.soundTransform = new SoundTransform( volume * (_volumes[ id ] as Number) );
		}
	}
}
