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
package net.flash_line.display ;
import js.Browser;
import js.html.Element;
import js.html.Event;
import js.html.EventListener;
import js.html.EventTarget;
import js.html.InputElement;
import js.html.TextAreaElement;
import net.flash_line._api.math.Vector;
import net.flash_line.event.StandardEvent;
import net.flash_line.util.Common;
/**
 * extends js.html.Element usage in caller : import js.html.Element; import net.flash_line.display.ElementExtender ; using net.flash_line.display.ElementExtender;
 */
typedef ElemBoundInfo = {
    var x : Float;
    var y : Float;
    var left : Float;
    var right: Float;
	var top: Float;
	var bottom: Float;
	var width: Float;
	var height: Float;
	
}
class ElementExtender  {
	static var listeners:Array<Dynamic>=[];
	//
	//
	public static function elemBy (el:Element, v:String):Element {
		if (el.getElementsByClassName(v)[0] == null) trace("f:: class '" + v + "' doesn't exist in element with id '"+el.id+"'");
		return cast(el.getElementsByClassName(v)[0], Element) ;
	}
	public static function elemByTag (el:Element, v:String):Element {
		if (el.getElementsByTagName(v)[0] == null) trace("f:: tag '" + v + "' doesn't exist in element with id '"+el.id+"'");
		return cast(el.getElementsByTagName(v)[0], Element)  ;
	}
	/* KEEP... THEN TODO in haxe
	public function elemByAtt(oElm, strTagName, strAttributeName, strAttributeValue){
		var arrElements = (strTagName == "*" && oElm.all)? oElm.all : oElm.getElementsByTagName(strTagName);
		var arrReturnElements = new Array();
		var oAttributeValue = (typeof strAttributeValue != "undefined")? new RegExp("(^|\\s)" + strAttributeValue + "(\\s|$)", "i") : null;
		var oCurrent;
		var oAttribute;
		for(var i=0; i<arrElements.length; i++){
			oCurrent = arrElements[i];
			oAttribute = oCurrent.getAttribute && oCurrent.getAttribute(strAttributeName);
			if(typeof oAttribute == "string" && oAttribute.length > 0){
				if(typeof strAttributeValue == "undefined" || (oAttributeValue && oAttributeValue.test(oAttribute))){
					arrReturnElements.push(oCurrent);
				}
			}
		}
		return arrReturnElements;
	}
	*/
	public static function child (el:Element, v:String):Element {
		var ret:Element = null; var child:Element=null;
		for (i in el.children) {
			child = cast(i, Element);			
			if (child.id == v) {
				ret = child;
				break;
			}
		}
		if (ret == null) trace("f:: child with id '" + v + "' doesn't exist in element with id '"+el.id+"'");		
		return ret ;
	}
	public static function childByName (el:Element, v:String):InputElement {
		var ret = null;
		var child=null;
		for (i in el.children) {	
			if (Std.is(i, InputElement) || (Std.is(i,TextAreaElement) ) ) {
				child = i;	
				if ((untyped child).name == v) {
					ret = child;
					break;
				}
			}
		}
		if (ret == null) trace("f:: InputElement child with name '" + v + "' doesn't exist in element with id '"+el.id+"'");		
		return untyped ret ;
	}
	public static function clone (el:Element, ?b:Bool=true):Element {
		return cast( el.cloneNode(b), Element);
	}
	public static function positionInWindow(el:Element) {		
		var v = new Vector(0, 0);
		do {
			v.x += el.offsetLeft-el.scrollLeft;
			v.y += el.offsetTop-el.scrollTop;
			el = el.offsetParent;
		} while ( el!=null );
		return v;
	} 
	public static function getBoundInfo(el:Element) : ElemBoundInfo{
		var r = el.getBoundingClientRect();
		var ebi:ElemBoundInfo = {  x:null, y:null, left:null, right:null, top:null, bottom:null, width:null, height:null };		
		var v = positionInWindow(el);
		ebi.x = v.x;
		ebi.y = v.y;
		ebi.left = r.left;
		ebi.right = r.right;
		ebi.top = r.top;
		ebi.bottom = r.bottom;
		ebi.width = r.width;
		ebi.height = r.height;
		return ebi;
	}
	public static function handCursor(ev:EventTarget, ?v:Bool = true)  { 
		if (Std.is(ev, Element)) {
			var el = cast(ev, Element);
			var str;
			if (v) str = "pointer" ; else str = "auto" ;
			el.style.cursor = str ;
		}
	}
	public static function setReadOnly (el:Element, ?b:Bool = true)  { 			
		if (!(Std.is(el, InputElement) || Std.is(el, TextAreaElement))) (untyped el).readOnly=b ;
		else (untyped el).disabled= b;
	}
	public static function setVisible(el:Element, ?b:Bool = true)  { 
		var v = "visible";
		if (!b) v = "hidden";
		el.style.visibility = v;
	}
	public static function show(el:Element)  { 
		el.style.display = strVal(el.getAttribute("data-flnet-display"), "inline") ;	
	}
	public static function hide(el:Element)  { 
		el.style.display = "none" ;
	}
	public static function setColor(el:Element, ?v:String = "#000")  { 
		el.style.color = v;
	}	
	/**
	 * remove all children 
	 */
    public static function  removeChildren (el:Element) {	
		if ( el.hasChildNodes() ) {
			while ( el.childNodes.length >0 ) {	
				el.removeChild( el.firstChild );   
			}
		}
	}
	/**
	 * remove element -used when native js remove() doesn't work !
	 */
    public static function  delete (el:Element) {	
		if ( el.parentNode!=null ) {
			el.parentNode.removeChild( el );   
		}
	}
	/**
	 * set value or innerHtml
	 */
    public static function  setText (e:Element, ?v:String = "") {	
		var el:Dynamic = e;
		if (Std.is(el, InputElement) || Std.is(el, TextAreaElement)) el.value = v;
		else if (Std.is(el, Element)) el.innerHTML = v;
	}	
	/**
	 * get value or innerHtml
	 */
    public static function  getText (e:Element) : Null<String> {	
		var el:Dynamic = e; var v:String=null;
		if (Std.is(el, InputElement) || Std.is(el, TextAreaElement)) v = el.value;
		else if (Std.is(el, Element)) v = el.innerHTML ;
		return v;
	}	
	/**
	 * set rotatation axis
	 */
    public static function  setRotationAxis (e:Element, v:String) {	
		var el:Dynamic = untyped e;
		el.style.webkitTransformOrigin=v;
		el.style.mozTransformOrigin=v;
		el.style.msTransformOrigin=v;
		el.style.oTransformOrigin=v;		
		el.style.khtmlTransformOrigin = v;
		el.style.transformOrigin=v;
	}	
	/**
	 * change rotation
	 */
    public static function  setRotation (e:Element, v:Float) {	
		var el:Dynamic = untyped e;
		var r = Std.string(v);
		el.style.webkitTransform = "rotate(" + r + "deg)" ;
		el.style.mozTransform = "rotate(" + r + "deg)" ;
		el.style.msTransform = "rotate(" + r + "deg)" ;
		el.style.oTransform = "rotate(" + r + "deg)" ;		
		el.style.khtmlTransform = "rotate(" + r + "deg)" ;
		el.style.transform = "rotate(" + r + "deg)" ;		
	}	
	/**
	 * used for loop rotation+=n
	 */
    public static function  rotate (el:Element, v:Float) {	
		var r:Float = untyped el.rotation;
		if (r == null) {
			r = 0.0;
			(untyped el).rotation = 0.0 ;
		}
		v += (untyped el).rotation;
		setRotation (el, v);
		(untyped el).rotation = v;
	}	
	/**
	 * involve enter key (hexa OD) to elem's click event
	 * el MUST BE visible and MUST NOT BE display:"none"
	 */
	public static function  joinEnterKeyToClick (el:Element, ?buttonArray:Array<Element> , ?focusElem:Element) {	
		var activeEl:Element = null;
		if (focusElem != null) focusElem.focus();		
		else el.focus();
		if (buttonArray == null) buttonArray = [];
		buttonArray.push(el);
		Browser.window.onkeypress = function (e) { 
			if (untyped e.keyCode == 13) { 	
				//trace("i::active=" + Browser.document.activeElement.id);
				for (button in buttonArray) {
					if (button==Browser.document.activeElement) {
						activeEl = Browser.document.activeElement;
					}
				}
				if (activeEl==null) {
					var evt  = new Event(StandardEvent.CLICK);
					el.dispatchEvent(evt);
				}
			}
		} ;
	}	
	public static function  clearEnterKeyToClick (el:Element) {	
		Browser.window.onkeypress = null ;
	}	
	/*
	 * 
		*/
	/**
	 * call examples :
	 *    view.connection.addLst("click",onClick,false,{param1:"param11",param2:"param12"} ); 
	 *	  view.connection.removeLst("click", onClick, false );
	 * 	  if no parameters needs to be sent, original listener is used ; else a delegate listener is used.
	 * @param	srcEvt
	 * @param	type
	 * @param	listenerFunction
	 * @param	?b
	 * @param	?data
	 */
	public static function addLst(srcEvt:EventTarget, type:String, listenerFunction:Dynamic, ?b:Bool = false, ?data:Dynamic = null) {
		var el:Dynamic;
		if (Std.is(srcEvt, Element) && type == "click" ) handCursor(srcEvt);			
		var deleguateFunction:EventListener = getLst(srcEvt, listenerFunction, data);
		el = untyped srcEvt; if (el.listeners == null) el.listeners = [];
		el.listeners.push( {type:type, listenerFunction:listenerFunction, deleguateFunction:deleguateFunction } );		
		srcEvt.addEventListener(type, deleguateFunction, b );
	}
	public static function removeLst(srcEvt:EventTarget, type:String, listenerFunction:Dynamic, ?b:Bool = false)  {			
		if (Std.is(srcEvt,Element) && type=="click" ) handCursor(srcEvt,false);
		if ( !removeDelegateListener(srcEvt, type, listenerFunction, b) ) {
			// normally no possible
			srcEvt.removeEventListener(type, listenerFunction, b);
		}
	}	
	/**
	 * <b>returns true</b> if at least one listener exists.
	 */
    public static function  hasLst (srcEvt:EventTarget, type:String, ?listenerFunction:Dynamic=null) : Bool {	
		var el:Dynamic = untyped srcEvt;
		var ret:Bool = false;
		if (el.listeners != null) {
			var len = el.listeners.length;
			for (n in 0...len) {
				var i = el.listeners[n];				
				if (i.type == type) {											
					if (listenerFunction == null) ret = true;
					else if (Reflect.compareMethods(i.listenerFunction,listenerFunction) ) ret = true; 
					if (ret) break;
				}
			}	
		}
		return ret;
	}
	/**
	 * @private
	 */
	static function removeDelegateListener(srcEvt:Dynamic, type:String, listenerFunction:Dynamic, ?b:Bool = false) :Bool {
		var match = false;
		var el:Dynamic = untyped srcEvt;
		if (el.listeners!=null) {
			var len = el.listeners.length;
			for (n in 0...len) {
				var i = el.listeners[n];
				if (Reflect.compareMethods(i.listenerFunction,listenerFunction) ) { 
					if (i.type == type) {							
						if (i.deleguateFunction != null) {
							srcEvt.removeEventListener(type, i.deleguateFunction, b);
						}
						el.listeners.splice(n, 1);
						//removeDelegateListener(srcEvt, type, listenerFunction, b);
						match = true;
						break;
					}
				}
			}
		}
		return match;
	}		
	static function getLst(srcEvt,listenerFunction:Dynamic,?data:Dynamic) : EventListener {
		var deleguateFunction:EventListener;
		if (data == null) deleguateFunction = listenerFunction;
		else {			
			deleguateFunction = function (e:Event) { listenerFunction.call(srcEvt, e, data) ;  } ;				
		}
		return deleguateFunction ;
	}
	static function strVal(s:Dynamic,?defVal:String="") :String {	
		if (s==null) return defVal ;
		if (s=="") return defVal;
		return s;
	}
}
 