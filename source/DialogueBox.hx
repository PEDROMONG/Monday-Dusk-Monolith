package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	var curAnim:String = '';

	// (tsg - 6/19/21) dialogue heights
	var dialogueTextHeight:Int = 450;

	public var finishThing:Void->Void;
	var afterWeek:Bool = false;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;
	var backgroundImage:FlxSprite;
	public var blackScreen2:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>, ?after:Bool = false)
	{
		super();

		afterWeek = after;

		if (afterWeek == false) {
			bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF000000);
			bgFade.scrollFactor.set();
			bgFade.alpha = 0;
			add(bgFade);	

			new FlxTimer().start(0.83, function(tmr:FlxTimer)
			{
				bgFade.alpha += (1 / 5) * 0.7;
				if (bgFade.alpha > 0.7)
					bgFade.alpha = 0.7;
			}, 5);

		}

		backgroundImage = new FlxSprite();
		backgroundImage.x = 0;
		backgroundImage.y = 0;
		add(backgroundImage);
		backgroundImage.visible = false;

		box = new FlxSprite(10, 45);
		
		var hasDialog = true;

		this.dialogueList = dialogueList;
		
		if (!hasDialog)
			return;

		if (PlayState.SONG.song.toLowerCase() == "prologue")
			{
				// ignore my shittycoding for prologue im tired ok - joe
				box.frames = Paths.getSparrowAtlas('dialogueAssets/mdmtextbox_assetsprologue', 'shared');
				box.animation.addByPrefix('normalOpen', 'textbox enter', 24, false);
				box.animation.addByIndices('normal', 'textbox enter', [4], '', 24, false);
			}
		else
			{
				box.frames = Paths.getSparrowAtlas('dialogueAssets/mdmtextbox_assets', 'shared');
				box.animation.addByPrefix('infectedOpen', 'infected textbox enter', 24, false);
				box.animation.addByIndices('infected', 'infected textbox enter', [4], '', 24, false);
				box.animation.addByPrefix('normalOpen', 'textbox enter', 24, false);
				box.animation.addByIndices('normal', 'textbox enter', [4], '', 24, false);
				box.setGraphicSize(Std.int(box.width * 1 * 0.9));
				box.y = (FlxG.height - box.height) + 79;
				box.x = (FlxG.height - box.height) + -99;
			}
		
		portraitLeft = new FlxSprite(-20, 40);
		add(portraitLeft);
		portraitLeft.visible = false;

		portraitRight = new FlxSprite(0, 40);
		add(portraitRight);
		portraitRight.visible = false;
		
		box.animation.play('normalOpen');
		box.updateHitbox();
		add(box);

		// portraitLeft.screenCenter(X);

		swagDialogue = new FlxTypeText(240, dialogueTextHeight, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.BLACK, LEFT);
		dropText = new FlxText(242, dialogueTextHeight, Std.int(FlxG.width * 0.6), "", 32);
		dropText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.BLACK, LEFT);

		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns') {
			dropText = new FlxText(242, dialogueTextHeight + 2, Std.int(FlxG.width * 0.6), "", 32);
			dropText.font = 'Pixel Arial 11 Bold';
			dropText.color = 0xFFD89494;

			swagDialogue = new FlxTypeText(240, dialogueTextHeight, Std.int(FlxG.width * 0.6), "", 32);
			swagDialogue.font = 'Pixel Arial 11 Bold';
			swagDialogue.color = 0xFF3F2021;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}

		if (PlayState.SONG.song.toLowerCase() == 'prologue') {
			dropText = new FlxText(42, 560, Std.int(FlxG.width * 0.9), "", 32);
			dropText.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.RED, LEFT);

			swagDialogue = new FlxTypeText(40, 560, Std.int(FlxG.width * 0.9), "", 32);
			swagDialogue.setFormat(Paths.font("vcr.ttf"), 40, FlxColor.BLACK, LEFT);
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
		}

		add(dropText);
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
			
			FlxG.sound.play(Paths.sound('clickText'), 0.8);

			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;

					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'restrain':
							FlxG.sound.music.fadeOut(2.2, 0);
					}

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					if (afterWeek == false) {
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							bgFade.alpha -= 1 / 5 * 0.7;
						}, 5);
					}

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});

					if (PlayState.SONG.song.toLowerCase() == 'prologue')
						new FlxTimer().start(1.2, function(tmr:FlxTimer)
							{
								finishThing();
							});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);

				portraitLeft.visible = false;
				portraitRight.visible = false;

				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function updateDialouge(playSound:Bool = true)
		{
			remove(dialogue);
	
			if (playSound == true)
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
	
			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
	
					switch (PlayState.SONG.song.toLowerCase())
					{
						case 'prologue':
							FlxG.sound.music.fadeOut(2.2, 0);
					}
	
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						backgroundImage.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					if (afterWeek == false) {
						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							bgFade.alpha -= 1 / 5 * 0.7;
						}, 5);
					}
	
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
	
				portraitLeft.visible = false;
				portraitRight.visible = false;

				startDialogue();
			}
	}

	function enddialogue()
		{
			if (dialogueList[1] == null && dialogueList[0] != null)
			{
				if (!isEnding)
				{
					isEnding = true;
	
					if (FlxG.sound.music != null)
						FlxG.sound.music.fadeOut(0.5, 0);
	
					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
					}, 5);
	
					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

	function startDialogue():Void
	{
		var setDialogue = false;
		var skipDialogue = false;
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'bf':
				// SWEEZO WAS HERE
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
					portraitRight.animation.addByPrefix('enter', 'bf_neutral instance 1', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);

					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 120;
					portraitRight.y = box.y - 245;

					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'bfconfused':
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			portraitLeft.visible = false;
			if (!portraitRight.visible)
			{
				portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
				portraitRight.animation.addByPrefix('enter', 'bf_confused instance 1', 24, false);
				portraitRight.scrollFactor.set();
				// portraitRight.screenCenter(X);

				portraitRight.x = (box.x + box.width) - (portraitRight.width) - 120;
				portraitRight.y = box.y - 245;

				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
		case 'bfscared':
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			portraitLeft.visible = false;
			if (!portraitRight.visible)
			{
				portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
				portraitRight.animation.addByPrefix('enter', 'bf_scared instance 1', 24, false);
				portraitRight.scrollFactor.set();
				// portraitRight.screenCenter(X);
	
				portraitRight.x = (box.x + box.width) - (portraitRight.width) - 120;
				portraitRight.y = box.y - 245;
	
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
		case 'bfsurprised':
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			portraitLeft.visible = false;
			if (!portraitRight.visible)
			{
				portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
				portraitRight.animation.addByPrefix('enter', 'bf_surprised instance 1', 24, false);
				portraitRight.scrollFactor.set();
				// portraitRight.screenCenter(X);
		
				portraitRight.x = (box.x + box.width) - (portraitRight.width) - 120;
				portraitRight.y = box.y - 245;
		
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
		case 'bfready':
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			portraitLeft.visible = false;
			if (!portraitRight.visible)
			{
				portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
				portraitRight.animation.addByPrefix('enter', 'bf_ready instance 1', 24, false);
				portraitRight.scrollFactor.set();
				// portraitRight.screenCenter(X);
			
				portraitRight.x = (box.x + box.width) - (portraitRight.width) - 200;
				portraitRight.y = box.y - 200;
			
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
		case 'bfconcerned':
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText'), 0.6)];
			swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			portraitLeft.visible = false;
			if (!portraitRight.visible)
			{
				portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/MOTHERFUCKER', 'shared');
				portraitRight.animation.addByPrefix('enter', 'bf_concerned instance 1', 24, false);
				portraitRight.scrollFactor.set();
				// portraitRight.screenCenter(X);
				
				portraitRight.x = (box.x + box.width) - (portraitRight.width) - 120;
				portraitRight.y = box.y - 245;
				
				portraitRight.visible = true;
				portraitRight.animation.play('enter');
			}
			case 'gf':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf normal', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 275;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gfsurprised':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{	
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf surprised', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 305;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gfconfused':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf confused', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 275;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gfworried':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf worried', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 275;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gfconfident':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf confident', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 275;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'gfangry':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('gfText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitLeft.visible = false;
				if (!portraitRight.visible)
				{
					portraitRight.frames = Paths.getSparrowAtlas('dialogueAssets/gf_sprites', 'shared');
					portraitRight.animation.addByPrefix('enter', 'gf angry', 24, false);
					portraitRight.scrollFactor.set();
					// portraitRight.screenCenter(X);
					
					portraitRight.x = (box.x + box.width) - (portraitRight.width) - 140;
					portraitRight.y = box.y - 275;
					
					portraitRight.visible = true;
					portraitRight.animation.play('enter');
				}
			case 'dad':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/DaddyDearestPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'DD ButCool', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 670;
					portraitLeft.y = box.y - 335;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'dadrestrain':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/DaddyDearestPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'DD RestrainedTwo', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 670;
					portraitLeft.y = box.y - 315;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'dadshine':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/DaddyDearestPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'DD Eyeshine', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 670;
					portraitLeft.y = box.y - 345;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'dadalert':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/DaddyDearestPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'DD Alert', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 670;
					portraitLeft.y = box.y - 345;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'dadhappy':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('dadText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/DaddyDearestPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'DD Happy', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 670;
					portraitLeft.y = box.y - 345;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'picocloak':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/PicoPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Pico Cloaked', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 730;
					portraitLeft.y = box.y - 275;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'pico':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/PicoPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Pico Angry 1', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 750;
					portraitLeft.y = box.y - 275;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'picopissed':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/PicoPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Pico PISSED', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 750;
					portraitLeft.y = box.y - 275;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'picoshocked':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/PicoPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Pico Shocked', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 750;
					portraitLeft.y = box.y - 275;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'picoangry':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('picoText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/PicoPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Pico Angry Gun', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 750;
					portraitLeft.y = box.y - 325;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'skidump':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('spookyText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/SkidumpPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Skidump Main', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 549;
					portraitLeft.y = box.y - 385;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'skidumpcheer':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('spookyText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/SkidumpPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Skidump Cheer', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 565;
					portraitLeft.y = box.y - 385;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'skidumpcrying':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('spookyText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/SkidumpPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Skidump Cry', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 637;
					portraitLeft.y = box.y - 385;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'lila':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('lila_e'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/lila_sprites', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'lila normal', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 637;
					portraitLeft.y = box.y - 295;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'lilaangry':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('lila_e'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/lila_sprites', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'lila angry', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 637;
					portraitLeft.y = box.y - 295;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'monster':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monsterText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/MonsterPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Monster Portrait', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 660;
					portraitLeft.y = box.y - 400;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'monstercreepy':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monsterText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/MonsterPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Monster Bloodlust', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 430;
					portraitLeft.y = box.y - 400;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'monsterblush':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monsterText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
				if (!portraitLeft.visible)
				{
					portraitLeft.frames = Paths.getSparrowAtlas('dialogueAssets/MonsterPortraits', 'shared');
					portraitLeft.animation.addByPrefix('enter', 'Monster Blush', 24, false);
					portraitLeft.scrollFactor.set();
					// portraitLeft.screenCenter(X);
					
					portraitLeft.x = (box.x + box.width) - (portraitLeft.width) - 660;
					portraitLeft.y = box.y - 400;
					
					portraitLeft.visible = true;
					portraitLeft.animation.play('enter');
				}
			case 'fleshscary':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('monsterText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
			case 'cg':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				swagDialogue.color = FlxColor.fromRGB(255, 255, 255);
				portraitRight.visible = false;
			case 'cgblack':
				swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pixelText'), 0.6)];
				swagDialogue.color = FlxColor.BLACK;
				portraitRight.visible = false;
			case 'cmd_normal':
				box.animation.play('normal', true);
				updateDialouge(false);
			case 'cmd_normalopen':
				box.animation.play('normalOpen', true);
				updateDialouge(false);
			case 'cmd_infected':
				box.animation.play('infected', true);
				updateDialouge(false);
			case 'cmd_infectedopen':
				// only use if character speaking first is infected, not rlly needed otherwise
				box.animation.play('infectedOpen', true);
				updateDialouge(false);
			case 'showbackgroundimage':
				backgroundImage.loadGraphic(Paths.image('dialogueAssets/omgAwesome/' + dialogueList[0], 'shared'));
				enddialogue();
				backgroundImage.visible = true;
			case 'hidebackground':
				enddialogue();
				backgroundImage.visible = false;
			case 'playsound':
				FlxG.sound.play(Paths.sound(dialogueList[0], 'shared'));
				enddialogue();
			case 'startmusic':
				FlxG.sound.playMusic(Paths.music(dialogueList[0], 'shared'));
				enddialogue();
			case 'endmusic':
				if (FlxG.sound.music != null)
					FlxG.sound.music.fadeOut(0.5, 0);
		}

		if(!skipDialogue){
			if(!setDialogue){
				swagDialogue.resetText(dialogueList[0]);
			}

			swagDialogue.start(0.04, true);
		}
		else{

			dialogueList.remove(dialogueList[0]);
			startDialogue();
			
		}

	}

	function cleanDialog():Void
	{
		while(dialogueList[0] == ""){
			dialogueList.remove(dialogueList[0]);
		}

		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];

		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
}