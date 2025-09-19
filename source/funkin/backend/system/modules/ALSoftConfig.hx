package funkin.backend.system.modules;

import lime.system.JNI;
import lime.system.System;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.io.Path;

#if sys
import sys.io.File;
import sys.FileSystem;
#end

/*
 * A class that simply points OpenALSoft to a custom configuration file when
 * the game starts up.
 *
 * The config overrides a few global OpenALSoft settings with the aim of
 * improving audio quality on desktop targets.
 */
#if (!macro && !web)
@:build(funkin.backend.system.modules.ALSoftConfig.setupConfig())
#end
class ALSoftConfig
{
	#if (desktop || android)
	#if android
	static final OPENAL_CONFIG:String = '';
	#end

	public static function init():Void
	{
		var origin:String = #if mobile System.applicationStorageDirectory #elseif hl Sys.getCwd() #else Sys.programPath() #end;

		var configPath:String = Path.directory(Path.withoutExtension(origin));
		#if windows
		configPath += "/plugins/alsoft.ini";
		#elseif mac
		configPath = Path.directory(configPath) + "/Resources/plugins/alsoft.conf";
		#elseif android
		configPath = origin + 'openal/alsoft.conf';
		FileSystem.createDirectory(Path.directory(configPath));
		File.saveContent(configPath, OPENAL_CONFIG);
		JNI.createStaticMethod('org/libsdl/app/SDLActivity', 'nativeSetenv', '(Ljava/lang/String;Ljava/lang/String;)V')("ALSOFT_CONF", configPath);
		#else
		configPath += "/plugins/alsoft.conf";
		#end

		#if !android
		Sys.putEnv("ALSOFT_CONF", configPath);
		#end
	}
	#end

	#if macro
	public static function setupConfig()
	{
		var fields = Context.getBuildFields();
		var pos = Context.currentPos();

		if (!FileSystem.exists('building/alsoft.txt')) return fields;

		var newFields = fields.copy();
		for (i => field in fields)
		{
			if (field.name == 'OPENAL_CONFIG')
			{
				newFields[i] = {
					name: 'OPENAL_CONFIG',
					access: [APrivate, AStatic, AFinal],
					kind: FVar(macro :String, macro $v{File.getContent('building/alsoft.txt')}),
					pos: pos,
				};
			}
		}

		return newFields;
	}
	#end
}
