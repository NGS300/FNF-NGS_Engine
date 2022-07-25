import flixel.tweens.FlxEase;
import Song.SwagSong;
import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.math.FlxPoint;
using StringTools;
typedef JsonCharacterRecognition ={
	var ?BoyfriendsBackgroundsColors:Array<String>;
	var ?BoyfriendsNames:Array<String>;
	var Boyfriends:Array<String>;
	var Opponents:Array<String>;
	//var Girlfriends:Array<String>;
}
class CharacterSettigs{
	public static var CharacterRecognition:JsonCharacterRecognition;
	public static var CharacterGetLimit:Null<Int> = 5;
    public static var bomboxSkinType:String = 'gf';
	public static var gfSpeed:Int = 1;
	public static function CreateLayerObject(trackLower:String, create:Dynamic ,opponent:Character, gf:Character, bf:Boyfriend){
		TrackMap.mapPlaces(trackLower, 'Backward', create, opponent, gf, bf);
		create(opponent);
		create(bf);
		if (FlxG.save.data.visualDistractions)
			TrackMap.mapPlaces(trackLower, 'Frontward', create, opponent, gf, bf);
	}
    public static function LoadGFType(Type:String, ?BomboxSkin:String = "gf", TrackLower:String, Map:String, gf:Character){
		switch (Type){
			case 'GFScrollfactor':
				switch (Map){
					default: gf.scrollFactor.set(0.95, 0.95);
				}
			case 'GetGF':
				switch (TrackLower){
					default: bomboxSkinType = BomboxSkin;
				}
		}
	}
	public static function CharacterIdles(state:String, ?holdArray:Array<Bool> = null, bf:Boyfriend, ?gf:Character, ?opponent:Character, ?SONG:SwagSong, ?step:Int, ?beat:Int, ?GFSpeed:Int){
		switch (state){
			case 'PlayStateKey':
				if (bf.holdTimer > Conductor.stepCrochet * 4 * 0.001 && bf.animation.curAnim.name.startsWith(Character.talkAction) && !bf.animation.curAnim.name.endsWith(Character.actionMiss) && !PlayState.instance.bfDodging && (!holdArray.contains(true) || Client.Public.botplay)){
					Actions.PlayCharAnim(bf, 'idle');
					PlayState.instance.removeTrail('Player');
					Camera.bfcamX = 0;
					Camera.bfcamY = 0;
				}
			case 'PlayBeatEvents':
				if (SONG.notes[Math.floor(step / 16)] != null && SONG.notes[Math.floor(step / 16)].mustHitSection && !opponent.animation.curAnim.name.startsWith(Character.talkAction)){
					PlayState.instance.removeTrail('Opponent');
					Actions.PlayCharAnim(opponent);
					Camera.camX = 0;
					Camera.camY = 0;
				}
				if (!bf.animation.curAnim.name.startsWith(Character.talkAction) && !PlayState.instance.bfDodging){ // BoyFrined Stop Sing Animations, Back to Idle
					Actions.PlayCharAnim(bf, 'idle');
					PlayState.instance.removeTrail('Player');
				}
				switch (SONG.song.toLowerCase()){
					default: if (beat % GFSpeed == 0) Actions.PlayCharAnim(gf);
					case 'tanpowder':
						if (beat >= 1 && beat < 128){
							if (beat % GFSpeed == 0)  Actions.PlayCharAnim(gf, 'idle');
						}else{
							if (beat % GFSpeed == 0)  Actions.PlayCharAnim(gf, 'idleSpinShirt');
						}
				}
		}
    }
	public static function CharacterTypePositions(Type:String, Map:String, OpponentCharacter:String, BomboxChracter:String, PlayerCharacter:String, trackLower:String, create:Dynamic, camPos:FlxPoint, opponent:Character, bf:Boyfriend, gf:Character/*, p3:Character, p4:Character, p5:Character, p6:Character*/){
		switch (Type){
			case 'PlayerPos':
				switch (PlayerCharacter){ // Set Player Positions
					default:
						bf.x += bf.characterPositionX;
						bf.y += bf.characterPositionY;
				}
			/*case 'GFPos':
				switch (BomboxChracter){
				}*/
			case 'OpponentPos':
				switch (OpponentCharacter){ // Set Opponents Positions
					default:
						if (opponent.curCharacter.startsWith('gf')){
							opponent.setPosition(gf.x, gf.y);
							gf.visible = false;
							if (PlayState.stateShit == 'StoryMode'){
								Actions.Tween(FlxG.camera, {zoom: 1.525}, (Conductor.stepCrochet * 5 / 1000), {ease: FlxEase.elasticInOut});
								camPos.x += 600;
							}
						}
						opponent.x += opponent.characterPositionX;
						opponent.y += opponent.characterPositionY;
						camPos.x += opponent.cameraPositionX;
						camPos.y += opponent.cameraPositionY;
						if (opponent.curCharacter.endsWith('-pixel'))
							camPos.set(opponent.getGraphicMidpoint().x + 300, opponent.getGraphicMidpoint().y);
					case 'pico':
						Actions.SetCharPos(opponent, 0, 300);
				}
			case 'InMapPos':
				switch (Map){ // Set Chars Positions
					case 'limo':
						if (FlxG.save.data.visualDistractions){
							TrackMap.mapSprEvent('reset');
							create(TrackMap.fastCar);
						}
						Actions.SetCharPos(bf, 260, -220);
					case 'mall':
						Actions.SetCharPos(bf, 200);
					case 'mallEvil':
						Actions.SetCharPos(opponent, 0, -80);
						Actions.SetCharPos(bf, 320);
					case 'school':
						Actions.SetCharPos(gf, 180, 300);
						Actions.SetCharPos(bf, 200, 220);
					case 'schoolEvil':
						if (FlxG.save.data.visualDistractions){
							var evilTrail = new FlxTrail(opponent, null, 4, 24, 0.3, 0.069);
							create(evilTrail);
						}
						Actions.SetCharPos(gf, 180, 300);
						Actions.SetCharPos(bf, 200, 220);
					case 'tankDesert':
						if (trackLower == 'stress')
							Actions.SetCharPos(gf, -90, -155);
						else
							Actions.SetCharPos(gf, -200, -55);
						Actions.SetCharPos(bf, 40);
						Actions.SetCharPos(opponent, -80, 60);
					case 'nevada':
						Actions.SetCharPos(opponent, -10, 60);
						Actions.SetCharPos(gf, -650, -210);
						Actions.SetCharPos(bf, 100, 10);
				}
		}
	}
}