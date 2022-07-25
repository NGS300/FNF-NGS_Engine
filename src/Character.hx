package;
import lime.utils.Assets;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.FlxSprite;
using StringTools;
class Character extends FlxSprite{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public static var alternativeAnimation:String = '-alt';
	public static var talkAction:String = 'action';
	public static var actionMiss:String = 'miss';
	public static var dodgeShit:String = 'DODGE';
	public static var dickShooter:String = 'SHOOT';
	public static var damageHit:String = 'hitted';
	public var curCharacter:String = 'bf';
	public var charOffseting:Bool = false;
	public var customHoldTimer:Float = 4;
	public static var instance:Character;
	private var bomboxDance:Bool = false;
	public var characterPositionX:Float;
	public var characterPositionY:Float;
	public var json:CharacterAnimation;
	public var healthBarColor:FlxColor;
	public var inExcited:Bool = false;
	public var cameraPositionX:Float;
	public var cameraPositionY:Float;
	public var isPlayer:Bool = false;
	public var isBombox:Bool = false;
	public var getCharPointX:Float;
	public var getCharPointY:Float;
	public var holdTimer:Float = 0;
	public var icon:String = '';
	public var gameOverDead:String = '';
	public var deathSize:Float = 1;
	public var complementShit:String = '';
	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false){
		super(x, y);
		instance = this;
		healthBarColor = isPlayer ? 0xFF66FF33 : 0xFFFF0000;
		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;
		getCharactersAnimations(curCharacter);
		dance();
		/*I RECOMMEND NOT TOUCHING IT!*/ if (isPlayer) {flipX = !flipX; if (!curCharacter.startsWith('bf')){var oldRight = animation.getByName('actionRIGHT').frames; animation.getByName('actionRIGHT').frames = animation.getByName('actionLEFT').frames; animation.getByName('actionLEFT').frames = oldRight; if (animation.getByName('actionRIGHTmiss') != null){ var oldMiss = animation.getByName('actionRIGHTmiss').frames; animation.getByName('actionRIGHTmiss').frames = animation.getByName('actionLEFTmiss').frames; animation.getByName('actionLEFTmiss').frames = oldMiss;}}}
	}
	function getCharactersAnimations(character:String){ // Create Character Animatios
		switch (character){
			default:  getCharacterFile(character);
			case 'pico': // This Exemplo to Use
				addAnim('charWeeks/3/Pico_Assets', null, ['idle',
					'actionLEFT', 'actionDOWN', 'actionUP', 'actionRIGHT',
					'actionLEFTmiss', 'actionDOWNmiss', 'actionUPmiss', 'actionRIGHTmiss', 'actionShoot'], ['Pico Idle Dance',
					'Pico Note LEFT0', 'Pico Down Note0', 'pico Up note0', 'Pico NOTE RIGHT0',
					'Pico Note LEFT Miss', 'Pico Down Note MISS', 'pico Up note miss', 'Pico NOTE Right miss', 'Pico Shoot'
					], null, null, [true, false, false, false, false]
				);
				getTheNecessary(0xFFb7d855, 'idle');
		}
	}
	override function update(elapsed:Float){
		if (!isPlayer){
			if (animation.curAnim.name.startsWith(talkAction)) holdTimer += elapsed;
			if (holdTimer >= Conductor.stepCrochet * 0.001 * customHoldTimer){ dance(); holdTimer = 0;}
		}
		if (animation.getByName('hairFall') != null && animation.curAnim.finished) playAnim('danceRight');
		super.update(elapsed);
	}
	public function getFileOffset(?Character:Null<String> = null, ?autoGetChar:String){ // KE Input Get Offset .txt File
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txtAny('GameSettings/CharacterOffsets/' + (Character != null ? Character : autoGetChar) + "-offsets", 'config'));
		for (i in 0...offset.length) {var get:Array<String> = offset[i].split(', '); addOffset(get[0], Std.parseInt(get[1]), Std.parseInt(get[2]));}
	}
	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void{ // Play Exist Character Animtion
		if (!inExcited){
			animation.play(AnimName, Force, Reversed, Frame);
			var daOffset = animOffsets.get(AnimName);
			if (animOffsets.exists(AnimName)) offset.set(daOffset[0], daOffset[1]); else offset.set(0, 0);
			if (curCharacter.startsWith('gf')){
				if (AnimName == 'actionLEFT') bomboxDance = true;
				else if (AnimName == 'actionRIGHT') bomboxDance = false;
				if (AnimName == 'actionUP' || AnimName == 'actionDOWN') bomboxDance = !bomboxDance;
			}
		}
	}
	public function dance(?AnimName:String = 'idle'){
		if (!charOffseting && !inExcited){
			if (!curCharacter.startsWith('gf') || !curCharacter.startsWith('gf') && animation.getByName(AnimName) != null) 
				playAnim(AnimName);
			else{
				if (!animation.curAnim.name.startsWith('hair')){
					bomboxDance = !bomboxDance;
					playAnim((bomboxDance ? 'danceRight' : 'danceLeft'));
				}
			}
		}
	}
	function addAnim(Frame:String, ?Folder:Null<String>, AnimNameArray:Array<String>, AnimPrefixArray:Array<String>, ?AnimIndices:Array<Array<Int>> = null, ?AnimFPS:Array<Int> = null, ?AnimForce:Array<Bool> = null){
		if (Assets.exists(Paths.getPath(Frame + '.txt', TEXT)))
			frames = Paths.getPackerAtlas(Frame, Folder != null ? Folder : 'character');
		else
			frames = Paths.getSparrowAtlas(Frame, Folder != null ? Folder : 'character');
		for (num in 0...AnimNameArray.length){
			if (AnimIndices == null)
				animation.addByPrefix(AnimNameArray[num], AnimPrefixArray[num], (AnimFPS == null ? 24 : AnimFPS[num]), (AnimForce == null ? false : AnimForce[num]));
			else
				animation.addByIndices(AnimNameArray[num], AnimPrefixArray[num], AnimIndices[num], "", (AnimFPS == null ? 24 : AnimFPS[num]), (AnimForce == null ? false : AnimForce[num]));
		}
	}
	public function getTheNecessary(?ColorHP:FlxColor = null, ?IdleAnimPlay:String = null, ?HoldTimer:Float = null, ?GraphicScale:Float = null, ?FlipX:Bool = null, ?FlipY:Bool = null, ?Antialiasing:Bool = null, ?Char:String = null){ // Get Complements Character Manual Create
		var getChar:String = (isBombox ? PlayState.SONG.girlfriend : isPlayer ? Options.ThisOption.changeBF() : PlayState.SONG.player2);
		getFileOffset(Char == null ? getChar : Char, getChar);
		healthBarColor = ColorHP != null ? ColorHP : FlxColor.WHITE;
		customHoldTimer = HoldTimer == null ? 4 : HoldTimer;
		if (IdleAnimPlay != null) if (animation.exists(IdleAnimPlay)) animation.play(IdleAnimPlay);
		icon = Char == null ? getChar : Char;
		flipX = (FlipX == null ? false : FlipX);
		flipY = (FlipY == null ? false : FlipY);
		if (curCharacter.endsWith('-pixel')){
			if (GraphicScale != null) setGraphicSize(Std.int(width * TrackMap.daPixelZoom * GraphicScale)); else setGraphicSize(Std.int(width * TrackMap.daPixelZoom));
			updateHitbox();
		}else{
			if (GraphicScale != null){
				setGraphicSize(Std.int(width * GraphicScale));
				updateHitbox();
			}
		}
		antialiasing = (Antialiasing != null ? Antialiasing : (curCharacter.endsWith('-pixel') ? false : Client.Public.antialiasing));
	}
	function getCharacterFile(?fileJsonPush:String){ // "I RECOMMEND NOT TOUCHING IT!!!" This Function Get Json Character Suport (More Option Possible)
		var getChar:String = (isBombox ? PlayState.SONG.girlfriend : isPlayer ? Options.ThisOption.changeBF() : PlayState.SONG.player2);
		json = cast Json.parse(Assets.getText(Paths.getPath('GameSettings/CharacterOffsets/' +  (fileJsonPush == null ? getChar : fileJsonPush) + '.json', TEXT, 'config')));
		switch ((json.getAtlasFile == null ? "sparrowAtlas" : json.getAtlasFile)){
			case "sparrowAtlas": frames = Paths.getSparrowAtlas(json.imageDirectory, (json.folder == null ? 'character' : json.folder));
			case "packerAtlas": frames = Paths.getPackerAtlas(json.imageDirectory, (json.folder == null ? 'character' : json.folder));
		}
		if (Assets.exists(Paths.getPath(json.imageDirectory + '.txt', TEXT))) json.getAtlasFile = "packerAtlas";
		icon = (json.icon == null ? '' : json.icon);
		antialiasing = (json.antialiasing != null ? json.antialiasing : (curCharacter.endsWith('-pixel') || json.isPixel && json.isPixel != null ? false : Client.Public.antialiasing));
		for (anim in json.characterAnimationsTypes){
			if (anim.frameNums != null)
				animation.addByIndices((anim.animationName == null ? 'idle' : anim.animationName), anim.frameName, anim.frameNums, "", (anim.frameRate == null ? 24 : anim.frameRate), (anim.animLooped == null ? false : anim.animLooped), (anim.flipX == null ? false : anim.flipX), (anim.flipY == null ? false : anim.flipY));
			else
				animation.addByPrefix((anim.animationName == null ? 'idle' : anim.animationName), anim.frameName, (anim.frameRate == null ? 24 : anim.frameRate), (anim.animLooped == null ? false : anim.animLooped), (anim.flipX == null ? false : anim.flipX), (anim.flipY == null ? false : anim.flipY));
			animOffsets[(anim.animationName == null ? 'idle' : anim.animationName)] = anim.offsets == null ? [0, 0] : anim.offsets;
		}
		playAnim((json.animStarted == null ? 'idle' : json.animStarted));
		gameOverDead = (json.deathAnim == null ? '' : json.deathAnim);
		healthBarColor = FlxColor.fromString((json.hpColor == null ? 'WHITE' : json.hpColor));
		customHoldTimer = (json.holdTimer == null ? 4 : json.holdTimer);
		alpha = (json.alpha == null ? 1 : json.alpha);
		flipX = (json.flipX == null ? false : json.flipX);
		flipY = (json.flipY == null ? false : json.flipY);
		if (json.scaleX != null) scale.x = json.scaleX;
		if (json.scaleY != null) scale.y = json.scaleY;
		json.isNegativeWidth = (json.isNegativeWidth == null ? false : json.isNegativeWidth);
		json.isNegativeHeight = (json.isNegativeHeight == null ? false : json.isNegativeHeight);
		if (json.width != null) (json.isNegativeWidth ? width -= json.width : width += json.width);
		if (json.height != null) (json.isNegativeHeight ? height -= json.height : height += json.height);
		getCharPointX = (json.midPointX == null ? 0 : json.midPointX);
		getCharPointY = (json.midPointY == null ? 0 : json.midPointY);
		characterPositionX = (json.positionX == null ? 0 : json.positionX);
		characterPositionY = (json.positionY == null ? 0 : json.positionY);
		cameraPositionX = (json.camposX == null ? 0 : json.camposX);
		cameraPositionY = (json.camposY == null ? 0 : json.camposY);
		if (json.complement != '' && json.complement != "" && json.complement != null && curCharacter.endsWith(json.complement)){
			complementShit = (json.complement == null ? '' : json.complement);
			if (json.graphicScale != null){
				setGraphicSize(Std.int(width * json.graphicScale));
				deathSize = json.graphicScale;
				updateHitbox();
			}
		}else if (curCharacter.endsWith('-pixel') || json.isPixel && json.isPixel != null){
			setGraphicSize(Std.int(width * (json.graphicScale == null ? TrackMap.daPixelZoom : TrackMap.daPixelZoom * json.graphicScale)));
			deathSize = (json.graphicScale == null ? TrackMap.daPixelZoom : TrackMap.daPixelZoom * json.graphicScale);
			complementShit = (json.complement == null ? '-pixel' : json.complement);
			updateHitbox();
		}else{
			complementShit = (json.complement == null ? '' : json.complement);
			if (json.graphicScale != null){
				setGraphicSize(Std.int(width * json.graphicScale));
				deathSize = json.graphicScale;
				updateHitbox();
			}
		}
		if (curCharacter == 'bf-pixel'){
			width -= 100;
			height -= 100;
		}
	}
	public function addOffset(AnimName:String, PosX:Float = 0, PosY:Float = 0) { animOffsets[AnimName] = [PosX, PosY]; }
}
typedef CharacterAnimation ={
	var imageDirectory:String;
	//var ?isGirlfriend:Bool;
	var ?antialiasing:Bool;
	var ?icon:String;
	var ?folder:String;
	var ?getAtlasFile:String;
	var ?hpColor:String;
	var ?animStarted:String;
	var ?holdTimer:Float;
	var ?graphicScale:Float;
	var ?width:Float;
	var ?height:Float;
	var ?scaleX:Float;
	var ?scaleY:Float;
	var ?alpha:Float;
	var ?flipX:Bool;
	var ?flipY:Bool;
	var ?midPointX:Float;
	var ?midPointY:Float;
	var ?positionX:Float;
	var ?positionY:Float;
	var ?camposX:Float;
	var ?camposY:Float;
	var ?isNegativeWidth:Bool;
	var ?isNegativeHeight:Bool;
	var ?isPixel:Bool;
	var ?deathAnim:String;
	var ?complement:String;
	var characterAnimationsTypes:Array<GetAnimationType>;
}
typedef GetAnimationType ={
	var ?animationName:String;
	var frameName:String;
	var ?offsets:Array<Int>;
	var ?frameNums:Array<Int>;
	var ?frameRate:Int;
	var ?animLooped:Bool;
	var ?flipX:Bool;
	var ?flipY:Bool;
} 