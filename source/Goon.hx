import motion.easing.Linear;
import motion.Actuate;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;

/**
    IDEAS:
    - For falling goons (jumping), maybe we can tween the y over time?
**/

/**
The direction of the goon
**/
enum GoonDirection {
    /**
    Moves from the right of the screen to the left
    **/
    RIGHTTOLEFT;

    /**
    Moves from the left of the screen to the right
    **/
    LEFTTORIGHT;
}

/**
The type of goon
**/
enum GoonType {
    /**
    Marches across the bottom of the screen
    **/
    MARCHING;

    /**
    Jumps across the bottom of the screen
    **/
    JUMPING;
}

/**
A monster goon
**/
class Goon extends FlxSprite
{
    /**
    The time it takes for a goon (in seconds) to march across the screen
    **/
    public var goonTravelSpeed:Float = 4;

    public var goonType:GoonType = GoonType.MARCHING;
    public var goonDirection:GoonDirection = GoonDirection.RIGHTTOLEFT;

    private var goonMarchMinY:Float;
    private var goonMarchMaxY:Float;

    /**
    Creates a new goon with a specified type and direction
    **/
    public function new(type:GoonType, direction:GoonDirection)
    {
        // Sets the underlying FlxSprite pos at 0,0... we adjust it later
        super(0, 0);

        // Behavior - Variables
        goonType = type;
        goonDirection = direction;

        // Animation - X Flip
        if (goonDirection == GoonDirection.LEFTTORIGHT) {
            flipX = true;
        }

        // Animation - Marching
        if (goonType == GoonType.MARCHING) {
            frames = Paths.getSparrowAtlas("Goons_Marching", "week2");
            animation.addByPrefix("march", "Goons Marching", 24, true);

            animation.play("march");

            goonMarchMinY = 0 + this.height;
            goonMarchMaxY = FlxG.height - this.height;
        }

        // Animation - Jumping
        if (goonType == GoonType.JUMPING) {
            frames = Paths.getSparrowAtlas("Goons_Jump", "week2");
            animation.addByPrefix("jump", "Goons Jump", 24, false);

            animation.play("jump");
        }

        // Behavior - Marching
        if (goonType == GoonType.MARCHING) {
            // Behavior - Left to right
            if (goonDirection == GoonDirection.LEFTTORIGHT) {
                // Set position to bottom left of screen
                this.setPosition(0 - this.width, FlxG.random.float(goonMarchMinY, goonMarchMaxY));

                // Tween position using the travel speed
                //FlxTween.tween(this, {x: FlxG.width}, this.goonTravelSpeed, {onComplete: function(tween:FlxTween) {
                //    this.destroy();
                //}});

                Actuate.tween (this, this.goonTravelSpeed, {x: FlxG.width}).onComplete (this.destroy).ease (Linear.easeNone);
            }

            // Behavior - Right to left
            if (goonDirection == GoonDirection.RIGHTTOLEFT) {
                // Set position to bottom right of screen
                this.setPosition(FlxG.width, FlxG.random.float(goonMarchMinY, goonMarchMaxY));

                // Tween position using the travel speed
                //FlxTween.tween(this, {x: 0 - this.width}, this.goonTravelSpeed, {onComplete: function(tween:FlxTween) {
                //    this.destroy();
                //}});

                Actuate.tween (this, this.goonTravelSpeed, {x: 0 - this.width}).onComplete (this.destroy).ease (Linear.easeNone);
            }
        }

        // Behavior - Jumping
        if (goonType == GoonType.JUMPING) {
            // Behavior - Right to left
            if (goonDirection == GoonDirection.RIGHTTOLEFT) {
                // Center the goon on the screen
                this.screenCenter();

                // Adjust it's position
                this.x += 320;
                this.y += 224;

                this.animation.finishCallback = function(name:String) {
                    this.destroy();
                }
            }

            // Behavior - Left to right
            if (goonDirection == GoonDirection.LEFTTORIGHT) {
                // Center the goon on the screen
                this.screenCenter();

                // Adjust it's position
                this.x -= 320;
                this.y += 224;

                this.animation.finishCallback = function(name:String) {
                    this.destroy();
                }
            }
        }
    }
}