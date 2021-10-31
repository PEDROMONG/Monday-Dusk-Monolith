package;

//import js.html.FileSystem;
import lime.tools.Icon;
import flixel.addons.display.FlxBackdrop;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;

#if windows
import Sys;
import sys.FileSystem;
#end

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class CreditsMenuState extends MusicBeatState
{

    var credIcons:FlxTypedGroup<CreditIcons>;

    var credText:String = '';
    var creditText:FlxText;
    var arrowLeft:FlxSprite;
	var arrowRight:FlxSprite;
    public var wackyText:FlxSprite;
    var curPage:Int = 0;
    var unlockMovement:Bool = true;
    
    override function create()
        {
            super.create();
            FlxG.camera.zoom = 1.0;

            if (FlxG.sound.music != null)
                {
                    if (!FlxG.sound.music.playing)
                        {
                            FlxG.sound.playMusic(Paths.music('freakyMenu'));
                            Conductor.changeBPM(102);
                        }
               }

             persistentUpdate = persistentDraw = true;

             FlxG.mouse.visible = true;

             #if windows
             // Updating Discord Rich Presence
             DiscordClient.changePresence("Checking Out Credits", null);
             #end

             var creditBackground:FlxBackdrop = new FlxBackdrop(Paths.image('credits/checkerBullshit'), 1, 1, true, true);
             creditBackground.velocity.set(2, 2);
             add(creditBackground);

             credIcons = new FlxTypedGroup<CreditIcons>();
             add(credIcons);

             var boxYeah:FlxSprite = new FlxSprite(890, -90).loadGraphic(Paths.image('credits/TRUE'));
             add(boxYeah);

             arrowRight = new FlxSprite(525, 500).loadGraphic(Paths.image("credits/arrowRight"));
             arrowRight.scale.set(1.6, 1.6);
             arrowRight.updateHitbox();
             add(arrowRight);
     
             arrowLeft = new FlxSprite(-70, 500).loadGraphic(Paths.image("credits/arrowLeft"));
             arrowLeft.scale.set(1.6, 1.6);
             arrowLeft.updateHitbox();
             add(arrowLeft);

             wackyText = new FlxSprite(80, 380);
			 wackyText.frames = Paths.getSparrowAtlas('credits/introtext_assets');
			 wackyText.animation.addByPrefix('idle', 'devs');
             wackyText.animation.addByPrefix('special', 'special thanks');
             wackyText.scale.set(0.7, 0.7);
			 wackyText.animation.play('idle');
			 add(wackyText);

             creditText = new FlxText(910, 60, 350, "", 42);
             creditText.setFormat(Paths.font("Funkin.otf"), 42, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
             creditText.scrollFactor.set();
             if(FlxG.save.data.antialiasing)
                {
                    creditText.antialiasing = true;
                }
     
             add(creditText);

             for (i in 0...8)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Puki', 'https://twitter.com/PukiNuke', 'Puki\n\nCreator of Monday Dusk Monolith, has worked on Neo and more mods. Puki created a lot of the designs, concepts, and wrote a lot of the dialogue, as well as creating a lot of the lore.');

                        case 1:
                            credIcon = new CreditIcons(0, 0, 'Squidley', 'https://twitter.com/sqvidley', 'Squidley\n\nCo-Created Monday Dusk Monolith, has worked on Neo, Curse of Funkenstein, Doki Doki Takeover and more. Squidley created lore, designs, mechanic concepts and more, as well as writing dialogue and making music tracks. As well as making every hard chart.');

                        case 2:
                            credIcon = new CreditIcons(0, 0, 'Joe', 'https://twitter.com/riphasabrain', 'Joe\n\nLead Programmer and Manager for Monday Dusk Monolith. Creates those Fart variables. Has worked on Bobs Trick or Treat, Doki Doki Takeover, little man 2 and more. Made several ideas for MDM. Can do fucking sick backflips.');

                        case 3:
                            credIcon = new CreditIcons(0, 0, 'Wreach', 'https://twitter.com/wreach_', 'Wreach\n\nMain Musician for Monday Dusk Monolith, created most of the soundtrack, provided plenty of feedback and ideas towards development.');

                        case 4:
                           credIcon = new CreditIcons(0, 0, 'Dause', 'https://twitter.com/DauseRetch', 'Dause_Retch\n\nDause is the Main Animator for Monday Dusk Monolith, has worked on other mods before.');

                        case 5:
                            credIcon = new CreditIcons(0, 0, 'Snart', 'https://twitter.com/Snart_Studios', 'Snart Studios\n\nSnart is a Sprite Artist and Designer for Monday Dusk Monolith, Snart Studios created the designs for Flesh Monster and the Goons, while also making the base sprites for Flesh Monster. Snart is currently working on other mods as well.');

                        case 6:
                              credIcon = new CreditIcons(0, 0, 'Flan', 'https://twitter.com/F14nTh3M4n', 'Flan the Man\n\nFlan is a Sprite Animator for Monday Dusk Monolith. Flan animated both Pico sprites and has worked on other mods such as V.S Yoshi, V.S Voltz and V.S Cval.');

                        case 7:
                             credIcon = new CreditIcons(0, 0, 'Bun', 'https://twitter.com/ghostbunbun', 'Cherribun\n\nCherribun is a Dialogue Artist for Monday Dusk Monolith. She made every dialogue portrait used within the mod. She has also created Sonic Rhythmic Rush.');
                    }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 50 + (i * 200);
                    credIcon.y = 50;

                    if (i > -1 && i < 3)
                        {
                            credIcon.x = 50 + (i * 200);
                        }

                    if (i > 3 && i < 8)
                        {
                            credIcon.x = 50 + ((i - 4) * 200);
                            credIcon.y += 200;
                        }

                    if (i > 8)
                        {
                            credIcon.x = 50 + ((i - 8) * 200);
                            credIcon.y += 400;
                        }
                }
             for (i in 0...8)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Sweezo', 'https://twitter.com/Sweezo_SFM', 'Sweezo\n\nSweezo is a Programmer and Charter for Monday Dusk Monolith. He programmed various things and did almost every single underchart. He has also worked on other mods such as Funky Frights.');

                        case 1:
                            credIcon = new CreditIcons(0, 0, 'Phlox', 'https://www.youtube.com/c/phlox', 'Phlox\n\nPhlox is a UI Designer for Monday Dusk Monolith. Phlox created various concepts and ideas for UI, made the text box and other things. You may know Phlox for creating the Bob mod. Phlox has worked on other mods too.');

                        case 2:
                            credIcon = new CreditIcons(0, 0, 'Wildy', 'https://twitter.com/wildythomas1233', 'Wildythomas\n\nWildy is a Charter and gives Programming Advice for Monday Dusk Monolith. Wildy has helped with programming several times. You may know him from Bob mod, little man 2 and Bob and Bosip.');

                        case 3:
                            credIcon = new CreditIcons(0, 0, 'TSG', 'https://twitter.com/AyeTSG', 'TSG\n\nTSG was a Programmer for Monday Dusk Monolith. TSG wrote Dialogue code and code for the Goons. TSG has also worked on Cyrix, Bobs Onslaught and others.');

                        case 4:
                           credIcon = new CreditIcons(0, 0, 'Jorge', 'https://twitter.com/Jorge_SunSpirit', 'Jorge - Sun Spirit\n\nJorge is an Assistance Programmer for Monday Dusk Monolith. Jorge did the code for the HP Goons and the health gradient mechanic. Jorge has worked on mods such as Doki Doki Takeover and others.');

                        case 5:
                            credIcon = new CreditIcons(0, 0, 'Fireable', 'https://twitter.com/notfireable', 'Fireable\n\nFireable is a Programmer for Monday Dusk Monolith. Fireable coded several things. Fireable has also worked on V.S Camelia and other mods.');

                        case 6:
                              credIcon = new CreditIcons(0, 0, 'Zack', 'https://twitter.com/ZackTheNerd', 'Zack The Nerd\n\nZack is a Artist for Monday Dusk Monolith. Zack did the Storymode Art and created Him. Zack has also worked on Martian Mixtape, Laugh and Peace and others.');

                        case 7:
                             credIcon = new CreditIcons(0, 0, 'Matt', 'https://twitter.com/matt_currency', 'Matt$\n\nMatt made a Bonus Track which is in Monday Dusk Monolith. The track is North. Matt has also worked on Cyrix, Doki Doki Takeover, F3.');
                    }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 1330 + (i * 200);
                    credIcon.y = 50;

                    if (i > -1 && i < 3)
                        {
                            credIcon.x = 1330 + (i * 200);
                        }

                    if (i > 3 && i < 8)
                        {
                            credIcon.x = 1330 + ((i - 4) * 200);
                            credIcon.y += 200;
                        }

                    if (i > 8)
                        {
                            credIcon.x = 1330 + ((i - 8) * 200);
                            credIcon.y += 400;
                        }
                }
             for (i in 0...8)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Bon', 'https://twitter.com/ProjectBon', 'Bon\n\nBon is a Beta Tester for Monday Dusk Monolith. Bon tested the mod and created Runner. Bon has also made Mobile Mania, Donut Eater, has worked on Wiik3+, V.S Baby mod.');

                        case 1:
                            credIcon = new CreditIcons(0, 0, 'Tenaxis', 'https://www.youtube.com/c/Tenaxis', 'Tenaxis\n\nTenaxis is a Musician and Voice Actor for Monday Dusk Monolith. Tenaxis composed Flesh and is the voice of Flesh Monster. Tenaxis has also worked on The Interviewed, Arcade Showdown (Kapi) and others.');

                        case 2:
                            credIcon = new CreditIcons(0, 0, 'Sector', 'https://twitter.com/Sector0003', 'Sector\n\nSector is a Programmer for Monday Dusk Monolith. Sector worked on several things and fixed multiple bugs. Sector has also worked on Micd Up, Cirno, HL024.');

                        case 3:
                            credIcon = new CreditIcons(0, 0, 'Mountroid', 'https://twitter.com/mountroid', 'Mountroid\n\nMountroid is a Visualiser for Monday Dusk Monolith. Mountroid did visualisers for several songs. Mountroid makes his own animations and has worked on other mods before.');

                        case 4:
                           credIcon = new CreditIcons(0, 0, 'Pip', 'https://twitter.com/DojimaDog', 'Pip\n\nPip is a Beta Tester for Monday Dusk Monolith. Pip beta tested the mod several times and provided ideas. Pip is the creator of F3 and Fizzy Pop Panic and has worked on several other projects before.');

                        case 5:
                            credIcon = new CreditIcons(0, 0, 'Myth', 'https://twitter.com/Mythicalian', 'Mythical\n\nMyth is a Voice Actor for Monday Dusk Monolith. He voiced GF in Prologue.');

                        case 6:
                              credIcon = new CreditIcons(0, 0, 'Leafstake', 'https://twitter.com/LeafsteakSunday', 'Leafstake\n\nLeaf is a Beta Tester for Monday Dusk Monolith.');

                        case 7:
                             credIcon = new CreditIcons(0, 0, 'Clowfoe', 'https://twitter.com/Clowfoe', 'Clowfoe\n\nClowfoe is a Beta Tester for Monday Dusk Monolith. Clowfoe provided bugs and assistance. Clowfoe has worked on other mods such as V.S Imposter and others.');
                    }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 2625 + (i * 200);
                    credIcon.y = 50;

                    if (i > -1 && i < 3)
                        {
                            credIcon.x = 2625 + (i * 200);
                        }

                    if (i > 3 && i < 8)
                        {
                            credIcon.x = 2625 + ((i - 4) * 200);
                            credIcon.y += 200;
                        }

                    if (i > 8)
                        {
                            credIcon.x = 2625 + ((i - 8) * 200);
                            credIcon.y += 400;
                        }
                }
             for (i in 0...7)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Snow', 'https://twitter.com/SnowTheFox122', 'Snow\n\nSnow made a Modchart that is used in Flesh for Monday Dusk Monolith. Snow has worked on other mods such as Retrospecter Remixes, V.S Snow and more.');

                        case 1:
                            credIcon = new CreditIcons(0, 0, 'Jams', 'https://twitter.com/jams3d', 'Jams3D\n\nJams3D is a Beta Tester for Monday Dusk Monolith, Jams has worked on other mods such as B3 Remixed in the past.');

                        case 2:
                            credIcon = new CreditIcons(0, 0, 'Sign', 'https://twitter.com/SignmanstrrEy', 'Sign\n\nSign is a Charter for Monday Dusk Monolith. Sign did the undercharts for Flesh.');

                        case 3:
                            credIcon = new CreditIcons(0, 0, 'Raze', 'https://twitter.com/TheOGFazFilms', 'Raze\n\nRaze is a Visualiser and Beta Tester for Monday Dusk Monolith. Raze made several visualisers which are uploaded. Raze has worked on other mods such as Funky Frights, FNF: The Curse Of Tails Doll and more.');
                        
                        case 4:
                            credIcon = new CreditIcons(0, 0, 'Empty', 'https://sites.google.com/view/bobismad/home', '');
                        
                        case 5:
                            credIcon = new CreditIcons(0, 0, 'Undernity', 'https://twitter.com/UndernityMain', 'Undernity\n\nUndernity has helped with some extra coding in MDM, they have also worked on other projects related to FNF.');
                            
                            case 6:
                                credIcon = new CreditIcons(0, 0, 'Oddball', 'https://twitter.com/AnOddArtist', 'AnOddArtist\n\nOddBall was one of the artists for Monday Dusk Monolith. Oddball did the Main Menu art and other several pieces of artwork.');
                        }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 3910 + (i * 200);
                    credIcon.y = 50;

                    if (i > -1 && i < 4)
                        {
                            credIcon.x = 3910 + (i * 200);
                        }
                    if (i > 3 && i < 8)
                        {
                            credIcon.x = 3910 + ((i - 4) * 200);
                            credIcon.y += 200;
                        }
                }
             for (i in 0...8)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Cel', 'https://twitter.com/CELSHDR', 'CelShader\n\nCelShader is here due to being a major inspiration and a huge supporter, thank you so much, Cel. It means a lot to us :)');

                        case 1:
                            credIcon = new CreditIcons(0, 0, 'Duster', 'https://twitter.com/SirDusterBuster', 'DusterBuster\n\nDusterBuster is here due to also being a major inspiration and a huge supporter, thank you so much, Duster. It means a lot to us :)');

                        case 2:
                            credIcon = new CreditIcons(0, 0, 'Silk', 'https://twitter.com/silksstuff', 'Silk\n\nSilk is here due to being a huge supporter for the team since the beginning, genuinely thank you so much Silk, it means so much to us :)');

                        case 3:
                            credIcon = new CreditIcons(0, 0, 'Ash', 'https://twitter.com/ash__i_guess_', 'Ash\n\nAsh is here due to being a huge help with coding things, thank you for open sourcing your code, it genuinely taught a lot!');

                        case 4:
                           credIcon = new CreditIcons(0, 0, 'BF', 'https://harlessben321.itch.io/fnf-modding-plus', 'Modding Plus\n\nModding Plus is here due to their alphabet, we used it for the mod, thank you for providing it!');

                        case 5:
                            credIcon = new CreditIcons(0, 0, 'Freddle', 'https://twitter.com/FFrooby', 'FreddleFrooby\n\nFreddleFrooby is here due to being such a massive supporter, thank you so much!');

                        case 6:
                              credIcon = new CreditIcons(0, 0, 'Max', 'https://twitter.com/MMillion_', 'MMillion\n\nMMillion is here due to being such a huge supporter, thank you so much!');

                        case 7:
                             credIcon = new CreditIcons(0, 0, 'JiggaOver', 'https://twitter.com/JiggaOver9000', 'JiggaOvver9000\n\nJiggaOver9000 is here due to him making special UI assets for us to use and being such a huge supporter, thank you so much!');
                    }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 5200 + (i * 200);
                    credIcon.y = 50;

                    if (i > -1 && i < 3)
                        {
                            credIcon.x = 5200 + (i * 200);
                        }

                    if (i > 3 && i < 8)
                        {
                            credIcon.x = 5200 + ((i - 4) * 200);
                            credIcon.y += 200;
                        }

                    if (i > 8)
                        {
                            credIcon.x = 5200 + ((i - 8) * 200);
                            credIcon.y += 400;
                        }
                }

             for (i in 0...1)
                {
                    var credIcon:CreditIcons = new CreditIcons();

                    credIcons.ID = i;

                    switch (i)
                    {
                        case 0:
                            credIcon = new CreditIcons(0, 0, 'Charlie', 'https://twitter.com/CharlieTsun', 'CharlieTsun\n\nCharlieTsun helped us out last second by making a few icons for the credits, she has also been a huge supporter for a long time, thank you Charlie! :)');
                    }
                    credIcons.add(credIcon);

                    if(FlxG.save.data.antialiasing)
                        {
                            credIcon.antialiasing = true;
                        }

                    credIcon.x = 6750;
                    credIcon.y = 250;

                    if (i > -1 && i < 2)
                        {
                            credIcon.x = 6750;
                        }
                }


        }

    override function update(elapsed:Float)
        {   
            if (unlockMovement) {
                if (controls.LEFT_P) {
                    changePage(-1);
                }
                if (controls.RIGHT_P) {
                    changePage(1);
                }
            }

            if (controls.BACK)
                {
                    FlxG.sound.play(Paths.sound('cancelMenu'));
                    FlxG.switchState(new ExtrasMenuState());
                }
            if (controls.RIGHT)
                  arrowRight.scale.set(1.4, 1.4);
              else
                  arrowRight.scale.set(1.6, 1.6);
        
           if (controls.LEFT)
                arrowLeft.scale.set(1.4, 1.4);
            else
                arrowLeft.scale.set(1.6, 1.6);

            for (i in credIcons)
                {
                    if (FlxG.mouse.overlaps(i))
                        {
                            i.scale.set(1.2, 1.2);
                            creditText.text = i.credText;

                            if (FlxG.mouse.justPressed)
                                {
                                #if linux
                                Sys.command('/usr/bin/xdg-open', [i.link, "&"]);
                                #else
                                FlxG.openURL(i.link);
                                #end
                        }
                }
            else
                {
                    i.scale.set(1.1, 1.1);
                }

            super.update(elapsed);
            
        }
    }

    function changePage(change:Int = 0):Void {
        var prevPage = curPage;
        curPage += change;
        if (curPage < 0) {
            curPage = 0;
        } else if (curPage > 5) {
            curPage = 5;
        }
        if (curPage == 3) {
            wackyText.animation.play('idle');
        } if (curPage == 4) {
            wackyText.animation.play('special');
        }
        if (prevPage != curPage) {
            for (i in credIcons) {
                unlockMovement = false;
                FlxTween.tween(i, {x: i.x + FlxG.width * -change}, 1, {
                    ease: FlxEase.quadOut,
                    onComplete: function (twn:FlxTween) {
						unlockMovement = true;
                    }
                });
            }
        }
    }
}
            