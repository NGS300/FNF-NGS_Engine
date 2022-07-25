package;
import openfl.media.Sound;
import lime.utils.Assets;
import flixel.graphics.FlxGraphic;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import openfl.utils.AssetType;
import openfl.utils.Assets as OpenFlAssets;
class Paths{
	inline public static var SoundComplement = #if web "mp3" #else "ogg" #end;
	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];
	public static var localTrackedAssets:Array<String> = [];
	static public var Target:String;
	static var assetsType:AssetType;
	static var currentLevel:String;
	static var pathType:String;
	static public function setCurrentLevel(name:String){
		currentLevel = name.toLowerCase();
	}
	public static function clearTraceSounds(){
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys()){
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key)){
				openfl.Assets.cache.removeBitmapData(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}
		for (key in currentTrackedSounds.keys()){
			if (!localTrackedAssets.contains(key) && key != null){
				Assets.cache.clear(key);
				currentTrackedSounds.remove(key);
			}
		}
	}
	static public function getPath(file:String, type:AssetType, ?library:Null<String>){
		if (library != null) return (library == "preload" || library == "default" ? 'assets/$file' : '$library:assets/$library/$file');
		if (currentLevel != null){
			var levelPath = '$currentLevel:assets/$currentLevel/$file';
			if (OpenFlAssets.exists(levelPath, type)) return levelPath;
			levelPath = 'shared:assets/shared/$file';
			if (OpenFlAssets.exists(levelPath, type)) return levelPath;
		}
		return 'assets/$file';
	}
	inline static public function file(file:String, type:AssetType = TEXT, ?library:String){
		return getPath(file, type, library);
	}



	// Text Push
	inline static public function txt(key:String, ?library:String){
		return getPath('data/$key.txt', TEXT, library);
	}
	inline static public function txtAny(key:String, ?library:String){
		return getPath('$key.txt', TEXT, library);
	}



	// Json Push
	inline static public function json(key:String, ?library:String){
		return getPath('chart/$key.json', TEXT, library);
	}
	inline static public function jsonAny(key:String, ?library:String){
		return getPath('$key.json', TEXT, library);
	}


	// Exist?
	inline static public function doesTextExist(path:String){
		return OpenFlAssets.exists(path, AssetType.TEXT);
	}
	inline static public function doesImageExist(path:String){
		return OpenFlAssets.exists(path, AssetType.IMAGE);
	}
	static public function doesSoundExist(path:String, ?isSound:Bool = true){
		return OpenFlAssets.exists(path, (isSound ? AssetType.SOUND : AssetType.MUSIC));
	}

	
	// Font
	inline static public function font(key:String){
		return 'assets/fonts/$key';
	}
	inline static public function font2(Font:String, ?FontFileExtension:String = 'TFF'){
		return 'assets/fonts/' + fontExtension('$Font', FontFileExtension);
	}


	// Inst & Vocal
	#if NEW_TYPE_CHECK_SONG // NEW TYPE
		inline static public function voices(song:String):Sound{
			return returnSound('chart', '${song.toLowerCase()}/Voices');
		}
		inline static public function inst(song:String):Sound{
			return returnSound('chart', '${song.toLowerCase()}/Inst');
		}
	#else // OLD TYPE
		inline static public function voices(song:String){
			return 'assets/chart/${song.toLowerCase()}/Voices.$SoundComplement';
		}
		inline static public function inst(song:String){
			return 'assets/chart/${song.toLowerCase()}/Inst.$SoundComplement';
		}
	#end


	// Path Images and Extesion
	inline static public function getSparrowAtlas(key:String, ?library:String){
		return FlxAtlasFrames.fromSparrow(loadImage(key, library), file('images/$key.xml', library));
	}
	inline static public function getPackerAtlas(key:String, ?library:String){
		return FlxAtlasFrames.fromSpriteSheetPacker(loadImage(key, library), file('images/$key.txt', library));
	}


	// Icon Paths
	inline static public function pushFileIcon(folder:String, char:String){
		return getPath('images/icons/$folder/$char.png', IMAGE, 'character');
	}
	inline static public function getIconSparrowAtlas(folder:String, key:String){
		return FlxAtlasFrames.fromSparrow(loadImage('icons/$folder/$key', 'character'), file('images/icons/$folder/$key.xml', 'character'));
	}

	// USELESS
	inline static public function type(filePath:String, ?extesionPath:String = null, ?TypePath:String = 'TEXT', ?Library:String = null, ?customExtesionPath:String, ?FreePath:Bool = false){
		if (TypePath != null){
			switch (TypePath){
				case 'image' | 'IMAGE':
					assetsType = IMAGE;
					if (extesionPath != null){
						switch (extesionPath){
							case 'custom' | 'CUSTOM' : pathType = '$filePath.$customExtesionPath';
							case 'png' | 'PNG': pathType = '$filePath.png';
							case 'jpg' | 'JPG': pathType = '$filePath.jpg';
						}
					}else
						pathType = '$filePath.png';
				case 'sound' | 'music' | 'SOUND' | 'MUSIC':
					if (TypePath == 'sound' || TypePath == 'SOUND')
						assetsType = SOUND;
					else if (TypePath == 'music' || TypePath == 'MUSIC')
						assetsType = MUSIC;
					if (extesionPath != null){
						switch (extesionPath){
							case 'custom' | 'CUSTOM' : pathType = '$filePath.$customExtesionPath';
							case 'auto' | 'AUTO': pathType = '$filePath.$SoundComplement';
							case 'mp3' | 'MP3': pathType = '$filePath.mp3';
							case 'ogg' | 'OGG': pathType = '$filePath.ogg';
							case 'wav' | 'WAV': pathType = '$filePath.wav';
						}
					}else
						pathType = '$filePath.$SoundComplement';
				case 'binary' | 'BINARY':
					assetsType = BINARY;
					if (extesionPath != null){
						switch (extesionPath){
							case 'custom' | 'CUSTOM' : pathType = '$filePath.$customExtesionPath';
							case 'mp4' | 'MP4': pathType = '$filePath.mp4';
						}
					}else
						pathType = '$filePath.mp4';
				case 'text' | 'TEXT':
					assetsType = TEXT;
					if (extesionPath != null){
						switch (extesionPath){
							case 'custom' | 'CUSTOM' : pathType = '$filePath.$customExtesionPath';
							case 'txt' | 'text' | 'TXT' | 'TEXT': pathType = '$filePath.txt';
							case 'json' | 'JSON': pathType = '$filePath.json';
							case 'xml' | 'XML': pathType = '$filePath.xml';
						}
					}else
						pathType = '$filePath.txt';
				case 'font' | 'FONT':
					assetsType = FONT;
					if (extesionPath != null)
						fontExtension('$filePath', extesionPath, '$customExtesionPath');
					else
						fontExtension('$filePath', 'TFF');
				case 'movie_clip' | 'MOVIE_CLIP':
					assetsType = MOVIE_CLIP;
					if (extesionPath != null){
						switch (extesionPath){
							case 'custom' | 'CUSTOM' : pathType = '$filePath.$customExtesionPath';
							case 'swf' | 'SWF': pathType = '$filePath.swf';
						}
					}else
						pathType = '$filePath.swf';
			}
		}
		if (!FreePath){
			if (TypePath != null)
				return getPath('$filePath' + (extesionPath != null ? '.$extesionPath' : ''), assetsType, Library);
			else
				return '$filePath' + (extesionPath != null ? '.$extesionPath' : '');
		}else
			return '$filePath' + (extesionPath != null ? '.$extesionPath' : '');
	}
	inline static public function fontExtension(Font:String, ?FontFileExtension:String = 'TFF', ?CustomExtesion:String = null){
		switch (FontFileExtension){
			case 'custom' | 'CUSTOM' : Target = '$Font.$CustomExtesion';
			case 'none' | 'null' | 'NONE' | 'NULL':  Target = '$Font';
			case 'jfproj' | 'JFPROJ': Target = '$Font.jfproj';
			case 'woff2' | 'WOFF2': Target = '$Font.woff2';
			case 'woff' | 'WOFF': Target = '$Font.woff';
			case 'ttf' | 'TTF': Target = '$Font.ttf';
			case 'otf' | 'OTF': Target = '$Font.otf';
			case 'fnt' | 'FNT': Target = '$Font.fnt';
			case 'vfb' | 'VFB': Target = '$Font.vfb';
			case 'pfb' | 'PFB': Target = '$Font.pfb';
			case 'sfd' | 'SFD': Target = '$Font.sfd';
			case 'fot' | 'FOT': Target = '$Font.fot';
			case 'vlw' | 'VLW': Target = '$Font.vlw';
			case 'pfa' | 'PFA': Target = '$Font.pfa';
			case 'etx' | 'ETX': Target = '$Font.etx';
		}
		return Target;
	}
	static public function loadImage(key:String, ?library:String):FlxGraphic{
		var path = image(key, library);
		if (CachingState.bitmapData != null && CachingState.bitmapData.exists(key))
			return CachingState.bitmapData.get(key);
		if (OpenFlAssets.exists(path, IMAGE)){
			var bitmap = OpenFlAssets.getBitmapData(path);
			return FlxGraphic.fromBitmapData(bitmap);
		}else
			return null;
	}
	public static function returnGraphic(key:String, ?library:String){
		var path = getPath('images/$key.png', IMAGE, library);
		var newGraphic:FlxGraphic = FlxG.bitmap.add(path, false, path);
		if (!currentTrackedAssets.exists(path))
			currentTrackedAssets.set(path, newGraphic);
		localTrackedAssets.push(path);
		return currentTrackedAssets.get(path);
	}
	public static function returnSound(path:String, key:String, ?library:String){
		var gottenPath:String = getPath('$path/$key.$SoundComplement', SOUND, library);	
		gottenPath = gottenPath.substring(gottenPath.indexOf(':') + 1, gottenPath.length);
		if (!currentTrackedSounds.exists(gottenPath)) 
			currentTrackedSounds.set(gottenPath, OpenFlAssets.getSound(getPath('$path/$key.$SoundComplement', SOUND, library)));
		localTrackedAssets.push(gottenPath);
		return currentTrackedSounds.get(gottenPath);
	}
	static public function sound(key:String, ?library:String){
		return returnSound('sounds', key, library);
	}
	inline static public function soundRandom(key:String, min:Int, max:Int, ?library:String){
		return sound(key + FlxG.random.int(min, max), library);
	}
	inline static public function music(key:String, ?library:String){
		return returnSound('music', key, library);
	}
	inline static public function videoMP4(key:String, ?library:String){
		return getPath('videos/$key.mp4', BINARY, library);
	}
	inline static public function videoMP4Any(key:String, ?library:String){
		return getPath('$key.mp4', BINARY, library);
	}
	inline static public function image(key:String, ?library:String){
		return getPath('images/$key.png', IMAGE, library);
	}
}