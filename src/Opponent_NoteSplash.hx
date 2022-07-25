package;
import flixel.FlxG;
import flixel.FlxSprite;
class Opponent_NoteSplash extends FlxSprite{
	public function new(XPos:Float, YPos:Float, ?Note:Int){
		super(XPos, YPos);
		LoadOpponentSplasher();
		setupOpponentSplash(XPos, YPos, Note);
	}
	public function LoadOpponentSplasher(){ // CUSTOM SONG NOTESPLASH LOAD
		switch (PlayState.SONG.song.toLowerCase()){
			default: SplashSkin();
		}
	}
	public function setupOpponentSplash(x:Float, y:Float, ?Note:Int){
		var RandomNumber:Int = FlxG.random.int(0, 1);
		playSplash(Note, RandomNumber);
		switch (PlayState.SONG.song.toLowerCase()){
			default: switch (RandomNumber){
					case 0: setPosition(x, y);
					case 1: setPosition(x - 15, y - 25);
				}
		}
	}
	public function SplashSkin(?SplashName:String){ // NOTESPLASH TYPE TO CREATE
		switch (SplashName){
			default: addSplosh(Options.Option.JsonOptions.UseNewNoteSytle ?
					'Opponent_NewStyleSplash' : 'Opponent_Splash',
					['note0-0', 'note1-0', 'note2-0', 'note3-0',
					'note0-1', 'note1-1', 'note2-1', 'note3-1'],
					['splash impact 1 purple', 'splash impact 1 blue', 'splash impact 1 green', 'splash impact 1 red',
					'splash impact 2 purple', 'splash impact 2 blue', 'splash impact 2 green', 'splash impact 2 red']
				);
		}
	}
	function addSplosh(Frame:String, AnimName:Array<String>, Prefix:Array<String>, ?FrameRate:Array<Int> = null, ?Force:Array<Bool> = null){ // Just Create Splash Skin in This Function
		if (Frame != null && Prefix != null){
			frames = Paths.getSparrowAtlas('note/splash/opponent/$Frame');
			for (i in 0...AnimName.length){
				var NameAnim:String = AnimName[i];
				var AnimPrefix:String = Prefix[i];
				var AnimFPS:Int = FrameRate[i];
				var AnimForce:Bool = Force[i];
				animation.addByPrefix(NameAnim, AnimPrefix, FrameRate == null ? 24 : AnimFPS, Force == null ? false : AnimForce);
			}
		}
	}
	function playSplash(Note:Int, RandomNum:Int){
		alpha = 0.6;
		animation.play("note" + Note + "-" + RandomNum, true);
		if (animation.curAnim != null) animation.curAnim.frameRate = 24 + FlxG.random.int(-2, 2);
		updateHitbox();
		offset.set(0.3 * width, 0.3 * height);
	}
	override public function update(elapsed){
		if (animation.curAnim != null) if (animation.curAnim.finished) kill();
		super.update(elapsed);
	}
}