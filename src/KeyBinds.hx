import flixel.FlxG;
class KeyBinds{
	public static var gamepad:Bool = false;
	public static function resetBinds():Void{
		FlxG.save.data.upBind = "W";
		FlxG.save.data.downBind = "S";
		FlxG.save.data.leftBind = "A";
		FlxG.save.data.rightBind = "D";
		FlxG.save.data.muteBind = "ZERO";
		FlxG.save.data.fullscreenBind = "F";
		FlxG.save.data.gpupBind = "DPAD_UP";
		FlxG.save.data.gpdownBind = "DPAD_DOWN";
		FlxG.save.data.gpleftBind = "DPAD_LEFT";
		FlxG.save.data.gprightBind = "DPAD_RIGHT";
		FlxG.save.data.pauseBind = "ENTER";
		FlxG.save.data.chartingBind = "SEVEN";
		FlxG.save.data.gppauseBind = "START";
		FlxG.save.data.resetBind = "R";
		FlxG.save.data.dodgeBind = "SPACE";
		FlxG.save.data.gpresetBind = "SELECT";
		FlxG.sound.muteKeys = ["ZERO", "NUMPADZERO"];
		PlayerSettings.player1.controls.loadKeyBinds();
	}
	public static function keyCheck():Void{
		if (FlxG.save.data.upBind == null){
			FlxG.save.data.upBind = "W";
			trace("No UP");
		}
		if (FlxG.save.data.downBind == null){
			FlxG.save.data.downBind = "S";
			trace("No DOWN");
		}
		if (FlxG.save.data.leftBind == null){
			FlxG.save.data.leftBind = "A";
			trace("No LEFT");
		}
		if (FlxG.save.data.rightBind == null){
			FlxG.save.data.rightBind = "D";
			trace("No RIGHT");
		}
		if (FlxG.save.data.gpupBind == null){
			FlxG.save.data.gpupBind = "DPAD_UP";
			trace("No GUP");
		}
		if (FlxG.save.data.gpdownBind == null){
			FlxG.save.data.gpdownBind = "DPAD_DOWN";
			trace("No GDOWN");
		}
		if (FlxG.save.data.gpleftBind == null)
		{
			FlxG.save.data.gpleftBind = "DPAD_LEFT";
			trace("No GLEFT");
		}
		if (FlxG.save.data.gprightBind == null){
			FlxG.save.data.gprightBind = "DPAD_RIGHT";
			trace("No GRIGHT");
		}
		if (FlxG.save.data.pauseBind == null){
			FlxG.save.data.pauseBind = "ENTER";
			trace("No ENTER");
		}
		if (FlxG.save.data.chartingBind == null){
			FlxG.save.data.chartingBind = "SEVEN";
			trace("No 7");
		}
		if (FlxG.save.data.gppauseBind == null){
			FlxG.save.data.gppauseBind = "START";
			trace("No ENTER");
		}
		if (FlxG.save.data.resetBind == null){
			FlxG.save.data.resetBind = "R";
			trace("No RESET");
		}
		if (FlxG.save.data.dodgeBind == null){
			FlxG.save.data.dodgeBind = "SPACE";
			trace("No Dodge");
		}
		if (FlxG.save.data.gpresetBind == null){
			FlxG.save.data.gpresetBind = "SELECT";
			trace("No RESET");
		}
		if (FlxG.save.data.muteBind == null){
			FlxG.save.data.muteBind = "ZERO";
			trace("No MUTE");
		}
		trace('Arrows Binds: ${FlxG.save.data.leftBind}-${FlxG.save.data.downBind}-${FlxG.save.data.upBind}-${FlxG.save.data.rightBind} - Dodge Bind: ${FlxG.save.data.dodgeBind}');
	}
}