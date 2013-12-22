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
import haxe.Log;
import js.Browser;
import js.html.Element;
import js.html.Node;
import js.Lib;
import haxe.PosInfos;

/**
 * Util package
 * 
 * Contains all-purpose methods -level 0.
 * <br/>Super class of many app classes.
 */
class ApiCommon {
	static public inline var STD_ERROR_MSG:String = "fl.net error. See last message above." ;
	static public inline var RED_IN_PAGE_ERROR_MSG:String = "fl.net error. See red message in page." ;
	static public inline var IN_PAGE_ERROR_MSG:String = "fl.net error. See message in page." ;
	//
	static public var alertFunction:Dynamic ;		
	//static public var debugIsSet:Bool = false ;
	/**
	 * <br/><b>v</b> dynamic value.
	 * <br/><b>return</b> true or false.
	 */
	public function boolVal(b:Dynamic,?defVal:Bool=false) :Bool {
		if (b==null) return defVal ;
		if (Std.is(b,String)) {
			if 		(b=="true" ) return true;
			else if (b=="false") return false;				
			else  				return defVal ;
		} else if (Std.is(b,Float)  ) {
			if 		(b==0) 		return false ;
			else if (b==1) 		return true ;
			else  				return defVal ;
		} else if (Std.is(b,Bool) ) return b ;
		return defVal;
	}
	/**
	 * <br/><b>v</b> dynamic value.
	 * <br/><b>return</b> a string.
	 */
	public function strVal(s:Dynamic,?defVal:String="") :String {	
		if (s==null) return defVal ;
		if (s=="") return defVal;
		return s;
	}
	public function numVal(n:Dynamic,?defVal:Float=0) : Float {
		if (n=="0") return Std.parseFloat("0"); 
		if (n==null) return defVal ;
		if (Math.isNaN(n)) return defVal ;
		if (n == "") return defVal ; 
		if (Std.is(n,String)) return Std.parseFloat(n); 
		return Math.pow(n,1) ;
	}
	public function intVal(n:Dynamic,?defVal:Int=0) : Int {
		if (n=="0") return Std.parseInt("0"); 
		if (n==null) return defVal ;
		if (Math.isNaN(n)) return defVal ;
		if (n == "") return defVal ; 
		if (Std.is(n,String)) return Std.parseInt(n); 
		return n ;
	}
	/**
	 * <br/><b>string</b> A string.
	 * <br/><b>return</b> true if string is empty ; or false.
	 */
	public function empty ( v : Dynamic) : Bool {
		if (v == null) return true;
		if (v.length == 0) return true ;
		return false;
	}
	/**
	 * Call js confirm()
	 * <br/><b>v</b> Message.
	 * <br/><b>return</b> true if user confirm ; or false.
	 */
	public function confirm ( v : Dynamic ) : Bool {
		return untyped __js__("confirm")(js.Boot.__string_rec(v,""));
	}
	/**
	 * Call js alert()
	 * <br/><b>v</b> Message.
	 */
	public function alert( v : Dynamic,?cb:Dynamic,?title ) : Void {
		if (ApiCommon.alertFunction != null) ApiCommon.alertFunction(v,cb,title);
		else {
			if (strVal(title,"") != "") v = title + "\n"+v ;
			untyped __js__("alert")(js.Boot.__string_rec(v, ""));
			if (cb!=null) cb();
		}
	}
	/*
		public function prompt ( v : Dynamic,?str:Dynamic="" ) : String {
		return untyped __js__("prompt")(js.Boot.__string_rec(v,""),js.Boot.__string_rec(str,""));
	}*/
	/**
	 * Call js prompt()
	 * <br/><b>v</b> Message.
	 * <br/><b>def</b> By default value.
	 * <br/><b>return</b> true if user confirm or false.
	 */
	public function prompt ( v : String,?def:String="" ) : String {
		return untyped __js__("prompt")(v,def);
	}	
	/**
	* return string <b>str</b> where <b>from</b> is replaced by <b>to</b> .
	*/
	public function strReplace (str:String,from:String,to:String ) :String {
		var reg = untyped __js__ ("new RegExp('('+from+')', 'g');");
		str = untyped __js__ ("str.replace(reg,to);");
		return str;
	}
	/**
	* return string in <b>str</b> between  <b>before</b> and <b>after</b>.
	*/
	public function strBetween (str:String,before:String,after:String ) :String {
		var  ret = ""; var l = 0; var p = 0;
		p = str.indexOf(before);
		if (p != -1) {
			p += before.length;
			l = str.indexOf(after, p);
			if (l == -1) ret = str.substr(p);
			else {
				l -= p ;	
				ret = str.substr(p, l);
			}
		}
		return ret;
	}
	/**
	 * remove debug trace
	 * <br/>
	 */
	public function removeTrace ()  {
		var el:Element;
		el = Browser.document.getElementById("flnet:error");
		if (el != null) el.id = "";		
		el = Browser.document.getElementById("flnet:info");
		if (el != null) el.id = "";		
		//el = Browser.document.getElementById("haxe:trace");
		//if (el != null) el.id = "";
		
	}	
	
