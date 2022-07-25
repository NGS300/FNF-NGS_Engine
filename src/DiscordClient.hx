package;
import flixel.FlxG;
import Sys.sleep;
import discord_rpc.DiscordRpc;
using StringTools;
class DiscordClient{
	public static function changePresence(details:String, state:Null<String>, ?smallImageKey : String, ?hasStartTimestamp : Bool, ?endTimestamp: Float){
		var startTimestamp:Float = if (hasStartTimestamp) Date.now().getTime() else 0;
		if (endTimestamp > 0) endTimestamp = startTimestamp + endTimestamp;
		DiscordRpc.presence({
			details: details,
			state: state,
			largeImageKey: 'enginelogo',
			largeImageText: "Friday Night Funkin': NG'S Engine",
			smallImageKey : smallImageKey,
			startTimestamp : Std.int(startTimestamp / 1000),
            endTimestamp : Std.int(endTimestamp / 1000)
		});
	}
	public function new(){
		trace("Discord Client Starting...");
		DiscordRpc.start({
			clientID: "966024519271710780",
			onReady: onReady,
			onError: onError,
			onDisconnected: onDisconnected
		});
		trace("Discord Client started.");
		while (true){
			DiscordRpc.process();
			sleep(2);
		}
		DiscordRpc.shutdown();
	}
	static function onReady(){
		DiscordRpc.presence({
			details: "In Title",
			state: null,
			largeImageKey: 'enginelogo',
			largeImageText: "Friday Night Funkin': NG'S Engine"
		});
	}
	public static function initialize(){
		var DiscordDaemon = sys.thread.Thread.create(() ->{
			new DiscordClient();
		});
		trace("Discord Client Initialized");
	}
	static function onError(_code:Int, _message:String){
		trace('Error! $_code : $_message');
	}
	static function onDisconnected(_code:Int, _message:String){
		trace('Disconnected! $_code : $_message');
	}
	public static function shutdown(){
		DiscordRpc.shutdown();
	}
	public static function globalPresence(State:String, ?SubState:String = null, ?Type:String = null){ // Updating Discord Rich Presence on States
		#if desktop
			switch (State){
				case 'PlayState': switch (SubState){
					case 'Create':
						changePresence(PlayState.instance.detailsText, PlayState.SONG.song + " (" + PlayState.instance.mainDifficultyText + ")");
					case 'Death':
						changePresence("Game Over - " + PlayState.instance.detailsText, PlayState.SONG.song + " (" + PlayState.instance.mainDifficultyText + ")");
					case 'StartCountdown':
						if (PlayState.loops == 0)
							changePresence(PlayState.instance.detailsText + (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song) + " (" + PlayState.instance.mainDifficultyText + ")", null);
						else if (Client.Public.endless && PlayState.loops >= 1)
							changePresence("Endless " + PlayState.instance.detailsText + (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song) + " (" + PlayState.instance.mainDifficultyText + ")", 'Loops: ' + PlayState.loops);
					case 'OpenSubState':
						if (PlayState.loops == 0)
							changePresence(PlayState.instance.detailsPausedText, (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song) + " (" + PlayState.instance.mainDifficultyText + ")", null, true);
						else if (Client.Public.endless && PlayState.loops >= 1)
							changePresence("Endless " + PlayState.instance.detailsPausedText + (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song) + " (" + PlayState.instance.mainDifficultyText + ")", "\nLoops: " + PlayState.loops, null, true);
					case 'CloseSubState':
						changePresence(PlayState.instance.detailsText, PlayState.SONG.song + " (" + PlayState.instance.mainDifficultyText + ")", null, (!PlayState.instance.startTimer.finished ? null : true), (!PlayState.instance.startTimer.finished ? null : PlayState.instance.songLength - Conductor.songPosition));
				}
				case 'MainMenuState':
					changePresence("In the MainMenu", null);
				case 'StoryMenuState':
					changePresence("In StoryMode Menu", '\nSelected Week: ' + StoryMenuState.curDickStory);
				case 'FreeplayState':
					changePresence("In the Freeplay Menu", '\nSelected Track: ' + FreeplayState.instance.songs[FreeplayState.instance.curSelected].songName);
				case 'OptionsMenu':
					changePresence("In Settings", null, null, true);
				case 'ChartingState':
					changePresence("Chart Editor", '\nTrack Charting: ' + PlayState.SONG.song, null, true);
				case 'PlayStepEvents':
					PlayState.instance.songLength = FlxG.sound.music.length;
					if (PlayState.loops == 0)
						changePresence(PlayState.instance.detailsText + (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song.toLowerCase())  + " (" + PlayState.instance.mainDifficultyText + ")", null, null, true, PlayState.instance.songLength - Conductor.songPosition);
					else if (Client.Public.endless && PlayState.loops >= 1)
						changePresence("Endless " + PlayState.instance.detailsText + (PlayState.stateShit == 'Secret' ? "" : " " + PlayState.SONG.song.toLowerCase()) + " (" + PlayState.instance.mainDifficultyText + ")", 'Loops: ' + PlayState.loops, null, true, PlayState.instance.songLength - Conductor.songPosition);
			}
		#end
	}
}