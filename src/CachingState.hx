import openfl.display.BitmapData;
import flixel.util.FlxTimer;
import sys.FileSystem;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
using StringTools;
typedef CacheOptions ={
    var DirectoryFoldersIcons:Array<String>; // "Check", Directory of Icons
    var CacheOnlyMusicsLoadingNumber:Float;
    var CacheOnlyImagesLoadingNumber:Float;
    var CacheAllLoadingNumber:Float;
    var noStrumHoldReaction:Bool;
    var strumNumMove:Float;
    var camMoveNum:Int;
}
class CachingState extends MusicBeatState{
    public static var bitmapData:Map<String, FlxGraphic>;
    public static var CacheConfig:CacheOptions;
    var ngsLogo:FlxSprite;
    var loadingTextPercent:FlxText;
    var loadingText:FlxText;
    var loadBar:FlxSprite;
    var percentNum:Float;
    var gameplayMusics = [];
    var images = [];
    var imagesGF = [];
    var imagesGF_Christmas = [];
    var imagesGF_Pixel = [];
    var imagesBF = [];
    var imagesBF_Christmas = [];
    var imagesBF_Pixel = [];
    var imagesDADWK0 = [];
    var imagesDADWK1 = [];
    var imagesDADWK2 = [];
    var imagesDADWK3 = [];
    var imagesDADWK4 = [];
    var imagesDADWK5 = [];
    var imagesDADWK6 = [];
    var imagesDADWK7 = [];
    var imagesChar = [];
    var imagesICON_Vanilla = [];
    var imagesICON_JP = [];
    var imagesICON_Juniorxefao = [];
    var imagesICON_Maty = [];
    var imagesICON_Kkpassaroxx = [];
    var loaded = false;
    var imagesLoaded = 0;
    var musicsLoaded = 0;
    var justImages = 0;
    var allNum = 0;
    var toDone = 0;
    var nump:Float = 2;
    override function create(){
        FlxG.save.bind('NGE', 'NGS300');
		PlayerSettings.init();
		Client.loadData();
        Client.loadJson();
        FlxG.mouse.visible = false;
        FlxG.worldBounds.set(0, 0);
		bitmapData = new Map<String, FlxGraphic>();
        var BG = new FlxSprite().loadGraphic(Paths.loadImage('BGMenus/LoadingBG'));
        if (FlxG.save.data.cacheType != 0)
            BG.alpha = 0;
        else
            BG.alpha = 1;
        BG.screenCenter(X);
        add(BG);

        loadingTextPercent = new FlxText(0, FlxG.height - 50, 0, "");
		loadingTextPercent.screenCenter(X);
		loadingTextPercent.antialiasing = Client.Public.antialiasing;
        loadingTextPercent.alpha = 0;
        loadingTextPercent.setFormat(Paths.font("Highman.ttf"), 32);

        loadingText = new FlxText(FlxG.width / 2 - 82, 70, 0, "");
		loadingText.antialiasing = Client.Public.antialiasing;
        loadingText.alpha = 0;
        loadingText.color = 0xFFff0000;
        loadingText.setFormat(Paths.font("Highman.ttf"), 55);

        loadBar = new FlxSprite(0, FlxG.height - 20).makeGraphic(FlxG.width, 10, 0xFFdaa520);
		loadBar.screenCenter(X);
		loadBar.antialiasing = Client.Public.antialiasing;

        getFolderToLoad();
        switch (FlxG.save.data.cacheType){
            case 1:
                allNum = Lambda.count(gameplayMusics);
            case 2:
                allNum = Lambda.count(imagesGF) + Lambda.count(imagesGF_Christmas) + Lambda.count(imagesGF_Pixel) + Lambda.count(imagesBF) + Lambda.count(imagesBF_Christmas) + Lambda.count(imagesBF_Pixel) + Lambda.count(imagesChar) + Lambda.count(imagesDADWK0) + Lambda.count(imagesDADWK1) + Lambda.count(imagesDADWK2) + Lambda.count(imagesDADWK3) + Lambda.count(imagesDADWK4) + Lambda.count(imagesDADWK5) + Lambda.count(imagesDADWK6) + Lambda.count(imagesDADWK7);
            case 3:
                allNum = Lambda.count(gameplayMusics) + Lambda.count(imagesGF) + Lambda.count(imagesGF_Christmas) + Lambda.count(imagesGF_Pixel) + Lambda.count(imagesBF) + Lambda.count(imagesBF_Christmas) + Lambda.count(imagesBF_Pixel) + Lambda.count(imagesChar) + Lambda.count(imagesDADWK0) + Lambda.count(imagesDADWK1) + Lambda.count(imagesDADWK2) + Lambda.count(imagesDADWK3) + Lambda.count(imagesDADWK4) + Lambda.count(imagesDADWK5) + Lambda.count(imagesDADWK6) + Lambda.count(imagesDADWK7) + Lambda.count(imagesICON_JP);
        }
        if (FlxG.save.data.cacheType != 0){
		    add(loadBar);
            add(loadingText);
            add(loadingTextPercent);
        }
        sys.thread.Thread.create(() ->{
            while (!loaded){
                if (allNum != 0 && toDone != allNum){
                    switch (FlxG.save.data.cacheType){
                        case 1: // Musics Only
                            refreshLoadingStats(CacheConfig.CacheOnlyMusicsLoadingNumber, BG);
                        case 2: // Images Only
                            refreshLoadingStats(CacheConfig.CacheOnlyImagesLoadingNumber, BG);
                        case 3: // All
                            refreshLoadingStats(CacheConfig.CacheAllLoadingNumber, BG);
                    }
                }
            }
        });
        sys.thread.Thread.create(() ->{
			toCache(FlxG.save.data.cacheType);
		});
        super.create();
    }
    override function update(elapsed){
		super.update(elapsed);
	}
    function toCache(whatIsDiretory:Int){
        switch (whatIsDiretory){
            case 0: // OFF
                new FlxTimer().start(3, function(tmr:FlxTimer){
                    loadBar.destroy();
                    loadingText.destroy();
                    FlxG.switchState(new TitleState());
                    trace("Skiped Caching");
                });
                loaded = true;
            case 1: // Musics Only
                #if !NEW_TYPE_CHECK_SONG
                    checkLoadObjects(false, true, false);
                    trace("Loaded Musics: " + musicsLoaded);
                    loaded = true;
                    new FlxTimer().start(2, function(tmr:FlxTimer){
                        loadBar.destroy();
                        loadingText.destroy();
                        loadingTextPercent.destroy();
                        FlxG.switchState(new TitleState());
                    });
                #else
                    new FlxTimer().start(3, function(tmr:FlxTimer){
                        loadBar.destroy();
                        loadingText.destroy();
                        loadingTextPercent.destroy();
                        FlxG.switchState(new TitleState());
                        trace("Skiped Caching");
                    });
                #end
            case 2: // Images Only
                checkLoadObjects(true, false, false);
                trace("Loaded Images: " + imagesLoaded);
                loaded = true;
                new FlxTimer().start(3, function(tmr:FlxTimer){
                    loadBar.destroy();
                    loadingText.destroy();
                    loadingTextPercent.destroy();
                    FlxG.switchState(new TitleState());
                });
            case 3: // All
                #if !NEW_TYPE_CHECK_SONG
                    checkLoadObjects(true, true, true);
                #else
                    checkLoadObjects(true, false, true);
                #end
                trace("Loaded Images: " + imagesLoaded + "\nLoaded Musics: " + musicsLoaded);
                loaded = true;
                new FlxTimer().start(2, function(tmr:FlxTimer){
                    loadBar.destroy();
                    loadingText.destroy();
                    loadingTextPercent.destroy();
                    FlxG.switchState(new TitleState());
                });
        }
    }
    inline function checkCharFolder(key:String){
        return 'assets/characters/images/$key';
    }
    function checkDiretoryFolder(diretoryPush:String, anyway:Dynamic){
        for (i in FileSystem.readDirectory(FileSystem.absolutePath(diretoryPush)))
            anyway.push(i);
    }
    function checkImageDiretoryFolder(diretoryPush:String, gayAnyWay:Dynamic){
        for (i in FileSystem.readDirectory(FileSystem.absolutePath(diretoryPush))){
            if (!i.endsWith(".png"))
                continue;
            gayAnyWay.push(i);
        }
    }
    function pushPNG(diretory:String, i:String){
        var replaced = i.replace(".png", "");
        var data:BitmapData = BitmapData.fromFile(diretory + i);
        var graph = FlxGraphic.fromBitmapData(data, false, false);
        graph.persist = true;
        graph.destroyOnNoUse = false;
        bitmapData.set(replaced, graph);
        imagesLoaded++;
        toDone++;
    }
    function refreshLoadingStats(name:Dynamic, BG:FlxSprite){
        var alpha = CoolUtil.floatDecimals(toDone / allNum * name, 2) / 100;
        loadingText.alpha = alpha;
        BG.alpha = alpha;
        loadingText.alpha = alpha;
        loadBar.scale.x = CoolUtil.floatDecimals(toDone / allNum * name, 2) / 100;
        if (toDone >= 0)
            percentNum = Math.round(toDone / allNum * name);
        else
            percentNum = 0;
        if (percentNum >= 99.5){
            loadingText.text = "Done.";
            loadingText.color = 0xFF00ff00;
        }else{
            loadingText.color = 0xFFff0000;
            loadingText.text = "Loading...";
        }
        if (percentNum >= 70 && percentNum < 99)
            loadingTextPercent.color = 0xFF028200;
        if (percentNum >= 40 && percentNum < 69)
            loadingTextPercent.color = 0xFFffd700;
        if (percentNum >= 0 && percentNum < 39)
            loadingTextPercent.color = 0xFFff0000;
        loadingTextPercent.text = percentNum + "%";
        loadingTextPercent.alpha = CoolUtil.floatDecimals(toDone / allNum * name, 2) / 100;
    }
    function checkLoadObjects(allowPushImages:Bool, allowPushMusics:Bool,extraImages:Bool){
        if (allowPushImages){
            for (i in imagesGF)
                pushPNG(i, checkCharFolder('gfChars/'));
            for (i in imagesGF_Christmas)
                pushPNG(i, checkCharFolder('gfChars/christmas/'));
            for (i in imagesGF_Pixel)
                pushPNG(i, checkCharFolder('gfChars/pixel/'));
            for (i in imagesBF)
                pushPNG(i, checkCharFolder('bfChars/'));
            for (i in imagesBF_Christmas)
                pushPNG(i, checkCharFolder('bfChars/christmas/'));
            for (i in imagesBF_Pixel)
                pushPNG(i, checkCharFolder('bfChars/pixel/'));
            /*for (i in imagesChar)
                pushPNG(i, checkCharFolder('charWeeks/char/'));
            for (i in imagesDADWK0)
                pushPNG(i, checkCharFolder('charWeeks/0/'));*/
            for (i in imagesDADWK1)
                pushPNG(i, checkCharFolder('charWeeks/1/'));
            for (i in imagesDADWK2)
                pushPNG(i, checkCharFolder('charWeeks/2/'));
            for (i in imagesDADWK3)
                pushPNG(i, checkCharFolder('charWeeks/3/'));
            for (i in imagesDADWK4)
                pushPNG(i, checkCharFolder('charWeeks/4/'));
            for (i in imagesDADWK5)
                pushPNG(i, checkCharFolder('charWeeks/5/'));
            for (i in imagesDADWK6)
                pushPNG(i, checkCharFolder('charWeeks/6/'));
            for (i in imagesDADWK7)
                pushPNG(i, checkCharFolder('charWeeks/7/'));
            if (extraImages){
                for (i in imagesICON_Vanilla)
                    pushPNG(i, checkCharFolder('icons/Vanilla-icons/'));
                for (i in imagesICON_JP)
                    pushPNG(i, checkCharFolder('icons/JP-icons/'));
                for (i in imagesICON_Juniorxefao)
                    pushPNG(i, checkCharFolder('icons/juniorxefao-icons/'));
                for (i in imagesICON_Maty)
                    pushPNG(i, checkCharFolder('icons/Maty-icons/'));
                for (i in imagesICON_Kkpassaroxx)
                    pushPNG(i, checkCharFolder('icons/KkpassaroxX-icons/'));
            }
        }
        #if !NEW_TYPE_CHECK_SONG
            if (allowPushMusics){
                for (i in gameplayMusics){
                    FlxG.sound.cache(Paths.inst(i));
                    FlxG.sound.cache(Paths.voices(i));
                    musicsLoaded++;
                    toDone++;
                }
            }
        #end
    }
    function getFolderToLoad(){
        switch (FlxG.save.data.cacheType){
            case 0:
                FlxGraphic.defaultPersist = false;
            case 1: // Musics Only
                FlxGraphic.defaultPersist = false;
                #if !NEW_TYPE_CHECK_SONG
                    checkDiretoryFolder("assets/chart", gameplayMusics);
                #end
            case 2: // Images Only
                FlxGraphic.defaultPersist = true;
                checkImageDiretoryFolder("assets/character/images/gfChars", imagesGF);
                checkImageDiretoryFolder("assets/character/images/gfChars/christmas", imagesGF_Christmas);
                checkImageDiretoryFolder("assets/character/images/gfChars/pixel", imagesGF_Pixel);
                checkImageDiretoryFolder("assets/character/images/bfChars", imagesBF);
                checkImageDiretoryFolder("assets/character/images/bfChars/christmas", imagesBF_Christmas);
                checkImageDiretoryFolder("assets/character/images/bfChars/pixel", imagesBF_Pixel);
                //checkImageDiretoryFolder("assets/character/images/charWeeks/0", imagesDADWK0); // active if there is 1 image in the folder
                checkImageDiretoryFolder("assets/character/images/charWeeks/1", imagesDADWK1);
                checkImageDiretoryFolder("assets/character/images/charWeeks/2", imagesDADWK2);
                checkImageDiretoryFolder("assets/character/images/charWeeks/3", imagesDADWK3);
                checkImageDiretoryFolder("assets/character/images/charWeeks/4", imagesDADWK4);
                checkImageDiretoryFolder("assets/character/images/charWeeks/5", imagesDADWK5);
                checkImageDiretoryFolder("assets/character/images/charWeeks/6", imagesDADWK6);
                checkImageDiretoryFolder("assets/character/images/charWeeks/7", imagesDADWK7);
                //checkImageDiretoryFolder("assets/character/images/charWeeks/char", imagesChar); // active if there is 1 image in the folder
            case 3: // All
                FlxGraphic.defaultPersist = true;
                checkImageDiretoryFolder("assets/character/images/gfChars", imagesGF);
                checkImageDiretoryFolder("assets/character/images/gfChars/christmas", imagesGF_Christmas);
                checkImageDiretoryFolder("assets/character/images/gfChars/pixel", imagesGF_Pixel);
                checkImageDiretoryFolder("assets/character/images/bfChars", imagesBF);
                checkImageDiretoryFolder("assets/character/images/bfChars/christmas", imagesBF_Christmas);
                checkImageDiretoryFolder("assets/character/images/bfChars/pixel", imagesBF_Pixel);
                //checkImageDiretoryFolder("assets/character/images/charWeeks/0", imagesDADWK0); // active if there is 1 image in the folder
                checkImageDiretoryFolder("assets/character/images/charWeeks/1", imagesDADWK1);
                checkImageDiretoryFolder("assets/character/images/charWeeks/2", imagesDADWK2);
                checkImageDiretoryFolder("assets/character/images/charWeeks/3", imagesDADWK3);
                checkImageDiretoryFolder("assets/character/images/charWeeks/4", imagesDADWK4);
                checkImageDiretoryFolder("assets/character/images/charWeeks/5", imagesDADWK5);
                checkImageDiretoryFolder("assets/character/images/charWeeks/6", imagesDADWK6);
                checkImageDiretoryFolder("assets/character/images/charWeeks/7", imagesDADWK7);
                //checkImageDiretoryFolder("assets/character/images/charWeeks/char", imagesChar); // active if there is 1 image in the folder
                checkImageDiretoryFolder("assets/character/images/icons/Vanilla-icons", imagesICON_Vanilla);
                checkImageDiretoryFolder("assets/character/images/icons/JP-icons", imagesICON_JP);
                checkImageDiretoryFolder("assets/character/images/icons/juniorxefao-icons", imagesICON_Juniorxefao);
                checkImageDiretoryFolder("assets/character/images/icons/Maty-icons", imagesICON_Maty);
                checkImageDiretoryFolder("assets/character/images/icons/KkpassaroxX-icons", imagesICON_Kkpassaroxx);
                #if !NEW_TYPE_CHECK_SONG
                    checkDiretoryFolder("assets/chart", gameplayMusics);
                #end
        }
    }
}