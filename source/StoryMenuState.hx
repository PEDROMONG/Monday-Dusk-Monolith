package;

import flixel.FlxObject;
import helpers.StoryMenuBGHelper;
import flixel.input.gamepad.FlxGamepad;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var scoreText:FlxText;
	var storyBG:StoryMenuBGHelper;
	public var animOffsets:Map<String, Array<Dynamic>>;

	static function weekData():Array<Dynamic>
	{
		return [
			['Prologue'],
			['Restrain', 'Getting-There', 'Saving'],
			['Spooky4ever', 'Arachnophobia', 'Flesh'],
			['Cloaked', 'Denial', 'Bullet-Hell'],
		];
	}
	var curDifficulty:Int = 1;

	public static var weekUnlocked:Array<Bool> = [];

	var weekNames:Array<String> = CoolUtil.coolTextFile(Paths.txt('data/weekNames'));

	var txtWeekTitle:FlxText;

	var curWeek:Int = 0;

	var curSelected:Int = 0;

	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpClipboardOrders:FlxTypedGroup<FlxSprite>;

	var grpLocks:FlxTypedGroup<FlxSprite>;

	var difficultySelectors:FlxTypedGroup<FlxSprite>;
	var storymodeSelectors:FlxTypedGroup<FlxSprite>;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;
	var rightArrowStory:FlxSprite;
	var leftArrowStory:FlxSprite;
	var blackBarThingie:FlxBackdrop;

	function unlockWeeks():Array<Bool>
	{
		var weeks:Array<Bool> = [true, true, true, true];
		#if debug
		for(i in 0...weekNames.length)
			weeks.push(true);
		return weeks;
		#end
		
		weeks.push(true);

		for(i in 0...FlxG.save.data.weekUnlocked)
			{
				weeks.push(true);
			}
		return weeks;
	}

	override function create()
	{
		FlxG.mouse.visible = true;

		weekUnlocked = unlockWeeks();

		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Story Mode Menu", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null)
		{
			if (!FlxG.sound.music.playing)
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				Conductor.changeBPM(102);
			}
		}

		persistentUpdate = persistentDraw = true;

		add(blackBarThingie = new FlxBackdrop(Paths.image('ScrollingBGTHING')));
		blackBarThingie.velocity.set(-30, -30);

		var uiThing:FlxSprite = new FlxSprite(0, 312).loadGraphic(Paths.image('uiTHING'));
		add(uiThing);
		uiThing.screenCenter(X);

		scoreText = new FlxText(10, 10, 0, "SCORE: 49324858", 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat(Paths.font("vcr.ttf"), 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');
		// var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);
		storyBG = new StoryMenuBGHelper(0, 56);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		grpLocks = new FlxTypedGroup<FlxSprite>();
		add(grpLocks);

		trace("Line 70");

		for (i in 0...weekData().length)
		{
			var weekThing:MenuItem = new MenuItem(320, storyBG.y +storyBG.height + 10, i);
			weekThing.x += ((weekThing.length + 55) * i);
			weekThing.targetX = i;
			weekThing.ID = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			if(FlxG.save.data.antialiasing)
				{
					weekThing.antialiasing = true;
				}
			// weekThing.updateHitbox();

			// Needs an offset thingie
			if (!weekUnlocked[i])
			{
				trace('locking week ' + i);
				var lock:FlxSprite = new FlxSprite(525, -240);
				lock.frames = ui_tex;
				lock.animation.addByPrefix('lock', 'lock');
				lock.animation.play('lock');
				lock.ID = i;
				if(FlxG.save.data.antialiasing)
					{
						lock.antialiasing = true;
					}
				grpLocks.add(lock);
			}
		}

		trace("Line 96");

		difficultySelectors = new FlxTypedGroup<FlxSprite>();
		add(difficultySelectors);

		storymodeSelectors = new FlxTypedGroup<FlxSprite>();
		add(storymodeSelectors);

		trace("Line 124");

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width - 410, grpWeekText.members[0].y + 120);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 130, leftArrow.y - 90);
		sprDifficulty.frames = ui_tex;
		sprDifficulty.animation.addByPrefix('easy', 'EASY');
		sprDifficulty.animation.addByPrefix('normal', 'NORMAL');
		sprDifficulty.animation.addByPrefix('hard', 'HARD');
		sprDifficulty.animation.play('easy');
		updateOffsets();

		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + sprDifficulty.width - 45, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		leftArrowStory = new FlxSprite(leftArrow.x - 60, leftArrow.y - 105);
		leftArrowStory.frames = ui_tex;
		leftArrowStory.animation.addByPrefix('idle', "arrow left");
		leftArrowStory.animation.addByPrefix('press', "arrow push left");
		leftArrowStory.animation.play('idle');
		storymodeSelectors.add(leftArrowStory);

		rightArrowStory = new FlxSprite(rightArrow.x + 60, rightArrow.y - 105);
		rightArrowStory.frames = ui_tex;
		rightArrowStory.animation.addByPrefix('idle', 'arrow right');
		rightArrowStory.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrowStory.animation.play('idle');
		storymodeSelectors.add(rightArrowStory);

		trace("Line 150");

		add(storyBG);

		txtTracklist = new FlxText(FlxG.width * 0.05, storyBG.x + storyBG.height + 100, 0, "Tracks", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		updateText();

		grpClipboardOrders = new FlxTypedGroup<FlxSprite>();

		for (i in 0...weekData().length)
			{
				var storyClipBoard:FlxSprite = new FlxSprite(475 + (250 * i), 50);
				storyClipBoard.frames = Paths.getSparrowAtlas('clipboard/story_assets', 'preload');
				storyClipBoard.animation.addByPrefix('completed', i + ' BEAT');
				storyClipBoard.animation.addByPrefix('default', i + ' NORMAL');
				storyClipBoard.animation.play('default');
				grpClipboardOrders.add(storyClipBoard);
			}
		add(grpClipboardOrders);

		grpClipboardOrders.members[1].visible = false;
		grpClipboardOrders.members[2].visible = false;
		grpClipboardOrders.members[3].visible = false;

		var bullShit:Int = 0;

		if (FlxG.save.data.beatWeek0)
			grpClipboardOrders.members[0].animation.play('completed');
		if (FlxG.save.data.beatWeek1)
			grpClipboardOrders.members[1].animation.play('completed');
		if (FlxG.save.data.beatWeek2)
			grpClipboardOrders.members[2].animation.play('completed');
		if (FlxG.save.data.beatWeek3)
			grpClipboardOrders.members[3].animation.play('completed');

		for (item in grpWeekText.members)
		{
			item.targetX = bullShit - curWeek;
			if (item.targetX == Std.int(0) && weekUnlocked[curWeek])
				item.alpha = 1;
			else
				item.alpha = 0;
			bullShit++;
		}

		trace("Line 165");

		super.create();
	}

	override function update(elapsed:Float)
	{	
		if (FlxG.mouse.wheel != 0)
		{
			// Mouse wheel logic goes here, for example zooming in / out:
			changeHorizontal(-FlxG.mouse.wheel);
		}

		grpWeekText.forEach(function(spr:MenuItem)
		{
			// why do the hitboxes overlap
			if (FlxG.mouse.overlaps(spr) && !FlxG.mouse.overlaps(leftArrowStory) && !FlxG.mouse.overlaps(rightArrowStory) && FlxG.mouse.justPressed)
			{
				selectWeek();
			}
		});

		if (FlxG.mouse.overlaps(leftArrow) && FlxG.mouse.justPressed)
		{
			// We gotta force it to switch the vertical object lmfao
			if (curSelected == 0)
			{
				leftArrow.animation.play('press');
				curSelected = 1;
				changeVertical();
			}

			changeHorizontal(-1);
		}
		else if (FlxG.mouse.overlaps(rightArrow) && FlxG.mouse.justPressed)
		{
			if (curSelected == 0)
			{
				rightArrow.animation.play('press');
				curSelected = 1;
				changeVertical();
			}

			changeHorizontal(1);
		}

		if (FlxG.mouse.overlaps(leftArrowStory) && FlxG.mouse.justPressed)
		{
			if (curSelected == 1)
			{
				leftArrowStory.animation.play('press');
				curSelected = 0;
				changeVertical();
			}

			changeHorizontal(-1);
		}
		else if (FlxG.mouse.overlaps(rightArrowStory) && FlxG.mouse.justPressed)
		{
			if (curSelected == 1)
			{
				rightArrowStory.animation.play('press');
				curSelected = 0;
				changeVertical();
			}

			changeHorizontal(1);
		}

		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekNames[curWeek].toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		difficultySelectors.visible = weekUnlocked[curWeek];

		grpLocks.forEach(function(lock:FlxSprite)
		{
			lock.y = grpWeekText.members[lock.ID].y;
		});

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						changeVertical(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						changeVertical(1);
					}

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrow.animation.play('press')
					else
						rightArrow.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrow.animation.play('press');
					else
						leftArrow.animation.play('idle');

					if (gamepad.pressed.DPAD_RIGHT)
						rightArrowStory.animation.play('press')
					else
						rightArrowStory.animation.play('idle');
					if (gamepad.pressed.DPAD_LEFT)
						leftArrowStory.animation.play('press');
					else
						leftArrowStory.animation.play('idle');

					if (gamepad.justPressed.DPAD_RIGHT)
					{
						changeHorizontal(1);
					}
					if (gamepad.justPressed.DPAD_LEFT)
					{
						changeHorizontal(-1);
					}
				}

				if (FlxG.keys.justPressed.UP)
				{
					changeVertical(-1);
				}

				if (FlxG.keys.justPressed.DOWN)
				{
					changeVertical(1);
				}

				if (controls.RIGHT)
					switch(curSelected) {
						case 0:
							rightArrowStory.animation.play('press');
						case 1:
							rightArrow.animation.play('press');
					}
				else
					rightArrow.animation.play('idle');
					rightArrowStory.animation.play('idle');

				if (controls.LEFT)
					switch(curSelected) {
						case 0:
							leftArrowStory.animation.play('press');
						case 1:
							leftArrow.animation.play('press');
					}
				else
					leftArrow.animation.play('idle');
					leftArrowStory.animation.play('idle');

				if (controls.RIGHT_P)
					changeHorizontal(1);
				if (controls.LEFT_P)
					changeHorizontal(-1);
			}

			if (controls.ACCEPT)
			{
				selectWeek();
			}
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (weekUnlocked[curWeek])
		{
			if (stopspamming == false)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));

				grpWeekText.members[curWeek].startFlashing();
				stopspamming = true;
			}

			PlayState.storyPlaylist = weekData()[curWeek];
			PlayState.isStoryMode = true;
			selectedWeek = true;


			PlayState.storyDifficulty = curDifficulty;

			// adjusting the song name to be compatible
			var songFormat = StringTools.replace(PlayState.storyPlaylist[0], " ", "-");
			switch (songFormat) {
				case 'I-CAN-SHIT-REALLY-LOUDLY': songFormat = 'Getting-There';
			}

			var poop:String = Highscore.formatSong(songFormat, curDifficulty);
			PlayState.sicks = 0;
			PlayState.bads = 0;
			PlayState.shits = 0;
			PlayState.goods = 0;
			PlayState.campaignMisses = 0;
			PlayState.SONG = Song.loadFromJson(poop, PlayState.storyPlaylist[0]);
			PlayState.storyWeek = curWeek;
			PlayState.campaignScore = 0;
			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState(), true);
			});
		}
	}

	function changeVertical(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = 1;
		if (curSelected > 1)
			curSelected = 0;
		
		switch(curSelected) {
			case 0:
				// Week
				for (item in difficultySelectors.members)
				{
					item.alpha = 0.6;
				}
				for (item in storymodeSelectors.members)
				{
					item.alpha = 1;
				}
				for (item in grpWeekText.members)
				{
					if (item.targetX == Std.int(0))
					{
						item.alpha = 1;
					}
					else
					{
						item.alpha = 0;
					}
				}
			case 1:
				// Difficulty
				for (item in difficultySelectors.members)
				{
					item.alpha = 1;
				}
				for (item in storymodeSelectors.members)
				{
					item.alpha = 0.6;
				}
				for (item in grpWeekText.members)
				{
					if (item.targetX == Std.int(0))
					{
						item.alpha = 0.6;
					}
					else
					{
						item.alpha = 0;
					}
				}
		}
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeHorizontal(change:Int = 0):Void
	{	
		switch(curSelected) {
			case 0:
				// Week
				curWeek += change;

				if (curWeek >= weekData().length)
					curWeek = 0;
				if (curWeek < 0)
					curWeek = weekData().length - 1;

				var bullShit:Int = 0;

				for (item in grpWeekText.members)
				{
					item.targetX = bullShit - curWeek;
					if (item.targetX == Std.int(0) && weekUnlocked[curWeek])
						item.alpha = 1;
					else
						item.alpha = 0;
					bullShit++;
				}
				
				switch (curWeek)
				{
					case 0:
						grpClipboardOrders.members[0].x = 475;
						
						grpClipboardOrders.members[0].visible = true;
						grpClipboardOrders.members[1].visible = false;
						grpClipboardOrders.members[2].visible = false;
						grpClipboardOrders.members[3].visible = false;

					case 1:
						grpClipboardOrders.members[0].x = 375;
						grpClipboardOrders.members[1].x = 575;

						grpClipboardOrders.members[0].visible = true;
						grpClipboardOrders.members[1].visible = true;
						grpClipboardOrders.members[2].visible = false;
						grpClipboardOrders.members[3].visible = false;

					case 2:
						grpClipboardOrders.members[0].x = 275;
						grpClipboardOrders.members[1].x = 475;
						grpClipboardOrders.members[2].x = 675;

						grpClipboardOrders.members[0].visible = true;
						grpClipboardOrders.members[1].visible = true;
						grpClipboardOrders.members[2].visible = true;
						grpClipboardOrders.members[3].visible = false;

					case 3:
						grpClipboardOrders.members[3].x = 275;
						grpClipboardOrders.members[1].x = 475;
						grpClipboardOrders.members[2].x = 675;

						grpClipboardOrders.members[0].visible = false;
						grpClipboardOrders.members[1].visible = true;
						grpClipboardOrders.members[2].visible = true;
						grpClipboardOrders.members[3].visible = true;
				}

				if (FlxG.save.data.beatWeek0)
					grpClipboardOrders.members[0].animation.play('completed');
				if (FlxG.save.data.beatWeek1)
					grpClipboardOrders.members[1].animation.play('completed');
				if (FlxG.save.data.beatWeek2)
					grpClipboardOrders.members[2].animation.play('completed');
				if (FlxG.save.data.beatWeek3)
					grpClipboardOrders.members[3].animation.play('completed');

				storyBG.setWeek(curWeek);
			case 1:
				// Difficulty
				curDifficulty += change;

				if (curDifficulty < 0)
					curDifficulty = 2;
				if (curDifficulty > 2)
					curDifficulty = 0;

				switch (curDifficulty)
				{
					case 0:
						sprDifficulty.animation.play('easy');
						sprDifficulty.offset.x = 47;
						sprDifficulty.offset.y = 22;
					case 1:
						sprDifficulty.animation.play('normal');
						sprDifficulty.offset.x = 55;
						sprDifficulty.offset.y = 22;
					case 2:
						sprDifficulty.animation.play('hard');
						sprDifficulty.offset.x = 80;
						sprDifficulty.offset.y = 5;
				}

				sprDifficulty.alpha = 0;
				sprDifficulty.y = leftArrow.y - 15;
				intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
				FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
		}

		FlxG.sound.play(Paths.sound('scrollMenu'));

		updateText();
	}

	function updateOffsets()
	{

		switch (curDifficulty)
		{
			case 0:
				sprDifficulty.animation.play('easy');
				sprDifficulty.offset.x = 47;
				sprDifficulty.offset.y = 22;
			case 1:
				sprDifficulty.animation.play('normal');
				sprDifficulty.offset.x = 55;
				sprDifficulty.offset.y = 22;
			case 2:
				sprDifficulty.animation.play('hard');
				sprDifficulty.offset.x = 80;
				sprDifficulty.offset.y = 5;
		}

		sprDifficulty.alpha = 0;
		sprDifficulty.y = leftArrow.y - 15;
		FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07);
	}

	function updateText()
	{
		txtTracklist.text = "Tracks\n";
		var stringThing:Array<String> = weekData()[curWeek];

		for (i in stringThing)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		txtTracklist.text += "\n";

		#if !switch
		intendedScore = Highscore.getWeekScore(curWeek, curDifficulty);
		#end
	}


	public static function unlockNextWeek(week:Int):Void
	{
		if(week <= weekData().length - 1 && FlxG.save.data.weekUnlocked == week)
		{
			weekUnlocked.push(true);
			trace('Week ' + week + ' beat (Week ' + (week + 1) + ' unlocked)');
		}

		FlxG.save.data.weekUnlocked = weekUnlocked.length - 1;
		FlxG.save.flush();
	}

	override function beatHit()
	{
		super.beatHit();
	}
}
