package;
import flixel.math.FlxMath;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import lime.app.Promise;
import lime.app.Future;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import haxe.io.Path;
class LoadingState extends MusicBeatState{
	inline static var MIN_TIME = 1.0;
	var callbacks:MultiCallback;
	var isOldLogo:Bool = false;
	var targetShit:Float = 0;
	var charDance:FlxSprite;
	var stopMusic = false;
	var ngeLogo:FlxSprite;
	var loadBar:FlxSprite;
	var target:FlxState;
	var randomLogo = 0;
	var randomChar = 0;
	function new(target:FlxState, stopMusic:Bool){
		super();
		this.target = target;
		this.stopMusic = stopMusic;
	}
	override function create(){
		randomLogo = FlxG.random.int(0, 8);
		randomChar = FlxG.random.int(0, 3);
		isOldLogo = FlxG.random.bool(50);
		StateImage.BGSMenus('TittleBG', add);
		switch (randomLogo){ // Show Random Logos
			case 0: // CuanRemix Logo
				ngeLogo = new NewSprite(432.325, -52.120, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpinMain'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.8, 0.8);
			case 1: // Juniorxefao Logo
				ngeLogo = new NewSprite(635, -55, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin1'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.77, 0.77);
			case 2: // KkpassaroxX Logo
				ngeLogo = new NewSprite(645, (!isOldLogo ? -50 : -55), 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin20' : 'NGSLogoBumpin2Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.7765, 0.7765);
			case 3: // Maty Logo
				ngeLogo = new NewSprite((!isOldLogo ? 570 : 630), (!isOldLogo ? -225 : -25), 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin30' : 'NGSLogoBumpin3Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.69, 0.69);
			case 4: // Jenvi Logo
				ngeLogo = new NewSprite(495, -5, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin4'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.745, 0.745);
			case 5: // Tiozão Logo
				ngeLogo = new NewSprite(655, -70, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin5'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.6436, 0.6436);
			case 6: // Júpiterzim Logo
				ngeLogo = new NewSprite((!isOldLogo ? 480 : 495), -157.75, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, [(!isOldLogo ? 'NGSLogoBumpin60' : 'NGSLogoBumpin6Old')], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.775, 0.775);
			case 7: // Marshverso Logo
				ngeLogo = new NewSprite(690, 5, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin7'], 24, true);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.5, 0.5);
			case 8: // Maty Logo Promo
				ngeLogo = new NewSprite(540, -140, 'TitleShit/Logos/NGELogos', null, true, 1, null, null, ['NGSLogoBumpin8'], 24, true, false);
				NewSprite.SpriteComplement.setVariables(ngeLogo, true, null, null, 0.69, 0.69);
		}
		FlxTween.angle(ngeLogo, -10, 10, 2.0, {ease: FlxEase.quadInOut, type: PINGPONG});
		switch (randomChar){ // Show Random Characters
			case 0: // .ng | NGS300
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['ng_idle'], 24, true);
				charDance.x -= 475;
				charDance.y += 7;
			case 1: // KkpassaroxX
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['KkpassaroxX_idle'], 24, true);
				charDance.x -= 450;
				charDance.y -= 95;
			case 2: // REX | Juniorxefao
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['rex_idle'], 24, true);
				charDance.x -= 452;
				charDance.y += 37.25;
			case 3: // MATY
				charDance = new NewSprite(FlxG.width * 0.4, FlxG.height * 0.07, 'TitleShit/Tittle_Characters_Assets', null, true, 1, null, null, ['maty_idle'], 24, true);
				charDance.x -= 450;
				charDance.y += 11;
		}
		add(charDance);
		add(ngeLogo);

		loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, -59694);
		loadBar.screenCenter(X);
		loadBar.antialiasing = Client.Public.antialiasing;
		add(loadBar);
		
		initSongsManifest().onComplete( function (lib){
			callbacks = new MultiCallback(onLoad);
			var introComplete = callbacks.add("introComplete");
			getSongPath();
			if (PlayState.SONG.needsVoices) getVocalPath();
			checkLibrary("shared");
			Actions.Fade(FlxG.camera, FlxG.camera.bgColor, 0.5, true);
			new FlxTimer().start(0.5 + MIN_TIME, function(_) introComplete());
		});
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (callbacks != null){
			targetShit = FlxMath.remapToRange(callbacks.numRemaining / callbacks.length, 1, 0, 0, 1);
			loadBar.scale.x += 950 * (targetShit - loadBar.scale.x); // 0.5
		}
	}
	static function getSongPath(){
		return Paths.inst(PlayState.SONG.song);
	}
	static function getVocalPath(){
		return Paths.voices(PlayState.SONG.song);
	}
	inline static public function loadAndSwitchState(target:FlxState, stopMusic = false){
		FlxG.switchState(getNextState(target, stopMusic));
	}
	override function destroy(){
		super.destroy();
		callbacks = null;
	}
	function onLoad(){
		if (stopMusic && FlxG.sound.music != null) FlxG.sound.music.stop();
		Actions.States('Switch', target);
	}
	static function getNextState(target:FlxState, stopMusic = false):FlxState{
		Paths.setCurrentLevel("week" + StoryMenuState.storyWeek);
		return new LoadingState(target, stopMusic);
		if (stopMusic && FlxG.sound.music != null) FlxG.sound.music.stop();
		return target;
	}
	function checkLibrary(library:String){
		trace(Assets.hasLibrary(library));
		if (Assets.getLibrary(library) == null){
			@:privateAccess
			if (!LimeAssets.libraryPaths.exists(library)) throw "Missing library: " + library;
			var callback = callbacks.add("library:" + library);
			Assets.loadLibrary(library).onComplete(function (_) { callback(); });
		}
	}
	static function initSongsManifest(){
		var id = "maps";
		var promise = new Promise<AssetLibrary>();
		var library = LimeAssets.getLibrary(id);
		if (library != null) return Future.withValue(library);
		var path = id;
		var rootPath = null;
		@:privateAccess
		var libraryPaths = LimeAssets.libraryPaths;
		if (libraryPaths.exists(id)){
			path = libraryPaths[id];
			rootPath = Path.directory(path);
		}else{
			if (StringTools.endsWith(path, ".bundle")){
				rootPath = path;
				path += "/library.json";
			}else{
				rootPath = Path.directory(path);
			}
			@:privateAccess
			path = LimeAssets.__cacheBreak(path);
		}
		AssetManifest.loadFromFile(path, rootPath).onComplete(function(manifest){
			if (manifest == null){
				promise.error("Cannot parse asset manifest for library \"" + id + "\"");
				return;
			}
			var library = AssetLibrary.fromManifest(manifest);
			if (library == null){
				promise.error("Cannot open library \"" + id + "\"");
			}else{
				@:privateAccess
				LimeAssets.libraries.set(id, library);
				library.onChange.add(LimeAssets.onChange.dispatch);
				promise.completeWith(Future.withValue(library));
			}
		}).onError(function(_){
			promise.error("There is no asset library with an ID of \"" + id + "\"");
		});
		return promise.future;
	}
}
class MultiCallback{
	var unfired = new Map<String, Void->Void>();
	public var numRemaining(default, null) = 0;
	public var length(default, null) = 0;
	var fired = new Array<String>();
	public var callback:Void->Void;
	public var logId:String = null;
	public function new (callback:Void->Void, logId:String = null){
		this.callback = callback;
		this.logId = logId;
	}
	public function add(id = "untitled"){
		id = '$length:$id';
		length++;
		numRemaining++;
		var func:Void->Void = null;
		func = function (){
			if (unfired.exists(id)){
				unfired.remove(id);
				fired.push(id);
				numRemaining--;
				if (logId != null) log('fired $id, $numRemaining remaining');
				if (numRemaining == 0){
					if (logId != null) log('all callbacks fired');
					callback();
				}
			}else
				log('already fired $id');
		}
		unfired[id] = func;
		return func;
	}
	inline function log(msg):Void{
		if (logId != null) trace('$logId: $msg');
	}
	public function getFired() return fired.copy();
	public function getUnfired() return [for (id in unfired.keys()) id];
}