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
import js.Browser;
import js.html.Node;
import js.html.Element;
/**
 * Util package
 * 
 * Contains all-purpose methods -level 0.
 * <br/>Super class of many app classes.
 */
class Common extends ApiCommon {
	public var isWindowsPhone(get, null):Bool;
	public var isMobile(get, null):Bool;	
	public var isWebKit(get, null):Bool;	
	public var rootHtmlElement(default,default):Element;
	//
	public function elem(v:String,?parent:Element) : Element {	 
		var el:Element;
		if (rootHtmlElement == null) rootHtmlElement = Browser.document.body;
		if (parent == null) parent = rootHtmlElement;
		el = Browser.document.getElementById(v);
		if (el==null) {
			trace("f::Element's id: " + v + " doesn't exist !");
		}
		if (!parent.contains(el)) {
			trace("f::Element's id: " + v + " is not only in parent : tag=" + parent.tagName+"/class="+parent.className+"/id="+parent.id);
		} 
		return el;
		
	}
	public function elemBy(v:String,?parent:Element) : Element {	 
		var el:Element;
		if (rootHtmlElement == null) rootHtmlElement = Browser.document.body;			
		if (parent == null) parent =  rootHtmlElement;
		el = cast(parent.getElementsByClassName(v)[0], Element) ;	
		if (el==null) {
			trace("f::Element's id: " + v + " doesn't exist !");
		}
		return el;
	}
	
	
	/**
	 * <b>return</b> an rgb() format
	 * <br/><b>v</b> a #hexa format
	 * <br/><b>see</b> net.flash_line.util.GetColor.
	 */
	public function toRgb(v:String) :String {	 
		return GetColor.toRgb(v);
	}
	/**
	 * <b>return</b> an #hexa format
	 * <br/><b>v</b> an rgb() format
	 * <br/><b>see</b> net.flash_line.util.GetColor.
	 */
	public function toHexa(v:String) :String {	 
		return GetColor.toHexa(v);
	}
	public function mailIsValid (v:String) : Bool {
		var r:EReg = ~/[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?/i;
		return r.match(v);		
    }

	/**
	* return pagename without previous paths nor last dot & extension
	* <br/><b>i.e.</b> "_JS-HTML-CSS/haxe/toTestNewClass/test/bin/dynUpdate/boxes.aa.html" becomes "boxes.aa"
	*/
	public function pagename() :String {
		var arr= Browser.window.location.pathname.split("/") ;
		var str:String = arr[arr.length - 1];
		str = str.substr(0, str.lastIndexOf("."));
		if (str == "") str = "index" ;
		return str ;
	}
	/**
	* page url path
	*/
	public function pageUrlPath() :String {
		var str:String = Browser.window.location.href ;
		var p = str.lastIndexOf("/");
		if (p > -1) return str.substr(0, p + 1 );
		return "";
	}
	public function Html5IsValid(?v:String):Bool {
		return false;
	}
	
	
	//
	function get_isMobile() :Bool {
		return new EReg("iPhone|iPod|Android|opera mini|blackberry|palm os|palm|hiptop|avantgo|plucker|xiino|blazer|elaine|iris|3g_t|opera mobi|windows phone|iemobile".toLowerCase(),"i").match(Browser.navigator.userAgent.toLowerCase());
	}
	function get_isWebKit() :Bool {
		return new EReg("webkit|chrome|safari".toLowerCase(),"i").match(Browser.navigator.userAgent.toLowerCase());
	}
	function get_isWindowsPhone() :Bool {
		return new EReg("windows phone|iemobile".toLowerCase(),"i").match(Browser.navigator.userAgent.toLowerCase());
	}
		
}
 