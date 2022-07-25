package;
import haxe.Json;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
using StringTools;
class MainMenuState extends MusicBeatState{
	public static var EngineFreakyMenu:String = 'NG_Freaky_Menu';
	public static var timeToUnlockedIdleIcon:Float = 0.5;
	public static var engineVersion:String = "1.0.5";
	public static var endTweenMove:Bool = false;
	public static var firstOpen:Bool = true;
	var menuItems:FlxTypedGroup<FlxSprite>;
	var PressedConsoleCodeIcon = false;
	var PressedGamebananaIcon = false;
	var MainMenuConfig:MainMenuJson;
	var PressedGameJoltIcon = false;
	var PressedDiscordIcon = false;
	var PressedYoutubeIcon = false;
	var PressedGithubIcon = false;
	var consoleCodeIcon:NewSprite;
	var selectedSomethin = false;
	var optionsSubIcon:NewSprite;
	var gamebananaIcon:NewSprite;
	var PressedExitIcon = false;
	var goOptionsIcon:NewSprite;
	var gemejoltIcon:NewSprite;
	var discordIcon:NewSprite;
	var youtubeIcon:NewSprite;
	var githubIcon:NewSprite;
	var curSelected:Int = 0;
	var camFollow:FlxObject;
	var iconsY:Float = 675;
	var exitIcon:NewSprite;
	override function create(){
		MainMenuConfig = Json.parse(openfl.utils.Assets.getText(Paths.jsonAny(Client.Public.gameFolder + 'MainMenuConfig', 'config')));
		FlxG.mouse.visible = true;
		PlayState.IsPlayState = false;
		PressedConsoleCodeIcon = false;
		PressedDiscordIcon = false;
		PressedExitIcon = false;
		PressedGameJoltIcon = false;
		PressedGamebananaIcon = false;
		PressedGithubIcon = false;
		PressedYoutubeIcon = false;
		OptionsMenu.isFreeplay = false;
		OptionsMenu.isMainMenu = false;
		OptionsMenu.isStoryMenu = false;
		OptionsMenu.disableMerges = false;
		ConsoleCodeState.secretSongName = '';
		CharacterSelect.getSongName = '';
		DiscordClient.globalPresence('MainMenuState');
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		if (!FlxG.sound.music.playing) Actions.PlayTrack(EngineFreakyMenu);
		persistentUpdate = persistentDraw = true;
		StateImage.BGSMenus('MainMenuBG', add);
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		StateImage.BGSMenus('MainMenuUnderBG', add);
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		var texureMenu = Paths.getSparrowAtlas('MainMenu_Assets');
		for (i in 0...MainMenuConfig.MainMenuBottomSpr.length){
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = texureMenu;
			menuItem.animation.addByPrefix('idle', MainMenuConfig.MainMenuBottomSpr[i] + " Idle", 24);
			menuItem.animation.addByPrefix('selected', MainMenuConfig.MainMenuBottomSpr[i] + " Selected", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = Client.Public.antialiasing;
			if (firstOpen)
				Actions.Tween(menuItem, {y: 60 + (i * 160)}, 1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween){ 
					endTweenMove = true; 
					changeItem();
				}});
			else
				menuItem.y = 60 + (i * 160);
		}
		consoleCodeIcon = new NewSprite(1195, -5, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Console_Idle', 'Console_MouseOver']);
		NewSprite.SpriteComplement.setVariables(consoleCodeIcon, true, null, null, 0.15, 0.15);
		add(consoleCodeIcon);
		discordIcon = new NewSprite(1235, iconsY, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Discord_Idle', 'Discord_MouseOver']);
		NewSprite.SpriteComplement.setVariables(discordIcon, true, null, null, 0.15, 0.15);
		add(discordIcon);
		exitIcon = new NewSprite(-10, (Client.Public.downscroll ? -10 : 650), 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Exit_Idle', 'Exit_MouseOver']);
		NewSprite.SpriteComplement.setVariables(exitIcon, true, null, null, 0.25, 0.25);
		add(exitIcon);
		gemejoltIcon = new NewSprite(1145, iconsY, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['GameJolt_Idle', 'GameJolt_MouseOver']);
		NewSprite.SpriteComplement.setVariables(gemejoltIcon, true, null, null, 0.15, 0.15);
		add(gemejoltIcon);
		gamebananaIcon = new NewSprite(1113, iconsY, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Gamebanana_Idle', 'Gamebanana_MouseOver']);
		NewSprite.SpriteComplement.setVariables(gamebananaIcon, true, null, null, 0.15, 0.15);
		add(gamebananaIcon);
		githubIcon = new NewSprite(1186.5, iconsY, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Github_Idle', 'Github_MouseOver']);
		NewSprite.SpriteComplement.setVariables(githubIcon, true, null, null, 0.149, 0.149);
		add(githubIcon);
		youtubeIcon = new NewSprite(1060, iconsY, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Youtube_Idle', 'Youtube_MouseOver']);
		NewSprite.SpriteComplement.setVariables(youtubeIcon, true, null, null, 0.17, 0.17);
		add(youtubeIcon);
		optionsSubIcon = new NewSprite(-10, (Client.Public.downscroll ? 50 : 590), 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['SubOptions_Idle', 'SubOptions_MouseOver']);
		NewSprite.SpriteComplement.setVariables(optionsSubIcon, true, null, null, 0.25, 0.25);
		add(optionsSubIcon);
		goOptionsIcon = new NewSprite(1215, 50, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['GoOptions_Idle', 'GoOptions_MouseOver']);
		NewSprite.SpriteComplement.setVariables(goOptionsIcon, true, null, null, 0.25, 0.25);
		add(goOptionsIcon);
		firstOpen = false;
		FlxG.camera.follow(camFollow, null, 0.06);
		var engineVersion:FlxText = new FlxText(1, (Client.Public.downscroll ? FlxG.height - 50 : 25), 0, "NG'S Engine - v" + engineVersion, 12);
		engineVersion.scrollFactor.set();
		engineVersion.setFormat("Highman.tff", 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(engineVersion);
		var versionShit:FlxText = new FlxText(1, (Client.Public.downscroll ? FlxG.height - 25 : 0), 0, "Friday Night Funkin' - v0.2.7.1", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("Highman.tff", 21, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		changeItem();
		super.create();
	}
	override function update(elapsed:Float){
		if (FlxG.sound.music.volume < 0.8) FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		if (!PressedExitIcon && !PressedConsoleCodeIcon){
			if (!selectedSomethin && endTweenMove && !OptionsMenu.isMainMenu){
				if (controls.UP_P){
					Actions.PlaySound('scrollMenu');
					changeItem(-1);
				}
				if (controls.DOWN_P){
					Actions.PlaySound('scrollMenu');
					changeItem(1);
				}
				if (controls.ACCEPT){
					if (MainMenuConfig.MainMenuBottomSpr[curSelected] == 'Donate')
						Actions.OpenLink("https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game/description");
					else{
						FlxFlicker.flicker(StateImage.magenta, 1.1, 0.15, false);
						Actions.PlaySound('confirmMenu');
						selectedSomethin = true;
						menuItems.forEach(function(spr:FlxSprite){
							if (curSelected != spr.ID){
								Actions.Tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.quadOut,
									onComplete: function(twn:FlxTween){
										spr.kill();
									}
								});
							}else{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
									var daChoice:String = MainMenuConfig.MainMenuBottomSpr[curSelected];
									switch (daChoice){
										case 'Story Mode': Actions.States('Switch', new StoryMenuState());
										case 'Freeplay': Actions.States('Switch', new FreeplayState());
									}
									trace(daChoice + " Selected");
								});
							}
						});
					}
				}
			}
			if (FlxG.mouse.overlaps(consoleCodeIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(consoleCodeIcon, 'Console_MouseOver');
					if (!PressedConsoleCodeIcon && FlxG.mouse.justPressed){
						PressedConsoleCodeIcon = true;
						Actions.States('Switch', new ConsoleCodeState());
					}
				}
			}else
				if (!PressedConsoleCodeIcon) Actions.PlaySprAnim(consoleCodeIcon, 'Console_Idle');
			if (FlxG.mouse.overlaps(discordIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(discordIcon, 'Discord_MouseOver');
					if (FlxG.mouse.justPressed){
						PressedDiscordIcon = true;
						Actions.OpenLink("https://discord.gg/Fkz2NT8QpU");
					}
				}
			}else
				if (!PressedDiscordIcon) Actions.PlaySprAnim(discordIcon, 'Discord_Idle');
			if (FlxG.mouse.overlaps(exitIcon)){
				Actions.PlaySprAnim(exitIcon, 'Exit_MouseOver');
				if (!PressedExitIcon && FlxG.mouse.justPressed){
					PressedExitIcon = true;
					Actions.PlaySound('cancelMenu');
					Actions.States('Switch', new TitleState());
				}
			}else
				if (!PressedExitIcon) Actions.PlaySprAnim(exitIcon, 'Exit_Idle');
			if (FlxG.mouse.overlaps(gemejoltIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(gemejoltIcon, 'GameJolt_MouseOver');
					if (FlxG.mouse.justPressed){
						PressedGameJoltIcon = true;
						Actions.OpenLink("https://gamejolt.com/games/ngs_engine/702509");
					}
				}
			}else
				if (!PressedGameJoltIcon) Actions.PlaySprAnim(gemejoltIcon, 'GameJolt_Idle');
			if (FlxG.mouse.overlaps(gamebananaIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(gamebananaIcon, 'Gamebanana_MouseOver');
					if (FlxG.mouse.justPressed){
						PressedGamebananaIcon = true;
						Actions.OpenLink("https://gamebanana.com/wips/66024");
					}
				}
			}else
				if (!PressedGamebananaIcon) Actions.PlaySprAnim(gamebananaIcon, 'Gamebanana_Idle');
			if (FlxG.mouse.overlaps(githubIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(githubIcon, 'Github_MouseOver');
					if (FlxG.mouse.justPressed){
						PressedGithubIcon = true;
						Actions.OpenLink("https://github.com/NGS300/NG-S-Engine");
					}
				}
			}else
				if (!PressedGithubIcon) Actions.PlaySprAnim(githubIcon, 'Github_Idle');
			if (FlxG.mouse.overlaps(youtubeIcon)){
				if (!OptionsMenu.isMainMenu){
					Actions.PlaySprAnim(youtubeIcon, 'Youtube_MouseOver');
					if (FlxG.mouse.justPressed){
						PressedYoutubeIcon = true;
						Actions.OpenLink("https://www.youtube.com/channel/UCtLfjD8idBXc5ll2J9TobAQ");
					}
				}
			}else
				if (!PressedYoutubeIcon) Actions.PlaySprAnim(youtubeIcon, 'Youtube_Idle');
			if (FlxG.mouse.overlaps(optionsSubIcon)){
				Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_MouseOver');
				if (!OptionsMenu.isMainMenu && FlxG.mouse.justPressed){
					OptionsMenu.isMainMenu = true;
					openSubState(new OptionsMenu(true));
				}
			}else
				if (!OptionsMenu.isMainMenu) Actions.PlaySprAnim(optionsSubIcon, 'SubOptions_Idle');
			if (FlxG.mouse.overlaps(goOptionsIcon)){
				Actions.PlaySprAnim(goOptionsIcon, 'GoOptions_MouseOver');
				if (!OptionsMenu.isMainMenu && FlxG.mouse.justPressed){
					OptionsMenu.isMainMenu = true;
					OptionsMenu.disableMerges = true;
					Actions.States('Switch', new OptionsDirect());
				}
			}else
				if (!OptionsMenu.isMainMenu) Actions.PlaySprAnim(goOptionsIcon, 'GoOptions_Idle');
			if (PressedDiscordIcon){
				new FlxTimer().start(timeToUnlockedIdleIcon, function(tmr:FlxTimer){
					PressedDiscordIcon = false;
				});
			}
			if (PressedGameJoltIcon){
				new FlxTimer().start(timeToUnlockedIdleIcon, function(tmr:FlxTimer){
					PressedGameJoltIcon = false;
				});
			}
			if (PressedGamebananaIcon){
				new FlxTimer().start(timeToUnlockedIdleIcon, function(tmr:FlxTimer){
					PressedGamebananaIcon = false;
				});
			}
			if (PressedGithubIcon){
				new FlxTimer().start(timeToUnlockedIdleIcon, function(tmr:FlxTimer){
					PressedGithubIcon = false;
				});
			}
			if (PressedYoutubeIcon){
				new FlxTimer().start(timeToUnlockedIdleIcon, function(tmr:FlxTimer){
					PressedYoutubeIcon = false;
				});
			}
		}
		super.update(elapsed);
		menuItems.forEach(function(spr:FlxSprite){
			spr.screenCenter(X);
		});
	}
	function changeItem(huh:Int = 0){
		curSelected += huh;
		if (curSelected >= menuItems.length) curSelected = 0;
		if (curSelected < 0) curSelected = menuItems.length - 1;
		menuItems.forEach(function(spr:FlxSprite){
			Actions.PlaySprAnim(spr, 'idle');
			if (spr.ID == curSelected && endTweenMove){
				Actions.PlaySprAnim(spr, 'selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}
			spr.updateHitbox();
		});
	}
}
typedef MainMenuJson ={
	var MainMenuBottomSpr:Array<String>;
} 