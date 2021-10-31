package;

import flixel.FlxSprite;

class CreditIcons extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var link:String;

	public var credText:String;

	public function new(xPos:Float = 0, yPos:Float = 0, icon:String = 'Joe', ?daLink:String = 'https://twitter.com/riphasabrain', daText:String = 'Joe\n\ndid work')
	{
		super(xPos, yPos);
		link = daLink;
		loadGraphic(Paths.image('icons/icon' + icon));
		credText = daText;
	}
}