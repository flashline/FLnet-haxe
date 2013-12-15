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
package net.flash_line._api.motion;
import net.flash_line.event.EventSource ;
import net.flash_line.event.StandardEvent;
import net.flash_line.util.Common;
//
import feffects.Tween;
import feffects.easing.Bounce;
import feffects.easing.Cubic;
import feffects.easing.Quad;
import feffects.easing.Linear;
/**
 * motion fx package.
 * 
 * Manage tween
 */
class BTween extends Tween {
	public var onLoop (default,null):Dynamic;
	public var listenerParam (default,null) :Dynamic; 
	public var asset (default,null) :Dynamic; 
	public function new (s : Float, e : Float, d: Float, onLoop : Dynamic, ?asset: Dynamic, ?listenerParam : Dynamic ) {
		super(s, e, Math.round(d*1000), Quad.easeInOut, false,_onLoop,_onEnd);
		this.onLoop = onLoop;
		this.listenerParam = listenerParam; 
		this.asset = asset; 
		start();
		
	}
	//
	public function clear () {
		onLoop = null;
		listenerParam = null ;
		asset = null;
		
	}
	function _onEnd() {
		var evtObj:StandardEvent = new StandardEvent(this,"end");
		evtObj.value = -1;
		evtObj.asset = asset;
		evtObj.data = listenerParam;
		onLoop(evtObj);
		
	}
	function _onLoop(e) {
		var evtObj:StandardEvent = new StandardEvent(this,"loop");
		evtObj.value = e;
		evtObj.asset = asset;
		evtObj.data = listenerParam;
		onLoop(evtObj);
	}
	
	
}