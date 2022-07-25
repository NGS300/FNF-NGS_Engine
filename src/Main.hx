package;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import flixel.FlxG;
import openfl.display.Sprite;
import openfl.events.Event;
import others.FPSEngine;
class Main extends Sprite{
	var initialState:Class<FlxState> = TitleState; // The FlxState the game starts with.
	public static var engineMark = true; // Engine Watermark, Hide Small Items.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets
	public static var instance:Main;
	public var fpsShow:FPSEngine;
	var skipSplash:Bool = true; // Whether to skip the flixel splash screen that appears in release mode.
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var framerate:Int = 120; // How many frames per second the game should run at.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.
	public static function dumpCache2(){ CachingState.bitmapData.clear(); }
	public static function main():Void{ Lib.current.addChild(new Main()); }
	public function new(){
		instance = this;
		super();
		(stage != null ? init() : addEventListener(Event.ADDED_TO_STAGE, init));
	}
	private function init(?E:Event):Void{
		if (hasEventListener(Event.ADDED_TO_STAGE)) removeEventListener(Event.ADDED_TO_STAGE, init);
		setupGame();
	}
	public static function dumpCache(){
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()){
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null){
				Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}
		Assets.cache.clear("assets");
		Assets.cache.clear("assets/chart");
	}
	private function setupGame():Void{
		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;
		if (zoom == -1){
			var ratioX:Float = stageWidth / gameWidth;
			var ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}
		#if !debug
			#if SKIP_ITEM_INITIATION
				initialState = TitleState;
			#else
				initialState = CachingState;
			#end
		#end
		#if !mobile
			fpsShow = new FPSEngine(-1, 0, null, 14, 0xFFFFFF);
		#end
		addChild(new FlxGame(gameWidth, gameHeight, initialState, zoom, framerate, framerate, skipSplash, startFullscreen));
		#if !mobile
			addChild(fpsShow);
			toggleFPS(FlxG.save.data.fpsAndMemory);
			setYFps(Client.Public.downscroll ? 0 : 675);
		#end
	}
	public function toggleFPS(fpsEnabled:Bool):Void{
		fpsShow.visible = fpsEnabled;
	}
	public function getFPS():Float{
		return fpsShow.currentFPS;
	}
	public function setYFps(posY:Float){
		fpsShow.y = posY;
	}
}