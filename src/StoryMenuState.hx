package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using StringTools;
typedef StoryOptions ={
	var WeekChracterMenu:Array<Dynamic>; // Week Characters
	var WeekUnlocked:Array<Bool>; // Weeks and Freeplay Tracks Unlocked
	var WeekNames:Array<String>; // Week Names in Story
	var WeekSong:Array<Dynamic>; // Week Data Tracks
}
class StoryMenuState extends MusicBeatState{
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;
	public static var instance:StoryMenuState;
	public static var StoryData:StoryOptions;
	var grpWeekText:FlxTypedGroup<MenuItem>;
	public static var curDickStory:Int = 0;
	var grpLocks:FlxTypedGroup<FlxSprite>;
	public static var storyWeek:Int = 0;
	public var curDiffcultyWeek:Int = 1;
	var difficultySelectors:FlxGroup;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;
	var optionsSubIcon:NewSprite;
	var sprDifficulty:FlxSprite;
	var movedBack:Bool = false;
	var intendedScore:Int = 0;
	var txtWeekTitle:FlxText;
	var txtTracklist:FlxText;
	var rightArrow:FlxSprite;
	var leftArrow:FlxSprite;
	var scoreText:FlxText;
	var lerpScore:Int = 0;
	public static function loadStoryCutscene(){
		switch (curDickStory){
			default: new FlxTimer().start(1.05, function(tmr:FlxTimer){
					Actions.States('LoadSwitch', new PlayState(), true);
				});
			case 7: new FlxTimer().start(1.325, function(tmr:FlxTimer){
					Actions.PlayVidCene(true, false, 'Week7Cutcene/ughCutscene', null, true);
				});
		}
	}
	override function create(){
		instance = this;
		Main.dumpCache();
		Paths.clearTraceSounds();
		Client.loadJson();
		FlxG.mouse.visible = true;
		PlayState.IsPlayState = false;
		OptionsMenu.isFreeplay = false;
		OptionsMenu.isMainMenu = false;
		OptionsMenu.isStoryMenu = false;
		OptionsMenu.disableMerges = false;
		PlayState.stateShit = 'StoryMenu';
		ConsoleCodeState.secretSongName = '';
		CharacterSelect.getSongName = '';
		curDickStory = 0;
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		if (!FlxG.sound.music.playing && FlxG.sound.music != null) Actions.PlayTrack(MainMenuState.EngineFreakyMenu);
		persistentUpdate = persistentDraw = true;
		scoreText = new FlxText(-2, 10, 0, "", 36);
		scoreText.setFormat("Highman.ttf", 35);
		txtWeekTitle = new FlxText(FlxG.width * 0.8, 10, 0, "", 30);
		txtWeekTitle.setFormat("Highman.ttf", 30, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.725;
		var ui_tex = Paths.getSparrowAtlas('StoryShit/UI_Storymenu_Assets');
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, StateImage.StoryBGColor);
		/*#if desktop
		DiscordClient.changePresence("In StoryMode Menu", '\nSelected Week: ' + 0); // Updating Discord Rich Presence
		#end*/
		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);
		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);
		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();
		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);
		for (i in 0...StoryData.WeekSong.length){ // Week Data Shit :D
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, i);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);
			weekThing.screenCenter(X);
			weekThing.antialiasing = Client.Public.antialiasing;
			if (!StoryData.WeekUnlocked[i]){
				var lock:FlxSprite = new FlxSprite(weekThing.width + 10 + weekThing.x);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('locked', 'PADLOCK');
				lock.animation.play('locked');
				lock.ID = i;
				lock.antialiasing = Client.Public.antialiasing;
				grpLocks.add(lock);
			}
		}
		grpWeekCharacters.add(new MenuCharacter(0, 100, 0.5, false));
		grpWeekCharacters.add(new MenuCharacter(450, 25, 0.9, true));
		grpWeekCharacters.add(new MenuCharacter(850, 100, 0.5, true));
		difficultySelectors = new FlxGroup();
		add(difficultySelectors);
		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10); // Left Arrow Difficulty Switch
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow Left Idle");
		leftArrow.animation.addByPrefix('press', "arrow Left Pressed");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);
		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y); // Difficulty Sprites
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('Easy', 'EASY');
		sprDifficulty.animation.addByPrefix('Normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('Hard', 'HARD');
		sprDifficulty.animation.addByPrefix('Very-hard', 'VERY HARD');
		sprDifficulty.animation.play('Normal');
		changeDifficulty();
		difficultySelectors.add(sprDifficulty);
		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width + 50, leftArrow.y); // Right Arrow Difficulty Switch
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow Right Idle');
		rightArrow.animation.addByPrefix('press', "arrow Right Pressed", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		add(yellowBG);
		add(grpWeekCharacters);
		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks:", 32); // TrackList Song Names
		txtTracklist.alignment = CENTER;
		txtTracklist.setFormat(Paths.font("Highman.ttf"), 32);
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		add(scoreText);
		add(txtWeekTitle);
		updateText();
		optionsSubIcon = new NewSprite(590, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['SubOptions_Idle', 'SubOptions_MouseOver']);
		NewSprite.SpriteComplement.setVariables(optionsSubIcon, true, null, null, 0.25, 0.25);
		add(optionsSubIcon);
		super.create();
	}
	override function update(elapsed:Float){
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));
		scoreText.text = "Week Score: " + lerpScore;
		txtWeekTitle.text = StoryData.WeekNames[curDickStory].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);
		difficultySelectors.visible = StoryData.WeekUnlocked[curDickStory];
		grpLocks.forEach(function(lock:FlxSprite){
			lock.y = grpWeekText.members[lock.ID].y;
		});
		if (!movedBack && !OptionsMenu.isStoryMenu){
			if (!selectedWeek && !OptionsMenu.isStoryMenu){
				if (controls.UP_P && !OptionsMenu.isStoryMenu) changeWeek(-1);
				if (controls.DOWN_P && !OptionsMenu.isStoryMenu) changeWeek(1);
				if (controls.RIGHT && !OptionsMenu.isStoryMenu)
					Actions.PlaySprAnim(rightArrow, 'press');
				else
					Actions.PlaySprAnim(rightArrow, 'idle');
				if (controls.LEFT && !OptionsMenu.isStoryMenu)
					Actions.PlaySprAnim(leftArrow, 'press');
				else
					Actions.PlaySprAnim(leftArrow, 'idle');
				if (controls.RIGHT_P && !OptionsMenu.isStoryMenu) changeDifficulty(1);
				if (controls.LEFT_P && !OptionsMenu.isStoryMenu) changeDifficulty(-1);
			}
			if (controls.ACCEPT && !OptionsMenu.isStoryMenu) selectWeek();
		}
		if (controls.BACK && !movedBack && !selectedWeek && !OptionsMenu.isStoryMenu){
			Actions.PlaySound('cancelMenu');
			movedBack = true;
			OptionsMenu.isStoryMenu = false;
			Actions.States('Switch', new MainMenuState());
		}
		/*if (FlxG.keys.justPressed.R && !OptionsMenu.isStoryMenu){ // KEY TO RESET StoryMode Score
			var counterGain = 0;
			new FlxTimer().start(0.15, function(timerDick:FlxTimer){ // 0.15 Sec
				counterGain += 1;
				if (counterGain == 30) Actions.States('Reset');
				if (FlxG.keys.pressed.R) timerDick.reset();
			});
		}*/
		if (FlxG.mouse.overlaps(optionsSubIcon)){
			Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_MouseOver');
			if (!OptionsMenu.isStoryMenu &&FlxG.mouse.justPressed){
				OptionsMenu.isStoryMenu = true;
				openSubState(new OptionsMenu(true));
			}
		}else
			if (!OptionsMenu.isStoryMenu) Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_Idle');
		super.update(elapsed);
	}
	function selectWeek(){
		if (StoryData.WeekUnlocked[curDickStory]){
			if (!stopspamming){
				Actions.PlaySound('confirmMenu');
				if (FlxG.save.data.flashingLightVisual) grpWeekText.members[curDickStory].startFlashing();
				grpWeekCharacters.members[1].animation.play('bfConfirm');
				stopspamming = true;
			}
			PlayState.storyPlaylist = StoryData.WeekSong[curDickStory];
			selectedWeek = true;
			PlayState.stateShit = 'StoryMode';
			PlayState.mainDifficulty = curDiffcultyWeek;
			trace("Selected Week: " + curDickStory + " \nTrack: " + PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(curDiffcultyWeek));
			PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0].toLowerCase() + CoolUtil.checkDifficultyData(curDiffcultyWeek), PlayState.storyPlaylist[0].toLowerCase());
			storyWeek = curDickStory;
			PlayState.campaignScore = 0;
			if (FlxG.save.data.charSelect < 2){
				switch (FlxG.save.data.charSelect){
					case 0: loadStoryCutscene();
					case 1: Actions.States('Switch', new CharacterSelect());
				}
			}else
				loadStoryCutscene();
		}
	}
	function cum(pussy:Dynamic){
		if (curDiffcultyWeek < 0) curDiffcultyWeek = pussy;
		if (curDiffcultyWeek > pussy) curDiffcultyWeek = 0;
	}
	function changeDifficulty(change:Int = 0):Void{
		curDiffcultyWeek += change;
		switch (FlxG.save.data.mode){ // HybridMode
			case 3: cum(CoolUtil.PushDiff.DifficultyNames.length);
			case 2: cum(7); // HellMode
			case 1: cum(5); // HardMode
			default: cum(3); // NormalMode
		}
		setDifficultySprite(curDiffcultyWeek);
		#if !switch
		intendedScore = Highscore.getWeekScore(curDickStory, curDiffcultyWeek);
		#end
	}
	function changeWeek(change:Int = 0):Void{
		curDickStory += change;
		if (curDickStory >= StoryData.WeekSong.length) curDickStory = 0;
		if (curDickStory < 0) curDickStory = StoryData.WeekSong.length - 1;
		DiscordClient.globalPresence('StoryMenuState');
		var bullShit:Int = 0;
		for (item in grpWeekText.members){
			item.targetY = bullShit - curDickStory;
			item.alpha = (item.targetY == Std.int(0) && StoryData.WeekUnlocked[curDickStory] ? 1 : 0.2);
			bullShit++;
		}
		Actions.PlaySound('scrollMenu');
		updateText();
	}
	function updateText(){
		grpWeekCharacters.members[0].setCharacter(StoryData.WeekChracterMenu[curDickStory][0]);
		grpWeekCharacters.members[1].setCharacter(StoryData.WeekChracterMenu[curDickStory][1]);
		grpWeekCharacters.members[2].setCharacter(StoryData.WeekChracterMenu[curDickStory][2]);
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = StoryData.WeekSong[curDickStory];
		for (i in stringThing) txtTracklist.text += "\n" + i;
		txtTracklist.text = txtTracklist.text.toUpperCase();
		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;
		txtTracklist.text += "\n";
		#if !switch
		intendedScore = Highscore.getWeekScore(curDickStory, curDiffcultyWeek);
		#end
	}
	function setDiffSettings(?PlayAnim:String = null, ?Xpos:Null<Float> = null, ?Ypos:Null<Float> = null){
		if (PlayAnim != null || PlayAnim != '') sprDifficulty.animation.play(PlayAnim);
		sprDifficulty.offset.x = Xpos;
		sprDifficulty.offset.y = Ypos;
	}
	function setDifficultySprite(curDiffcultyWeek:Int){
		setDiffSettings(null, 0); // test
		switch (curDiffcultyWeek){
			case 0: setDiffSettings('Easy', 20);
			case 1: setDiffSettings('Normal', 70);
			case 2: setDiffSettings('Hard', 20);
			case 3: setDiffSettings('Very-hard', 20);
		}
		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;
		Actions.Tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}
}