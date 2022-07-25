import flixel.FlxCamera;
import flixel.tweens.FlxEase;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.FlxObject;
import Song.SwagSong;
class Camera extends MusicBeatState{
	public static var camZooming:Bool = false;
	// Camera Move Items
	public static var camFollowMove:Bool = true;
	public static var cameramove:Bool = false;
	public static var camX:Int = 0;
	public static var camY:Int = 0;
	public static var bfcamX:Int = 0;
	public static var bfcamY:Int = 0;
	public static function cameraMakeOn(State:String, TrackLower:String){ // Camera Beating to Turn On or OFF
		switch (State){
			case 'PlayStateCreate': switch (TrackLower){
				default: camZooming = false;
				case 'stress' | 'tanpowder': camZooming = FlxG.save.data.camerazoom;
			}
			case 'OpponentSings': switch (TrackLower){
				default: if (!camZooming) camZooming = FlxG.save.data.camerazoom;
				case 'tutorial': camZooming = false;
			}
		}
	}
    public static function cameraZooming(State:String, Force:Bool, ?beat:Int){ // Camera Zooms Bops
        if (Force){ switch (State){
				case 'PlayBeatEvents':
					if (FlxG.camera.zoom < 1.35 && beat % 4 == 0) PlayStateZoom(0.06); // is Cam Zooming Lol
				case 'PlayStateUpdate':
					FlxG.camera.zoom = FlxMath.lerp(TrackMap.camZoom, FlxG.camera.zoom, 0.95);
					PlayState.camNOTE.zoom = FlxMath.lerp(1, PlayState.camNOTE.zoom, 0.95);
					PlayState.camHUD.zoom = FlxMath.lerp(1, PlayState.camHUD.zoom, 0.95);
					PlayState.laneCamera.zoom = FlxMath.lerp(1, PlayState.laneCamera.zoom, 0.95);
			}
        }
    }
    public static function cameraBeating(){
    }
    public static function cameraSection(SONG:SwagSong, camFollow:FlxObject, step:Int, beat:Int, opponent:Character, gf:Character, bf:Character){ // Camera Player Switch in Sections
        if (PlayState.instance.generatedMusic && SONG.notes[Std.int(step / 16)] != null){
			if (camFollowMove){
                if (!SONG.notes[Std.int(step / 16)].mustHitSection){
                    camFollow.setPosition(opponent.getMidpoint().x + 150, opponent.getMidpoint().y - 100);
					if (opponent.getCharPointX != 0) camFollow.x = opponent.getMidpoint().x + opponent.getCharPointX;
					if (opponent.getCharPointY != 0) camFollow.y = opponent.getMidpoint().y + opponent.getCharPointY;
					switch (opponent.curCharacter){ // Place You Char Here to Work CamMove :D
						case 'pico':
							camFollow.x = opponent.getMidpoint().x + 300;
							camFollow.y = opponent.getMidpoint().y - 50;
					}
                }else{
                    camFollow.setPosition(bf.getMidpoint().x - 100, bf.getMidpoint().y - 100);
					if (bf.curCharacter == "bf"){
						if (StoryMenuState.storyWeek == 7)
							camFollow.y = bf.getMidpoint().y - 145;
						else{
							camFollow.x = (bf.getCharPointX == 0 ? bf.getMidpoint().x - 138 : bf.getMidpoint().x - 138 + bf.getCharPointX);
							camFollow.y = (bf.getCharPointY == 0 ? bf.getMidpoint().y - 140 : bf.getMidpoint().y - 140 + bf.getCharPointY);
						}
					}else{
						if (bf.getCharPointX != 0) camFollow.x = bf.getMidpoint().x + bf.getCharPointX;
						if (bf.getCharPointY != 0) camFollow.y = bf.getMidpoint().y + bf.getCharPointY;
					}
					switch (TrackMap.curMap){
						case 'spooky':
							camFollow.y = bf.getMidpoint().y - 125;
						case 'limo':
							camFollow.x = bf.getMidpoint().x - 300;
						case 'mall':
							camFollow.y = bf.getMidpoint().y - 200;
						case 'school':
							camFollow.x = bf.getMidpoint().x - 200;
							camFollow.y = bf.getMidpoint().y - 200;
						case 'schoolEvil':
							camFollow.x = bf.getMidpoint().x - 200;
							camFollow.y = bf.getMidpoint().y - 230;
					}
                }
                switch (SONG.song.toLowerCase()){
                    case 'tutorial': Actions.Tween(FlxG.camera, {zoom: (SONG.notes[Std.int(step / 16)].mustHitSection ? 1.0525 : 1.525)}, (Conductor.stepCrochet * 5 / 1000), {ease: FlxEase.elasticInOut});
                }
                if (cameramove){
                    camFollow.x += (SONG.notes[Std.int(step / 16)].mustHitSection ? bfcamX : camX);
                    camFollow.y += (SONG.notes[Std.int(step / 16)].mustHitSection ? bfcamY : camY);
                }
			}
		}
    }
	public static function PlayStateZoom(zoomValue:Float = 0.1){
		if (FlxG.save.data.camerazoom){
			FlxG.camera.zoom += zoomValue;
			PlayState.camNOTE.zoom += zoomValue;
			PlayState.camHUD.zoom += zoomValue;
			PlayState.laneCamera.zoom += zoomValue;
		}
	}
	public static function SetZoom(cam:FlxCamera, ZoomType:String, zoomValue:Float = 0.1, ?step:Null<Int>, ?backInStep:Null<Int> = 0, ?beat:Null<Int>, ?backInBeat:Null<Int> = 0){ // Choice You CamZoom Types :D
		if (FlxG.save.data.camerazoom && ZoomType != null){
			switch (ZoomType){
				case 'Zoom': cam.zoom += zoomValue;
				case 'StaticZoom': cam.zoom = zoomValue;
				case 'StepZoom': if (PlayStepEvents.publicStep % step == backInStep) cam.zoom += zoomValue;
				case 'BeatZoom': if (PlayBeatEvents.publicBeat % beat == backInBeat) cam.zoom += zoomValue;
			}
		}
	}
	public static function PresetCam(Player:String, num:Int, note:Note){ // Configuration to Move
        cameramove = FlxG.save.data.cameramovehitnote; // camMoveOnHitedNOTES
		var type = note.noteType;
		var id = note.noteData;
		var XCam:Array<Int> = PlayState.SONG.fiveNotes ? [-num, 0, 0, 0, num] : [-num, 0, 0, num];
		var YCam:Array<Int> = PlayState.SONG.fiveNotes ? [0, num, 0, -num, 0] : [0, num, -num, 0];
		if (cameramove){
			switch (Player){
				case 'BF':
					switch (type){
						case 0 | 1:
							bfcamX = XCam[id];
							bfcamY = YCam[id];
					}
				case 'Opponent':
					switch (type){
						case 0 | 1:
							camX = XCam[id];
							camY = YCam[id];
					}
			}
		}
	}
}