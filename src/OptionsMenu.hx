package;
import flixel.FlxSubState;
import flixel.input.gamepad.FlxGamepad;
import Options;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
class OptionCategory extends FlxSprite{
	public var optionObjects:FlxTypedGroup<FlxText>;
	public var options:Array<Option>;
	public var titleObject:FlxText;
	public var middle:Bool = false;
	public var title:String;
	public function new(x:Float, y:Float, _title:String, _options:Array<Option>, middleType:Bool = false){
		super(x, y);
		title = _title;
		middle = middleType;
		if (!middleType) makeGraphic(295, 64, FlxColor.BLACK);
		alpha = 0.5;
		options = _options;
		optionObjects = new FlxTypedGroup();
		titleObject = new FlxText((middleType ? 1180 / 2 : x), y + (middleType ? 0 : 16), 0, title);
		titleObject.setFormat(Paths.font("Highman.ttf"), 35, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		titleObject.borderSize = 3;
		if (middleType)
			titleObject.x = 50 + ((1180 / 2) - (titleObject.fieldWidth / 2));
		else
			titleObject.x += (width / 2) - (titleObject.fieldWidth / 2);
		titleObject.scrollFactor.set();
		scrollFactor.set();
		for (i in 0...options.length){
			var opt = options[i];
			var text:FlxText = new FlxText((middleType ? 1180 / 2 : 72), titleObject.y + 54 + (46 * i), 0, opt.getValue());
			if (middleType) text.screenCenter(X);
			text.setFormat(Paths.font("Highman.ttf"), 35, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 3;
			text.borderQuality = 1;
			text.scrollFactor.set();
			optionObjects.add(text);
		}
	}
	public function changeColor(color:FlxColor){
		makeGraphic(295, 64, color);
	}
}
class OptionsMenu extends FlxSubState{
	public static var itIsNecessaryToRestart:Bool = false;
	public static var disableMerges:Bool = false;
	public var shownStuff:FlxTypedGroup<FlxText>;
	public static var visibleRange = [114, 640];
	public static var isStoryMenu:Bool = false;
	public static var isFreeplay:Bool = false;
	public static var isMainMenu:Bool = false;
	public var options:Array<OptionCategory>;
	public var menu:FlxTypedGroup<FlxSprite>;
	public static var isInPause:Bool = false;
	public static var instance:OptionsMenu;
	public var selectedCat:OptionCategory;
	public var selectedOptionIndex = 0;
	public var selectedOption:Option;
	var PressedGoOptionsIcon = false;
	public var background:FlxSprite;
	public var selectedCatIndex = 0;
	public var isInCat:Bool = false;
	public var descBack:FlxSprite;
	var goOptionsIcon:NewSprite;
	public var descText:FlxText;
	public function new(pauseMenu:Bool = false){
		super();
		isInPause = pauseMenu;
	}
	override function create(){
		options =[
			new OptionCategory(50, 40, "Gameplay",[
				new ScrollOptions("Toggle MiddleScroll; Making the Notes Scrolling Diretion (UP or DOWN); Change Scroll Pos Y; Change Scroll Speed, (1 = Chart Speed)."),
				new NoteOption("Toggle NoteSplash Shows in Pressed Rating Sick; Change How Late You Hit The Notes."),
				new NoteExtraOption("You Hit Note You Strum Move, Show Your Keys Every Start of the Song."),
				new OpenSubOptions("Press (ENTER: HUD, SHIFT: KEYBIND, CTRL: HITTING)"),
			]),
			new OptionCategory(345, 40, "Appearance",[
				new GraphicOption("Toggle Distractions That can Hinder Your Gameplay; Toggle Antialiasing, Improving Graphics Quality at a Slight Performance Penalt; Toogle Map for Show ou Hide Map for More FPS or Effects."),
				new VisualOption("Toggle Visual Effects; Toggle Flashing Lights That can Cause Epileptic Seizures and Strain; Toggle Shaking Camera."),
				new OpponentStrumNoteHit("Toggle Opponent Hit Glown Notes."),
			]),
			new OptionCategory(640, 40, "Misc",[
				new GaymingOption("Toggle New Imput, You Can Press Any Arrow or Old Imput You Can't Press Any Arrow no Notes Passing; Set Health Colors of Char Icons, (Example Tankman = black); Toggle Miss Sounds Playing When You Don't Hit a Note."),
				new CameraOption("Toggle Camera Zoom on Beat of Track; Toggle Camera Move on Diretion Hit Notes; FPS The Higher it Gets the Faster."),
				new OtherOption("Toggle AutoRespawn Skip the Dead Eggs State; Toggle R Press to Die; Toggle AutoPause When Not Focused on The Game The Game Pauses."),
				new FPSOption("Show You Current FPS."),
				new EngineMarkOption("Enable and Disable Engine Watermarks."),
				new DebugCharacterOffsetOption("Open Character OFFSETS to Set, Need Toggle Modding Tools Option (Need inside in Chart)."),
				new CacheOption("Cache Songs or Images or All in Gameplay to Open More Speed. (But Need Good PC!)"),
			]),
			new OptionCategory(935, 40, "Other",[
				new ModesOption("Botplay Plays Without You; Toggle Endless Very Loops to In Chart; Unlock More Difficuly in This Engine."),
				new ResetTypeOption("Reset ALL Your Settings / Score on ALL Songs and Weeks. (This is irreversible)!"),
				new ThisOption("Toggle Character Select Menu."),
				new GameOverOption("In Gamer Over Show You Last Scores Before Death."),
			]),
			new OptionCategory(-1, 125, "Editing Hitting",[
				new SafeFrameOption("Change Offset-Zone."),
				new SickMSOption("How Many Milliseconds Are in The Sick Hit."),
				new GoodMsOption("How Many Milliseconds Are in The Good Hit."),
				new BadMsOption("How Many Milliseconds Are in The Bad Hit."),
				new ShitMsOption("How Many Milliseconds Are in The Shit Hit.")
			], true),
			new OptionCategory(-1, 125, "Editing Keybinds",[
				new LeftKeybind("Left Note's Keybind."),
				new DownKeybind("Down Note's Keybind."),
				new UpKeybind("Up Note's Keybind."),
				new RightKeybind("Right Note's Keybind."),
				new DodgeKeybind("Dodge Keybind."),
				new PauseKeybind("Pause Keybind."),
				new ResetBind("Die keybind."),
				new ChartingKeyBind("Charting Keybind."),
				new MuteBind("Mute keybind."),
			], true),
			new OptionCategory(-1, 125, "Editing Hud",[
				new ScoreOption("Show or Hide Score."),
				new MissesOption("Show or Hide Misses."),
				new AccuracyOption("Show or Hide Accuracy."),
				new RatingOption("Show or Hide Rank."),
				new ComboOption("Show or Hide You Combo."),
				new ComboMaxOption("Show or Hide You Max Combo."),
				new StatsCounterOption("Show You Judgements."),
				new IconSpriteOption("Set Skins of Icons & Hide Icons."),
				new HealthPercentOption("Show or Hide You Health in Percent."),
				new HealthBGSOption("Show or Hide HealthBar & HealthBarBG."),
				new RatingSpriteOption("Rating in Strum you Hit Note, Rating Show in Strum you Hited, Defualt is Default in Center."),
				new TrackTimeOption("Show How Much Time is Left."),
				new RatingHUDOption("Change Rating HUD Layer; HUD Scale Hit Effects."),
				new ScrollLaneTransparencyOption("Set Transparency Lane Player's Scroll."),
				new ScoreLaneTransparencyOption("Set Transparency Lane Score."),
			], true)
		];
		instance = this;
		if (disableMerges){
			isMainMenu = false;
			isFreeplay = false;
			isStoryMenu = false;
		}
		menu = new FlxTypedGroup<FlxSprite>();
		shownStuff = new FlxTypedGroup<FlxText>();

		background = new FlxSprite(50, 40).makeGraphic(1180, 640, FlxColor.BLACK);
		background.alpha = 0.5;
		background.scrollFactor.set();
		menu.add(background);

		descBack = new FlxSprite(50, 640).makeGraphic(1180, 38, FlxColor.BLACK);
		descBack.alpha = 0.3;
		descBack.scrollFactor.set();
		menu.add(descBack);

		if (isInPause || isFreeplay || isStoryMenu || isMainMenu){
			var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			bg.alpha = 0;
			bg.scrollFactor.set();
			menu.add(bg);
			background.alpha = 0.5;
			bg.alpha = 0.625;
			cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
		}
		selectedCat = options[0];
		selectedOption = selectedCat.options[0];
		add(menu);
		add(shownStuff);

		for (i in 0...options.length - 1){
			if (i >= 4) continue;
			var cat = options[i];
			add(cat);
			add(cat.titleObject);
		}

		descText = new FlxText(62, 648);
		descText.setFormat(Paths.font("Highman.ttf"), 20, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.borderSize = 2;
		add(descBack);
		add(descText);

		goOptionsIcon = new NewSprite(1215, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['GoOptions_Idle', 'GoOptions_MouseOver']);
		NewSprite.SpriteComplement.setVariables(goOptionsIcon, true, null, null, 0.25, 0.25);
		if (isInPause && !isFreeplay && !isStoryMenu && !isMainMenu)
			add(goOptionsIcon);

		isInCat = true;
		switchCat(selectedCat);
		selectedOption = selectedCat.options[0];
		DiscordClient.globalPresence('OptionsMenu');
		super.create();
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (isInPause && !isFreeplay && !isStoryMenu && !isMainMenu){
			if (FlxG.mouse.overlaps(goOptionsIcon)){
				Actions.PlaySprAnim(goOptionsIcon, 'GoOptions_MouseOver');
				if (!PressedGoOptionsIcon && FlxG.mouse.justPressed){
					PressedGoOptionsIcon = true;
					Actions.States('Switch', new OptionsDirect());
				}
			}else
				if (!PressedGoOptionsIcon) Actions.PlaySprAnim(goOptionsIcon, 'GoOptions_Idle');
		}
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		var accept = false;
		var shift = false;
		var ctrl = false;
		var right = false;
		var left = false;
		var up = false;
		var down = false;
		var any = false;
		var escape = false;
		accept = FlxG.keys.justPressed.ENTER || (gamepad != null ? gamepad.justPressed.A : false);
		shift = FlxG.keys.justPressed.SHIFT /*|| (gamepad != null ? gamepad.justPressed.A : false)*/;
		ctrl = FlxG.keys.justPressed.CONTROL /*|| (gamepad != null ? gamepad.justPressed.A : false)*/;
		right = FlxG.keys.justPressed.RIGHT || (gamepad != null ? gamepad.justPressed.DPAD_RIGHT : false);
		left = FlxG.keys.justPressed.LEFT || (gamepad != null ? gamepad.justPressed.DPAD_LEFT : false);
		up = FlxG.keys.justPressed.UP || (gamepad != null ? gamepad.justPressed.DPAD_UP : false);
		down = FlxG.keys.justPressed.DOWN || (gamepad != null ? gamepad.justPressed.DPAD_DOWN : false);
		any = FlxG.keys.justPressed.ANY || (gamepad != null ? gamepad.justPressed.ANY : false);
		escape = FlxG.keys.justPressed.ESCAPE || (gamepad != null ? gamepad.justPressed.B : false);
		if (selectedCat != null && !isInCat){
			for (i in selectedCat.optionObjects.members){
				if (selectedCat.middle)
					i.screenCenter(X);
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
					i.alpha = (selectedCat.optionObjects.members[selectedOptionIndex].text != i.text ? 0.35 : 1);
			}
		}try{
			if (isInCat){
				descText.text = "Please Select a Category";
				if (right){
					Actions.PlaySound('scrollMenu');
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex++;
					if (selectedCatIndex > options.length - 4)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 4;
					switchCat(options[selectedCatIndex]);
				}else if (left){
					Actions.PlaySound('scrollMenu');
					selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
					selectedCatIndex--;
					if (selectedCatIndex > options.length - 4)
						selectedCatIndex = 0;
					if (selectedCatIndex < 0)
						selectedCatIndex = options.length - 4;
					switchCat(options[selectedCatIndex]);
				}
				if (accept){
					Actions.PlaySound('scrollMenu');
					selectedOptionIndex = 0;
					isInCat = false;
					selectOption(selectedCat.options[0]);
				}
				if (escape && !PressedGoOptionsIcon){
					if (isFreeplay){
						isFreeplay = false;
						close();
					}else if (isStoryMenu){
						isStoryMenu = false;
						close();
					}else if (isMainMenu){
						isMainMenu = false;
						close();
					}else{
						if (!isInPause)
							FlxG.switchState(new MainMenuState());
						else{
							PauseSubState.goBack = true;
							if (!itIsNecessaryToRestart){
							}else{
								PlayState.loops = 0;
								PlayState.death = 0;
								FlxG.resetState();
							}
							close();
						}
					}
				}
			}else{
				if (selectedOption != null)
					if (selectedOption.acceptPress){
						if (escape && selectedOption.waitingPress && !PressedGoOptionsIcon){
							Actions.PlaySound('scrollMenu');
							selectedOption.waitingPress = false;
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							object.text = "> " + selectedOption.getValue();
							return;
						}else if (any){
							var object = selectedCat.optionObjects.members[selectedOptionIndex];
							selectedOption.onPress(gamepad == null ? FlxG.keys.getIsDown()[0].ID.toString() : gamepad.firstJustPressedID());
							object.text = "> " + selectedOption.getValue();
						}
					}
				if (selectedOption.acceptPress || !selectedOption.acceptPress){
					if (accept){
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.press();
						if (selectedOptionIndex == prev){
							FlxG.save.flush();
							object.text = "> " + selectedOption.getValue();
						}
					}
					if (shift){
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.shift();
						if (selectedOptionIndex == prev){
							FlxG.save.flush();
							object.text = "> " + selectedOption.getValue();
						}
					}
					if (ctrl){
						var prev = selectedOptionIndex;
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.ctrl();
						if (selectedOptionIndex == prev){
							FlxG.save.flush();
							object.text = "> " + selectedOption.getValue();
						}
					}
					if (down){
						if (selectedOption.acceptPress) selectedOption.waitingPress = false;
						Actions.PlaySound('scrollMenu');
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex++;
						if (selectedOptionIndex > options[selectedCatIndex].options.length - 1){
							for (i in 0...selectedCat.options.length){
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
							selectedOptionIndex = 0;
						}
						if (selectedOptionIndex != 0 && selectedOptionIndex != options[selectedCatIndex].options.length - 1 && options[selectedCatIndex].options.length > 6){
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
									i.y -= 46;
						}
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}else if (up){
						if (selectedOption.acceptPress) selectedOption.waitingPress = false;
						Actions.PlaySound('scrollMenu');
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						selectedOptionIndex--;
						if (selectedOptionIndex < 0){
							selectedOptionIndex = options[selectedCatIndex].options.length - 1;
							if (options[selectedCatIndex].options.length > 6)
								for (i in selectedCat.optionObjects.members)
									i.y -= (46 * ((options[selectedCatIndex].options.length - 1) / 2));
						}
						if (selectedOptionIndex != 0 && options[selectedCatIndex].options.length > 6){
							if (selectedOptionIndex >= (options[selectedCatIndex].options.length - 1) / 2)
								for (i in selectedCat.optionObjects.members)
									i.y += 46;
						}
						if (selectedOptionIndex < (options[selectedCatIndex].options.length - 1) / 2){
							for (i in 0...selectedCat.options.length){
								var opt = selectedCat.optionObjects.members[i];
								opt.y = selectedCat.titleObject.y + 54 + (46 * i);
							}
						}
						selectOption(options[selectedCatIndex].options[selectedOptionIndex]);
					}
					if (right){
						Actions.PlaySound('scrollMenu');
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.right();
						FlxG.save.flush();
						object.text = "> " + selectedOption.getValue();
					}else if (left){
						Actions.PlaySound('scrollMenu');
						var object = selectedCat.optionObjects.members[selectedOptionIndex];
						selectedOption.left();
						FlxG.save.flush();
						object.text = "> " + selectedOption.getValue();
					}
					if (escape && !PressedGoOptionsIcon){
						Actions.PlaySound('scrollMenu');
						if (selectedCatIndex >= 4) selectedCatIndex = 0;
						PlayerSettings.player1.controls.loadKeyBinds();
						Rating.hitMs = [
							FlxG.save.data.shitMs,
							FlxG.save.data.badMs,
							FlxG.save.data.goodMs,
							FlxG.save.data.sickMs
						];
						for (i in 0...selectedCat.options.length){
							var opt = selectedCat.optionObjects.members[i];
							opt.y = selectedCat.titleObject.y + 54 + (46 * i);
						}
						selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
						isInCat = true;
						if (selectedCat.optionObjects != null)
							for (i in selectedCat.optionObjects.members){
								if (i != null){
									if (i.y < visibleRange[0] - 24)
										i.alpha = 0;
									else if (i.y > visibleRange[1] - 24)
										i.alpha = 0;
									else
										i.alpha = 0.35;
								}
							}
						if (selectedCat.middle)
							switchCat(options[0]);
					}
				}
			}
		}catch (e){
			selectedCatIndex = 0;
			selectedOptionIndex = 0;
			Actions.PlaySound('scrollMenu');
			if (selectedCat != null){
				for (i in 0...selectedCat.options.length){
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
				selectedCat.optionObjects.members[selectedOptionIndex].text = selectedOption.getValue();
				isInCat = true;
			}
		}
	}
	public function selectOption(option:Option){
		var object = selectedCat.optionObjects.members[selectedOptionIndex];
		selectedOption = option;
		if (!isInCat){
			object.text = "> " + option.getValue();
			descText.text = option.getDescription();
		}
	}
	public function switchCat(cat:OptionCategory, checkForOutOfBounds:Bool = true){
		try{
			visibleRange = [114, 640];
			if (cat.middle) visibleRange = [Std.int(cat.titleObject.y), 640];
			if (selectedOption != null){
				var object = selectedCat.optionObjects.members[selectedOptionIndex];
				object.text = selectedOption.getValue();
			}
			if (selectedCatIndex > options.length - 3 && checkForOutOfBounds)
				selectedCatIndex = 0;
			if (selectedCat.middle)
				remove(selectedCat.titleObject);
			selectedCat.changeColor(FlxColor.BLACK);
			selectedCat.alpha = 0.3;
			for (i in 0...selectedCat.options.length){
				var opt = selectedCat.optionObjects.members[i];
				opt.y = selectedCat.titleObject.y + 54 + (46 * i);
			}
			while (shownStuff.members.length != 0)
				shownStuff.members.remove(shownStuff.members[0]);
			selectedCat = cat;
			selectedCat.alpha = 0.2;
			selectedCat.changeColor(FlxColor.WHITE);
			if (selectedCat.middle)
				add(selectedCat.titleObject);
			for (i in selectedCat.optionObjects)
				shownStuff.add(i);
			selectedOption = selectedCat.options[0];
			if (selectedOptionIndex > options[selectedCatIndex].options.length - 1){
				for (i in 0...selectedCat.options.length){
					var opt = selectedCat.optionObjects.members[i];
					opt.y = selectedCat.titleObject.y + 54 + (46 * i);
				}
			}
			selectedOptionIndex = 0;
			if (!isInCat)
				selectOption(selectedOption);
			for (i in selectedCat.optionObjects.members){
				if (i.y < visibleRange[0] - 24)
					i.alpha = 0;
				else if (i.y > visibleRange[1] - 24)
					i.alpha = 0;
				else
					i.alpha = 0.35;
			}
		}catch (e)
			selectedCatIndex = 0;
	}
}