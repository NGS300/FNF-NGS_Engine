import flixel.addons.transition.FlxTransitionableState;
class OptionsDirect extends MusicBeatState{
	override function create(){
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;
		persistentUpdate = true;
		PlayState.IsPlayState = false;
		StateImage.BGSMenus('OptionsBG', add);
		openSubState(new OptionsMenu());
	}
}