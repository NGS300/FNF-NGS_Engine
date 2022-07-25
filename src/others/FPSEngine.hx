package others;
import openfl.system.System;
import flixel.math.FlxMath;
import openfl.text.TextField;
import openfl.text.TextFormat;
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#if flash
import openfl.Lib;
#end
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class FPSEngine extends TextField{
	@:noCompletion private var times:Array<Float>;
	@:noCompletion private var currentTime:Float;
	@:noCompletion private var cacheCount:Int;
	public var currentFPS(default, null):Int;
	public function new(x:Float = 0, y:Float = 0, ?Font:Null<String> = null, ?SizeFont:Int = 14, Color:Int = 0x000000){
		super();
		this.x = x;
		this.y = y;
		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat(openfl.utils.Assets.getFont('assets/' + (Font != null ? Font : 'fonts/Highman.ttf')).fontName, SizeFont, Color);
        autoSize = LEFT;
        background = true;
        backgroundColor = 0xFF000000;
        alpha = 0.7;
		multiline = true;
		cacheCount = 0;
		currentTime = 0;
		times = [];
		#if flash
		addEventListener(Event.ENTER_FRAME, function(e){
			var time = Lib.getTimer();
			__enterFrame(time - currentTime);
		});
		#end
	}
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void{
		currentTime += deltaTime;
		times.push(currentTime);
		while (times[0] < currentTime - 1000) times.shift();
		var currentCount = times.length;
		currentFPS = Math.round((currentCount + cacheCount) / 2);
		if (currentCount != cacheCount){
			text = "FPS: " + currentFPS;
            var memoryMegas:Float = 0;
			#if openfl
			memoryMegas = Math.abs(FlxMath.roundDecimal(System.totalMemory / 1000000, 1));
			text += "\nMemory: " + memoryMegas + " MB";
			#end
			textColor = 0xFFFFFFFF;
			if (memoryMegas > 3000 || currentFPS <= 120 / 2) textColor = 0xFFFF0000;
			text += "\nNG'S Engine v" + MainMenuState.engineVersion;
			#if (gl_stats && !disable_cffi && (!html5 || !canvas))
			text += "\ntotalDC: " + Context3DStats.totalDrawCalls();
			text += "\nstageDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE);
			text += "\nstage3DDC: " + Context3DStats.contextDrawCalls(DrawCallContext.STAGE3D);
			#end
		}
		cacheCount = currentCount;
	}
}