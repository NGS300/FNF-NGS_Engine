package;
import haxe.Json;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.util.FlxTimer;
import Boyfriend.Boyfriend;
import HealthIcon.HealthIcon;
import flixel.ui.FlxBar;
using StringTools;
class CharacterSelect extends MusicBeatState{
    private var characterSeeArray:Array<Boyfriend> = [];
    private var grpAlphabet:FlxTypedGroup<Alphabet>;
    public static var charSelected:String = '';
    public static var getSongName:String = '';
    var lockedCharSelected:Bool = false;
    var nameLocationStateTxt:FlxText;
    var PressedExitIcon:Bool = false;
    var nameCharSelectTxt:FlxText;
    var doesntExist:Bool = false;
    var pressedSkip:Bool = false;
    var curSelectedChar:Int;
    var charPush:HealthIcon;
    var exitIcon:NewSprite;
    var skipIcon:NewSprite;
    var BG:NewSprite;
    //var IsCharacterSelect:Bool = true;
    function makeActionChar(charSelected:String){ // Background Color
        switch (charSelected){
            default: changeBG(true);
            case 'bf-pixel': 
                changeBG(true);
                offsetCharSect(3, -185, -130, 1.25);
        }
    }
    override function create(){
        CharacterSettigs.CharacterRecognition = Json.parse(openfl.utils.Assets.getText(Paths.type(Client.Public.gameFolder + 'CharacterList', 'json', 'TEXT','config')));
        pressedSkip = false;
        PressedExitIcon = false;
        BG = new NewSprite(0, 0, 'BGMenus/CharacterSelectBG', null, true, 0.35);
        NewSprite.SpriteComplement.setVariables(BG, true, 1, null, null, null, null, null, true);
        add(BG);
        grpAlphabet = new FlxTypedGroup<Alphabet>();
        add(grpAlphabet);
        for (i in 0...CharacterSettigs.CharacterRecognition.Boyfriends.length){
            var otherGet:Alphabet = new Alphabet(170, (70 * i) + 230, CharacterSettigs.CharacterRecognition.Boyfriends[i], true, false);
            otherGet.isCharacterSelect = true;
            otherGet.targetY = i;
            grpAlphabet.add(otherGet);
            var charPush:Boyfriend = new Boyfriend(0, 0, CharacterSettigs.CharacterRecognition.Boyfriends[i]);
            charPush.sprTracker = otherGet;
            charPush.scale.set(0.8, 0.8);
            charPush.antialiasing = charPush.antialiasing;
            characterSeeArray.push(charPush);
            add(charPush);
        }
        nameLocationStateTxt = new FlxText(-1, 680, 0, "Character Select", 36);
        nameLocationStateTxt.setFormat(Paths.font("Highman.ttf"), 36, FlxColor.WHITE, FlxTextAlign.RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(nameLocationStateTxt);
        nameCharSelectTxt = new FlxText(-1, 680, 0, "", 38);
        nameCharSelectTxt.setFormat(Paths.font("Highman.ttf"), 38, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(nameCharSelectTxt);
        var arrows:NewSprite = new NewSprite(290, 180, 'BGMenus/ArrowCharacterSlect');
        NewSprite.SpriteComplement.setVariables(arrows, true, null, null, null, null, null, null);
        add(arrows);
        skipIcon = new NewSprite(1171, -22, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Skip_Idle', 'Skip_MouseOver']);
		NewSprite.SpriteComplement.setVariables(skipIcon, true, null, null, 0.25, 0.25);
		add(skipIcon);
        exitIcon = new NewSprite(-10, -10, 'MainMenuIcon_Assets', null, true, 1.0, 0, 0, ['Exit_Idle', 'Exit_MouseOver']);
		NewSprite.SpriteComplement.setVariables(exitIcon, true, null, null, 0.25, 0.25);
		add(exitIcon);
        changeCharSee();
        super.create();
    }
    override function update(elapsed:Float){
        nameCharSelectTxt.text = CharacterSettigs.CharacterRecognition.BoyfriendsNames[curSelectedChar].toUpperCase();
        nameCharSelectTxt.x = FlxG.width - (nameCharSelectTxt.width + 10);
        if (nameCharSelectTxt.text == '') nameCharSelectTxt.text = '';
        if (characterSeeArray[curSelectedChar].animation.curAnim.name == 'idle' && characterSeeArray[curSelectedChar].animation.curAnim.finished && doesntExist) Actions.PlayCharAnim(characterSeeArray[curSelectedChar], 'idle', true);
        if (!lockedCharSelected){
            if (FlxG.mouse.overlaps(exitIcon)){
                if (!pressedSkip){
                    Actions.PlaySprAnim(exitIcon, "Exit_MouseOver");
                    if (!PressedExitIcon && FlxG.mouse.justPressed){ // QUIT OF CONSOLESTATE
                        PressedExitIcon = true;
                        lockedCharSelected = true;
                        Actions.PlaySound('cancelMenu');
                        switch (PlayState.stateShit){
                            case 'StoryMode': Actions.States('Switch', new StoryMenuState());
                            case 'Freeplay': Actions.States('Switch', new FreeplayState());
                            case 'Secret': Actions.States('Switch', new ConsoleCodeState());
                        }
                    }
                }
            }else
                if (!PressedExitIcon) Actions.PlaySprAnim(exitIcon, "Exit_Idle");
            if (FlxG.mouse.overlaps(skipIcon)){  // Skip Character Select
                if (!PressedExitIcon){
                    Actions.PlaySprAnim(skipIcon, 'Skip_MouseOver');
                    if (!pressedSkip /*&& !OptionsMenu.isMainMenu*/ && FlxG.mouse.justPressed){
                        //OptionsMenu.isCharacterSelect = true;
                        //OptionsMenu.disableMerges = true;
                        pressedSkip = true;
                        lockedCharSelected = true;
                        charSelected = PlayState.SONG.player1;
                        switch (PlayState.stateShit){
                            case 'StoryMode': StoryMenuState.loadStoryCutscene();
                            case 'Freeplay': Actions.States('LoadSwitch', new PlayState());
                            case 'Secret': ConsoleCodeState.loadSecretSong(getSongName);
                        }
                    }
                }
            }else
                if (!pressedSkip/* && !OptionsMenu.isMainMenu*/) Actions.PlaySprAnim(skipIcon, 'Skip_Idle');
            if (controls.LEFT_P){
                changeCharSee(-1);
                Actions.PlaySound('scrollMenu');
            }
            if (controls.RIGHT_P){
                changeCharSee(1);
                Actions.PlaySound('scrollMenu');
            }
            if (controls.ACCEPT){
                lockedCharSelected = true;
                charSelected = CharacterSettigs.CharacterRecognition.Boyfriends[curSelectedChar];
                FlxFlicker.flicker(characterSeeArray[curSelectedChar], 0);
                switch (PlayState.stateShit){
                    case 'StoryMode': Actions.PlaySound('confirmMenu'); StoryMenuState.loadStoryCutscene();
                    case 'Secret': ConsoleCodeState.loadSecretSong(getSongName);
                    case 'Freeplay': Actions.PlaySound('confirmMenu'); new FlxTimer().start(0.5, function(tmr:FlxTimer){ Actions.States('LoadSwitch', new PlayState()); });
                }
            }
        }
        super.update(elapsed);
    }
    function changeCharSee(change:Int = 0):Void{
        curSelectedChar += change;
        if (curSelectedChar < 0) curSelectedChar = (!FlxG.save.data.trrBF ? CharacterSettigs.CharacterGetLimit : CharacterSettigs.CharacterRecognition.Boyfriends.length - 1);
        if (curSelectedChar >= (!FlxG.save.data.trrBF ? CharacterSettigs.CharacterGetLimit : CharacterSettigs.CharacterRecognition.Boyfriends.length)) curSelectedChar = 0;
        var otherInt:Int = 0;
        for (i in 0...characterSeeArray.length) characterSeeArray[i].alpha = 0;
        characterSeeArray[curSelectedChar].alpha = 1;
        for (item in grpAlphabet.members){
            item.targetY = otherInt - curSelectedChar;
            otherInt++;
            item.alpha = 0;
        }
        doesntExist = false;
        charSelected = CharacterSettigs.CharacterRecognition.Boyfriends[curSelectedChar];
        remove(charPush);
        makeActionChar(charSelected);
        doesntExist = true;
        var healthBarBG:NewSprite = new NewSprite(FlxG.width - 155, FlxG.height * 0.9, 'healthBar', null, false, 1, 0, 0);
        NewSprite.SpriteComplement.setVariables(healthBarBG, true, null, null, null, null, null, null, true, X);
        add(healthBarBG);
        var healthBar:FlxBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
        healthBar.scrollFactor.set();
        healthBar.createFilledBar(0xFFFF0000, 0xFF66FF33);
        healthBar.visible = false;
        add(healthBar);
        charPush = new HealthIcon(CharacterSettigs.CharacterRecognition.Boyfriends[curSelectedChar], true);
        charPush.y = healthBar.y - (charPush.height / 2);
        charPush.x = FlxG.width - 155;
        charPush.setGraphicSize(-4);
        charPush.y -= 20;
        add(charPush);
    }
    function offsetCharSect(CharacterNumber:Int, ?X:Float = 0, ?Y:Float = 0, ?WidthSize:Float = 1){ // Set Character Position on Selections
        if (WidthSize != 1) characterSeeArray[CharacterNumber].setGraphicSize(Std.int(characterSeeArray[CharacterNumber].width * WidthSize));
        characterSeeArray[CharacterNumber].offset.set(X, Y);
    }
    function changeBG(?Color:FlxColor = 0xFF1a1a1a, ?IsJson:Bool = false){ // Set Background Color
        BG.color = (!IsJson ? Color : FlxColor.fromString((CharacterSettigs.CharacterRecognition.BoyfriendsBackgroundsColors[curSelectedChar] == null ? "0xFF1a1a1a" : CharacterSettigs.CharacterRecognition.BoyfriendsBackgroundsColors[curSelectedChar]))); 
    }
}