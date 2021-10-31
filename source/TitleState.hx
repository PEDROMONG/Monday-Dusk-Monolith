package;

#if sys
import smTools.SMFile;
#end
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import openfl.Lib;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var fleshScreenChance:Bool = false;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{	

		// 1/1000
        if (FlxG.random.bool(0.01))
		{
			new FlxTimer().start(5, function(tmr:FlxTimer)
				{
					fleshScreenChance = true;
					FlxG.sound.music.volume = 0;
					FlxG.sound.play(Paths.sound('FRS'));
					var fleshScreen:FlxSprite = new FlxSprite().loadGraphic(Paths.image('aa_scary'));
					fleshScreen.screenCenter();
					add(fleshScreen);
					Lib.application.window.borderless = true;
					Lib.application.window.mouseLock = true;
					new FlxTimer().start(5, function(tmr:FlxTimer)
						{
							Lib.application.window.alert('FOUND YOU','.');
							new FlxTimer().start(10, function(tmr:FlxTimer)
								{
									FlxG.switchState(new TitleState());
									FlxG.sound.destroy();
									FlxG.sound.music.volume = 1;
								});
						});
				});
		}

		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		Lib.application.window.borderless = false;
		Lib.application.window.mouseLock = false;

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		#if !cpp

		FlxG.save.bind('funkin', 'ninjamuffin99');

		PlayerSettings.init();

		KadeEngineData.initSave();
		
		#end

				
		Highscore.load();


		curWacky = FlxG.random.getObject(getIntroTextShit());

		trace('hello');

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		#if !cpp
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#else
		startIntro();
		#end
		#end
	}

	var logoBl:FlxSprite;
	var backdrop:FlxBackdrop;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		// bg.antialiasing = true;
		// bg.setGraphicSize(Std.int(bg.width * 0.6));
		// bg.updateHitbox();
		add(bg);

        add(backdrop = new FlxBackdrop(Paths.image('mdmTitleBG')));
		backdrop.scale.x = 0.7;
        backdrop.scale.y = 0.7;

        logoBl = new FlxSprite(380, 10);
        logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
        logoBl.antialiasing = true;
        logoBl.setGraphicSize(Std.int(logoBl.width * 0.6));
        logoBl.scale.x = 0.6;
        logoBl.scale.y = 0.6;
        logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
        logoBl.animation.play('bump');
        logoBl.updateHitbox();
        // logoBl.screenCenter();
        // logoBl.color = FlxColor.BLACK;

		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		if(FlxG.save.data.antialiasing)
			{
				titleText.antialiasing = true;
			}
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		if(FlxG.save.data.antialiasing)
			{
				logo.antialiasing = true;
			}
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8r", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		if(FlxG.save.data.antialiasing)
			{
				ngSpr.antialiasing = true;
			}

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			Conductor.changeBPM(102);
			initialized = true;
		}

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('data/introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		if (FlxG.mouse.justPressed && !skippedIntro && initialized && !fleshScreenChance)
		{
			skipIntro();
		}

		if (FlxG.mouse.overlaps(titleText) && FlxG.mouse.justPressed && !transitioning && skippedIntro && !fleshScreenChance)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// No more downloading info from the internet
				
				FlxG.switchState(new MainMenuState()); // fail but we go anyway
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		var pressedEnter:Bool = controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		if (pressedEnter && !transitioning && skippedIntro && !fleshScreenChance)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;
			MainMenuState.finishedFunnyMove = false;

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				// No more downloading info from the internet
				
				FlxG.switchState(new MainMenuState()); // fail but we go anyway
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized && !fleshScreenChance)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{
		super.beatHit();

		logoBl.animation.play('bump', true);
		danceLeft = !danceLeft;

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 0:
				deleteCoolText();
			case 2:
				createCoolText(['ninjamuffin99', 'phantomArcade', 'kawaisprite', 'evilsk8r']);
			// credTextShit.visible = true;
			case 4:
				deleteCoolText();
				createCoolText(['pukinuke', 'squidley', 'joe', 'wreach']);
			// credTextShit.visible = true;
			case 6:
				deleteCoolText();
				createCoolText(['Snart Studios', 'TSG', 'Dause_Retch', 'Zack The Nerd']);
			// credTextShit.visible = true;
			case 8:
				deleteCoolText();
				createCoolText(['Flan The Man', 'phlox', 'wildy', 'Cherribun']);
			// credTextShit.visible = true;
			case 10:
				deleteCoolText();
				createCoolText(['Tenaxis', 'Oddball', 'CallMeDante', 'Matt Money']);
			// credTextShit.visible = true;
			case 11:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 14:
				if (Main.watermarks)
					createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['In Partnership', 'with']);
			case 16:
				if (Main.watermarks)
					addMoreText('KadeDeveloper');
				else
				{
					addMoreText('Newgrounds');
					ngSpr.visible = true;
				}
			// credTextShit.text += '\nNewgrounds';
			case 18:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 19:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 22:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 26:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 29:
				addMoreText('Monday');
			// credTextShit.visible = true;
			case 30:
				addMoreText('Dusk');
			// credTextShit.text += '\nNight';
			case 31:
				addMoreText('Monolith'); // credTextShit.text += '\nFunkin';

			case 32:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro && !fleshScreenChance)
		{
			FlxG.mouse.visible = true;

			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);

			skippedIntro = true;
		}
	}
}
