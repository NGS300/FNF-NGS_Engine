package;
import haxe.Json;
import flixel.FlxG;
import openfl.Lib;
typedef OptionsJson ={
	var ?laneTransparencyScroll:Float;
	var ?laneTransparencyScore:Float;
	var UseKadeEngineHitNote:Bool;
	var ScrollLineY:Null<Float>;
	var UseNewNoteSytle:Bool;
	var laneOpponent:Bool;
	var lanePlayer:Bool;
} 
class Option{
	public static var JsonOptions:OptionsJson;
	private var acceptValues:Bool = false;
	public var waitingPress:Bool = false;
	public var acceptPress:Bool = false;
	private var description:String = "";
	private var display:String;
	public function onPress(text:String){
	}
	public final function getDisplay():String{
		return display;
	}
	public final function getAccept():Bool{
		return acceptValues;
	}
	public final function getDescription():String{
		return description;
	}
	public function getValue():String{
		return updateDisplay();
	};
	public function new(){
		display = updateDisplay();
	}
	private function updateDisplay():String{
		return "";
	}
	public function press():Bool{
		return true;
	}
	public function shift():Bool{
		return true;
	}
	public function ctrl():Bool{
		return true;
	}
	public function left():Bool{
		return false;
	}
	public function right():Bool{
		return false;
	}
	public final function num():Int{
		return 1;
	}
}
class OpenSubOptions extends Option{ // OPEN SUB TO EDIT
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{ // EDIT HUD
		OptionsMenu.instance.selectedCatIndex = 6;
		OptionsMenu.instance.switchCat(OptionsMenu.instance.options[6], false);
		OptionsMenu.itIsNecessaryToRestart = false;
		return false;
	}
	public override function shift():Bool{ // EDIT KEYBINDS
        OptionsMenu.instance.selectedCatIndex = 4;
        OptionsMenu.instance.switchCat(OptionsMenu.instance.options[4], false);
        OptionsMenu.itIsNecessaryToRestart = false;
        return false;
    }
	public override function ctrl():Bool{ // EDIT HITTING
        OptionsMenu.instance.selectedCatIndex = 5;
        OptionsMenu.instance.switchCat(OptionsMenu.instance.options[5], false);
        OptionsMenu.itIsNecessaryToRestart = false;
        return true;
    }
	private override function updateDisplay():String{
		return "Edit HUD" + ' - ' + "Edit Keybindings" + ' - ' + "Edit Offset Hit";
	}
}
class GraphicOption extends Option{ // Affect FPS
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.visualDistractions = !FlxG.save.data.visualDistractions;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.antialiasing = !FlxG.save.data.antialiasing;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function ctrl():Bool{
		FlxG.save.data.map = !FlxG.save.data.map;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Graphics: < " + (FlxG.save.data.visualDistractions ? "Distractions: Enabled" : "Distractions: Disabled") + " - " + (FlxG.save.data.antialiasing ? "Antialiasing: Enabled" : "Antialiasing: Disabled") + " - " + (FlxG.save.data.map ? "Map: Enabled" : "Map: Disabled") + " >";
	}
}
class VisualOption extends Option{ // Gameplay Visual
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.visualEffects = !FlxG.save.data.visualEffects;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.flashingLightVisual = !FlxG.save.data.flashingLightVisual;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function ctrl():Bool{
		FlxG.save.data.shakeEffects = !FlxG.save.data.shakeEffects;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Visual: < " + (FlxG.save.data.visualEffects ? "Effects: Enabled" : "Effects: Disabled") + " - " + (FlxG.save.data.flashingLightVisual ? "FL: Enabled" : "FL: Disabled") + " - " + (FlxG.save.data.shakeEffects ? "Shake: Enabled" : "Shake: Disabled") + " >";
	}
}
class GaymingOption extends Option{ // Gayming Option
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.newInput = !FlxG.save.data.newInput;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.colourCharIcon = !FlxG.save.data.colourCharIcon;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function ctrl():Bool{
		FlxG.save.data.missSounds = !FlxG.save.data.missSounds;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Gameplay: < " + (FlxG.save.data.newInput ? "Input: New" : "Input: Old") + " - " + (FlxG.save.data.colourCharIcon ? "HP Colours: Enabled" : "HP Colours: Disabled") + " - " + (FlxG.save.data.missSounds ? "MissSounds: Enabled" : "MissSounds: Disabled") + " >";
	}
}
class OtherOption extends Option{ // is Other Type Option
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.autoRespawn = !FlxG.save.data.autoRespawn;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.resetButton = !FlxG.save.data.resetButton;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function ctrl():Bool{
		FlxG.save.data.autoPause = !FlxG.save.data.autoPause;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Other: < " + (FlxG.save.data.autoRespawn ? "Auto Respawn: Enabled" : "Auto Respawn: Disabled") + " - " + (FlxG.save.data.resetButton ? "Die Key: Enabled" : "Die Key: Disabled") + " - " + (FlxG.save.data.autoPause ? "Auto Pause: Enabled" : "Auto Pause: Disabled") + " >";
	}
}
class CameraOption extends Option{ // Camera Option
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press():Bool{
		FlxG.save.data.camerazoom = !FlxG.save.data.camerazoom;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function ctrl():Bool{
		FlxG.save.data.cameramovehitnote = !FlxG.save.data.cameramovehitnote;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.cameraFPS -= 5;
		else
       		FlxG.save.data.cameraFPS--;
        if (FlxG.save.data.cameraFPS < 0)
            FlxG.save.data.cameraFPS = 0;
        display = updateDisplay();
        OptionsMenu.itIsNecessaryToRestart = true;
        return true;
    }
    public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.cameraFPS += 5;
		else
        	FlxG.save.data.cameraFPS++;
        display = updateDisplay();
        OptionsMenu.itIsNecessaryToRestart = true;
        return true;
    }
	public override function onPress(char:String){
        if (char.toLowerCase() == "r"){
            FlxG.save.data.cameraFPS = 30;
            OptionsMenu.itIsNecessaryToRestart = true;
        }
    }
	private override function updateDisplay():String{
		return "Camera: < " + (FlxG.save.data.camerazoom ? "Zoom: Enabled" : "Zoom: Disabled") + " - " + (FlxG.save.data.cameramovehitnote ? "Move: Enabled" : "Move: Disabled") + " - " + (FlxG.save.data.cameraFPS == 0 ? "FPS: Stopped" : "FPS: " + FlxG.save.data.cameraFPS) + " >";
	}
}
class ModesOption extends Option{ // GameModes
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
	}
	public override function press():Bool{
		if (!OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu) return false;
		FlxG.save.data.botplay = !FlxG.save.data.botplay;
		Client.loadData();
		if (PlayState.IsPlayState) (Client.Public.botplay ? PlayState.instance.botplayTxt.revive() : PlayState.instance.botplayTxt.kill());
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function shift():Bool{
        FlxG.save.data.endless = !FlxG.save.data.endless;
		Client.loadData();
        display = updateDisplay();
        OptionsMenu.itIsNecessaryToRestart = false;
        return true;
	}
	public override function left():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		FlxG.save.data.mode--;
		if (FlxG.save.data.mode < 0)
			FlxG.save.data.mode = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		FlxG.save.data.mode++;
		if (FlxG.save.data.mode > 3)
			FlxG.save.data.mode = 3;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.mode = 0;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		var dicktext:String = '';
		switch (FlxG.save.data.mode){
			case 0: dicktext = 'Normal';
			case 1: dicktext = 'Hard';
			case 2: dicktext = 'Hell';
			case 3: dicktext = 'Hybrid';
		}
		return "Game: < " + (FlxG.save.data.botplay ? "Botplay: Enabled" : "Botplay: Disabled") + " - " + (FlxG.save.data.endless ? "Endless: Enabled" : "Endless: Disabled") + " - " + dicktext + " mode" + " >";
	}
}
class ResetTypeOption extends Option{ // Reset TYPES oPTIONS
	var confirmHighScore:Bool = false;
	var confirmResetSetting:Bool = false;
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			description = "This Option Cannot be Toggled In The Pause Menu.";
		else
			description = desc;
	}
	public override function shift():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		if (!confirmHighScore){
			confirmHighScore = true;
			display = updateDisplay();
			return true;
		}
		resetType('Highscore', true);
		confirmHighScore = false;
		trace('Reseted Highscores');
		display = updateDisplay();
		return true;
	}
	public override function ctrl():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		if (!confirmResetSetting){
			confirmResetSetting = true;
			display = updateDisplay();
			return true;
		}
		resetType('Settings', true);
		confirmResetSetting = false;
		trace('Resetted Settings');
		display = updateDisplay();
		return true;
	}
	private override function updateDisplay():String{
		return (confirmHighScore ? "Confirm HighScore Reset" : "Reset HighScore") + " - " + (confirmResetSetting ? "Confirm Settings Reset" : "Reset Settings");
	}
	public static function resetType(typeReset:String, ?allThisType:Bool = false){
		switch (typeReset){
			case 'Highscore': // RESET HIGHSCORE
				if (!allThisType){
					if (Client.Public.endless){
						if (PlayState.stateShit == 'FreeplayMenu'){
							FlxG.save.data.songEndlessScores = null;
							for (key in Highscore.songEndlessScores.keys())
								Highscore.songEndlessScores[key] = 0;
						}
					}else{
						switch (PlayState.stateShit){
							case 'StoryMenu':
								FlxG.save.data.storySongScores = null;
								for (key in Highscore.storySongScores.keys())
									Highscore.storySongScores[key] = 0;
							case 'FreeplayMenu':
								FlxG.save.data.songScores = null;
								for (key in Highscore.songScores.keys())
									Highscore.songScores[key] = 0;
								FlxG.save.data.songMisses = null;
								for (key in Highscore.songMisses.keys())
									Highscore.songMisses[key] = 0;
								FlxG.save.data.songAccuracy = null;
								for (key in Highscore.songAccuracy.keys())
									Highscore.songAccuracy[key] = 0;
								FlxG.save.data.songComboMax = null;
								for (key in Highscore.songComboMax.keys())
									Highscore.songComboMax[key] = 0;
								FlxG.save.data.songRank = null;
								for (key in Highscore.songRating.keys())
									Highscore.songRating[key] = '';
								FlxG.save.data.songFCRank = null;
								for (key in Highscore.songFCRating.keys())
									Highscore.songFCRating[key] = '';
						}
					}
				}else{
					FlxG.save.data.storySongScores = null;
					for (key in Highscore.storySongScores.keys())
						Highscore.storySongScores[key] = 0;
					FlxG.save.data.songEndlessScores = null;
					for (key in Highscore.songEndlessScores.keys())
						Highscore.songEndlessScores[key] = 0;
					FlxG.save.data.songScores = null;
					for (key in Highscore.songScores.keys())
						Highscore.songScores[key] = 0;
					FlxG.save.data.songMisses = null;
					for (key in Highscore.songMisses.keys())
						Highscore.songMisses[key] = 0;
					FlxG.save.data.songAccuracy = null;
					for (key in Highscore.songAccuracy.keys())
						Highscore.songAccuracy[key] = 0;
					FlxG.save.data.songComboMax = null;
					for (key in Highscore.songComboMax.keys())
						Highscore.songComboMax[key] = 0;
					FlxG.save.data.songRank = null;
					for (key in Highscore.songRating.keys())
						Highscore.songRating[key] = '';
					FlxG.save.data.songFCRank = null;
					for (key in Highscore.songFCRating.keys())
						Highscore.songFCRating[key] = '';
				}
			case 'Settings': // RESET SETTINGS
				if (allThisType){
					FlxG.save.data.strumLineY = null;
					FlxG.save.data.splashScroll = null;
					FlxG.save.data.middleScroll = null;
					FlxG.save.data.downscroll = null;	
					FlxG.save.data.laneScroll = null;
					FlxG.save.data.laneTransparencyScroll = null;
					FlxG.save.data.laneScore = null;
					FlxG.save.data.laneTransparencyScore = null;
					FlxG.save.data.scoreHUD = null;
					FlxG.save.data.scoreHUDTransparency = null;
					FlxG.save.data.missesHUD = null;
					FlxG.save.data.missesHUDTransparency = null;
					FlxG.save.data.accuracyHUD = null;
					FlxG.save.data.accuracyHUDTransparency = null;
					FlxG.save.data.iconSprite = null;
					FlxG.save.data.iconTransparency = null;
					FlxG.save.data.healthShitHUD = null;
					FlxG.save.data.healthHUDTransparency = null;
					FlxG.save.data.ratingHUD = null;
					FlxG.save.data.ratingSpriteTransparency = null;
					FlxG.save.data.comboHUD = null;
					FlxG.save.data.ComboHUDTransparency = null;
					FlxG.save.data.maxComboHUD = null;
					FlxG.save.data.maxComboHUDTransparency = null;
					FlxG.save.data.hpHUDPercent = null;
					FlxG.save.data.hpHUDPercentTransparency = null;
					FlxG.save.data.statsCounter = null;
					FlxG.save.data.statsCounterTransparency = null;
					FlxG.save.data.trackTimeLeft = null;
					FlxG.save.data.trackTimeLeftTransparency = null;
					FlxG.save.data.rating = null;
					FlxG.save.data.ratingTransparency = null;
					FlxG.save.data.ratinghudcolor = null;
					FlxG.save.data.hitHUDEffect = null;
					FlxG.save.data.offsetNote = null;
					FlxG.save.data.hudTweenHit = null;
					FlxG.save.data.safeFrames = null;
					FlxG.save.data.endless = null;
					FlxG.save.data.opponentGlownHit = null;
					FlxG.save.data.newInput = null;
					FlxG.save.data.autoRespawn = null;
					FlxG.save.data.dfjk = null;
					FlxG.save.data.engineMark = null;
					FlxG.save.data.engineMarkTransparency = null;
					FlxG.save.data.engineMarkCustomization = null;
					FlxG.save.data.songArtistMark = null;
					FlxG.save.data.songArtistMarkTransparency = null;
					FlxG.save.data.scrollSpeed = null;
					FlxG.save.data.cameraFPS = null;
					FlxG.save.data.mode = null;
					FlxG.save.data.shitMs = null;
					FlxG.save.data.badMs = null;
					FlxG.save.data.goodMs = null;
					FlxG.save.data.sickMs = null;
					FlxG.save.data.map = null;
					FlxG.save.data.antialiasing = null;
					FlxG.save.data.visualDistractions = null;
					FlxG.save.data.colourCharIcon = null;
					FlxG.save.data.flashingLightVisual = null;
					FlxG.save.data.visualEffects = null;
					FlxG.save.data.shakeEffects = null;
					FlxG.save.data.missSounds = null;
					FlxG.save.data.fpsAndMemory = null;
					FlxG.save.data.resetButton = null;
					FlxG.save.data.autoPause = null;
					FlxG.save.data.botplay = null;
					FlxG.save.data.cameramovehitnote = null;
					FlxG.save.data.camerazoom = null;
					FlxG.save.data.moddingTools = null;
					FlxG.save.data.cacheType = null;
					FlxG.save.data.engineLanguage = null;
					FlxG.save.data.charSelect = null;
					FlxG.save.data.subCharSelect = null;
					ConsoleCodeState.saveNullCodes(true);
					Client.loadData();
					Client.loadJson();
					Conductor.refreshConductors();
					PlayerSettings.player1.controls.loadKeyBinds();
					KeyBinds.keyCheck();
				}
		}
	}
}
class ScrollOptions extends Option{ // Scrolls Options
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press():Bool{
		FlxG.save.data.middleScroll = !FlxG.save.data.middleScroll;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
		(cast (Lib.current.getChildAt(0), Main)).setYFps(FlxG.save.data.downscroll ? 0 : 675);
		if (FlxG.save.data.downscroll)
			FlxG.save.data.strumLineY = 165;
		else
			FlxG.save.data.strumLineY = 50;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.scrollSpeed -= 0.1;
			else
				FlxG.save.data.scrollSpeed -= 0.01;
			if (FlxG.save.data.scrollSpeed < 1)
				FlxG.save.data.scrollSpeed = 1;
		}else{
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.strumLineY -= 0.1;
			else
				FlxG.save.data.strumLineY--;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.scrollSpeed += 0.1;
			else
				FlxG.save.data.scrollSpeed += 0.01;
			if (FlxG.save.data.scrollSpeed > 8)
				FlxG.save.data.scrollSpeed = 8;
		}else{
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.strumLineY += 0.1;
			else
				FlxG.save.data.strumLineY++;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			if (FlxG.save.data.downscroll)
				FlxG.save.data.strumLineY = 165;
			else
				FlxG.save.data.strumLineY = 50;
			FlxG.save.data.scrollSpeed = 1;
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		return "Scroll: < " + (FlxG.save.data.middleScroll ? "Middle" : "Disabled") + " - " + (FlxG.save.data.downscroll ? "Downscrolling" : "Upscrolling") + " - Y: " + (FlxG.save.data.downscroll ? (FlxG.save.data.strumLineY == 165 ? "Default" : FlxG.save.data.strumLineY) : (FlxG.save.data.strumLineY == 50 ? "Default" : FlxG.save.data.strumLineY)) + " - " + (FlxG.save.data.scrollSpeed == 1 ? "Speed: Chart" : "Speed: " + FlxG.save.data.scrollSpeed) + " >";
	}
}
class NoteOption extends Option{ // Notes Options
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function press():Bool{
		FlxG.save.data.splashScroll = !FlxG.save.data.splashScroll;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			/*FlxG.save.data.noteskin--;
			if (FlxG.save.data.noteskin < 0)
				FlxG.save.data.noteskin = ?.?().length - 1;*/
		}else{
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.offsetNote -= 10;
			else
				FlxG.save.data.offsetNote--;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			/*FlxG.save.data.noteSkin++;
			if (FlxG.save.data.noteSkin > ?.?().length - 1)
				FlxG.save.data.noteSkin = 0;*/
		}else{
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.offsetNote += 10;
			else
				FlxG.save.data.offsetNote++;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.offsetNote = 0;
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		/*var skins:String = '';
		switch (FlxG.save.data.noteSkin){
			case 0: skins = 'Arrow';
		}*/
		return "Note: < " + (FlxG.save.data.splashScroll ? "Splash: Enabled" : "Splash: Disabled") + /*" - " + "Skin: " + skins + */" - " + (FlxG.save.data.offsetNote == 0 ? "Offset: Default" : "Offset: " + FlxG.save.data.offsetNote) + " >";
	}
}
class SickMSOption extends Option{ // MS HIT SICK
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.sickMs -= 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.sickMs -= 0.01;
		else
			FlxG.save.data.sickMs--;
		if (FlxG.save.data.sickMs < 0)
			FlxG.save.data.sickMs = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.sickMs += 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.sickMs += 0.01;
		else
			FlxG.save.data.sickMs++;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.sickMs = 45;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		return "Sick: < " + (FlxG.save.data.sickMs == 45 ? "Default" : FlxG.save.data.sickMs) + " ms >";
	}
}
class GoodMsOption extends Option{ // MS HIT GOOD
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.goodMs -= 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.goodMs -= 0.01;
		else
			FlxG.save.data.goodMs--;
		if (FlxG.save.data.goodMs < 0)
			FlxG.save.data.goodMs = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.goodMs += 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.goodMs += 0.01;
		else
			FlxG.save.data.goodMs++;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.goodMs = 90;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		return "Good: < " + (FlxG.save.data.goodMs == 90 ? "Default" : FlxG.save.data.goodMs) + " ms >";
	}
}
class BadMsOption extends Option{ // MS HIT BAD
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.badMs -= 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.badMs -= 0.01;
		else
			FlxG.save.data.badMs--;
		if (FlxG.save.data.badMs < 0)
			FlxG.save.data.badMs = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.badMs += 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.badMs += 0.01;
		else
			FlxG.save.data.badMs++;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.badMs = 135;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		return "Bad: < " + (FlxG.save.data.badMs == 135 ? "Default" : FlxG.save.data.badMs) + " ms >";
	}
}
class ShitMsOption extends Option{ // MS HIT SHIT
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.shitMs -= 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.shitMs -= 0.01;
		else
			FlxG.save.data.shitMs--;
		if (FlxG.save.data.shitMs < 0)
			FlxG.save.data.shitMs = 0;
		OptionsMenu.itIsNecessaryToRestart = false;
		display = updateDisplay();
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL)
			FlxG.save.data.shitMs += 5;
		else if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.shitMs += 0.01;
		else
			FlxG.save.data.shitMs++;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.shitMs = 160;
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		return "Shit: < " + (FlxG.save.data.shitMs == 160 ? "Default" : FlxG.save.data.shitMs) + " ms >";
	}
}
class UpKeybind extends Option{ // UP KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.upBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "UP: " + (waitingPress ? "> " + FlxG.save.data.upBind + " <" : FlxG.save.data.upBind) + "";
	}
}
class DownKeybind extends Option{ // DOWN KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}	
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.downBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "DOWN: " + (waitingPress ? "> " + FlxG.save.data.downBind + " <" : FlxG.save.data.downBind) + "";
	}
}
class RightKeybind extends Option{ // RIGHT KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.rightBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "RIGHT: " + (waitingPress ? "> " + FlxG.save.data.rightBind + " <" : FlxG.save.data.rightBind) + "";
	}
}
class LeftKeybind extends Option{ // LEFT KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.leftBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "LEFT: " + (waitingPress ? "> " + FlxG.save.data.leftBind + " <" : FlxG.save.data.leftBind) + "";
	}
}
class DodgeKeybind extends Option{ // DODGE KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.dodgeBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "DODGE: " + (waitingPress ? "> " + FlxG.save.data.dodgeBind + " <" : FlxG.save.data.dodgeBind) + "";
	}
}
class PauseKeybind extends Option{ // PAUSE KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.pauseBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "PAUSE: " + (waitingPress ? "> " + FlxG.save.data.pauseBind + " <" : FlxG.save.data.pauseBind) + "";
	}
}
class ChartingKeyBind extends Option{ // CHARTING KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.chartingBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "CHARTING: " + (waitingPress ? "> " + FlxG.save.data.chartingBind + " <" : FlxG.save.data.chartingBind) + "";
	}
}
class ResetBind extends Option{ // KILL KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.resetBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "Kill: " + (waitingPress ? "> " + FlxG.save.data.resetBind + " <" : FlxG.save.data.resetBind) + "";
	}
}
class MuteBind extends Option{ // MUTE KEY
	public function new(desc:String){
		super();
		description = desc;
		acceptPress = true;
	}
	public override function press(){
		waitingPress = !waitingPress;
		return true;
	}
	public override function onPress(text:String){
		if (waitingPress){
			FlxG.save.data.muteBind = text;
			waitingPress = false;
		}
	}
	private override function updateDisplay():String{
		return "Vol. Mute: " + (waitingPress ? "> " + FlxG.save.data.muteBind + " <" : FlxG.save.data.muteBind) + "";
	}
}
class RatingHUDOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function press():Bool{
		FlxG.save.data.hitHUDEffect = !FlxG.save.data.hitHUDEffect;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		FlxG.save.data.ratingHUD--;
		if (FlxG.save.data.ratingHUD < 0)
			FlxG.save.data.ratingHUD = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		FlxG.save.data.ratingHUD++;
		if (FlxG.save.data.ratingHUD > 2)
			FlxG.save.data.ratingHUD = 2;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.ratingHUD = 0;
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		var wellSexy:String = '';
		switch (FlxG.save.data.ratingHUD){
			case 0: wellSexy = 'Default';
			case 1: wellSexy = 'CamDefault';
			case 2: wellSexy = 'Strum';
		}
		return "Rating: < " + wellSexy + " - " + (FlxG.save.data.hitHUDEffect ? "TweenHUD: Effect" : "TweenHUD: Disabled") + " >";
	}
}
class ScrollLaneTransparencyOption extends Option{ // Scroll Lane Options
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.laneScroll = !FlxG.save.data.laneScroll;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.laneTransparencyScroll -= 0.1;
		else
			FlxG.save.data.laneTransparencyScroll -= 0.01;
		
