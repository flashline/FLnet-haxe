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
package net.flash_line.event ;
/**
 * Events manager package
 * 
 * Records/removes listeners and send events. 
 */
class EventSource  {
	private var _listenerArray:Array<Dynamic>;
	/**
	 * Constructor
	 */
    public function new() { _listenerArray = []; }
	/**
	 * Adds an event listener.
	 * <br/>listener:</b>		Listener method
	 * <br/><b>data:</b> Parameters -{}- sent from the bind() caller, to the listener
	 * <br/>Example: myElem.click.bind(onClick);
	 */
	public function bind (listener:Dynamic, ?data:Dynamic) : Bool { 		
		_listenerArray.push( { listener:listener, data:data } ) ;
		return true;  // for compatibility
	}
	/**
	 * Removes an event listener.
	 * <br/><b>listener:</b>		listener method
	 * <br/><b>return true</b> if action was finishing correctly.
	 * <br/>Example: if (!myElem.click.unbind(onClick)) trace ("error during unbind() of onClick() from click-event-source.");
	 */
	public function unbind (?listener:Dynamic=null) : Bool { 
		var match:Bool = false;
		if (listener == null) {
			_listenerArray = []; match = true;
		} else {
			for ( o in _listenerArray ) {
				if (Reflect.compareMethods(listener,o.listener)) {
					_listenerArray.remove(o);
					unbind (listener);
					match = true;
					break;
				}
			}
		}
		return match ;
	}	
	/**
	 * Dispatches an event to listeners.
	 * <br/><b>e:</b> Event parameters object to be transfered to listeners.
	 */
	public function dispatch(e:StandardEvent) : Dynamic {		
		var ret:Dynamic=null;
		if (e.target == null) e.target = this;
		for ( o in _listenerArray ) {
			e.data = o.data;
			ret=o.listener(e);
		}
		return ret;
	}
	/**
	 * <b>returns true</b> if at least one listener exists.
	 */
    public function  hasListener () : Bool {	
		return (_listenerArray.length != 0);
	}
	public function getLength(): Int { 
		return _listenerArray.length ;
	}
	
}
 