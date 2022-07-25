package;
import flixel.FlxG;
using StringTools;
class Highscore{
	public static function formatTrack(track:String, difficulty:Int):String{
		var daTrackSong:String = track; // please don't mess this up, this took too long to make ;-;
		if (difficulty == difficulty) daTrackSong += CoolUtil.PushDiff.DifficultyDataNames[difficulty];
		return daTrackSong;
	}
	public static function loadSavedScores():Void{
		if (FlxG.save.data.storySongScores != null)
			storySongScores = FlxG.save.data.storySongScores;
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;
		if (FlxG.save.data.songEndlessScores != null)
			songEndlessScores = FlxG.save.data.songEndlessScores;
		if (FlxG.save.data.songMisses != null)
			songMisses = FlxG.save.data.songMisses;
		if (FlxG.save.data.songAccuracy != null)
			songAccuracy = FlxG.save.data.songAccuracy;
		if (FlxG.save.data.songRating != null)
			songRating = FlxG.save.data.songRating;
		if (FlxG.save.data.songFCRating != null)
			songFCRating = FlxG.save.data.songFCRating;
		if (FlxG.save.data.songComboMax != null)
			songComboMax = FlxG.save.data.songComboMax;
	}
	#if (haxe >= "4.0.0")
	public static var storySongScores:Map<String, Int> = new Map();
	public static var songScores:Map<String, Int> = new Map();
	public static var songEndlessScores:Map<String, Int> = new Map();
	public static var songMisses:Map<String, Int> = new Map();
	public static var songAccuracy:Map<String, Float> = new Map();
	public static var songRating:Map<String, String> = new Map();
	public static var songFCRating:Map<String, String> = new Map();
	public static var songComboMax:Map<String, Int> = new Map();
	#else
	public static var storySongScores:Map<String, Int> = new Map<String, Int>();
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songEndlessScores:Map<String, Int> = new Map<String, Int>();
	public static var songMisses:Map<String, Int> = new Map<String, Int>();
	public static var songAccuracy:Map<String, Float> = new Map<String, Float>();
	public static var songRating:Map<String, String> = new Map<String, String>();
	public static var songFCRating:Map<String, String> = new Map<String, String>();
	public static var songComboMax:Map<String, Int> = new Map<String, Int>();
	#end

	// Endless SCORE Shit
	public static function saveEndlessScore(track:String, endlessScore:Int = 0, ?diff:Int = 0):Void{
		var daHandjobs:String = formatTrack(track, diff);
		if (songEndlessScores.exists(daHandjobs)){
			if (songEndlessScores.get(daHandjobs) < endlessScore)
				setEndlessScore(daHandjobs, endlessScore);
		}else
			setEndlessScore(daHandjobs, endlessScore);
	}
	static function setEndlessScore(track:String, endlessScore:Int):Void{
		songEndlessScores.set(track, endlessScore);
		FlxG.save.data.songEndlessScores = songEndlessScores;
		FlxG.save.flush();
	}
	public static function getEndlessScore(track:String, diff:Int):Int{
		if (!songEndlessScores.exists(formatTrack(track, diff)))
			setEndlessScore(formatTrack(track, diff), 0);
		return songEndlessScores.get(formatTrack(track, diff));
	}


