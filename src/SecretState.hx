import flixel.util.FlxTimer;
import flixel.FlxG;
class SecretState extends MusicBeatState{
    public static var PushSecret:String = '';
    public static var NeedName:String = '';
    var PressedExitIcon = false;
    var exitIcon:NewSprite;
    override function create(){
        super.create();
        PushSecret = NeedName;
        switch (PushSecret){
            case 'CRACKERS': GIGACHAD();
        }
    }
    override function update(elapsed:Float){
        super.update(elapsed);
        switch (PushSecret){
            case 'CRACKERS':
                if (FlxG.mouse.overlaps(exitIcon)){
                    if (!PressedExitIcon) Actions.PlaySprAnim(exitIcon, 'Exit_MouseOver');
                    if (!PressedExitIcon && FlxG.mouse.justPressed){
                        PressedExitIcon = true;
                        Actions.PlaySprAnim(exitIcon, 'NoExit');
                        Actions.PlaySound('nope.avi', 'secrets');
                    }
                }else
                    if (!PressedExitIcon) Actions.PlaySprAnim(exitIcon, 'Exit_Idle');
                if (PressedExitIcon){
                    Actions.PlaySprAnim(exitIcon, 'NoExit');
                    new FlxTimer().start(1.25, function(tmr:FlxTimer){
                        PressedExitIcon = false;
                    });
			    }
        }
    }
    public function GIGACHAD(){ // Create The GIGA CHAD CRACK STATE
        FlxG.sound.music.stop();
        if (!FlxG.sound.music.playing) Actions.PlayTrack("GIGACHAD", 'secrets', 0.7);
        var crack:NewSprite = new NewSprite(0, 0, 'Crack_Gang', 'secrets');
        NewSprite.SpriteComplement.setVariables(crack, true, null, null, 0.6395, 0.72);
        add(crack);
        exitIcon = new NewSprite(-10, -10, 'MainMenuIcon_Assets', null, true, 1, 0, 0, ['Exit_Idle', 'Exit_MouseOver', 'NoExit']);
		NewSprite.SpriteComplement.setVariables(exitIcon, true, null, null, 0.25, 0.25);
		add(exitIcon);
    }
}