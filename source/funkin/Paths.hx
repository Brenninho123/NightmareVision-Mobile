package funkin;

import haxe.io.Path;
import openfl.media.Sound;
import flixel.FlxG;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import sys.FileSystem;
import funkin.mobile.backend.StorageUtil;

using StringTools;
using haxe.io.Path;

class Paths
{
	#if ASSET_REDIRECT
	public static inline final trail = #if macos '../../../../' #else '../../../../' #end;
	#end

	public static var CORE_DIRECTORY(get, never):String;
	private static inline function get_CORE_DIRECTORY():String
	{
		#if ASSET_REDIRECT
		return trail + 'assets/game';
		#else
		return 'assets';
		#end
	}

	public static var MODS_DIRECTORY(get, never):String;
	private static inline function get_MODS_DIRECTORY():String
	{
		#if mobile
		return StorageUtil.getStorageDirectory() + 'content';
		#else
		#if ASSET_REDIRECT
		return trail + 'content';
		#else
		return 'content';
		#end
		#end
	}

	public static var DEFAULT_FONT:String = 'vcr.ttf';

	public static var COMBO_PREFIX:String = 'UI/combo/';
	public static var RATINGS_PREFIX:String = 'UI/ratings/';
	public static var COUNTDOWN_PREFIX:String = 'UI/countdown/';
	public static var UI_PREFIX:String = 'UI/';

	@:allow(funkin.backend.FunkinCache)
	static var tempAtlasFramesCache:Map<String, FlxAtlasFrames> = [];

	public static function getPath(file:String, ?parentFolder:String, checkMods:Bool = false):String
	{
		if (parentFolder != null) file = '$parentFolder/$file';

		#if MODS_ALLOWED
		if (checkMods)
		{
			final modPath:String = modFolders(file);
			if (FileSystem.exists(modPath)) return modPath;
		}
		#end

		#if ASSET_REDIRECT
		final embedPath = getCorePath().replace(CORE_DIRECTORY, trail + 'assets/embeds') + file;
		if (FunkinAssets.exists(embedPath)) return embedPath;
		#end

		return getCorePath(file);
	}

	public static inline function getCorePath(file:String = ''):String
	{
		return '$CORE_DIRECTORY/$file';
	}

	public static inline function txt(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		return getPath('data/$key.txt', parentFolder, checkMods);
	}

	public static inline function xml(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		return getPath('data/$key.xml', parentFolder, checkMods);
	}

	public static inline function json(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		return getPath('songs/$key.json', parentFolder, checkMods);
	}

	public static inline function noteskin(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		var path = getPath('data/noteskins/$key.json', parentFolder, checkMods);
		if (!FunkinAssets.exists(path, TEXT)) path = getPath('noteskins/$key.json', parentFolder, checkMods);

		return path;
	}

	public static inline function fragment(key:String, checkMods:Bool = true):String
	{
		return getPath('shaders/$key.frag', null, checkMods);
	}

	public static inline function vertex(key:String, checkMods:Bool = true):String
	{
		return getPath('shaders/$key.vert', null, checkMods);
	}

	public static function video(key:String, ?ext:String, checkMods:Bool = true):String
	{
		final exts = ext != null ? [ext, 'mp4', 'mov', 'webm'] : ['mp4', 'mov', 'webm'];
		return findFileWithExts('videos/$key', exts, null, checkMods);
	}

	public static function textureAtlas(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		return getPath('images/$key', parentFolder, checkMods);
	}

	public static function sound(key:String, ?parentFolder:String, checkMods:Bool = true):Sound
	{
		final soundKey = findFileWithExts('sounds/$key', ['ogg', 'wav'], parentFolder, checkMods);
		return FunkinAssets.getSound(soundKey);
	}

	public static inline function soundRandom(key:String, min:Int = 0, max:Int = 0, ?parentFolder:String, checkMods:Bool = true):Sound
	{
		return sound(key + FlxG.random.int(min, max), parentFolder, checkMods);
	}

	public static inline function music(key:String, ?parentFolder:String, checkMods:Bool = true):Sound
	{
		final musicKey = findFileWithExts('music/$key', ['ogg', 'wav'], parentFolder, checkMods);
		return FunkinAssets.getSound(musicKey);
	}

