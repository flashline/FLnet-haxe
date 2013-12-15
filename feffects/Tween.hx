package feffects;
 
#if haxe3
	import haxe.ds.GenericStack in FastList;
#else
	import haxe.FastList;
#end

#if nme
	import nme.Lib;
	import nme.events.Event;
#elseif flash9
	import flash.Lib;
	import flash.events.Event;
#elseif ( js ||flash8 )
	import haxe.Timer;
#end

typedef Easing = Float->Float->Float->Float->Float;

/**
* Class that allows tweening properties of an object.<br/>
* Version 3.0.0
* Compatible haxe 3 - flash/js/NME
* Usage :<br/>
* import feffects.easing.Elastic;<br/>
* 
* using feffects.Tween.TweenObject;
* ...<br/>
* var mySprite = new Sprite();
* mySprite.graphics.beginFill( 0 );
* mySprite.graphics.drawCircle( 0, 0, 20 );
* mySprite.graphics.endFill();
* 
* Lib.current.addChild( mySprite );
* 
* function foo() {
* 	trace( "end" );
* }
* 
* mySprite.tween( { x : 100, y : 200 }, 1000 ).onFinish( foo ).start();
* 
* OR
* 
* mySprite.tween( { x : 100, y : 200 }, 1000, foo, true );
* 
* @author : M.Romecki
* 
*/

class TweenObject {
	
	public var tweens		(default, null)			: FastList<TweenProperty>;
	public var target		(default, null)			: Dynamic;
	public var properties	(default, null)			: Dynamic;
	public var duration		(default, null)			: Int;
	public var easing		(default, null)			: Easing;
	public var isPlaying	(get_isPlaying, null)	: Bool;
	function get_isPlaying() {
		for ( tween in tweens ) {
			if ( tween.isPlaying )
				return true;
		}
		return false;
	}
	
	var __onFinish			: Void->Void;
	var _nbFinished			: Int;
	var _nbTotal			: Int;
	
	public static function tween( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, autoStart = false, ?onFinish : Void->Void ) {
		return new TweenObject( target, properties, duration, easing, autoStart, onFinish );
	}
	
	public function new( target : Dynamic, properties : Dynamic, duration : Int, ?easing : Easing, autoStart = false, ?onFinish : Void->Void ) {
		this.target			= target;
		this.properties		= properties;
		this.duration		= duration;
		this.easing 		= easing;
				
		this.onFinish( onFinish );
		
		tweens		= new FastList<TweenProperty>();
		_nbTotal	= 0;
		for ( key in Reflect.fields( properties ) ) {
			var tp = new TweenProperty( target, key, Reflect.field( properties, key ), duration, easing, false );
			tp.onFinish( _onFinish );
			tweens.add( tp );
			_nbTotal++;
		}
		
		if ( autoStart )
			start();
	}
	
	public function setEasing( easing : Easing ) : TweenObject {
		for ( tweenProp in tweens )
			tweenProp.setEasing( easing );
		return this;
	}
	
	public function start() : FastList<TweenProperty> {
		_nbFinished	= 0;
		for ( tweenProp in tweens )
			tweenProp.start();				
		return tweens;
	}
	
	public function pause() {
		for ( tweenProp in tweens )
			tweenProp.pause();
	}
	
	public function resume() {
		for ( tweenProp in tweens )
			tweenProp.resume();
	}
	
	public function seek( n : Int ) : TweenObject {
		for ( tweenProp in tweens )
			tweenProp.seek( n );
		return this;
	}
	
	public function reverse(){
		for ( tweenProp in tweens )
			tweenProp.reverse();
	}
	
	public function stop( ?finish : Bool ) {
		for ( tweenProp in tweens )
			tweenProp.stop( finish );
	}
	
	public function onFinish( f : Void->Void ) : TweenObject {
		__onFinish 	= f != null ? f : function(){};
		return this;
	}
		
	function _onFinish() {
		_nbFinished++;
		if ( _nbFinished == _nbTotal )
			__onFinish();
	}
}

class TweenProperty extends Tween{
	
	public var  target		(default, null)	: Dynamic;
	public var property		(default, null)	: String;
	
	#if ( flash9 || nme )
		var _doTarget		: flash.display.DisplayObject;
	#end
	
	public function new( target : Dynamic, prop : String, value : Float, duration : Int, ?easing : Easing, autostart = false, ?onFinish : Void->Void ) {
		this.target			= target;
		this.property		= prop;
			
		#if ( flash9 || nme )
			if ( Std.is( target, flash.display.DisplayObject ) ) {
				_doTarget = target;
				super( Reflect.getProperty( target, property ), value, duration, easing, autostart, switch( prop ) {
					case 'x'			: __onUpdateX;
					case 'y'			: __onUpdateY;
					case 'width'		: __onUpdateWidth;
					case 'height'		: __onUpdateHeight;
					case 'alpha'		: __onUpdateAlpha;
					case 'rotation'		: __onUpdateRotation;
					case 'scaleX'		: __onUpdateScaleX;
					case 'scaleY'		: __onUpdateScaleY;
					#if flash10
						case 'z'			: __onUpdateZ;
						case 'scaleZ'		: __onUpdateScaleZ;
						case 'rotationX'	: __onUpdateRotationX;
						case 'rotationY'	: __onUpdateRotationY;
						case 'rotationZ'	: __onUpdateRotationZ;
					#end
					default: __onUpdate;
				}, onFinish );
			}else
				super( Reflect.getProperty( target, property ), value, duration, easing, autostart, __onUpdate, onFinish );
		#else
			super( Reflect.getProperty( target, property ), value, duration, easing, autostart, __onUpdate, onFinish );
		#end
	}
	
