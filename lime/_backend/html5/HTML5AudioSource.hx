package lime._backend.html5;


import lime.media.AudioSource;
import lime.math.Vector4;

@:access(lime.media.AudioBuffer)


class HTML5AudioSource {
	
	
	private var completed:Bool;
	private var gain:Float;
	private var id:Int;
	private var length:Int;
	private var loops:Int;
	private var parent:AudioSource;
	private var playing:Bool;
	private var position:Vector4;
	
	
	public function new (parent:AudioSource) {
		
		this.parent = parent;
		
		id = -1;
		gain = 1;
		position = new Vector4 ();
		
	}
	
	
	public function dispose ():Void {
		
		
		
	}
	
	
	public function init ():Void {
		
		
		
	}
	
	
	public function play (?spriteKey:String):Void {
		
		#if howlerjs
		
		if (playing || parent.buffer == null) {
			
			return;
			
		}
		
		playing = true;
		
		var time = getCurrentTime ();
		
		completed = false;
		
		var cacheVolume = untyped parent.buffer.__srcHowl._volume;
		untyped parent.buffer.__srcHowl._volume = parent.gain;
		
		if (spriteKey != null) {
			id = parent.buffer.__srcHowl.play (spriteKey);
		} else {
			id = parent.buffer.__srcHowl.play ();

			// these values are configured per-sprite in soundsprites.
			// setting them in here breaks HTML5 Howler soundsprites, like those
			// used by IE 11, or other browsers that don't support WebAudio API.
			untyped parent.buffer.__srcHowl._volume = cacheVolume;
			//setGain (parent.gain);
			setPosition (parent.position);
			setCurrentTime (time);
		}
		
		parent.buffer.__srcHowl.on ("end", howl_onEnd, id);
		#end
		
	}
	
	
	public function pause ():Void {
		
		#if howlerjs
		
		playing = false;
		if (parent.buffer != null) parent.buffer.__srcHowl.pause (id);
		
		#end
		
	}
	
	
	public function stop ():Void {
		
		#if howlerjs
		
		playing = false;
		if (parent.buffer != null) parent.buffer.__srcHowl.stop (id);
		
		#end
		
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function howl_onEnd () {
		
		#if howlerjs
		
		playing = false;
		
		if (loops > 0) {
			
			loops--;
			stop ();
			//currentTime = 0;
			play ();
			return;
			
		} else {
			
			parent.buffer.__srcHowl.stop (id);
			
		}
		
		completed = true;
		parent.onComplete.dispatch ();
		
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	public function getCurrentTime ():Int {
		
		if (id == -1) {
			
			return 0;
			
		}
		
		#if howlerjs
		
		if (completed) {
			
			return getLength ();
			
		} else if (parent.buffer != null) {
			
			var time = Std.int (parent.buffer.__srcHowl.seek (id) * 1000) - parent.offset;
			if (time < 0) return 0;
			return time;
			
		}
		
		#end
		
		return 0;
		
	}
	
	
	public function setCurrentTime (value:Int):Int {
		
		#if howlerjs
		
		if (parent.buffer != null) {
			
			//if (playing) buffer.__srcHowl.play (id);
			var pos = (value + parent.offset) / 1000;
			if (pos < 0) pos = 0;
			parent.buffer.__srcHowl.seek (pos, id);
			
		}
		
		#end
		
		return value;
		
	}
	
	
	public function getGain ():Float {
		
		return gain;
		
	}
	
	
	public function setGain (value:Float):Float {
		
		#if howlerjs
		
		if (parent.buffer != null) {
			
			parent.buffer.__srcHowl.volume (value, id);
			
		}
		
		#end
		
		return gain = value;
		
	}
	
	
	public function getLength ():Int {
		
		if (length != 0) {
			
			return length;
			
		}
		
		#if howlerjs
		
		if (parent.buffer != null) {
			
			return Std.int (parent.buffer.__srcHowl.duration () * 1000);
			
		}
		
		#end
		
		return 0;
		
	}
	
	
	public function setLength (value:Int):Int {
		
		return length = value;
		
	}
	
	
	public function getLoops ():Int {
		
		return loops;
		
	}
	
	
	public function setLoops (value:Int):Int {
		
		return loops = value;
		
	}
	
	
	public function getPosition ():Vector4 {
		
		#if howlerjs
		
		// TODO: Use 3D audio plugin
		
		#end
		
		return position;
		
	}
	
	
	public function setPosition (value:Vector4):Vector4 {
		
		position.x = value.x;
		position.y = value.y;
		position.z = value.z;
		position.w = value.w;
		
		#if howlerjs
		
		// TODO: Use 3D audio plugin
		
		#end
		
		return position;
		
	}
	
	
}