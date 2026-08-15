package funkin.mobile.ui;

import lime.app.Application;
import openfl.Lib;

#if android
import extension.android.AndroidNative;
#end

class Fullscreen
{
	public static var isFullscreen(get, set):Bool;

	private static function get_isFullscreen():Bool
	{
		#if android
		return true;
		#else
		return Application.current.window.fullscreen;
		#end
	}

	private static function set_isFullscreen(value:Bool):Bool
	{
		#if android
		if (value)
			enableAndroidImmersiveMode();
		return true;
		#else
		Application.current.window.fullscreen = value;
		return value;
		#end
	}

	public static function init():Void
	{
		#if android
		enableAndroidImmersiveMode();
		#end
	}

	public static function enableAndroidImmersiveMode():Void
	{
		#if android
		try
		{
			AndroidNative.setSystemUiVisibility(
				AndroidNative.SYSTEM_UI_FLAG_LAYOUT_STABLE
				| AndroidNative.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
				| AndroidNative.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
				| AndroidNative.SYSTEM_UI_FLAG_HIDE_NAVIGATION
				| AndroidNative.SYSTEM_UI_FLAG_FULLSCREEN
				| AndroidNative.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
			);
		}
		catch (e:Dynamic) {}
		#end
	}

	public static function toggle():Void
	{
		isFullscreen = !isFullscreen;
	}
}