	function __onUpdate( n : Float ) {
		Reflect.setProperty( target, property, n );
	}
	
	#if ( flash9 || nme )
		function __onUpdateX( n : Float ) {	_doTarget.x = n; }
		function __onUpdateY( n : Float ) {	_doTarget.y = n; }
		function __onUpdateWidth( n : Float ) { _doTarget.width = n; }
		function __onUpdateHeight( n : Float ) { _doTarget.height = n; }
		function __onUpdateAlpha( n : Float ) { _doTarget.alpha = n; }
		function __onUpdateRotation( n : Float ) { _doTarget.rotation = n; }
		function __onUpdateScaleX( n : Float ) { _doTarget.scaleX = n; }
		function __onUpdateScaleY( n : Float ) { _doTarget.scaleY = n; }
		#if flash10
			function __onUpdateZ( n : Float ) {	_doTarget.z = n; }
			function __onUpdateScaleZ( n : Float ) { _doTarget.scaleZ = n; }
			function __onUpdateRotationX( n : Float ) { _doTarget.rotationX = n; }
			function __onUpdateRotationY( n : Float ) { _doTarget.rotationY = n; }
			function __onUpdateRotationZ( n : Float ) { _doTarget.rotationZ = n; }
		#end
	#end
}

/**
* Class that allows tweening numerical values of an object.<br/>
* Version 3.0.0
* Compatible haxe 3 - flash/js/NME
* Usage :<br/>
* import feffects.Tween;<br/>
* import feffects.easing.Elastic;<br/>
* ...<br/>
* function foo ( n : Float ){
* 	mySprite.x = n;
* }
* var t = new Tween( 0, 100, 2000 );						// create a new tween<br/>
* t.onUpdate( foo );
* t.start();												// start the tween<br/>
* 
* You can add :
* * 
* t.setEasing( Elastic.easeIn );							// set the easing function used to compute values<br/>
* t.seek( 1000 );											// go to the specified position (in ms)</br>
* t.pause();<br/>
* t.resume();<br/>
* t.reverse();												// reverse the tween from the current position</br>
* t.stop();
* 
* OR combinated sythax :
* 
* new Tween( 0, 100, 2000 ).setEasing( Elastic.easeIn ).seek( 1000 ).onUpdate( foo ).onFinish( foo2 ).start();
* 
* OR fastest one : 
*
* new Tween( 0, 100, 2000, Elastic.easeIn, foo, foo2, true ).seek( 1000 );
* 
* @author : M.Romecki
* 
*/

class Tween {
	static var _aTweens	= new FastList<Tween>();
	static var _aPaused	= new FastList<Tween>();
	
	#if ( !nme && js || flash8 )
		static var _timer	: haxe.Timer;
		public static var INTERVAL		= 10;
	#end
	
	public static var DEFAULT_EASING	= easingEquation;
			
	public var duration		(default, null) : Int;
	public var position		(default, null) : Int;
	public var isReversed	(default, null) : Bool;
	public var isPlaying	(default, null) : Bool;
	public var isPaused		(default, null) : Bool;
	
	static var _isTweening	: Bool;
			
	var _initVal		: Float;
	var _endVal			: Float;
	var _startTime		: Float;
	var _pauseTime		: Float;
	var _offsetTime		: Float;
	var _reverseTime	: Float;
	
	var _easingF		: Easing;
	var _onUpdate		: Float->Void;
	var _onFinish		: Void->Void;
	
	static function addTween( tween : Tween ) : Void {
		if ( !_isTweening )
		{
			#if ( !nme && js || flash8 )
				_timer 		= new haxe.Timer( INTERVAL ) ;
				_timer.run 	= cb_tick;
			#else
				Lib.current.stage.addEventListener( Event.ENTER_FRAME, cb_tick );
			#end
			_isTweening	= true;
			cb_tick();
		}
		
		_aTweens.add( tween );
	}

	static function removeActiveTween( tween : Tween ) : Void {
		_aTweens.remove( tween );
		checkActiveTweens();
	}
	
	static function removePausedTween( tween : Tween ) : Void {
		_aPaused.remove( tween );
		checkActiveTweens();
	}
	
	static function checkActiveTweens() {
		if ( _aTweens.isEmpty() ) {
			#if ( !nme && js || flash8 )
				if ( _timer != null ) {
					_timer.stop() ;
					_timer	= null ;
				}
			#else
				Lib.current.stage.removeEventListener( Event.ENTER_FRAME, cb_tick );
			#end
			_isTweening = false;
		}
	}
	
