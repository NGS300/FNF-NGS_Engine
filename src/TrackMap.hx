package;
import Song.SwagSong;
import flixel.FlxCamera;
import flixel.ui.FlxBar;
import flixel.math.FlxMath;
import flixel.math.FlxAngle;
import haxe.Json;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.util.FlxAxes;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
using StringTools;
class TrackMap extends MusicBeatState{
	public static var animString:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];
	public static var allowedToHandbro:Bool = false;
	public static var AlreadyToYeah:Bool = false;
	public static var mapComplement:String = '';
	public static var curMap:String = '';
	public static var camZoom:Float = 1.05;
	public static var daPixelZoom:Float = 6;
	public static var halloweenBG:NewSprite;
	public static var isHalloween:Bool = false;
	public static var lightningStrikeBeat:Int = 0;
	public static var lightningOffset:Int = 8;
	public static var phillyCityLights:FlxTypedGroup<NewSprite>;
	public static var phillyTrain:NewSprite;
	public static var trainSound:FlxSound;
	public static var trainMoving:Bool = false;
	public static var trainFrameTiming:Float = 0;
	public static var trainCars:Int = 8;
	public static var trainFinishing:Bool = false;
	public static var trainCooldown:Int = 0;
	public static var startedMoving:Bool = false;
	public static var limo:NewSprite;
	public static var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	public static var fastCar:NewSprite;
	public static var curLight:Int = 0;
	public static var fastCarCanDrive:Bool = true;
	public static var upperBoppers:NewSprite;
	public static var bottomBoppers:NewSprite;
	public static var santa:NewSprite;
	public static var snowEmitterR:FlxEmitter;
	public static var snowEmitterC:FlxEmitter;
	public static var snowEmitterL:FlxEmitter;
	public static var bgGirls:BackgroundGirls;
	public static var picoSpeakerShotingStep:PSW; // Pico Speaker Weapon Shot Step 
	public static var johnRunningStep:JRS; // John Running Step
	public static var sky:NewSprite;
	public static var tankWatchtower:NewSprite;
	public static var tankRolling:NewSprite;
	public static var johnRun:FlxTypedGroup<JohnRunnerBG>;
	public static var bgSpace:FlxSprite;
	public static var spaceGuns:Array<Int> =[
		0xFFfffcff,	 // White [0]
		0xFF9370db, // Medium Purple [1]
		0xFF00c800, // Green [2]
		0xFFEEA14A, // Orange Light [3]
		0xFF1e90ff, // Dodgerblue [4]
		0xFFffd700, // Gold [5]
		0xFFcd5c5c, // Idian Red [6]
		0xFFae40ff, // Magenta Blue [7]
		0xFF00e1e1, // Cian [8]
		0xFFff2828 // Red [9]
	];
	public static var tankBops:FlxTypedGroup<NewSprite>;
	public static var tankBop1:NewSprite;
	public static var tankBop2:NewSprite;
	public static var tankBop3:NewSprite;
	public static var tankBop4:NewSprite;
	public static var tankBop5:NewSprite;
	public static var tankBop6:NewSprite;
	public static var tankX = 400;
	public static var tankAngle:Float = FlxG.random.int(-90, 45);
	public static var tankSpeed:Float = FlxG.random.float(5, 7);
	public static var tent:NewSprite;
	public static function LoadTrackMap(pull:Dynamic, Track:String){
		switch (Track){ // Push Tracks Maps of Functios MAP, Just Make You Map :D
			default: mapType('create', pull, 'stage');
            case 'spookeez' | 'south' | 'monster': mapType('create', pull, 'spooky');
		    case 'pico' | 'blammed' | 'philly': mapType('create', pull, 'philly');
		    case 'milf' | 'satin-panties' | 'high': mapType('create', pull, 'limo');
		    case 'cocoa' | 'eggnog': mapType('create', pull, 'mall');
		    case 'winter-horrorland': mapType('create', pull, 'mallEvil');
		    case 'senpai' | 'roses': mapType('create', pull, 'school');
		    case 'thorns': mapType('create', pull, 'schoolEvil');
			case 'ugh' | 'guns' | 'stress': mapType('create', pull, 'tankDesert');
			case 'tanpowder': mapType('create', pull, 'nevada');
        }
	}
	public static function mapPlaces(trackLower:String, Place:String, get:Dynamic, opponent:Character, gf:Character, bf:Boyfriend){
		switch (Place){
			case 'Frontward': // Add to Map Front
				switch (curMap){
					case 'tankDesert': get(tankBops);
					case 'nevada': get(tent);
				}
			case 'Backward': // Add to Behind of Frontward
				if (curMap != 'mallEvil') get(gf);
				if (curMap == 'limo') get(limo);
		}
	}
	public static function mapType(Type:String, ?create:Null<Dynamic>, ?MapName:Null<String> = null, ?elapsed:Null<Float> = null, ?Track:String, ?opponent:Character, ?gf:Character, ?bf:Boyfriend, ?step:Int, ?beat:Int, ?diff:Int, ?SONG:SwagSong, ?generatedMusic:Bool, ?healthBar:FlxBar, ?camHUD:FlxCamera, ?camNOTE:FlxCamera, ?laneCamera:FlxCamera, ?playerStrums:FlxTypedGroup<FlxSprite>, ?opponentStrums:FlxTypedGroup<FlxSprite>, ?strumLineNotes:FlxTypedGroup<FlxSprite>){
		switch (Type){
			case 'create': // PlayState Create
				switch (MapName){
					case 'stage':
						camZoom = 0.9;
						curMap = 'stage';
						mapComplement = '';
						GetSprMap(create, 'stageSpr');
					case 'spooky':
						camZoom = 1.05;
						curMap = 'spooky';
						isHalloween = true;
						mapComplement = '';
						GetSprMap(create, 'spookySpr');
					case 'philly':
						camZoom = 1.05;
						curMap = 'philly';
						mapComplement = '';
						GetSprMap(create, 'phillySpr');
					case 'limo':
						camZoom = .9;
						curMap = 'limo';
						mapComplement = '';
						GetSprMap(create, 'limoSpr');
					case 'mall':
						camZoom = .8;
						curMap = 'mall';
						mapComplement = '';
						GetSprMap(create, 'mallSpr');
					case 'mallEvil':
						camZoom = 1.05;
						curMap = 'mallEvil';
						mapComplement = '';
						GetSprMap(create, 'mallEvilSpr');
					case 'school':
						camZoom = 1.05;
						curMap = 'school';
						mapComplement = 'pixel';
						GetSprMap(create, 'schoolSpr');
					case 'schoolEvil':
						camZoom = 1.05;
						curMap = 'schoolEvil';
						mapComplement = 'pixel';
						GetSprMap(create, 'schoolEvilSpr');
					case 'tankDesert':
						camZoom = 0.9;
						curMap = 'tankDesert';
						mapComplement = '';
						GetSprMap(create, 'tankDesertSpr');
					case 'nevada':
						camZoom = 0.8;
						curMap = 'nevada';
						mapComplement = '';
						GetSprMap(create, 'nevadaSpr');
				}
			case 'update': // PlayState Update
				if (Client.Public.map){
					switch (curMap){ // Maps Events Update
						case 'philly':
							if (FlxG.save.data.visualDistractions && trainMoving){
								trainFrameTiming += elapsed;
								if (trainFrameTiming >= 1 / 24){ mapSprEvent('update'); trainFrameTiming = 0; }
							}
						case 'tankDesert':
							if (FlxG.save.data.visualDistractions) mapSprEvent('move');
					}
					if (allowedToHandbro && generatedMusic && SONG.notes[Std.int(step / 16)] != null){
						if (gf.animation.curAnim.name == 'danceLeft' || gf.animation.curAnim.name == 'danceRight' || gf.animation.curAnim.name == 'idle'){
							switch (Track){
								case 'Bopeebo':{
									if (beat > 5 && beat < 130){
										if (beat % 8 == 7){
											if (!AlreadyToYeah){
												Actions.PlayCharAnim(gf, 'cheer');
												AlreadyToYeah = true;
											}
										}else 
											AlreadyToYeah = false;
									}
								}
								case 'Philly':{
									if (beat < 250){
										if (beat != 184 && beat != 216){
											if (beat % 16 == 8){
												if (!AlreadyToYeah){
													Actions.PlayCharAnim(gf, 'cheer');
													AlreadyToYeah = true;
												}
											}else 
												AlreadyToYeah = false;
										}
									}
								}
								case 'Blammed':{
									if (beat > 30 && beat < 190){
										if (beat < 90 || beat > 128){
											if (beat % 4 == 2){
												if (!AlreadyToYeah){
													Actions.PlayCharAnim(gf, 'cheer');
													AlreadyToYeah = true;
												}
											}else 
												AlreadyToYeah = false;
										}
									}
								}
								case 'Cocoa':{
									if (beat < 170){
										if (beat < 65 || beat > 130 && beat < 145){
											if (beat % 16 == 15){
												if (!AlreadyToYeah){
													Actions.PlayCharAnim(gf, 'cheer');
													Actions.PlaySprMapAnim(TrackMap.bottomBoppers, 'Bottom Level Boppers HEY!!');
													AlreadyToYeah = true;
												}
											}else 
												AlreadyToYeah = false;
										}
									}
								}
								case 'Eggnog':{
									if (beat > 10 && beat != 111 && beat < 220){
										if (beat % 8 == 7){
											if (!AlreadyToYeah){
												Actions.PlayCharAnim(gf, 'cheer');
												Actions.PlaySprMapAnim(TrackMap.bottomBoppers, 'Bottom Level Boppers HEY!!');
												AlreadyToYeah = true;
											}
										}else 
											AlreadyToYeah = false;
									}
								}
							}
						}
					}
				}
			case 'beat': // PlayBeatEvents Beat
				if (isHalloween && FlxG.random.bool(25) && beat > lightningStrikeBeat + lightningOffset) mapSprEvent(); // Spooky LightStrike
				switch (curMap){ // Maps Objects Events
					case "philly":
						if (FlxG.save.data.visualDistractions){
							if (!trainMoving) trainCooldown += 1; // Train is no Moving, 1 beat + 1 countdown
							if (beat % 4 == 0){
								phillyCityLights.forEach(function(light:FlxSprite) {light.visible = false;}); // Random Change Lights
								curLight = FlxG.random.int(0, phillyCityLights.length - 1);
								phillyCityLights.members[curLight].visible = true;
								switch (Track){
									case 'Philly':
										if (FlxG.save.data.visualEffects){
											if (beat >= 168 && beat < 231){
												var lightCam:Array<Int> =[
													0xFF31a2fd, // Blue [0]
													0xFF31fd8c, // Green [1]
													0xFFfb33f5, // Purple [2]
													0xFFfd4531, // Orange [3]
													0xFFfba633 // Yellow [4]
												];
												Actions.Flash(camHUD, lightCam[curLight], .35, true);
												healthBar.createFilledBar(lightCam[curLight], lightCam[curLight]);
												healthBar.updateBar();
											}
											if (beat == 232){
												healthBar.createFilledBar((FlxG.save.data.colourCharIcon ? opponent.healthBarColor : 0xFFFF0000), (FlxG.save.data.colourCharIcon ? bf.healthBarColor : 0xFF66FF33));
												healthBar.updateBar();
											}
										}
								}
							}
							if (beat % 8 == 4 && FlxG.random.bool(35) && !trainMoving && trainCooldown > 8){ // Train Moving Random on Contdown Timer 8 for up
								trainCooldown = FlxG.random.int(-4, 0);
								mapSprEvent('start');
							}
						}
					case 'limo':
						if (FlxG.save.data.visualDistractions){
							grpLimoDancers.forEach(function(dancer:BackgroundDancer) {dancer.dance();});  // Dancers in Limo Beat Dance Anim
							if (FlxG.random.bool(10.25) && fastCarCanDrive) mapSprEvent('appear'); // Ultra Fest Car Passing
						}
					case 'mall': // Just Idle of BGS 
						Actions.PlaySprMapAnim(upperBoppers, 'Upper Crowd Bob', true);
						Actions.PlaySprMapAnim(bottomBoppers, 'Bottom Level Boppers Idle', true);
						Actions.PlaySprMapAnim(santa, 'santa idle in fear', true);
					case 'school':
						bgGirls.dance(); // The Sucks Girl Dance
					case "tankDesert":
						if (beat % 1 == 2){
							Actions.PlaySprMapAnim(tankWatchtower, 'watchtower gradient color instance 1');
							Actions.PlaySprMapAnim(tankBop1, 'fg tankhead far right instance 1');
							Actions.PlaySprMapAnim(tankBop2, 'fg tankhead 5 instance 1');
							Actions.PlaySprMapAnim(tankBop3, 'foreground man 3 instance 1');
							Actions.PlaySprMapAnim(tankBop4, 'fg tankhead 4 instance 1');
							Actions.PlaySprMapAnim(tankBop5, 'fg tankman bobbin 3 instance 1');
							Actions.PlaySprMapAnim(tankBop6, 'fg tankhead far right instance 1');
						}
				}
		}
	}
	public static function GetSprMap(create:Null<Dynamic>, MapName:Null<String> = null){
		if (Client.Public.map){
			switch (MapName){
				case 'stageSpr':
					var bg:NewSprite = new NewSprite(-600, -200, 'stage/stageback', 'maps', true, 1, 0.9, 0.9);
					create(bg);

					var stageFront:NewSprite = new NewSprite(-650, 600, 'stage/stagefront', 'maps', true, 1, 0.9, 0.9);
					NewSprite.SpriteComplement.setVariables(stageFront, true, 1.1);
					create(stageFront);

					var stageCurtains:NewSprite = new NewSprite(-500, -300, 'stage/stagecurtains', 'maps', true, 1, 1.3, 1.3);
					NewSprite.SpriteComplement.setVariables(stageCurtains, true, 0.9);
					if (FlxG.save.data.visualDistractions)
						create(stageCurtains);
				case 'spookySpr':
					halloweenBG = new NewSprite(-200, -100, 'spooky/halloween_bg', 'maps', true, 1, 1, 1, ['halloweem bg0', 'halloweem bg lightning strike']);
					create(halloweenBG);
				case 'phillySpr':
					var sky:NewSprite = new NewSprite(-100, 'philly/sky', 'maps', true, 1, 0.1, 0.1);
					if (FlxG.save.data.visualDistractions)
						create(sky);

					var cityBG:NewSprite = new NewSprite(-100, 'philly/city', 'maps', true, 1, 0.3, 0.3);
					NewSprite.SpriteComplement.setVariables(cityBG, true, 0.85);
					create(cityBG);

					if (FlxG.save.data.visualDistractions){
						phillyCityLights = new FlxTypedGroup<NewSprite>();
						create(phillyCityLights);
						for (i in 0...5){
							var light:NewSprite = new NewSprite(cityBG.x, 'philly/win' + i, 'maps', false, 1, 0.3, 0.3);
							NewSprite.SpriteComplement.setVariables(light, true, 0.85);
							phillyCityLights.add(light);
						}
					}

					var streetBehind:NewSprite = new NewSprite(-40, 50, 'philly/behindTrain', 'maps');
					if (FlxG.save.data.visualDistractions)
						create(streetBehind);

					phillyTrain = new NewSprite(2000, 360, 'philly/train', 'maps');
					if (FlxG.save.data.visualDistractions)
						create(phillyTrain);

					trainSound = new FlxSound().loadEmbedded(Paths.sound('philly/train_passes', 'maps'));
					FlxG.sound.list.add(trainSound);

					var street:NewSprite = new NewSprite(-40, streetBehind.y, 'philly/street', 'maps');
					create(street);
				case 'limoSpr':
					var skyBG:NewSprite = new NewSprite(-120, -50, 'limo/limoSunset', 'maps', true, 1, 0.1, 0.1);
					create(skyBG);

					var bgLimo:NewSprite = new NewSprite(-200, 480, 'limo/bgLimo', 'maps', true, 1, 0.4, 0.4, ['background limo pink'], 24, true);
					if (FlxG.save.data.visualDistractions)
						create(bgLimo);

					if (FlxG.save.data.visualDistractions){
						grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
						create(grpLimoDancers);
						for (i in 0...5){
							var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400, 0.4, 0.4);
							grpLimoDancers.add(dancer);
						}
					}
					limo = new NewSprite(-120, 550, 'limo/limoDrive', 'maps', true, 1, 1, 1, ['Limo stage'], 24, true);
					fastCar = new NewSprite(-300, 160, 'limo/fastCarLol', 'maps');
					fastCar.active = true;
				case 'mallSpr':
					var bg:NewSprite = new NewSprite(-1000, -500, 'mall/bgWalls', 'maps', true, 1, 0.2, 0.2);
					NewSprite.SpriteComplement.setVariables(bg, true, 0.8);
					create(bg);

					upperBoppers = new NewSprite(-240, -90, 'mall/upperBop', 'maps', true, 1, 0.33, 0.33, ['Upper Crowd Bob']);
					NewSprite.SpriteComplement.setVariables(upperBoppers, true, 0.85);
					if (FlxG.save.data.visualDistractions)
						create(upperBoppers);

					var bgEscalator:NewSprite = new NewSprite(-1100, -600, 'mall/bgEscalator', 'maps', true, 1, 0.3, 0.3);
					NewSprite.SpriteComplement.setVariables(bgEscalator, true, 0.9);
					if (FlxG.save.data.visualDistractions)
						create(bgEscalator);

					var tree:NewSprite = new NewSprite(-370, -250, 'mall/christmasTree', 'maps', true, 1, 0.4, 0.4);
					if (FlxG.save.data.visualDistractions)
						create(tree);

					bottomBoppers = new NewSprite(-300, 140, 'mall/bottomBop', 'maps', true, 1, 0.9, 0.9, ['Bottom Level Boppers Idle', 'Bottom Level Boppers HEY!!']);
					NewSprite.SpriteComplement.setVariables(bottomBoppers, true, 1);
					if (FlxG.save.data.visualDistractions)
						create(bottomBoppers);

					var fgSnow:NewSprite = new NewSprite(-600, 700, 'mall/fgSnow', 'maps');
					create(fgSnow);

					santa = new NewSprite(-840, 150, 'mall/santa', 'maps', true, 1, 1, 1, ['santa idle in fear']);
					if (FlxG.save.data.visualDistractions)
						create(santa);

					if (FlxG.save.data.visualDistractions && FlxG.save.data.visualEffects){
						//RIGHT
						snowEmitterR = new FlxEmitter(FlxG.width / 2 - 760, FlxG.height / 2 - 760);
						snowEmitterR.makeParticles(4, 4, FlxColor.WHITE, 500);
						snowEmitterR.launchAngle.set(23, 167);
						snowEmitterR.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterR.velocity.set(200, -100, 200, 100);
						snowEmitterR.lifespan.set(300, 300);
						snowEmitterR.start(false, 0.1);
						//CENTER
						snowEmitterC = new FlxEmitter(FlxG.width / 2, FlxG.height / 2 - 512);
						snowEmitterC.makeParticles(4, 4, FlxColor.WHITE, 500);
						snowEmitterC.launchAngle.set(0, 180);
						snowEmitterC.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterC.velocity.set(200, -100, 200, 100);
						snowEmitterC.lifespan.set(300, 300);
						snowEmitterC.start(false, 0.1);
						//LEFT
						snowEmitterL = new FlxEmitter(FlxG.width / 2  + 512, FlxG.height / 2 - 512);
						snowEmitterL.makeParticles(4, 4, FlxColor.WHITE, 500);
						snowEmitterL.launchAngle.set(23, 167);
						snowEmitterL.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterL.velocity.set(200, -100, 200, 100);
						snowEmitterL.lifespan.set(300, 300);
						snowEmitterL.start(false, 0.1);
						create(snowEmitterR);
						create(snowEmitterC);
						create(snowEmitterL);
					}
				case 'mallEvilSpr':
					var bg:NewSprite = new NewSprite(-400, -500, 'mall/evil/evilBG', 'maps', true, 1, 0.2, 0.2);
					NewSprite.SpriteComplement.setVariables(bg, true, 0.8);
					create(bg);

					var evilTree:NewSprite = new NewSprite(300, -300, 'mall/evil/evilTree', 'maps', true, 1, 0.2, 0.2);
					if (FlxG.save.data.visualDistractions)
						create(evilTree);
						
					var evilSnow:NewSprite = new NewSprite(-200, 700, 'mall/evil/evilSnow', 'maps');
					create(evilSnow);

					if (FlxG.save.data.visualDistractions && FlxG.save.data.visualEffects){
						//RIGHT
						snowEmitterR = new FlxEmitter(FlxG.width / 2 - 760, FlxG.height / 2 - 760);
						snowEmitterR.makeParticles(4, 4, FlxColor.RED, 500);
						snowEmitterR.launchAngle.set(23, 167);
						snowEmitterR.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterR.velocity.set(200, -100, 200, 100);
						snowEmitterR.lifespan.set(300, 300);
						snowEmitterR.start(false, 0.1);
						//CENTER
						snowEmitterC = new FlxEmitter(FlxG.width / 2, FlxG.height / 2 - 512);
						snowEmitterC.makeParticles(4, 4, FlxColor.RED, 500);
						snowEmitterC.launchAngle.set(0, 180);
						snowEmitterC.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterC.velocity.set(200, -100, 200, 100);
						snowEmitterC.lifespan.set(300, 300);
						snowEmitterC.start(false, 0.1);
						//LEFT
						snowEmitterL = new FlxEmitter(FlxG.width / 2  + 512, FlxG.height / 2 - 512);
						snowEmitterL.makeParticles(4, 4, FlxColor.RED, 500);
						snowEmitterL.launchAngle.set(23, 167);
						snowEmitterL.launchMode = FlxEmitterMode.CIRCLE;
						snowEmitterL.velocity.set(200, -100, 200, 100);
						snowEmitterL.lifespan.set(300, 300);
						snowEmitterL.start(false, 0.1);
						create(snowEmitterR);
						create(snowEmitterC);
						create(snowEmitterL);
					}
				case 'schoolSpr':
					var bgSky:NewSprite = new NewSprite(0, 0, 'school/weebSky', 'maps', true, 1, 0.1, 0.1);
					var widShit = Std.int(bgSky.width * 6);
					bgSky.setGraphicSize(widShit);
					NewSprite.SpriteComplement.setVariables(bgSky, true);
					create(bgSky);

					var bgSchool:NewSprite = new NewSprite(-200, 0, 'school/weebSchool', 'maps', true, 1, 0.6, 0.9);
					bgSchool.setGraphicSize(widShit);
					NewSprite.SpriteComplement.setVariables(bgSchool, true);
					create(bgSchool);

					var bgStreet:NewSprite = new NewSprite(-200, 0, 'school/weebStreet', 'maps', true, 1, 0.95, 0.95);
					bgStreet.setGraphicSize(widShit);
					NewSprite.SpriteComplement.setVariables(bgStreet, true);
					create(bgStreet);

					var fgTrees:NewSprite = new NewSprite(-200 + 170, 130, 'school/weebTreesBack', 'maps', true, 1, 0.9, 0.9);
					fgTrees.setGraphicSize(Std.int(widShit * 0.8));
					NewSprite.SpriteComplement.setVariables(fgTrees, true);
					if (FlxG.save.data.visualEffects)
						create(fgTrees);

					var bgTrees:FlxSprite = new FlxSprite(-200 - 380, -800);
					var treetex = Paths.getPackerAtlas('school/weebTrees', 'maps');
					bgTrees.frames = treetex;
					bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
					bgTrees.animation.play('treeLoop');
					bgTrees.scrollFactor.set(0.85, 0.85);
					bgTrees.setGraphicSize(Std.int(widShit * 1.4));
					NewSprite.SpriteComplement.setVariables(bgTrees, true, null, null, null, null, null, false);
					if (FlxG.save.data.visualEffects)
						create(bgTrees);

					var treeLeaves:NewSprite = new NewSprite(-200, -40, 'school/petals', 'maps', true, 1, 0.85, 0.85, ['PETALS ALL'], 24, true);
					treeLeaves.setGraphicSize(widShit);
					NewSprite.SpriteComplement.setVariables(treeLeaves, true);
					if (FlxG.save.data.visualEffects)
						create(treeLeaves);

					bgGirls = new BackgroundGirls(-100, 190, 0.9, 0.9);
					if (PlayState.SONG.song.toLowerCase() == 'roses')
						bgGirls.getScared();
					bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
					NewSprite.SpriteComplement.setVariables(bgGirls, true);
					if (FlxG.save.data.visualDistractions)
						create(bgGirls);
				case 'schoolEvilSpr':
					var evilSchool:NewSprite = new NewSprite(400, 200, 'school/evil/animatedEvilSchool', 'maps', true, 1, 0.8, 0.9, ['background 2'], 24, true);
					evilSchool.scale.set(6, 6);
					create(evilSchool);
				case 'tankDesertSpr':
					if (PlayState.SONG.song.toLowerCase() == 'stress'){
						picoSpeakerShotingStep = Json.parse(openfl.utils.Assets.getText(Paths.json('stress/PicoSpeakerShootSteps')));
						johnRunningStep = Json.parse(openfl.utils.Assets.getText(Paths.json('stress/JohnRunnersSpawnSteps')));
					}

					sky = new NewSprite(-400, -400, 'tankDesert/tankSky', 'maps', true, 1, 0, 0);
					NewSprite.SpriteComplement.setVariables(sky, false, 1.5);
					create(sky);

					var clouds:NewSprite = new NewSprite(FlxG.random.int(-700, -100), FlxG.random.int(-20, 20), 'tankDesert/tankClouds', 'maps', true, 1, 0.1, 0.1);
					clouds.velocity.x = FlxG.random.float(5, 15);
					NewSprite.SpriteComplement.setVariables(clouds, true);
					if (FlxG.save.data.visualDistractions)
						create(clouds);

					var mountains:NewSprite = new NewSprite(-300, -20, 'tankDesert/tankMountains', 'maps', true, 1, 0.2, 0.2);
					NewSprite.SpriteComplement.setVariables(mountains, true, 1.2);
					create(mountains);

					var buildings:NewSprite = new NewSprite(-200, 0, 'tankDesert/tankBuildings', 'maps', true, 1, 0.3, 0.3);
					NewSprite.SpriteComplement.setVariables(buildings, true, 1.1);
					if (FlxG.save.data.visualDistractions)
						create(buildings);

					var ruins:NewSprite = new NewSprite(-200, 0, 'tankDesert/tankRuins', 'maps', true, 1, 0.35, 0.35);
					NewSprite.SpriteComplement.setVariables(ruins, true, 1.1);
					if (FlxG.save.data.visualDistractions)
						create(ruins);

					var smokeLeft:NewSprite = new NewSprite(-200, -100, 'tankDesert/smokeLeft', 'maps', true, 1, 0.4, 0.4, ['SmokeBlurLeft '], 24, true);
					if (FlxG.save.data.visualDistractions)
						create(smokeLeft);

					var smokeRight:NewSprite = new NewSprite(1100, -100, 'tankDesert/smokeRight', 'maps', true, 1, 0.4, 0.4, ['SmokeRight '], 24, true);
					if (FlxG.save.data.visualDistractions)
						create(smokeRight);

					var tankWatchtower:NewSprite = new NewSprite(100, 120, 'tankDesert/tankWatchtower', 'maps', true, 1, 0.5, 0.5, ['watchtower gradient color instance 1'], 24, true);
					if (FlxG.save.data.visualDistractions)
						create(tankWatchtower);

					tankRolling = new NewSprite(300, 300, 'tankDesert/tankRolling', 'maps', true, 1, 0.5, 0.5, ['BG tank w lighting instance 1'], 24, true);
					if (FlxG.save.data.visualDistractions)
						create(tankRolling);

					johnRun = new FlxTypedGroup<JohnRunnerBG>();
					if (FlxG.save.data.visualDistractions && PlayState.SONG.song.toLowerCase() == 'stress')
						create(johnRun);

					if (PlayState.SONG.song.toLowerCase() == 'guns'){
						bgSpace = new FlxSprite().makeGraphic(5000, 800, FlxColor.WHITE);
						bgSpace.alpha = 0;
						bgSpace.x -= 350;
						bgSpace.y += 50;
						bgSpace.scrollFactor.set(1, 1);
						bgSpace.scale.x = 1.5;
						bgSpace.scale.y = 1.5;
						if (FlxG.save.data.visualDistractions && FlxG.save.data.visualEffects)
							create(bgSpace);
					}

					var ground:NewSprite = new NewSprite(-420, -150, 'tankDesert/tankGround', 'maps', true, 1, 1, 1);
					NewSprite.SpriteComplement.setVariables(ground, true, 1.15);
					create(ground);

					tankBop1 = new NewSprite(-500, 650, 'tankDesert/tank0', 'maps', true, 1, 1.7, 1.5, ['fg tankhead far right instance 1'], 24, true);
					tankBop2 = new NewSprite(-300, 750, 'tankDesert/tank1', 'maps', true, 1, 2.0, 0.2, ['fg tankhead 5 instance 1'], 24, true);
					tankBop3 = new NewSprite(450, 940, 'tankDesert/tank2', 'maps', true, 1, 1.5, 1.5, ['foreground man 3 instance 1'], 24, true);
					tankBop4 = new NewSprite(1300, 1200, 'tankDesert/tank3', 'maps', true, 1, 3.5, 2.5, ['fg tankhead 4 instance 1'], 24, true);
					tankBop5 = new NewSprite(1300, 900, 'tankDesert/tank4', 'maps', true, 1, 1.5, 1.5, ['fg tankman bobbin 3 instance 1'], 24, true);
					tankBop6 = new NewSprite(1620, 700, 'tankDesert/tank5', 'maps', true, 1, 1.5, 1.5, ['fg tankhead far right instance 1'], 24, true);
					tankBops = new FlxTypedGroup();
					tankBops.add(tankBop1);
					tankBops.add(tankBop2);
					tankBops.add(tankBop3);
					tankBops.add(tankBop4);
					tankBops.add(tankBop5);
					tankBops.add(tankBop6);
					Actions.PlaySprMapAnim(tankWatchtower, 'watchtower gradient color instance 1', true);
					Actions.PlaySprMapAnim(tankBop1, 'fg tankhead far right instance 1', true);
					Actions.PlaySprMapAnim(tankBop2, 'fg tankhead 5 instance 1', true);
					Actions.PlaySprMapAnim(tankBop3, 'foreground man 3 instance 1', true);
					Actions.PlaySprMapAnim(tankBop4, 'fg tankhead 4 instance 1', true);
					Actions.PlaySprMapAnim(tankBop5, 'fg tankman bobbin 3 instance 1', true);
					Actions.PlaySprMapAnim(tankBop6, 'fg tankhead far right instance 1', true);
				case 'nevadaSpr':
					var citys:NewSprite = new NewSprite(-600, -200, 'nevada/citys', 'maps', true, 1, 0.9, 0.9);
					create(citys);

					var bigRock:NewSprite = new NewSprite(-600, -400, 'nevada/bigRocks', 'maps', true, 1, 0.9, 0.9);
					NewSprite.SpriteComplement.setVariables(bigRock, true, 1.1, null, null, null, null, false);
					create(bigRock);

					var rockFloor:NewSprite = new NewSprite(-650, 600, 'nevada/rockFloor', 'maps', true, 1, 0.9, 0.9);
					NewSprite.SpriteComplement.setVariables(rockFloor, true, 1.1, null, null, null, null, false);
					create(rockFloor);

					tent = new NewSprite(-500, -100, 'nevada/tent', 'maps', true, 1, 0.9, 0.9);
					NewSprite.SpriteComplement.setVariables(tent, true, 1.1);
			}
		}
	}
	public static function mapSprEvent(?Starting:Bool = false, ?TypeSpr:String):Void{
		switch (StoryMenuState.storyWeek){
			case 2: // Week 2
				switch (PlayState.SONG.song.toLowerCase()){
					default: Actions.PlayRandomSound('spooky/thunder', 1, 2, 'maps');
					case 'spookeez': if (PlayStepEvents.publicStep != 16 || PlayStepEvents.publicStep != 576 || PlayStepEvents.publicStep != 640 || PlayStepEvents.publicStep != 704 || PlayStepEvents.publicStep != 768 || PlayStepEvents.publicStep != 832 || PlayStepEvents.publicStep != 896)	 Actions.PlayRandomSound('spooky/thunder', 1, 2, 'maps');
				}
				Actions.Flash(PlayState.camHUD, 0xFFFFFFFF, 0.3, true);
				lightningStrikeBeat = PlayBeatEvents.publicBeat;
				lightningOffset = FlxG.random.int(8, 24);
				Actions.PlaySprMapAnim(halloweenBG, 'halloweem bg lightning strike');
				Actions.PlayCharAnim(PlayState.instance.gf, 'scared', true);
				Actions.PlayCharAnim(PlayState.instance.boyfriend, 'scared', true);
				if (!Starting){
					if (PlayState.mainDifficulty >= 5){
						new FlxTimer().start(0.001, function(tmr:FlxTimer){
							Actions.PlaySprMapAnim(halloweenBG, 'halloweem bg lightning strike');
							Actions.PlayRandomSound('spooky/thunder', 1, 2, 'maps');
							new FlxTimer().start(0.01, function(tmr:FlxTimer){
								Actions.PlaySprMapAnim(halloweenBG, 'halloweem bg lightning strike');
								Actions.PlayRandomSound('spooky/thunder', 1, 2, 'maps');
							});
						});
					}
					if (PlayState.mainDifficulty >= 4)
						PlayState.instance.health -= 0.275;
				}
			case 3: // Week 3
				switch (TypeSpr){
					case 'start':
						trainMoving = true;
						if (!trainSound.playing) trainSound.play(true);
					case 'update':
						if (trainSound.time >= 4700){
							startedMoving = true;
							Actions.Shake(PlayState.camNOTE, 0.015805, 0.016, null, true, FlxAxes.X);
							Actions.Shake(PlayState.camGame, 0.015805, 0.016, null, true, FlxAxes.X);
							Actions.Shake(PlayState.camHUD, 0.015805, 0.016, null, true, FlxAxes.X);
							Actions.Shake(PlayState.laneCamera, 0.015805, 0.016, null, true, FlxAxes.X);
							Actions.PlayCharAnim(PlayState.instance.gf, 'hairBlow');
						}
						if (startedMoving){
							phillyTrain.x -= 400;
							if (phillyTrain.x < -2000 && !trainFinishing){
								phillyTrain.x = -1150;
								trainCars -= 1;
								if (trainCars <= 0) trainFinishing = true;
							}
							if (phillyTrain.x < -4000 && trainFinishing) mapSprEvent('reset');
						}
					case 'reset':
						Actions.PlayCharAnim(PlayState.instance.gf, 'hairFall');
						phillyTrain.x = FlxG.width + 200;
						trainMoving = false;
						trainCars = 8;
						trainFinishing = false;
						startedMoving = false;
				}
			case 4: // Week 4
				switch (TypeSpr){
					case 'appear':
						Actions.PlayRandomSound('limo/carPass', 0, 1, 'maps', 0.7);
						fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
						fastCarCanDrive = false;
						new FlxTimer().start(2, function(tmr:FlxTimer) {mapSprEvent('reset');});
					case 'reset':
						fastCar.x = -12600;
						fastCar.y = FlxG.random.int(140, 250);
						fastCar.velocity.x = 0;
						fastCarCanDrive = true;
				}
			case 7: // Week 7
				switch (TypeSpr){
					case 'move':
						tankAngle += FlxG.elapsed * tankSpeed;
						tankRolling.angle = tankAngle - 90 + 15;
						tankRolling.x = tankX + 1500 * FlxMath.fastCos(FlxAngle.asRadians(tankAngle + 180));
						tankRolling.y = 1300 + 1100 * FlxMath.fastSin(FlxAngle.asRadians(tankAngle + 180));
					case 'again':
						tankRolling.x = 300;
						tankRolling.y = 300;
						mapSprEvent('move');
				}
		}
	}
	public static function eventStartCounter(get:Dynamic, SecSay:Int){
		getSprStarting(get, SecSay);
		switch (curMap){
			case 'spooky':
				if (Client.Public.map && FlxG.save.data.flashingLightVisual && SecSay == 3) mapSprEvent(true);
			case "philly":
				if (Client.Public.map && FlxG.save.data.visualDistractions){
					if (!trainMoving) trainCooldown += 1;
					phillyCityLights.forEach(function(light:FlxSprite){light.visible = false;});
					SecSay = FlxG.random.int(0, phillyCityLights.length - 1);
					phillyCityLights.members[SecSay].visible = true;
					if (SecSay == 1){
						trainCooldown = FlxG.random.int(-4, 0);
						mapSprEvent('start');
					}
				}
			case 'limo':
				if (Client.Public.map && FlxG.save.data.visualDistractions){
					grpLimoDancers.forEach(function(dancer:BackgroundDancer) {dancer.dance();});
					if (FlxG.random.bool(50) && fastCarCanDrive) mapSprEvent('appear');
				}
			case 'mall':
				if (Client.Public.map){
					Actions.PlaySprMapAnim(upperBoppers, 'Upper Crowd Bob', true);
					Actions.PlaySprMapAnim(bottomBoppers, 'Bottom Level Boppers Idle', true);
					Actions.PlaySprMapAnim(santa, 'santa idle in fear', true);
				}
			case 'school':
				if (Client.Public.map) bgGirls.dance();
		}
	}
	// DON'T CHANGE!
	public static function oldInput(direction:Int = 1):Void{ // This is Ghost Taping PLZ DON'T TOUTCH!
		var bfLikeAMiss = PlayState.instance.boyfriend;
		if (!bfLikeAMiss.stunned){
			if (PlayState.combo > 5 && PlayState.instance.gf.animOffsets.exists('cry')) Actions.PlayCharAnim(PlayState.instance.gf, 'cry');
			if (FlxG.save.data.missSounds) Actions.PlayRandomSound('missSound/missnote', 1, 3, 'character', FlxG.random.float(0.1, 0.2));
			switch (PlayState.SONG.song.toLowerCase()){
				default:
					PlayState.misses++;
					PlayState.combo = 0;
					PlayState.instance.health -= 0.04;
					PlayState.instance.chartScore -= 10;
					PlayState.instance.addsDamageHealthSpriteTake += 0.04;
					PlayState.instance.interuptgrabbedPlayerIconHealth = true;
					if (PlayState.instance.isPlayerMain) Actions.PlayCharAnim(bfLikeAMiss, Character.talkAction + animString[direction] + Character.actionMiss, true, false, 0, true);
			}
			PlayState.instance.refreshStats();
		}
	}
	public static function getSprStarting(get:Null<Dynamic> = null, ?NumIntro:Int){ // Is Just Counter in one Time Reapet This
		if (get != null){
			var NameSay:String = '';
			switch (NumIntro){
				case 0: NameSay = 'Three';
				case 1: NameSay = 'Two';
				case 2: NameSay = 'One';
				case 3: NameSay = (mapComplement != 'pixel' ? 'Go' : 'Date');
				case 4: NameSay = 'Skip';
			}
			if (NameSay != 'Skip'){
				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default',[
					'beginTrack/UIStart/three', 
					"beginTrack/UIStart/two", 
					"beginTrack/UIStart/one", 
					"beginTrack/UIStart/go"
				]);
				introAssets.set('pixel',[
					'beginTrack/UIStart/Pixel/three-pixel', 
					'beginTrack/UIStart/Pixel/two-pixel', 
					'beginTrack/UIStart/Pixel/one-pixel', 
					'beginTrack/UIStart/Pixel/date-pixel'
				]);
				var introAlts:Array<String> = introAssets.get('default');
				var altSuffix:String = "";
				var soundIntroShit:String = '';
				var diretoryShit:String = 'beginTrack/';
				if (mapComplement == 'pixel'){
					introAlts = introAssets.get('pixel');
					diretoryShit = 'beginTrack/pixel/';
					soundIntroShit = '-pixel';
					altSuffix = '-pixel';
				}
				var sprite:NewSprite = new NewSprite(0, 0, introAlts[NumIntro], null, true, 1, 0, 0);
				NewSprite.SpriteComplement.setVariables(sprite, true, null, null, null, null, null, null, true);
				if (mapComplement == 'pixel') sprite.setGraphicSize(Std.int(sprite.width * daPixelZoom));
				get(sprite);
				Actions.Tween(sprite, {y: sprite.y += 100, alpha: 0}, Conductor.crochet / 1000,{
					ease: FlxEase.cubeInOut, onComplete: function(twn:FlxTween) {sprite.destroy();}
				});
				Actions.PlaySound(diretoryShit + NameSay + soundIntroShit, 'shared', 0.7);
			}
			if (NumIntro >= 0 && NumIntro < 3) HealthIcon.iconBumping(PlayState.instance.boyfriend, PlayState.instance.dad);
			Actions.PlayCharAnim(PlayState.instance.dad);
			Actions.PlayCharAnim(PlayState.instance.gf);
			Actions.PlayCharAnim(PlayState.instance.boyfriend, 'idle');
		}
	}
}
typedef PSW ={ // Pico Speaker Weapon
	var right:Array<Int>;
	var left:Array<Int>;
}
typedef JRS ={ //Tank Runner Spawn
	var right:Array<Int>;
	var left:Array<Int>;
}
typedef MapSettings ={
	var ?opponentX:Float;
	var ?opponentY:Float;
	var ?gfX:Float;
	var ?gfY:Float;
	var ?bfX:Float;
	var ?bfY:Float;
	var ?needBombox:Bool;
	var ?needPlayer:Bool;
	var ?needOpponent:Bool;
	var ?complement:String;
	var ?zoom:Float;
} 