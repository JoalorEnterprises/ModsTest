package;

import flixel.FlxGame;
import openfl.display.Sprite;

import core.ToastCore;
import core.ModCore;

class Main extends Sprite
{
	public static var toast:ToastCore;
	
	public function new()
	{
		super();

		ModCore.reload();

		addChild(new FlxGame(1280, 720, PlayState, #if (flixel < "5.0.0") -1, #end 60, 60, false, false));

		toast = new ToastCore();
		addChild(toast);
	}
}