package;
import lime.utils.Assets;
import haxe.Json;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
using StringTools;
class FreeplayState extends MusicBeatState{
	public static var instance:FreeplayState = null;
	public static var FreeplayData:FreeplayOption;
	private var iconArray:Array<HealthIcon> = [];
	private var grpSongs:FlxTypedGroup<Alphabet>;
	public var songs:Array<SongMetadata> = [];
	private var curPlaying:Bool = false;
	public var colorTween:FlxTween;
	public var curSelected:Int = 0;
	var optionsSubIcon:NewSprite;
	public var songText:Alphabet;
	var statsTextScale:Int = 27;
	var ALPHABGS:Float = 0.625; // default 0.75
	var curDifficulty:Int = 1;
	var accuracyText:FlxText;
	var comboMaxText:FlxText;
	public var curColor:Int;
	var cuming:Bool = false;
	var missesText:FlxText;
	var scoreText:FlxText;
	var ratingTxt:FlxText;
	var diffText:FlxText;
	var intendedAccuracy:Float = 0.00;
	var lerpAccuracy:Float = 0.00;
	var intendedScore:Int = 0;
	var intendedMAXCB:Int = 0;
	var rating:String = 'N/A'; // RATING NAME
	var ratingFC:String = '?'; // FC RATING NAME
	var intendedMisses:Int;
	var lerpScore:Int = 0;
	var lerpMAXCB:Int = 0;
	var lerpMisses:Int;
	var lerpEndlessScore:Int = 0;
	var intendedEndlessScore:Int = 0;
	function trackFile(i:Array<String>){
		addTrack(i[0], Std.parseInt(i[2]), i[1]);
	}
	function trackJson(i:Lists, isPack:Bool){
		(!isPack ? addTrack(i.songName, i.weekNum, i.icon) : addWeekTrack(i.packSongs, i.weekNum, i.icons));	
	}
	override function create(){
		Main.dumpCache();
		Paths.clearTraceSounds();
		instance = this;
		cuming = false;
		FlxG.mouse.visible = true;
		PlayState.IsPlayState = false;
		OptionsMenu.isFreeplay = false;
		OptionsMenu.isMainMenu = false;
		OptionsMenu.isStoryMenu = false;
		OptionsMenu.disableMerges = false;
		PlayState.stateShit = 'FreeplayMenu';
		ConsoleCodeState.secretSongName = '';
		CharacterSelect.getSongName = '';
		freeplayTrackLists(FreeplayData.OnlyFreeplayTrackListText);
		StateImage.BGSMenus('FreeplayBG', add);
		if (FlxG.sound.music != null && !FlxG.sound.music.playing) Actions.PlayTrack(MainMenuState.EngineFreakyMenu);
		optionsSubIcon = new NewSprite(1215, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['SubOptions_Idle', 'SubOptions_MouseOver']);
		NewSprite.SpriteComplement.setVariables(optionsSubIcon, true, null, null, 0.25, 0.25);
		add(optionsSubIcon);
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);
		for (i in 0...songs.length){
			songText = new Alphabet(0, (90 * i) + 40, songs[i].songName, true, false);
			songText.isFreeplayItem = true;
			songText.targetY = i;
			grpSongs.add(songText);
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		// Score Text
		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("Highman.ttf"), 30, FlxColor.WHITE, RIGHT);
		scoreText.x -= 425;

		// Rating Text Text
		ratingTxt = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		ratingTxt.setFormat(Paths.font("Highman.ttf"), statsTextScale, FlxColor.WHITE, RIGHT);
		ratingTxt.x -= 900;
		ratingTxt.visible = (!FreeplayData.MergeOption ? true : (FlxG.save.data.rating == 2 ? false : true));

		// Accuracy Text
		accuracyText = new FlxText(FlxG.width * 0.7, 40, 0, "", 32);
		accuracyText.setFormat(Paths.font("Highman.ttf"), statsTextScale, FlxColor.WHITE, RIGHT);
		accuracyText.x -= 900;
		accuracyText.visible = (!FreeplayData.MergeOption ? true : FlxG.save.data.accuracyHUD);

		// ComboMax Text
		comboMaxText = new FlxText(FlxG.width * 0.7, 85, 0, "", 32);
		comboMaxText.setFormat(Paths.font("Highman.ttf"), statsTextScale, FlxColor.WHITE, RIGHT);
		comboMaxText.x -= 900;
		comboMaxText.visible = (!FreeplayData.MergeOption ? true : FlxG.save.data.maxComboHUD);

		// Miss Text
		missesText = new FlxText(FlxG.width * 0.7, 130, 0, "", 32);
		missesText.setFormat(Paths.font("Highman.ttf"), statsTextScale, FlxColor.WHITE, RIGHT);
		missesText.x -= 900;
		missesText.visible = (!FreeplayData.MergeOption ? true : FlxG.save.data.missesHUD);

		// BG Score
		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = ALPHABGS;
		add(scoreBG);

