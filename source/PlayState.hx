package;

import flixel.text.FlxText;
import flixel.FlxState;
import core.ModCore;
import flixel.FlxG;

class PlayState extends FlxState
{
    	override public function create()
    	{
        	Paths.clearStoredMemory();
		Paths.clearUnusedMemory();
        
        	#if FUTURE_POLYMOD
		ModCore.reload();
		if (ModCore.trackedMods != []) {
			for (i in ModCore.trackedMods) {
				Main.toast.create('Mods installed', 0xFFFFFF00, ' ${i.title}');
			}
		}
		#end

        	super.create();

        	var text:FlxText = new FlxText(0, 0, 0, "Hello World", 64);
        	text.screenCenter();
        	add(text);
    	}

    	override public function update(elapsed:Float)
    	{
        	if (FlxG.keys.justPressed.M)
        	{ 
            		FlxG.switchState(new ModsState());
        	}
        
        	super.update(elapsed);
    	}
}
