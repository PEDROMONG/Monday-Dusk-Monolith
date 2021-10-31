package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

class Character extends FlxSprite
{
	public var animOffsets:Map<String, Array<Dynamic>>;
	public var debugMode:Bool = false;

	public var isPlayer:Bool = false;
	public var curCharacter:String = 'bf';
	public var healthBarColor:FlxColor = 0xFFFF0000;

	public var holdTimer:Float = 0;

	public function new(x:Float, y:Float, ?character:String = "bf", ?isPlayer:Bool = false)
	{
		super(x, y);

		animOffsets = new Map<String, Array<Dynamic>>();
		curCharacter = character;
		this.isPlayer = isPlayer;

		var tex:FlxAtlasFrames;
		if(FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}

		switch (curCharacter)
		{
			case 'gf':
				// GIRLFRIEND CODE
				healthBarColor = FlxColor.fromRGB(135, 8, 67);
				tex = Paths.getSparrowAtlas('GF_assets','shared',true);
				frames = tex;
				animation.addByPrefix('cheer', 'GF Cheer', 24, false);
				animation.addByPrefix('singLEFT', 'GF left note', 24, false);
				animation.addByPrefix('singRIGHT', 'GF Right Note', 24, false);
				animation.addByPrefix('singUP', 'GF Up Note', 24, false);
				animation.addByPrefix('singDOWN', 'GF Down Note', 24, false);
				animation.addByIndices('sad', 'gf sad', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceLeft', 'GF Dancing Beat', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
				animation.addByIndices('danceRight', 'GF Dancing Beat', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
				animation.addByIndices('hairBlow', "GF Dancing Beat Hair blowing", [0, 1, 2, 3], "", 24);
				animation.addByIndices('hairFall', "GF Dancing Beat Hair Landing", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], "", 24, false);
				animation.addByPrefix('scared', 'GF FEAR', 24);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');

			case 'dad':
				healthBarColor = FlxColor.fromRGB(144, 95, 165);
				// DAD ANIMATION LOADING CODE
				tex = Paths.getSparrowAtlas('Dad_MDM_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'IDLE POSE', 24);
				animation.addByPrefix('singUP', 'UP POSE', 24);
				animation.addByPrefix('singRIGHT', 'DD RIGHT', 24);
				animation.addByPrefix('singDOWN', 'DOWN POSE', 24);
				animation.addByPrefix('singLEFT', 'DD LEFT', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				setGraphicSize(Std.int(width - 6666666));
                updateHitbox();

                antialiasing = false;
			case 'spooky':
				healthBarColor = FlxColor.fromRGB(173, 111, 19);
				tex = Paths.getSparrowAtlas('Skidump_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('singUP', 'SKIDUMP UP', 24, false);
				animation.addByPrefix('singDOWN', 'SKIDUMP DOWN', 24, false);
				animation.addByPrefix('singLEFT', 'SKIDUMP LEFT', 24, false);
				animation.addByPrefix('singRIGHT', 'SKIDUMP RIGHT', 24, false);
				animation.addByIndices('danceLeft', 'SKIDUMP IDLE', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], "", 24, false);
				animation.addByIndices('danceRight', 'SKIDUMP IDLE', [13, 14, 15, 16, 17, 18, 19, 20, 21], "", 24, false);

				loadOffsetFile(curCharacter);

				playAnim('danceRight');
			case 'lila':
				healthBarColor = FlxColor.fromRGB(64, 53, 122);
				// flaming cock
				tex = Paths.getSparrowAtlas('Lila_MDM_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'LILA IDLE', 24);
				animation.addByPrefix('singUP', 'LILA UP POSE', 24);
				animation.addByPrefix('singRIGHT', 'LILA RIGHT POSE', 24);
				animation.addByPrefix('singDOWN', 'LILA DOWN POSE', 24);
				animation.addByPrefix('singLEFT', 'LILA LEFT POSE', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'dad-saving':
				// DAD ANIMATION LOADING CODE
				healthBarColor = FlxColor.fromRGB(144, 95, 165);
				tex = Paths.getSparrowAtlas('Dad_2_MDM_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'IDLE POSE', 24);
				animation.addByPrefix('singUP', 'UP', 24);
				animation.addByPrefix('singRIGHT', 'RIGHT', 24);
				animation.addByPrefix('singDOWN', 'DOWN', 24);
				animation.addByPrefix('singLEFT', 'left', 24);
	
				loadOffsetFile(curCharacter);

				playAnim('idle');
			case 'monster':
				healthBarColor = FlxColor.fromRGB(221, 231, 114);
				tex = Paths.getSparrowAtlas('Monster_Assets','shared',true);
				frames = tex;
				animation.addByPrefix('idle', 'monster idle', 24, false);
				animation.addByPrefix('singUP', 'monster up note', 24, false);
				animation.addByPrefix('singDOWN', 'monster down', 24, false);
				animation.addByPrefix('singLEFT', 'Monster left note', 24, false);
				animation.addByPrefix('singRIGHT', 'Monster Right note', 24, false);

				loadOffsetFile(curCharacter);
				playAnim('idle');
			case 'pico':
				healthBarColor = FlxColor.fromRGB(160, 182, 93);
				tex = Paths.getSparrowAtlas('mdmPicoAssets','shared', true);
				frames = tex;
				animation.addByPrefix('idle', "MDM Pico Idle", 24);
				animation.addByPrefix('singUP', 'MDM Pico Up', 24, false);
				animation.addByPrefix('singDOWN', 'MDM Pico Down', 24, false);
				animation.addByPrefix('singLEFT', 'MDM Pico Back', 24, false);
				animation.addByPrefix('singRIGHT', 'MDM Pico Left', 24, false);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'pico-cloaked':
				healthBarColor = FlxColor.fromRGB(160, 182, 93);
				tex = Paths.getSparrowAtlas("mdmPicoPhase1", 'shared', true);
				frames = tex;

				animation.addByPrefix('idle', "MDM Pico Idle", 24);
				animation.addByPrefix('singUP', 'MDM Pico Up', 24, false);
				animation.addByPrefix('singDOWN', 'MDM Pico Down', 24, false);
				animation.addByPrefix('singLEFT', 'MDM Pico Backward', 24, false);
				animation.addByPrefix('singRIGHT', 'MDM Pico Forward', 24, false);
	
				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;

			case 'pizza':
				healthBarColor = FlxColor.fromRGB(0, 102, 0);
				tex = Paths.getSparrowAtlas('characters/PizzaMan', 'shared');
				frames = tex;
				animation.addByPrefix('idle', "PizzasHere", 29);
				animation.addByPrefix('fall', "PizzasHere", 29);
				animation.addByPrefix('singUP', 'Up', 29, false);
				animation.addByPrefix('singDOWN', 'Down', 29, false);
				animation.addByPrefix('singLEFT', 'Left', 29, false);
				animation.addByPrefix('singRIGHT', 'Right', 29, false);

				loadOffsetFile(curCharacter);

			case 'bf':
				healthBarColor = FlxColor.fromRGB(64, 143, 163);
				var tex = Paths.getSparrowAtlas('BOYFRIEND','shared',true);
				frames = tex;

				trace(tex.frames.length);

				animation.addByPrefix('idle', 'BF idle dance', 24, false);
				animation.addByPrefix('singUP', 'BF NOTE UP0', 24, false);
				animation.addByPrefix('singLEFT', 'BF NOTE LEFT0', 24, false);
				animation.addByPrefix('singRIGHT', 'BF NOTE RIGHT0', 24, false);
				animation.addByPrefix('singDOWN', 'BF NOTE DOWN0', 24, false);
				animation.addByPrefix('singUPmiss', 'BF NOTE UP MISS', 24, false);
				animation.addByPrefix('singLEFTmiss', 'BF NOTE LEFT MISS', 24, false);
				animation.addByPrefix('singRIGHTmiss', 'BF NOTE RIGHT MISS', 24, false);
				animation.addByPrefix('singDOWNmiss', 'BF NOTE DOWN MISS', 24, false);
				animation.addByPrefix('hey', 'BF HEY', 24, false);

				animation.addByPrefix('firstDeath', "BF dies", 24, false);
				animation.addByPrefix('deathLoop', "BF Dead Loop", 24, true);
				animation.addByPrefix('deathConfirm', "BF Dead confirm", 24, false);

				animation.addByPrefix('scared', 'BF idle shaking', 24);

				loadOffsetFile(curCharacter);

				playAnim('idle');

				flipX = true;
		}

		dance();

		if (isPlayer)
		{
			flipX = !flipX;

			// Doesn't flip for BF, since his are already in the right place???
			if (!curCharacter.startsWith('bf'))
			{
				// var animArray
				var oldRight = animation.getByName('singRIGHT').frames;
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animation.getByName('singLEFT').frames = oldRight;

				// IF THEY HAVE MISS ANIMATIONS??
				if (animation.getByName('singRIGHTmiss') != null)
				{
					var oldMiss = animation.getByName('singRIGHTmiss').frames;
					animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
					animation.getByName('singLEFTmiss').frames = oldMiss;
				}
			}
		}
	}

	public function loadOffsetFile(character:String)
	{
		var offset:Array<String> = CoolUtil.coolTextFile(Paths.txt('images/characters/' + character + "Offsets", 'shared'));

		for (i in 0...offset.length)
		{
			var data:Array<String> = offset[i].split(' ');
			addOffset(data[0], Std.parseInt(data[1]), Std.parseInt(data[2]));
		}
	}

	override function update(elapsed:Float)
	{
		if (!curCharacter.startsWith('bf'))
		{
			if (animation.curAnim.name.startsWith('sing'))
			{
				holdTimer += elapsed;
			}

			var dadVar:Float = 4;

			if (curCharacter == 'dad')
				dadVar = 6.1;
			if (holdTimer >= Conductor.stepCrochet * dadVar * 0.001)
			{
				trace('dance');
				dance();
				holdTimer = 0;
			}
		}

		switch (curCharacter)
		{
			case 'gf':
				if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished)
					playAnim('danceRight');
		}

		super.update(elapsed);
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance(forced:Bool = false)
	{
		if (!debugMode)
		{
			switch (curCharacter)
			{
				case 'gf' | 'gf-christmas' | 'gf-car' | 'gf-pixel':
					if (!animation.curAnim.name.startsWith('hair'))
					{
						danced = !danced;

						if (danced)
							playAnim('danceRight');
						else
							playAnim('danceLeft');
					}
				case 'spooky':
					danced = !danced;

					if (danced)
						playAnim('danceRight');
					else
						playAnim('danceLeft');
				default:
					playAnim('idle', forced);
			}
		}
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
	{
		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(AnimName);
		if (animOffsets.exists(AnimName))
		{
			offset.set(daOffset[0], daOffset[1]);
		}
		else
			offset.set(0, 0);

		if (curCharacter == 'gf')
		{
			if (AnimName == 'singLEFT')
			{
				danced = true;
			}
			else if (AnimName == 'singRIGHT')
			{
				danced = false;
			}

			if (AnimName == 'singUP' || AnimName == 'singDOWN')
			{
				danced = !danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
	{
		animOffsets[name] = [x, y];
	}
}
