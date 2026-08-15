package funkin.mobile.backend;

import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

#if android
import android.content.Context;
import android.os.Environment;
import android.os.Build;
import android.Permissions;
#end

class StorageUtil
{
    public static final rootDir:String = "NightmareVision";

    public static function getStorageDirectory():String
    {
        #if android
        var path:String = Environment.getExternalStorageDirectory() + "/" + rootDir + "/";
        return path;
        #else
        return "./";
        #end
    }

    public static function initStorage():Void
    {
        #if android
        requestPermissions();
        #end

        var path:String = getStorageDirectory();
        if (!FileSystem.exists(path))
            FileSystem.createDirectory(path);

        var modsPath:String = Path.join([path, "content"]);
        if (!FileSystem.exists(modsPath))
            FileSystem.createDirectory(modsPath);
    }

    #if android
    public static function requestPermissions():Void
    {
        if (Build.VERSION.SDK_INT >= 30)
        {
            if (!Environment.isExternalStorageManager())
            {
                Permissions.requestPermission("android.permission.MANAGE_EXTERNAL_STORAGE");
            }
        }
        else
        {
            if (!Permissions.getGrantedPermissions().contains("android.permission.READ_EXTERNAL_STORAGE"))
            {
                Permissions.requestPermission("android.permission.READ_EXTERNAL_STORAGE");
            }
            if (!Permissions.getGrantedPermissions().contains("android.permission.WRITE_EXTERNAL_STORAGE"))
            {
                Permissions.requestPermission("android.permission.WRITE_EXTERNAL_STORAGE");
            }
        }
    }
    #end

    public static function saveContent(fileRelativePath:String, data:String):Void
    {
        var fullPath:String = Path.join([getStorageDirectory(), fileRelativePath]);
        var directory:String = Path.directory(fullPath);

        if (!FileSystem.exists(directory))
            FileSystem.createDirectory(directory);

        File.saveContent(fullPath, data);
    }

    public static function getContent(fileRelativePath:String):Null<String>
    {
        var fullPath:String = Path.join([getStorageDirectory(), fileRelativePath]);

        if (FileSystem.exists(fullPath))
            return File.getContent(fullPath);

        return null;
    }
}
