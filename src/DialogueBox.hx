package;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using StringTools;
class DialogueBox extends FlxSpriteGroup{
	var dialogueList:Array<String> = [];
	var timerEndPortrait:Float = 1.405;
	public var finishThing:Void->Void;
	var dialogueStarted:Bool = false;
	var dialogueOpened:Bool = false;
	var curCharacter:String = '';
	var swagDialogue:FlxTypeText;
	var portraitRight:FlxSprite;
	var portraitLeft:FlxSprite;
	var isEnding:Bool = false;
	var handSelect:FlxSprite;
	var dialogue:Alphabet;
	var hasDialog = false;
	var dropText:FlxText;
	var bgFade:FlxSprite;
	var face:FlxSprite;
	var box:FlxSprite;
	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>){
		super();
		scrollFactor.set();
		switch (PlayState.SONG.song.toLowerCase()){ // Start Action Dialogue
			case 'senpai':
				Actions.PlayTrack('pixel/school/Lunchbox', 'maps', 0);
				Actions.FadeTrack(true, 1, 0, 0.8);
			case 'thorns':
				Actions.PlayTrack('pixel/school/LunchboxScary', 'maps', 0);
				Actions.FadeTrack(true, 1, 0, 0.8);
		}
		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);
		new FlxTimer().start(0.8325, function(tmr:FlxTimer){
			Actions.Tween(bgFade, {alpha: (1 / 5)}, 0.65, {ease: FlxEase.cubeOut});
			if (bgFade.alpha > 0.7) bgFade.alpha = 0.7;
		}, 5);
		box = new FlxSprite(-20, 45);
		switch (PlayState.SONG.song.toLowerCase()){
			case 'senpai':
				hasDialog = true;
				loadSprBox('senpai-pixel');
			case 'roses':
				hasDialog = true;
				loadSprBox('senpai-angry-pixel');
			case 'thorns':
				hasDialog = true;
				loadSprBox('spirit-pixel');
		}
		this.dialogueList = dialogueList;
		if (!hasDialog) return;
		switch (PlayState.SONG.song.toLowerCase()){
			case 'senpai' | 'roses' | 'thorns':
				portraitDialogue('senpai-pixel', -20, 40);
				portraitDialogue('bf-pixel', 0, 40);
		}
		boxComplement();
		switch (PlayState.SONG.song.toLowerCase()){
			default:
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 33);
				dropText.font = 'Highman.ttf';
				dropText.color = 0xFFD89494;
				add(dropText);
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 33);
				swagDialogue.font = 'Highman.ttf';
				swagDialogue.color = 0xFF3F2021;
				//swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				add(swagDialogue);
			case 'senpai' | 'roses' | 'thorns':
				portraitLeft.screenCenter(X);
				handSelect = new NewSprite(FlxG.width * 0.9, FlxG.height * 0.9, 'dialogueShits/talkingSprites/pixel/week6Talking/handTextBox', 'shared');
				add(handSelect);
				dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
				dropText.font = 'Pixel Arial 11 Bold';
				dropText.color = 0xFFD89494;
				add(dropText);
				swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
				swagDialogue.font = 'Pixel Arial 11 Bold';
				swagDialogue.color = 0xFF3F2021;
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('school/pixelTextSound', 'maps'), 0.6)];
				add(swagDialogue);
		}
		dialogue = new Alphabet(0, 80, "", false, true);
	}
	override function update(elapsed:Float){
		switch (PlayState.SONG.song.toLowerCase()){
			case 'roses' | 'thorns':
				portraitLeft.visible = false;
				if (PlayState.SONG.song.toLowerCase() == 'thorns'){
					portraitLeft.color = FlxColor.BLACK;
					swagDialogue.color = FlxColor.WHITE;
					dropText.color = FlxColor.BLACK;
				}
		}
		dropText.text = swagDialogue.text;
		if (box.animation.curAnim != null){
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished){
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}
		if (dialogueOpened && !dialogueStarted){
			startDialogue();
			dialogueStarted = true;
		}
		if (FlxG.mouse.justPressed && dialogueStarted){
			remove(dialogue);
			Actions.PlaySound('clickText', null, 0.8);
			if (dialogueList[0] != null && dialogueList[1] == null){
				if (!isEnding){
					isEnding = true;
					switch (PlayState.SONG.song.toLowerCase()){
						case 'senpai' | 'thorns': Actions.FadeTrack(false, 2.2, null, 0);
					}
					new FlxTimer().start(0.4, function(tmr:FlxTimer){
						Actions.Tween(box, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
						Actions.Tween(bgFade, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
						switch (PlayState.SONG.song.toLowerCase()){
							default:
								Actions.Tween(portraitRight, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
								Actions.Tween(portraitLeft, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
							case 'thorns':
								Actions.Tween(face, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
						}
						Actions.Tween(swagDialogue, {alpha: 0}, timerEndPortrait, {ease: FlxEase.cubeOut});
						dropText.alpha = swagDialogue.alpha;
					}, 5);
					new FlxTimer().start(1.475, function(tmr:FlxTimer){
						finishThing();
						kill();
						FlxG.mouse.visible = false;
						Actions.Alpha(PlayState.camNOTE, 1, 0.825, {ease: FlxEase.cubeIn});
						Actions.Alpha(PlayState.camHUD, 1, 0.825, {ease: FlxEase.cubeIn});
						Actions.Alpha(PlayState.laneCamera, (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll), 0.825, {ease: FlxEase.cubeIn});
					});
				}
			}else{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		if (FlxG.keys.justPressed.SPACE){ // Space to skip dialogue
			finishThing();
			kill();
			FlxG.mouse.visible = false;
			new FlxTimer().start(1.05, function(tmr:FlxTimer){
				Actions.Alpha(PlayState.camNOTE, 1, 0.8, {ease: FlxEase.cubeIn});
				Actions.Alpha(PlayState.camHUD, 1, 0.8, {ease: FlxEase.cubeIn});
				Actions.Alpha(PlayState.laneCamera, (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll), 0.8, {ease: FlxEase.cubeIn});
			});
		}
		super.update(elapsed);
	}
	function startDialogue():Void{
		cleanDialog();
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);
		switch (curCharacter){
			case 'bf': getPortrait(true);
			case 'dad': getPortrait(false);
		}
	}
	function portraitDialogue(charPortrait:String, Xpos:Int, Ypos:Int){ // Here You Create Portrait Dialogue
		switch (charPortrait){
			case 'senpai-pixel':
				portraitLeft = new NewSprite(Xpos, Ypos, 'dialogueShits/portraits/pixel/week6Port/senpaiPortrait', 'shared', null, 0, 0, 0, 'enter', ['Senpai Portrait Enter']);
				NewSprite.SpriteComplement.setVariables(portraitLeft, true, TrackMap.daPixelZoom * 0.9);
				add(portraitLeft);
			case 'bf-pixel':
				portraitRight = new NewSprite(Xpos, Ypos, 'dialogueShits/portraits/pixel/week6Port/bfPortrait', 'shared', null, 0, 0, 0, 'enter', ['Boyfriend portrait enter']);
				NewSprite.SpriteComplement.setVariables(portraitRight, true, TrackMap.daPixelZoom * 0.9);
				add(portraitRight);
		}
	}
	function loadSprBox(?boxStyle:String = 'default'){ // Here You Load Box Dialogue in the Styles
		switch (boxStyle){
			case 'default':
				boxSprPath(-100, 375, 200, 200, 'dialogueShits/talkingSprites/speech_bubble_talking', 'shared', ['normalOpen', 'normal'], ['Speech Bubble Normal Open', 'speech bubble normal'], [false, true], [4]);
			case 'senpai-pixel':
				boxSprPath(null, null, null, null, 'dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-pixel', 'shared', ['normalOpen', 'normal'], ['Text Box Appear', 'Text Box Appear'], [false, true], [4]);
			case 'senpai-angry-pixel':
				if (PlayState.death == 0){
					Actions.PlaySound('school/AngryShit_Text_Box', 'maps');
					Actions.PlaySound('school/AngryShit', 'maps');
				}
				if (PlayState.mainDifficulty == 4) PlayState.HealthAction('HealthDrain', 0.5);
				boxSprPath(null, null, null, null, 'dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-senpaiMad', 'shared', ['normalOpen', 'normal'], ['SENPAI ANGRY IMPACT SPEECH', 'SENPAI ANGRY IMPACT SPEECH'], [false, true], [4]);
			case 'spirit-pixel':
				boxSprPath(null, null, null, null, 'dialogueShits/talkingSprites/pixel/week6Talking/dialogueBox-evil', 'shared', ['normalOpen', 'normal'], ['Spirit Textbox spawn', 'Spirit Textbox spawn'], [false, true], [11]);
				face = new NewSprite(320, 170, 'dialogueShits/portraits/pixel/week6Port/spiritFaceForward', 'shared');
				NewSprite.SpriteComplement.setVariables(face, null, TrackMap.daPixelZoom);
				add(face);
		}
	}
	function cleanDialog():Void{
		var splitName:Array<String> = dialogueList[0].split("|");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
	function getPortrait(IsPlayer:Bool, ?showAlpha:Float = 0.315, ?hideAlpha:Float = 0.425){ // Here Place Yours Portrait Codes
		if (IsPlayer){ // Player Portrait Code
			Actions.Tween(portraitLeft, {alpha: 0}, hideAlpha, {ease: FlxEase.cubeOut});
			if (portraitRight.alpha == 0){
				Actions.Tween(portraitRight, {alpha: 1}, showAlpha, {ease: FlxEase.cubeIn});
				portraitRight.animation.play('enter');
			}
		}else{ // Opponent Portrait Code
			Actions.Tween(portraitRight, {alpha: 0}, hideAlpha, {ease: FlxEase.cubeOut});
			if (portraitLeft.alpha == 0){
				Actions.Tween(portraitLeft, {alpha: 1}, showAlpha, {ease: FlxEase.cubeIn});
				portraitLeft.animation.play('enter');
			}
		}
	}
	function boxSprPath(?X:Null<Float>, ?Y:Null<Float>, ?Width:Null<Float>, ?Height:Null<Float>, ?SwitchAtlasPath:Null<String> = null, ?Folder:Null<String> = null, AnimPlay:Array<String>, AnimPath:Array<String>, ?NeedIndices:Array<Bool> = null, ?FrameIndices:Array<Int> = null, ?FrameRate:Int = 24, ?Looped:Bool = false){ // Here You Get Box Dialogue
		if (SwitchAtlasPath != null){
			box.frames = Paths.getSparrowAtlas(SwitchAtlasPath, Folder);
			for (i in 0...NeedIndices.length){
                var playA:String = AnimPlay[i];
                var animN:String = AnimPath[i];
				var bollShit:Bool = NeedIndices[i];
				if (bollShit)
					box.animation.addByIndices(playA, animN, FrameIndices, "", FrameRate);
				else
                	box.animation.addByPrefix(playA, animN, FrameRate, Looped);
            }
			if (Width != null) box.width = Width;
			if (Height != null) box.height = Height;
			if (X != null)	box.x = X;
			if (Y != null) box.y = Y;
		}
	}
	function boxComplement(){
		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * TrackMap.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);
		box.screenCenter(X);
	}
}