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
class Object implements Dynamic {
	
	//
    public function new (?o:Dynamic=null ) {
		if (o != null) {
			var arr:Array<String> = Reflect.fields(o);
			for (i in 0...arr.length) {
				var v:Dynamic = Reflect.field(o, arr[i]);
				set(arr[i], v);
			}
		}
	}
	public function set(k:String,?v:Dynamic=null) {
		Reflect.setField( this,k, v);
	}
	public function get(k:String) : Dynamic {
		return Reflect.field(this, k );
	}
	public function remove(k:String) : Void {
		 Reflect.deleteField(this, k );
	}
	
	public function array() : Array<String> {
		return Reflect.fields(this);
	}
	public function length() : Int {
		return Reflect.fields(this).length;
	}
	public function toDynamic() : Dynamic {
		var d:Dynamic = {};
		for (i in 0...array().length) {
			var k:String = array()[i];
			var v:Dynamic = get(k);
			Reflect.setField( d,k, v);
		}
		return d;
	}	
	public function toHtmlString(?tab:String="") : String {
		var str:String = tab+"{<br/>"; var tabType = "&nbsp;&nbsp;&nbsp;&nbsp; "; 
		var len:Int = array().length;
		for (i in 0...len) {
			var k:String = array()[i];
			var v:Dynamic = get(k);
			str += tab + k + ":" ;
			if (Std.is(v, Object)) str += "<br/>"+v.toHtmlString(tab + tabType);
			else str += '"'+v+'"';
			if (i < len - 1) str += ",<br/>";
			else str += "<br/>";
		}
		str += tab+"}<br/>";
		return str;
	}	
	public function toString(?tab:String="") : String {
		var str:String = tab+"{\n"; var tabType = "\t\t"; 
		var len:Int = array().length;
		for (i in 0...len) {
			var k:String = array()[i];
			var v:Dynamic = get(k);
			str += tab + k + ":" ;
			if (Std.is(v, Object)) str += "\n"+v.toString(tab + tabType);
			else str += '"'+v+'"';
			if (i < len - 1) str += ",\n";
			else str += "\n";
		}
		str += tab+"}\n";
		return str;
	}	
	
}
	