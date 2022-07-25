package;
import flixel.graphics.frames.FlxAtlasFrames;
import haxe.Json;
import lime.utils.Assets;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
using StringTools;
class HealthIcon extends FlxSprite{
	public var folder = CachingState.CacheConfig.DirectoryFoldersIcons[FlxG.save.data.iconSprite];
	public static var onPlayState:Bool = false;
	public static var danceIcons:Bool = false;
	public static var dancingIcons:Bool = false;
	public var totalIconsAnim:Array<Int> = [];
	public static var instance:HealthIcon;
	public var isPlayer:Bool = false;
	public var isPNGIcon:Bool = true;
	public var sprTracker:FlxSprite;
	var defaultIconScale:Float = 1;
	public var offsetX:Float = 0;
	public var offsetY:Float = 0;
	public var json:IconJson;
	var iconScale:Float = 1;
	var char:String = 'bf';
	var iconSize:Float;
	public function new(char:String = 'bf', isPlayer:Bool = false){
		super();
		this.isPlayer = isPlayer;
		pushIcons(char);
		scrollFactor.set();
		iconScale = defaultIconScale;
		iconSize = width;
	}
	public function pushIcons(character:String){
		switch (character){
			default: getIconFile(character);
		}
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (onPlayState){
			setGraphicSize(Std.int(iconSize * iconScale));
			updateHitbox();
		}else{}
		if (sprTracker != null) setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
	function addIcon(CharIcon:String, ?IconLenght:Array<Int>, ?Antialiasing:Bool, ?OffsetX:Float = 0, ?OffsetY:Float = 0){
		if (!OpenFlAssets.exists(Paths.pushFileIcon('$folder', CharIcon + '-icon'))) CharIcon = 'carlinhos';
		offsetX = OffsetX;
		offsetY = OffsetY;	
		loadGraphic(Paths.pushFileIcon('$folder', CharIcon + '-icon'), true, 150, 150);
		Antialiasing != null ? antialiasing = Antialiasing : if (CharIcon.endsWith('-pixel')) antialiasing = false; else antialiasing = FlxG.save.data.antialiasing;
		animation.add(CharIcon, (IconLenght == null ? [0, 1 ,2] : IconLenght), 0, false, isPlayer);
		animation.play(CharIcon);
		this.char = CharIcon;
    }
	function getIconFile(charIcon:String){
		json = cast Json.parse(Assets.getText(Paths.getPath('GameSettings/HealthIcons/' + charIcon + '-icon' + '.json', TEXT, 'config')));
		var widthOptions:Int = 0;
		var heightOptions:Int = 0;
		var iconOptions:String = '';
		var graphicWidthOptions:Float = 0;
		var isPNGIcon:Bool = true;
		if (isPNGIcon){
			if (!OpenFlAssets.exists(Paths.pushFileIcon('$folder', charIcon + '-icon' + (json.complement == null ? '' : json.complement)))) charIcon = 'carlinhos';
		}
		isPNGIcon = (json.isGraphicPhoto == null ? true : json.isGraphicPhoto);
		switch (FlxG.save.data.iconSprite){
			case 0:
				if (isPNGIcon){
					widthOptions = 0;	
					heightOptions = 0;
				}
				graphicWidthOptions = 0;
				iconOptions = 'carlinhos';
				offsetX = 0;
				offsetY = 0;
			case 1:
				if (isPNGIcon){
					widthOptions = (json.widthOption1 != null ? json.widthOption1 : (json.width != null ? json.width : 150));
					heightOptions = (json.heightOption1 != null ? json.heightOption1 : (json.height != null ? json.height : 150));
				}
				iconOptions = (json.iconOption1 != null ? json.iconOption1 : (json.icon != null ? json.icon : charIcon));
				graphicWidthOptions = (json.graphicWidthOption1 != null ? json.graphicWidthOption1 : (json.graphicWidth != null ? json.graphicWidth : 1));
				offsetX = (json.offsetXOption1 != null ? json.offsetXOption1 : (json.offsetX != null ? json.offsetX : 0));
				offsetY = (json.offsetYOption1 != null ? json.offsetYOption1 : (json.offsetY != null ? json.offsetY : 0));
				x += (json.offsetXOption1 != null ? json.offsetXOption1 : (json.offsetX != null ? json.offsetX : 0));
				y += (json.offsetYOption1 != null ? json.offsetYOption1 : (json.offsetY != null ? json.offsetY : 0));
			case 2:
				if (isPNGIcon){
					widthOptions = (json.widthOption2 != null ? json.widthOption2 : (json.width != null ? json.width : 150));
					heightOptions = (json.heightOption2 != null ? json.heightOption2 : (json.height != null ? json.height : 150));
				}
				iconOptions = (json.iconOption2 != null ? json.iconOption2 : (json.icon != null ? json.icon : charIcon));
				graphicWidthOptions = (json.graphicWidthOption2 != null ? json.graphicWidthOption2 : (json.graphicWidth != null ? json.graphicWidth : 1));
				offsetX = (json.offsetXOption2 != null ? json.offsetXOption2 : (json.offsetX != null ? json.offsetX : 0));
				offsetY = (json.offsetYOption2 != null ? json.offsetYOption2 : (json.offsetY != null ? json.offsetY : 0));
				x += (json.offsetXOption2 != null ? json.offsetXOption2 : (json.offsetX != null ? json.offsetX : 0));
				y += (json.offsetYOption2 != null ? json.offsetYOption2 : (json.offsetY != null ? json.offsetY : 0));
			case 3:
				if (isPNGIcon){
					widthOptions = (json.widthOption3 != null ? json.widthOption3 : (json.width != null ? json.width : 150));
					heightOptions = (json.heightOption3 != null ? json.heightOption3 : (json.height != null ? json.height : 150));
				}
				iconOptions = (json.iconOption3 != null ? json.iconOption3 : (json.icon != null ? json.icon : charIcon));
				graphicWidthOptions = (json.graphicWidthOption3 != null ? json.graphicWidthOption3 : (json.graphicWidth != null ? json.graphicWidth : 1));
				offsetX = (json.offsetXOption3 != null ? json.offsetXOption3 : (json.offsetX != null ? json.offsetX : 0));
				offsetY = (json.offsetYOption3 != null ? json.offsetYOption3 : (json.offsetY != null ? json.offsetY : 0));
				x += (json.offsetXOption3 != null ? json.offsetXOption3 : (json.offsetX != null ? json.offsetX : 0));
				y += (json.offsetYOption3 != null ? json.offsetYOption3 : (json.offsetY != null ? json.offsetY : 0));
			case 4:
				if (isPNGIcon){
					widthOptions = (json.widthOption4 != null ? json.widthOption4 : (json.width != null ? json.width : 150));
					heightOptions = (json.heightOption4 != null ? json.heightOption4 : (json.height != null ? json.height : 150));
				}
				iconOptions = (json.iconOption4 != null ? json.iconOption4 : (json.icon != null ? json.icon : charIcon));
				graphicWidthOptions = (json.graphicWidthOption4 != null ? json.graphicWidthOption4 : (json.graphicWidth != null ? json.graphicWidth : 1));
				offsetX = (json.offsetXOption4 != null ? json.offsetXOption4 : (json.offsetX != null ? json.offsetX : 0));
				offsetY = (json.offsetYOption4 != null ? json.offsetYOption4 : (json.offsetY != null ? json.offsetY : 0));
				x += (json.offsetXOption4 != null ? json.offsetXOption4 : (json.offsetX != null ? json.offsetX : 0));
				y += (json.offsetYOption4 != null ? json.offsetYOption4 : (json.offsetY != null ? json.offsetY : 0));
			case 5:
				if (isPNGIcon){
					widthOptions = (json.widthOption5 != null ? json.widthOption5 : (json.width != null ? json.width : 150));
					heightOptions = (json.heightOption5 != null ? json.heightOption5 : (json.height != null ? json.height : 150));
				}
				iconOptions = (json.iconOption5 != null ? json.iconOption5 : (json.icon != null ? json.icon : charIcon));
				graphicWidthOptions = (json.graphicWidthOption5 != null ? json.graphicWidthOption5 : (json.graphicWidth != null ? json.graphicWidth : 1));
				offsetX = (json.offsetXOption5 != null ? json.offsetXOption5 : (json.offsetX != null ? json.offsetX : 0));
				offsetY = (json.offsetYOption5 != null ? json.offsetYOption5 : (json.offsetY != null ? json.offsetY : 0));
				x += (json.offsetXOption5 != null ? json.offsetXOption5 : (json.offsetX != null ? json.offsetX : 0));
				y += (json.offsetYOption5 != null ? json.offsetYOption5 : (json.offsetY != null ? json.offsetY : 0));
		}
		if (isPNGIcon){
			loadGraphic(Paths.loadImage(((json.iconDirectory == null ? 'icons/$folder/' + iconOptions : iconOptions)) + '-icon' + (json.complement == null ? '' : json.complement), (json.folder == null ? 'character' : json.folder)), (json.animated == null ? true : json.animated), widthOptions, heightOptions);
			json.antialiasing != null ? antialiasing = json.antialiasing : if (charIcon.endsWith('-pixel')) antialiasing = false; else antialiasing = FlxG.save.data.antialiasing;
			totalIconsAnim = (json.iconLenght != null ? json.iconLenght : [0, 1, 2]);
			animation.add(charIcon, totalIconsAnim, (json.frameRate == null ? 0 : json.frameRate), false, isPlayer, (json.flipY == null ? false : json.flipY));
			animation.play(charIcon);
		}else{ // Experimental (Useless)
			var sparrowAtlas:FlxAtlasFrames = Paths.getIconSparrowAtlas('$folder', iconOptions + '-fileIcon' + (json.complement == null ? '' : json.complement));
			frames = sparrowAtlas;
			/*animation.addByPrefix('dead', 'dead', 0, false, isPlayer);
			animation.addByPrefix('win', 'wining', 0, false, isPlayer);
			animation.addByPrefix('idle', 'idle', 0, false, isPlayer);
			animation.play('idle');*/
			animation.addByPrefix(charIcon, 'idle', 0, false, isPlayer);
			animation.play(charIcon);
		}
		if (graphicWidthOptions != (0 | 1)){
			setGraphicSize(Std.int(width * graphicWidthOptions));
			updateHitbox();
		}
		this.char = charIcon;
	}
	public static function iconBumping(bf:Boyfriend, opponent:Character, ?dancingIcons:Bool = false, ?beat:Int = 1, backingBeat:Int = 0, ?timeTween:Float = 0.2, ?scaleShit:Float = 1.365){
		if (FlxG.save.data.camerazoom && FlxG.save.data.iconSprite >= 1){
			if (!dancingIcons){
				if (bf.animation.curAnim.name.startsWith(Character.talkAction) && !bf.animation.curAnim.name.endsWith(Character.actionMiss)){ // Boyfriend is Sing, Icon Bop
					PlayState.iconP1.iconScale = PlayState.iconP1.defaultIconScale * scaleShit;
					Actions.Tween(PlayState.iconP1, {iconScale: PlayState.iconP1.defaultIconScale}, timeTween, {ease: FlxEase.quintOut});
				}
				if (opponent.animation.curAnim.name.startsWith(Character.talkAction)){ // Opponent is Sing, Icon Bop
					PlayState.iconP2.iconScale = PlayState.iconP2.defaultIconScale * scaleShit;
					Actions.Tween(PlayState.iconP2, {iconScale: PlayState.iconP2.defaultIconScale}, timeTween, {ease: FlxEase.quintOut});
				}
			}else{
				if (PlayStepEvents.publicStep % beat == backingBeat){
					PlayState.iconP1.scale.set(1.25, 1.25);
					PlayState.iconP2.scale.set(1.25, 1.25);
					PlayState.iconP1.updateHitbox();
					PlayState.iconP2.updateHitbox();
				}
			}
		}
	}
	public static function DancingIcons(nameTrack:String, ?beat:Int = 1, ?backingStep:Int = 0, ?angleShit:Float = 10){ // Dance health Icons in Fun Levels :D 
		danceIcons = true;
		if (PlayBeatEvents.publicBeat % beat == backingStep && PlayState.SONG.song.toLowerCase() == nameTrack){
			dancingIcons = !dancingIcons;
			PlayState.iconP1.angle = (dancingIcons ? angleShit : -angleShit);
			PlayState.iconP2.angle = (dancingIcons ? angleShit : -angleShit);
		}
	}
}
typedef IconJson ={
	var ?icon:String;
	var ?iconOption1:String;
	var ?iconOption2:String;
	var ?iconOption3:String;
	var ?iconOption4:String;
	var ?iconOption5:String;
	var ?widthOption5:Int;
	var ?heightOption5:Int;
	var ?widthOption4:Int;
	var ?heightOption4:Int;
	var ?widthOption3:Int;
	var ?heightOption3:Int;
	var ?widthOption2:Int;
	var ?heightOption2:Int;
	var ?widthOption1:Int;
	var ?heightOption1:Int;
	var ?width:Int;
	var ?height:Int;
	var ?graphicWidth:Float;
	var ?graphicWidthOption1:Float;
	var ?graphicWidthOption2:Float;
	var ?graphicWidthOption3:Float;
	var ?graphicWidthOption4:Float;
	var ?graphicWidthOption5:Float;
	var ?isGraphicPhoto:Bool;
	var ?complement:String;
	var ?antialiasing:Bool;
	var ?iconDirectory:String;
	var ?folder:String;
	var ?frameName:String;
	var ?iconLenght:Array<Int>;
	var ?frameRate:Float;
	var ?FPSFrameWining:Int;
	var ?FPSFrameIdle:Int;
	var ?FPSFrameDead:Int;
	var ?frameNameIdle:String;
	var ?frameNameDead:String;
	var ?frameNameWining:String;
	var ?loopAnimWining:Bool;
	var ?loopAnimIdle:Bool;
	var ?loopAnimDead:Bool;
	var ?animated:Bool;
	var ?offsetX:Float;
	var ?offsetXOption1:Float;
	var ?offsetXOption2:Float;
	var ?offsetXOption3:Float;
	var ?offsetXOption4:Float;
	var ?offsetXOption5:Float;
	var ?offsetY:Float;
	var ?offsetYOption1:Float;
	var ?offsetYOption2:Float;
	var ?offsetYOption3:Float;
	var ?offsetYOption4:Float;
	var ?offsetYOption5:Float;
	var ?flipY:Bool;
	var ?flipX:Bool;
}