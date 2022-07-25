package;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
class OutdatedState extends MusicBeatState{
	override function create(){
		super.create();
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);
		var updateTxtCheck:FlxText = new FlxText(0, 0, FlxG.width, "", 32);
		updateTxtCheck.text = "Hey! You're on an Outdated Engine Version\nCurrent Engine Version Using: " + MainMenuState.engineVersion + " \nNew Version is Available, Update Now " + TitleState.updateVersion + " \nPress ENTER to Go to Github or ESC to Ignore This Shit.";
		/*switch (FlxG.save.data.language){ // Project
			case 0: // English
				updateTxtCheck.text = "Hey! You're on an Outdated Engine Version\nCurrent Engine Version Using: " + MainMenuState.engineVersion + " \nNew Version is Available, Update Now " + TitleState.updateVersion + " \nPress ENTER to Go to Github or ESC to Ignore This Shit.";
			case 1: // Portuguese Brasilian
				updateTxtCheck.text = "Opa! Você Está numa Versão da Engine Desatualizado"; // Beta
		}*/
		updateTxtCheck.setFormat("Highman.ttf", 35, FlxColor.WHITE, CENTER);
		updateTxtCheck.screenCenter();
		add(updateTxtCheck);
	}
	override function update(elapsed:Float){
		if (controls.BACK) Actions.States('Switch', new MainMenuState());
		if (controls.ACCEPT){
			Actions.OpenLink("https://github.com/NGS300/Ngs-Engine/releases");
			new FlxTimer().start(1.25, function(timer:FlxTimer){
				Actions.States('Switch', new MainMenuState());
			});
		}
		super.update(elapsed);
	}
}