		if (FlxG.save.data.laneTransparencyScroll < 0)
			FlxG.save.data.laneTransparencyScroll = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.laneTransparencyScroll += 0.1;
		else
			FlxG.save.data.laneTransparencyScroll += 0.01;
		if (FlxG.save.data.laneTransparencyScroll > 1)
			FlxG.save.data.laneTransparencyScroll = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Lane Scroll: < " + (FlxG.save.data.laneScroll ? "Enabled" : "Disabled") + ' - Opacity: ' + FlxG.save.data.laneTransparencyScroll + " >";
	}
}
class ScoreLaneTransparencyOption extends Option{ // LaneScore Option
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.laneScore = !FlxG.save.data.laneScore;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.laneTransparencyScore -= 0.1;
		else
			FlxG.save.data.laneTransparencyScore -= 0.01;
		if (FlxG.save.data.laneTransparencyScore < 0)
			FlxG.save.data.laneTransparencyScore = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.laneTransparencyScore += 0.1;
		else 
			FlxG.save.data.laneTransparencyScore += 0.01;
		if (FlxG.save.data.laneTransparencyScore > 1)
			FlxG.save.data.laneTransparencyScore = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Lane Score: < " + (FlxG.save.data.laneScore ? "Enabled" : "Disabled") + ' - Opacity: ' + FlxG.save.data.laneTransparencyScore + " >";
	}
}
class ScoreOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.scoreHUD = !FlxG.save.data.scoreHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.scoreHUDTransparency -= 0.1;
		else
			FlxG.save.data.scoreHUDTransparency -= 0.01;
		if (FlxG.save.data.scoreHUDTransparency < 0)
			FlxG.save.data.scoreHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.scoreHUDTransparency += 0.1;
		else
			FlxG.save.data.scoreHUDTransparency += 0.01;
		if (FlxG.save.data.scoreHUDTransparency > 1)
			FlxG.save.data.scoreHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Score: < " + (FlxG.save.data.scoreHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.scoreHUDTransparency + " >";
	}
}
class MissesOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.missesHUD = !FlxG.save.data.missesHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.missesHUDTransparency -= 0.1;
		else
			FlxG.save.data.missesHUDTransparency -= 0.01;
		if (FlxG.save.data.missesHUDTransparency < 0)
			FlxG.save.data.missesHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.missesHUDTransparency += 0.1;
		else
			FlxG.save.data.missesHUDTransparency += 0.01;
		if (FlxG.save.data.missesHUDTransparency > 1)
			FlxG.save.data.missesHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Misses: < " + (FlxG.save.data.missesHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.missesHUDTransparency + " >";
	}
}
class AccuracyOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.accuracyHUD = !FlxG.save.data.accuracyHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.accuracyHUDTransparency -= 0.1;
		else
			FlxG.save.data.accuracyHUDTransparency -= 0.01;
		if (FlxG.save.data.accuracyHUDTransparency < 0)
			FlxG.save.data.accuracyHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.accuracyHUDTransparency += 0.1;
		else
			FlxG.save.data.accuracyHUDTransparency += 0.01;
		if (FlxG.save.data.accuracyHUDTransparency > 1)
			FlxG.save.data.accuracyHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Accuracy: < " + (FlxG.save.data.accuracyHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.accuracyHUDTransparency + " >";
	}
}
class RatingOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.ratingTransparency -= 0.1;
			else
				FlxG.save.data.ratingTransparency -= 0.01;
			if (FlxG.save.data.ratingTransparency < 0)
				FlxG.save.data.ratingTransparency = 0;
		}else{
			FlxG.save.data.rating--;
			if (FlxG.save.data.rating < 0)
				FlxG.save.data.rating = 0;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.ratingTransparency += 0.1;
			else
				FlxG.save.data.ratingTransparency += 0.01;
			if (FlxG.save.data.ratingTransparency > 1)
				FlxG.save.data.ratingTransparency = 1;
		}else{
			FlxG.save.data.rating++;
			if (FlxG.save.data.rating > 2)
				FlxG.save.data.rating = 2;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.rating = 1;
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		var wallRanker:String = '';
		switch (FlxG.save.data.rating){
			case 0: wallRanker = 'Show & no FC';
			case 1: wallRanker = 'Show & Show FC';
			case 2: wallRanker = 'Disabled';
		}
		return "Rating: < " + wallRanker + " - Opacity: " + FlxG.save.data.ratingTransparency + " >";
	}
}
class ComboOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.comboHUD = !FlxG.save.data.comboHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.ComboHUDTransparency -= 0.1;
		else
			FlxG.save.data.ComboHUDTransparency -= 0.01;
		if (FlxG.save.data.ComboHUDTransparency < 0)
			FlxG.save.data.ComboHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.ComboHUDTransparency += 0.1;
		else
			FlxG.save.data.ComboHUDTransparency += 0.01;
		if (FlxG.save.data.ComboHUDTransparency > 1)
			FlxG.save.data.ComboHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Combo: < " + (FlxG.save.data.comboHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.ComboHUDTransparency + " >";
	}
}
class ComboMaxOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.maxComboHUD = !FlxG.save.data.maxComboHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.maxComboHUDTransparency -= 0.1;
		else
			FlxG.save.data.maxComboHUDTransparency -= 0.01;
		if (FlxG.save.data.maxComboHUDTransparency < 0)
			FlxG.save.data.maxComboHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.maxComboHUDTransparency += 0.1;
		else
			FlxG.save.data.maxComboHUDTransparency += 0.01;
		if (FlxG.save.data.maxComboHUDTransparency > 1)
			FlxG.save.data.maxComboHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "ComboMax: < " + (FlxG.save.data.maxComboHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.maxComboHUDTransparency +" >";
	}
}
class HealthPercentOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.hpHUDPercent = !FlxG.save.data.hpHUDPercent;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.hpHUDPercentTransparency -= 0.1;
		else
			FlxG.save.data.hpHUDPercentTransparency -= 0.01;
		if (FlxG.save.data.hpHUDPercentTransparency < 0)
			FlxG.save.data.hpHUDPercentTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.hpHUDPercentTransparency += 0.1;
		else
			FlxG.save.data.hpHUDPercentTransparency += 0.01;
		if (FlxG.save.data.hpHUDPercentTransparency > 1)
			FlxG.save.data.hpHUDPercentTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Health Percent: < " + (FlxG.save.data.hpHUDPercent ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.hpHUDPercentTransparency + " >";
	}
}
class HealthBGSOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.healthShitHUD = !FlxG.save.data.healthShitHUD;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.healthHUDTransparency -= 0.1;
		else
			FlxG.save.data.healthHUDTransparency -= 0.01;
		if (FlxG.save.data.healthHUDTransparency < 0)
			FlxG.save.data.healthHUDTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.healthHUDTransparency += 0.1;
		else
			FlxG.save.data.healthHUDTransparency += 0.01;
		if (FlxG.save.data.healthHUDTransparency > 1)
			FlxG.save.data.healthHUDTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Health Bar: < " + (FlxG.save.data.healthShitHUD ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.healthHUDTransparency + " >";
	}
}
class RatingSpriteOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function press():Bool{
		FlxG.save.data.ratinghudcolor = !FlxG.save.data.ratinghudcolor;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.ratingSpriteTransparency -= 0.1;
			else
				FlxG.save.data.ratingSpriteTransparency -= 0.01;
			if (FlxG.save.data.ratingSpriteTransparency < 0)
				FlxG.save.data.ratingSpriteTransparency = 0;
		}else{
			FlxG.save.data.ratingHUD--;
			if (FlxG.save.data.ratingHUD < 0)
				FlxG.save.data.ratingHUD = 0;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.ratingSpriteTransparency += 0.1;
			else
				FlxG.save.data.ratingSpriteTransparency += 0.01;
			if (FlxG.save.data.ratingSpriteTransparency > 1)
				FlxG.save.data.ratingSpriteTransparency = 1;
		}else{
			FlxG.save.data.ratingHUD++;
			if (FlxG.save.data.ratingHUD > 3)
				FlxG.save.data.ratingHUD = 3;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.ratingHUD = 2;
			FlxG.save.data.ratingSpriteTransparency = 1;
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		var wellSexy:String = '';
		switch (FlxG.save.data.ratingHUD){
			case 0: wellSexy = 'Default';
			case 1: wellSexy = 'MiddleCam';
			case 2: wellSexy = 'Strum';
			case 3: wellSexy = 'Disabled';
		}
		return "Rating Sprite: < " + wellSexy + " - " + (FlxG.save.data.ratinghudcolor ? "Hud Color: Enabled" : "Hud Color: Disabled") + " - Opacity: " + FlxG.save.data.ratingSpriteTransparency + " >";
	}
}
class StatsCounterOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.statsCounter = !FlxG.save.data.statsCounter;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.statsCounterTransparency -= 0.1;
		else
			FlxG.save.data.statsCounterTransparency -= 0.01;
		if (FlxG.save.data.statsCounterTransparency < 0)
			FlxG.save.data.statsCounterTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.statsCounterTransparency += 0.1;
		else
			FlxG.save.data.statsCounterTransparency += 0.01;
		if (FlxG.save.data.statsCounterTransparency > 1)
			FlxG.save.data.statsCounterTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Stats Counter: < " + (FlxG.save.data.statsCounter ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.statsCounterTransparency + " >";
	}
}
class TrackTimeOption extends Option{ // Show Track Time Lenght Left
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.trackTimeLeft = !FlxG.save.data.trackTimeLeft;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.trackTimeLeftTransparency -= 0.1;
		else
			FlxG.save.data.trackTimeLeftTransparency -= 0.01;
		if (FlxG.save.data.trackTimeLeftTransparency < 0)
			FlxG.save.data.trackTimeLeftTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.trackTimeLeftTransparency += 0.1;
		else
			FlxG.save.data.trackTimeLeftTransparency += 0.01;
		if (FlxG.save.data.trackTimeLeftTransparency > 1)
			FlxG.save.data.trackTimeLeftTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function getValue():String{
		return "Track Time: < " + (FlxG.save.data.trackTimeLeft ? "Enabled" : "Disabled") + " - Opacity: " + FlxG.save.data.trackTimeLeftTransparency + " >";
	}
}
class IconSpriteOption extends Option{
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			description = "This Option Cannot be Toggled in the Pause Menu.";
		else
			description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.iconTransparency -= 0.1;
			else
				FlxG.save.data.iconTransparency -= 0.01;
			if (FlxG.save.data.iconTransparency < 0)
				FlxG.save.data.iconTransparency = 0;
		}else{
			if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
				return false;
			FlxG.save.data.iconSprite--;
			if (FlxG.save.data.iconSprite < 0)
				FlxG.save.data.iconSprite = CachingState.CacheConfig.DirectoryFoldersIcons.length - 1;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.iconTransparency += 0.1;
			else
				FlxG.save.data.iconTransparency += 0.01;
			if (FlxG.save.data.iconTransparency > 1)
				FlxG.save.data.iconTransparency = 1;
		}else{
			if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
				return false;
			FlxG.save.data.iconSprite++;
			if (FlxG.save.data.iconSprite > CachingState.CacheConfig.DirectoryFoldersIcons.length - 1)
				FlxG.save.data.iconSprite = 0;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.iconSprite = 1;
			FlxG.save.data.iconTransparency = 1;
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		var packName:String = '';
		switch (FlxG.save.data.iconSprite){
			case 5: packName = 'Maty';
			case 4: packName = 'KkpassaroxX';
			case 3: packName = 'Juniorxefao';
			case 2: packName = 'JP';
			case 1: packName = 'Vanilla';
			case 0: packName = 'Disabled';
		}
		return "Icon: < " + (FlxG.save.data.iconSprite >= 1 ? packName + "-Pack" : packName) + " - Opacity: " + FlxG.save.data.iconTransparency + " >";
	}
}
class SafeFrameOption extends Option{
	public function new(desc:String){
		super();
		description = desc + " (R to Reset)";
		acceptPress = true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.safeFrames -= 0.1;
		else
			FlxG.save.data.safeFrames -= 0.01;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		Conductor.refreshConductors();
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.safeFrames += 0.1;
		else
			FlxG.save.data.safeFrames += 0.01;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		Conductor.refreshConductors();
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.safeFrames = 10;
			Conductor.refreshConductors();
			display = updateDisplay();
			OptionsMenu.itIsNecessaryToRestart = true;
		}
	}
	private override function updateDisplay():String{
		return "Safe Frames: < " + (FlxG.save.data.safeFrames == 10 ? "Default" : FlxG.save.data.safeFrames) + " >";
	}
}
class FPSOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.fpsAndMemory = !FlxG.save.data.fpsAndMemory;
		(cast (Lib.current.getChildAt(0), Main)).toggleFPS(FlxG.save.data.fpsAndMemory);
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "FPS & Memory: < " + (FlxG.save.data.fpsAndMemory ? "Enabled" : "Disabled") + " >";
	}
}
class EngineMarkOption extends Option{ // EngineMark Options
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		Main.engineMark = !Main.engineMark;
		FlxG.save.data.engineMark = Main.engineMark;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.engineMarkTransparency -= 0.1;
			else
				FlxG.save.data.engineMarkTransparency -= 0.01;
			if (FlxG.save.data.engineMarkTransparency < 0)
				FlxG.save.data.engineMarkTransparency = 0;
		}else{
			FlxG.save.data.engineMarkCustomization--;
			if (FlxG.save.data.engineMarkCustomization < 0)
				FlxG.save.data.engineMarkCustomization = 0;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.CONTROL){
			if (FlxG.keys.pressed.SHIFT)
				FlxG.save.data.engineMarkTransparency += 0.1;
			else
				FlxG.save.data.engineMarkTransparency += 0.01;
			if (FlxG.save.data.engineMarkTransparency > 1)
				FlxG.save.data.engineMarkTransparency = 1;
		}else{
			FlxG.save.data.engineMarkCustomization++;
			if (FlxG.save.data.engineMarkCustomization > 3)
				FlxG.save.data.engineMarkCustomization = 3;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		var Typed:String = '';
		switch (FlxG.save.data.engineMarkCustomization){
			case 0: Typed = 'All';
			case 1: Typed = 'Only Track';
			case 2: Typed = 'Only Difficulty';
			case 3: Typed = 'Only EngineMark';
		}
		return "EngineMark: < " + (Main.engineMark ? "Enabled" : "Disabled") + ' - Type: ' + Typed + ' - Opacity: ' + FlxG.save.data.engineMarkTransparency + " >";
	}
}
class SongMarkOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.songArtistMark = !FlxG.save.data.songArtistMark;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function left():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.songArtistMarkTransparency -= 0.1;
		else
			FlxG.save.data.songArtistMarkTransparency -= 0.01;
		if (FlxG.save.data.songArtistMarkTransparency < 0)
			FlxG.save.data.songArtistMarkTransparency = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function right():Bool{
		if (FlxG.keys.pressed.SHIFT)
			FlxG.save.data.songArtistMarkTransparency += 0.1;
		else
			FlxG.save.data.songArtistMarkTransparency += 0.01;
		if (FlxG.save.data.songArtistMarkTransparency > 1)
			FlxG.save.data.songArtistMarkTransparency = 1;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "SongMark: < " + (FlxG.save.data.songArtistMark ? "Enabled" : "Disabled") + ' - Opacity: ' + FlxG.save.data.songArtistMarkTransparency + " >";
	}
}

