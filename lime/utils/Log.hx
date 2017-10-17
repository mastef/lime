package lime.utils;


import haxe.PosInfos;

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Log {
	
	
	public static var level:LogLevel;
	public static var throwErrors:Bool = true;
	
	
	public static function debug (message:String, ?obj:Dynamic = null, ?info:PosInfos):Void {
		
		if (level >= LogLevel.DEBUG) {
			
			#if js
				if(obj != null) {
					untyped __js__("console").debug ("[" + info.className + "] " + message, obj, info);
				} else {
					untyped __js__("console").debug ("[" + info.className + "] " + message, info);
				}
			#else
				println ("[" + info.className + "] " + message);
			#end
			
		}
		
	}
	
	
	public static function error (message:String, ?info:PosInfos):Void {
		
		if (level >= LogLevel.ERROR) {
			
			var message = "[" + info.className + "] ERROR: " + message;
			
			if (throwErrors) {

				#if js
					untyped __js__("console").error (message, info);
				#end
				throw message;
				
			} else {
				
				#if js
					untyped __js__("console").error (message);
				#else
					println (message);
				#end
				
			}
			
		}
		
	}
	
	
	public static function info (message:String, ?obj:Dynamic, ?info:PosInfos):Void {
		
		if (level >= LogLevel.INFO) {
			
			#if js
				if(obj != null) {
					untyped __js__("console").info ("[" + info.className + "] " + message, obj, info);
				} else {
					untyped __js__("console").info ("[" + info.className + "] " + message, info);
				}
			#else
				println ("[" + info.className + "] " + message);
			#end
			
		}
		
	}
	
	
	public static inline function print (message:String):Void {
		
		#if sys
		Sys.print (message);
		#elseif flash
		untyped __global__["trace"] (message);
		#elseif js
		untyped __js__("console").log (message);
		#else
		trace (message);
		#end
		
	}
	
	
	public static inline function println (message:String):Void {
		
		#if sys
		Sys.println (message);
		#elseif flash
		untyped __global__["trace"] (message);
		#elseif js
		untyped __js__("console").log (message);
		#else
		trace (message);
		#end
		
	}
	
	
	public static function verbose (message:String, ?info:PosInfos):Void {
		
		if (level >= LogLevel.VERBOSE) {
			
			println ("[" + info.className + "] " + message);
			
		}
		
	}
	
	
	public static function warn (message:String, ?obj:Dynamic = null, ?info:PosInfos):Void {
		
		if (level >= LogLevel.WARN) {
			
			#if js
				if(obj != null) {
					untyped __js__("console").warn ("[" + info.className + "] WARNING: " + message, obj, info);
				} else {
					untyped __js__("console").warn ("[" + info.className + "] WARNING: " + message, info);
				}
			#else
				println ("[" + info.className + "] WARNING: " + message);
			#end
			
		}
		
	}
	
	
	private static function __init__ ():Void {
		
		#if no_traces
		level = NONE;
		#elseif verbose
		level = VERBOSE;
		#else
		#if sys
		var args = Sys.args ();
		if (args.indexOf ("-v") > -1 || args.indexOf ("-verbose") > -1) {
			level = VERBOSE;
		} else
		#end
		{
			#if debug
			level = DEBUG;
			#else
			level = INFO;
			#end
		}
		#end
		
		#if js
		if (untyped __js__("typeof console") == "undefined") {
			untyped __js__("console = {}");
		}
		if (untyped __js__("console").log == null) {
			untyped __js__("console").log = function () {};
		}
		#end
		
		#if (lime >= "4.0.0")
		throwErrors = true;
		#end
		
	}
	
	
}


@:enum abstract LogLevel(Int) from Int to Int from UInt to UInt {
	
	var NONE = 0;
	var ERROR = 1;
	var WARN = 2;
	var INFO = 3;
	var DEBUG = 4;
	var VERBOSE = 5;
	
	@:op(A > B) private static inline function gt (a:LogLevel, b:LogLevel):Bool { return (a:Int) > (b:Int); }
	@:op(A >= B) private static inline function gte (a:LogLevel, b:LogLevel):Bool { return (a:Int) >= (b:Int); }
	@:op(A < B) private static inline function lt (a:LogLevel, b:LogLevel):Bool { return (a:Int) < (b:Int); }
	@:op(A <= B) private static inline function lte (a:LogLevel, b:LogLevel):Bool { return (a:Int) <= (b:Int); }
	
}