	public static function getActiveTweens() {
		return _aTweens;
	}
	
	public static function getPausedTweens() {
		return _aPaused;
	}
	
	static function setTweenPaused( tween : Tween ) : Void {
		_aPaused.add( tween );
		_aTweens.remove( tween );
		
		checkActiveTweens();
	}
	
	static function setTweenActive( tween : Tween ) : Void {
		_aTweens.add( tween );
		_aPaused.remove( tween );
		
		if ( !_isTweening ) {
			#if ( !nme && js || flash8 )
				_timer 		= new haxe.Timer( INTERVAL ) ;
				_timer.run 	= cb_tick;
			#else
				Lib.current.stage.addEventListener( Event.ENTER_FRAME, cb_tick );
			#end
			_isTweening	= true;
			cb_tick();
		}
	}

	static function cb_tick( #if ( nme || flash9 ) ?_ #end ) : Void	{
		for ( i in _aTweens )
			i.doInterval();
	}
		
	/**
	* Create a tween from the [init] value, to the [end] value, while [dur] (in ms)<br />
	* There is a default easing equation.
	*/
	
	public function new( init : Float, end : Float, dur : Int, ?easing : Easing, autoStart = false, ?onUpdate : Float->Void, ?onFinish : Void->Void ) {
				
		_initVal		= init;
		_endVal			= end;
		duration		= dur;
				
		_offsetTime 	= 0;
		position		= 0;
		isPlaying		= false;
		isPaused		= false;
		isReversed		= false;
		
		this.onUpdate( onUpdate ); 
		this.onFinish( onFinish );
		setEasing( easing );		
			
		if ( autoStart )
			start();
	}
	
	public function start( position = 0 ) : Void {
		_startTime		= getStamp();
		_reverseTime	= getStamp();
		
		seek( position );
		
		if ( isPaused )
			removePausedTween( this );
		
		isPlaying 	= true;
		isPaused	= false;
		
		addTween( this );
		
		if ( duration == 0 || position >= duration )
			stop( true );
	}
	
	public function pause() : Void {
		if ( !isPlaying || isPaused )
			return;
		_pauseTime	= getStamp();
		
		isPlaying	= false;
		isPaused	= true;

		setTweenPaused( this );
	}
	
	public function resume() : Void {
		if ( !isPaused || isPlaying )
			return;
		
		_startTime		+= getStamp() - _pauseTime;
		_reverseTime 	+= getStamp() - _pauseTime;
				
		isPlaying	= true;
		isPaused	= false;
		
		setTweenActive( this );
	}
	
	/**
	* Go to the specified position [ms] (in ms) 
	*/
	public function seek( ms : Int ) : Tween {
		_offsetTime = ms < duration ? ms : duration;
		return this;
	}
		
	/**
	* Reverse the tweeen from the current position 
	*/
	public function reverse() {
		if ( !isPlaying )
			return;
		
		isReversed = !isReversed;
		if ( !isReversed )
			_startTime += ( getStamp() - _reverseTime ) * 2;

		_reverseTime = getStamp();
	}
	
	public function stop( doFinish = false ) : Void {
		if( isPaused )
			removePausedTween( this );
		else
			if( isPlaying )
				removeActiveTween( this );
				
		isPaused	= false;
		isPlaying	= false;
		
		if ( doFinish )
			finish();	
	}
	
	function finish() : Void {
		_onUpdate( isReversed ? _initVal : _endVal );
		_onFinish();
	}

	
	public function onUpdate( f : Float->Void ) {
		_onUpdate	= f != null ? f : function(_){};
		return this;
	}
	
	public function onFinish( f : Void->Void ) {
		_onFinish	= f != null ? f : function(){};
		return this;
	}
	
	/**
	* Set the [easingFunc] equation to use for tweening
	*/
	public function setEasing( f : Easing ) : Tween {
		_easingF = f != null ? f : easingEquation;
		return this;
	}
	
	function doInterval() : Void {
		var stamp = getStamp();
				
		var curTime = 0;
		untyped{
			if ( isReversed )
				curTime = ( _reverseTime * 2 ) - stamp - _startTime + _offsetTime;
			else
				curTime = stamp - _startTime + _offsetTime;
		}
		
		var curVal = getCurVal( curTime );
		if ( curTime >= duration || curTime < 0 )
			stop( true );
		else {
			_onUpdate( curVal );
		}
		position = curTime;		
	}
	
	inline function getCurVal( curTime : Int ) : Float {
		return _easingF( curTime, _initVal, _endVal - _initVal, duration );
	}
	
	inline function getStamp() {
		#if sys
			return Sys.time() * 1000;
		#elseif js
			return Date.now().getTime();
		#elseif flash
			return flash.Lib.getTimer();
		#end
	}

	static inline function easingEquation( t : Float, b : Float, c : Float, d : Float ) : Float {
		return c / 2 * ( Math.sin( Math.PI * ( t / d - 0.5 ) ) + 1 ) + b;
	}
}