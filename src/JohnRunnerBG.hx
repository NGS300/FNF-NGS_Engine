package;
import flixel.FlxSprite;
import flixel.FlxG;
using StringTools;
class JohnRunnerBG extends FlxSprite{
    public var johnSpeed:Float = 0.7 * 1000;
    public var isRight:Bool = false;
    var maxRunning:Int = 1;
    var running:Int = 0;
    override public function new(){
        super();
        frames = Paths.getSparrowAtlas("tankDesert/johnKilled", 'maps');
        animation.addByPrefix("run", "John Running", 24, false);
        animation.addByPrefix("hited", "Death " + FlxG.random.int(1, 2), 24, false);
        antialiasing = Client.Public.antialiasing;
        animation.play("run");
        updateHitbox();
        setGraphicSize(Std.int(width * 0.8));
        updateHitbox();
    }
    public function resetJohn(X:Float, Y:Float, ToRight:Bool, ?RunMax:Int = 1, ?JohnSpeed:Float = 1){
        this.x = X;
        this.y = Y;
        this.isRight = ToRight;
        maxRunning = RunMax;
        johnSpeed = FlxG.random.float(0.6, 1) * 170;
        velocity.x = johnSpeed * (ToRight ? JohnSpeed * 2 : (JohnSpeed * 2 * -1));
        if (animation.curAnim.name == "hited"){
            if (ToRight) offset.x = 300;
            velocity.x = 0;
        }
    }
    override public function update(elapsed:Float){
        super.update(elapsed);
        flipX = isRight;
        if (animation.curAnim.name == "hited"){
            offset.x = (!isRight ? 0 : 400);
            velocity.x = 10;
        }
        if (animation.curAnim.name == "run" && animation.curAnim.finished){
            if (running < maxRunning){
                animation.play("run");
                running++;
            }else if (running >= maxRunning){
                animation.play("hited");
                running = 0;
            }
        }else if(animation.curAnim.finished) kill();
    }
    public static function picoShot(IsRight:Bool){ // PICO SPEAKER SHOOTS!
        for (i in (IsRight ? 0...TrackMap.picoSpeakerShotingStep.right.length : 0...TrackMap.picoSpeakerShotingStep.left.length)) // LEFT & RIGHT PicoSpeakerShoot
            if (PlayStepEvents.publicStep == (IsRight ? TrackMap.picoSpeakerShotingStep.right : TrackMap.picoSpeakerShotingStep.left)[i])
                Actions.PlayCharAnim(PlayState.instance.gf, 'shoot' + FlxG.random.int((IsRight ? 1 : 3), (IsRight ? 2 : 4)), true);
    }
    public static function johnSpawn(){ // JOHN RUNNING SPAWNER!
        for (i in 0...TrackMap.johnRunningStep.left.length){ // LEFT JohnRunnerSpawn
            if (PlayStepEvents.publicStep == TrackMap.johnRunningStep.left[i]){
                var johnRunning:JohnRunnerBG = new JohnRunnerBG();
                johnRunning.resetJohn(FlxG.random.int(630, 730) * -1, 255, true, 1, 1.5);
                TrackMap.johnRun.add(johnRunning);
            }
        }
        for (i in 0...TrackMap.johnRunningStep.right.length){ // RIGHT JohnRunnerSpawn
            if (PlayStepEvents.publicStep == TrackMap.johnRunningStep.right[i]){
                var johnRunning:JohnRunnerBG = new JohnRunnerBG();
                johnRunning.resetJohn(FlxG.random.int(1500, 1700) * 1, 275, false, 1, 1.5);
                TrackMap.johnRun.add(johnRunning);
            }
        }
    }
}