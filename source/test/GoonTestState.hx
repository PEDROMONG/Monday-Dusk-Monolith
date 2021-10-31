package test;

import flixel.addons.plugin.taskManager.FlxTask;
import flixel.text.FlxText;
import flixel.FlxSprite;
import Goon.GoonDirection;
import Goon.GoonType;
import flixel.FlxG;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import Song.SwagSong;

class GoonTestState extends MusicBeatState
{
    var song:SwagSong;
    var hasEnded:Bool;

    var testGoon:Goon;

    var goonTypeTxt:FlxText;
    var goonDirectionTxt:FlxText;
    var goonSpeedTxt:FlxText;

    override function create() {
        super.create();

        var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.GRAY);
        add(bg);

        goonTypeTxt = new FlxText(10, 10, "", 20);
        goonTypeTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(goonTypeTxt);

        goonDirectionTxt = new FlxText(10, 28, "", 20);
        goonDirectionTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(goonDirectionTxt);

        goonSpeedTxt = new FlxText(10, 46, "", 20);
        goonSpeedTxt.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(goonSpeedTxt);

        song = Song.loadFromJson("flesh", "flesh");
        Conductor.mapBPMChanges(song);
        Conductor.changeBPM(song.bpm);
        persistentUpdate = true;

        new FlxTimer().start(0.5, function(tmr:FlxTimer){
            this.startSong();
        });

        new FlxTimer().start(2.5, function(tmr:FlxTimer) {
            testGoon = new Goon(GoonType.MARCHING, GoonDirection.RIGHTTOLEFT);
            add(testGoon);

            // testGoon.screenCenter();

            new FlxTimer().start(testGoon.goonTravelSpeed, function(tmr:FlxTimer) {
                testGoon = new Goon(GoonType.MARCHING, GoonDirection.LEFTTORIGHT);
                add(testGoon);

                // testGoon.screenCenter();

                new FlxTimer().start(testGoon.goonTravelSpeed, function(tmr:FlxTimer) {
                    testGoon = new Goon(GoonType.JUMPING, GoonDirection.RIGHTTOLEFT);
                    add(testGoon);

                    new FlxTimer().start(testGoon.goonTravelSpeed, function(tmr:FlxTimer) {
                        testGoon = new Goon(GoonType.JUMPING, GoonDirection.LEFTTORIGHT);
                        add(testGoon);
                    });
                });
            });
        });
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

        if (testGoon != null) {
            if (testGoon.goonType == GoonType.MARCHING) {
                goonTypeTxt.text = "Goon Type: Marching";
            } else if (testGoon.goonType == GoonType.JUMPING) {
                goonTypeTxt.text = "Goon Type: Jumping";
            }

            if (testGoon.goonDirection == GoonDirection.RIGHTTOLEFT) {
                goonDirectionTxt.text = "Goon Direction: Right to Left";
            } else if (testGoon.goonDirection == GoonDirection.LEFTTORIGHT) {
                goonDirectionTxt.text = "Goon Direction: Left to Right";
            }

            goonSpeedTxt.text = "Goon Speed: " + testGoon.goonTravelSpeed;
        }
    }

    override function onFocusLost()
    {
        if (hasEnded == false) {
            FlxG.sound.music.pause();
        }

        super.onFocusLost();
    }

    override function onFocus()
    {
        if (hasEnded == false) {
            FlxG.sound.music.play();

            this.resyncVocals();
        }
    }

    function startSong():Void
    {
        FlxG.sound.playMusic(Paths.inst(song.song), 1, false);
        FlxG.sound.music.onComplete = this.endSong;

        hasEnded = false;
    }

    function endSong():Void
    {
        hasEnded = true;

        FlxG.sound.music.volume = 0;

        new FlxTimer().start(0.5, function(tmr:FlxTimer) {
            FlxG.switchState(new MainMenuState());
        });
    }

    function resyncVocals():Void
    {
        FlxG.sound.music.play();
        Conductor.songPosition = FlxG.sound.music.time;
    }
}