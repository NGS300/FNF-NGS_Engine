import Song.SwagSong;
import flixel.addons.effects.FlxTrail;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
class PlayStepEvents /*extends MusicBeatState*/{ // <-- Any Bug Active This
	public static var publicStep = 0; // To Use Any State
    public static var bfThornsTrail:FlxTrail; 
    public static var transcendsTrail:FlxTrail;
    public static var bfSpinTrail:FlxTrail;
	public static var skyBitch:Int = 0;
	public static var bgSos:Int = 0;
    public static function startCountdownEvents(Track:String, opponent:Character, gf:Character, bf:Boyfriend){
        switch (Track){
			case 'Thorns':
				bfThornsTrail = new FlxTrail(bf, null, 4, 24, 0.3, 0.069);
			case 'Guns':
				bfSpinTrail = new FlxTrail(bf, null, 8, 10, 0.425, 0.1105);
				transcendsTrail = new FlxTrail(opponent, null, 4, 24, 0.425, 0.1105);
		}
    }
    public static function stepEvents(create:Dynamic, remove:Dynamic, Track:String, trackLower:String, opponent:Character, gf:Character, bf:Boyfriend, healthBar:FlxBar, step:Int, beat:Int, SONG:SwagSong, diff:Int, danceIcons:Bool, camZooming:Bool, gfDanceSpeed:Int, iconP1:HealthIcon, iconP2:HealthIcon, camHUD:FlxCamera, camNOTE:FlxCamera, laneCamera:FlxCamera, playerStrums:FlxTypedGroup<FlxSprite>, opponentStrums:FlxTypedGroup<FlxSprite>, strumLineNotes:FlxTypedGroup<FlxSprite>, notes:FlxTypedGroup<Note>, paused:Bool){
		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20) PlayState.instance.resyncVocals();
		DiscordClient.globalPresence('PlayStepEvents');
		publicStep = step;
        switch (Track){
			case 'Bopeebo': switch (step){
					case 190 | 446: 
						Actions.PlayCharAnim(bf, 'hey', true);
						Actions.PlayCharAnim(gf, 'cheer', true);
				}
            case 'Spookeez': switch (step){
					case 188 | 444: 
						Actions.PlayCharAnim(bf, 'hey', true);
						Actions.PlayCharAnim(gf, 'cheer', true);
				}
			case 'Cocoa':
				if (opponent.curCharacter == 'parents' && FlxG.save.data.colourCharIcon){
					switch (step){
						case 130 | 385 | 576: Actions.changeBarColor(healthBar, 0xFFd8558e, bf.healthBarColor); // Mom Turn
						case 260 | 512: Actions.changeBarColor(healthBar, 0xFFaf66ce, bf.healthBarColor); // Dad Turn
					}
				}
			case 'Eggnog':
				if (opponent.curCharacter == 'parents' && FlxG.save.data.colourCharIcon){
					switch (step){
						case 160 | 416 | 608 | 864: Actions.changeBarColor(healthBar, 0xFFd8558e, bf.healthBarColor); // Mom Turn
						case 290 | 482 | 738: Actions.changeBarColor(healthBar, 0xFFaf66ce, bf.healthBarColor); // Dad Turn
					}
				}
			case 'Ugh':
				if (opponent.curCharacter == 'tankmanCaptain'){
					switch (step){
						case 60 | 444 | 524 | 540 | 541 | 828:
							Camera.PlayStateZoom(0.3325);
						case 59 | 443 | 523 | 539 | 827: // Set UGH Anim
							Actions.CharMiniEvent(true, true, true, bf);
							Actions.SwitchCharAnimOffset(opponent, true, 'actionLEFT', 'ugh', -13, -8, false);
						case 64 | 448 | 528 | 542 | 832: // Set Default Anim
							Actions.CharMiniEvent(false, true, false, bf);
							Actions.SwitchCharAnimOffset(opponent, true, 'actionLEFT', 'oldActionLEFT', 86, -13, false);
					}
				}
			case 'Guns':
				if (FlxG.save.data.visualDistractions && FlxG.save.data.visualEffects && diff >= 2){
					var colorTween:FlxTween;
					var curColor:Int;
					function ColorSwitch(spriteShit:FlxSprite, placeYouColor:Int = 0xFF8a2be2, ?duration:Float = 1){
						if (placeYouColor != curColor){
							if (colorTween != null)
								colorTween.cancel();
							curColor = placeYouColor;
							colorTween = FlxTween.color(spriteShit, duration, spriteShit.color, placeYouColor,{
								onComplete: function(twn:FlxTween){
									colorTween = null;
								}
							});
						}
					}
					var colorTween2:FlxTween;
					var curColor2:Int;
					function ColorSwitch2(spriteShit:FlxSprite, placeYouColor:Int = 0xFF8a2be2, ?duration:Float = 1){
						if (placeYouColor != curColor2){
							if (colorTween2 != null)
								colorTween2.cancel();
							curColor2 = placeYouColor;
							colorTween2 = FlxTween.color(spriteShit, duration, spriteShit.color, placeYouColor,{
								onComplete: function(twn:FlxTween){
									colorTween2 = null;
								}
							});
						}
					}
					if (FlxG.save.data.flashingLightVisual){
						if (step % 16 == 0){
							if (step >= 896 && step < 1664){
								skyBitch = FlxG.random.int(0, TrackMap.spaceGuns.length - 1);
								bgSos = FlxG.random.int(0, TrackMap.spaceGuns.length - 1);
							}
							var timer:Float = 1;
							if (step >= 896 && step < 1664)
								ColorSwitch(TrackMap.sky, TrackMap.spaceGuns[skyBitch], timer);
							if (step >= 896 && step < 1152)
								ColorSwitch2(TrackMap.bgSpace, TrackMap.spaceGuns[bgSos], timer);
						}
					}
					switch (step){
						case 896:
							Camera.PlayStateZoom(0.1);
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1.25}, 10, {ease: FlxEase.elasticInOut});	
							var timerMove:Float = 19;
							Actions.Flash(camHUD, FlxColor.WHITE, 4.25);
							Actions.Alpha(TrackMap.bgSpace, 0.6, 5, {ease: FlxEase.cubeOut});
							Actions.TweenYObject(opponent, -2000, timerMove, {ease: FlxEase.cubeOut});
							Actions.TweenYObject(gf, -2100, timerMove, {ease: FlxEase.cubeOut});
							Actions.TweenYObject(bf, -1836, timerMove, {ease: FlxEase.cubeOut});
							Actions.TweenYObject(TrackMap.bgSpace, -2225, 18, {ease: FlxEase.cubeOut});
							Actions.Angle(bf, null, 360, 10.625,  {ease: FlxEase.cubeInOut});
							Actions.Angle(gf, null, -360, 10.325,  {ease: FlxEase.cubeInOut});
							//Actions.PlayCharAnim(bf, 'wow', true);
						case 900:
							if (FlxG.save.data.visualDistractions) create(bfSpinTrail);
						case 1012:
							if (FlxG.save.data.visualDistractions) remove(bfSpinTrail);
						case 1024:
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1}, 1.05, {ease: FlxEase.elasticInOut});
						case 1150:
							Actions.TweenYObject(opponent, 325, 5, {ease: FlxEase.cubeOut});
							Actions.TweenYObject(gf, 75, 4.5, {ease: FlxEase.cubeOut});
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: .9}, 0.25, {ease: FlxEase.elasticInOut});
						case 1213:
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1.25}, 5, {ease: FlxEase.elasticInOut});
						case 1220:
							if (FlxG.save.data.visualDistractions) TrackMap.bgSpace.destroy();
						case 1246:
							Actions.TweenYObject(bf, 460, 4, {ease: FlxEase.cubeOut});
						case 1180:
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1}, 1, {ease: FlxEase.elasticInOut});
						case 1341:
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1.3}, 5, {ease: FlxEase.elasticInOut});
						case 1408:
							if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 0.9}, 1, {ease: FlxEase.elasticInOut});
						case 1529:
							if (FlxG.save.data.visualEffects && diff >= 3){
								Actions.Tween(FlxG.camera, {angle: 360}, 0.725, {ease: FlxEase.elasticInOut});
								Actions.Tween(camNOTE, {angle: 360}, 0.725, {ease: FlxEase.elasticInOut});
								Actions.Tween(camHUD, {angle: 360}, 0.725, {ease: FlxEase.elasticInOut});
								Actions.SetAngleScroll(playerStrums, null, 360, 0.725, {ease: FlxEase.elasticInOut});
							}
							case 1536:
								if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1.3}, 10, {ease: FlxEase.elasticInOut});
							case 1666:
								if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: .765}, 3, {ease: FlxEase.cubeOut});
						}
						if (step >= 1152 && step < 1408)
							if (step % 4 == 0)
								Camera.PlayStateZoom(0.045);
						if (step >= 1536 && step < 1663)
							if (step % 4 == 0)
								Camera.PlayStateZoom(0.045);
						if (step >= 1410 && step < 1528)
							if (step % 15 == 0)
								Camera.PlayStateZoom(0.0525);
						if (step >= 256 && step < 475)
							if (step % 12 == 0)
								Camera.PlayStateZoom(0.0435);
				}
			case 'Stress':
				if (FlxG.save.data.map && FlxG.save.data.visualDistractions){
					JohnRunnerBG.picoShot(true);
					JohnRunnerBG.picoShot(false);
					JohnRunnerBG.johnSpawn();
				}
				if (diff >= 2){
					if (opponent.curCharacter == 'tankmanCaptain'){
						switch (step){
							case 128:
								Actions.Flash(camHUD, FlxColor.WHITE, 1);
							case 156 | 157 | 158 | 796 | 797 | 798 | 812 | 813 | 814:
								Camera.PlayStateZoom(0.075);
							case 626:
								if (FlxG.save.data.visualDistractions){
									Actions.GlobalModify(null, false);
									iconP1.angle = 0;
									iconP2.angle = 0;
								}
							case 624 | 628 | 632 | 634:
								Camera.PlayStateZoom(0.04325);
							case 636 | 638:
								Camera.PlayStateZoom(0.03925);
							case 735: // Set Pretty Good Anim
								Actions.CharMiniEvent(true, true, true, bf);
								Actions.SwitchCharAnimOffset(opponent, true, 'actionUP', 'prettyGood', 2, 15, true);
								if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 1.4}, 3, {ease: FlxEase.cubeOut});
							case 736 | 737: // Play Pretty Good Anim
								Actions.PlayCharAnim(opponent, 'prettyGood', true);
							case 768: // Set Default Anim
								Actions.CharMiniEvent(false, true, false, bf);
								Actions.SwitchCharAnimOffset(opponent, false, 'actionUP', 'oldActionUP', 45, 45, false);
								if (FlxG.save.data.camerazoom) Actions.Tween(FlxG.camera, {zoom: 0.9}, 1.125, {ease: FlxEase.elasticInOut});
							case 1264:
								if (FlxG.save.data.visualDistractions){
									Actions.GlobalModify(null, false);
									iconP1.angle = 0;
									iconP2.angle = 0;
								}
						}
					}
				}else if (diff < 2){
					if (opponent.curCharacter == 'tankmanCaptain'){
						switch (step){
							case 735: // Set Pretty Good Anim
								Actions.CharMiniEvent(true, true, true, bf);
								Actions.SwitchCharAnimOffset(opponent, true, 'actionUP', 'prettyGood', 2, 15, true);
							case 736 | 737: // Play Pretty Good Anim
								Actions.PlayCharAnim(opponent, 'prettyGood', true);
							case 768: // Set Default Anim
								Actions.CharMiniEvent(false, true, false, bf);
								Actions.SwitchCharAnimOffset(opponent, false, 'actionUP', 'oldActionUP', 45, 45, false);
						}
					}
				}
		}
    }
}