package;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxSprite;
using StringTools;
class ConsoleCodeState extends MusicBeatState{
    public static var enableNumAllowedToPress:String = 'ONETWOTHREEFOURFIVESIXSEVENEIGHTNINEZERO';
    public static var enableKeyAllowedToPress:String = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    var enablesKeys = enableKeyAllowedToPress + enableNumAllowedToPress;
    public static var enableNumKeyAllowedToPress:String = '1234567890';
    public static var secretSongName:String = '';
    var getCodeByKeyboard:String = '';
    var getTextForKeyboard:FlxText;
    var PressedResetIcon = false;
    var PressedExitIcon = false;
    var resetIcon:NewSprite;
    var exitIcon:NewSprite;
    var publicCode:Int = 0;
    var writtenCodeName:Array<String> =[ // CUSTOM WRITTEN CODES TO GET
        'CRACKERS', // Secret/Meme/Credits State (depends how you are going to do it)
        'TANPOWDER', // Secret Song Base of You Use
        'MODDINGTOOLS' // Tools in Engine to Make Mods (You Need This to Make Mods "Any Change")
        //'DEVELOPERTROUBLE' // engine team collaboration coming soon (or not)
	];
    function finalPressCode(){ // Get Exit Old Code Type
        switch (publicCode){
            case 3: Actions.PlaySound('confirmMenu', 0.725);
                if (!FlxG.save.data.trrBF) FlxG.save.data.trrBF = true;
        }
    }
    function GetOldTypedCode(){ // OLD TYPE SECRET CODE TO USE
        if (!FlxG.save.data.trrBF && FlxG.keys.justPressed.T) codePress(0);
        if (!FlxG.save.data.trrBF && FlxG.keys.justPressed.R) codePress(1);
        if (!FlxG.save.data.trrBF && FlxG.keys.justPressed.R) codePress(2);
        if (controls.ACCEPT) finalPressCode();
    }
    function GetNewTypedCode(codeNames:String){ switch (codeNames){ // NEW TYPE SECRET CODE TO USE
            //case 'DEVELOPERTROUBLE': Actions.LoadTrackChart("devs-trouble-very-hard", 'devs-trouble', 0.525, 3, 2077, 'Freeplay', true, true, 0.325, FlxColor.RED); // Unused
            case 'CRACKERS': // CRACKERS BOY, I LOVE THIS XP
                SecretState.NeedName = 'CRACKERS';
                Actions.PlaySound('confirmMenu', 0.725);
                Actions.States('Switch', new SecretState());
            case 'MODDINGTOOLS': // WELL, UNLOCKED Items in Engine for Modding
                if (FlxG.save.data.moddingTools){
                    Actions.PlaySound('cancelMenu');
                    Actions.States('Switch', new MainMenuState());
                }else{
                    Actions.PlaySound('confirmMenu', 0.725);
                    FlxG.save.data.moddingTools = true;
                    Actions.States('Reset');
                }
            case 'TANPOWDER': // Tankman Sings GunFight/Gunpowde
                switch (FlxG.save.data.mode){
                    default: 
                        Actions.PlaySound('cancelMenu');
                        Actions.States('Reset');
                    case 1:
                        secretSongName = 'TANPOWDER';
                        PlayState.stateShit = 'Secret';
                        CharacterSelect.getSongName = secretSongName;
                        (FlxG.save.data.charSelect != 1 ? loadSecretSong(secretSongName) : Actions.States('Switch', new CharacterSelect()));
                }
        }
    }
    public static function loadSecretSong(secretSongNameShitA:String){ // Only to Use For Secret Song or anything, whatever 
        switch (secretSongNameShitA){
            case 'TANPOWDER': Actions.LoadTrackChart("tanpowder", 'tanpowder', 4, 650, 3, null, true, true, 1.25, FlxColor.WHITE);
        }
    }
    public static function saveNullCodes(Reset:Bool){ // Client Datas (Only Secrets)
        if (Reset){
            FlxG.save.data.moddingTools = null;
            FlxG.save.data.trrBF = null;
        }else{
            if (FlxG.save.data.moddingTools == null)
                FlxG.save.data.moddingTools = false;
            if (FlxG.save.data.trrBF == null)
                FlxG.save.data.trrBF = false;
        }
    }
    override public function create(){
        FlxG.mouse.visible = true;
        PlayState.IsPlayState = false;
        OptionsMenu.isFreeplay = false;
		OptionsMenu.isMainMenu = false;
		OptionsMenu.isStoryMenu = false;
        PressedExitIcon = false;
        PressedResetIcon = false;
		secretSongName = '';
		CharacterSelect.getSongName = '';
        getTextForKeyboard = new FlxText(333, 60, 0, "", 28);
        add(getTextForKeyboard);
        var BG = new FlxSprite().loadGraphic(Paths.image('BGMenus/LoadingBG'));
        BG.alpha = 0.6;
        BG.screenCenter(X);
        add(BG);
        exitIcon = new NewSprite(-10, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Exit_Idle', 'Exit_MouseOver']);
		NewSprite.SpriteComplement.setVariables(exitIcon, true, null, null, 0.25, 0.25);
		add(exitIcon);
        resetIcon = new NewSprite(1215, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Reset_Idle', 'Reset_MouseOver']);
		NewSprite.SpriteComplement.setVariables(resetIcon, true, null, null, 0.25, 0.25);
		add(resetIcon);
        super.create();
    }
    override function update(elapsed:Float){
        GetOldTypedCode();
        if (FlxG.keys.firstJustPressed() != FlxKey.NONE){
            var keyboardPressed:FlxKey = FlxG.keys.firstJustPressed();
            var outPutKeyboardGetPressed:String = Std.string(keyboardPressed);
            if (enablesKeys.contains(outPutKeyboardGetPressed)){
                getTextForKeyboard.text += outPutKeyboardGetPressed;
                getCodeByKeyboard += outPutKeyboardGetPressed;
                if (getTextForKeyboard.text.length >= 25)
                    getTextForKeyboard.text = getTextForKeyboard.text.substring(1);
				if (getCodeByKeyboard.length >= 25)
                    getCodeByKeyboard = getCodeByKeyboard.substring(1);
                for (deciphered in writtenCodeName){
					var readyCode:String = deciphered.toUpperCase();
					if (getCodeByKeyboard.contains(readyCode)) // CODE TYPING IN CONSOLE WORKING
                        GetNewTypedCode(readyCode);
                }
            }
        }
        if (FlxG.mouse.overlaps(exitIcon)){
			if (!PressedResetIcon){
                Actions.PlaySprAnim(exitIcon, "Exit_MouseOver");
				if (!PressedExitIcon && FlxG.mouse.justPressed){ // QUIT OF CONSOLESTATE
					PressedExitIcon = true;
                    Actions.PlaySound('cancelMenu');
                    Actions.States('Switch', new MainMenuState());
				}
			}
		}else
			if (!PressedExitIcon) Actions.PlaySprAnim(exitIcon, "Exit_Idle");
        if (FlxG.mouse.overlaps(resetIcon)){
            if (!PressedExitIcon){
                Actions.PlaySprAnim(resetIcon, "Reset_MouseOver");
                if (!PressedResetIcon && FlxG.mouse.justPressed){
                    PressedResetIcon = true;
                    new FlxTimer().start(1.5, function(tmr:FlxTimer){
                        Actions.States('Reset');
                    });
                }
            }
        }else
            if (!PressedResetIcon) Actions.PlaySprAnim(resetIcon, "Reset_Idle");
        super.update(elapsed);
    }
    function codePress(ifNum:Int){
        if (publicCode == ifNum){
            publicCode = ifNum + 1;
            Actions.PlaySound('scrollMenu', 0.725);
        }else
            publicCode == 0;
    }
}