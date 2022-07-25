package;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
class AnimationDebug extends FlxState{
	var charAnimationList:Array<String> = [];
	var grpTexts:FlxTypedGroup<FlxText>;
	var curAnimCharacter:Character;
	var getChar:String = 'spooky';
	var camFollow:FlxObject;
	var curAnimText:FlxText;
	var multiplier:Int = 1;
	var isDad:Bool = true;
	var isGF:Bool = true;
	var curAnim:Int = 0;
	var dad:Character;
	var bf:Boyfriend;
	var gf:Character;
	public function new(getChar:String = 'spooky'){
		super();
		this.getChar = getChar;
	}
	override function create(){
		FlxG.sound.music.stop();
		var gridBG:FlxSprite = FlxGridOverlay.create(10, 10);
		gridBG.scrollFactor.set(0.5, 0.5);
		add(gridBG);
		if (getChar == 'gf') isGF = true;
		if (getChar == 'bf') isDad = false;
		if (isDad){ // Opponent Anim Modifire
			dad = new Character(0, 0, getChar);
			dad.screenCenter();
			dad.charOffseting = true;
			add(dad);
			curAnimCharacter = dad;
			dad.flipX = false;
		}else{ // Player Anim Modifire
			bf = new Boyfriend(0, 0);
			bf.screenCenter();
			bf.charOffseting = true;
			add(bf);
			curAnimCharacter = bf;
			bf.flipX = false;
		}
		if (isGF && isDad && !isDad){ // GF Anim Modifire
			gf = new Character(0, 0, CharacterSettigs.bomboxSkinType);
			gf.screenCenter();
			gf.charOffseting = true;
			add(gf);
			curAnimCharacter = gf;
			remove(dad);
			remove(bf);
		}
		grpTexts = new FlxTypedGroup<FlxText>();
		add(grpTexts);
		curAnimText = new FlxText(300, 16);
		curAnimText.size = 26;
		curAnimText.setFormat(Paths.font("Highman.ttf"), 26, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		curAnimText.scrollFactor.set();
		add(curAnimText);
		generateCharOffsets(true);
		camFollow = new FlxObject(0, 0, 2, 2);
		camFollow.screenCenter();
		add(camFollow);
		FlxG.camera.follow(camFollow);
		super.create();
	}
	override function update(elapsed:Float){
		curAnimText.text = "Current Anim: " + curAnimCharacter.animation.curAnim.name;
		if (FlxG.keys.justPressed.ESCAPE) Actions.States('Switch', new MainMenuState());
		if (FlxG.keys.justPressed.F) (isDad ? dad.flipX = !dad.flipX : bf.flipX = !bf.flipX);
		if (FlxG.keys.justPressed.E) FlxG.camera.zoom += 0.25;
		if (FlxG.keys.justPressed.Q) FlxG.camera.zoom -= 0.25;
		if (FlxG.keys.pressed.I || FlxG.keys.pressed.J || FlxG.keys.pressed.K || FlxG.keys.pressed.L){
			if (FlxG.keys.pressed.I)
				camFollow.velocity.y = -90;
			else if (FlxG.keys.pressed.K)
				camFollow.velocity.y = 90;
			else 
				camFollow.velocity.y = 0;
			if (FlxG.keys.pressed.J)
				camFollow.velocity.x = -90;
			else if (FlxG.keys.pressed.L)
				camFollow.velocity.x = 90;
			else
				camFollow.velocity.x = 0;
		}else
			camFollow.velocity.set();
		if (FlxG.keys.justPressed.W) curAnim -= 1;
		if (FlxG.keys.justPressed.S) curAnim += 1;
		if (curAnim < 0) curAnim = charAnimationList.length - 1;
		if (curAnim >= charAnimationList.length) curAnim = 0;
		if (FlxG.keys.justPressed.S || FlxG.keys.justPressed.W || FlxG.keys.justPressed.SPACE){
			curAnimCharacter.playAnim(charAnimationList[curAnim]);
			updateTexts();
			generateCharOffsets(false);
		}
		multiplier = (!FlxG.keys.pressed.SHIFT ? 1 : 10);
		if (FlxG.keys.anyJustPressed([UP]) || FlxG.keys.anyJustPressed([RIGHT]) || FlxG.keys.anyJustPressed([DOWN]) || FlxG.keys.anyJustPressed([LEFT])){
			updateTexts();
			if (FlxG.keys.anyJustPressed([UP])) curAnimCharacter.animOffsets.get(charAnimationList[curAnim])[1] += 1 * multiplier;
			if (FlxG.keys.anyJustPressed([DOWN])) curAnimCharacter.animOffsets.get(charAnimationList[curAnim])[1] -= 1 * multiplier;
			if (FlxG.keys.anyJustPressed([LEFT])) curAnimCharacter.animOffsets.get(charAnimationList[curAnim])[0] += 1 * multiplier;
			if (FlxG.keys.anyJustPressed([RIGHT])) curAnimCharacter.animOffsets.get(charAnimationList[curAnim])[0] -= 1 * multiplier;
			updateTexts();
			generateCharOffsets(false);
			curAnimCharacter.playAnim(charAnimationList[curAnim]);
		}
		super.update(elapsed);
	}
	function generateCharOffsets(pushList:Bool):Void{
		var daLoop:Int = 0;
		var colorShit:Array<Int> =[
			0xFFfafad2, // Color Text
			0xFF000000 // Outline Color Text
		];
		for (anim => offsets in curAnimCharacter.animOffsets){
			var text:FlxText = new FlxText(8, 50 + (20 * daLoop), 0, anim + ": " + offsets, 15);
			text.scrollFactor.set();
			text.setFormat(Paths.font("Highman.ttf"), 20, colorShit[0], CENTER, FlxTextBorderStyle.OUTLINE, colorShit[1]);
			grpTexts.add(text);
			if (pushList) charAnimationList.push(anim);
			daLoop++;
		}
	}
	function updateTexts():Void{
		grpTexts.forEach(function(text:FlxText){
			text.kill();
			grpTexts.remove(text, true);
		});
	}
}