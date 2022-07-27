package;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
class PauseSubState extends MusicBeatSubstate{
	public static var goToOptions:Bool = false;
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	public static var goBack:Bool = false;
	//public static var pauseMusic:FlxSound;
	var menuItems:Array<String> = [];
	var menuPage:String = "Default";
	var curSelected:Int = 0;
	function checkMenuShit(){
		var daSelected:String = menuItems[curSelected];
		switch (menuPage){
			case "Default":
				switch (daSelected){
					case "Resume":
						close();
					case "Options":
						goToOptions = true;
						close();
					case "Difficulty":
						menuPage = "Difficulty";
						changeDickItems();
					case "Restart Track":
						PlayState.loops = 0;
						Actions.States('Reset');
					case "Exit to Menus":
						PlayState.loops = 0;
						PlayState.death = 0;
						ConsoleCodeState.secretSongName = '';
						CharacterSelect.getSongName = '';
						switch (PlayState.stateShit){
							case 'StoryMode': Actions.States('Switch', new StoryMenuState());
							case 'Freeplay': Actions.States('Switch', new FreeplayState());
							case 'Secret': Actions.States('Switch', new ConsoleCodeState());
						}
				}
			case 'Difficulty':
				PlayState.SONG = Song.loadFromJson(Highscore.formatTrack(PlayState.SONG.song, curSelected), PlayState.SONG.song.toLowerCase());
				trace("Changed Difficulty: " + Highscore.formatTrack(PlayState.SONG.song, curSelected));
				PlayState.mainDifficulty = curSelected;
				Actions.States('Reset');
				PlayState.death = 0;
				PlayState.loops = 0;
		}
	}
	function changeDickItems(){
		switch (menuPage){
			case "Default":
				menuItems = ['Resume', 'Options', 'Difficulty', 'Restart Track', 'Exit to Menus'];
			case "Difficulty":
				switch (FlxG.save.data.mode){
					default: menuItems = ['Easy', 'Normal', 'Hard', 'Very-Hard']; // NormalMode
					case 1: menuItems = ['Easy', 'Normal', 'Hard', 'Very-Hard', 'Extra-Hard', 'Fucked', 'Crazy', 'Insane']; // HardMode
					case 2: menuItems = ['Easy', 'Normal', 'Hard', 'Very-Hard', 'Extra-Hard', 'Fucked', 'Crazy', 'Insane', 'Judgment', 'Hell']; // HellMode
					case 3: menuItems = CoolUtil.PushDiff.DifficultyNames; // HybridMode
				}
		}
		grpMenuShit.clear();
		curSelected = 0;
		changeSelection();
		for (i in 0...menuItems.length){
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}
	}
	public function new(){
		super();
		menuItems = ['Resume', 'Options', 'Difficulty', 'Restart Track', 'Exit to Menus'];
		/*pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));
		FlxG.sound.list.add(pauseMusic);*/

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("Highman.ttf"), 36, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyFromInt(PlayState.mainDifficulty).toUpperCase();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font("Highman.ttf"), 30, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		levelDifficulty.updateHitbox();
		add(levelDifficulty);

		var deathCounter:FlxText = new FlxText(20, 72, 0, "", 32);
		deathCounter.text += "Deaths: " + PlayState.death;
		deathCounter.scrollFactor.set();
		deathCounter.setFormat(Paths.font("Highman.ttf"), 25, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		deathCounter.updateHitbox();
		add(deathCounter);

		var suckLoops:FlxText = new FlxText(20, 47, 0, "", 32);
		suckLoops.text += "Loop: " + PlayState.loops;
		suckLoops.scrollFactor.set();
		suckLoops.setFormat(Paths.font("Highman.ttf"), 36, 0xFFFFFFFF, CENTER, FlxTextBorderStyle.OUTLINE, 0xFF000000);
		suckLoops.updateHitbox();
		if (Client.Public.endless && PlayState.loops >= 1) add(suckLoops);

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;
		deathCounter.alpha = 0;
		suckLoops.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);
		deathCounter.x = FlxG.width - (deathCounter.width + 20);

		Actions.Tween(bg, {alpha: 0.625}, 0.4, {ease: FlxEase.quartInOut});
		Actions.Tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		Actions.Tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.4});
		Actions.Tween(deathCounter, {alpha: 1, y: deathCounter.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		Actions.Tween(suckLoops, {alpha: 1, y: 15}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);
		for (i in 0...menuItems.length){
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}
		changeSelection();	
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}
	override function update(elapsed:Float){
		if (PlayState.pauseMusic.volume < 0.5) PlayState.pauseMusic.volume += 0.01 * elapsed;
		super.update(elapsed);
		if (controls.UP_P) changeSelection(-1);
		if (controls.DOWN_P) changeSelection(1);
		if (controls.ACCEPT) checkMenuShit();
		if (controls.BACK && menuPage == "Difficulty"){
			menuPage = "Default";
			changeDickItems();
		}
	}
	override function destroy(){
		if (!goToOptions) PlayState.pauseMusic.destroy();
		super.destroy();
	}
	function changeSelection(change:Int = 0):Void{
		curSelected += change;
		if (curSelected < 0) curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length) curSelected = 0;
		var bullShit:Int = 0;
		for (item in grpMenuShit.members){
			item.targetY = bullShit - curSelected;
			bullShit++;
			item.alpha = 0.45;
			if (item.targetY == 0) item.alpha = 1;
		}
	}
}