	/**
	 * remove debug trace
	 * <br/>
	 */
	public function setupTrace (?ctnrId:String) :Bool  {
		var ctnr:Element;
		if (empty(ctnrId)) ctnr = cast(Browser.document.getElementsByTagName("body")[0], Element);
		else ctnr = Browser.document.getElementById(ctnrId) ;
		if (ctnr!=null) {
			if (Browser.document.getElementById("flnet:error") == null){
				ctnr.innerHTML += "<div id='flnet:error' style='font-weight:bold;color:#900;' ></div>";			
			}
			if (Browser.document.getElementById("flnet:info") == null){
				ctnr.innerHTML += "<div id='flnet:info' style='font-weight:bold;' ></div>";			
			}
			//if (Browser.document.getElementById("haxe:haxe") == null){
				//ctnr.innerHTML += "<div id='haxe:haxe' style='font-weight:bold;' ></div>";			
			//}
			Log.trace = ApiCommon.flnetTrace;
		} else return false;
		return true;
	}		
	static function flnetTrace ( v : Dynamic, ?i : PosInfos ) {
		var str = Std.string(v) ; var len = str.length; 
		if (len > 2 && str.substr(1, 2) == "::" ) {			
			if (str.substr(0,1) == "e" || str.substr(0,1) == "f" ) {
				var d = Browser.document.getElementById("flnet:error");
				if ( d != null )	{
					str = "<br/>error " + ( if ( i != null ) "in " + i.fileName + " line " + i.lineNumber else "") + " : " + str.substr(3, len - 3) + "<br/>" ; 			
					d.innerHTML += str + "<br/>";		
					throw ApiCommon.RED_IN_PAGE_ERROR_MSG;
				} else {
					if (str.substr(0, 1) == "f" )	 {	
						var msg="";
						v = str.substr(3, len - 3);		
						if (Browser.document.getElementById("haxe:trace") != null) msg = ApiCommon.IN_PAGE_ERROR_MSG;
						else msg = ApiCommon.STD_ERROR_MSG;
						untyped js.Boot.__trace(v, i);
						throw msg;	
					}
				}
			} else if (str.substr(0, 1) == "i") {			
				str = "<br/>notice in "+( if( i != null ) i.fileName+":"+i.lineNumber else "")+"<br/>"+str.substr(3, len-3)  ;
				var d = Browser.document.getElementById("flnet:info");
				if ( d != null )	d.innerHTML += str + "<br/>";	
			}
		} else untyped js.Boot.__trace(v,i);
	}
	public function decodeXmlReserved(str:String) :String {
		str = strVal(str, "");
		if (str!="") {
			var i:Int=str.indexOf("~#e") ;
			while (i>-1) {
				str=str.substr(0,i)+"&"+str.substr(i+3);
				i=str.indexOf("~#e") ;
			}
			i=str.indexOf("~#{") ;
			while (i>-1) {
				str=str.substr(0,i)+"<"+str.substr(i+3);
				i=str.indexOf("~#{") ;
			}
			i=str.indexOf("~#}") ;
			while (i>-1) {
				str=str.substr(0,i)+">"+str.substr(i+3);
				i=str.indexOf("~#}") ;
			}
		}
		return str ;
	}
	
	/**
	* return true if year is leap year
	* <br/><b>n</b> a year as 9999
	*/
	public function isBissextile(n:Int) :Bool{
		return (new Date(n,1,29,0,0,0).getDay() != new Date(n,2,1,0,0,0).getDay());
	}
	
}
 