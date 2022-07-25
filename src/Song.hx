package;
import Section.SwagSection;
import haxe.Json;
import lime.utils.Assets;
using StringTools;
typedef SwagSong ={
	var notes:Array<SwagSection>;
	var girlfriend:String;
	var needsVoices:Bool;
	var validScore:Bool;
	var fiveNotes:Bool;
	var player1:String;
	var player2:String;
	var artist:String;
	var song:String;
	var speed:Float;
	var bpm:Int;
}
class Song{
	public var notes:Array<SwagSection>;
	public var girlfriend:String = 'gf';
	public var needsVoices:Bool = true;
	public var player2:String = 'dad';
	public var fiveNotes:Bool = false;
	public var player1:String = 'bf';
	public var artist:String = null;
	public var speed:Float = 1;
	public var song:String;
	public var bpm:Int;
	public function new(song, notes, bpm){
		this.notes = notes;
		this.song = song;
		this.bpm = bpm;
	}
	public static function loadFromJson(jsonInput:String, ?folder:String):SwagSong{
		var rawJson = Assets.getText(Paths.json(folder.toLowerCase() + '/' + jsonInput.toLowerCase())).trim();
		while (!rawJson.endsWith("}")) rawJson = rawJson.substr(0, rawJson.length - 1);
		return parseJSONshit(rawJson);
	}
	public static function parseJSONshit(rawJson:String):SwagSong{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}