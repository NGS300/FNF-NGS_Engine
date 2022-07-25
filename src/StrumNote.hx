package;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
using StringTools;
class StrumNote extends FlxSprite{
    public static var ColorPixelStrum:Array<String> = ['purplel', 'blue', 'green', 'red'];
    public static var ColorStrum:Array<String> = ['purple', 'blue', 'green', 'red'];
    public static var DelayStarting:Float = 0;
    public static var FloaterTimer:Float = 0;
    public static var TimerOutTip:Float = 0;
    public static var DickTween:Bool = true;
    public static var Duration:Float = 0;
    public static function ShowKeybindsTip(?add:Dynamic = null){ 
        if (add != null){
            for (i in 0...4/*arrowMax[numArrow]*/){
                var playerKeyBinds:Array<String> = (!PlayState.SONG.fiveNotes ? [FlxG.save.data.leftBind, FlxG.save.data.downBind, FlxG.save.data.upBind, FlxG.save.data.rightBind] :  [FlxG.save.data.leftBind, FlxG.save.data.downBind, 'MiddleBind(NotExist)', FlxG.save.data.upBind, FlxG.save.data.rightBind]);
                var showKeys:Text = new Text(playerKeyBinds[i], (108.35 * i) + PlayState.playerStrums.members[0].x + 50, PlayState.instance.strumLine.y + 34, 50, 0, 0);
                showKeys.format((TrackMap.mapComplement != 'pixel' ? "Highman" : "Windows Regular"), 50, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
                showKeys.borderSize = 2;
                add(showKeys);
                showKeys.cameras = [PlayState.camNOTE];
                Actions.Tween(showKeys, {y: showKeys.y + (Client.Public.downscroll ? -100 : 100), alpha: 1}, Duration, {ease: FlxEase.smoothStepInOut, startDelay: DelayStarting + (FloaterTimer * i)});
                new FlxTimer().start(TimerOutTip, function(tmr:FlxTimer){
                    Actions.Tween(showKeys, {y: showKeys.y + (Client.Public.downscroll ? 100 : -100), alpha: 0}, Duration, {ease: FlxEase.smoothStepInOut, startDelay: DelayStarting + (FloaterTimer * i)});
                    new FlxTimer().start(TimerOutTip + 5, function(tmr:FlxTimer){
                        showKeys.destroy();
                    });
                });
            }
        }
    }
    public static function StrumMoveOnHit(Player:String, Note:Note){ // Get strumMembers to Move
		var i = Note.noteData;
        switch (Player){
            case 'P1': strumMembers(PlayState.playerStrums, i, Note, CachingState.CacheConfig.strumNumMove); // Player
            case 'P2': if (!Client.Public.mid) strumMembers(PlayState.opponentStrums, i, Note, CachingState.CacheConfig.strumNumMove); // Opponent
        }
    }
    public static function LoadArrowAnimation(?LoadArrow:String = 'default', skin:FlxSprite, player:Int, ?i:Int):Void{ // Load Diretion Arrow
        trace('Skin Loaded ' + "[" + LoadArrow + "]");
        skin.x += Note.swagWidth * i;
        switch (LoadArrow){
            case 'default':
                loadStrumImages('default', skin, player);
                addAnimStrum(skin, i, 'static', ['arrowLEFT', 'arrowDOWN', 'arrowUP', 'arrowRIGHT'], false, null, 30, true);
                addAnimStrum(skin, i, 'pressed', ['left pressed', 'down pressed', 'up pressed', 'right pressed']);
                addAnimStrum(skin, i, 'glown', ['left hited', 'down hited', 'up hited', 'right hited']);
            case 'pixel':
                loadStrumImages('pixel', skin, player);
                addAnimStrum(skin, i, 'static', null, true, [[0], [1], [2], [3]], 30, true);
                addAnimStrum(skin, i, 'pressed', null, true, [[4, 8], [5, 9], [6, 10], [7, 11]], 12);
                addAnimStrum(skin, i, 'glown', null, true, [[12, 16], [13, 17], [14, 18], [15, 19]]);
        }
        skin.updateHitbox();
		skin.scrollFactor.set();
        Actions.PlaySprAnim(skin, 'static');
		skin.x += 50;
    }
    public static function GlowHitNote(Action:String, spr:FlxSprite, ?note:Note, ?pressArray:Array<Bool>, ?holdArray:Array<Bool>){ // Load Hit, Press, Idle Animations
        switch (Action){
            case 'OpponentIdle': sprPlay(false, false, spr, note);
            case 'OpponentHit': sprPlay(true, false, spr, note);
            case 'PlayerIdle': sprPlay(false, true, spr, note, pressArray, holdArray);
            case 'PlayerHit': sprPlay(true, true, spr, note, pressArray, holdArray);
        }
	}
    public static function TweenNote(skin:FlxSprite, TweenShit:Bool, i:Int){ // Tween Alpha and Y post Basic of Gen Static Arrow
        TweenShit = DickTween;
        switch (PlayState.instance.curTrack){
            default: tweenSetting(1, 0.2, 0.5, 4.25);
            case 'Tutorial': tweenSetting(2.5, 0.55, 0.6, 7.25);
            case 'Dadbattle' | 'Thorns': tweenSetting(0.095, 0.1985, 0.5, 3);
        }
        if (TweenShit){
            skin.y -= 10;
            skin.alpha = 0;
            Actions.Tween(skin, {y: skin.y + 10, alpha: 1}, Duration, {ease: FlxEase.circOut, startDelay: DelayStarting + (FloaterTimer * i)});
        }
	}
    public static function loadStrumImages(?StrumImagePush:String = 'default', skin:FlxSprite, player:Int):Void{ // Load Sprite Strum
        switch (StrumImagePush){
            case 'default':
                switch (PlayState.SONG.song.toLowerCase()){
                    default: switch (player){
                            case 0: getImages(skin, 'opponent', ['Opponent_NewSytle_NOTE_assets', 'Opponent_NOTE_assets'], true);
                            case 1: getImages(skin, 'player', ['Player_NewSytle_NOTE_assets', 'Player_NOTE_assets'], true);
                        }
                }
                addBaseStrum(skin, ['arrowLEFT', 'arrowDOWN', 'arrowUP', 'arrowRIGHT']);
            case 'pixel':
                switch (PlayState.SONG.song.toLowerCase()){
                    default: switch (player){
                            case 0: getPixelImages(skin, 'opponent', ['Opponent_NOTENewStyle', 'Opponent_NOTE'], true);
                            case 1: getPixelImages(skin, 'player', ['Player_NOTENewStyle', 'Player_NOTE'], true);
                        }
                }
                addBaseStrum(skin, null, true, [[4], [5], [6], [7]]);
        }
    }
    public static function getImages(Skin:FlxSprite, Player:String, Path:Array<String>, ?HaveStyle:Bool = false, ?Folder:String = 'shared'){
        Skin.frames = Paths.getSparrowAtlas('note/skins/$Player/' + (HaveStyle ? (Options.Option.JsonOptions.UseNewNoteSytle ? Path[0] : Path[1]) : Path[0]), Folder);
    }
    public static function getPixelImages(Skin:FlxSprite, Player:String, ?PixelPath:Array<String>, ?HaveStyle:Bool = false, ?Folder:String = 'shared', ?Width:Int = 17, ?Height:Int = 17, ?Animated:Bool = true){
        Skin.loadGraphic(Paths.loadImage('note/skins/$Player/pixel/' + (HaveStyle ? (Options.Option.JsonOptions.UseNewNoteSytle ? PixelPath[0] : PixelPath[1]) : PixelPath[0]) + '-pixel', Folder), Animated, Width, Height);
    }
    public static function tweenSetting(?Timeleft:Float = 0, ?Timer:Float = 0, ?Delay:Float = 0, ?OutTip:Float = 0){
        TimerOutTip = OutTip;
        if (DickTween){
            Duration = Timeleft;
            FloaterTimer = Timer;
            DelayStarting = Delay;
        }
    }
    public static function SprOffset(spr:FlxSprite, X:Float = 0, Y:Float = 0){
        spr.centerOffsets();
        if (X != 0) spr.offset.x += X;
        if (Y != 0) spr.offset.y += Y;
    }
    public static function addAnimStrum(skin:FlxSprite, i:Int, StrumType:String, ?PathPrefix:Array<String> = null, ?IsPixel:Bool = false, ?PathFrame:Array<Array<Int>> = null, ?FrameRate:Int = 24, ?Looped:Bool = false){
        if (IsPixel)
            skin.animation.add(StrumType, PathFrame[i], FrameRate, Looped);
        else
            skin.animation.addByPrefix(StrumType, PathPrefix[i], FrameRate, Looped);
    }
    public static function strumMembers(StrumName:Dynamic, i:Int, Note:Note, moveNote:Float){ // Code of Strums to Pre-Move
		if (CachingState.CacheConfig.noStrumHoldReaction){
			if (!Note.isSustainNote) 
                compactMemmbersMove(StrumName, i, moveNote);
		}else
			compactMemmbersMove(StrumName, i, moveNote);
    }
	public static function compactMemmbersMove(StrumName:Dynamic, i:Int, offsetMove:Float){ // Just to Compact
		Actions.Tween(StrumName.members[i], {y: PlayState.instance.strumLineYPos + (Client.Public.downscroll ? offsetMove : -offsetMove)}, 0.1, {ease: FlxEase.circOut,
			onComplete: function(twn:FlxTween){
				Actions.Tween(StrumName.members[i], {y: PlayState.instance.strumLineYPos}, 0.1, {ease: FlxEase.circOut});
			}
		});
		Actions.Tween(StrumName.members[i], {y: PlayState.instance.strumLineYPos + (Client.Public.downscroll ? offsetMove : -offsetMove)}, 0.1, {ease: FlxEase.circOut,
			onComplete: function(twn:FlxTween){
				Actions.Tween(StrumName.members[i], {y: PlayState.instance.strumLineYPos}, 0.1, {ease: FlxEase.circOut});
			}
		});
	}
    public static function addBaseStrum(skin:FlxSprite, ?Prefix:Array<String> = null, ?isPixel:Bool = false, ?Frame:Array<Array<Int>> = null){
        if (isPixel){
            for (i in 0...4) skin.animation.add(ColorPixelStrum[i], Frame[i]);
        }else{
            for (i in 0...4) skin.animation.addByPrefix(ColorStrum[i], Prefix[i]);
        }
        skin.setGraphicSize(Std.int(skin.width * (isPixel ? TrackMap.daPixelZoom : 0.7)));
        if (isPixel) skin.updateHitbox();
        skin.antialiasing = (isPixel ? false : Client.Public.antialiasing);
    }
    public static function sprPlay(IsHit:Bool, IsPlayer:Bool, spr:FlxSprite, note:Note, ?pressArray:Array<Bool>, ?holdArray:Array<Bool>){
        if (IsHit){
            if (IsPlayer){ // Player
                if (FlxG.save.data.botplay){
                    if (Math.abs(note.noteData) == spr.ID)
                        if (!note.isSustainNote)
                            Actions.PlaySprAnim(spr, 'glown', true);
                    if (spr.animation.curAnim.name == 'glown' && TrackMap.mapComplement != 'pixel')
                        SprOffset(spr, -13, -13);
                    else
                        SprOffset(spr);
                }else{
                    if (Math.abs(note.noteData) == spr.ID){
                        if (!note.isSustainNote)
                            Actions.PlaySprAnim(spr, 'glown', true);
                    }
                }
            }else{ // Opponent
                if (Math.abs(note.noteData) == spr.ID)
                    if (!note.isSustainNote)
                        Actions.PlaySprAnim(spr, 'glown', true);
                if (spr.animation.curAnim.name == 'glown' && TrackMap.mapComplement != 'pixel')
                    SprOffset(spr, -13, -13);
                else
                    SprOffset(spr);
            }
        }else{
            if (IsPlayer){ // Player
                if (FlxG.save.data.botplay){
                    if (spr.animation.finished){
                        Actions.PlaySprAnim(spr, 'static');
                        SprOffset(spr);
                    }
                }else{
                    if (pressArray[spr.ID] && spr.animation.curAnim.name != 'glown')
                        Actions.PlaySprAnim(spr, 'pressed');
                    if (!holdArray[spr.ID]) 
                        Actions.PlaySprAnim(spr, 'static');
                    if (spr.animation.curAnim.name == 'glown' && TrackMap.mapComplement != 'pixel')
                        SprOffset(spr, -13, -13);
                    else
                        SprOffset(spr);
                }
            }else{ // Opponent
                if (spr.animation.finished){
                    Actions.PlaySprAnim(spr, 'static');
                    SprOffset(spr);
                }
            }
        }
    }
}