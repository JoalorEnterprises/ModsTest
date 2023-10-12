package;

import flixel.FlxG;
import openfl.media.Sound;
import openfl.utils.Assets;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import core.ModCore;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Paths
{
	inline public static final SOUND_EXT = #if !html5 "ogg" #else "mp3" #end;

	static var currentLevel:String;

	public static var currentTrackedAssets:Map<String, FlxGraphic> = [];
	public static var currentTrackedSounds:Map<String, Sound> = [];

	public static var localTrackedAssets:Array<String> = [];

	public static function clearUnusedMemory()
	{
		for (key in currentTrackedAssets.keys())
		{
			if (!localTrackedAssets.contains(key) && key != null)
			{
				var obj = currentTrackedAssets.get(key);
				@:privateAccess
				if (obj != null)
				{
					Assets.cache.removeBitmapData(key);
					Assets.cache.clearBitmapData(key);
					Assets.cache.clear(key);
					FlxG.bitmap._cache.remove(key);
					obj.destroy();
					currentTrackedAssets.remove(key);
				}
			}
		}

		for (key in currentTrackedSounds.keys())
		{
			if (!localTrackedAssets.contains(key) && key != null)
			{
				var obj = currentTrackedSounds.get(key);
				if (obj != null)
				{
					Assets.cache.removeSound(key);
					Assets.cache.clearSounds(key);
					Assets.cache.clear(key);
					currentTrackedSounds.remove(key);
				}
			}
		}
	}

	public static function clearStoredMemory()
	{
		@:privateAccess
		for (key in FlxG.bitmap._cache.keys())
		{
			var obj = FlxG.bitmap._cache.get(key);
			if (obj != null && !currentTrackedAssets.exists(key))
			{
				Assets.cache.removeBitmapData(key);
				Assets.cache.clearBitmapData(key);
				Assets.cache.clear(key);
				FlxG.bitmap._cache.remove(key);
				obj.destroy();
			}
		}

		@:privateAccess
		for (key in Assets.cache.getSoundKeys())
		{
			if (key != null && !currentTrackedSounds.exists(key))
			{
				var obj = Assets.cache.getSound(key);
				if (obj != null)
				{
					Assets.cache.removeSound(key);
					Assets.cache.clearSounds(key);
					Assets.cache.clear(key);
				}
			}
		}

		localTrackedAssets = [];
	}

	static public function file(file:String)
	{
		var path = 'assets/$file';
		if (currentLevel != null && Assets.exists('$currentLevel:$path'))
			return '$currentLevel:$path';

		return path;
	}

	inline static public function txt(key:String)
	{
		return file('data/$key.txt');
	}

	inline static public function xml(key:String)
	{
		return file('data/$key.xml');
	}

	static public function sound(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('sounds/$key', cache);
	}

	inline static public function soundRandom(key:String, min:Int, max:Int)
	{
		return file('sounds/$key${FlxG.random.int(min, max)}.$SOUND_EXT');
	}

	inline static public function music(key:String, ?cache:Bool = true):Sound
	{
		return returnSound('music/$key', cache);
	}

	inline static public function image(key:String, ?cache:Bool = true):FlxGraphic
	{
		return returnGraphic('images/$key', cache);
	}

	inline static public function font(key:String)
	{
		return file('fonts/$key');
	}

	inline static public function getSparrowAtlas(key:String, ?cache:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(returnGraphic('images/$key', cache), xml('images/$key'));
	}

	inline static public function getPackerAtlas(key:String, ?cache:Bool = true):FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSpriteSheetPacker(returnGraphic('images/$key', cache), txt('images/$key'));
	}

	public static function returnGraphic(key:String, ?cache:Null<Bool> = true):FlxGraphic
	{
		var path:String = 'assets/$key.png';
		if (Assets.exists(path, IMAGE))
		{
			if (!currentTrackedAssets.exists(path))
			{
				var graphic:FlxGraphic = FlxGraphic.fromBitmapData(Assets.getBitmapData(path), false, path, cache);
				graphic.persist = true;
				currentTrackedAssets.set(path, graphic);
			}

			localTrackedAssets.push(path);
			return currentTrackedAssets.get(path);
		}

		trace('$key its null');
		return null;
	}

	public static function returnSound(key:String, ?cache:Null<Bool> = true):Sound
	{
		if (Assets.exists('assets/$key.$SOUND_EXT', SOUND))
		{
			var path:String = 'assets/$key.$SOUND_EXT';
			if (!currentTrackedSounds.exists(path))
				currentTrackedSounds.set(path, Assets.getSound(path, cache));

			localTrackedAssets.push(path);
			return currentTrackedSounds.get(path);
		}

		trace('$key its null');
		return null;
	}

	#if FUTURE_POLYMOD
	static public function mods(key:String = '')
	{
		if (ModCore.trackedMods != [])
		{
			for (i in 0...ModCore.trackedMods.length)
			{
				return 'mods/' + ModCore.trackedMods[i] + '/' + key;
			}
		}
		else
		{
			return 'mods/' + key;
		}

		return 'mods/' + key;
	}

	inline static public function appendTxt(key:String)
		return mods('_append/data/$key.txt');

	inline static public function modsTxt(key:String)
		return mods('data/$key.txt');

	inline static public function modsFont(key:String)
		return mods('fonts/$key');

	inline static public function modsJson(key:String)
		return mods('data/$key.json');

	inline static public function modsSounds(key:String)
		return mods('sounds/$key.$SOUND_EXT');

	inline static public function modsImages(key:String)
		return mods('images/$key.png');

	inline static public function modsXml(key:String)
		return mods('images/$key.xml');
	#end
}  