// Scroll
class NoteExtraOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.noteKeybind = !FlxG.save.data.noteKeybind;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	public override function shift():Bool{
		FlxG.save.data.strumMove = !FlxG.save.data.strumMove;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "Note < " + (FlxG.save.data.noteKeybind ? "Keybinds: Enabled" : "Keybinds: Disabled") + " >";
	}
}
class OpponentStrumNoteHit extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.opponentGlownHit = !FlxG.save.data.opponentGlownHit;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = true;
		return true;
	}
	private override function updateDisplay():String{
		return "Opponent Strum: < " + (FlxG.save.data.opponentGlownHit ? "Glown" : "No Change") + " on Hit" + " >";
	}
}
class DebugCharacterOffsetOption extends Option{
	public function new(desc:String){
		description = desc;
		super();
	}
	public override function press():Bool{
		OptionsMenu.itIsNecessaryToRestart = false;
		if (FlxG.save.data.moddingTools)
			FlxG.switchState(new AnimationDebug(PlayState.SONG.player2));
		else
			OptionsMenu.instance.close();
		return false;
	}
	public override function shift():Bool{
		OptionsMenu.itIsNecessaryToRestart = false;
		if (FlxG.save.data.moddingTools)
			FlxG.switchState(new AnimationDebug((FlxG.save.data.charSelect != 1 ? PlayState.SONG.player1 : CharacterSelect.charSelected)));
		else
			OptionsMenu.instance.close();
		return false;
	}
	public override function ctrl():Bool{
		OptionsMenu.itIsNecessaryToRestart = false;
		if (FlxG.save.data.moddingTools)
			FlxG.switchState(new AnimationDebug(PlayState.SONG.girlfriend));
		else
			OptionsMenu.instance.close();
		return false;
	}
	private override function updateDisplay():String{
		return "Character Offset Debug";
	}
}
class CacheOption extends Option{
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			description = "This Option Cannot be Toggled in the Pause Menu.";
		else
			description = desc + " (R to Reset)";
	}
	public override function left():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		FlxG.save.data.cacheType--;
		if (FlxG.save.data.cacheType < 0)
			FlxG.save.data.cacheType = 0;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			return false;
		FlxG.save.data.cacheType++;
		if (FlxG.save.data.cacheType > 3)
			FlxG.save.data.cacheType = 3;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r"){
			FlxG.save.data.cacheType = 0;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		var cacheText:String = '';
		switch (FlxG.save.data.cacheType){
			case 0: cacheText = 'Disabled';
			case 1: cacheText = 'Songs';
			case 2: cacheText = 'Images';
			case 3: cacheText = 'All';
		}
		return "Cache: < " + cacheText + " >";
	}
}
class ThisOption extends Option{
	static var Target:String = '';
	inline static public function changeBF(?IsIcon:Bool = false):String{
		var chartJsonBFblock:Array<String> = ['bf-50Years-Phase1', 'bf-50Years-Phase2', 'bf-50Years-Phase3'];
		if (FlxG.save.data.charSelect < 2){
			switch (FlxG.save.data.charSelect){
				case 0: for (i in 0...chartJsonBFblock.length)
					Target =  (!IsIcon ? (PlayState.SONG.player1 ==  chartJsonBFblock[i] && !FlxG.save.data.trrBF ? 'bf' : PlayState.SONG.player1) : (PlayState.instance.boyfriend.icon == '' ? (PlayState.SONG.player1 ==  chartJsonBFblock[i] && !FlxG.save.data.trrBF ? 'bf' : PlayState.SONG.player1) : PlayState.instance.boyfriend.icon));
				case 1: Target = (!IsIcon ? CharacterSelect.charSelected : (PlayState.instance.boyfriend.icon == '' ? CharacterSelect.charSelected : PlayState.instance.boyfriend.icon));
			}
		}else
			Target = (PlayState.SONG.player1 = (!IsIcon ? CharacterSettigs.CharacterRecognition.Boyfriends[FlxG.save.data.subCharSelect] : (PlayState.instance.boyfriend.icon == '' ? CharacterSettigs.CharacterRecognition.Boyfriends[FlxG.save.data.subCharSelect] : PlayState.instance.boyfriend.icon)));
		return Target;
	}
	public function new(desc:String){
		super();
		if (OptionsMenu.isInPause && !OptionsMenu.isFreeplay && !OptionsMenu.isStoryMenu && !OptionsMenu.isMainMenu)
			description = "This Option Cannot be Toggled In The Pause Menu.";
		else
			description = desc + " (R to Reset)";
		acceptPress = true;
		CharacterSettigs.CharacterRecognition = Json.parse(openfl.utils.Assets.getText(Paths.type(Client.Public.gameFolder + 'CharacterList', 'json', 'TEXT', 'config')));
	}
	public override function left():Bool{
		if (!OptionsMenu.isInPause && OptionsMenu.isFreeplay && OptionsMenu.isStoryMenu && OptionsMenu.isMainMenu)
			return false;
		if (FlxG.save.data.charSelect == 2){
			if (FlxG.save.data.subCharSelect == 0)
				FlxG.save.data.charSelect--;
			else
				FlxG.save.data.subCharSelect--;
			if (FlxG.save.data.subCharSelect < 0)
				FlxG.save.data.subCharSelect = 0;
			if (FlxG.save.data.charSelect < 0)
				FlxG.save.data.charSelect = 0;
		}else{
			FlxG.save.data.charSelect--;
			if (FlxG.save.data.charSelect < 0)
				FlxG.save.data.charSelect = 0;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function right():Bool{
		if (!OptionsMenu.isInPause && OptionsMenu.isFreeplay && OptionsMenu.isStoryMenu && OptionsMenu.isMainMenu)
			return false;
		if (FlxG.save.data.charSelect == 2){
			FlxG.save.data.subCharSelect++;
			if (FlxG.save.data.subCharSelect > (!FlxG.save.data.trrBF ? CharacterSettigs.CharacterGetLimit : CharacterSettigs.CharacterRecognition.Boyfriends.length - 1))
				FlxG.save.data.subCharSelect = (!FlxG.save.data.trrBF ? CharacterSettigs.CharacterGetLimit : CharacterSettigs.CharacterRecognition.Boyfriends.length - 1);
		}else{
			FlxG.save.data.charSelect++;
			if (FlxG.save.data.charSelect > 2)
				FlxG.save.data.charSelect = 2;
		}
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	public override function onPress(char:String){
		if (char.toLowerCase() == "r" && !OptionsMenu.isInPause && OptionsMenu.isFreeplay && OptionsMenu.isStoryMenu && OptionsMenu.isMainMenu){
			FlxG.save.data.charSelect = 0;
			FlxG.save.data.subCharSelect = 0;
			OptionsMenu.itIsNecessaryToRestart = false;
		}
	}
	private override function updateDisplay():String{
		var charSelectedBro:String = '';
		if (FlxG.save.data.charSelect >= 2)
			charSelectedBro = CharacterSettigs.CharacterRecognition.Boyfriends[FlxG.save.data.subCharSelect]
		else{
			switch (FlxG.save.data.charSelect){
				case 0: charSelectedBro = 'Auto'; // Chart Dependent
				case 1: charSelectedBro = 'Manual'; // Manual Select
			}
		}
		return "CharacterSelected: < " + charSelectedBro + " >";
	}
}
class GameOverOption extends Option{
	public function new(desc:String){
		super();
		description = desc;
	}
	public override function press():Bool{
		FlxG.save.data.deathStats = !FlxG.save.data.deathStats;
		display = updateDisplay();
		OptionsMenu.itIsNecessaryToRestart = false;
		return true;
	}
	private override function updateDisplay():String{
		return "GameOverStats: < " + (FlxG.save.data.deathStats ? "Enabled" : "Disabled") + " >";
	}
}