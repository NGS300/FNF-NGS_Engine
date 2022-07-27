package;
import openfl.system.System;
import Options.Option;
import flixel.addons.plugin.screengrab.FlxScreenGrab;
import Section.SwagSection;
import Song.SwagSong;
import openfl.Lib;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.util.FlxAxes;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
using StringTools;
class PlayState extends MusicBeatState{
	public static var instance:PlayState = null;
	public static var SONG:SwagSong;
	public static var storyPlaylist:Array<String> = [];
	public static var stateShit:String = 'StoryMode';
	public static var mainDifficulty:Int = 2;

	// HUD Scores
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;
	public static var misses:Int = 0;
	public static var badNote:Int = 0;
	public static var loops:Int = 0;
	public static var combo:Int = 0;
	public static var highestCombo:Int = 0;
	public static var badNotes:Int = 0;
	public static var death:Int = 0;
	
	// in brain
	//var arrowMax:Array<Int> = [4];
	//var numArrow:Int = 0;

	// Accuracy
	public var accuracy:Float = 0.00;
	private var accuracyDefault:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalNotesHitDefault:Float = 0;
	private var totalPlayed:Int = 0;

	private var ss:Bool = false;
	public var vocals:FlxSound;

	// Chars 
	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Boyfriend;

	public static var endTrack:Bool = false;
	var canDie:Bool = true;
	public var refreshCum:Bool = true;
	public var missedNote:Bool = false;

	// Bool Chars
	public var isPlayerMain:Bool = false;
	public var isOpponentMain:Bool = false;

	public  var iconColorSwitch:Bool = false;

	private var notes:FlxTypedGroup<Note>;

	private var unspawnNotes:Array<Note> = [];

	public var strumLine:FlxSprite;
	public var strumLineYPos:Float;

	public static var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	public static var strumLineNotes:FlxTypedGroup<FlxSprite> = null;
	public static var playerStrums:FlxTypedGroup<FlxSprite> = null;
	var grpOpponentNoteSplashes:FlxTypedGroup<Opponent_NoteSplash>;
	var grpPlayerNoteSplashes:FlxTypedGroup<Player_NoteSplash>;
	public static var opponentStrums:FlxTypedGroup<FlxSprite> = null;
	public var curTrack:String = "";

	// Health
	public var health:Float = 1;
	public var healthPercent:Int = 50;
	public var healthToDie:Float = 2;
	public var healthToScale:Float = 2;
	public var healthLimiter:Float = 2;
	public var healthDrain:Float = 0.4375;

	public var healthBarBG:FlxSprite;
	public var healthBar:FlxBar;

	public var bfDodging:Bool = false;
	public var bfCanDodge:Bool = false;
	public var bfDodgeTiming:Float = 0.22625;
	public var bfDodgeCooldown:Float = 0.1135;

	public var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public static var iconP1:HealthIcon;
	public static var iconP2:HealthIcon;

	// Cams
	public static var laneCamera:FlxCamera;
	public static var camCutcene:FlxCamera;
	public static var camNOTE:FlxCamera;
	public static var camHUD:FlxCamera;
	public static var camGame:FlxCamera;
	public static var camPos:FlxPoint;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var talking:Bool = true;
	var trackScoreDefault:Int = 0;
	public var chartScore:Int = 0;

	// HUDTexts
	public var waterMarkEngine:Text;
	public var waterMarkEngineInfo:Text;
	public var waterMarkEngineSongName:Text;
	public var waterMarkEngineDiff:Text;
	public var lanePlayerScroll:FlxSprite;
	public var laneOpponentScroll:FlxSprite;
	public var laneScore:FlxSprite;
	public var scoreTxt:Text;
	public var missTxt:Text;
	public var accuracyTxt:Text;
	public static var ratingTxt:Text;
	public var comboTxt:Text;
	public var higherComboTxt:Text;
	public var healthTxt:Text;
	public var timerTrackTxt:Text;
	public var botplayTxt:Text;
	public var statsCounterTxt:Text;
	// HUD Tween
	public var scoreTxtTween:FlxTween;
	public var missTxtTween:FlxTween;
	public var accuracyTxtTween:FlxTween;
	public var ratingTxtTween:FlxTween;
	public var comboTxtTween:FlxTween;
	public var higherComboTxtTween:FlxTween;
	public var healthTxtTween:FlxTween;
	public var timerTrackTxtTween:FlxTween;
	public var statsCounterTxtTxtTween:FlxTween;
	public static var ObjectTween:FlxTween;
	public var getCum:Float;

	// Diretions Shits
	public var diretionSing:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public var diretionDodge:Array<String> = [Character.dodgeShit, Character.dodgeShit, Character.dodgeShit, Character.dodgeShit];
	public var diretionShoot:Array<String> = [Character.dickShooter, Character.dickShooter, Character.dickShooter, Character.dickShooter];

	public static var campaignScore:Int = 0;

	public static var inCutscene:Bool = false;
	#if desktop // Discord RPC variables
	public var mainDifficultyText:String = "";
	public var songLength:Float = 0;
	public var detailsText:String = "";
	public var detailsPausedText:String = "";
	#end
	public static var pauseMusic:FlxSound;
	public var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;
	public var startTimer:FlxTimer;

