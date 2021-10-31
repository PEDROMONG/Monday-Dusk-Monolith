package helpers;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class StoryMenuBGHelper extends FlxSprite
{
    public function new(x:Float, y:Float)
    {
        super(x, y);

        frames = Paths.getSparrowAtlas("MDMWeekSpriteSheet");
        
        animation.addByPrefix("prologue", "Prologue", 0);
        animation.addByPrefix("week1", "Week1", 0);
        animation.addByPrefix("week2", "Week2", 0);
        animation.addByPrefix("week3", "Week3", 0);

        animation.play("prologue");

        scale.x = 1.15;
        antialiasing = true;
    }

    public function setWeek(weekNum:Int) {
        if (weekNum == 0) {
            animation.play("prologue");
        } else {
            animation.play("week" + weekNum);
        }
    }
}