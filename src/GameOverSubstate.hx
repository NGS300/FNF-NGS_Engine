package;
import flixel.math.FlxMath;
import flixel.FlxCamera;
import flixel.util.FlxStringUtil;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
using StringTools;
class GameOverSubstate extends MusicBeatSubstate{
	public static var BFName:Null<String> = null;
	public static var mapSuffix:String = "";
	public static var BFSize:Float;
	private var deathCam:FlxCamera;
	private var camGame:FlxCamera;
	var isEnding:Bool = false;
	var camFollow:FlxObject;
	var gameOverTxt:Text;
	var bf:Boyfriend;
	public function new(x:Float, y:Float){
		super();
		camGame = new FlxCamera();
		deathCam = new FlxCamera();
		deathCam.bgColor.alpha = 0;
		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(deathCam);
		FlxCamera.defaultCameras = [camGame];
		/*if (PlayState.SONG.player1 == PlayState.SONG.player1) // Future
			BFName = PlayState.SONG.player1;
		if (bf.gameOverDead != ''){
			BFSize = deathSize;
			mapSuffix = complementShit;
			if (PlayState.SONG.player1 == bf.gameOverDead)
				BFName = bf.gameOverDead;
		}else{*/
			mapSuffix = (!PlayState.instance.boyfriend.curCharacter.endsWith('-pixel') ? '' : '-pixel');
			BFSize = (!PlayState.instance.boyfriend.curCharacter.endsWith('-pixel') ? 1 : TrackMap.daPixelZoom);
			switch ((FlxG.save.data.charSelect != 1 ? PlayState.SONG.player1 : CharacterSelect.charSelected)){ // BF Deaths
				default: BFName = 'bf';
				case 'bf-pixel': BFName = 'bf-pixel-dead';
				case 'bf-holding-the-gf': BFName = 'bf-holding-the-gf';
				case 'bf-50Years-Phase1' | 'bf-50Years-Phase2': BFName = 'bf-50Years-Phase1';
				case 'bf-50Years-Phase3': BFName = 'bf-50Years-Phase3';
			}
		Conductor.songPosition = 0;
		bfDead(x, y);
		camFollow = new FlxObject(bf.getGraphicMidpoint().x, bf.getGraphicMidpoint().y, 1, 1);
		add(camFollow);
		Actions.PlaySound('missSound/lose/fnf_loss_sfx' + mapSuffix, 'character');
		Conductor.changeBPM(100);
		FlxG.camera.scroll.set();
		FlxG.camera.target = null;
		Actions.PlayCharAnim(bf, 'firstDeath');
		var recordMark:String = 'Deaths: ' + PlayState.death
		+ ' | Score: ' + PlayState.instance.chartScore
		+ ' | Misses: ' + PlayState.misses
		+ ' | Accuracy: ' + CoolUtil.floatDecimals(PlayState.instance.accuracy, 2) + "%"
		+ ' | Combo: ' + PlayState.combo
		+ ' | HighestCombo: ' + PlayState.highestCombo
		+ ' | Rating: ' + Rating.getRatings(PlayState.instance.accuracy);
		var recordTxt:Text = new Text(recordMark, 0, (mapSuffix != '-pixel' ? FlxG.height * 0.85 : FlxG.height * 0.765), (mapSuffix != '-pixel' ? 22 : 20));
		recordTxt.format((mapSuffix != '-pixel' ? "Highman" : "Windows Regular"), (mapSuffix != '-pixel' ? 24 : 20), 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		recordTxt.screenCenter(X);
		recordTxt.cameras = [deathCam];
		gameOverTxt = new Text('GAME OVER', 0, ((mapSuffix != '-pixel' ? 50 : 70)), 45);
		gameOverTxt.format((mapSuffix != '-pixel' ? "Highman" : "Windows Regular"), 45, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		gameOverTxt.screenCenter(X);
		gameOverTxt.cameras = [deathCam];
		var trackInfo:Text = new Text('Song: ' + PlayState.SONG.song 
		+ ' - Difficulty: ' + PlayState.instance.mainDifficultyText + ' - ' 
		+ (!Client.Public.endless ? 'Timeleft: ' + FlxStringUtil.formatTime(PlayState.instance.getCum) 
		: 'Timeleft of Loop: ' + FlxStringUtil.formatTime(PlayState.instance.getCum) + ' - Loops: ' + PlayState.loops), 0, gameOverTxt.y + 50, 25);
		trackInfo.format((mapSuffix != '-pixel' ? "Highman" : "Windows Regular"), 26, 0xFFFFFFFF, 0xFF000000, CENTER, 'OUTLINE');
		trackInfo.screenCenter(X);
		trackInfo.cameras = [deathCam];
		if (FlxG.save.data.deathStats){
			add(recordTxt);
			add(gameOverTxt);
			add(trackInfo);
		}
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (controls.ACCEPT) endBalls();
		if (FlxG.sound.music.playing) Conductor.songPosition = FlxG.sound.music.time;
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.curFrame == 12) FlxG.camera.follow(camFollow, LOCKON, 0.01);
		if (bf.animation.curAnim.name == 'firstDeath' && bf.animation.curAnim.finished) Actions.PlayTrack('lose/gameOver' + mapSuffix, 'character');
		if (controls.BACK){
			PlayState.death = 0;
			FlxG.sound.music.stop();
			Actions.States('Switch', (PlayState.stateShit != 'StoryMode' ? new FreeplayState() : new StoryMenuState()));
		}
		if (FlxG.save.data.camerazoom){
			FlxG.camera.zoom = FlxMath.lerp(1.05, FlxG.camera.zoom, 0.95);
			deathCam.zoom = FlxMath.lerp(1, deathCam.zoom, 0.95);
		}
	}
	override function beatHit(){
		super.beatHit();
		FlxG.log.add(curBeat);
		if (FlxG.save.data.camerazoom && curBeat % 2 == 1 && !isEnding){
			FlxG.camera.zoom += 0.1;
			deathCam.zoom += 0.1;
		}
	}
	function endBalls():Void{
		if (!isEnding){
			isEnding = true;
			FlxG.sound.music.stop();
			gameOverTxt.text = 'RETURNING';
			Actions.PlayCharAnim(bf, 'deathConfirm', true);
			Actions.PlayTrack('lose/gameOverEnd' + mapSuffix, 'character');
			new FlxTimer().start(0.75, function(tmr:FlxTimer){
				Actions.Fade(deathCam, FlxColor.BLACK, 2.5, false, function(){
					Actions.States('LoadSwitch', new PlayState());
				});
			});
		}
	}
	function bfDead(X:Float, Y:Float){
		bf = new Boyfriend(X, Y, BFName);
		bf.antialiasing = (mapSuffix == '-pixel' ? false : bf.antialiasing);
		if (BFSize != 1){
			bf.setGraphicSize(Std.int(bf.width * BFSize));
			bf.updateHitbox();
		}
		add(bf);
	}
}