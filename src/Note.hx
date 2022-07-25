package;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;
class Note extends FlxSprite{
	public var noteColorName:Array<String> = ['purple', 'blue', 'green', 'red'];
	public static var swagWidth:Float = 160 * 0.7;
	public var noteName:String = 'Normal Note';
	public var noteDescription:String = '';
	public static var instance:Note = null;
	public var isSustainNote:Bool = false;
	public var modifiedByLua:Bool = false;
	public var sustainColorName:Int = 0;
	public var wasGoodHit:Bool = false;
	public var sustainLength:Float = 0;
	public var rating:String = "shit";
	public var mustPress:Bool = false;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var strumTime:Float = 0;
	public  var noteData:Int = 0;
	public var noteType:Int = 0;
	public var prevNote:Note;
	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?noteType:Int = 0, ?isPlayer:Bool = false){
		super();
		instance = this;
		if (prevNote == null) prevNote = this;
		this.noteType = noteType;
		this.prevNote = prevNote;
		isSustainNote = sustainNote;
		x += 50;
		y -= 2000;
		this.strumTime = strumTime;
		this.strumTime += FlxG.save.data.offsetNote;
		this.noteData = noteData;
		switch (TrackMap.mapComplement){
			default: LoadNote('default', isPlayer);
			case 'pixel': LoadNote('pixel', isPlayer);
		}
		x += swagWidth * noteData;
		animation.play(noteColorName[noteData] + 'Scroll');
		sustainColorName = noteData;
		if (Client.Public.downscroll && sustainNote) flipY = true;
		if (isSustainNote && prevNote != null){
			alpha = 0.6;
			x += width / 2;
			sustainColorName = prevNote.sustainColorName;
			animation.play(noteColorName[sustainColorName] + 'holdend');
			updateHitbox();
			x -= width / 2;
			if (TrackMap.mapComplement != 'pixel') x += 30;
			if (prevNote.isSustainNote){
				prevNote.animation.play(noteColorName[prevNote.sustainColorName] + 'hold');
				prevNote.scale.y *= Conductor.stepCrochet / 100 * 1.5 * (FlxG.save.data.scrollSpeed == 1 ? PlayState.SONG.speed : FlxG.save.data.scrollSpeed);
				prevNote.updateHitbox();
			}
		}
	}
	override function update(elapsed:Float){
		super.update(elapsed);
		if (mustPress){
			//if (noteType >= 0){ (if the note is too heavy to hit, activate this if)
				if (isSustainNote){
					if ((Options.Option.JsonOptions.UseKadeEngineHitNote ? strumTime - Conductor.songPosition <= (((166 * Conductor.timeScale) * 0.5)) && strumTime - Conductor.songPosition >= (((-166 * Conductor.timeScale))) : strumTime > Conductor.songPosition - (Conductor.safeZoneOffset * 1.5) && strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5)))
						canBeHit = true; else canBeHit = false;
				}else{
					if ((Options.Option.JsonOptions.UseKadeEngineHitNote ? strumTime - Conductor.songPosition <= (((166 * Conductor.timeScale))) && strumTime - Conductor.songPosition >= (((-166 * Conductor.timeScale))) : strumTime > Conductor.songPosition - Conductor.safeZoneOffset && strumTime < Conductor.songPosition + Conductor.safeZoneOffset))
						canBeHit = true; else canBeHit = false;
				}
			//}
			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset * Conductor.timeScale && !wasGoodHit) tooLate = true; // Valid Player Hit Note
		}else{
			canBeHit = false;
			if (strumTime <= Conductor.songPosition){ // Opponent Hit Note
				switch (noteType){
					case 0 | 1: wasGoodHit = true;
				}
			}
		}
		if (tooLate && !wasGoodHit)
			if (alpha > 0.3) alpha = 0.3;
	}
	public function LoadNote(?Skin:String = 'default', ?IsPlayer:Bool = false){ // Load Notes
		animation.play(noteColorName[noteData] + 'Scroll');
		switch (Skin){
			case 'pixel':
				loadGraphic(Paths.loadImage('note/skins/' + (IsPlayer ? 'player/pixel/' : 'opponent/pixel/') + (IsPlayer ? Options.Option.JsonOptions.UseNewNoteSytle ? "Player_NOTENewStyle" : "Player_NOTE"
				: Options.Option.JsonOptions.UseNewNoteSytle ? "Opponent_NOTENewStyle" : "Opponent_NOTE") + "-pixel"), true, 17, 17);
				if (isSustainNote)
					loadGraphic(Paths.loadImage('note/skins/' + (IsPlayer ? 'player/pixel/' : 'opponent/pixel/') + (IsPlayer ? Options.Option.JsonOptions.UseNewNoteSytle ? "Player_TailsNewStyle" : "Player_Tails"
					: Options.Option.JsonOptions.UseNewNoteSytle ? "Opponent_TailsNewStyle" : "Opponent_Tails") + "-pixel"), true, 7, 6);
				switch (noteType){
					default: notePixel(null, null, 4, true); // Default Pixel Note
					case 1: notePixel(null, null, 4, true); // Alt Anim Sing Pixel Note
					case 2: notePixel(null, null, 20); // DODGE Pixel Note
				}
				updateHitbox();
				antialiasing = false;
			case 'default':
				frames = Paths.getSparrowAtlas('note/skins/' + (IsPlayer ? 'player/' : 'opponent/') + (IsPlayer ? Options.Option.JsonOptions.UseNewNoteSytle ? "Player_NewSytle_NOTE_assets" : "Player_NOTE_assets"
				: Options.Option.JsonOptions.UseNewNoteSytle ? "Opponent_NewSytle_NOTE_assets" : "Opponent_NOTE_assets"));
				var fackPushPussy = Paths.getSparrowAtlas('note/types/Spin_NOTE');
				for (pussy in fackPushPussy.frames)
					this.frames.pushFrame(pussy);
				switch(noteType){
					default: // Default Note
						note(null, null, 'note/skins/' + (IsPlayer ? 'player/' : 'opponent/') + (IsPlayer ? Options.Option.JsonOptions.UseNewNoteSytle ? "Player_NewSytle_NOTE_assets" : "Player_NOTE_assets"
							: Options.Option.JsonOptions.UseNewNoteSytle ? "Opponent_NewSytle_NOTE_assets" : "Opponent_NOTE_assets"), 
							['purple note', 'blue note', 'green note', 'red note'], // Normal Notes
							['purple holdTail', 'blue holdTail', 'green holdTail', 'red holdTail'], // Hold Tails
							['purple tailEnd', 'blue tailEnd', 'green tailEnd', 'red tailEnd'] // End Tails
						);
					case 1: // Alt Anim Sing Note
						note('Alt Note', 'Play -alt Anims', 'note/skins/' + (IsPlayer ? 'player/' : 'opponent/') + (IsPlayer ? Options.Option.JsonOptions.UseNewNoteSytle ? "Player_NewSytle_NOTE_assets" : "Player_NOTE_assets"
							: Options.Option.JsonOptions.UseNewNoteSytle ? "Opponent_NewSytle_NOTE_assets" : "Opponent_NOTE_assets"), 
							['purple note', 'blue note', 'green note', 'red note'], // Normal Notes
							['purple holdTail', 'blue holdTail', 'green holdTail', 'red holdTail'], // Hold Tails
							['purple tailEnd', 'blue tailEnd', 'green tailEnd', 'red tailEnd'] // End Tails
						);
					case 2: // ALERT Note
						note('ALERT Note', 'Alert for Action for no Die', 'note/types/Alert_NOTE', ['Alert note', 'Alert note', 'Alert note', 'Alert note']);
					case 3: // Heal Note
						note('Heal Note', 'Heal Player Hited', 'note/types/Heal_NOTE', ['HEAL HP LEFT', 'HEAL HP DOWN', 'HEAL HP UP', 'HEAL HP RIGHT']);
					case 4: // Ragen Note
						note('Ragen Note', 'Regenerates For a Few Seconds', 'note/types/Healing_NOTE', ['HEALING HP LEFT', 'HEALING HP DOWN', 'HEALING HP UP', 'HEALING HP RIGHT']);
					case 5: // Block Health Gain
						note('Block Gain Health Note', 'Block Health Gain for Notes for a Few Seconds', 'note/types/Block_Heal_NOTE', ['BLOCK HEAL HP LEFT', 'BLOCK HEAL HP DOWN', 'BLOCK HEAL HP UP', 'BLOCK HEAL HP RIGHT']);
					case 6: // Dont Pass Note
						note('Dont Pass Note', 'Cant Let It Go If You Dont Take Damage', 'note/types/Alert_Press_NOTE', ['Need Press LEFT', 'Need Press DOWN', 'Need Press UP', 'Need Press RIGHT']);
					case 7: // Damage Note
						note('Damage Note', 'You Take Damage on Hit', 'note/types/Saw_NOTE', ['Saw PURPLE', 'Saw BLUE', 'Saw GREEN', 'Saw RED'], null, null, 0.5295);
					case 8: // Poison Note
						note('Poison Note', 'You Take Damage Over Time', 'note/types/Poised_NOTE', ['LEFT OwO', 'DOWN OwO', 'UP OwO', 'RIGHT OwO']);
					case 9: // Padlock Note
						note('Padlock Note', 'Block Scroll (Unable to Press For a Few Seconds)', 'note/types/PadLock_NOTE', ['PadLock Left NOTE', 'PadLock Down NOTE', 'PadLock Up NOTE', 'PadLock Right NOTE']);
					case 10: // Flash Note
						note('Flash Note', 'You Cant See Anything in a Few Seconds', 'note/types/FlashBang_NOTE', ['Left Flash', 'Down Flash', 'UP Flash', 'Right Flash']);
					case 11: // In-Fection Note
						note('In-Fection Note', 'Unknown', 'note/types/InFecTdeD_nOtE', ['IN-fEctEdeD lEft', 'iNfeCteDed dOwN', 'inFecTedEd uP', 'InfeCTedeD RIgHt']);
					case 12: // DEATH NOTE
						note('DEATH NOTE', 'Death When You Press', 'note/types/Spin_NOTE', ['SpinWhell', 'SpinWhell', 'SpinWhell', 'SpinWhell'], null, null, 0.42);
					case 13: // Corrupt Note
						note('Corrupt Note', 'Crash on Hit', 'note/types/Corrupt_NOTE', ['404 Complex LEFT', '404 Complex Down', '404 Complex UP', '404 Complex RIGHT']);
				}
				updateHitbox();
				antialiasing = Client.Public.antialiasing;
		}
	}
	function note(?chartingShowNoteName:String = 'Normal Note', ?chartingNoteDescription:String = '', ?Frame:String = null, ScrollNotes:Array<String>, ?HoldTails:Array<String> = null, ?EndTails:Array<String> = null, ?noteSize:Float = 0.7, ?Folder:String = 'shared'){
		noteName = chartingShowNoteName;
		noteDescription = chartingNoteDescription;
		if (Frame != null) frames = Paths.getSparrowAtlas(Frame, Folder);
		for (id in 0...ScrollNotes.length){
			animation.addByPrefix(noteColorName[id] + 'Scroll', ScrollNotes[id]); // Normal Notes
			if (HoldTails != null) animation.addByPrefix(noteColorName[id] + 'hold', HoldTails[id]); // Holding Tails
			if (EndTails != null) animation.addByPrefix(noteColorName[id] + 'holdend', EndTails[id]); // End Trails
		}
		setGraphicSize(Std.int(width * noteSize));
	}
	function notePixel(ChartingShowNoteName:String = 'Normal Pixel Notes', ?ChartingNoteDescription:String = '', ?ScrollNotes:Int = null, ?HoldTails:Bool = false, ?EndTails:Int = null, ?NoteSize:Float = null){
		noteName = ChartingShowNoteName;
		noteDescription = ChartingNoteDescription;
		for (i in 0...(ScrollNotes == null ? 4 : ScrollNotes)){
			animation.add(noteColorName[i] + 'Scroll', [i + ScrollNotes]); // Normal Pixels Notes
			if (HoldTails) animation.add(noteColorName[i] + 'hold', [i]); // Holding Pixels Tails
			if (HoldTails && EndTails != null) animation.add(noteColorName[i] + 'holdend', [i + (EndTails == null ? ScrollNotes : EndTails)]); // End Pixels Tails
		}
		setGraphicSize(Std.int(width * (NoteSize != null ? NoteSize : TrackMap.daPixelZoom)));
	}
}