package funkin.ui.android;

#if android
import extension.android.AndroidNative;
#end

class AndroidKeyboard
{
	public static function show():Void
	{
		#if android
		AndroidNative.showKeyboard();
		#end
	}

	public static function hide():Void
	{
		#if android
		AndroidNative.hideKeyboard();
		#end
	}

	public static function isVisible():Bool
	{
		#if android
		return AndroidNative.isKeyboardVisible();
		#else
		return false;
		#end
	}
}
