import haxe.Json;
import flixel.FlxG;
class Public{
	public static var clientFolder:String = 'ClientSettings/';
	public static var gameFolder:String = 'GameSettings/';
	public static var antialiasing:Bool;
	public static var downscroll:Bool;
	public static var botplay:Bool;
	public static var endless:Bool;
	public static var map:Bool;
	public static var mid:Bool;
}
class Client{
	public static function loadJson(){
		CachingState.CacheConfig = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Public.gameFolder + 'EngineConfig', 'config')));
		CoolUtil.PushDiff = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Public.gameFolder + 'DifficultyPath', 'config')));
		StoryMenuState.StoryData = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Public.gameFolder + 'StoryConfig', 'config')));
		FreeplayState.FreeplayData = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Public.gameFolder + 'FreeplayConfig', 'config')));
		Options.Option.JsonOptions = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Public.clientFolder + 'OptionsConfig', 'config')));
	}
	public static function loadData(){
		// SCROLL
		if (FlxG.save.data.strumLineY == null){
			if (FlxG.save.data.downscroll)
				FlxG.save.data.strumLineY = 165;
			else
				FlxG.save.data.strumLineY = 0;
		}
		if (FlxG.save.data.splashScroll == null)
			FlxG.save.data.splashScroll = true;
		if (FlxG.save.data.noteKeybind == null)
			FlxG.save.data.noteKeybind = true;
		if (FlxG.save.data.strumMove == null)
			FlxG.save.data.strumMove = true;
		if (FlxG.save.data.middleScroll == null)
			FlxG.save.data.middleScroll = false;
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;
	
		// HUD DATA SAVE
		if (FlxG.save.data.laneScroll == null)
			FlxG.save.data.laneScroll = false;
		if (FlxG.save.data.laneTransparencyScroll == null)
			FlxG.save.data.laneTransparencyScroll = 0;
		if (FlxG.save.data.laneScore == null)
			FlxG.save.data.laneScore = true;
		if (FlxG.save.data.laneTransparencyScore == null)
			FlxG.save.data.laneTransparencyScore = 0.6;
		if (FlxG.save.data.scoreHUD == null)
			FlxG.save.data.scoreHUD = true;
		if (FlxG.save.data.scoreHUDTransparency == null)
			FlxG.save.data.scoreHUDTransparency = 1;
		if (FlxG.save.data.missesHUD == null)
			FlxG.save.data.missesHUD = true;
		if (FlxG.save.data.missesHUDTransparency == null)
			FlxG.save.data.missesHUDTransparency = 1;
		if (FlxG.save.data.accuracyHUD == null)
			FlxG.save.data.accuracyHUD = true;
		if (FlxG.save.data.accuracyHUDTransparency == null)
			FlxG.save.data.accuracyHUDTransparency = 1;
		if (FlxG.save.data.iconSprite == null)
			FlxG.save.data.iconSprite = 1;
		if (FlxG.save.data.iconTransparency == null)
			FlxG.save.data.iconTransparency = 1;
		if (FlxG.save.data.healthShitHUD == null)
			FlxG.save.data.healthShitHUD = true;
		if (FlxG.save.data.healthHUDTransparency == null)
			FlxG.save.data.healthHUDTransparency = 1;
		if (FlxG.save.data.ratingHUD == null)
			FlxG.save.data.ratingHUD = 2;
		if (FlxG.save.data.ratingSpriteTransparency == null)
			FlxG.save.data.ratingSpriteTransparency = 1;
		if (FlxG.save.data.comboHUD == null)
			FlxG.save.data.comboHUD = true;
		if (FlxG.save.data.ComboHUDTransparency == null)
			FlxG.save.data.ComboHUDTransparency = 1;
		if (FlxG.save.data.maxComboHUD == null)
			FlxG.save.data.maxComboHUD = true;
		if (FlxG.save.data.maxComboHUDTransparency == null)
			FlxG.save.data.maxComboHUDTransparency = 1;
		if (FlxG.save.data.hpHUDPercent == null)
			FlxG.save.data.hpHUDPercent = true;
		if (FlxG.save.data.hpHUDPercentTransparency == null)
			FlxG.save.data.hpHUDPercentTransparency = 1;
		if (FlxG.save.data.statsCounter == null)
			FlxG.save.data.statsCounter = false;
		if (FlxG.save.data.statsCounterTransparency == null)
			FlxG.save.data.statsCounterTransparency = 1;
		if (FlxG.save.data.trackTimeLeft == null)
			FlxG.save.data.trackTimeLeft = false;
		if (FlxG.save.data.trackTimeLeftTransparency == null)
			FlxG.save.data.trackTimeLeftTransparency = 1;
		if (FlxG.save.data.rating == null)
			FlxG.save.data.rating = 1;
		if (FlxG.save.data.ratingTransparency == null)
			FlxG.save.data.ratingTransparency = 1;
		if (FlxG.save.data.ratinghudcolor == null)
			FlxG.save.data.ratinghudcolor = true;
		if (FlxG.save.data.hitHUDEffect == null)
			FlxG.save.data.hitHUDEffect = true;
		if (FlxG.save.data.deathStats == null)
			FlxG.save.data.deathStats = true;
	
		// GAMEPLAY
		if (FlxG.save.data.offsetNote == null)
			FlxG.save.data.offsetNote = 0;
		if (FlxG.save.data.hudTweenHit == null)
			FlxG.save.data.hudTweenHit = true;
		if (FlxG.save.data.safeFrames == null)
			FlxG.save.data.safeFrames = 10;
		if (FlxG.save.data.endless == null)
			FlxG.save.data.endless = false;
		if (FlxG.save.data.opponentGlownHit == null)
			FlxG.save.data.opponentGlownHit = true;
		if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;
		if (FlxG.save.data.autoRespawn == null)
			FlxG.save.data.autoRespawn = false;
		if (FlxG.save.data.dfjk == null)
			FlxG.save.data.dfjk = false;
		if (FlxG.save.data.engineMark == null)
			FlxG.save.data.engineMark = true;
		if (FlxG.save.data.engineMarkTransparency == null)
			FlxG.save.data.engineMarkTransparency = 1;
		if (FlxG.save.data.engineMarkCustomization == null)
			FlxG.save.data.engineMarkCustomization = 0;
		if (FlxG.save.data.songArtistMark == null)
			FlxG.save.data.songArtistMark = true;
		if (FlxG.save.data.songArtistMarkTransparency == null)
			FlxG.save.data.songArtistMarkTransparency = 1;
		if (FlxG.save.data.scrollSpeed == null)
			FlxG.save.data.scrollSpeed = 1;
		if (FlxG.save.data.cameraFPS == null)
			FlxG.save.data.cameraFPS = 30;
		if (FlxG.save.data.mode == null)
			FlxG.save.data.mode = 0;
		if (FlxG.save.data.shitMs == null)
			FlxG.save.data.shitMs = 160.0;
		if (FlxG.save.data.badMs == null)
			FlxG.save.data.badMs = 135.0;
		if (FlxG.save.data.goodMs == null)
			FlxG.save.data.goodMs = 90.0;
		if (FlxG.save.data.sickMs == null)
			FlxG.save.data.sickMs = 45.0;
	
		// APARENCE & OPTIMIZE
		if (FlxG.save.data.map == null)
			FlxG.save.data.map = true;
		if (FlxG.save.data.antialiasing == null)
			FlxG.save.data.antialiasing = true;
		if (FlxG.save.data.visualDistractions == null)
			FlxG.save.data.visualDistractions = true;
		if (FlxG.save.data.colourCharIcon == null)
			FlxG.save.data.colourCharIcon = true;
		if (FlxG.save.data.flashingLightVisual == null)
			FlxG.save.data.flashingLightVisual = true;
		if (FlxG.save.data.visualEffects == null)
			FlxG.save.data.visualEffects = true;
		if (FlxG.save.data.shakeEffects == null)
			FlxG.save.data.shakeEffects = true;
	
		// MISC
		if (FlxG.save.data.missSounds == null)
			FlxG.save.data.missSounds = true;
		if (FlxG.save.data.fpsAndMemory == null)
			FlxG.save.data.fpsAndMemory = false;
		if (FlxG.save.data.resetButton == null)
			FlxG.save.data.resetButton = false;
		if (FlxG.save.data.autoPause == null)
			FlxG.save.data.autoPause = false;
		if (FlxG.save.data.botplay == null)
			FlxG.save.data.botplay = false;
	
		// CAM
		if (FlxG.save.data.cameramovehitnote == null)
			FlxG.save.data.cameramovehitnote = true;
		if (FlxG.save.data.camerazoom == null)
			FlxG.save.data.camerazoom = true;

		// OTHER
		if (FlxG.save.data.engineLanguage == null)
			FlxG.save.data.engineLanguage = 0; // Default (English)
		if (FlxG.save.data.cacheType == null)
			FlxG.save.data.cacheType = 0;
		if (FlxG.save.data.charSelect == null)
			FlxG.save.data.charSelect = 0;
		if (FlxG.save.data.subCharSelect == null)
			FlxG.save.data.subCharSelect = 0;
		Rating.hitMs =[
			FlxG.save.data.shitMs,
			FlxG.save.data.badMs,
			FlxG.save.data.goodMs,
			FlxG.save.data.sickMs
		];
		ConsoleCodeState.saveNullCodes(false);
		Conductor.refreshConductors();
		PlayerSettings.player1.controls.loadKeyBinds();
		KeyBinds.keyCheck();
		Main.engineMark = FlxG.save.data.engineMark;
		Public.map = FlxG.save.data.map;
		Public.mid = FlxG.save.data.middleScroll;
		Public.botplay = FlxG.save.data.botplay;
        Public.downscroll = FlxG.save.data.downscroll;
        Public.antialiasing = FlxG.save.data.antialiasing;
		Public.endless = FlxG.save.data.endless;
	}
}