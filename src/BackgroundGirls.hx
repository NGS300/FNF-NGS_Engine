package;
import flixel.FlxSprite;
class BackgroundGirls extends FlxSprite{
	var danceDir:Bool = false;
	public function new(x:Float, y:Float, scrollX:Float, scrollY:Float){
		super(x, y);
		frames = Paths.getSparrowAtlas('school/bgFreaks', 'maps');
		animation.addByIndices('danceLeft', 'BG girls group', CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', 'BG girls group', CoolUtil.numberArray(30, 15), "", 24, false);
		animation.play('danceLeft');
		scrollFactor.set(scrollX, scrollY);
		antialiasing = false;
	}
	public function getScared():Void{
		animation.addByIndices('danceLeft', 'BG fangirls dissuaded', CoolUtil.numberArray(14), "", 24, false);
		animation.addByIndices('danceRight', 'BG fangirls dissuaded', CoolUtil.numberArray(30, 15), "", 24, false);
		dance();
	}
	public function dance():Void{
		danceDir = !danceDir;
		animation.play((danceDir ? 'danceRight' : 'danceLeft'), (danceDir ? true : false));
	}
}