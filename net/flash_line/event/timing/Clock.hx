/**
 * Copyright (c) jm Delettre.
 * 
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 * 
 *   - Redistributions of source code must retain the above copyright
 *     notice, this list of conditions and the following disclaimer.
 *   - Redistributions in binary form must reproduce the above copyright
 *     notice, this list of conditions and the following disclaimer in the
 *     documentation and/or other materials provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */
package net.flash_line.event.timing;
import haxe.Timer;
import net.flash_line.event.EventSource;
import net.flash_line.event.StandardEvent;
/**
 * 
 */
class Clock extends Timer  {
	var listener:Dynamic;
	var _idle:Bool;
	public var isEnabled(get, null):Bool;
	public var top(default,null):EventSource ;
	/**
	* Constructor
	* <br/><b>f</b> callback func 
	* <br/><b>per</b> period in sec.
	*/
    public function new ( ?f:Dynamic,?per :Float=0.04){
		super(Math.round(per * 1000));
		top = new EventSource();
		run = clockRun ;
		listener = f;
		_idle = false;
	}
	public function pause () {
		_idle=true;
	}
	public function restart () {
		_idle=false;
	}
	public function remove () : Dynamic {
		super.stop();
		listener = null;
		run = null;
		top = null;
		return null;
	}
	
	function clockRun () {
		if (!_idle) {
			if (listener != null) listener(this) ;
			top.dispatch(new StandardEvent(this));
		}
	}
	
	
	/**
	 * 
	 * <br/><b></b>	
	 */
	/**
	 * getter/setter
	 */
	function get_isEnabled ():Bool {
		return !_idle;
	}
	/**
	 * public
	 */	
	/**
	 * private
	 */
	
}