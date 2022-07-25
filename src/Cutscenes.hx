import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.FlxG;
import Song.SwagSong;
import flixel.FlxSprite;
class Cutscenes extends MusicBeatState{
	public static var senpaiEvil:FlxSprite;
    public static var black:FlxSprite;
    public static var red:FlxSprite;
	public static var cutsceneBooler:Bool = true; // need make options to disabled and enable
    public static function startTrackCutscene(StateShit:String, curTrack:String, startCountdown:Dynamic, inCutScene:Bool, add:Dynamic, remove:Dynamic, SONG:SwagSong, log:DialogueBox, camHUD:FlxCamera, camNOTE:FlxCamera, laneCamera:FlxCamera, camFollow:FlxObject, death:Int, diff:Int){
        switch (StateShit){
			case 'StoryMode': switch (curTrack.toLowerCase()){
					default: startCountdown();
					case "winter-horrorland": getCene('hlStart', null, add, remove, null, startCountdown, camFollow, camHUD, camNOTE, laneCamera, death, diff);
                    case 'senpai' | 'roses' | 'thorns': getDialogue(log, add, remove, startCountdown, camNOTE, camHUD, laneCamera, inCutScene, SONG, death, diff);
					case 'guns' | 'stress': getCene('wk7Cn', null, null, null, SONG);
				}
			case 'Freeplay': switch (curTrack.toLowerCase()){
					default: startCountdown();
				}
			case 'Secret': switch (curTrack.toLowerCase()){
					default: startCountdown();
				}
		}
    }
	public static function endTrackCutscenes(StateShit:String, ?SubStateShit:String = null, curTrack:String, create:Dynamic, remove:Dynamic, camFollow:FlxObject, camHUD:FlxCamera, camNOTE:FlxCamera, laneCamera:FlxCamera, death:Int, diff:Int){
		switch (StateShit){
			case 'StoryMode': switch (SubStateShit){
				case 'End': switch (curTrack.toLowerCase()){
					default: trace('Back to StoryMenu');
						Actions.States('Switch', new StoryMenuState());
				}
				case 'FinalTrack': switch (curTrack.toLowerCase()){
					default: Actions.States('LoadSwitch', new PlayState());
           			case 'eggnog': getCene('eggEnd', null, create, null, null, null, camFollow, camHUD, camNOTE, laneCamera, null, diff);
				}
			}
			case 'Freeplay': switch (curTrack.toLowerCase()){
				default: trace('Back to Freeplay');
					Actions.States('Switch', new FreeplayState());
					Actions.PlayTrack(MainMenuState.EngineFreakyMenu);
			}
			case 'Secret': switch (curTrack.toLowerCase()){
				default: trace('Back to Console');
					Actions.States('Switch', new ConsoleCodeState());
					Actions.PlayTrack(MainMenuState.EngineFreakyMenu);
			}
		}
	}
    public static function getDialogue(?logBox:DialogueBox, add:Dynamic, remove:Dynamic, startCountdown:Dynamic, camNOTE:FlxCamera, camHUD:FlxCamera, laneCamera:FlxCamera, inCutscene:Bool, SONG:SwagSong, death:Int, diff:Int):Void{
		if (diff >= 2 && death == 0 && cutsceneBooler){
			black = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFF000000);
			black.scrollFactor.set();
			add(black);
			getCene('thrnsEvSpr', null, add, remove, SONG);
			new FlxTimer().start(0.3, function(tmr:FlxTimer){
				camNOTE.alpha = 0;
				camHUD.alpha = 0;
				if (Client.Public.mid && FlxG.save.data.laneScroll) laneCamera.alpha = 0;
				black.alpha -= 0.15;
				if (black.alpha > 0)
					tmr.reset(0.3);
				else{
					if (logBox != null){
						inCutscene = true;
						if (SONG.song.toLowerCase() == 'thorns')
							getCene('thrnsEvStart', logBox, add, remove, SONG);
						else{
							FlxG.mouse.visible = true;
							add(logBox);
						}
					}else
						startCountdown();
					remove(black);
				}
			});
		}else
			startCountdown();
	}
	public static function getCene(localtion:String, ?logBox:Null<DialogueBox> = null, ?add:Null<Dynamic> = null, ?remove:Null<Dynamic> = null, ?SONG:Null<SwagSong> = null, ?startCountdown:Null<Dynamic> = null, ?camFollow:Null<FlxObject> = null, ?camHUD:Null<FlxCamera>, ?camNOTE:Null<FlxCamera> = null, ?laneCamera:Null<FlxCamera> = null, ?death:Null<Int> = null, ?diff:Null<Int> = null){
		switch (localtion){
			case 'wk7Cn': // Week 7 Cutcenes
				if (SONG.song.toLowerCase() == 'guns')
					Actions.PlayVidCene(true, true, 'Week7Cutcene/gunsCutscene');
				else if (SONG.song.toLowerCase() == 'stress')
					Actions.PlayVidCene(true, true, 'Week7Cutcene/stressCutscene');
			case 'thrnsEvSpr': // Get Thorns Sprites
				if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns'){
					remove(black);
					if (SONG.song.toLowerCase() == 'thorns'){
						red = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
						red.scrollFactor.set();
						add(red);
						senpaiEvil = new NewSprite(0, 0, 'cutcene/pixel/Senpai_Death', 'shared', null, 1, 0, 0, 'transform', ['Senpai Death Explosion']);
						NewSprite.SpriteComplement.setVariables(senpaiEvil, true, TrackMap.daPixelZoom, null, null, null, null, null, true);
					}
				}
			case 'eggEnd': // Eggnog End
				if (diff >= 2 && cutsceneBooler){
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;
					camNOTE.visible = false;
					laneCamera.visible = false;
					Actions.PlaySound('mallEvil/lightsShutOff', 'maps', 1, false, null, true, function(){
						Actions.States('LoadSwitch', new PlayState());
					});
				}else
					Actions.States('LoadSwitch', new PlayState());
			case 'thrnsEvStart': // Thorns Senpai Start Transform
				add(senpaiEvil);
				senpaiEvil.alpha = 0;
				new FlxTimer().start(0.3, function(swagTimer:FlxTimer){
					senpaiEvil.alpha += 0.15;
					if (senpaiEvil.alpha < 1)
						swagTimer.reset();	
					else{
						senpaiEvil.animation.play('transform');
						Actions.PlaySound('school/Senpai_Exploded', 'maps', 1, false, null, true, function(){
							remove(senpaiEvil);
							remove(red);
							Actions.Fade(FlxG.camera, FlxColor.WHITE, 0.01, true, function(){
								FlxG.mouse.visible = true;
								add(logBox);
							}, true);
						});
						new FlxTimer().start(3.2, function(deadTime:FlxTimer){
							Actions.Fade(FlxG.camera, FlxColor.WHITE, 1.6, false);
						});
					}
				});
			case 'hlStart': // Horror Land Start
				if (diff >= 2 && death == 0 && cutsceneBooler){
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;
					camHUD.alpha = 0;
					camNOTE.visible = false;
					camNOTE.alpha = 0;
					laneCamera.visible = false;
					laneCamera.alpha = 0;
					new FlxTimer().start(0.1, function(tmr:FlxTimer){
						remove(blackScreen);
						Actions.PlaySound('mallEvil/lightsTurnOn', 'maps');
						camFollow.x += 200;
						camFollow.y = -2050;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;
						new FlxTimer().start(0.8, function(tmr:FlxTimer){
							camHUD.visible = true;
							Actions.Alpha(camHUD, 1, 1, {ease: FlxEase.cubeOut});
							camNOTE.visible = true;
							Actions.Alpha(camNOTE, 1, 1, {ease: FlxEase.cubeOut});
							laneCamera.visible = true;
							Actions.Alpha(laneCamera, (Options.Option.JsonOptions.laneTransparencyScroll != null ? Options.Option.JsonOptions.laneTransparencyScroll : FlxG.save.data.laneTransparencyScroll), 1, {ease: FlxEase.cubeOut});
							remove(blackScreen);
							Actions.Tween(FlxG.camera, {zoom: TrackMap.camZoom}, 2.5, {ease: FlxEase.quadInOut, onComplete: function(twn:FlxTween){
									startCountdown();
								}
							});
						});
					});
				}else
					startCountdown();
		}
	}
}