	// SCORE FACK
	public static function saveScore(track:String, score:Int = 0, ?diff:Int = 0):Void{
		var daHandjobs:String = formatTrack(track, diff);
		if (songScores.exists(daHandjobs)){
			if (songScores.get(daHandjobs) < score)
				setScore(daHandjobs, score);
		}else
			setScore(daHandjobs, score);
	}
	static function setScore(track:String, score:Int):Void{
		songScores.set(track, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	public static function getScore(track:String, diff:Int):Int{
		if (!songScores.exists(formatTrack(track, diff)))
			setScore(formatTrack(track, diff), 0);
		return songScores.get(formatTrack(track, diff));
	}

	// Week Score Dick
	public static function saveWeekScore(week:Int = 0, storyScore:Int = 0, ?diff:Int = 0):Void{
		var daWeek:String = formatTrack('week' + week, diff);
		if (storySongScores.exists(daWeek)){
			if (storySongScores.get(daWeek) < storyScore)
				setWeekScore(daWeek, storyScore);
		}else
			setWeekScore(daWeek, storyScore);
	}
	static function setWeekScore(track:String, storyScore:Int):Void{
		storySongScores.set(track, storyScore);
		FlxG.save.data.storySongScores = storySongScores;
		FlxG.save.flush();
	}
	public static function getWeekScore(week:Int, diff:Int):Int{
		if (!storySongScores.exists(formatTrack('week' + week, diff)))
			setWeekScore(formatTrack('week' + week, diff), 0);
		return storySongScores.get(formatTrack('week' + week, diff));
	}


	// MISSES FACK
	public static function saveMisses(song:String, miss:Int = 0, ?diff:Int = 0):Void{
		var daSexyTrack:String = formatTrack(song, diff);
		if (songMisses.exists(daSexyTrack)){
			if (miss >= 0)
				if (songMisses.get(daSexyTrack) < miss)
					setMisses(daSexyTrack, miss);
			else
				if (songMisses.get(daSexyTrack) > miss)
					setMisses(daSexyTrack, miss);
		}else
			setMisses(daSexyTrack, miss);
	}
	static function setMisses(track:String, miss:Int):Void{
		songMisses.set(track, miss);
		FlxG.save.data.songMisses = songMisses;
		FlxG.save.flush();
	}
	public static function getMisses(track:String, diff:Int):Int{
		if (!songMisses.exists(formatTrack(track, diff)))
			setMisses(formatTrack(track, diff), 0);
		return songMisses.get(formatTrack(track, diff));
	}


	// Accuracy FACK
	public static function saveAccuracy(track:String, ?accuracy:Float = 0, ?diff:Int = 0):Void{
		var daSexy:String = formatTrack(track, diff);
		if (songAccuracy.exists(daSexy)){
			if (songAccuracy.get(daSexy) < accuracy)
				if (accuracy >= 0) 
					setAccuracy(daSexy, accuracy);
		}else{
			if (accuracy >= 0) 
				setAccuracy(daSexy, accuracy);
		}
	}
	static function setAccuracy(track:String, accuracy:Float):Void{
		songAccuracy.set(track, accuracy);
		FlxG.save.data.songAccuracy = songAccuracy;
		FlxG.save.flush();
	}
	public static function getAccuracy(track:String, diff:Int):Float{
		if (!songAccuracy.exists(formatTrack(track, diff)))
			setAccuracy(formatTrack(track, diff), 0);
		return songAccuracy.get(formatTrack(track, diff));
	}


	// Rating Suck!
	public static function saveRating(daTrack:String, rank:String = 'N/A', ?diff:Int = 0):Void{
		var daTrack:String = formatTrack(daTrack, diff);
		var theMainRANK:String = rank.split(')')[0].replace('(', '');
		if (songRating.exists(daTrack)){
			if (pushRating(songRating.get(daTrack)) < pushRating(theMainRANK))
				setRating(daTrack, theMainRANK);
		}else
			setRating(daTrack, theMainRANK);
	}
	static function setRating(track:String, rank:String = "N/A"):Void{
		songRating.set(track, rank);
		FlxG.save.data.songRating = songRating;
		FlxG.save.flush();
	}
	public static function getRating(track:String, diff:Int):String{
		if (!songRating.exists(formatTrack(track, diff)))
			setRating(formatTrack(track, diff));
		return songRating.get(formatTrack(track, diff));
	}
	static function pushRating(RANK:String):Int{
		switch (RANK){
			default:  return 0;
			case 'Terrible': return 1;
			case 'Shit': return 2;
			case 'Bad': return 3;
			case 'Bruh': return 4;
			case 'Meh': return 5;
			case 'Good': return 6;
			case 'Great': return 7;
			case 'Optimum': return 9;
			case 'Excellent!!': return 9;
			case 'Mayor!!!': return 10;
			case 'Bloody Epic!!!!': return 11;
		}
	}


	// RatingFC Suck!
	public static function saveFCRating(daTrack:String, fcrank:String = '?', ?diff:Int = 0):Void{
		var daTrack:String = formatTrack(daTrack, diff);
		var theMainRANKFC:String = fcrank.split(')')[0].replace('(', '');
		if (songFCRating.exists(daTrack)){
			if (pushFCRating(songFCRating.get(daTrack)) < pushFCRating(theMainRANKFC))
				setFCRating(daTrack, theMainRANKFC);
		}else
			setFCRating(daTrack, theMainRANKFC);
	}
	static function setFCRating(track:String, fcrank:String = "?"):Void{
		songFCRating.set(track, fcrank);
		FlxG.save.data.songFCRating = songFCRating;
		FlxG.save.flush();
	}
	public static function getFCRating(track:String, diff:Int):String{
		if (!songFCRating.exists(formatTrack(track, diff)))
			setFCRating(formatTrack(track, diff));
		return songFCRating.get(formatTrack(track, diff));
	}
	static function pushFCRating(RANKFC:String):Int{
		switch (RANKFC){
			default: return 0;
			case 'UnstoppableTF': return 1;
			case 'TenTF': return 2;
			case 'NTF': return 3;
			case 'ETF': return 4;
			case 'SvnTF': return 5;
			case 'SxTF': return 6;
			case 'FvTF': return 7;
			case 'FTF': return 8;
			case 'ThrTF': return 9;
			case 'TwTF': return 10;
			case 'OTF': return 11;
			case 'FC': return 12;
			case 'GFC': return 13;
			case 'PFC!': return 14;
			case 'SPFC!!': return 15;
		}
	}


	// COMBO MAX FACK
	public static function saveComboMax(track:String, comboMax:Int = 0, ?diff:Int = 0):Void{
		var daTrack:String = formatTrack(track, diff);
		if (songComboMax.exists(daTrack)){
			if (songComboMax.get(daTrack) < comboMax)
				setComboMax(daTrack, comboMax);
		}else
			setComboMax(daTrack, comboMax);
	}
	static function setComboMax(track:String, comboMax:Int):Void{
		songComboMax.set(track, comboMax);
		FlxG.save.data.songComboMax = songComboMax;
		FlxG.save.flush();
	}
	public static function getComboMax(track:String, diff:Int):Int{
		if (!songComboMax.exists(formatTrack(track, diff)))
			setComboMax(formatTrack(track, diff), 0);
		return songComboMax.get(formatTrack(track, diff));
	}
}