	public static inline function trackSwap(song:String, ?postFix:String, checkMods:Bool = true):Null<Sound>
	{
		var name = sanitize(song);

		var songKey:String = '$name/Track';
		if (FunkinAssets.isDirectory(getPath('songs/$name/audio', null, checkMods))) songKey = '$name/audio/Track';

		if (postFix != null) songKey += '-$postFix';

		songKey = findFileWithExts('songs/$songKey', ['ogg', 'wav'], null, checkMods);

		if (ClientPrefs.streamedMusic) return FunkinAssets.getVorbisSound(songKey);

		return FunkinAssets.getSoundUnsafe(songKey);
	}

	public static inline function voices(song:String, ?postFix:String, checkMods:Bool = true):Null<Sound>
	{
		var name = sanitize(song);

		var songKey:String = '$name/Voices';
		if (FunkinAssets.isDirectory(getPath('songs/$name/audio', null, checkMods))) songKey = '$name/audio/Voices';

		if (postFix != null) songKey += '-$postFix';

		songKey = findFileWithExts('songs/$songKey', ['ogg', 'wav'], null, checkMods);

		if (ClientPrefs.streamedMusic) return FunkinAssets.getVorbisSound(songKey);

		return FunkinAssets.getSoundUnsafe(songKey);
	}

	public static inline function inst(song:String, ?postFix:String, checkMods:Bool = true):Sound
	{
		var name = sanitize(song);

		var songKey:String = '$name/Inst';
		if (FunkinAssets.isDirectory(getPath('songs/$name/audio', null, checkMods))) songKey = '$name/audio/Inst';

		if (postFix != null) songKey += '-$postFix';

		songKey = findFileWithExts('songs/$songKey', ['ogg', 'wav'], null, checkMods);

		if (ClientPrefs.streamedMusic) return FunkinAssets.getVorbisSound(songKey) ?? FunkinAssets.getSound(songKey);

		return FunkinAssets.getSound(songKey);
	}

	public static inline function image(key:String, ?parentFolder:String, allowGPU:Bool = true, checkMods:Bool = true):FlxGraphic
	{
		return FunkinAssets.getGraphic(getPath('images/$key.png', parentFolder, checkMods), true, allowGPU);
	}

	public static inline function font(key:String, checkMods:Bool = true):String
	{
		return findFileWithExts('fonts/$key', ['ttf', 'otf'], null, checkMods);
	}

	public static function findFileWithExts(key:String, exts:Array<String>, ?parentFolder:String, checkMods:Bool = true):String
	{
		for (ext in exts)
		{
			final joined = getPath('$key.$ext', parentFolder, checkMods);
			if (FunkinAssets.exists(joined)) return joined;
		}

		return getPath(key, parentFolder, checkMods);
	}

	public static function getTextFromFile(key:String, ?parentFolder:String, checkMods:Bool = true):String
	{
		key = getPath(key, parentFolder, checkMods);
		return FunkinAssets.exists(key) ? FunkinAssets.getContent(key) : '';
	}

	public static inline function fileExists(key:String, ?parentFolder:String, checkMods:Bool = true):Bool
	{
		return FunkinAssets.exists(getPath(key, parentFolder, checkMods));
	}

	public static inline function getMultiAtlas(keys:Array<String>, ?parentFolder:String, allowGPU:Bool = true, checkMods:Bool = true):FlxAtlasFrames
	{
		if (keys.length == 0) return null;

		final firstKey:Null<String> = keys.shift()?.trim();
		if (firstKey == null) return null;

		var frames = getAtlasFrames(firstKey, parentFolder, allowGPU, checkMods);

		if (keys.length != 0)
		{
			final originalCollection = frames;
			frames = new FlxAtlasFrames(originalCollection.parent);
			frames.addAtlas(originalCollection, true);
			for (i in keys)
			{
				final newFrames = getAtlasFrames(i.trim(), parentFolder, allowGPU, checkMods);
				if (newFrames != null)
				{
					frames.addAtlas(newFrames, false);
				}
			}
		}
		return frames;
	}

