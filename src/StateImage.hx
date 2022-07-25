package;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
class StateImage{
    public static var scrollFactorYShit:Float = 0.125;
    public static var StoryBGColor:Int = 0xFFF9CF51; // Yellow Color BG StoryMode
    public static var FreeplayBG:FlxSprite;
    public static var magenta:FlxSprite;
    public static function FreeplayBGColor(spriteShit:FlxSprite, placeYouColor:Int = 0xFF8a2be2){ // Change Color BG Effect
        if (placeYouColor != FreeplayState.instance.curColor){
            if (FreeplayState.instance.colorTween != null) FreeplayState.instance.colorTween.cancel();
            FreeplayState.instance.curColor = placeYouColor;
            FreeplayState.instance.colorTween = FlxTween.color(spriteShit, 1, spriteShit.color, placeYouColor,{
                onComplete: function(twn:FlxTween){
                    FreeplayState.instance.colorTween = null;
                }
            });
        }
    }
    public static function BGSMenus(nameHX:String, ?push:Dynamic){ switch (nameHX){ // Backgrounds Menus
            case 'TittleBG': // Title State BG
                var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
                push(bg);
                var gradientDownScreen:FlxSprite = new FlxSprite().loadGraphic(Paths.image('TitleShit/gradient'));
                gradientDownScreen.setGraphicSize(1880, 256);
                gradientDownScreen.color = 0xFF680000;
                gradientDownScreen.alpha = 0.515;
                gradientDownScreen.x += 256;
                gradientDownScreen.y += 512;
                push(gradientDownScreen);
                FlxTween.color(gradientDownScreen, 2.025, 0xFFff0000, 0xFF680000, {ease: FlxEase.quadInOut, type: PINGPONG});
                var gradientTopScreen:FlxSprite = new FlxSprite().loadGraphic(Paths.image('TitleShit/gradient'));
                gradientTopScreen.setGraphicSize(1880, 256);
                gradientTopScreen.color = 0xFFff0000;
                gradientTopScreen.x += 256;
                gradientTopScreen.alpha = 0.325;
                gradientTopScreen.flipY = true;
                push(gradientTopScreen);
                FlxTween.color(gradientTopScreen, 2.025, 0xFF680000, 0xFFff0000, {ease: FlxEase.quadInOut, type: PINGPONG});
            case 'MainMenuBG': // This MainMenu BG
                var bgMainMenu:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('BGMenus/MainMenuBG'));
                bgMainMenu.scrollFactor.x = 0;
                bgMainMenu.scrollFactor.y = scrollFactorYShit;
                bgMainMenu.setGraphicSize(Std.int(bgMainMenu.width * 1.1));
                bgMainMenu.updateHitbox();
                bgMainMenu.screenCenter();
                bgMainMenu.antialiasing = Client.Public.antialiasing;
                push(bgMainMenu);
            case 'MainMenuUnderBG': // Is Imagem Show on Play Any Buttom (Example, Story Mode, Freeplay & etc)
                magenta = new FlxSprite(-80).loadGraphic(Paths.image('BGMenus/OptionsBG'));
                magenta.scrollFactor.x = 0;
                magenta.scrollFactor.y = scrollFactorYShit;
                magenta.setGraphicSize(Std.int(magenta.width * 1.1));
                magenta.updateHitbox();
                magenta.screenCenter();
                magenta.visible = false;
                magenta.antialiasing = Client.Public.antialiasing;
                push(magenta);
            case 'FreeplayBG': // Freeplay BG
                FreeplayBG = new FlxSprite().loadGraphic(Paths.image('BGMenus/FreeplayBG'));
                push(FreeplayBG);
            case 'FreeplaySwitchBGColor': // Freeplay BG Colors :D
                switch ((FreeplayState.instance.songs[FreeplayState.instance.curSelected].songName.toLowerCase())){
                    default: FreeplayBGColor(FreeplayBG, 0xFF010101);
                    case 'tutorial': FreeplayBGColor(FreeplayBG, 0xFFa5004d);
                    case 'bopeebo' | 'fresh' | 'dadbattle': FreeplayBGColor(FreeplayBG, 0xFFaf66ce);
                    case 'spookeez' | 'south': FreeplayBGColor(FreeplayBG, 0xFF32325a);
                    case 'monster': FreeplayBGColor(FreeplayBG, 0xFF32325a);
                    case 'pico' | 'philly' | 'blammed': FreeplayBGColor(FreeplayBG, 0xFF160c27);
                    case 'satin-panties' | 'high' | 'milf': FreeplayBGColor(FreeplayBG, 0xFFfc6c70);
                    case 'cocoa' | 'eggnog': FreeplayBGColor(FreeplayBG, 0xFF5456ba);
                    case 'winter-horrorland': FreeplayBGColor(FreeplayBG, 0xFF601447);
                    case 'senpai' | 'roses': FreeplayBGColor(FreeplayBG, 0xFFbb98ab);
                    case 'thorns': FreeplayBGColor(FreeplayBG, 0xFF18048b);
                    case 'ugh' | 'guns' | 'stress': FreeplayBGColor(FreeplayBG, 0xFFe28206);
                }
            case 'OptionsBG': // BG Options Menu
                var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("BGMenus/OptionsBG"));
                menuBG.color = 0xFFea71fd;
                menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
                menuBG.updateHitbox();
                menuBG.screenCenter();
                menuBG.antialiasing = FlxG.save.data.antialiasing;
                push(menuBG);
            case 'ChartingBG': // Charting BG and BG Colors
                var bgCharting:FlxSprite = new FlxSprite().loadGraphic(Paths.image('BGMenus/ChartingBG'));
                bgCharting.scrollFactor.set();
                push(bgCharting);
                switch (TrackMap.curMap){
                    default: bgCharting.color = 0xFF010101;
                    case 'stage': bgCharting.color = 0xFF957967;
                    case 'spooky': bgCharting.color = 0xFF32325a;
                    case 'philly': bgCharting.color = 0xFF160c27;
                    case 'limo': bgCharting.color = 0xFFfc6c70;
                    case 'mall': bgCharting.color = 0xFF5456ba;
                    case 'mallEvil': bgCharting.color = 0xFF601447;
                    case 'school': bgCharting.color = 0xFFbb98ab;
                    case 'schoolEvil': bgCharting.color = 0xFF18048b;
                    case 'tankDesert': bgCharting.color = 0xFFe28206;
                    case 'nevada': bgCharting.color = 0xFF4b0001;
                }
        }
    }
}