		// BG Stats of Track
		var statsBG:FlxSprite = new FlxSprite(accuracyText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.3325), 750, 0xFF000000);
		statsBG.alpha = ALPHABGS;
		if (!Client.Public.endless) add(statsBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);
		add(scoreText);
		if (!Client.Public.endless){
			add(missesText);
			add(accuracyText);
			add(comboMaxText);
			add(ratingTxt);
		}
		changeTrack();
		changeDiff();
		super.create();
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (FlxG.sound.music.volume < 0.7) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		if (controls.UP_P && !OptionsMenu.isFreeplay) changeTrack(-1);
		if (controls.DOWN_P && !OptionsMenu.isFreeplay) changeTrack(1);
		if (controls.LEFT_P && !OptionsMenu.isFreeplay) changeDiff(-1);
		if (controls.RIGHT_P && !OptionsMenu.isFreeplay) changeDiff(1);
		if ((FlxG.keys.anyJustPressed([FlxKey.fromString(FlxG.save.data.chartingBind)])) && FlxG.save.data.moddingTools && !OptionsMenu.isFreeplay) cuming = !cuming;		
		if (controls.BACK && !OptionsMenu.isFreeplay){
			if (colorTween != null) colorTween.cancel();
			Actions.States('Switch', new MainMenuState());
			Actions.PlaySound('cancelMenu');
		}
		if (FlxG.keys.justPressed.R && !OptionsMenu.isFreeplay){
			var HoldingButtom = 0;
			new FlxTimer().start(0.15, function(timer:FlxTimer){ // 0.15 Sec
				HoldingButtom += 1;
				if (HoldingButtom == 30){ // 15sec
					Options.ResetTypeOption.resetType("Highscore");
					Actions.States('Reset');
				}
				if (FlxG.keys.pressed.R) timer.reset(); // Hold R on KeyBoard
			});
		}
		if (controls.ACCEPT && !OptionsMenu.isFreeplay) loadTrackOrCharting(cuming);
		if (FlxG.mouse.overlaps(optionsSubIcon)){
			Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_MouseOver');
			if (!OptionsMenu.isFreeplay && FlxG.mouse.justPressed){
				OptionsMenu.isFreeplay = true;
				openSubState(new OptionsMenu(true));
			}
		}else
			if (!OptionsMenu.isFreeplay) Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_Idle');

		// Score Shit
		if (Client.Public.endless)
			lerpEndlessScore = Math.floor(FlxMath.lerp(lerpEndlessScore, intendedEndlessScore, 0.4));
		else
			lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));
		if (Math.abs((!Client.Public.endless ? lerpScore - intendedScore : lerpEndlessScore - intendedEndlessScore)) <= 10) (!Client.Public.endless ? lerpScore = intendedScore : lerpEndlessScore = intendedEndlessScore);
		scoreText.text = (!Client.Public.endless ? "Best Score: " + lerpScore : "Best Endless Score: " + lerpEndlessScore);

		// Accuracy Shit
		lerpAccuracy = CoolUtil.floatDecimals(lerpAccuracy, 2);
		if (Math.abs(lerpAccuracy - intendedAccuracy) <= 0.01) lerpAccuracy = intendedAccuracy;
		accuracyText.text = "Best Accuracy: " + lerpAccuracy + "%";

		// Misses Shit
		lerpMisses = Math.floor(FlxMath.lerp(lerpMisses, intendedMisses, 0.4));
		if (Math.abs(lerpMisses - intendedMisses) <= 1) lerpMisses = intendedMisses;
		missesText.text = "Less Misses: " + lerpMisses;

		// Rating Shit
		ratingTxt.text = "Best Rating: " + (FlxG.save.data.rating == 0 ? rating : rating + " - " + "(" + ratingFC + ")") + '\n';

		// Higher Combo
		lerpMAXCB = Math.floor(FlxMath.lerp(lerpMAXCB, intendedMAXCB, 0.4));
		if (Math.abs(lerpMAXCB - intendedMAXCB) <= 1) lerpMAXCB = intendedMAXCB;
		comboMaxText.text = "Best Combo: " + lerpMAXCB;
	}
	function freeplayTrackLists(UseOnlyTextFile:Bool){
		var file:FreeplayType = cast Json.parse(Assets.getText(Paths.getPath('data/FreeplayTrackList.json', TEXT)));
		var text = CoolUtil.coolTextFile(Paths.txt('FreeplayTrackList'));
		if (UseOnlyTextFile){
			for (list in 0...text.length){
				var i:Array<String> = text[list].split(':');
				addTrack(i[0],	Std.parseInt(i[2]), i[1]);
			}
			for (i in file.freeplayList)
				trackJson(i, (i.packSongs != null ? true : false));
		}else{
			addTrack('Tutorial', 0, 'gf'); // WEEK 0
			addWeekTrack(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad']); // Week 1
			addWeekTrack(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster']); // Week 2
			addWeekTrack(['Pico', 'Philly', 'Blammed'], 3, ['pico']); // Week 3
			addWeekTrack(['Satin-Panties', 'High', 'Milf'], 4, ['mom']); // Week 4
			addWeekTrack(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents', 'parents', 'monster-christmas']); // Week 5
			addWeekTrack(['Senpai', 'Roses', 'Thorns'], 6, ['senpai-pixel', 'senpai-angry-pixel', 'spirit-pixel']); // Week 6
			addWeekTrack(['Ugh', 'Guns', 'Stress'], 7, ['tankmanCaptain']); // Week 7
			if (FreeplayData.UseCustomTracks){
				for (list in 0...text.length){
					var i:Array<String> = text[list].split(':');
					trackFile(i);
				}
				for (i in file.freeplayList)
					trackJson(i, (i.packSongs != null ? true : false));
			}
		}
	}
	public function loadTrackDatas(songName:String, difficulty:Int, isGoingCharting:Bool, skipDick:Bool = false){
		PlayState.SONG = Song.loadFromJson(Highscore.formatTrack(songName, difficulty), songName);
		PlayState.mainDifficulty = difficulty;
		if (colorTween != null) colorTween.cancel();
		StoryMenuState.storyWeek = songs[curSelected].week;
		if (isGoingCharting && !Client.Public.endless){
			PlayState.stateShit = 'Freeplay';
			if (FlxG.save.data.charSelect == 1) CharacterSelect.charSelected = PlayState.SONG.player1;
			Actions.States('LoadSwitch', new ChartingState(), skipDick);
		}else{
			PlayState.stateShit = 'Freeplay';
			if (FlxG.save.data.charSelect < 2){
				switch (FlxG.save.data.charSelect){
					case 0: Actions.States('LoadSwitch', new PlayState());
					case 1: Actions.States('Switch', new CharacterSelect());
				}
			}else
				Actions.States('LoadSwitch', new PlayState());
		}
		trace('Current Song Week: ' + "[" + StoryMenuState.storyWeek + "] " + " \nCurrent Difficulty: " + curDifficulty);
	}
	function changeTrack(change:Int = 0){
		curSelected += change;
		if (curSelected < 0) curSelected = songs.length - 1;
		if (curSelected >= songs.length) curSelected = 0;
		StateImage.BGSMenus('FreeplaySwitchBGColor');
		DiscordClient.globalPresence('FreeplayState');
		#if !switch
		if (!Client.Public.endless)
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		else
			lerpEndlessScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		rating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		ratingFC = Highscore.getFCRating(songs[curSelected].songName, curDifficulty);
		intendedMAXCB = Highscore.getComboMax(songs[curSelected].songName, curDifficulty);
		lerpAccuracy = Highscore.getAccuracy(songs[curSelected].songName, curDifficulty);
		#end
		var bullShit:Int = 0;
		for (i in 0...iconArray.length) iconArray[i].alpha = 0.2;
		iconArray[curSelected].alpha = 1;
		for (item in grpSongs.members){
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.2;
			if (item.targetY == 0) item.alpha = 1;
		}
		Actions.PlaySound('scrollMenu');
	}
	function changeDiff(change:Int = 0){
		curDifficulty += change;
		switch (FlxG.save.data.mode){
			case 0: pussy(3); // NormalMode
			case 1: pussy(5); // HardMode
			case 2: pussy(7); // HellMode
			case 3: pussy(CoolUtil.PushDiff.DifficultyNames.length); // HybridMode
		}
		#if !switch
		if (!Client.Public.endless)
			intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		else
			intendedEndlessScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedMisses = Highscore.getMisses(songs[curSelected].songName, curDifficulty);
		rating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		ratingFC = Highscore.getFCRating(songs[curSelected].songName, curDifficulty);
		intendedMAXCB = Highscore.getComboMax(songs[curSelected].songName, curDifficulty);
		lerpAccuracy = Highscore.getAccuracy(songs[curSelected].songName, curDifficulty);
		#end
		diffText.text = CoolUtil.difficultyFromInt(curDifficulty).toUpperCase();
	}
	public function addWeekTrack(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>){
		if (songCharacters == null) songCharacters = ['carlinhos'];
		var num:Int = 0;
		for (song in songs){
			if (StoryMenuState.StoryData.WeekUnlocked[weekNum]) addTrack(song, weekNum, songCharacters[num]);
			if (songCharacters.length != 1) num++;
		}
	}
	function pussy(creampie:Dynamic){
		if (curDifficulty < 0) curDifficulty = creampie;
		if (curDifficulty > creampie) curDifficulty = 0;
	}
	public function loadTrackOrCharting(goToChartingState:Bool = false){
		loadTrackDatas(songs[curSelected].songName, curDifficulty, goToChartingState);
	}
	public function addTrack(songName:String, weekNum:Int, songCharacter:String){
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}
}
class SongMetadata{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public function new(song:String, week:Int, songCharacter:String){
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
typedef FreeplayType ={
	var freeplayList:Array<Lists>;
}
typedef Lists ={
	var ?packSongs:Array<String>;
	var ?songName:String;
	var ?weekNum:Int;
	var ?icon:String;
	var ?icons:Array<String>;
}
typedef FreeplayOption ={
	var MergeOption:Bool;
	var UseCustomTracks:Bool;
	var OnlyFreeplayTrackListText:Bool;
}