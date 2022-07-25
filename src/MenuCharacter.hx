package;
import flixel.FlxSprite;
class MenuCharacter extends FlxSprite{
	private var flipped:Bool = false;
	private static var settings:Map<String, CharacterSetting> =[
		'nothing' => new CharacterSetting(),
		'gf' => new CharacterSetting(50, 80, 1.5, true),
		'bf' => new CharacterSetting(0, -20, 1.0, true),
		'dad' => new CharacterSetting(-15, 130),
		'spooky' => new CharacterSetting(20, 30),
		'pico' => new CharacterSetting(0, 0, 1.0, true),
		'mom' => new CharacterSetting(-30, 140, 0.85),
		'parents' => new CharacterSetting(100, 130, 1.8),
		'senpai-pixel' => new CharacterSetting(-40, -45, 1.4),
		'tankmanCaptain' => new CharacterSetting(-10, 100, 1.25)
	];
	public function new(x:Int, y:Int, scale:Float, flipped:Bool){
		super(x, y);
		this.flipped = flipped;
		antialiasing = Client.Public.antialiasing;
		frames = Paths.getSparrowAtlas('StoryShit/UI_Characters_Storymenu_Assets');
		addStoryCharacter();
		addStoryCharacter('bf', 'BF Idle Dance');
		addStoryCharacter('bfConfirm', 'BF HEY!!', 24, false);
		addStoryCharacter('gf', 'GF Dancing Beat');
		addStoryCharacter('dad', 'Dad Idle Dance');
		addStoryCharacter('spooky', 'Spooky Idle Dance');
		addStoryCharacter('pico', 'Pico Idle Dance');
		addStoryCharacter('mom', 'Mom Idle Dance');
		addStoryCharacter('parents', 'Parents Idle Dance');
		addStoryCharacter('senpai-pixel', 'Senpai Idle Dance');
		addStoryCharacter('tankmanCaptain', 'TankmanCaptain Idle Dance');
		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}
	public function setCharacter(character:String):Void{
		if (character == ''){
			visible = false;
			return;
		}else
			visible = true;
		animation.play(character);
		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
	function addStoryCharacter(Name:String = 'nothing', NameAnim:String = 'NoLines', FrameRater:Int = 24, Looped:Bool = true, FlipX:Bool = false, FlipY:Bool = false){
		animation.addByPrefix(Name, NameAnim, FrameRater, Looped, FlipX, FlipY);
	}
}
class CharacterSetting{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;
	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false){
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}