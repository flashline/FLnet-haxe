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
import net.flash_line.util.Object;
/**
 * Events manager package.
 * 
 * Used to send to listeners, datas from EventSource and from class which has called EventSource.bind(), 
 *<br/>super class for other events 
 *<br/>implements dynamic but it's better to extend StandardEvent and add static properties.
 */
class StandardEvent implements Dynamic {
	public static inline  var CLICK : String = "click";
	public static inline  var DBL_CLICK : String = "dblclick";
	public static inline  var MOUSE_DOWN : String = "mousedown";
	public static inline  var MOUSE_MOVE : String = "mousemove";
	public static inline  var MOUSE_OUT : String = "mouseout";
	public static inline  var MOUSE_OVER : String = "mouseover";
	public static inline  var MOUSE_UP : String = "mouseup";
	public static inline  var MOUSE_WHEEL : String = "mousewheel";
	/**
	 * <b> data:</b> Used to store -facultatives- parameters sent by bind()'s caller to the listener method.
	 */
	public var data:Dynamic;
	/**
	 * <b> target:</b> EventSource instance.
	 */
	public var target:Dynamic;
	/**
	 * <b> type:</b> Type of event - change, finish, loadData, errorLoadData, etc.
	 */
	public var type:String;
	/**
	 * <b> message:</b> A simple message from event source.
	 */
	public var message:String;
	/**
	 * Constructor
	 * <br/><b>target:</b> Event source dispatcher.
	 * <br/><b>type:</b> Type of event - change, finish, loadData, errorLoadData, etc.
	 * <br/><b>message:</b>A simple message from event source.
	 */
    public function new (target:Dynamic, ?type:String = "event", ?message:String ="") {
		this.target = target;
		this.type = type;
		this.message = message;
	}
	
	
}
 