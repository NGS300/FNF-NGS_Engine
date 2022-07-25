package;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
class MenuItem extends FlxSpriteGroup{
	var fakeFramerate:Int = Math.round((1 / FlxG.elapsed) / 10);
	private var isFlashing:Bool = false;
	public static var week:FlxSprite;
	public var flashingInt:Int = 0;
	public var targetY:Float = 0;
	public function new(x:Float, y:Float, weekNum:Int = 0){
		super(x, y);
		week = new FlxSprite().loadGraphic(Paths.image('StoryShit/WeekNums/shitWeek' + weekNum));
		add(week);
	}
	public function startFlashing():Void{
		isFlashing = true;
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);
		if (isFlashing) flashingInt += 1;
		week.color = (flashingInt % fakeFramerate >= Math.floor(fakeFramerate / 2) ? 0xFF33ffff : FlxColor.WHITE);
	}
}