import flixel.ui.FlxBar;
import flixel.addons.ui.StrNameLabel;
import flixel.system.FlxSoundGroup;
import flixel.FlxState;
import flixel.util.FlxTimer;
import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxAxes;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.FlxObject;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import vlc.MP4Handler;
class Actions{
	public static var iconEventOpponent:Bool = false;
	public static var iconEventPlayer:Bool = false;
	public static function ChangeCameraPlayer(Player:Bool){ // I do not know
		PlayState.SONG.notes[Std.int(PlayStepEvents.publicStep / 16)].mustHitSection = Player;
	}
	public static function PlaySprMapAnim(?Sprite:Null<FlxSprite>, AnimN:String, ?Force:Bool = false, ?Reversed:Bool = false, ?FrameNum:Int = 0){
		if (Client.Public.map) Sprite.animation.play(AnimN, Force, Reversed, FrameNum);
	}
	public static function PlaySprAnim(?Sprite:Null<FlxSprite>, AnimN:String, ?Force:Bool = false, ?Reversed:Bool = false, ?FrameNum:Int = 0){
		Sprite.animation.play(AnimN, Force, Reversed, FrameNum);
	}
	public static function PlayTrack(TrackPath:String, ?Folder:Null<String>, ?Volume:Float = 1, ?Loop:Bool = true, ?Group:FlxSoundGroup){
		FlxG.sound.playMusic(Paths.music(TrackPath, Folder), Volume, Loop, Group);
	}
    public static function PlaySound(SoundPath:String, ?Folder:Null<String>, ?Volume:Float = 1, ?Loop:Bool = false, ?Group:FlxSoundGroup, AutoDestroy:Bool = true, ?OnComplete:Void->Void){
        FlxG.sound.play(Paths.sound(SoundPath, Folder), Volume, Loop, Group, AutoDestroy, OnComplete);
    }
	public static function PlayRandomSound(SoundPath:String, Min:Int, Max:Int, ?Folder:Null<String>, ?Volume:Float = 1, ?Loop:Bool = false, ?Group:FlxSoundGroup, AutoDestroy:Bool = true, ?OnComplete:Void->Void){
        FlxG.sound.play(Paths.soundRandom(SoundPath, Min, Max, Folder), Volume, Loop, Group, AutoDestroy, OnComplete);
    }
	public static function SetCharAnimOffset(Char:Character, AnimName:String, OffsetX:Null<Int>, OffsetY:Null<Int>){
		Char.addOffset(AnimName, OffsetX, OffsetY); // AddNewOffset of Char in Chart
	}
	public static function Flash(Cam:FlxCamera, ?Color:FlxColor = FlxColor.WHITE, ?Duration:Float = 0.5, ?OnComplete:Void->Void, ?Force:Bool = true):Void{
		if (FlxG.save.data.flashingLightVisual) Cam.flash(Color, Duration, OnComplete, Force); // Set Flash Color
	}
	public static function Fade(Cam:FlxCamera, ?Color:FlxColor = FlxColor.WHITE, ?Duration:Float = 0.5, ?FadeIn:Bool = false, ?OnComplete:Void->Void, ?Force:Bool = true):Void{
		if (FlxG.save.data.flashingLightVisual) Cam.fade(Color, Duration, FadeIn, OnComplete, Force); // Set Flash Color
	}	
	public static function Shake(Cam:FlxCamera, ?Intensity:Float = 0.025, ?Duration:Float = 0.05, ?OnComplete:Void->Void, ?Force:Bool = true, ?Axes:FlxAxes):Void{
		if (FlxG.save.data.shakeEffects) Cam.shake(Intensity, Duration, OnComplete, Force, Axes); // Just Facking Shaking Bro
	}
	public static function Tween(Object:Dynamic, Values:Dynamic, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, Values, Duration, Options); // Make Action Object, Example Any Action Object :P
	}
	public static function Alpha(?Object:Dynamic, ToAlpha:Float, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {alpha: ToAlpha}, Duration, Options); // Make Alpha Object, Example Place Alpha Object :P
	}
	public static function Angle(Sprite:FlxSprite, FromAngle:Null<Float>, ToAngle:Null<Float>, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{
		FlxTween.angle(Sprite, FromAngle, ToAngle, Duration, Options); // Make Angle Object, Example Rotation Object
	}
	public static function CircularMotion(Object:FlxObject, CenterX:Float, CenterY:Float, Radius:Float, Angle:Float, Clockwise:Bool, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:Null<TweenOptions>):Void{
		FlxTween.circularMotion(Object, CenterX, CenterY, Radius, Angle, Clockwise, DurationOrSpeed, UseDuration, Options); // Make Center Motion
	}
	public static function TweenColor(?Sprite:FlxSprite, FromColor:FlxColor, ToColor:FlxColor, ?Duration:Float = 1, ?Options:Null<TweenOptions>){
		FlxTween.color(Sprite, Duration, FromColor, ToColor, Options); // Make Color Switch
	}
	public static function StopTween(Object:Dynamic, ?FieldPaths:Array<String>){
		FlxTween.cancelTweensOf(Object, FieldPaths); // Cancel Any Tween
	}
	public static function CubicMotion(Object:FlxObject, FromX:Float, FromY:Float, Ax:Float, Ay:Float, Bx:Float, By:Float, ToX:Float, ToY:Float, Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		FlxTween.cubicMotion(Object, FromX, FromY, Ax, Ay, Bx, By, ToX, ToY, Duration, Options); // Make Cubic Motion
	}
	public static function LinearMotion(Object:FlxObject, FromX:Float, FromY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:Null<TweenOptions>):Void{
		FlxTween.linearMotion(Object, FromX, FromY, ToX, ToY, DurationOrSpeed, UseDuration, Options); // Make Action Linear Motion
	}
	public static function LinearPath(Object:FlxObject, Points:Array<FlxPoint>, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:Null<TweenOptions>):Void{
		FlxTween.linearPath(Object, Points, DurationOrSpeed, UseDuration, Options); // Make Action Linear Path
	}
	public static function Num(FromValue:Float, ToValue:Float, Duration:Float = 1, ?Options:Null<TweenOptions>, ?TweenFunction:Float -> Void){
		FlxTween.num(FromValue, ToValue, Duration, Options, TweenFunction); // Make Action Num
	}
	public static function QuadMotion(Object:FlxObject, FromX:Float, FromY:Float, ControlX:Float, ControlY:Float, ToX:Float, ToY:Float, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:Null<TweenOptions>):Void{
		FlxTween.quadMotion(Object, FromX, FromY, ControlX, ControlY, ToX, ToY, DurationOrSpeed, UseDuration, Options); // Make Action Quad Motion
	}
	public static function QuadPath(Object:FlxObject, Points:Array<FlxPoint>, DurationOrSpeed:Float = 1, UseDuration:Bool = true, ?Options:Null<TweenOptions>):Void{
		FlxTween.quadPath(Object, Points, DurationOrSpeed, UseDuration, Options); // Make Action Quad Path
	}
	public static function SetPosObject(Object:Dynamic, IsXPos:Null<Int>, IsYPos:Null<Int>, ?Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {x: IsXPos, y: IsYPos}, Duration, Options); // Make Action, Move Position Object
	}
	public static function TweenXObject(Object:Dynamic, IsXPos:Int, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {x: IsXPos}, Duration, Options); // Make Action X Object
	}
	public static function TweenYObject(Object:Dynamic, IsYPos:Int, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(Object, {y: IsYPos}, Duration, Options); // Make Action Y Object
	}
	public static function TweenXStrum(StrumName:Dynamic, Num:Int, IsXPos:Int, ?Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(StrumName.members[Num], {x: StrumName.members[Num].x + IsXPos}, Duration, Options); // Make Action X Strum Members
	}
	public static function TweenYStrum(StrumName:Dynamic, Num:Int, IsYPos:Float, ?Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(StrumName.members[Num], {y: StrumName.members[Num].y + IsYPos}, Duration, Options); // Make Action Y Strum Members
	}
	public static function TweenPosStrum(StrumName:Dynamic, Num:Int, IsXPos:Null<Int>, IsYPos:Null<Int>, ?Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(StrumName.members[Num], {x: StrumName.members[Num].x + IsXPos, y: StrumName.members[Num].y + IsYPos}, Duration, Options); // Make Action X & Y Strum Members
	}
	public static function SetAlphaStrum(StrumName:FlxTypedGroup<FlxSprite>, Num:Int, ToAlpha:Float, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{
		FlxTween.tween(StrumName.members[Num], {alpha: ToAlpha}, Duration, Options); // Make Action Alpha Strum Members
	}
	public static function SetAngleStrum(StrumName:FlxTypedGroup<FlxSprite>, Num:Int, FromAngle:Null<Float>, ToAngle:Null<Float>, ?Duration:Float, ?Options:Null<TweenOptions>):Void{
		FlxTween.angle(StrumName.members[Num], FromAngle, ToAngle, Duration, Options); // Make Action Angle Strum Members
	}
	public function GetFrames(Sprite:FlxSprite, ImagePath:String, ?Library:Null<String> = null, ?IsPackerAtlas:Bool = false){
		Sprite.frames = (IsPackerAtlas ? Paths.getPackerAtlas(ImagePath, Library) : Paths.getSparrowAtlas(ImagePath, Library));
	}
	public static function FadeTrack(FadeIn:Bool, ?Duration:Float = 1, ?From:Float = 0, ?To:Null<Float> = 1, ?OnComplete:FlxTween->Void){
		(!FadeIn ? FlxG.sound.music.fadeOut(Duration, To, OnComplete) : FlxG.sound.music.fadeIn(Duration, From, To, OnComplete));
	}
	public static function PlayInst(?IsInst:Bool = true, ?Path:String = null, ?Volume:Float = 1, ?Looped:Bool = false){
		(!IsInst ? Paths.voices((Path != null ? Path : PlayState.SONG.song)) : FlxG.sound.playMusic(Paths.inst(((Path != null ? Path : PlayState.SONG.song))), Volume, Looped));
	}
	public static function PlayCharAnim(Char:Character, ?PlayAnimN:Null<String> = null, ?Force:Bool = false, ?Reversed:Bool = false, ?FrameNum:Int = 0, ?checkExist:Bool = false, ?notify:Bool = false, ?customErro:String = null):Void{
		if (FlxG.save.data.map){
			if (checkExist){
				if (Char.animation.exists(PlayAnimN))
					Char.playAnim(PlayAnimN, Force, Reversed, FrameNum)
				else if (notify)
					throw Char.curCharacter.toUpperCase() + (customErro != null ? customErro : ' Called $PlayAnimN But It Was Not Found.');
			}else
				(PlayAnimN == null ? Char.dance() : Char.playAnim(PlayAnimN, Force, Reversed, FrameNum));
		}
	}
	public static function changeBarColor(bar:FlxBar, LeftColor:FlxColor, RightColor:FlxColor, ?AutoBarUpdate:Bool = true, ?ShowBorder:Bool = false, ?Border:FlxColor = FlxColor.WHITE){
		if (bar.exists){
			bar.createFilledBar(LeftColor, RightColor, ShowBorder, Border);
			if (AutoBarUpdate) bar.updateBar();
		}else
			throw 'Called Bar Not Found!';
	}
	public static function SetAlphaScroll(StrumName:FlxTypedGroup<FlxSprite>, ToAlpha:Float, ?Duration:Float = 0.725, ?Options:Null<TweenOptions>):Void{
		StrumName.forEach(function(Scroll:FlxSprite){
			Tween(Scroll, {alpha: ToAlpha}, Duration, Options); // Make Action Scroll Alpha
		});
	}
	public static function SetPosScroll(StrumName:FlxTypedGroup<FlxSprite>, IsXPos:Null<Int>, IsYPos:Null<Int>, ?NewLocation:Bool = false, ?IsNegative:Bool = false, ?Duration:Float = 1, ?Options:Null<TweenOptions>):Void{
		StrumName.forEach(function(Scroll:FlxSprite){
			Tween(Scroll, {x: (IsXPos == null ? null : (NewLocation ? IsXPos : (IsNegative ? Scroll.x -= IsXPos : Scroll.x += IsXPos))), y: (IsYPos == null ? null : (NewLocation ? IsYPos : (IsNegative ? Scroll.y -= IsYPos : Scroll.y += IsYPos)))}, Duration, Options); // Make Action Scroll Position
		});
	}
	public static function SetAngleScroll(StrumName:FlxTypedGroup<FlxSprite>, FromAngle:Null<Float>, ToAngle:Null<Float>, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{
		StrumName.forEach(function(Scroll:FlxSprite){
			Angle(Scroll, FromAngle, ToAngle, Duration, Options); // Make Action Scroll Angle
		});
	}
	public static function CharMiniEvent(Icon:Bool, ?IsOpponent:Bool = true, ?BoolerSex:Bool, ?Char:Character){
		if (IsOpponent)
			iconEventOpponent = Icon;
		else 
			iconEventPlayer = Icon;
		if (Char != null) Char.inExcited = BoolerSex;
	}
	public static function FlipSprite(Item:FlxSprite, DiretionFlip:Bool, Fliped:Bool):Void{
		if (DiretionFlip)
			Item.flipX = Fliped;
		else
			Item.flipY = Fliped;
	}
	public static function OpenLink(Link:String){
		#if linux
			Sys.command('/usr/bin/xdg-open', [Link, "&"]);
		#else
			FlxG.openURL(Link);
		#end
	}
	public static function SetCharPos(Char:Character, ?Px:Null<Int> = null, ?Py:Int = null, ?OriginalSet:Bool = false):Void{  // Set Character Positions
		if (OriginalSet){
			if (Px != null) Char.x = Px;
			if (Py != null) Char.y = Py;
		}else{
			if (Px != null || Px != 0) Char.x += Px;
			if (Py != null || Py != 0) Char.y += Py;
		}
	}
	public static function States(GetType:String, ?State:FlxState, ?StopMusic = false){
		switch (GetType){
			case 'Reset': FlxG.resetState();
			case 'Switch': FlxG.switchState(State);
			case 'LoadSwitch': LoadingState.loadAndSwitchState(State, StopMusic);
		}
	}
	public static function AddAnim(Sprite:FlxSprite, AnimName:String, ?FramePath:Null<String> = null, ?FrameIndice:Array<Int> = null, ?FrameRate:Int = 24, ?Looped:Bool = false, ?FlipX:Bool = false, ?FlipY:Bool = false){ // to Add Character Frames
		if (FramePath == null)
			Sprite.animation.add(AnimName, FrameIndice, FrameRate, Looped, FlipX, FlipY);
		else{
			if (FrameIndice != null)
				Sprite.animation.addByIndices(AnimName, FramePath, FrameIndice, "", FrameRate, Looped, FlipX, FlipY);
			else
				Sprite.animation.addByPrefix(AnimName, FramePath, FrameRate, Looped, FlipX, FlipY);
		}
	}
	public static function makeStringIntList(?LimitToArray:Int = null, StringArray:Array<String>, UseIndexID:Bool = false):Array<StrNameLabel>{
		var strIdArray:Array<StrNameLabel> = [];
		for (i in 0...(LimitToArray != null ? LimitToArray : StringArray.length)){
			var ID:String = StringArray[i];
			if (UseIndexID) ID = Std.string(i);
			strIdArray[i] = new StrNameLabel(ID, StringArray[i]);
		}
		return strIdArray;
	}
	public static function PlayVidCene(IsDefaultDiretoryPush:Bool, InPlayState:Bool, VidName:String, ?Library:Null<String> = null, ?StopMusic:Bool = false){
		if (InPlayState){
			if (PlayState.death == 0 && PlayState.mainDifficulty >= 2 && Cutscenes.cutsceneBooler){
				PlayState.inCutscene = true;
				FlxG.mouse.visible = false;
				var video:MP4Handler = new MP4Handler();
				if (IsDefaultDiretoryPush)
					video.playVideo(Paths.videoMP4(VidName, Library));
				else
					video.playVideo(Paths.videoMP4Any(VidName, Library));
				video.finishCallback = function(){
					PlayState.instance.startCountdown();
				}
			}else
				PlayState.instance.startCountdown();
		}else{
			if (StoryMenuState.instance.curDiffcultyWeek >= 2 && Cutscenes.cutsceneBooler){
				FlxG.mouse.visible = false;
				if (StopMusic) FlxG.sound.music.stop();
				var video:MP4Handler = new MP4Handler();
				if (IsDefaultDiretoryPush)
					video.playVideo(Paths.videoMP4(VidName, Library));
				else
					video.playVideo(Paths.videoMP4Any(VidName, Library));
				video.finishCallback = function(){
					States('LoadSwitch', new PlayState(), StopMusic);
				}
			}else
				States('LoadSwitch', new PlayState(), StopMusic);
		}
	}
	public function TweenEffect(Object:Dynamic, TweenDynamic:Dynamic, ?Zoom:Null<Float> = null, ?Angle:Null<Float> = null, ?Alpha:Null<Float> = 1, ?OriginalPos:Null<Bool> = false, Px:Null<Float> = null, Py:Null<Float> = null, ?Duration:Float = 0.5, ?Options:Null<TweenOptions>):Void{ // Yep is Effect :D
		if (PlayState.ObjectTween != null) PlayState.ObjectTween.cancel();
		if (Zoom != null) {if (FlxG.save.data.camerazoom) Object.zoom = Zoom;}
		if (Angle != null) Object.angle = Angle;
		if (Alpha != null) Object.alpha = Alpha;
		if (OriginalPos != null){
			if (OriginalPos){
				Object.x = Px;
				Object.y = Py;
			}else{
				Object.x += Px;
				Object.y += Py;
			}
		}
		PlayState.ObjectTween = FlxTween.tween(Object, TweenDynamic, Duration, Options);
	}
    public static function SwitchCharAnimOffset(Char:Character, NewOffset:Bool = true, AnimationName:String, PlayNewAnim:String, OffsetX:Null<Int>, OffsetY:Null<Int>, ?Force:Bool = false){
		if (NewOffset){
			Char.addOffset(AnimationName, OffsetX, OffsetY);
			Char.animation.getByName(AnimationName).frames = Char.animation.getByName(PlayNewAnim).frames;
			if (Force) PlayCharAnim(Char, PlayNewAnim, Force);
		}else{
			Char.addOffset(AnimationName, OffsetX, OffsetY);
			Char.animation.getByName(AnimationName).frames = Char.animation.getByName(PlayNewAnim).frames;
			if (Force) PlayCharAnim(Char, PlayNewAnim, Force);
		}
	}
	public static function LoadTrackChart(TrackNmDiff:String, ?Folder:Null<String> = null, ?Diff:Int = 1, ?StoryWeek:Int = 0, ?TimerChangeState:Float = 0.5, ?CurState:String = 'Secret', ?Transition:Bool = false, ?FadeCam:Bool = false, ?TimeFade:Float = 0.3, ?Color:FlxColor = FlxColor.WHITE, ?FadeIn:Bool = false, ?OnComplete:Void -> Void, ?Force:Bool = false){
        PlayState.SONG = Song.loadFromJson(TrackNmDiff + CoolUtil.difficultyData(Diff), Folder);
        PlayState.mainDifficulty = Diff;
        StoryMenuState.storyWeek = StoryWeek;
        PlaySound('confirmMenu');
        PlayState.stateShit = CurState;
		if (FadeCam) Fade(FlxG.camera, Color, TimeFade, FadeIn, OnComplete, Force);
		if (Transition){
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
		}
		new FlxTimer().start(TimerChangeState, function(timer:FlxTimer){
			States('LoadSwitch', new PlayState());
		});
    }
	public static function GlobalModify(?ShitCameraZooming:Bool = null, ?ShitDanceIcons:Bool = null, ?GfDancingShitSpeed:Int = null, ?Pause:Bool = null){ // Need to Modify unmodified values in PlaySteps & PlayBeats
		if (GfDancingShitSpeed != null) CharacterSettigs.gfSpeed = GfDancingShitSpeed;
		if (Pause != null) PlayState.instance.paused = Pause;
		if (ShitCameraZooming != null) Camera.camZooming = ShitCameraZooming;
		if (ShitDanceIcons != null){
			HealthIcon.danceIcons = ShitDanceIcons;
			if (!ShitDanceIcons) HealthIcon.dancingIcons = false;
		}
	}
}