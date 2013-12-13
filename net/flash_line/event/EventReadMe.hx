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
	* <br/>Events dispatch doc.
	*<br/>The event(s) source class must :
	* 
	*	Have these imports :
	*<br/>		import net.flash_line.event.EventSource ;
	*<br/>   	import net.flash_line.event.StandardEvent; // or other custom class which extends StandardEvent.
	* 
	*	Declare a property BY event type, for <EventSource's instance> . Example :
	*<br/>		//Event dispatcher on finish.
	*<br/>		public var finish:EventSource; 
	*<br/>		//Event dispatcher on change.
	*<br/>		public var change:EventSource; 
	* 
	* 	Have new EventSource() instanciation/assignation, in constructor or before other classes bind to it.
	* 
	*	Dispatch event(s) like : 
	*<br/>    	<EventSource's instance>.dispatch(<StandardEvent instance>) ;
	*<br/>    	Examples :
	*<br/>			finish.dispatch(new StandardEvent(this));
	*<br/>			// or
	*<br/>			var e:MyMotionEvent; // MyMotionEvent is an example which extends StandardEvent.
	*<br/>			e.target = this;
	*<br/>			e.type = "finish";
	*<br/>			e.message = "The End";
	*<br/>			e.time = a_time_value ; // specific to MyMotionEvent 
	*<br/>			e.dynamicVarFromEventSrc = "hello" ; // not recommended but nice sometime ;)
	*<br/>			finish.dispatch(e);
	*
	* usage :
	*<br/>	in class which contains -generally- the listener(s) :
	*<br/>		<event source container>.<EventSource's instance by event-type>.bind(<listener> [,{ key:value, key:value , etc } ] );
	*<br/>		// example:
	*<br/>		new MyEventSourceClass().finish.bind(onFinish);
	*<br/>		new MyEventSourceClass().finish.bind(onFinish , {key1:val1,key2:val2} );
	*<br/>		// [...]
	*<br/>		<event source container>.<EventSource's instance by event-type>.unbind(<listener>);
	*<br/>  	// [...]
	*<br/>		function <listener>(e:StandardEvent) {
	*<br/>			trace(e.data.key<1> + " " + e.data.key<2>);
	*<br/>			trace(cast(e.target,<event source container>.a_public_var);
	*<br/>			trace(e.type);
	*<br/>			trace(e.message);
	*<br/>			trace(e.dynamicVarFromEventSrc);	* 			
	*<br/>		}
	*/
class EventReadMe {}
 