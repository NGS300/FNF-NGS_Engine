import flixel.util.FlxAxes;
import flixel.FlxSprite;
using StringTools;
class NewSprite extends FlxSprite{
    private var idleAnim:String;
    public function new(?X:Float = 0, ?Y:Float = 0, Sprite:String, ?Folder:Null<String>, ?Visible:Bool = true, ?Alpha:Float = 1, ?ScrollX:Null<Float> = 1, ?ScrollY:Null<Float> = 1,  ?animNameToPlay:Null<String> = null, ?animLenght:Array<String> = null, ?FrameSpeed:Int = 24, ?Loop:Bool = false, ?Antialiasing:Null<Bool> = null){
        super(X, Y);
        if (animLenght != null){
            frames = Paths.getSparrowAtlas(Sprite, Folder);
			for (i in 0...animLenght.length){
				var anim:String = animLenght[i];
                if (animNameToPlay != null)
                    animation.addByPrefix(animNameToPlay, anim, FrameSpeed, Loop);
                else
				    animation.addByPrefix(anim, anim, FrameSpeed, Loop);
				if (idleAnim == null){
					idleAnim = anim;
					animation.play(anim);
				}
			}
        }else{
            if (Sprite != null)
                loadGraphic(Paths.loadImage(Sprite, Folder));
            active = false;
        }
        alpha = Alpha;
        visible = Visible;
        scrollFactor.set(ScrollX, ScrollY);
        if (Antialiasing == null){
            switch (TrackMap.mapComplement){
                default: antialiasing = Client.Public.antialiasing;
                case 'pixel': antialiasing = false;
            }
        }else
            antialiasing = Antialiasing;
    }
    public function dance(?Force:Bool = false){
		animation.play(idleAnim, Force);
	}
}
class SpriteComplement{
    public static function setAnims(?sprite:FlxSprite = null, animNameToPlay:Array<String> = null, ?animLenght:Array<String> = null, ?FrameSpeed:Int = 24, ?Loop:Bool = false, ?autoPlay:Bool = false, ?forcePlay:Bool = false){
        if (sprite != null){
            for (i in 0...animLenght.length){
                var animPlay:String = animNameToPlay[i];
                var animName:String = animLenght[i];
                sprite.animation.addByPrefix(animPlay, animName, FrameSpeed, Loop);
                if (autoPlay)
                    sprite.animation.play(animPlay, forcePlay);
            }
        }
    }
    //public static function switchPaths(){ }
    public static function setVariables(?sprite:FlxSprite = null, ?HitBoxUpdate:Null<Bool> = null, ?Width:Null<Float> = null, ?Height:Null<Float> = null, ?ScaleX:Null<Float> = null, ?ScaleY:Null<Float> = null, ?Active:Null<Bool> = null, ?Antialiasing:Null<Bool> = null, ?needAsScreenSprite:Null<Bool> = null, ?ScreenCenterValue:Null<FlxAxes> = null){
        if (sprite != null){
            if (Width != null)
                sprite.setGraphicSize(Std.int(sprite.width * Width));
            if (Height != null)
                sprite.setGraphicSize(Std.int(sprite.height * Height));
            if (ScaleX != null)
                sprite.scale.x = ScaleX;
            if (ScaleY != null)
                sprite.scale.y = ScaleY;
            if (HitBoxUpdate || HitBoxUpdate != null)
                sprite.updateHitbox();
            if (Active != null)
                sprite.active = Active;
            if (needAsScreenSprite || needAsScreenSprite != null){
                if (ScreenCenterValue != null)
                    sprite.screenCenter(ScreenCenterValue);
                else
                    sprite.screenCenter();
            }
            if (Antialiasing != null)
                sprite.antialiasing = Antialiasing;
        }
    }
}