	var iconOffset:Int = 26;
	var noRagen:Bool = false;
	var scrollLocked:Bool = false;
	var strumLEFTLocked:Bool = false;
	var strumDOWNLocked:Bool = false;
	var strumUPLocked:Bool = false;
	var strumRIGHTLocked:Bool = false;
	public var VolumeShoot:Float = 0.65; // old 0.05
	var numDifShit:Int;
	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;
	var mashing:Int = 0;
	var mashViolations:Int = 0;
	// Germelin Mechanic
	public var addsDamageHealthSpriteTake:Float = 0;
	public var interuptgrabbedPlayerIconHealth = false;
	var interuptgrabbedOpponentHealth = false;
	var playerTurn:Bool = true;
	var isFackingGrabCoondownPlayer:Bool = false;
	var isFackingGrabCoondownOpponent:Bool = false;
	public static var IsPlayState:Bool = false;
	var grabbedPlayerIcon = false;
	var grabbedOpponentIcon = false;
	var whatThisMark:Dynamic;
	override public function create(){
		Main.dumpCache();
		Paths.clearTraceSounds();
		Client.loadData();
		instance = this;
		OptionsMenu.isFreeplay = false;
		OptionsMenu.isMainMenu = false;
		OptionsMenu.isStoryMenu = false;
		OptionsMenu.disableMerges = false;
		endTrack = false;
		IsPlayState = true;
		Actions.iconEventOpponent = false;
		Actions.iconEventPlayer = false;
		HealthIcon.onPlayState = true;
		FlxG.mouse.visible = false;
		Camera.cameraMakeOn('PlayStateCreate', SONG.song.toLowerCase());
		if (FlxG.sound.music != null) FlxG.sound.music.stop();
		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		combo = 0;
		misses = 0;
		badNotes = 0;
		highestCombo = 0;
		
		// Cams
		camGame = new FlxCamera();
		laneCamera = new FlxCamera();
		laneCamera.bgColor.alpha = 0;
		camCutcene = new FlxCamera();
		camCutcene.bgColor.alpha = 0;
		camNOTE = new FlxCamera();
		camNOTE.bgColor.alpha = 0;
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(laneCamera);
		FlxG.cameras.add(camCutcene);
		FlxG.cameras.add(camNOTE);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];
		persistentUpdate = true;
		persistentDraw = true;
		if (SONG == null) SONG = Song.loadFromJson('tutorial');
		grpOpponentNoteSplashes = new FlxTypedGroup<Opponent_NoteSplash>();
		var splooshOp = new Opponent_NoteSplash(100, 100, 0);
		splooshOp.alpha = 0;
		grpOpponentNoteSplashes.add(splooshOp);
		grpPlayerNoteSplashes = new FlxTypedGroup<Player_NoteSplash>();
		var splooshPly = new Player_NoteSplash(100, 100, 0);
		splooshPly.alpha = 0;
		grpPlayerNoteSplashes.add(splooshPly);
		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);
		if (Paths.doesTextExist(Paths.txt('dialogueTracks/${SONG.song.toLowerCase()}/dialogue', 'shared'))) dialogue = CoolUtil.coolTextFile(Paths.txt('dialogueTracks/${SONG.song.toLowerCase()}/dialogue', 'shared')); // Dialogue
		#if desktop
		mainDifficultyText = CoolUtil.difficultyFromInt(mainDifficulty); // Making difficulty text for Discord Rich Presence.
		switch (stateShit){
			case 'StoryMode': detailsText = "StoryMode: Week " + StoryMenuState.storyWeek;
			case 'Freeplay': detailsText = "Freeplay";
			case 'Secret': detailsText = 'Secret';
		}
		detailsPausedText = "Paused - " + detailsText; // String for when the game is paused
		#end
		DiscordClient.globalPresence('PlayState', 'Create');
		TrackMap.LoadTrackMap(add, SONG.song.toLowerCase()); // Path Load Maps
		CharacterSettigs.LoadGFType('GetGF', SONG.girlfriend, SONG.song.toLowerCase(), TrackMap.curMap, gf); // Get to Path GF Skin
		gf = new Character(400, 130, CharacterSettigs.bomboxSkinType); // Path GF Skins
		if (Client.Public.map){
			CharacterSettigs.LoadGFType('GFScrollfactor', SONG.girlfriend, SONG.song.toLowerCase(), TrackMap.curMap, gf); // Path GF Scroll Factor
			//CharacterSettigs.CharacterTypePositions('GFPos', TrackMap.curMap, SONG.player2, SONG.girlfriend, Options.ThisOption.changeBF(false), SONG.song.toLowerCase(), add, camPos, dad, boyfriend, gf); // Path Bombox Position
		}
		dad = new Character(100, 100, SONG.player2); // Opponent Skin
		camPos = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);
		if (Client.Public.map) CharacterSettigs.CharacterTypePositions('OpponentPos', TrackMap.curMap, SONG.player2, SONG.girlfriend, Options.ThisOption.changeBF(false), SONG.song.toLowerCase(), add, camPos, dad, boyfriend, gf); // Path Player 2 Positions
		boyfriend = new Boyfriend(770, 450, Options.ThisOption.changeBF(false)); // Boyfriend Skin
		if (Client.Public.map){
			CharacterSettigs.CharacterTypePositions('PlayerPos', TrackMap.curMap, SONG.player2, SONG.girlfriend, Options.ThisOption.changeBF(false), SONG.song.toLowerCase(), add, camPos, dad, boyfriend, gf); // Path Player 1 Positions
			CharacterSettigs.CharacterTypePositions('InMapPos', TrackMap.curMap, SONG.player2, SONG.girlfriend, Options.ThisOption.changeBF(false), SONG.song.toLowerCase(), add, camPos, dad, boyfriend, gf); // Path Chracaters Position in Maps
			CharacterSettigs.CreateLayerObject(SONG.song.toLowerCase(), add, dad, gf, boyfriend); // Add Map Parts & Players
		}
		var logShit:DialogueBox = new DialogueBox(false, dialogue);
		logShit.finishThing = startCountdown;
		Conductor.songPosition = -5000;
		strumLineYPos = (!Client.Public.downscroll ? (Option.JsonOptions.ScrollLineY != null ? Option.JsonOptions.ScrollLineY : FlxG.save.data.strumLineY)
		: (Option.JsonOptions.ScrollLineY != null ? FlxG.height - Option.JsonOptions.ScrollLineY : FlxG.height - FlxG.save.data.strumLineY));
		strumLine = new FlxSprite(0, strumLineYPos).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();
		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);
		add(grpOpponentNoteSplashes);
		add(grpPlayerNoteSplashes);
		playerStrums = new FlxTypedGroup<FlxSprite>();
		opponentStrums = new FlxTypedGroup<FlxSprite>();
		generateChart(SONG.song);
		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(camPos.x, camPos.y);
		if (prevCamFollow != null){
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		add(camFollow);
		FlxG.camera.follow(camFollow, LOCKON, 0.04 * (FlxG.save.data.cameraFPS / (cast (Lib.current.getChildAt(0), Main)).getFPS()));
		FlxG.camera.zoom = TrackMap.camZoom;
		FlxG.camera.focusOn(camFollow.getPosition());
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
		FlxG.fixedTimestep = false;

		// Health BackGround of Healthbar Colors
		healthBarBG = new FlxSprite(0, (Client.Public.downscroll ? 50 : FlxG.height * 0.9)).loadGraphic(Paths.loadImage('healthBar'));
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.alpha = (stateShit != 'StoryMode' ? 0 : FlxG.save.data.healthHUDTransparency);
		if (FlxG.save.data.healthShitHUD) add(healthBarBG);

		// Health Bar Colors
		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.alpha = (stateShit != 'StoryMode' ? 0 : FlxG.save.data.healthHUDTransparency);
		if (FlxG.save.data.healthShitHUD){
			healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? dad.healthBarColor : 0xFFFF0000), (FlxG.save.data.colourCharIcon ? boyfriend.healthBarColor : 0xFF66FF33));
			add(healthBar);
		}

		// Player's Scroll Lane Alpha
		laneOpponentScroll = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2, FlxColor.BLACK);
		laneOpponentScroll.alpha = (stateShit != 'StoryMode' ? 0 : (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll));
		laneOpponentScroll.scrollFactor.set();
		laneOpponentScroll.screenCenter(Y);
		lanePlayerScroll = new FlxSprite(0, 0).makeGraphic(110 * 4 + 50, FlxG.height * 2, FlxColor.BLACK);
		lanePlayerScroll.alpha = (stateShit != 'StoryMode' ? 0 : (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll));
		lanePlayerScroll.scrollFactor.set();
		lanePlayerScroll.screenCenter(Y);
		if (FlxG.save.data.map){
			if (FlxG.save.data.laneScroll){
				if (!Client.Public.mid && Options.Option.JsonOptions.laneOpponent)
					add(laneOpponentScroll);
				if (Options.Option.JsonOptions.lanePlayer)
					add(lanePlayerScroll);
				else
					if (Client.Public.mid)
						add(lanePlayerScroll);
			}
		}

		// Lane Score
		laneScore = new FlxSprite(0, healthBarBG.y + 50).makeGraphic(FlxG.width * 4, 26, FlxColor.BLACK);
		laneScore.scrollFactor.set();
		laneScore.alpha = (stateShit != 'StoryMode' ? 0 : (Option.JsonOptions.laneTransparencyScore != null ? Option.JsonOptions.laneTransparencyScore : FlxG.save.data.laneTransparencyScore));
		if (FlxG.save.data.map && FlxG.save.data.laneScore) add(laneScore);

		// Engine Mark Texts
		switch (FlxG.save.data.engineMarkCustomization){
			case 0: // WaterMark All Types
				waterMarkEngine = new Text((!FlxG.save.data.fpsAndMemory ? 'NGE v' + MainMenuState.engineVersion + ' - ' + SONG.song : SONG.song) + '-' + mainDifficultyText, 1, (Client.Public.downscroll ? FlxG.height * 0.9 + 50 : FlxG.height * 0.9 - 648), 18, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.engineMarkTransparency));
				waterMarkEngine.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 23, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
			case 1: // WaterMark TrackName Text
				waterMarkEngineSongName = new Text('Song: ' + SONG.song, 1, (Client.Public.downscroll ? FlxG.height * 0.9 + 50 : FlxG.height * 0.9 - 648), 18, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.engineMarkTransparency));
				waterMarkEngineSongName.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 23, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
			case 2: // WaterMark Difficulty Text
				waterMarkEngineDiff = new Text('Difficulty: ' + mainDifficultyText, 1, (Client.Public.downscroll ? FlxG.height * 0.9 + 50 : FlxG.height * 0.9 - 648), 18, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.engineMarkTransparency));
				waterMarkEngineDiff.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 23, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
			case 3: // WaterMark Engine Name & Version Text
				waterMarkEngineInfo = new Text("NG'S Engine - v" + MainMenuState.engineVersion, 1, (Client.Public.downscroll ? FlxG.height * 0.9 + 50 : FlxG.height * 0.9 - 648), 18, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.engineMarkTransparency));
				waterMarkEngineInfo.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 23, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		}
		if (Main.engineMark){
			switch (FlxG.save.data.engineMarkCustomization){
				case 0: add(waterMarkEngine);
				case 1: add(waterMarkEngineSongName);
				case 2: add(waterMarkEngineDiff);
				case 3: if (!FlxG.save.data.fpsAndMemory) add(waterMarkEngineInfo);
			}
		}

		// Score Text
		scoreTxt = new Text('Score: 0', healthBarBG.x + healthBarBG.width - 330, healthBarBG.y + (TrackMap.mapComplement != 'pixel' ? 50 : 47), 20, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.scoreHUDTransparency));
		scoreTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 20, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.scoreHUD) add(scoreTxt);

		// Misses Text
		missTxt = new Text('Misses: 0', healthBarBG.x + healthBarBG.width - 75, healthBarBG.y + (TrackMap.mapComplement != 'pixel' ? 50 : 47), 20, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.missesHUDTransparency));
		missTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 20, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.missesHUD) add(missTxt);

		// Accuracy Text
		accuracyTxt = new Text('Accuracy: 0%', healthBarBG.x + healthBarBG.width - 602, healthBarBG.y + (TrackMap.mapComplement != 'pixel' ? 50 : 47), 20, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.accuracyHUDTransparency));
		accuracyTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 20, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.accuracyHUD) add(accuracyTxt);
		
		// Ratings Text
		ratingTxt = new Text("Rating: N/A - (?)", (FlxG.save.data.iconSprite >= 1 ? 0 : healthBarBG.x - 3), (FlxG.save.data.iconSprite >= 1 ? healthBarBG.y - 75 : healthBarBG.y + 20), 22, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.ratingTransparency));
		ratingTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 24, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.rating < 2) add(ratingTxt);
		
		// Combo Text
		comboTxt = new Text("Combo: 0", 0, 0, 22, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.ComboHUDTransparency));
		comboTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 22, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.comboHUD) add(comboTxt);

		// Higherst Combo Text
		higherComboTxt = new Text("HighestCombo: 0", 0, 0, 22, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.maxComboHUDTransparency));
		higherComboTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 22, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.maxComboHUD) add(higherComboTxt);

		// Health Text
		healthTxt = new Text("Health: ?", 0, 0, 22, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.hpHUDPercentTransparency), FlxG.save.data.hpHUDPercent);
		healthTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 22, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		if (FlxG.save.data.hpHUDPercent) add(healthTxt);

		// Stats Counter Text
		statsCounterTxt = new Text('Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nBadNotes: ${badNote}', (Client.Public.mid ? 0 : 20), 0, 21, 0, (stateShit != 'StoryMode' ? 0 : FlxG.save.data.statsCounterTransparency));
		statsCounterTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 22, 0xFFFFFFFF, 0xFF000000, LEFT, 'OUTLINE');
		statsCounterTxt.borderSize = 1.25;
		statsCounterTxt.borderQuality = 1.25;
		statsCounterTxt.screenCenter(Y);
		if (FlxG.save.data.statsCounter) add(statsCounterTxt);

		// Timer Track Text
		timerTrackTxt = new Text("TrackLeft: ?", (Client.Public.mid ? -5.25 : 390), (Client.Public.downscroll ? 670 : 30), 32, 400, ((stateShit != 'StoryMode' ? 0 : FlxG.save.data.trackTimeLeftTransparency)), FlxG.save.data.trackTimeLeft);
		timerTrackTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 32, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		timerTrackTxt.borderSize = 1.25;
		refreshCum = FlxG.save.data.trackTimeLeft;
		if (FlxG.save.data.trackTimeLeft) add(timerTrackTxt);

		// BotPlay Text
		botplayTxt = new Text('Botplaying', (Client.Public.mid ? -5.25 : 390), (Client.Public.downscroll ? 640 : 60), 32, 400, ((stateShit != 'StoryMode' ? 0 : 1)));
		botplayTxt.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 32, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		botplayTxt.borderSize = 1.25;
		add(botplayTxt);
		if (!Client.Public.botplay)	botplayTxt.kill();

		iconP1 = new HealthIcon(Options.ThisOption.changeBF(true), true);
		iconP1.y = healthBar.y - (iconP1.height / 2) - iconP1.offsetY;
		iconP1.alpha = (stateShit != 'StoryMode' ? 0 : FlxG.save.data.iconTransparency);
		iconP2 = new HealthIcon((dad.icon == '' ? SONG.player2 : dad.icon), false);
		iconP2.y = healthBar.y - (iconP2.height / 2) - iconP2.offsetY;
		iconP2.alpha = (stateShit != 'StoryMode' ? 0 : FlxG.save.data.iconTransparency);
		if (FlxG.save.data.iconSprite >= 1){
			add(iconP1);
			add(iconP2);
		}

		strumLineNotes.cameras = [camNOTE];
		grpOpponentNoteSplashes.cameras = [camNOTE];
		grpPlayerNoteSplashes.cameras = [camNOTE];
		notes.cameras = [camNOTE];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		healthTxt.cameras = [camNOTE];
		scoreTxt.cameras = [camHUD];
		missTxt.cameras = [camHUD];
		accuracyTxt.cameras = [camHUD];
		ratingTxt.cameras = [camHUD];
		comboTxt.cameras = [camHUD];
		higherComboTxt.cameras = [camHUD];
		timerTrackTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		laneScore.cameras = [camHUD];
		lanePlayerScroll.cameras = [laneCamera];
		laneOpponentScroll.cameras = [laneCamera];
		statsCounterTxt.cameras = [camHUD];
		logShit.cameras = [camCutcene];
		switch (FlxG.save.data.engineMarkCustomization){
			case 0: waterMarkEngine.cameras = [camHUD];
			case 1: waterMarkEngineSongName.cameras = [camHUD];
			case 2: waterMarkEngineDiff.cameras = [camHUD];
			case 3: waterMarkEngineInfo.cameras = [camHUD];
		}
		startingSong = true;
		Cutscenes.startTrackCutscene(stateShit, curTrack, startCountdown, inCutscene, add, remove, SONG, logShit, camHUD, camNOTE, laneCamera, camFollow, death, mainDifficulty);
		super.create();
	}
	override public function update(elapsed:Float){
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.dodgeBind)])) && !bfDodging && bfCanDodge){ // Dodge Start
			bfDodging = true;
			bfCanDodge = false;
			Actions.PlayCharAnim(boyfriend, Character.talkAction + Character.dodgeShit, true, false, 0, true);
			new FlxTimer().start(bfDodgeTiming, function(tmr:FlxTimer){ // Dodge Stop
				bfDodging = false;
				Actions.PlayCharAnim(boyfriend, 'idle');
				new FlxTimer().start(bfDodgeCooldown, function(tmr:FlxTimer){ // Reset Dodge
					bfCanDodge = true;
				});
			});
		}
		TrackMap.mapType('update', add, null, elapsed, curTrack, dad, gf, boyfriend, curStep, curBeat, mainDifficulty, SONG, generatedMusic);
		super.update(elapsed);
		scoreTxt.text = 'Score: $chartScore'; // Score
		healthTxt.text = 'Health: $healthPercent' + "%";
		if (FlxG.save.data.iconSprite >= 1) ratingTxt.x = iconP1.x - 20;
		if (Actions.iconEventOpponent && iconP2.totalIconsAnim.length >= 3){ 
			if (FlxG.save.data.iconSprite >= 2){ switch (dad.curCharacter){
					case 'tankmanCaptain': switch (SONG.song.toLowerCase()){
						case 'ugh': iconP2.animation.curAnim.curFrame = 4; // UGH Icon
						case 'stress': iconP2.animation.curAnim.curFrame = 3; // Pretty Good Icon
					}
				}
			}
		}else if (Actions.iconEventPlayer && iconP1.totalIconsAnim.length >= 3){
			if (FlxG.save.data.iconSprite >= 2){ switch (boyfriend.curCharacter){}
			}
		}else{
			if (iconP1.isPNGIcon){
				if (iconP1.totalIconsAnim.length > 1 && healthBar.percent < 20) // Player
					iconP1.animation.curAnim.curFrame = 1; // Dead Icon
				else if (iconP1.totalIconsAnim.length > 2 && healthBar.percent > 80 && FlxG.save.data.iconSprite >= 2)
					iconP1.animation.curAnim.curFrame = 2; // Wining Icon
				else
					iconP1.animation.curAnim.curFrame = 0; // Idle Icon
			}else{ // Experimental and Progress 50% (No Functionality!!!!!)
				if (/*iconP1.json.frameNameDead != null &&*/ healthBar.percent < 20) // Player
					//iconP1.playIcon = 'dead'; // Dead Icon
					iconP1.animation.frameName = 'dead';
				else if (/*iconP1.json.frameNameWining != null &&*/ healthBar.percent > 80)
					//iconP1.playIcon = 'win'; // Idle Icon
					iconP1.animation.frameName = 'win';
				else
					iconP1.animation.frameName = 'idle';
					//iconP1.playIcon = 'idle'; // Idle Icon
			}
			if (iconP2.isPNGIcon){
				if (iconP2.totalIconsAnim.length > 1 && healthBar.percent > 80) // Opponent
					iconP2.animation.curAnim.curFrame = 1; // Dead Icon
				else if (iconP2.totalIconsAnim.length > 2 && healthBar.percent < 20 && FlxG.save.data.iconSprite >= 2)
					iconP2.animation.curAnim.curFrame = 2; // Wining Icon
				else
					iconP2.animation.curAnim.curFrame = 0; // Idle Icon
			}
		}
		switch (SONG.song.toLowerCase()){ // Set Health Chart's 
			default: switch (boyfriend.curCharacter){
				default: HealthType(false); // 100% HP
				case 'bf-50Years-Phase1': HealthType(true, 2.5); // 125% HP
				case 'bf-50Years-Phase2': HealthType(true, 1.8); // 90% HP
				case 'bf-50Years-Phase3': HealthType(true, 20); // 1000% HP
			}
		}
		if (FlxG.save.data.healthShitHUD){
			if (health >= 2.005){
				healthBar.visible = false;
				healthBarBG.visible = false;
			}else{
				healthBar.visible = true;
				healthBarBG.visible = true;
			}
		}
		(health >= 0 ? healthPercent = Math.round(health * 50) : healthPercent = 0); // Float Health to Health Percent
		if (combo > highestCombo){highestCombo = combo; TweenHitHUD('Press', 1.1);} // Max Combo System and Tween Max Combo
		if (FlxG.save.data.hpHUDPercent){
			switch (SONG.song.toLowerCase()){
				default: // Default All Track in no Case Here
					if (healthPercent >= 70 && healthPercent < 100) healthTxt.color = 0xFF02ff00; // Green Color (Safe HP), 70% of 100%
    				if (healthPercent >= 40 && healthPercent < 69) healthTxt.color = 0xFFffd700; // Orange Color (Alert HP), 40% of 69%
   					if (healthPercent >= 0 && healthPercent < 39) healthTxt.color = 0xFFff0000; // Red Color (Danger HP), 0% of 39%
			}
		}
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.pauseBind)])) && startedCountdown && canPause && !endTrack){ // Paused Shit
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;
			pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
			pauseMusic.volume = 0;
			pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
			FlxG.sound.list.add(pauseMusic);
			openSubState(new PauseSubState());
		}
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.chartingBind)])) && FlxG.save.data.moddingTools){ // Going to The ChartingState
			canDie = false;
			persistentUpdate = false;
			paused = true;
			Actions.States('Switch', new ChartingState());
		}
		if (FlxG.save.data.moddingTools){ // Dev Tools Shit (Acess Only Use Code in ConsoleCodeState)
			if (FlxG.keys.justPressed.DELETE) endChart();
			if (FlxG.keys.justPressed.PAGEUP) FlxG.switchState(new AnimationDebug((FlxG.save.data.charSelect != 1 ? SONG.player1 : CharacterSelect.charSelected))); // BF OFFSETS
			if (FlxG.keys.justPressed.PAGEDOWN) FlxG.switchState(new AnimationDebug(SONG.player2)); // OPPONENT OFFSETS
			if (FlxG.keys.justPressed.HOME) FlxG.switchState(new AnimationDebug(SONG.girlfriend)); // GF OFFSETS
		}
		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset) - iconP1.offsetX;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset) - iconP2.offsetX;
		if (startingSong){
			if (startedCountdown){
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0) startChart();
			}
		}else{
			Conductor.songPosition += FlxG.elapsed * 1000;
			if (!paused){
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;
				if (Conductor.lastSongPos != Conductor.songPosition){
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
				}
				if (refreshCum){ // Show Time Left to End Track
					var pussy:Float = Conductor.songPosition / 1000;
					var dick:Float = songLength / 1000;
					getCum = (dick - pussy);
					timerTrackTxt.text = 'Timeleft: ' + FlxStringUtil.formatTime(getCum);
				}
			}
		}
		Camera.cameraSection(SONG, camFollow, curStep, curBeat, dad, gf, boyfriend);
		Camera.cameraZooming('PlayStateUpdate', Camera.camZooming);
		if (FlxG.save.data.resetButton && (FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.resetBind)])) && !endTrack) health -= healthToDie;
		if (health <= 0 && !endTrack){
			canDie = true;
			(!Client.Public.endless ? death++ : death = 0);
			loops = 0;
			boyfriend.stunned = true;
			persistentUpdate = false;
			persistentDraw = false;
			paused = true;
			vocals.stop();
			FlxG.sound.music.stop();
			Actions.Flash(FlxG.camera, FlxColor.RED, 1);
			if (SONG.validScore && !Client.Public.botplay && Client.Public.endless) // ENDLESS SAVE SCORE
				Highscore.saveEndlessScore(SONG.song, chartScore, mainDifficulty);
			if (FlxG.save.data.autoRespawn && !Client.Public.endless){
				Actions.PlaySound('missSound/lose/fnf_loss_sfx' + GameOverSubstate.mapSuffix, 'character');
				Actions.States('Switch', new PlayState());
				new FlxTimer().start(0.01, function(tmr:FlxTimer){
					Actions.States('LoadSwitch', new PlayState());
				});
			}else
				openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			DiscordClient.globalPresence('PlayState', 'Death');
		}
		if (unspawnNotes[0] != null && unspawnNotes[0].strumTime - Conductor.songPosition < 1500){
			var dunceNote:Note = unspawnNotes[0];
			notes.add(dunceNote);
			var index:Int = unspawnNotes.indexOf(dunceNote);
			unspawnNotes.splice(index, 1);
		}
		if (generatedMusic){
			notes.forEachAlive(function(daNote:Note){
				daNote.active = (daNote.tooLate ? false : true);
				daNote.visible = (daNote.tooLate ? false : true);
				if (!daNote.modifiedByLua){
					if (Client.Public.downscroll){
						daNote.y = ((daNote.mustPress ? playerStrums : strumLineNotes).members[Math.floor(Math.abs(daNote.noteData))].y + 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						if (daNote.isSustainNote){
							daNote.y += (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null ? daNote.prevNote.height + 38 : daNote.height / 2);
							if (Client.Public.botplay || (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && !Client.Public.botplay && daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= (strumLine.y + Note.swagWidth / 2)){
								var swagRect = new FlxRect(0, 0, daNote.frameWidth * 2, daNote.frameHeight * 2);
								swagRect.height = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.y = daNote.frameHeight - swagRect.height;
								daNote.clipRect = swagRect;
							}
						}
					}else{
						daNote.y = ((daNote.mustPress ? playerStrums : strumLineNotes).members[Math.floor(Math.abs(daNote.noteData))].y - 0.45 * (Conductor.songPosition - daNote.strumTime) * FlxMath.roundDecimal(FlxG.save.data.scrollSpeed == 1 ? SONG.speed : FlxG.save.data.scrollSpeed, 2));
						if (daNote.isSustainNote){
							daNote.y -= (daNote.animation.curAnim.name.endsWith('end') && daNote.prevNote != null ? daNote.prevNote.height - 84 : daNote.height / 2);
							if (Client.Public.botplay || (!daNote.mustPress || daNote.wasGoodHit || daNote.prevNote.wasGoodHit && !daNote.canBeHit) && !Client.Public.botplay && daNote.y + daNote.offset.y * daNote.scale.y <= (strumLine.y + Note.swagWidth / 2)){
								var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
								swagRect.y = (strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].y + Note.swagWidth / 2 - daNote.y) / daNote.scale.y;
								swagRect.height -= swagRect.y;
								daNote.clipRect = swagRect;
							}
						}
					}
					if (daNote.mustPress){
						daNote.visible = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) daNote.angle = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = playerStrums.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}else if (!daNote.wasGoodHit){
						daNote.visible = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].visible;
						daNote.x = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].x;
						if (!daNote.isSustainNote) daNote.angle = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].angle;
						daNote.alpha = strumLineNotes.members[Math.floor(Math.abs(daNote.noteData))].alpha;
					}
					if (daNote.isSustainNote){
						daNote.x += (TrackMap.mapComplement != 'pixel' ? daNote.width / 1 : daNote.width / 1.375);
						daNote.alpha = 0.5;
					}
				}
				if (!daNote.mustPress && daNote.wasGoodHit) opponentNoteHit(daNote); // Opoonent Note Hit
				if ((daNote.mustPress && daNote.tooLate && !Client.Public.downscroll || daNote.mustPress && daNote.tooLate && Client.Public.downscroll) && daNote.mustPress){
					if (daNote.isSustainNote && daNote.wasGoodHit){
						daNote.kill();
						notes.remove(daNote, true);
					}else{
						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
						passNotes(daNote);
					}
				}
			});
		}
		if (!inCutscene) keyShit();
	}
	private function generateChart(dataPath:String):Void{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);
		curTrack = songData.song;
		vocals = (SONG.needsVoices ? new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song)) : new FlxSound());
		FlxG.sound.list.add(vocals);
		if (loops == 0){
			notes = new FlxTypedGroup<Note>();
			add(notes);
		}
		var noteData:Array<SwagSection>;
		noteData = songData.notes;
		for (section in noteData){
			for (songNotes in section.sectionNotes){
				var daStrumTime:Float = songNotes[0] + FlxG.save.data.offsetNote;
				if (daStrumTime < 0) daStrumTime = 0;
				var daNoteData:Int = Std.int(songNotes[1] % 4 /*arrowMax[numArrow]*/);
				var gottaHitNote:Bool = section.mustHitSection;
				if (songNotes[1] > 3 /*>= arrowMax[numArrow]*/) gottaHitNote = !section.mustHitSection;
				var oldNote:Note = (unspawnNotes.length > 0 ? unspawnNotes[Std.int(unspawnNotes.length - 1)] : null);
				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, songNotes[3], (gottaHitNote ? true : false));
				swagNote.sustainLength = songNotes[2];	
				swagNote.scrollFactor.set(0, 0);	
				var susLength:Float = swagNote.sustainLength;
				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);
				for (susNote in 0...Math.floor(susLength)){
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true, null, (gottaHitNote ? true : false));
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					sustainNote.mustPress = gottaHitNote;
					if (sustainNote.mustPress) sustainNote.x += FlxG.width / 2;
				}
				swagNote.mustPress = gottaHitNote;
				if (swagNote.mustPress) swagNote.x += FlxG.width / 2;
			}
		}
		unspawnNotes.sort(sortByShit);
		generatedMusic = true;
	}
	public function startCountdown():Void{
		DiscordClient.globalPresence('PlayState', 'StartCountdown');
		PlayStepEvents.startCountdownEvents(curTrack, dad, gf, boyfriend);
		inCutscene = false;
		if (loops == 0){
			generateScrolls(0, true);
			generateScrolls(1, true);
			StrumNote.ShowKeybindsTip((FlxG.save.data.noteKeybind ? add : null)); // don't notice, I wanted to make a different true and false :D
			lanePlayerScroll.x = playerStrums.members[0].x - 25;
			laneOpponentScroll.x = opponentStrums.members[0].x - 25;
		}
		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;
		var swagCounter:Int = 0;
		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer){
			TrackMap.eventStartCounter(add, swagCounter);
			swagCounter += 1;
		}, 5);
		if (mainDifficulty >= 4){
			switch (SONG.song.toLowerCase()){
				case 'senpai': if (curStep < 688) startGrabHealth('Player', 3, 1.2, 25, 6);
				case 'roses': if (curStep < 688) startGrabHealth('Player', 10, 1.4, 40, 3);
			}
		}
	}
	function startChart():Void{
		switch (curTrack){
			default:
				isPlayerMain = true;
				isOpponentMain = true;
			case 'Tutorial':
				bfCanDodge = true;
				isPlayerMain = true;
				isOpponentMain = true;
		}
		if (FlxG.save.data.songArtistMark) showSongMark();
		if (loops == 0 || stateShit != 'StoryMode') TweenHUD(null, 0.85, true);
		startingSong = false;
		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;
		if (!paused) Actions.PlayInst();
		FlxG.sound.music.onComplete = endChart;
		vocals.play();
		switch (curTrack){
			case 'Bopeebo' | 'Philly' | 'Blammed' | 'Cocoa' | 'Eggnog': TrackMap.allowedToHandbro = true;
			default: TrackMap.allowedToHandbro = false;
		}
	}
	private function generateScrolls(player:Int, tweenScroll:Bool):Void{
		for (i in 0...4/*arrowMax[numArrow]*/){
			var strumArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			var Xpos:Float = (Client.Public.mid ? 990 : 529);
			higherComboTxt.x = strumArrow.x + Xpos;
			higherComboTxt.y = strumArrow.y + (Client.Public.mid ? 40 : (Client.Public.downscroll ? -10 : 135));
			healthTxt.x = strumArrow.x + Xpos;
			healthTxt.y = strumArrow.y + (Client.Public.mid ? 60 : (Client.Public.downscroll ? -30 : 154));
			comboTxt.x = strumArrow.x + Xpos;
			comboTxt.y = strumArrow.y + (Client.Public.mid ? 80 : (Client.Public.downscroll ? -50 : 174));
			if (Client.Public.mid){
				statsCounterTxt.x = strumArrow.x + Xpos;
				statsCounterTxt.y = strumArrow.y + 260;
			}
			switch (TrackMap.mapComplement){
				default: StrumNote.LoadArrowAnimation('default', strumArrow, player, i);
				case 'pixel': StrumNote.LoadArrowAnimation('pixel', strumArrow, player, i);
			}
			strumArrow.ID = i;
			strumArrow.x += ((FlxG.width / 2) * player);
			switch (player){
				case 0: if (Client.Public.mid){
						strumArrow.visible = false;
						strumArrow.alpha = 0;
					}else{
						if (FlxG.save.data.map)
							StrumNote.TweenNote(strumArrow, tweenScroll, i);
						else{
							strumArrow.visible = false;
							strumArrow.alpha = 0;	
						}
					}
				case 1: if (Client.Public.mid){
						StrumNote.TweenNote(strumArrow, tweenScroll, i);
						strumArrow.x -= 276; // old -275
					}else
						StrumNote.TweenNote(strumArrow, tweenScroll, i);
			}
			switch (player){
				case 0: opponentStrums.add(strumArrow);
				case 1: playerStrums.add(strumArrow);
			}
			strumLineNotes.add(strumArrow);
		}
	}
	function endChart():Void{
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		FlxG.sound.music.stop();
		vocals.stop();
		ConsoleCodeState.secretSongName = '';
		CharacterSelect.getSongName = '';
		if (Client.Public.endless){
			canPause = true;
			canDie = true;
			endTrack = false;
			startingSong = true;
		}else{
			IsPlayState = false;
			canPause = false;
			canDie = false;
			endTrack = true;
			paused = true;
			death = 0;
			if (SONG.validScore && !Client.Public.botplay){
				#if !switch
					Highscore.saveScore(SONG.song, chartScore, mainDifficulty);
					Highscore.saveAccuracy(SONG.song, accuracy, mainDifficulty);
					Highscore.saveComboMax(SONG.song, highestCombo, mainDifficulty);
					Highscore.saveMisses(SONG.song, misses, mainDifficulty);
					Highscore.saveRating(SONG.song, Rating.generateRatingNames(accuracy), mainDifficulty);
					Highscore.saveFCRating(SONG.song, Rating.generateFCRating(accuracy), mainDifficulty);
				#end
			}
		}
		switch (stateShit){
			case 'StoryMode':
				campaignScore += Math.round(chartScore);
				storyPlaylist.remove(storyPlaylist[0]);
				if (storyPlaylist.length <= 0){
					Actions.PlayTrack(MainMenuState.EngineFreakyMenu);
					transIn = FlxTransitionableState.defaultTransIn;
					transOut = FlxTransitionableState.defaultTransOut;
					Cutscenes.endTrackCutscenes('StoryMode', 'End', curTrack, add, remove, camFollow, camHUD, camNOTE, laneCamera, death, mainDifficulty);
					StoryMenuState.StoryData.WeekUnlocked[Std.int(Math.min(StoryMenuState.storyWeek + 1, StoryMenuState.StoryData.WeekUnlocked.length - 1))] = true;
					if (SONG.validScore) Highscore.saveWeekScore(StoryMenuState.storyWeek, campaignScore, mainDifficulty);
					FlxG.save.data.weekUnlocked = StoryMenuState.StoryData.WeekUnlocked;
					FlxG.save.flush();
				}else{
					trace('Loading Next Chart: ' + PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(mainDifficulty));
					death = 0;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;
					prevCamFollow = camFollow;
					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(mainDifficulty), PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();
					Cutscenes.endTrackCutscenes('StoryMode', 'FinalTrack', curTrack, add, remove, camFollow, camHUD, camNOTE, laneCamera, death, mainDifficulty);
				}
			case 'Freeplay' | 'Secret':
				if (!Client.Public.endless)
					Cutscenes.endTrackCutscenes((stateShit != 'Secret'? 'Freeplay' : 'Secret'), null, curTrack, add, remove, camFollow, camHUD, camNOTE, laneCamera, death, mainDifficulty);
				else{
					loops++;
					if (SONG.speed < 8) SONG.speed += 0.075;
					FlxG.sound.music.volume = 1;
					vocals.volume = 1;
					Conductor.songPosition = -5000;
					generateChart(SONG.song);
					startCountdown();
				}
		}
	}
	public function AddTrail(player:String){ // Add Anim in Sing
		if (FlxG.save.data.map){
			switch (curTrack){
				case 'Thorns': if (player == 'Player') add(PlayStepEvents.bfThornsTrail);
				case 'Guns': if (curStep == 896) if (player == 'Opponent') add(PlayStepEvents.transcendsTrail);
			}
		}
	}
	public function removeTrail(player:String){ // Remove Trail on Idle Anim
		if (FlxG.save.data.map){
			switch (curTrack){
				case 'Thorns': if (player == 'Player') remove(PlayStepEvents.bfThornsTrail);
				case 'Guns': if (player == 'Opponent') remove(PlayStepEvents.transcendsTrail);
			}
		}
	}
	function notePlaySound(note:Note){
		switch (note.noteType){
			case 2:
				switch (SONG.song.toLowerCase()){
					default: if (curTrack != 'Tanpowder') Actions.PlaySound('gunShoot', 'character', VolumeShoot);
					case 'blammed':
						Actions.PlaySound('gunShoot', 'character', VolumeShoot);
						Actions.Shake(camGame, 0.02, 0.0225, null, true);
				}
		}
	}
	public function noteGetHealth(SprRating:String){ // Player Rating Note Hit Health Gain
		switch (SprRating){
			case 'shit':
				switch (SONG.song.toLowerCase()){
					default: switch (boyfriend.curCharacter){
						default: HealthAction('drain', 0.2); addsDamageHealthSpriteTake += 0.2;
						case 'bf-50Years-Phase1': HealthAction('drain', 0.2); addsDamageHealthSpriteTake += 0.2;
						case 'bf-50Years-Phase2': HealthAction('drain', 0.15); addsDamageHealthSpriteTake += 0.15;
						case 'bf-50Years-Phase3': HealthAction('drain', 0.5); addsDamageHealthSpriteTake += 0.5;
					}
					interuptgrabbedPlayerIconHealth = true;
				}
			case 'bad':
				switch (SONG.song.toLowerCase()){
					default: switch (boyfriend.curCharacter){
						default: HealthAction('drain', 0.06); addsDamageHealthSpriteTake += 0.06;
						case 'bf-50Years-Phase1': HealthAction('drain', 0.06); addsDamageHealthSpriteTake += 0.06;
						case 'bf-50Years-Phase2': HealthAction('drain', 0.0325); addsDamageHealthSpriteTake += 0.0325;
						case 'bf-50Years-Phase3': HealthAction('drain', 0.0815); addsDamageHealthSpriteTake += 0.0815;
					}
					interuptgrabbedPlayerIconHealth = true;
				}
			case 'good':
				switch (SONG.song.toLowerCase()){
					default: switch (boyfriend.curCharacter){
						default: if (health < 2 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.04);
						case 'bf-50Years-Phase1': if (health < 2.5 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.04);
						case 'bf-50Years-Phase2': if (health < 1.8 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.0275);
						case 'bf-50Years-Phase3': if (health < 20 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.06);
					}
				}
			case 'sick':
				switch (SONG.song.toLowerCase()){
					default: switch (boyfriend.curCharacter){
							default: if (health < 2 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.1);
							case 'bf-50Years-Phase1': if (health < 2.5 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.1);
							case 'bf-50Years-Phase2': if (health < 1.8 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.09);
							case 'bf-50Years-Phase3': if (health < 20 && !grabbedPlayerIcon && !noRagen) HealthAction('gain', 0.2);
						}
				}
		}
	}
	function passNotes(noteShit:Note){
		switch (noteShit.noteType){
			case 0 | 1:
				addsDamageHealthSpriteTake += 0.07;
				interuptgrabbedPlayerIconHealth = true;
				health -= 0.07;
				vocals.volume = 0;
				missNote(noteShit.noteData, noteShit);
			case 2: missNote(noteShit, false);
			case 3 | 4 | 5 | 7 | 8 | 9 | 10 | 11 | 12 | 13: // NOTES NOT TO PRESS
				vocals.volume = 1;
				getTypeSprite("Pass");
			case 6: // NEED PRESS NOTE
				vocals.volume = 0;
				health -= 0.3725;
				getTypeSprite("Pass");
		}
	}
	public function missNote(?direction:Int = 1, daNoteShit:Note, ?soundMiss:Bool = true):Void{
		if (!boyfriend.stunned){
			if (combo > 5 && gf.animation.exists('cry')) Actions.PlayCharAnim(gf, 'cry');
			if (soundMiss && FlxG.save.data.missSounds) Actions.PlayRandomSound('missSound/missnote', 1, 3, 'character', FlxG.random.float(0.1, 0.2));
			switch (daNoteShit.noteType){
				case 0 | 1: // Normal Notes (if you miss)
					switch (boyfriend.curCharacter){
						default: HealthAction('drain', 0.04); addsDamageHealthSpriteTake += 0.04;
						case 'bf-50Years-Phase1': HealthAction('drain', 0.04105); addsDamageHealthSpriteTake += 0.04105;
						case 'bf-50Years-Phase2': HealthAction('drain', 0.035); addsDamageHealthSpriteTake += 0.035;
						case 'bf-50Years-Phase3': HealthAction('drain', 0.825); addsDamageHealthSpriteTake += 0.825;
					}
					interuptgrabbedPlayerIconHealth = true;
					getTypeSprite("Miss");
					missedNote = true;
					chartScore -= 10;
					combo = 0;
					misses++;
					if (FlxG.save.data.missesHUD){
						missTxt.color = 0xFF6f0000;
						new FlxTimer().start(2.125, function(tmr:FlxTimer){
							if (paused)
								tmr.reset();
							else{
								missTxt.color = scoreTxt.color;
								missedNote = false;
							}
						});
					}
					if (isPlayerMain) SingDiretions('BFMiss', direction, daNoteShit);
				case 2: // DODGE NOTE (if you miss)
					getTypeSprite("Miss");
					missedNote = true;
					if (FlxG.save.data.missesHUD){
						missTxt.color = 0xFF6f0000;
						new FlxTimer().start(2.125, function(tmr:FlxTimer){
							if (paused)
								tmr.reset();
							else{
								missTxt.color = scoreTxt.color;
								missedNote = false;
							}
						});
					}
					switch (SONG.song.toLowerCase()){
						case 'philly': trace("BOYFRIEND CUM ON ME DUDE!"); // (Not Finish)
							Actions.PlaySound('gunShoot', 'character', VolumeShoot);
							Actions.PlayCharAnim(gf, 'cry', true, false, 0, true);
							Actions.Shake(camNOTE, 0.265);
							Actions.Shake(camGame, 0.265);
							Actions.Shake(camHUD, 0.265);
							Actions.Shake(laneCamera, 0.265);
							HealthAction('drain', 0.4);
						case 'tanpowder': trace("YOU A GONA DIE!");
							switch (mainDifficulty){
								case 4: // Extra Hard
									Actions.Shake(camGame);
									Actions.Shake(camNOTE);
									Actions.Shake(camHUD);
									Actions.Shake(laneCamera);
									HealthAction('drain', (boyfriend.curCharacter != 'bf-50Years-Phase3' ? 0.215 : 1.325));
							}
					}
					Actions.PlayCharAnim(boyfriend, 'hited', true, false, 0, true);
					Actions.PlayCharAnim(dad, Character.talkAction + Character.dickShooter, true, false, 0, true);
					/*Actions.PlayCharAnim(dad, Character.talkAction + Character.dickShooter, true, false, 0, true);
					new FlxTimer().start(0.001, function(tmr:FlxTimer){
						Actions.PlayCharAnim(dad, Character.talkAction + Character.dickShooter, true, false, 0, true);
					});
					Actions.PlayCharAnim(boyfriend, 'hited', true, false, 0, true);
					Actions.PlayCharAnim(boyfriend, 'hited', true, false, 0, true);
					new FlxTimer().start(0.001, function(tmr:FlxTimer){
						Actions.PlayCharAnim(boyfriend, 'hited', true, false, 0, true);
					});*/
				case 5 | 7 | 8 | 9 | 10 | 11 | 12 | 13:
					if (isPlayerMain) SingDiretions('BFMiss', direction, daNoteShit);
					getTypeSprite("Miss");
					missedNote = true;
					if (FlxG.save.data.missesHUD){
						missTxt.color = 0xFF6f0000;
						new FlxTimer().start(2.125, function(tmr:FlxTimer){
							if (paused)
								tmr.reset();
							else{
								missTxt.color = scoreTxt.color;
								missedNote = false;
							}
						});
					}
			}
			refreshStats();
		}
	}
	public function singDiretionActions(TypePlayer:String, note:Note, ?diretion:Int, ?altAnim:String){
		var i = note.noteData;
		var idMiss = diretion;
		switch (TypePlayer){
			case 'MISS': Actions.PlayCharAnim(boyfriend, Character.talkAction + diretionSing[idMiss] + Character.actionMiss, true, false, 0, true);
			case 'P1': switch (note.noteType){
					case 0: Actions.PlayCharAnim(boyfriend, Character.talkAction + diretionSing[i], true, false, 0, true, true);
					case 1: Actions.PlayCharAnim(boyfriend, Character.talkAction + diretionSing[i] + Character.alternativeAnimation, true, false, 0, true, true);
					case 2: Actions.PlayCharAnim(gf, 'cheer', true, false, 0, true);
						Actions.PlayCharAnim(boyfriend, Character.talkAction + diretionDodge[i], true, false, 0, true, true);
						switch (SONG.song.toLowerCase()){ // Opponents Shoots in Player Hit DODGE NOTES
							case 'blammed': Actions.PlayCharAnim(dad, Character.talkAction + diretionShoot[i], true, false, 0, true, true);
							case 'tanpowder': Actions.PlayCharAnim(dad, Character.talkAction + diretionShoot[i], true, false, 0, true, true);
						}
				}
			case 'P2': switch (note.noteType){ // Opponents Shoots in Hiting Alert Notes
					case 0: Actions.PlayCharAnim(dad, Character.talkAction + diretionSing[i] + altAnim, true, false, 0, true, true);
					case 1: Actions.PlayCharAnim(dad, Character.talkAction + diretionSing[i] + Character.alternativeAnimation, true, false, 0, true, true);
					case 2: switch (SONG.song.toLowerCase()){
							case 'blammed': Actions.PlayCharAnim(dad, Character.talkAction + diretionShoot[i], true, false, 0, true, true);
							case 'tanpowder': Actions.PlayCharAnim(dad, Character.talkAction + diretionShoot[i], true, false, 0, true, true);
						}
				}
		}
	}
	function playerNoteHit(note:Note, resetMashViolation = true):Void{ // Player Note Hit
		if (mashing != 0) mashing = 0;
		if (mashViolations < 0) mashViolations = 0;
		if (!resetMashViolation && mashViolations >= 1) mashViolations--;
		note.rating = Rating.noteMs(-(note.strumTime - Conductor.songPosition));
		switch (note.rating){
			case "miss": return;
			case "sick": if (FlxG.save.data.splashScroll && !note.isSustainNote){
				var recycledNote = grpPlayerNoteSplashes.recycle(Player_NoteSplash);
				recycledNote.setupPlayerSplash(playerStrums.members[note.noteData].x, playerStrums.members[note.noteData].y, note.noteData);
				grpPlayerNoteSplashes.add(recycledNote);
			}
		}
		if (!note.wasGoodHit){
			if (!note.isSustainNote){
				if (Client.Public.botplay)
					popUpStats(note, true);
				else{
					if (note.noteType == 0 || note.noteType == 1) popUpStats(note, false);
					popUpAcc(note);
				}
				notePlaySound(note);
			}else 
				if (!Client.Public.botplay){
					totalNotesHit += 1; // + 0.01 Accuracy of Hold Notes
					chartScore += 1; // +1 Score of Hold Notes
				}
			if (!grabbedPlayerIcon && !noRagen) health += 0.015; // +0.015 Health of Hold Notes
			LoadActionsNotes(true, note); // Set Custom Notes Mechanics
			TweenHitHUD('Press&Hold', 1.1, note);
			AddTrail('Player'); // Player Set Trail
			if (isPlayerMain) SingDiretions('BF', note); // Player Sing Diretions
			if (FlxG.save.data.strumMove) StrumNote.StrumMoveOnHit('P1', note); // Player Strums Move on Hit Note
			playerStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('PlayerHit', spr, note); // on Hit Note Glown Note
			});
			note.wasGoodHit = true;
			vocals.volume = 1;
			if (!note.isSustainNote){
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			refreshStats();
		}
	}
	function opponentNoteHit(daNote:Note){ // Opponent Note Hit
		Camera.cameraMakeOn('OpponentSings', SONG.song.toLowerCase());
		var opponentHitedCounter:Int = 0;
		if (!Client.Public.mid && Client.Public.map && FlxG.save.data.splashScroll && FlxG.save.data.opponentGlownHit && !daNote.isSustainNote){
			var recycledNote = grpOpponentNoteSplashes.recycle(Opponent_NoteSplash);
			recycledNote.setupOpponentSplash(opponentStrums.members[daNote.noteData].x, opponentStrums.members[daNote.noteData].y, daNote.noteData);
			grpOpponentNoteSplashes.add(recycledNote);
		}
		var altAnim:String = "";
		if (SONG.notes[Math.floor(curStep / 16)] != null) if (SONG.notes[Math.floor(curStep / 16)].altAnim) altAnim = '-alt';
		if (!playerTurn && !daNote.isSustainNote && opponentHitedCounter % 100 == 0) interuptgrabbedOpponentHealth = true;
		switch (curTrack){
			case 'Roses': if (grabbedOpponentIcon)
					opponentHitedCounter++;
				else{
					if (mainDifficulty == 4) if (curStep >= 64) HealthAction('drain', 0.0325);
				}
			case 'Stress': if (curStep >= 896 && curStep < 960) Camera.PlayStateZoom(0.03);
			case 'Tanpowder': if (curStep >= 1820 && curStep < 1828){
					Actions.Shake(camGame, 0.03, 0.075);
					Actions.Shake(camNOTE, 0.03, 0.075);
					Actions.Shake(camHUD, 0.03, 0.075);
					Actions.Shake(laneCamera, 0.03, 0.075);
				}
		}
		AddTrail('Opponent');
		ShakingSingChars('OpponentSing');
		if (isOpponentMain) SingDiretions('Opponent', altAnim, daNote); // Opponent Sings Diretions
		if (FlxG.save.data.strumMove) StrumNote.StrumMoveOnHit('P2', daNote); // Player Strums Move on Hit Note
		if (FlxG.save.data.opponentGlownHit){
			opponentStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('OpponentHit', spr, daNote); // on Hit Note Glown Note
			});
		}
		dad.holdTimer = 0;
		if (SONG.needsVoices) vocals.volume = 1;
		daNote.kill();
		notes.remove(daNote, true);
		daNote.destroy();
	}
	public function refreshStats(){
		totalPlayed += 1;
		accuracy = Math.max(0,totalNotesHit / totalPlayed * 100);
		accuracyDefault = Math.max(0, totalNotesHitDefault / totalPlayed * 100);
		if (!Client.Public.botplay && FlxG.save.data.rating < 2) ratingTxt.text = "Rating: " + Rating.getRatings(accuracy);
		comboTxt.text = 'Combo: $combo'; // Combo
		missTxt.text = 'Misses: $misses'; // Misses
		higherComboTxt.text = 'HighestCombo: $highestCombo'; // MaxCombo
		accuracyTxt.text = "Accuracy: " + CoolUtil.floatDecimals(accuracy, 2) + "%"; // Acuracy
		statsCounterTxt.text = 'Sicks: ${sicks}\nGoods: ${goods}\nBads: ${bads}\nShits: ${shits}\nBadNotes: ${badNote}'; // Rating Counter
	}
	override function stepHit(){
		super.stepHit();
		PlayStepEvents.stepEvents(add, remove, curTrack, SONG.song.toLowerCase(), dad, gf, boyfriend, healthBar, curStep, curBeat, SONG, mainDifficulty, HealthIcon.danceIcons, Camera.camZooming, CharacterSettigs.gfSpeed, iconP1, iconP2, camHUD, camNOTE, laneCamera, playerStrums, opponentStrums, strumLineNotes, notes, paused);
	}
	override function beatHit(){
		super.beatHit();
		PlayBeatEvents.beatEvents(add, remove, curTrack, SONG.song.toLowerCase(), dad, gf, boyfriend, healthBar, curStep, curBeat, SONG, mainDifficulty, HealthIcon.danceIcons, Camera.camZooming, CharacterSettigs.gfSpeed, iconP1, iconP2, camHUD, camNOTE, laneCamera, playerStrums, opponentStrums, strumLineNotes, notes, paused);
	}
	function scrollSkin(skin:Array<String>){
		setScrollSkin(skin[0], 0, false);
		setScrollSkin(skin[1], 1, false);
	}
	private function setScrollSkin(skinName:String, player:Int, tweenScroll:Bool):Void{
		for (i in 0...4/*arrowMax[numArrow]*/){
			var strumArrow:FlxSprite = new FlxSprite(0, strumLine.y);
			var Xpos:Float = (Client.Public.mid ? 990 : 529);
			higherComboTxt.x = strumArrow.x + Xpos;
			higherComboTxt.y = strumArrow.y + (Client.Public.mid ? 40 : (Client.Public.downscroll ? -10 : 135));
			healthTxt.x = strumArrow.x + Xpos;
			healthTxt.y = strumArrow.y + (Client.Public.mid ? 60 : (Client.Public.downscroll ? -30 : 154));
			comboTxt.x = strumArrow.x + Xpos;
			comboTxt.y = strumArrow.y + (Client.Public.mid ? 80 : (Client.Public.downscroll ? -50 : 174));
			if (Client.Public.mid){
				statsCounterTxt.x = strumArrow.x + Xpos;
				statsCounterTxt.y = strumArrow.y + 260;
			}
			StrumNote.LoadArrowAnimation(skinName, strumArrow, i);
			strumArrow.ID = i;
			strumArrow.x += ((FlxG.width / 2) * player);
			switch (player){
				case 0: if (Client.Public.mid){
						strumArrow.visible = false;
						strumArrow.alpha = 0;
					}else{
						if (FlxG.save.data.map)
							StrumNote.TweenNote(strumArrow, tweenScroll, i);
						else{
							strumArrow.visible = false;
							strumArrow.alpha = 0;	
						}
					}
				case 1: if (Client.Public.mid){
						StrumNote.TweenNote(strumArrow, tweenScroll, i);
						strumArrow.x -= 276; // old -275
					}else
						StrumNote.TweenNote(strumArrow, tweenScroll, i);
			}
			switch (player){
				case 0: opponentStrums.add(strumArrow);
				case 1: playerStrums.add(strumArrow);
			}
			strumLineNotes.add(strumArrow);
		}
	}
	function ChangeChar(PLayerN:String, idChar:String, offsetX:Null<Int> = 0, offsetY:Null<Int> = 0){
		switch (PLayerN){
			case 'Opponent':
				if (offsetX == 0 && offsetY == 0){
					var oldDADX = dad.x;
					var oldDADY = dad.y;
					remove(dad);
					dad = new Character(oldDADX, oldDADY, idChar);
					add(dad);
				}else{
					remove(dad);
					dad = new Character(offsetX, offsetY, idChar);
					add(dad);
				}
				Actions.PlaySprAnim(iconP2, idChar);
			case 'GirlFriend':
				if (offsetX == 0 && offsetY == 0){
					var oldGFX = gf.x;
					var oldGFY = gf.y;
					remove(gf);
					gf = new Character(oldGFX, oldGFY, idChar);
					add(gf);
				}else{
					remove(gf);
					gf = new Character(offsetX, offsetY, idChar);
					add(gf);
				}
			case 'Player':
				if (offsetX == 0 && offsetY == 0){
					var oldBFX = boyfriend.x;
					var oldBFY = boyfriend.y;
					remove(boyfriend);
					boyfriend = new Boyfriend(oldBFX, oldBFY, idChar);
					add(boyfriend);
				}else{
					remove(boyfriend);
					boyfriend = new Boyfriend(offsetX, offsetY, idChar);
					add(boyfriend);
				}
				Actions.PlaySprAnim(iconP1, idChar);
		}
	}
	function ShakingSingChars(player:String){
		switch (player){
			case 'OpponentSing': switch (dad.curCharacter){
					case 'pico':
						if (curTrack == 'Philly' && curBeat >= 168 && curBeat < 216){
							Actions.Shake(camNOTE, 0.0125, 0.02, null, true, FlxAxes.X);
							Actions.Shake(camGame, 0.0125, 0.02, null, true, FlxAxes.X);
							Actions.Shake(camHUD, 0.0125, 0.02, null, true, FlxAxes.X);
							Actions.Shake(laneCamera, 0.0125, 0.02, null, true, FlxAxes.X);
						}
				}
			case 'PlayerSing':
				switch (boyfriend.curCharacter){}
		}
	}
	function Alert(TypeAlert:Int = 0, ?Vol_Alert:Float = 1):Void{
		trace('Danger Incoming');
		switch (TypeAlert){
			case 0:
				//alertSprite.animation.play('alert);
				Actions.PlaySound('alert', 'character', Vol_Alert);
				//kb_attack_alert.animation.play('alert');
				//FlxG.sound.play(Paths.sound('alert','qt'), Vol_Alert);
		}
	}
	function OpponentAttack(Attacked:Bool):Void{
		if (Attacked){ // Attack Anim
			//kb_attack_saw.animation.play('fire');
			//kb_attack_saw.offset.set(1600, 0);
			switch (SONG.song.toLowerCase()){
				case 'philly':
					Actions.PlaySound('alert', 'character');
					Actions.PlayCharAnim(dad, 'shoot', true, false, 0, true);
					trace('DIE!');
			}
			new FlxTimer().start(0.09, function(tmr:FlxTimer){
				if (!bfDodging) health -= healthToDie; // It Check Auto to Die
			});
		}else{ // Prepare to Attack (Anim)
			//kb_attack_saw.animation.play('prepare');
			//kb_attack_saw.offset.set(-333, 0);
		}
	}
	public function SingDiretions(?Player:String, ?direction:Int = 1, ?altAnim:String, note:Note){
		switch (Player){
			case 'BFMiss': singDiretionActions('MISS', note, direction);
			case 'BF':
				Camera.PresetCam('BF', CachingState.CacheConfig.camMoveNum, note);
				singDiretionActions('P1', note);
			case 'Opponent':
				Camera.PresetCam('Opponent', CachingState.CacheConfig.camMoveNum, note);
				singDiretionActions('P2', note, altAnim);
		}
	}
	public static function Teleport(?FLIPX:Null<Bool> = null, ?FLIPY:Null<Bool> = null, ?setLocation:Bool = false, ?bfX:Null<Float> = null, ?bfY:Null<Float> = null, ?opponentX:Null<Float> = null, ?opponentY:Null<Float> = null){
			var BF = PlayState.instance.boyfriend;
			var OPPONENT = PlayState.instance.dad;
			if (FLIPX != null){
				if (setLocation){
					if (bfX != null) BF.x = bfX;
					if (opponentX != null) OPPONENT.x = opponentX;
				}else{
					BF.x += (bfX == null ? 0 : bfX);
					OPPONENT.x += (opponentX == null ? 0 : opponentX);
				}
				if (FLIPY != null) BF.flipX = FLIPX;
			}
			if (FLIPX != null){
				if (setLocation){
					if (bfY != null) BF.y = bfY;
					if (opponentY != null) OPPONENT.y = opponentY;
				}else{
					BF.y += (bfY == null ? 0 : bfY);
					OPPONENT.y += (opponentY == null ? 0 : opponentY);
				}
				if (FLIPY != null) BF.flipY = FLIPY;
			}
			if (FLIPX != null){
				for (i in 0...PlayState.strumLineNotes.length){
					if ((FLIPX ? i >= 4 : i <= 3))
						Actions.Tween(strumLineNotes.members[i], {x: 50 + Note.swagWidth * (i % 4)}, 0.001, {ease: FlxEase.linear});
					else
						Actions.Tween(strumLineNotes.members[i], {x: (50 + (FlxG.width / 2)) + Note.swagWidth * (i % 4)}, 0.001, {ease: FlxEase.linear});
				}
			}
	}
	public static function HealthAction(nameItem:String, ?Action:Float = 0.1){ // Just Modchart for Source Code :D
		switch (nameItem){
			case 'set': PlayState.instance.health = Action; // Set Value Static Health Example 2 (FULL HEALTH IMMEDIATE)
			case 'gain': PlayState.instance.health += Action; // Set Value to Healing
			case 'drain': PlayState.instance.health -= Action; // Set Value to Drain
		}
	}
	function HealthType(ForceHealth:Bool, ?amouthHealth:Float):Void{ // Defines How Much Maximum Health You Will Have.
		if (ForceHealth){
			var opponentToUse:Float = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);
			if (iconP2.x - iconP2.width / 2 < healthBar.x && iconP2.x > opponentToUse){
				healthBarBG.offset.x = iconP2.x - opponentToUse;
				healthBar.offset.x = iconP2.x - opponentToUse;
			}else{
				healthBarBG.offset.x = 0;
				healthBar.offset.x = 0;
			}
			iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange((health / 2 * 100), 0, 100, 100, 0) * 0.01) - iconOffset);
			iconP2.x = opponentToUse;
			if (health > amouthHealth) health = amouthHealth;
			healthToDie = amouthHealth + 1;
			healthDrain = amouthHealth / 11; // ~30% Lost
			healthToScale = amouthHealth;
			healthLimiter = amouthHealth;
		}else{
			if (health > 2) health = 2;
			healthToDie = 3;
			healthDrain = 0.4375; // ~30% lost
			healthToScale = 2;
			healthLimiter = 2;
		}
	}
	function FlashBang(isPlayer:Bool, ?Duration:Float = 2.4725, ?scoreShit:Null<Int> = 100, ?note:Note):Void{
		if (isPlayer){
			misses++;
			badNote++;
			combo = 0;
			chartScore -= scoreShit;
			missNote(note.noteData, note);
		}
		Actions.Flash(camHUD, 0xFFFFFFFF, Duration, true);
		Actions.PlaySound('flashBang', 'shared');
		Actions.SetAlphaScroll(strumLineNotes, 0, 1, {ease: FlxEase.cubeOut});
		TweenHUD(0, 1, true);
		new FlxTimer().start(1, function(tmr:FlxTimer){
			Actions.SetAlphaScroll(strumLineNotes, 1, 1, {ease: FlxEase.cubeOut});
			TweenHUD(null, 1, true);
		});
	}
	function BlockHealth(player:Bool = false, ?note:Note){ // Block Health Gain on Hit Note
		new FlxTimer().start(8, function(unLockRagen:FlxTimer) { if (player) noRagen = false;});
		if (player){
			noRagen = true;
			missNote(note.noteData, note);
			chartScore -= 50;
			combo = 0;
			badNote++;
			misses++;
		}else{}
	}
	function PoisonHealth(player:Bool = false, ?timerShit:Float = 0.0001, ?healthDrainShit:Float = 0.0005, ?scoreShit:Null<Int> = 300, ?note:Note):Void{
		if (player){
			misses++;
			badNote++;
			combo = 0;
			chartScore -= scoreShit;
			missNote(note.noteData, note);
			healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? dad.healthBarColor : 0xFF5400FF), (FlxG.save.data.colourCharIcon ? 0xFFFF0000 : 0xFF5400FF));
		}else
			healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? 0xFF5400FF : boyfriend.healthBarColor), (FlxG.save.data.colourCharIcon ? 0xFF5400FF : 0xFF66FF33));
		var healthDrained:Float = 0;
		new FlxTimer().start(timerShit, function(swagTimer:FlxTimer){
			if (player){
				health -= healthDrainShit;
				healthDrained += healthDrainShit;
			}else{
				health += healthDrainShit;
				healthDrained += healthDrainShit;
			}
			if (healthDrained < 0.5)
				swagTimer.reset();
			else{
				healthDrained = 0;
				healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? dad.healthBarColor : 0xFFFF0000), (FlxG.save.data.colourCharIcon ? boyfriend.healthBarColor : 0xFF66FF33));
				healthBar.updateBar();
			}
		});
	}
	function RegenerationHealth(player:Bool = false, ?timerShit:Float = 0.0001, ?healingGet:Float = 0.000425, ?scoreShit:Null<Int> = 325):Void{ // Ragen You Healtn 
		if (player){
			combo = 0;
			chartScore += scoreShit;
			healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? dad.healthBarColor : 0xFFFF0000), (FlxG.save.data.colourCharIcon ? 0xFFFF00D2 : 0xFFFF00D2));
		}else
			healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? 0xFFFF00D2 : boyfriend.healthBarColor), (FlxG.save.data.colourCharIcon ? 0xFFFF00D2 : 0xFF66FF33));
		var healthGained:Float = 0;
		new FlxTimer().start(timerShit, function(swagTimer:FlxTimer){
			if (player){
				health += healingGet;
				healthGained += healingGet;
			}else{
				health -= healingGet;
				healthGained += healingGet;
			}
			if (healthGained < 0.5)
				swagTimer.reset();
			else{
				healthGained = 0;
				healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? dad.healthBarColor : 0xFFFF0000), (FlxG.save.data.colourCharIcon ? boyfriend.healthBarColor : 0xFF66FF33));
				healthBar.updateBar();
			}
		});
	}
	function CrashShit(){ // This Game Crash, Is Nice :D
		var thisF:FlxSprite = new FlxSprite();
		thisF.frames = Paths.getSparrowAtlas('bitch');
		thisF.setGraphicSize(FlxG.width, FlxG.height);
		thisF.width = 1280;
		thisF.height = 720;
		thisF.x = 0;
		thisF.y = 0;
		thisF.screenCenter(X);
		thisF.cameras = [camNOTE, camHUD];
		add(thisF);
		new FlxTimer().start(0.125, function(tmr:FlxTimer){
			FlxG.sound.play(Paths.sound('sus','shared'), 1); // no fix this, this is good to crash
			new FlxTimer().start(0.25, function(tmr:FlxTimer){
				persistentUpdate = false;
				persistentDraw = true;
				paused = true;
				if (FlxG.sound.music != null){
					FlxG.sound.music.pause();
					vocals.pause();
				}
				notes.clear();
				var wtfthiscrap = new FlxSprite(0, 0, FlxScreenGrab.grab().bitmapData);
				wtfthiscrap.cameras = [camNOTE, camHUD];
				add(wtfthiscrap);
				new FlxTimer().start(0.415, function(tmr:FlxTimer){
					System.exit(0);
					trace('Crashed');
				});
			});

		});
	}
	function LoadActionsNotes(isPlayerNote:Bool, note:Note){ // Load Mechanics of Custom Fack Notes :D I Love This
		if (isPlayerNote){
			switch (note.noteType){
				case 3: health += 0.325; // HEAL NOTE
				case 4: RegenerationHealth(true); // RAGEN NOTE
				case 5: BlockHealth(true, note); // BLOCK HEALTH
				case 6: chartScore += 125; // NEED PRESS NOTE
				case 7: // DAMAGE NOTE
					chartScore -= 500;
					misses++;
					badNote++;
					combo = 0;
					health -= healthDrain;
					missNote(note.noteData, note);
				case 8: PoisonHealth(true, note); // POISON NOTE
				case 9: ScrollBlock(true, note); // BLOCK SCROLL
				case 10: FlashBang(true, note);  // FLSAH NOTE
				case 11: // In-Fection Note
					badNote++;
				case 12: health -= healthToDie; // DEATH NOTE: It Check Auto to Die
				case 13: CrashShit(); // CORRUPT NOTE
			}
		}else{}
    }
	function ScrollBlock(?player:Bool = false, ?note:Note){ // Strum Lock PadLock Members
			var padLockLEFT = new FlxSprite(playerStrums.members[0].x - 16, playerStrums.members[0].y - 47.50);
			var padLockDOWN = new FlxSprite(playerStrums.members[1].x - 16, playerStrums.members[1].y - 47.50);
			var padLockUP = new FlxSprite(playerStrums.members[2].x - 16, playerStrums.members[2].y - 47.50);
			var padLockRIGHT = new FlxSprite(playerStrums.members[3].x - 16, playerStrums.members[3].y - 47.50);
		if (FlxG.save.data.visualEffects){
			//LEFT
			padLockLEFT.frames = Paths.getSparrowAtlas('note/sprTypes/StrumLocked');
			padLockLEFT.animation.addByPrefix('lockedLeft', "Locked", 24, false);
			padLockLEFT.animation.addByPrefix('unLockedLeft', "Unlock", 24, false);
			//DOWN
			padLockDOWN.frames = Paths.getSparrowAtlas('note/sprTypes/StrumLocked');
			padLockDOWN.animation.addByPrefix('lockedDown', "Locked", 24, false);
			padLockDOWN.animation.addByPrefix('unLockedDown', "Unlock", 24, false);
			//UP
			padLockUP.frames = Paths.getSparrowAtlas('note/sprTypes/StrumLocked');
			padLockUP.animation.addByPrefix('lockedUp', "Locked", 24, false);
			padLockUP.animation.addByPrefix('unLockedUp', "Unlock", 24, false);
			//RIGHT
			padLockRIGHT.frames = Paths.getSparrowAtlas('note/sprTypes/StrumLocked');
			padLockRIGHT.animation.addByPrefix('lockedRight', "Locked", 24, false);
			padLockRIGHT.animation.addByPrefix('unLockedRight', "Unlock", 24, false);
			add(padLockLEFT);
			add(padLockDOWN);
			add(padLockUP);
			add(padLockRIGHT);
			padLockLEFT.cameras = [camHUD];
			padLockDOWN.cameras = [camHUD];
			padLockUP.cameras = [camHUD];
			padLockRIGHT.cameras = [camHUD];
			padLockLEFT.animation.play('lockedLeft', true);
			padLockDOWN.animation.play('lockedDown', true);
			padLockUP.animation.play('lockedUp', true);
			padLockRIGHT.animation.play('lockedRight', true);
		}
		new FlxTimer().start(3.125, function(timer:FlxTimer){
			if (FlxG.save.data.visualEffects){
				padLockLEFT.animation.play('unLockedLeft', true);
				padLockDOWN.animation.play('unLockedDown', true);
				padLockUP.animation.play('unLockedUp', true);
				padLockRIGHT.animation.play('unLockedRight', true);
			}
			new FlxTimer().start(0.23135, function(destroyPadLock:FlxTimer){
				scrollLocked = false;
				if (FlxG.save.data.visualEffects){
					remove(padLockLEFT);
					remove(padLockDOWN);
					remove(padLockUP);
					remove(padLockRIGHT);
				}
			});
		});
		scrollLocked = true;
		if (player){
			missNote(note.noteData, note);
			chartScore -= 150;
			combo = 0;
			badNote++;
			misses++;
		}
	}
	function ratingSpriteColor(ratingName:String){
		var colorHUDRating:Array<Int> = [
			0xFF482601, // Shit
			0xFFcf0112, // Bad
			0xFF13ab01, // Good
			0xFFfffb01 // Sick
		];
		if (FlxG.save.data.ratinghudcolor){
			switch (ratingName){
				case 'shit':
					scoreTxt.color = colorHUDRating[0];
					if (!missedNote) missTxt.color = colorHUDRating[0];
					accuracyTxt.color = colorHUDRating[0];
				case 'bad':
					scoreTxt.color = colorHUDRating[1];
					if (!missedNote) missTxt.color = colorHUDRating[1];
					accuracyTxt.color = colorHUDRating[1];
				case 'good':
					scoreTxt.color = colorHUDRating[2];
					if (!missedNote) missTxt.color = colorHUDRating[2];
					accuracyTxt.color = colorHUDRating[2];
				case 'sick':
					scoreTxt.color = colorHUDRating[3];
					if (!missedNote) missTxt.color = colorHUDRating[3];
					accuracyTxt.color = colorHUDRating[3];
			}
		}
	}
	function TweenHitHUD(NameNotePress:String = '', numScaleTweenEffect:Float, ?note:Note):Void{
		if (!Client.Public.botplay){
			if (FlxG.save.data.hitHUDEffect){ // Visual Effets need stain on
				if (NameNotePress == 'Press'){ // Pressed
					if (FlxG.save.data.maxComboHUD){ // Max Combo HUD Effect
						if (higherComboTxtTween != null) higherComboTxtTween.cancel();
						higherComboTxt.scale.x = numScaleTweenEffect;
						higherComboTxt.scale.y = numScaleTweenEffect;
						higherComboTxtTween = FlxTween.tween(higherComboTxt.scale, {x: 1, y: 1}, 0.2,{
							onComplete: function(twn:FlxTween){
								higherComboTxtTween = null;
							}
						});
					}
				}
				if (NameNotePress == 'Press&Hold'){ // HUD EFFETS HUDS, Pressed and Hold
					if (FlxG.save.data.scoreHUD){ // Score Hud Effet
						if (scoreTxtTween != null) scoreTxtTween.cancel();
						scoreTxt.scale.x = numScaleTweenEffect;
						scoreTxt.scale.y = numScaleTweenEffect;
						scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2,{
							onComplete: function(twn:FlxTween){
								scoreTxtTween = null;
							}
						});
					}
					if (FlxG.save.data.accuracyHUD){
						if (accuracy < 100){
							if (accuracyTxtTween != null) accuracyTxtTween.cancel();
							accuracyTxt.scale.x = numScaleTweenEffect;
							accuracyTxt.scale.y = numScaleTweenEffect;
							accuracyTxtTween = FlxTween.tween(accuracyTxt.scale, {x: 1, y: 1}, 0.2,{
								onComplete: function(twn:FlxTween){
									accuracyTxtTween = null;
								}
							});
						}
					}
					if (FlxG.save.data.rating < 2){
						if (accuracy < 100){
							if (ratingTxtTween != null) ratingTxtTween.cancel();
							ratingTxt.scale.x = numScaleTweenEffect;
							ratingTxt.scale.y = numScaleTweenEffect;
							ratingTxtTween = FlxTween.tween(ratingTxt.scale, {x: 1, y: 1}, 0.2,{
								onComplete: function(twn:FlxTween){
									ratingTxtTween = null;
								}
							});
						}
					}
					if (FlxG.save.data.hpHUDPercent){ // Health HUD Effet
						if (health < healthToScale){
							if (healthTxtTween != null) healthTxtTween.cancel();
							healthTxt.scale.x = numScaleTweenEffect;
							healthTxt.scale.y = numScaleTweenEffect;
							healthTxtTween = FlxTween.tween(healthTxt.scale, {x: 1, y: 1}, 0.2,{
								onComplete: function(twn:FlxTween){
									healthTxtTween = null;
								}
							});
						}
					}
					if (FlxG.save.data.comboHUD){ // Combo Hud Effect
						if (!note.isSustainNote){
							if (comboTxtTween != null) comboTxtTween.cancel();
							comboTxt.scale.x = numScaleTweenEffect;
							comboTxt.scale.y = numScaleTweenEffect;
							comboTxtTween = FlxTween.tween(comboTxt.scale, {x: 1, y: 1}, 0.2,{
								onComplete: function(twn:FlxTween){
									comboTxtTween = null;
								}
							});
						}
					}
				}
			}
		}
    }
	function sortByShit(Obj1:Note, Obj2:Note):Int{ return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime); }
	public function resyncVocals():Void{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}
	override function openSubState(SubState:FlxSubState){
		if (paused){
			if (FlxG.sound.music != null){
				FlxG.sound.music.pause();
				vocals.pause();
			}
			DiscordClient.globalPresence('PlayState', 'OpenSubState');
			if (!startTimer.finished) startTimer.active = false;
		}
		super.openSubState(SubState);
	}
	override function closeSubState(){
		if (PauseSubState.goToOptions){
			if (PauseSubState.goBack){
				PauseSubState.goToOptions = false;
				PauseSubState.goBack = false;
				FlxG.mouse.visible = false;
				openSubState(new PauseSubState());
			}else
				openSubState(new OptionsMenu(true));
		}else if (paused){
			if (FlxG.sound.music != null && !startingSong) resyncVocals();
			if (!startTimer.finished) startTimer.active = true;
			paused = false;
			DiscordClient.globalPresence('PlayState', 'CloseSubState');
		}
		super.closeSubState();
	}
	public function TweenHUD(?Alpha:Float = null, ?Duration:Float = 1, ?laneCameraProcesed:Bool = false){
		Actions.Alpha(healthBarBG, (Alpha != null ? Alpha : FlxG.save.data.healthHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(healthBar, (Alpha != null ? Alpha : FlxG.save.data.healthHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(laneScore, (Alpha != null ? Alpha : (Option.JsonOptions.laneTransparencyScore != null ? Option.JsonOptions.laneTransparencyScore : FlxG.save.data.laneTransparencyScore)), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(scoreTxt, (Alpha != null ? Alpha : FlxG.save.data.scoreHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(missTxt, (Alpha != null ? Alpha : FlxG.save.data.missesHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(accuracyTxt, (Alpha != null ? Alpha : FlxG.save.data.accuracyHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(ratingTxt, (Alpha != null ? Alpha : FlxG.save.data.ratingTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(comboTxt, (Alpha != null ? Alpha : FlxG.save.data.ComboHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(higherComboTxt, (Alpha != null ? Alpha : FlxG.save.data.maxComboHUDTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(healthTxt, (Alpha != null ? Alpha : FlxG.save.data.hpHUDPercentTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(statsCounterTxt, (Alpha != null ? Alpha : FlxG.save.data.statsCounterTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(timerTrackTxt, (Alpha != null ? Alpha : FlxG.save.data.trackTimeLeftTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(botplayTxt, (Alpha != null ? Alpha : FlxG.save.data.trackTimeLeftTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(iconP1, (Alpha != null ? Alpha : FlxG.save.data.iconTransparency), Duration, {ease: FlxEase.cubeOut});
		Actions.Alpha(iconP2, (Alpha != null ? Alpha : FlxG.save.data.iconTransparency), Duration, {ease: FlxEase.cubeOut});
		if (Main.engineMark){
			switch (FlxG.save.data.engineMarkCustomization){
				case 0: Actions.Alpha(waterMarkEngine, (Alpha != null ? Alpha : FlxG.save.data.engineMarkTransparency), Duration, {ease: FlxEase.cubeOut});
				case 1: Actions.Alpha(waterMarkEngineSongName, (Alpha != null ? Alpha : FlxG.save.data.engineMarkTransparency), Duration, {ease: FlxEase.cubeOut});
				case 2: Actions.Alpha(waterMarkEngineDiff, (Alpha != null ? Alpha : FlxG.save.data.engineMarkTransparency), Duration, {ease: FlxEase.cubeOut});
				case 3: if (!FlxG.save.data.fpsAndMemory) Actions.Alpha(waterMarkEngineInfo, (Alpha != null ? Alpha : FlxG.save.data.engineMarkTransparency), Duration, {ease: FlxEase.cubeOut});
			}
		}
		if (laneCameraProcesed){
			Actions.Alpha(lanePlayerScroll, (Alpha != null ? Alpha : (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll)), Duration, {ease: FlxEase.cubeOut});
			Actions.Alpha(laneOpponentScroll, (Alpha != null ? Alpha : (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll)), Duration, {ease: FlxEase.cubeOut});
		}
	}
	function removeStaticsStrums(nameItem:String){
		switch (nameItem){
			case 'Player':
				playerStrums.forEach(function(todel:FlxSprite){
					playerStrums.remove(todel);
					todel.destroy();
				});
				new FlxTimer().start(0, function(tmr:FlxTimer){
					playerStrums.forEach(function(todel:FlxSprite){
						playerStrums.remove(todel);
						todel.destroy();
					});
				});
			case 'Opponent':
				opponentStrums.forEach(function(todel:FlxSprite){
					opponentStrums.remove(todel);
					todel.destroy();
				});
				new FlxTimer().start(0, function(tmr:FlxTimer){
					opponentStrums.forEach(function(todel:FlxSprite){
						opponentStrums.remove(todel);
						todel.destroy();
					});
				});
			case 'Notes':
				strumLineNotes.forEach(function(todel:FlxSprite){
					strumLineNotes.remove(todel);
					todel.destroy();
				});
		}
	}
	private function keyShit():Void{ // Player Keys
		var holdArray:Array<Bool> = [controls.LEFT, controls.DOWN, controls.UP, controls.RIGHT];
		var pressArray:Array<Bool> = [controls.LEFT_P, controls.DOWN_P, controls.UP_P, controls.RIGHT_P];
		var releaseArray:Array<Bool> = [controls.LEFT_R, controls.DOWN_R, controls.UP_R, controls.RIGHT_R];
		if (Client.Public.botplay || scrollLocked){
			holdArray = [false, false, false, false];
			pressArray = [false, false, false, false];
			releaseArray = [false, false, false, false];
		} 
		if (holdArray.contains(true) && generatedMusic && !endTrack){
			notes.forEachAlive(function(daNote:Note){
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && holdArray[daNote.noteData]) playerNoteHit(daNote);
			});
		}
		if (pressArray.contains(true) && generatedMusic && !endTrack){
			boyfriend.holdTimer = 0;
			var possibleNotes:Array<Note> = []; // notes that can be hit
			var directionList:Array<Int> = []; // directions that can be hit
			var dumbNotes:Array<Note> = []; // notes to kill later
			notes.forEachAlive(function(daNote:Note){
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit){
					if (directionList.contains(daNote.noteData)){
						for (coolNote in possibleNotes){
							if (coolNote.noteData == daNote.noteData && Math.abs(daNote.strumTime - coolNote.strumTime) < 10){
								dumbNotes.push(daNote);
								break;
							}else if (coolNote.noteData == daNote.noteData && daNote.strumTime < coolNote.strumTime){
								possibleNotes.remove(coolNote);
								possibleNotes.push(daNote);
								break;
							}
						}
					}else{
						possibleNotes.push(daNote);
						directionList.push(daNote.noteData);
					}
				}
			});
			for (note in dumbNotes){
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
			possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			var dontCheck = false;
			for (i in 0...pressArray.length)
				if (pressArray[i] && !directionList.contains(i))
					dontCheck = true;
			if (possibleNotes.length > 0 && !dontCheck){
				if (!FlxG.save.data.newInput)
					for (shit in 0...pressArray.length)
						if (pressArray[shit] && !directionList.contains(shit))
							TrackMap.oldInput(shit);
				for (coolNote in possibleNotes){
					if (pressArray[coolNote.noteData]){
						if (mashViolations != 0)
							mashViolations--;
						playerNoteHit(coolNote);
					}
				}
			}else if (!FlxG.save.data.newInput){
				for (shit in 0...pressArray.length)
					if (pressArray[shit])
						TrackMap.oldInput(shit);
			}
			if (dontCheck && possibleNotes.length > 0 && FlxG.save.data.newInput && !Client.Public.botplay){
				if (mashViolations > 8){
					missTxt.color = 0xFF6f0000;
					TrackMap.oldInput(0);
				}else
					mashViolations++;
			}
		}
		playerStrums.forEach(function(spr:FlxSprite){
			StrumNote.GlowHitNote('PlayerIdle', spr, null, (Client.Public.botplay ? null : pressArray), (Client.Public.botplay ? null : holdArray));
		});
		if (FlxG.save.data.opponentGlownHit){
			opponentStrums.forEach(function(spr:FlxSprite){
				StrumNote.GlowHitNote('OpponentIdle', spr);
			});
		}
		notes.forEachAlive(function(daNote:Note){
            if (Client.Public.botplay && Client.Public.downscroll && daNote.y > strumLine.y || Client.Public.botplay && !Client.Public.downscroll && daNote.y < strumLine.y){
                if (daNote.canBeHit && daNote.mustPress || daNote.tooLate && daNote.mustPress){
                    playerNoteHit(daNote);
                    boyfriend.holdTimer = daNote.sustainLength;
                }
            }
        });
		CharacterSettigs.CharacterIdles('PlayStateKey', holdArray, boyfriend);
	}
	function CheckRandomGrab(){ // Beta!
		switch (SONG.song.toLowerCase()){
			case 'senpai':
				if (FlxG.random.bool(1)) playerTurn = true;
				if (FlxG.random.bool(0.5)) playerTurn = false;
			case 'roses':
				if (FlxG.random.bool(8)) playerTurn = true;
				if (FlxG.random.bool(4)) playerTurn = false;
		}
		if (!playerTurn && !isFackingGrabCoondownOpponent){
			isFackingGrabCoondownPlayer = false;
			switch (SONG.song.toLowerCase()){
				case 'senpai': startGrabHealth2('Opponent', 1.5, 50, 5);
				case 'roses': startGrabHealth2('Opponent', 1.4, 35, 4);
			}
		}else if (!isFackingGrabCoondownPlayer){
			isFackingGrabCoondownOpponent = false;
			switch (SONG.song.toLowerCase()){
				case 'senpai': startGrabHealth2('Player', 1.5, 50, 5);
				case 'roses': startGrabHealth2('Player', 1.4, 35, 4);
			}
		}
	}
	function startGrabHealth(player:String , timer:Float = 20, healthFloat:Float = 1.5, takeHealth:Int = 100, duration:Int = 4, ?spriteLock:Bool = false){
		new FlxTimer().start(timer, function(tmr:FlxTimer){
			if (playerTurn){
				if (canPause && !paused && health >= healthFloat && !grabbedPlayerIcon)
					grabHealth(player, takeHealth, duration, spriteLock);
			}else{
				if (canPause && !paused && healthBar.percent > healthFloat && !grabbedOpponentIcon)
					grabHealth(player, takeHealth, duration, spriteLock);
			}
			tmr.reset(timer);
		});
	}
	function startGrabHealth2(player:String, healthFloat:Float = 1.5, takeHealth:Int = 100, duration:Int = 5, ?spriteLock:Bool = false){
		if (playerTurn){
			if (canPause && !paused && health >= healthFloat && !grabbedPlayerIcon)
				grabHealth(player, takeHealth, duration, spriteLock);
		}else{
			if (canPause && !paused && healthBar.percent > healthFloat && !grabbedOpponentIcon)
				grabHealth(player, takeHealth, duration, spriteLock);
		}
	}
	function SpriteGrab(spriteSussy:FlxSprite){ // Sprite Health Grab
		switch (curTrack){
			case 'Senpai' | 'Roses':
				spriteSussy.x = (playerTurn ? iconP1.x : iconP2.x);
				spriteSussy.y = (!Client.Public.downscroll ? healthBarBG.y : -15 + healthBarBG.y);
				spriteSussy.flipX = (playerTurn ? false : true);
				spriteSussy.flipY = (Client.Public.downscroll ? true : false);
				spriteSussy.cameras = [camHUD];
				spriteSussy.frames = Paths.getSparrowAtlas('school/BG_Girls_HandLovePushingv2', 'maps');
				spriteSussy.setGraphicSize(Std.int(spriteSussy.width * 2));
				spriteSussy.animation.addByIndices('come','Appear',[0,1,2,3,4,5,6,7,8,9], "", 24, false);
				spriteSussy.animation.addByIndices('grab','Grab',[0,1,2,3,4,5], "", 24, false);
				spriteSussy.animation.addByIndices('hold','Pushing',[0,1,2,3],"",24);
				spriteSussy.animation.addByIndices('release','Release',[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16],"",24,false);
				spriteSussy.antialiasing = Client.Public.antialiasing;
		}
	}
	function grabHealth(turnGrab:String, healthCaculate:Int, duration:Int, lockedSprite:Bool = false){
		if (playerTurn){
			//isFackingGrabCoondownPlayer = true;
			grabbedPlayerIcon = true;
			interuptgrabbedPlayerIconHealth = false;
		}else{
			isFackingGrabCoondownOpponent = true;
			grabbedOpponentIcon = true;
			interuptgrabbedOpponentHealth = false;
		}
		addsDamageHealthSpriteTake = 0;
		var spriteFackGrab:FlxSprite = new FlxSprite(0,0);
		SpriteGrab(spriteFackGrab);
		add(spriteFackGrab);
		spriteFackGrab.animation.play('come');
		switch (turnGrab){
			case 'Player': GrabPlayerHealth(spriteFackGrab, healthCaculate, duration, lockedSprite);
			case 'Opponent': GrabOpponentHealth(spriteFackGrab, healthCaculate, duration, lockedSprite);
		}
	}
	function GrabPlayerHealth(spriteThis:FlxSprite, healthCaculate:Int, duration:Int, lockedSprite:Bool){
		playerTurn = true;
		var spriteSpeed:Float = 0.014425;
		var offSetStart:Int = 75;
		var currentStartHealthGrab = health;
		var thisFackPush = (healthCaculate / 100) * currentStartHealthGrab;
		var susHP = thisFackPush / 2 * 100;
		var goFackYouSelf:Bool = false;
		new FlxTimer().start(0.14, function(tmr:FlxTimer){
			spriteThis.animation.play('grab');
			Actions.Tween(spriteThis,{x: iconP1.x}, 1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween){
				spriteThis.animation.play('hold');
				Actions.Tween(spriteThis,{
					x: (healthBar.x + 
					(healthBar.width * (FlxMath.remapToRange(susHP, 0, 100, 100, 0) * spriteSpeed) 
					- 26)) - offSetStart}, duration,{
					onUpdate: function(tween:FlxTween){
						if (interuptgrabbedPlayerIconHealth && !goFackYouSelf && !lockedSprite){
							goFackYouSelf = true;
							spriteThis.animation.play('release');
							spriteThis.animation.finishCallback = function(pog:String){
								spriteThis.alpha = 0;
							}
						}else if (!interuptgrabbedPlayerIconHealth || lockedSprite){
							var pp = FlxMath.lerp(currentStartHealthGrab, thisFackPush, tween.percent);
							if (pp <= 0)
								pp = 0.1;
							health = pp;
						}
					},
					onComplete: function(tween:FlxTween){
						if (interuptgrabbedPlayerIconHealth && !lockedSprite){
							remove(spriteThis);
							grabbedPlayerIcon = false;
							isFackingGrabCoondownPlayer = false;
						}else{
							spriteThis.animation.play('release');
							if (lockedSprite && addsDamageHealthSpriteTake >= 0.7)
								health -= addsDamageHealthSpriteTake;
							spriteThis.animation.finishCallback = function(pog:String){
								remove(spriteThis);
							}
							grabbedPlayerIcon = false;
							isFackingGrabCoondownPlayer = false;
						}
					}
				});
			}});
		});
	}
	function GrabOpponentHealth(spriteThis:FlxSprite, healthCaculate:Int, duration:Int, lockedSprite:Bool){
		playerTurn = false;
		var offSetStart:Int = 75;
		var currentStartHealthGrab = health;
		var thisFackPush = (healthCaculate / 100) * currentStartHealthGrab;
		var susHP = thisFackPush / 2 * 100;
		var goFackYouSelf:Bool = false;
		new FlxTimer().start(0.14, function(tmr:FlxTimer){
			spriteThis.animation.play('grab');
			Actions.Tween(spriteThis,{x: iconP2.x + 20}, 1,{ease: FlxEase.elasticIn, onComplete: function(tween:FlxTween){
				spriteThis.animation.play('hold');
				Actions.Tween(spriteThis,{
					x: (healthBar.x + 
					(healthBar.width * (FlxMath.remapToRange(susHP, 0, -0.0001, -0.0001, 0) * 0.01) 
					- 26)) - offSetStart}, duration,{
					onUpdate: function(tween:FlxTween){
						if (interuptgrabbedOpponentHealth && !goFackYouSelf && !lockedSprite){
							goFackYouSelf = true;
							spriteThis.animation.play('release');
							spriteThis.animation.finishCallback = function(pog:String){
								spriteThis.alpha = 0;
							}
						}else if (!interuptgrabbedOpponentHealth || lockedSprite){
							var pp = FlxMath.lerp(currentStartHealthGrab, thisFackPush, -tween.percent);
							if (pp <= 0)
								pp = 0.1;
							health = pp;
						}
					},
					onComplete: function(tween:FlxTween){
						if (interuptgrabbedOpponentHealth && !lockedSprite){
							remove(spriteThis);
							grabbedOpponentIcon = false;
							isFackingGrabCoondownOpponent = false;
						}else{
							spriteThis.animation.play('release');
							if (lockedSprite && addsDamageHealthSpriteTake >= 0.7)
								health += addsDamageHealthSpriteTake;
							spriteThis.animation.finishCallback = function(pog:String){
								remove(spriteThis);
							}
							grabbedOpponentIcon = false;
							isFackingGrabCoondownOpponent = false;
						}
					}
				});
			}});
		});
	}
	function getKeyPresses(note:Note):Int{
		var possibleNotes:Array<Note> = [];
		notes.forEachAlive(function(daNote:Note){
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate){
				possibleNotes.push(daNote);
				possibleNotes.sort((a, b) -> Std.int(a.strumTime - b.strumTime));
			}
		});
		if (possibleNotes.length == 1) return possibleNotes.length + 1;
		return possibleNotes.length;
	}
	function noteCheck(controlArray:Array<Bool>, note:Note):Void{
		note.rating = Rating.noteMs(-(note.strumTime - Conductor.songPosition));
		if (controlArray[note.noteData]) playerNoteHit(note, (mashing > getKeyPresses(note)));
	}
	private  function popUpAcc(note:Note){ // Is Here Just to Fix other Notes Pressing to get Accuracy
		switch (note.rating){
			case 'shit': totalNotesHit -= 1;
			case 'bad': totalNotesHit -= 0.50;
			case 'good': totalNotesHit += 0.75;
			case 'sick': totalNotesHit += 1;
		}
	}
	private function popUpStats(note:Note, isBot:Bool):Void{ // Weel is Stats to Get in Hud and Gameplay
		var ratingName = note.rating;
		if (isBot)
			noteGetHealth(ratingName);
		else{
			var strum = playerStrums.members[note.noteData];
			var ratingSprite:FlxSprite = new FlxSprite();
			var score:Int = 0;
			switch (ratingName){
				case 'shit':
					score = -300;
					ss = false;
					combo = 0;
					shits++;
				case 'bad':
					ratingName = 'bad';
					ss = false;
					score = 0;
					bads++;
				case 'good':
					ratingName = 'good';
					score = 200;
					ss = false;
					goods++;
				case 'sick':
					score = 350;
					sicks++;
			}
			combo++;
			noteGetHealth(ratingName); // Get Health Custom
			ratingSpriteColor(ratingName); // Rating Color of Sprite Rating
			if (ratingName != 'shit' || ratingName != 'bad'){
				chartScore += Math.round(score);
				var diretoryPixShit:String = "UI/";
				var complementName:String = '';
				if (TrackMap.mapComplement == 'pixel'){
					diretoryPixShit = 'UI/pixelUI/';
					complementName = '-pixel';
				}
				ratingSprite.loadGraphic(Paths.image(diretoryPixShit + ratingName + complementName, 'shared'));
				ratingSprite.alpha = FlxG.save.data.ratingSpriteTransparency;
				switch (FlxG.save.data.ratingHUD){
					case 2:
						ratingSprite.cameras = [camNOTE];
						ratingSprite.x = strum.x;
						ratingSprite.y = strum.y + (!Client.Public.downscroll ? -35 : 115);
					case 1:
						ratingSprite.cameras = [camNOTE];
						ratingSprite.x = (Client.Public.mid ? 160 : 510);
						ratingSprite.y = strum.y + (Client.Public.mid ? (Client.Public.downscroll ? 15 : 36) : 15);
					case 0:
						ratingSprite.y -= 60;
						ratingSprite.screenCenter();
				}
				ratingSprite.acceleration.y = 550;
				ratingSprite.velocity.y -= FlxG.random.int(160, 200);
				ratingSprite.velocity.x -= FlxG.random.int(0, 15);
				if (TrackMap.mapComplement != 'pixel'){
					ratingSprite.antialiasing = Client.Public.antialiasing;
					switch (FlxG.save.data.ratingHUD){
						case 2: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * 0.45));
						case 1: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * 0.5));
						case 0: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * 0.625));
					}
				}else{
					ratingSprite.antialiasing = false;
					switch (FlxG.save.data.ratingHUD){
						case 2: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * TrackMap.daPixelZoom * 0.45));
						case 1: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * TrackMap.daPixelZoom * 0.55));
						case 0: ratingSprite.setGraphicSize(Std.int(ratingSprite.width * TrackMap.daPixelZoom * 0.65));
					}
				}
				ratingSprite.updateHitbox();
				if (FlxG.save.data.ratingHUD < 3)
					add(ratingSprite);
				Actions.Tween(ratingSprite, {alpha: 0}, 0.2,{
					onComplete: function(tween:FlxTween){ ratingSprite.destroy(); },
					startDelay: Conductor.crochet * 0.001
				});
			}
		}
	}
	function getTypeSprite(nameType:String){
		switch (nameType){
			case "Miss":
				var missSprite:FlxSprite = new FlxSprite();
				var diretoryPixMiss:String = "UI/miss";
				var complementName:String = '';
				if (TrackMap.mapComplement == 'pixel'){
					diretoryPixMiss = 'UI/pixelUI/miss';
					complementName = '-pixel';
				}
				missSprite.loadGraphic(Paths.image(diretoryPixMiss + complementName, 'shared'));
				switch (FlxG.save.data.ratingHUD){
					case 2 | 1:
						missSprite.cameras = [camHUD];
						missSprite.x = 910;
						missSprite.y = (Client.Public.downscroll ? 50 : 600);
						missSprite.angle = 15;
					case 0:
						missSprite.x = boyfriend.x;
						missSprite.y = boyfriend.y;
				}
				missSprite.acceleration.y = 550;
				missSprite.velocity.y -= FlxG.random.int(125, 325);
				missSprite.velocity.x -= FlxG.random.int(0, 50);
				missSprite.setGraphicSize(Std.int(missSprite.width * (TrackMap.mapComplement != 'pixel' ? 0.6 : TrackMap.daPixelZoom * 0.6)));
				missSprite.updateHitbox();
				if (FlxG.save.data.ratingHUD < 3)
					add(missSprite);
				Actions.Tween(missSprite, {alpha: 0}, 0.2,{
					onComplete: function(tween:FlxTween){ missSprite.destroy(); },
					startDelay: Conductor.crochet * 0.001
				});
			case "Pass":
				var passSprite:FlxSprite = new FlxSprite();
				var diretoryPixPass:String = "UI/pass";
				var complementName:String = '';
				if (TrackMap.mapComplement == 'pixel'){
					diretoryPixPass = 'UI/pixelUI/pass';
					complementName = '-pixel';
				}
				passSprite.loadGraphic(Paths.image(diretoryPixPass + complementName, 'shared'));
				switch (FlxG.save.data.ratingHUD){
					case 2 | 1:
						passSprite.cameras = [camHUD];
						passSprite.x = 190;
						passSprite.y = (Client.Public.downscroll ? 50 : 600);
						passSprite.angle = -15;
					case 0:
						passSprite.x = gf.x + 55;
						passSprite.y = gf.y + 275;
				}
				passSprite.acceleration.y = 550;
				passSprite.velocity.y -= FlxG.random.int(150, 250);
				passSprite.velocity.x -= FlxG.random.int(0, 25);
				passSprite.setGraphicSize(Std.int(passSprite.width * (TrackMap.mapComplement != 'pixel' ? 0.625 : TrackMap.daPixelZoom * 0.6)));
				passSprite.updateHitbox();
				if (FlxG.save.data.ratingHUD < 3)
					add(passSprite);
				Actions.Tween(passSprite, {alpha: 0}, 0.2,{
					onComplete: function(tween:FlxTween){ passSprite.destroy(); },
					startDelay: Conductor.crochet * 0.001
				});
		}
	}
	function showSongMark(?durationIn:Float = 1, ?durationOut:Float = 1){
		var boxSpr:NewSprite = new NewSprite(-600, (Client.Public.downscroll ? 590 : 0), 'songBar', 'shared', true, FlxG.save.data.songArtistMarkTransparency, 0, 0);
		NewSprite.SpriteComplement.setVariables(boxSpr, true, 0.5);
		boxSpr.cameras = [camHUD];
		var trackInfo:Text = new Text('Track Now Playing:', -300, ((Client.Public.downscroll ? 692 : 0)), 25, 0, FlxG.save.data.songArtistMarkTransparency);
		trackInfo.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 27, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		trackInfo.cameras = [camHUD];
		var trackName:Text = new Text(SONG.song.toLowerCase() + '-' + mainDifficultyText + (Client.Public.endless && loops >= 1 ? ' (Loop: $loops)' : ''), -300, ((Client.Public.downscroll ? 655 : 35)), 20, 0, FlxG.save.data.songArtistMarkTransparency);
		trackName.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 20, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		trackName.cameras = [camHUD];
		var artistName:Text = new Text('By: ' + (SONG.artist == null ? '?' : SONG.artist), -300, ((Client.Public.downscroll ? 610 : 75)), 22, 0, FlxG.save.data.songArtistMarkTransparency);
		artistName.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 24, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		artistName.cameras = [camHUD];
		if (FlxG.save.data.songArtistMarkTransparency != 0){
			add(boxSpr);
			add(trackInfo);
			add(trackName);
			add(artistName);
			new FlxTimer().start(0.25, function(tmr:FlxTimer){
				Actions.Tween(boxSpr, {x: -100}, durationIn, {type:PERSIST, ease: FlxEase.backInOut});
				Actions.Tween(trackInfo, {x: -1}, durationIn, {type:PERSIST, ease: FlxEase.backInOut});
				Actions.Tween(trackName, {x: -1}, durationIn, {type:PERSIST, ease: FlxEase.backInOut});
				Actions.Tween(artistName, {x: -1}, durationIn, {type:PERSIST, ease: FlxEase.backInOut});
				new FlxTimer().start(5, function(tmr:FlxTimer){
					Actions.Tween(boxSpr, {x: -600}, durationOut, {type:PERSIST, ease: FlxEase.backInOut});
					Actions.Tween(trackInfo, {x: -500}, durationOut, {type:PERSIST, ease: FlxEase.backInOut});
					Actions.Tween(trackName, {x: -500}, durationOut, {type:PERSIST, ease: FlxEase.backInOut});
					Actions.Tween(artistName, {x: -500}, durationOut, {type:PERSIST, ease: FlxEase.backInOut});
					new FlxTimer().start(3, function(tmr:FlxTimer){
						boxSpr.destroy();
						trackInfo.destroy(); 
						trackName.destroy();
						artistName.destroy();
					});
				});
			});
		}
	}
}