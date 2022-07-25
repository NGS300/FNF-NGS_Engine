package;
import Conductor.BPMChangeEvent;
import Section.SwagSection;
import Song.SwagSong;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import haxe.Json;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.net.FileReference;
import lime.media.AudioBuffer;
using StringTools;
class ChartingState extends MusicBeatState{
	var _file:FileReference;
	var UI_box:FlxUITabMenu;
	var curSection:Int = 0;
	public static var lastSection:Int = 0;
	var informationText:FlxText;
	var strumLine:FlxSprite;
	var arrowEventStumLine:FlxSprite;
	var waveformSprite:FlxSprite;
	private var lastNote:Note;
	var curSong:String = 'Dadbattle';
	var amountSteps:Int = 0;
	var bullshitUI:FlxGroup;
	var highlight:FlxSprite;
	var GRID_SIZE:Int = 40;
	var CHANGEABLE_GRID_SIZE:Int = 40;
	var dummyArrow:FlxSprite;
	var curRenderedNotes:FlxTypedGroup<Note>;
	var curRenderedSustains:FlxTypedGroup<FlxSprite>;
	var gridBG:FlxSprite;
	var _song:SwagSong;
	var typingSong:FlxInputText;
	var typingArtist:FlxInputText;
	var curSelectedNote:Array<Dynamic>;
	var tempBpm:Int = 0;
	var vocals:FlxSound;
	var player2:Character = new Character(0,0, "dad");
	var player1:Boyfriend = new Boyfriend(0,0, "bf");
	public var leftIcon:HealthIcon;
	public var rightIcon:HealthIcon;
	var check_mustHitSection:FlxUICheckBox;
	var waveformEnabled:FlxUICheckBox;
	var waveformUseInstrumental:FlxUICheckBox;
	var stepperSusLength:FlxUINumericStepper;
	var check_changeBPM:FlxUICheckBox;
	var stepperLength:FlxUINumericStepper;
	var stepperSectionBPM:FlxUINumericStepper;
	var check_altAnim:FlxUICheckBox;
	var waveformPrinted:Bool = true;
	var audioBuffers:Array<AudioBuffer> = [null, null];
	private var daSpacing:Float = 0.3;
	public static var noteType = 0;
	var updatedSection:Bool = false;
	var sussyLenght:Float = 10000000000; // Hold Notes Max, Numer Showing
	var maxSussy:Int = 10000; // Max NoteTypes Number Select in Charting
	var buttomScaleShit:Float = 0.8475;
	var clearNotesButton:FlxButton;
	var moreBox:Int = 0;
	var noteNameLabel:Text;
	var noteDescriptionLabel:Text;
	override function create(){
		curSection = lastSection;
		CharacterSettigs.CharacterRecognition = Json.parse(openfl.utils.Assets.getText(Paths.type(Client.Public.gameFolder + 'CharacterList', 'json', 'TEXT', 'config')));
		StateImage.BGSMenus('ChartingBG', add);

		gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
		add(gridBG);

		var gridBlackLine:FlxSprite = new FlxSprite(gridBG.x + gridBG.width / 2).makeGraphic(2, Std.int(gridBG.height), FlxColor.BLACK);
		add(gridBlackLine);

		curRenderedNotes = new FlxTypedGroup<Note>();
		curRenderedSustains = new FlxTypedGroup<FlxSprite>();

		if (PlayState.SONG != null)
			_song = PlayState.SONG;
		else{
			_song ={
				notes: [],
				needsVoices: true,
				validScore: true,
				fiveNotes: false,
				girlfriend: 'gf',
				player2: 'dad',
				player1: 'bf',
				artist: "Sus",
				song: 'Test',
				speed: 1,
				bpm: 150
			};
		}
		FlxG.mouse.visible = true;
		tempBpm = _song.bpm;

		addSection();
		updateGrid();
		loadSong(_song.song);
		Conductor.changeBPM(_song.bpm);
		Conductor.mapBPMChanges(_song);

		HealthIcon.onPlayState = false;

		leftIcon = new HealthIcon(_song.player1);
		rightIcon = new HealthIcon(_song.player2);
		rightIcon.flipX = true;
		leftIcon.scrollFactor.set(1, 1);
		rightIcon.scrollFactor.set(1, 1);

		leftIcon.setGraphicSize(0, 45);
		rightIcon.setGraphicSize(0, 45);

		add(leftIcon);
		add(rightIcon);

		leftIcon.setPosition(0, -100);
		rightIcon.setPosition(gridBG.width / 2, -100);

		informationText = new FlxText(940.5, 3.75, 0, "", 16);
		informationText.scrollFactor.set();
		add(informationText);

		strumLine = new FlxSprite(0, 50).makeGraphic(Std.int(FlxG.width / 2), 6); // height 4
		add(strumLine);

		arrowEventStumLine = new FlxSprite(strumLine.x - 93.25).loadGraphic(Paths.image('eventArrow', 'shared'));
		arrowEventStumLine.scale.x = 0.4;
		arrowEventStumLine.scale.y = 0.4;
		add(arrowEventStumLine);

		dummyArrow = new FlxSprite().makeGraphic(GRID_SIZE, GRID_SIZE);
		add(dummyArrow);

		var tabs =[
			{name: "Song", label: 'Song'},
			{name: "Section", label: 'Section'},
			{name: "Chart", label: 'Chart'}
		];

		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(300, 400);
		UI_box.x = FlxG.width / 2;
		UI_box.y = 0;
		add(UI_box);

		addChartUIFACKYeah();
		//updateWaveform();
		addSongUI();
		addSectionUI();
		updateIcons();

		add(curRenderedNotes);
		add(curRenderedSustains);

		DiscordClient.globalPresence('ChartingState');
		super.create();
	}
	function addChartUIFACKYeah():Void{
		var noteTypePick:FlxUINumericStepper = new FlxUINumericStepper(5, 40, 1, 1, 0, maxSussy, 1);
		noteTypePick.value = noteType;
		noteTypePick.name = 'type_mechanicsNotes';
		var noteTypePickLabel = new FlxText(noteTypePick.x + 60, noteTypePick.y, 'NoteTypes');
		noteNameLabel = new Text((Note.instance.noteName == null ? '?' : Note.instance.noteName), noteTypePick.x, noteTypePick.y - 20, Std.int(8.5));
		noteDescriptionLabel = new Text((Note.instance.noteDescription == null ? '?' : Note.instance.noteDescription), noteTypePick.x, noteTypePick.y + 25);

		stepperSusLength = new FlxUINumericStepper(1, 425, Conductor.stepCrochet / 2, 0, 0, sussyLenght);
		stepperSusLength.value = 0;
		stepperSusLength.name = 'note_susLength';
		var stepperSussyLabel = new FlxText(stepperSusLength.x - 2, stepperSusLength.y - 15, 'Hold Notes Lenght:');

		var applyLength:FlxButton = new FlxButton(stepperSusLength.x + 60, stepperSusLength.y - 3, 'Apply!');
		applyLength.scale.x = buttomScaleShit;
		applyLength.scale.y = buttomScaleShit;

		check_mustHitSection = new FlxUICheckBox(5, 290, null, null, "BoyFriend Turn", 100);
		check_mustHitSection.name = 'check_mustHit';
		check_mustHitSection.checked = true;
		
		/*waveformEnabled = new FlxUICheckBox(5, 355, null, null, "Visible Waveform", 100);
		if (FlxG.save.data.chart_waveform == null) FlxG.save.data.chart_waveform = false;
		waveformEnabled.checked = FlxG.save.data.chart_waveform;
		waveformEnabled.callback = function(){
			FlxG.save.data.chart_waveform = waveformEnabled.checked;
			updateWaveform();
		};
		waveformUseInstrumental = new FlxUICheckBox(waveformEnabled.x + 120, waveformEnabled.y, null, null, "Waveform for Instrumental", 100);
		waveformUseInstrumental.checked = false;
		waveformUseInstrumental.callback = function(){
			updateWaveform();
		};*/

		var check_mute_inst = new FlxUICheckBox(5, 355, null, null, "Mute Instrumental", 100);
		check_mute_inst.checked = false;
		check_mute_inst.callback = function(){
			var volInst:Float = 1;
			if (check_mute_inst.checked)
				volInst = 0;
			FlxG.sound.music.volume = volInst;
		};
		var check_mute_vocal = new FlxUICheckBox(check_mute_inst.x + 120, check_mute_inst.y, null, null, "Mute Vocal", 100);
		check_mute_vocal.checked = false;
		check_mute_vocal.callback = function(){
			var volVocal:Float = 1;
			if (check_mute_vocal.checked)
				volVocal = 0;
			vocals.volume = volVocal;
		};

		var stepperVocalVol:FlxUINumericStepper = new FlxUINumericStepper(1, 380, 0.1, 1, 0, 10, 1);
		stepperVocalVol.value = vocals.volume;
		stepperVocalVol.name = 'song_vocalvol';
		var stepperVocalVolLabel = new FlxText(stepperVocalVol.x + 60, stepperVocalVol.y - 1, 'Vocal Volume'); // old 62, 379
		var stepperSongVol:FlxUINumericStepper = new FlxUINumericStepper(1, 395, 0.1, 1, 0, 10, 1);
		stepperSongVol.value = FlxG.sound.music.volume;
		stepperSongVol.name = 'song_instvol';
		var stepperSongVolLabel = new FlxText(stepperSongVol.x + 60, stepperSongVol.y - 1, 'Instrumental Volume'); // old 62 394

		var tab_group_chart = new FlxUI(null, UI_box);
		tab_group_chart.name = "Chart";
		tab_group_chart.add(noteTypePick);
		tab_group_chart.add(noteTypePickLabel);
		tab_group_chart.add(noteNameLabel);
		tab_group_chart.add(noteDescriptionLabel);
		//tab_group_chart.add(waveformEnabled);
		//tab_group_chart.add(waveformUseInstrumental);
		tab_group_chart.add(check_mustHitSection);
		tab_group_chart.add(check_mute_vocal);
		tab_group_chart.add(check_mute_inst);
		tab_group_chart.add(stepperVocalVol);
		tab_group_chart.add(stepperVocalVolLabel);
		tab_group_chart.add(stepperSongVol);
		tab_group_chart.add(stepperSongVolLabel);
		tab_group_chart.add(stepperSusLength);
		tab_group_chart.add(applyLength);
		tab_group_chart.add(stepperSussyLabel);
		UI_box.addGroup(tab_group_chart);
	}
	function addSongUI():Void{
		var player1DropDown = new FlxUIDropDownMenu(-640, -18, Actions.makeStringIntList((!FlxG.save.data.trrBF ? CharacterSettigs.CharacterGetLimit : null), CharacterSettigs.CharacterRecognition.Boyfriends, true), function(bf:String){
			_song.player1 = CharacterSettigs.CharacterRecognition.Boyfriends[Std.parseInt(bf)];
		});
		player1DropDown.selectedLabel = _song.player1;
		var player1LabelName = new FlxText(player1DropDown.x - 2, player1DropDown.y + 20, 'Player:');
		var player2DropDown = new FlxUIDropDownMenu(-510, -18, FlxUIDropDownMenu.makeStrIdLabelArray(CharacterSettigs.CharacterRecognition.Opponents, true), function(dad:String){
			_song.player2 = CharacterSettigs.CharacterRecognition.Opponents[Std.parseInt(dad)];
		});
		player2DropDown.selectedLabel = _song.player2;
		var player2LabelName = new FlxText(player2DropDown.x - 2, player2DropDown.y + 20, 'Opponent:');
		var UI_songTitle = new FlxUIInputText(202.5, 10, 95, _song.song, 8);
		typingSong = UI_songTitle;
		var songNameLabel = new FlxText(UI_songTitle.x - 40, UI_songTitle.y, 'Song:');

		var UI_artistTitle = new FlxUIInputText(UI_songTitle.x, UI_songTitle.y + 20, 95, _song.artist, 8);
		typingArtist = UI_artistTitle;
		var artistNameLabel = new FlxText(UI_artistTitle.x - 40, UI_artistTitle.y, 'Artist:');

		var check_voices = new FlxUICheckBox(5, 355, null, null, "Has Voice Track?", 100);
		check_voices.checked = _song.needsVoices;
		check_voices.callback = function(){
			_song.needsVoices = check_voices.checked;
		};

		var saveButton:FlxButton = new FlxButton(5, 8, "Save Chart", function(){
			saveSong();
		});
		var reloadSong:FlxButton = new FlxButton(saveButton.x, saveButton.y + 30, "Reload Audio", function(){
			loadSong(_song.song);
			//updateWaveform();
			//loadAudioBuffer();
		});
		var reloadSongJson:FlxButton = new FlxButton(reloadSong.x, reloadSong.y + 30, "Reload Chart", function(){
			reloadTrackJson(_song.song.toLowerCase());
		});
		var loadAutosaveBtn:FlxButton = new FlxButton(reloadSongJson.x, reloadSongJson.y + 30, 'Load Autosave', loadAutosave);

		var stepperSpeed:FlxUINumericStepper = new FlxUINumericStepper(1, 395, 0.1, 1, 0.1, 10, 1);
		stepperSpeed.value = _song.speed;
		stepperSpeed.name = 'song_speed';
		var stepperSpeedLabel = new FlxText(stepperSpeed.x + 60, stepperSpeed.y - 1, 'Track Speed');

		var stepperBPM:FlxUINumericStepper = new FlxUINumericStepper(1, 380, 1, 1, 1, 339, 0);
		stepperBPM.value = Conductor.bpm;
		stepperBPM.name = 'song_bpm';
		var stepperBPMLabel = new FlxText(stepperBPM.x + 60, stepperBPM.y - 1, 'Track BPM');

		clearNotesButton = new FlxButton(5, stepperBPM.y - 50, "Clear Notes", function(){for (sec in 0..._song.notes.length){
			_song.notes[sec].sectionNotes = [];}
				clearNotesButton.color = FlxColor.RED;
				updateGrid();
			}
		);
		clearNotesButton.color = FlxColor.WHITE;

		var tab_group_song = new FlxUI(null, UI_box);
		tab_group_song.name = "Song";
		tab_group_song.add(UI_songTitle);
		tab_group_song.add(UI_artistTitle);
		tab_group_song.add(songNameLabel);
		tab_group_song.add(artistNameLabel);
		tab_group_song.add(check_voices);
		tab_group_song.add(saveButton);
		tab_group_song.add(reloadSong);
		tab_group_song.add(reloadSongJson);
		tab_group_song.add(loadAutosaveBtn);
		tab_group_song.add(clearNotesButton);
		tab_group_song.add(stepperBPM);
		tab_group_song.add(stepperSpeed);
		tab_group_song.add(stepperBPMLabel);
		tab_group_song.add(stepperSpeedLabel);
		tab_group_song.add(player1LabelName);
		tab_group_song.add(player2LabelName);
		tab_group_song.add(player1DropDown);
		tab_group_song.add(player2DropDown);
		UI_box.addGroup(tab_group_song);
		UI_box.scrollFactor.set();
		FlxG.camera.follow(strumLine);
	}
	function addSectionUI():Void{
		var tab_group_section = new FlxUI(null, UI_box);
		tab_group_section.name = 'Section';

		check_altAnim = new FlxUICheckBox(5, 10, null, null, "Alt Sings", 100);
		check_altAnim.name = 'check_altAnim';
		
		stepperSectionBPM = new FlxUINumericStepper(5, 120, 1, Conductor.bpm, 0, 999, 0);
		stepperSectionBPM.value = Conductor.bpm;
		stepperSectionBPM.name = 'section_bpm';
		check_changeBPM = new FlxUICheckBox(stepperSectionBPM.x, stepperSectionBPM.y - 20, null, null, 'Change BPM', 100);
		check_changeBPM.name = 'check_changeBPM';
		var stepperBpmLabel = new FlxText(stepperSectionBPM.x - 2, stepperSectionBPM.y - 35, 'BPM Section:');
		
		/*var moreBoxCheck = new FlxUICheckBox(10, 45, null, null, "moreNotes", 100);
		moreBoxCheck.checked = _song.fiveNotes;
		moreBoxCheck.callback = function(){
			_song.fiveNotes = false;
			if (moreBoxCheck.checked)
				_song.fiveNotes = true;
			updateGrid();
		};*/

		var swapSection:FlxButton;
		swapSection = new FlxButton(5, 355, "Swap Section", function(){
			for (i in 0..._song.notes[curSection].sectionNotes.length){
				var note = _song.notes[curSection].sectionNotes[i];
				note[1] = (note[1] + 4) % 8;
				_song.notes[curSection].sectionNotes[i] = note;
				updateGrid();
			}
		});
		var clearSectionButton:FlxButton = new FlxButton(swapSection.x + 100, swapSection.y, "Clear Section", clearSection);
		stepperLength = new FlxUINumericStepper(1, 380, 4, 0, 0, 1000, 0);
		stepperLength.value = _song.notes[curSection].lengthInSteps;
		stepperLength.name = "section_length";
		var stepperSectionLabel = new FlxText(stepperLength.x + 64, stepperLength.y - 1, 'Section Lenght');

		var copyButton:FlxButton;
		var stepperCopy:FlxUINumericStepper = new FlxUINumericStepper(1, 408, 1, 1, -1000, 1000, 0);
		copyButton = new FlxButton(stepperCopy.x + 60, stepperCopy.y - 1, "Copy Section", function(){
			copySection(Std.int(stepperCopy.value));
		});
		copyButton.scale.x = buttomScaleShit;
		copyButton.scale.y = buttomScaleShit;
		var stepperSectionCopyShitLabel = new FlxText(stepperCopy.x - 2, stepperCopy.y - 15, 'Copy Section Lenght:');

		tab_group_section.add(stepperLength);
		tab_group_section.add(stepperSectionLabel);
		tab_group_section.add(stepperSectionBPM);
		tab_group_section.add(stepperCopy);
		tab_group_section.add(stepperSectionCopyShitLabel);
		tab_group_section.add(check_altAnim);
		tab_group_section.add(stepperBpmLabel);
		tab_group_section.add(check_changeBPM);
		tab_group_section.add(copyButton);
		tab_group_section.add(clearSectionButton);
		tab_group_section.add(swapSection);
		UI_box.addGroup(tab_group_section);
	}
	function loadSong(daSong:String):Void{
		if (FlxG.sound.music != null) FlxG.sound.music.stop();
		Actions.PlayInst(daSong);
		vocals = new FlxSound().loadEmbedded(Paths.voices(daSong));
		FlxG.sound.list.add(vocals);
		FlxG.sound.music.pause();
		vocals.pause();
		FlxG.sound.music.onComplete = function(){
			vocals.pause();
			vocals.time = 0;
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
			changeSection();
		};
	}
	function generateUI():Void{
		while (bullshitUI.members.length > 0)
			bullshitUI.remove(bullshitUI.members[0], true);
		var title:FlxText = new FlxText(UI_box.x + 20, UI_box.y + 20, 0);
		bullshitUI.add(title);
	}
	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>){
		if (id == FlxUICheckBox.CLICK_EVENT){
			var check:FlxUICheckBox = cast sender;
			switch (check.getLabel().text){
				case 'BoyFriend Turn':
					_song.notes[curSection].mustHitSection = check.checked;
					updateIcons();
				case 'Change BPM': _song.notes[curSection].changeBPM = check.checked;
				case "Alt Sings": _song.notes[curSection].altAnim = check.checked;
			}
			updateGrid();
		}else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper)){
			var nums:FlxUINumericStepper = cast sender;
			switch (nums.name){
				case 'section_length':
					_song.notes[curSection].lengthInSteps = Std.int(nums.value);
					updateGrid();
				case 'song_speed': _song.speed = nums.value;
				case 'song_bpm':
					tempBpm = Std.int(nums.value);
					Conductor.mapBPMChanges(_song);
					Conductor.changeBPM(Std.int(nums.value));
				case 'note_susLength':
					curSelectedNote[2] = nums.value;
					updateGrid();
				case 'section_bpm':
					_song.notes[curSection].bpm = Std.int(nums.value);
					updateGrid();
				case 'song_vocalvol': vocals.volume = nums.value;
				case 'song_instvol': FlxG.sound.music.volume = nums.value;
				case 'type_mechanicsNotes':
					if (noteType == noteType){
						noteNameLabel.text = Note.instance.noteName;
						noteDescriptionLabel.text = Note.instance.noteDescription;
					}
					noteType = Std.int(nums.value);
					updateGrid();
			}
		}
	}
	function sectionStartTime():Float{
		var daBPM:Int = _song.bpm;
		var daPos:Float = 0;
		for (i in 0...curSection){
			if (_song.notes[i].changeBPM)
				daBPM = _song.notes[i].bpm;
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}
	override function update(elapsed:Float){
		curStep = recalculateSteps();
		/*moreBox = (_song.fiveNotes ? 1 : 0);
		if (moreBox == 1 && gridBG.width != CHANGEABLE_GRID_SIZE * 10){
			remove(gridBG);
			gridBG = FlxGridOverlay.create(CHANGEABLE_GRID_SIZE, GRID_SIZE, CHANGEABLE_GRID_SIZE * 10, GRID_SIZE * 16);
			add(gridBG);
		}
		if (moreBox == 0 && gridBG.width != GRID_SIZE * 8){
			remove(gridBG);
			gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
			add(gridBG);
		}*/
		/*switch (moreBox){
			case 0: if (gridBG.width != GRID_SIZE * 8){
				remove(gridBG);
				gridBG = FlxGridOverlay.create(GRID_SIZE, GRID_SIZE, GRID_SIZE * 8, GRID_SIZE * 16);
				add(gridBG); }
			case 1: if (gridBG.width != CHANGEABLE_GRID_SIZE * 10){
				remove(gridBG);
				gridBG = FlxGridOverlay.create(CHANGEABLE_GRID_SIZE, GRID_SIZE, CHANGEABLE_GRID_SIZE * 10, GRID_SIZE * 16);
				add(gridBG); }
		}*/
		Conductor.songPosition = FlxG.sound.music.time;
		_song.song = typingSong.text;
		_song.artist = typingArtist.text;
		if (noteType == noteType){
			noteNameLabel.text = Note.instance.noteName;
			noteDescriptionLabel.text = Note.instance.noteDescription;
		}
		strumLine.y = getYfromStrum((Conductor.songPosition - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps));
		arrowEventStumLine.y = strumLine.y - 59;
		if (curBeat % 4 == 0 && curStep >= 16 * (curSection + 1)){
			if (_song.notes[curSection + 1] == null)
				addSection();
			changeSection(curSection + 1, false);
		}
		curRenderedNotes.forEachAlive(function(note:Note){
			(note.strumTime <= Conductor.songPosition ? note.alpha = 0.4 : note.alpha = 1);
		});
		if (FlxG.mouse.justPressed){
			if (FlxG.mouse.overlaps(curRenderedNotes)){
				curRenderedNotes.forEach(function(note:Note){
					if (FlxG.mouse.overlaps(note))
						(FlxG.keys.pressed.CONTROL ? selectNote(note) : deleteNote(note));
				});
			}else
				if (FlxG.mouse.x > gridBG.x && FlxG.mouse.x < gridBG.x + gridBG.width && FlxG.mouse.y > gridBG.y && FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps)) addNote();
		}
		if (FlxG.mouse.x > gridBG.x && FlxG.mouse.x < gridBG.x + gridBG.width && FlxG.mouse.y > gridBG.y && FlxG.mouse.y < gridBG.y + (GRID_SIZE * _song.notes[curSection].lengthInSteps)){
			dummyArrow.x = Math.floor(FlxG.mouse.x / GRID_SIZE) * GRID_SIZE;
			dummyArrow.y = (FlxG.keys.pressed.SHIFT ? FlxG.mouse.y : Math.floor(FlxG.mouse.y / GRID_SIZE) * GRID_SIZE);
		}
		if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.Z && lastNote != null)
			(curRenderedNotes.members.contains(lastNote) ? deleteNote(lastNote) : addNote(lastNote));
		if (FlxG.keys.justPressed.ENTER){
			autosaveSong();
			lastSection = curSection;
			PlayState.SONG = _song;
			FlxG.sound.music.stop();
			vocals.stop();
			Actions.States('Switch', new PlayState());
		}
		if (FlxG.keys.justPressed.E) changeNoteSustain(Conductor.stepCrochet);
        if (FlxG.keys.justPressed.Q) changeNoteSustain(-Conductor.stepCrochet);
		if (FlxG.keys.justPressed.TAB){
			(FlxG.keys.pressed.CONTROL ? UI_box.selected_tab -= 1 : UI_box.selected_tab += 1);
			if ((FlxG.keys.pressed.CONTROL ? UI_box.selected_tab < 0 : UI_box.selected_tab > UI_box.length - 1))
				(FlxG.keys.pressed.CONTROL ? UI_box.selected_tab = 0 : UI_box.selected_tab = UI_box.length - 1);
		}
		if (!typingSong.hasFocus && !typingArtist.hasFocus){
			if (FlxG.keys.justPressed.SPACE){
				autosaveSong();
				(FlxG.sound.music.playing ? vocals.pause() : vocals.play());
				(FlxG.sound.music.playing ? FlxG.sound.music.pause() : FlxG.sound.music.play()); 
			}
			if (FlxG.keys.justPressed.R) resetSection((FlxG.keys.pressed.SHIFT ? true : false));
			if (FlxG.mouse.wheel != 0){
				FlxG.sound.music.pause();
				FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.8);
				if (vocals != null){
					vocals.pause();
					vocals.time = FlxG.sound.music.time;
				}
			}
			if (FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.W || FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.S || !FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.W || !FlxG.keys.pressed.SHIFT && FlxG.keys.pressed.S){
				FlxG.sound.music.pause();
				vocals.pause();
				(FlxG.keys.pressed.W ? FlxG.sound.music.time -= (!FlxG.keys.pressed.SHIFT ? 700 * FlxG.elapsed : Conductor.stepCrochet * 2) : FlxG.sound.music.time += (!FlxG.keys.pressed.SHIFT ? 700 * FlxG.elapsed : Conductor.stepCrochet * 2));
				vocals.time = FlxG.sound.music.time;
			}
		}
		_song.bpm = tempBpm;
		if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.D) changeSection(curSection + (FlxG.keys.pressed.SHIFT ? 5 : 1));
		if (FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A) changeSection(curSection - (FlxG.keys.pressed.SHIFT ? 5 : 1));
		informationText.text = "CurTrackPosition: "
			+ Std.string(FlxMath.roundDecimal(Conductor.songPosition / 1000, 2))
			+ "\nTrackLenght: "
			+ Std.string(FlxMath.roundDecimal(FlxG.sound.music.length / 1000, 2))
			+ "\nCurTrack: "
			+ _song.song
			+ "\nCurDiff: "
			+ CoolUtil.difficultyFromInt(PlayState.mainDifficulty)
			+ "\nCurSection: "
			+ curSection
			+ "\nCurStep: "
			+ curStep
			+ "\nCurBeat: "
			+ curBeat;
		super.update(elapsed);
	}
	function changeNoteSustain(Value:Float):Void{
		if (curSelectedNote != null && curSelectedNote[2] != null){
			curSelectedNote[2] += Value;
			curSelectedNote[2] = Math.max(curSelectedNote[2], 0);
		}
		autosaveSong();
		updateNoteUI();
		updateGrid();
	}
	function recalculateSteps():Int{
		var lastChange:BPMChangeEvent ={
			stepTime: 0,
			songTime: 0,
			bpm: 0
		}
		for (i in 0...Conductor.bpmChangeMap.length)
			if (FlxG.sound.music.time > Conductor.bpmChangeMap[i].songTime) lastChange = Conductor.bpmChangeMap[i];
		curStep = lastChange.stepTime + Math.floor((FlxG.sound.music.time - lastChange.songTime) / Conductor.stepCrochet);
		updateBeat();
		return curStep;
	}
	function resetSection(songBeginning:Bool = false):Void{
		updateGrid();
		FlxG.sound.music.pause();
		vocals.pause();
		FlxG.sound.music.time = sectionStartTime();
		if (songBeginning){
			FlxG.sound.music.time = 0;
			curSection = 0;
		}
		if (vocals != null){
			vocals.pause();
			vocals.time = FlxG.sound.music.time;
		}
		updateCurStep();
		updateGrid();
		updateSectionUI();
		//updateWaveform();
	}
	function changeSection(sec:Int = 0, ?updateMusic:Bool = true):Void{
		if (_song.notes[sec] != null){
			curSection = sec;
			updateGrid();
			if (updateMusic){
				FlxG.sound.music.pause();
				FlxG.sound.music.time = sectionStartTime();
				if (vocals != null){
					vocals.pause();
					vocals.time = FlxG.sound.music.time;
				}
				updateCurStep();
			}
			updateGrid();
			updateSectionUI();
		}else
			changeSection();
		Conductor.songPosition = FlxG.sound.music.time;
		//updateWaveform();
	}
	function copySection(?sectionNum:Int = 1){
		var daSec = FlxMath.maxInt(curSection, sectionNum);
		for (note in _song.notes[daSec - sectionNum].sectionNotes){
			var strum = note[0] + Conductor.stepCrochet * (_song.notes[daSec].lengthInSteps * sectionNum);
			var copiedNote:Array<Dynamic> = [strum, note[1], note[2]];
			_song.notes[daSec].sectionNotes.push(copiedNote);
		}
		updateGrid();
	}
	function updateSectionUI():Void{
		var sec = _song.notes[curSection];
		stepperLength.value = sec.lengthInSteps;
		check_mustHitSection.checked = sec.mustHitSection;
		check_altAnim.checked = sec.altAnim;
		check_changeBPM.checked = sec.changeBPM;
		stepperSectionBPM.value = sec.bpm;
		updateIcons();
	}
	function updateIcons():Void{
		leftIcon.setPosition((check_mustHitSection.checked ? 0 : gridBG.width / 2), -100);
		leftIcon.flipX = (check_mustHitSection.checked ? false : true);
		rightIcon.setPosition((check_mustHitSection.checked ? gridBG.width / 2 : 0), -100);
		rightIcon.flipX = (check_mustHitSection.checked ? true : false);
	}
	function updateNoteUI():Void{
		if (curSelectedNote != null) stepperSusLength.value = curSelectedNote[2];
	}
	function updateGrid():Void{
		//if (waveformEnabled != null)
			//updateWaveform();
		while (curRenderedNotes.members.length > 0)
			curRenderedNotes.remove(curRenderedNotes.members[0], true);
		while (curRenderedSustains.members.length > 0)
			curRenderedSustains.remove(curRenderedSustains.members[0], true);
		var sectionInfo:Array<Dynamic> = _song.notes[curSection].sectionNotes;
		if (_song.notes[curSection].changeBPM && _song.notes[curSection].bpm > 0)
			Conductor.changeBPM(_song.notes[curSection].bpm);
		else{
			var daBPM:Int = _song.bpm;
			for (i in 0...curSection)
				if (_song.notes[i].changeBPM)
					daBPM = _song.notes[i].bpm;
			Conductor.changeBPM(daBPM);
		}
		for (i in sectionInfo){
			var daNoteInfo = i[1];
			var daStrumTime = i[0];
			var daSus = i[2];
			var daType = i[3];
			var note:Note = new Note(daStrumTime, daNoteInfo % 4, null, false, daType);
			note.sustainLength = daSus;
			note.setGraphicSize(GRID_SIZE, GRID_SIZE);
			note.updateHitbox();
			note.x = Math.floor(daNoteInfo * GRID_SIZE);
			note.y = Math.floor(getYfromStrum((daStrumTime - sectionStartTime()) % (Conductor.stepCrochet * _song.notes[curSection].lengthInSteps)));
			if (curSelectedNote != null && curSelectedNote[0] == note.strumTime) lastNote = note;
			curRenderedNotes.add(note);
			if (daSus > 0){
				var sustainVis:FlxSprite = new FlxSprite(note.x + (GRID_SIZE / 2),
				note.y + GRID_SIZE).makeGraphic(8, Math.floor(FlxMath.remapToRange(daSus, 0, Conductor.stepCrochet * _song.notes[curSection].lengthInSteps, 0, gridBG.height)));
				curRenderedSustains.add(sustainVis);
			}
		}
	}
	private function addSection(lengthInSteps:Int = 16):Void{
		var sec:SwagSection ={
			lengthInSteps: lengthInSteps,
			bpm: _song.bpm,
			changeBPM: false,
			mustHitSection: true,
			sectionNotes: [],
			typeOfSection: 0,
			altAnim: false
		};
		_song.notes.push(sec);
	}
	function selectNote(note:Note):Void{
		var swagNum:Int = 0;
		for (i in _song.notes[curSection].sectionNotes){
			if (i.strumTime == note.strumTime && i.noteData % 4 == note.noteData)
				curSelectedNote = _song.notes[curSection].sectionNotes[swagNum];
			swagNum += 1;
		}
		updateGrid();
		updateNoteUI();
	}
	function deleteNote(note:Note):Void{
		lastNote = note;
		for (i in _song.notes[curSection].sectionNotes)
			if (i[0] == note.strumTime && i[1] % 4 == note.noteData)
				_song.notes[curSection].sectionNotes.remove(i);
		updateGrid();
	}
	function clearSection():Void{
		_song.notes[curSection].sectionNotes = [];
		updateGrid();
	}
	private function addNote(?n:Note):Void{
		var noteStrum = getStrumTime(dummyArrow.y) + sectionStartTime();
		var noteData = Math.floor(FlxG.mouse.x / GRID_SIZE);
		var noteSus = 0;
		(n == null ? _song.notes[curSection].sectionNotes.push([noteStrum, noteData, noteSus, noteType]) 
		: _song.notes[curSection].sectionNotes.push([n.strumTime, n.noteData, n.sustainLength, n.noteType]));
		curSelectedNote = _song.notes[curSection].sectionNotes[_song.notes[curSection].sectionNotes.length - 1];
		updateGrid();
		updateNoteUI();
		autosaveSong();
	}
	function getStrumTime(yPos:Float):Float{
		return FlxMath.remapToRange(yPos, gridBG.y, gridBG.y + gridBG.height, 0, 16 * Conductor.stepCrochet);
	}
	function getYfromStrum(strumTime:Float):Float{
		return FlxMath.remapToRange(strumTime, 0, 16 * Conductor.stepCrochet, gridBG.y, gridBG.y + gridBG.height);
	}
	function getNotes():Array<Dynamic>{
		var noteData:Array<Dynamic> = [];
		for (i in _song.notes)
			noteData.push(i.sectionNotes);
		return noteData;
	}
	function reloadTrackJson(song:String):Void{
		PlayState.SONG = Song.loadFromJson(song.toLowerCase(), song.toLowerCase());
		FlxG.resetState();
	}
	function loadAutosave():Void{
		PlayState.SONG = Song.parseJSONshit(FlxG.save.data.autosave);
		FlxG.resetState();
	}
	function autosaveSong():Void{
		FlxG.save.data.autosave = Json.stringify({
			"song": _song
		});
		FlxG.save.flush();
	}
	private function saveSong(){
		var json ={
			"song": _song
		};
		var data:String = Json.stringify(json);
		if ((data != null) && (data.length > 0)){
			_file = new FileReference();
			_file.addEventListener(Event.COMPLETE, onSaveComplete);
			_file.addEventListener(Event.CANCEL, onSaveCancel);
			_file.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
			_file.save(data.trim(), _song.song.toLowerCase() + CoolUtil.difficultyData(PlayState.mainDifficulty) + ".json");
		}
	}
	function onSaveComplete(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}
	function onSaveCancel(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}
	function onSaveError(_):Void{
		_file.removeEventListener(Event.COMPLETE, onSaveComplete);
		_file.removeEventListener(Event.CANCEL, onSaveCancel);
		_file.removeEventListener(IOErrorEvent.IO_ERROR, onSaveError);
		_file = null;
	}
}