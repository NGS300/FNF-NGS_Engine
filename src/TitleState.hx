package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.app.Application;
import openfl.Assets;
using StringTools;
class TitleState extends MusicBeatState{
	var http = new haxe.Http("https://raw.githubusercontent.com/NGS300/Ngs-Engine/development/gitEngineVersion.txt");
	public static var updateVersion:String = '';
	static var initialized:Bool = false;
	var curWacky:Array<String> = [];
	var showNewUpdate:Bool = false;
	var transitioning:Bool = false;
	var skippedIntro:Bool = false;
	var isOldLogo:Bool = false;
	var blackScreen:FlxSprite;
	var credTextShit:Alphabet;
	var ngs300Spr:NewSprite;
	var charDance:NewSprite;
	var titleText:NewSprite;
	var credGroup:FlxGroup;
	var textGroup:FlxGroup;
	var ngeLogo:NewSprite;
	var ngSpr:NewSprite;
	var randomLogo = 0;
	var randomChar = 0;
	override public function create():Void{
		Main.dumpCache();
		Paths.clearTraceSounds();
		randomLogo = FlxG.random.int(0, 8);
		randomChar = FlxG.random.int(0, 3);
		isOldLogo = FlxG.random.bool(50);
		curWacky = FlxG.random.getObject(getIntroTextShit());
		super.create();
		FlxG.autoPause = FlxG.save.data.autoPause;
		FlxG.save.bind('NGE', 'NGS300');
		PlayerSettings.init();
		Client.loadData();
        Client.loadJson();
		FlxG.sound.muteKeys = [FlxKey.fromString(FlxG.save.data.muteBind)];
		FlxG.mouse.visible = false;
		Highscore.loadSavedScores();
		#if FREEPLAY Actions.States('Switch', new FreeplayState()); #elseif CHARTING Actions.States('Switch', new ChartingState()); #else
		new FlxTimer().start(1, function(tmr:FlxTimer){ startIntro(); });
		#end
		http.onData = function (data:String){
			updateVersion = data.split('\n')[0].trim();
			var curVersion:String = MainMenuState.engineVersion.trim();
			trace ('New Version: ' + updateVersion + ', Current Version: ' + curVersion);
			if (updateVersion != curVersion) showNewUpdate = true;
		}	
		http.onError = function (error){ trace('error: $error'); }	
		http.request();
		#if desktop
		DiscordClient.initialize();
		Application.current.onExit.add (function (exitCode){ DiscordClient.shutdown(); });
		#end
	}
	function startIntro(){
		if (!initialized){
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;
			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
			Actions.PlayTrack(MainMenuState.EngineFreakyMenu, null, 0);
			Actions.FadeTrack(true, 4, 0, 0.7);
		}
		Conductor.changeBPM(102);
		persistentUpdate = true;
		StateImage.BGSMenus('TittleBG', add);
		switch (randomLogo){ // Show Random Logos
			case 0: // CuanRemix Logo
				ngeLogo = new NewSprite(432.325, -52.120, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpinMain'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.8, 0.8);
			case 1: // Juniorxefao Logo
				ngeLogo = new NewSprite(635, -55, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin1'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.77, 0.77);
			case 2: // KkpassaroxX Logo
				ngeLogo = new NewSprite(645, (!isOldLogo ? -50 : -55), 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin20' : 'NGSLogoBumpin2Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.7765, 0.7765);
			case 3: // Maty Logo
				ngeLogo = new NewSprite((!isOldLogo ? 570 : 630), (!isOldLogo ? -225 : -25), 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin30' : 'NGSLogoBumpin3Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.69, 0.69);
			case 4: // Jenvi Logo
				ngeLogo = new NewSprite(495, -5, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin4'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.745, 0.745);
			case 5: // Tiozão Logo
				ngeLogo = new NewSprite(655, -70, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin5'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.6436, 0.6436);
			case 6: // Júpiterzim Logo
				ngeLogo = new NewSprite((!isOldLogo ? 480 : 495), -157.75, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin60' : 'NGSLogoBumpin6Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.775, 0.775);
			case 7: // Marshverso Logo
				ngeLogo = new NewSprite(690, 5, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin7'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.5, 0.5);
			case 8: // Maty Logo Promo
				ngeLogo = new NewSprite(540, -140, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin8'], 24, true, false);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.69, 0.69);
		}
		FlxTween.angle(ngeLogo, -10, 10, 2.0, {ease: FlxEase.quadInOut, type: PINGPONG});
		switch (randomChar){ // Show Random Characters
			case 0: // .ng | NGS300
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 0, null, null, ['ng_idle'], 24, true);
				charDance.x -= 475;
				charDance.y += 7;
			case 1: // KkpassaroxX
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['KkpassaroxX_idle'], 24, true);
				charDance.x -= 450;
				charDance.y -= 95;
			case 2: // REX | Juniorxefao
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['rex_idle'], 24, true);
				charDance.x -= 452;
				charDance.y += 37.25;
			case 3: // MATY
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['maty_idle'], 24, true);
				charDance.x -= 450;
				charDance.y += 11;
		}
		add(charDance);
		add(ngeLogo);

		titleText = new NewSprite(100, FlxG.height * 0.8, 'TitleShit/titleEnter', null, true, 1, null, null, ['Press Enter to Begin', 'ENTER PRESSED'], 24, true);
		NewSprite.SpriteComplement.setVariables(titleText, true);
		add(titleText);

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();
		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);
		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();
		credTextShit.visible = false;

		ngSpr = new NewSprite(0, FlxG.height * 0.52, 'TitleShit/Logos/NewgroundsLogo', null, false);
		NewSprite.SpriteComplement.setVariables(ngSpr, true, 0.8, null, null, null, null, null, true, X);
		ngs300Spr = new NewSprite(0, FlxG.height * 0.52, 'TitleShit/Logos/NGSLogo', null, false);
		NewSprite.SpriteComplement.setVariables(ngs300Spr, true, 0.8, null, null, null, null, null, true, X);
		add((!Main.engineMark ? ngSpr : ngs300Spr));

		Actions.Tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxG.mouse.visible = false;
		if (initialized) skipIntro(); else initialized = true;
	}
	override function update(elapsed:Float){
		if (FlxG.sound.music != null) Conductor.songPosition = FlxG.sound.music.time;
		if (FlxG.keys.justPressed.F) FlxG.fullscreen = !FlxG.fullscreen;
		if (controls.ACCEPT && !transitioning && skippedIntro){
			Actions.PlaySprAnim(titleText, 'ENTER PRESSED');
			Actions.Flash(FlxG.camera, FlxColor.WHITE, 1);
			Actions.PlaySound('confirmMenu', null, 0.7);
			transitioning = true;
			MainMenuState.firstOpen = true;
			MainMenuState.endTweenMove = false;
			new FlxTimer().start(2, function(tmr:FlxTimer){
				Actions.States('Switch', (showNewUpdate ? new OutdatedState() : new MainMenuState()));
			});
		}
		if (controls.ACCEPT && !skippedIntro) skipIntro();
		super.update(elapsed);
	}
	override function beatHit(){
		super.beatHit();
		FlxG.log.add(curBeat);
		switch (curBeat){
			case 0: deleteCoolText();
			case 1: createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8er']);
			case 3: addMoreText('present');
			case 4: deleteCoolText();
			case 5: createCoolText([(Main.engineMark ? 'NGS Engine' : 'In Partnership'), (Main.engineMark ? 'by' : 'with')]);
			case 7: addMoreText((Main.engineMark ? 'NGS' : 'Newgrounds'));
				if (!Main.engineMark)
					//ngs300Spr.visible = true;
				//else
					ngSpr.visible = true;
			case 8: deleteCoolText();
				(Main.engineMark ? ngs300Spr.visible = false : ngSpr.visible = false);	
			case 9: createCoolText([curWacky[0]]);
			case 11: addMoreText(curWacky[1]);
			case 12: deleteCoolText();
			case 13: addMoreText('Friday');
			case 14: addMoreText('Night');
			case 15: addMoreText('Funkin');
			case 16: skipIntro();
		}
	}
	function skipIntro():Void{
		if (!skippedIntro){
			remove((!Main.engineMark ? ngSpr : ngs300Spr));
			Actions.Flash(FlxG.camera, (randomChar == 0 ? FlxColor.RED : FlxColor.WHITE), 4);
			remove(credGroup);
			skippedIntro = true;
			if (randomChar == 0) Actions.Alpha(charDance, 1, 5, {ease: FlxEase.sineInOut});
		}
	}
	function getIntroTextShit():Array<Array<String>>{
		var fullText:String = Assets.getText(Paths.txt('IntroText'));
		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];
		for (i in firstArray){ swagGoodArray.push(i.split(' - ')); }
		return swagGoodArray;
	}
	function createCoolText(textArray:Array<String>){
		for (i in 0...textArray.length){
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}
	function addMoreText(text:String){
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}
	function deleteCoolText(){
		while (textGroup.members.length > 0){
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}
}