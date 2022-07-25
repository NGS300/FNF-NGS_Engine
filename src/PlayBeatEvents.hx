import flixel.util.FlxSort;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.FlxG;
class PlayBeatEvents /*extends MusicBeatState*/{ // <-- Any Bug Active This
	public static var publicBeat = 0; // To Use Any State
	public static var thistShit:WiggleEffect = new WiggleEffect();
    public static function beatEvents(create:Dynamic, remove:Dynamic, Track:String, TrackLower:String, opponent:Character, gf:Character, bf:Boyfriend, healthBar:FlxBar, step:Int, beat:Int, SONG:SwagSong, diff:Int, danceIcons:Bool, camZooming:Bool, gfDanceSpeed:Int, iconP1:HealthIcon, iconP2:HealthIcon, camHUD:FlxCamera, camNOTE:FlxCamera, laneCamera:FlxCamera, playerStrums:FlxTypedGroup<FlxSprite>, opponentStrums:FlxTypedGroup<FlxSprite>, strumLineNotes:FlxTypedGroup<FlxSprite>, notes:FlxTypedGroup<Note>, paused:Bool){
		if (Client.Public.map) TrackMap.mapType('beat', null, null, null, Track, opponent, gf, bf, step, beat, diff, SONG, null, healthBar, camHUD, camNOTE, laneCamera, playerStrums, opponentStrums, strumLineNotes);
		if (SONG.notes[Math.floor(step / 16)] != null && SONG.notes[Math.floor(step / 16)].changeBPM) Conductor.changeBPM(SONG.notes[Math.floor(step / 16)].bpm);
		if (PlayState.instance.generatedMusic) notes.sort(FlxSort.byY, (Client.Public.downscroll ? FlxSort.ASCENDING : FlxSort.DESCENDING));
		CharacterSettigs.CharacterIdles('PlayBeatEvents', null, bf, gf, opponent, SONG, step, beat, gfDanceSpeed); // Character Idles
		Camera.cameraZooming('PlayBeatEvents', camZooming, beat); // Camera Beating Bro
		HealthIcon.iconBumping(bf, opponent, danceIcons); // Player Icons Beating
		thistShit.update(Conductor.crochet);
		publicBeat = beat;
        switch (TrackLower){ // Tracks/Songs Events
			case 'tutorial': if (beat % 16 == 15 && opponent.curCharacter == 'gf' && beat > 16 && beat < 48){ // Bruh is Default of FNF
					Actions.PlayCharAnim(bf, 'hey', true);
					Actions.PlayCharAnim(opponent, 'cheer', true);
				}
			case 'bopeebo': if (beat % 8 == 7){ // Again XP DEFAULT Bro
					Actions.PlayCharAnim(bf, 'hey', true);
					Actions.PlayCharAnim(gf, 'cheer', true);
				}
                if (beat == 128 || beat == 129 || beat == 130) PlayState.instance.vocals.volume = 0;
			case 'fresh': switch (beat){
					case 16: Actions.GlobalModify(null, null, 2);
					case 48: Actions.GlobalModify(null, null, 1);
					case 80: Actions.GlobalModify(null, null, 2);
					case 112: Actions.GlobalModify(null, null, 1);
				}
            case 'spookeez':
				switch (step){
					case 16 | 576 | 640 | 704 | 768 | 832 | 896: TrackMap.mapSprEvent(); // Just LightStrike of Spookeez (is Hard to Listen)
				}
			case 'milf':
				if (FlxG.save.data.camerazoom && beat >= 168 && beat < 200 && camZooming && FlxG.camera.zoom < 1.35 && camNOTE.zoom < 1.35) // This Facking Beating Super Zooming of FACKING MILF, I Love This Song XP
					Camera.PlayStateZoom(0.1);
				else if (FlxG.save.data.camerazoom && beat >= 8 && beat < 328) // Normal Beating :O
					Camera.PlayStateZoom(0.0435);
			case 'stress': if (diff >= 2 && FlxG.save.data.visualDistractions){
					if (step >= 384 && step < 624)
					    HealthIcon.DancingIcons('stress');
					if (step >= 1024 && step < 1262)
						HealthIcon.DancingIcons('stress');
					if (beat >= 96 && beat < 156)
						Camera.PlayStateZoom(0.038);
					if (beat >= 256 && beat < 315)
						Camera.PlayStateZoom(0.038);
				}
		} 
    }
}