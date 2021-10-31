package;
import flixel.*;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

/**
 * ...
 * @author bbpanzu
 //thank u bbpanzu, bless -carrot
 hi you guys dont mind if i use this again thanjs -wildy
 hey guys what is up yall dont mind if i use this right - joe
 */
class EndingState extends FlxState
{
	var alreadySkipped:Bool = false;
	public function new() 
	{
		super();
	}
	
	override public function create():Void 
	{
		super.create();
		var end:FlxSprite = new FlxSprite(0, 0);
		end.loadGraphic(Paths.image("tobecontinued"));
		add(end);
		FlxG.camera.fade(FlxColor.BLACK, 0.8, true);
		
		
		new FlxTimer().start(9, endIt);
		
	}
	
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		
		if (FlxG.keys.pressed.ENTER){
			endIt();
		}
		
	}
	
	
	public function endIt(e:FlxTimer=null){
		trace("ENDING");
		if (FlxG.save.data.scoreScreen)
		{
			if (alreadySkipped == false)
			{
				alreadySkipped = true;
				openSubState(new ResultsScreen());
				new FlxTimer().start(1, function(tmr:FlxTimer)
					{
						PlayState.inResults = true;
					});
			}
		}
		else
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
			Conductor.changeBPM(102);
			FlxG.switchState(new StoryMenuState());
		}
	}
	
}