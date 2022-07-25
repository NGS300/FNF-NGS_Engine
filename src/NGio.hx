package;
import flixel.FlxG;
import flixel.util.FlxSignal;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.events.Response;
import io.newgrounds.objects.events.Result.GetCurrentVersionResult;
import lime.app.Application;
using StringTools;
class NGio{
	public static var ngScoresLoaded(default, null):FlxSignal = new FlxSignal();
	public static var ngDataLoaded(default, null):FlxSignal = new FlxSignal();
	public static var scoreboardArray:Array<Score> = [];
	public static var scoreboardsLoaded:Bool = false;
	public static var GAME_VER_NUMS:String = '';
	public static var gotOnlineVer:Bool = false;
	public static var isLoggedIn:Bool = false;
	public static var GAME_VER:String = "";
	public static function noLogin(api:String){
		GAME_VER = "v" + Application.current.meta.get('version');
		NG.create(api);
		new FlxTimer().start(2, function(tmr:FlxTimer){
			var call = NG.core.calls.app.getCurrentVersion(GAME_VER).addDataHandler(function(response:Response<GetCurrentVersionResult>){
				if (response.result != null){
					GAME_VER = response.result.data.currentVersion;
					GAME_VER_NUMS = GAME_VER.split(" ")[0].trim();
					gotOnlineVer = true;
				}
			});
			call.send();
		});
	}
	public function new(api:String, encKey:String, ?sessionId:String){
		NG.createAndCheckSession(api, sessionId);
		NG.core.verbose = true;
		NG.core.initEncryption(encKey);
		trace(NG.core.attemptingLogin);
		if (NG.core.attemptingLogin)
			NG.core.onLogin.add(onNGLogin);
		else
			NG.core.requestLogin(onNGLogin);
	}
	function onNGLogin():Void{
		isLoggedIn = true;
		FlxG.save.data.sessionId = NG.core.sessionId;
		NG.core.requestMedals(onNGMedalFetch);
		NG.core.requestScoreBoards(onNGBoardsFetch);
		ngDataLoaded.dispatch();
	}
	function onNGMedalFetch():Void{
	}
	function onNGBoardsFetch():Void{
	}
	inline static public function postScore(score:Int = 0, song:String){
		if (isLoggedIn){
			for (id in NG.core.scoreBoards.keys()){
				var board = NG.core.scoreBoards.get(id);
				if (song == board.name) board.postScore(score, "Uhh meow?");
			}
		}
	}
	function onNGScoresFetch():Void{
		scoreboardsLoaded = true;
		ngScoresLoaded.dispatch();
	}
	inline static public function logEvent(event:String){
		NG.core.calls.event.logEvent(event).send();
	}
	inline static public function unlockMedal(id:Int){
		if (isLoggedIn){
			var medal = NG.core.medals.get(id);
			if (!medal.unlocked)
				medal.sendUnlock();
		}
	}
}