	public static inline function getAtlasFrames(key:String, ?parentFolder:String, allowGPU:Bool = true, checkMods:Bool = true):FlxAtlasFrames
	{
		final directPath = getPath('images/$key.png', parentFolder, checkMods).withoutExtension();

		final tempFrames = tempAtlasFramesCache.get(directPath);
		if (tempFrames != null)
		{
			return tempFrames;
		}

		final xmlPath = getPath('images/$key.xml', parentFolder, checkMods);
		final txtPath = getPath('images/$key.txt', parentFolder, checkMods);
		final jsonPath = getPath('images/$key.json', parentFolder, checkMods);

		final graphic = image(key, parentFolder, allowGPU, checkMods);

		if (FunkinAssets.exists(xmlPath))
		{
			@:nullSafety(Off)
			{
				final frames = FlxAtlasFrames.fromSparrow(graphic, FunkinAssets.getContent(xmlPath));
				if (frames != null) tempAtlasFramesCache.set(directPath, frames);
				return frames;
			}
		}

		if (FunkinAssets.exists(jsonPath))
		{
			@:nullSafety(Off)
			{
				final frames = FlxAtlasFrames.fromAseprite(graphic, FunkinAssets.getContent(jsonPath));
				if (frames != null) tempAtlasFramesCache.set(directPath, frames);
				return frames;
			}
		}

		@:nullSafety(Off)
		{
			final frames = FlxAtlasFrames.fromSpriteSheetPacker(graphic, FunkinAssets.exists(txtPath) ? FunkinAssets.getContent(txtPath) : null);
			if (frames != null) tempAtlasFramesCache.set(directPath, frames);
			return frames;
		}
	}

	public static inline function getSparrowAtlas(key:String, ?parentFolder:String, ?allowGPU:Bool = true, checkMods:Bool = true):FlxAtlasFrames
	{
		final directPath = getPath('images/$key.png', parentFolder, checkMods).withoutExtension();
		final tempFrames = tempAtlasFramesCache.get(directPath);
		if (tempFrames != null)
		{
			return tempFrames;
		}

		final xmlPath = getPath('images/$key.xml', parentFolder, checkMods);
		@:nullSafety(Off)
		{
			final frames = FlxAtlasFrames.fromSparrow(image(key, parentFolder, allowGPU, checkMods), FunkinAssets.exists(xmlPath) ? FunkinAssets.getContent(xmlPath) : null);
			if (frames != null) tempAtlasFramesCache.set(directPath, frames);
			return frames;
		}
	}

	public static inline function getPackerAtlas(key:String, ?parentFolder:String, ?allowGPU:Bool = true, checkMods:Bool = true)
	{
		final directPath = getPath('images/$key.png', parentFolder, checkMods).withoutExtension();
		final tempFrames = tempAtlasFramesCache.get(directPath);
		if (tempFrames != null)
		{
			return tempFrames;
		}

		final txtPath = getPath('images/$key.txt', parentFolder, checkMods);
		@:nullSafety(Off)
		{
			final frames = FlxAtlasFrames.fromSpriteSheetPacker(image(key, parentFolder, allowGPU, checkMods), FunkinAssets.exists(txtPath) ? FunkinAssets.getContent(txtPath) : null);
			if (frames != null) tempAtlasFramesCache.set(directPath, frames);
			return frames;
		}
	}

	public static inline function sanitize(path:String):String
	{
		return ~/[^- a-zA-Z0-9..\/]+\//g.replace(path, '').replace(' ', '-').trim().toLowerCase();
	}

	public static function listAllFilesInDirectory(directory:String, checkMods:Bool = true)
	{
		var folders:Array<String> = [];
		var files:Array<String> = [];

		if (FunkinAssets.exists(getCorePath(directory))) folders.push(getCorePath(directory));

		#if MODS_ALLOWED
		if (checkMods)
		{
			for (mod in Mods.globalMods)
			{
				final folder = mods('$mod/$directory');
				if (FileSystem.exists(folder) && !folders.contains(folder)) folders.push(folder);
			}

			final folder = mods(directory);
			if (FileSystem.exists(folder) && !folders.contains(folder)) folders.push(folder);

			if (Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
			{
				final folder = mods('${Mods.currentModDirectory}/$directory');
				if (FileSystem.exists(folder) && !folders.contains(folder)) folders.push(folder);
			}
		}
		#end

		for (folder in folders)
		{
			for (file in FunkinAssets.readDirectory(folder))
			{
				final path = Path.join([folder, file]);
				if (!files.contains(path)) files.push(path);
			}
		}

		return files;
	}

	#if MODS_ALLOWED
	public static inline function mods(key:String = ''):String
	{
		return MODS_DIRECTORY + '/' + key;
	}

	public static function modFolders(key:String):String
	{
		if (Mods.currentModDirectory != null && Mods.currentModDirectory.length > 0)
		{
			final fileToCheck:String = mods(Mods.currentModDirectory + '/' + key);
			if (FileSystem.exists(fileToCheck))
			{
				return fileToCheck;
			}
		}

		for (mod in Mods.globalMods)
		{
			final fileToCheck:String = mods(mod + '/' + key);
			if (FileSystem.exists(fileToCheck)) return fileToCheck;
		}
		return mods(key);
	}
	#end
}
