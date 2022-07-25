package;
import flixel.FlxSprite;
import flixel.FlxG;
using StringTools;
class Boyfriend extends Character{
	public var stunned:Bool = false;
	public var sprTracker:FlxSprite;
	public function new(x:Float, y:Float, ?char:String = 'bf'){
		super(x, y, char, true);
	}
	override function update(elapsed:Float){
		if (!charOffseting){
			(animation.curAnim.name.startsWith(Character.talkAction) ? holdTimer += elapsed : holdTimer = 0);
			if (animation.curAnim.name.endsWith(Character.actionMiss) && animation.curAnim.finished) playAnim('idle', true, false, 10);
			if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished) playAnim('deathLoop');
		}
		if (sprTracker != null){
			x = (sprTracker.y * 2) + 90 - 350;
			y = FlxG.height / 3 - 68;
		}
		super.update(elapsed);
	}
}