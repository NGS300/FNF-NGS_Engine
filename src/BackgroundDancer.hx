package;
import flixel.FlxSprite;
class BackgroundDancer extends FlxSprite{
	var danceDir:Bool = false;
	public function new(x:Float, y:Float, scrollX:Float, scrollY:Float){
		super(x, y);
		frames = Paths.getSparrowAtlas("limo/limoDancer", 'maps');
		animation.addByIndices('danceLeft', 'bg dancer sketch PINK', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('danceRight', 'bg dancer sketch PINK', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.play('danceLeft');
		scrollFactor.set(scrollX, scrollY);
		antialiasing = Client.Public.antialiasing;
	}
	public function dance():Void{
		danceDir = !danceDir;
		animation.play((danceDir ? 'danceRight' : 'danceLeft'), true);
	}
}