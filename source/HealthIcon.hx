package;

import flixel.FlxG;
import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		if(FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}
		if (char == 'sm')
		{
			loadGraphic(Paths.image("stepmania-icon"));
			return;
		}
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);
        animation.add('bf', [0, 1], 0, false, isPlayer);
        animation.add('spooky', [2, 3], 0, false, isPlayer);
        animation.add('pico', [4, 5], 0, false, isPlayer);
        animation.add('face', [10, 11], 0, false, isPlayer);
        animation.add('dad', [12, 13], 0, false, isPlayer);
        animation.add('gf', [16], 0, false, isPlayer);
        animation.add('monster', [19, 20], 0, false, isPlayer);
        animation.add('lila', [28, 29], 0, false, isPlayer);
        animation.add('pico-cloaked', [26, 27], 0, false, isPlayer);
        animation.add('dad-saving', [24, 25], 0, false, isPlayer);
		animation.add('pizza', [24, 25], 0, false, isPlayer);
        animation.play(char);

		switch(char)
		{
			case 'bf-pixel' | 'senpai' | 'senpai-angry' | 'spirit' | 'gf-pixel':
				antialiasing = false;
		}

		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
