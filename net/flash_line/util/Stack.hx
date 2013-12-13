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
package net.flash_line.util ;
class Stack<T> extends ApiCommon  {
	public var array(default,null):Array<T>;
	public var length(get_length, null):Int;
	//
    public function new(?a:Array<T>) {
		if (a == null) a = new Array();
		array = a;	
		
	}
	public function last():T {
		if (length < 1) return null;
		else return array[length-1];
	}
	public function push(o:T) {
		array.push(o);
	}
	public function pop() : T{
		return array.pop();
	}
	public function sort(f:Dynamic) {
		return array.sort(f);
	}
	/**
	* If Array contains Dynamic instance with a  property prop  then return the object with the prop value == val + its index
	* @param prop 	property.
	* @param val 	value of property
	* @return the first object of Array which has its property prop equal to val + its index
	*/
	public function objectOf (key:String,val:Dynamic) :Dynamic {
		if (length == 0) { trace("f::Stack is empty !!");  }
		if (!(Reflect.hasField(array[0], key))) { trace("f::search key must exists in stack's objects ! ") ;  }
		for (i in 0...length) {			
			var o:Dynamic = array[i]; 
			if (val == Reflect.field(o, key)) return {idx:i,obj:array[i]} ;
		}
		return {idx:null,obj:null};
	}
	
	
	/**
	* pop array and exec clear() method of each element 
	* <br/>	f : Function to be launched instead of clear()
	*/		
	public function clear(?f:String) : Dynamic {	
		var o:Dynamic;
		while ( o = array.pop() ) {
			if (f == null) {
				if (o.clear != null) o.clear(); 
			} else {
				Reflect.field(o, f)();
			}
		}	
		return null ;
	}
	function get_length () : Int {
		return array.length;
	}
	/**
		Returns an iterator of the Array values.
	**/
	function iterator() : Iterator<T>;
}
	

	